// ─────────────────────────────────────────────────────────────────────────────
// core/backup/backup_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación concreta de BackupService (ver backup_service.dart para
//   el contrato completo y la política de retención documentada).
//
// ESTRATEGIA:
//   Backup por copia de archivo. El archivo de base de datos (ya cifrado
//   con SQLCipher por Drift) se copia bit a bit a la carpeta backups/.
//   No requiere descifrar ni volver a cifrar: el .bak queda protegido con
//   la misma clave AES-256 que el original.
//
// NOMBRE DE ARCHIVO:
//   backup_<tipo>_v<versión-de-esquema>[_<etiqueta>]_<timestamp-utc>.db.bak
//   La versión de esquema se graba en el NOMBRE del archivo (no se lee del
//   contenido cifrado) porque es la única forma barata de saber, sin
//   descifrar, con qué versión de esquema fue creado cada backup — esto
//   importa para decidir si un backup antiguo es compatible al restaurar.
//
// INTEGRIDAD:
//   Cada BackupInfo lleva su hash SHA-256. verifyBackupIntegrity recalcula
//   el hash del archivo y lo compara — detecta backups truncados o
//   corrompidos por fallas de almacenamiento antes de intentar restaurar.
//
// DEPENDENCIAS PERMITIDAS:   dart:io, dart:core, package:path, package:crypto,
//                            core/backup/backup_service.dart (contrato),
//                            core/error/app_exception.dart
// DEPENDENCIAS PROHIBIDAS:   features, shared/ui, flutter/widgets
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:jardindeleden/core/backup/backup_service.dart';
import 'package:jardindeleden/core/error/app_exception.dart';
import 'package:path/path.dart' as p;

/// Implementación de [BackupService] basada en copia de archivos.
final class BackupServiceImpl implements BackupService {
  BackupServiceImpl({
    required Directory documentsDirectory,
    required String databaseFileName,
    required int Function() currentSchemaVersion,
  }) : _documentsDirectory = documentsDirectory,
       _databaseFileName = databaseFileName,
       _currentSchemaVersion = currentSchemaVersion;

  final Directory _documentsDirectory;
  final String _databaseFileName;
  final int Function() _currentSchemaVersion;

  static const int _retentionSession = 3;
  static const int _retentionMilestone = 5;
  static const int _retentionPreMigration = 1;
  static const int _retentionWeekly = 4;

  static const String _backupExtension = '.db.bak';

  Directory get _backupsDir =>
      Directory(p.join(_documentsDirectory.path, 'backups'));

  File get _activeDatabaseFile =>
      File(p.join(_documentsDirectory.path, _databaseFileName));

  // ── Creación de Backups ─────────────────────────────────────────────────

  @override
  Future<void> createSessionBackup() => _createBackup(BackupType.session);

  @override
  Future<void> createMilestoneBackup({required String milestoneDescription}) =>
      _createBackup(BackupType.milestone, label: milestoneDescription);

  @override
  Future<void> createPreMigrationBackup({required int fromVersion}) =>
      _createBackup(BackupType.preMigration, versionOverride: fromVersion);

  @override
  Future<void> createWeeklyBackup() => _createBackup(BackupType.weekly);

  Future<void> _createBackup(
    BackupType type, {
    String? label,
    int? versionOverride,
  }) async {
    // No hay nada que respaldar antes del primer arranque con datos.
    if (!_activeDatabaseFile.existsSync()) return;

    await _backupsDir.create(recursive: true);

    final version = versionOverride ?? _currentSchemaVersion();
    final timestamp = DateTime.now().toUtc().toIso8601String().replaceAll(
      RegExp(r'[:.]'),
      '-',
    );
    final sanitizedLabel = label != null
        ? '_${_sanitizeForFileName(label)}'
        : '';

    final fileName =
        'backup_${type.name}_v$version$sanitizedLabel'
        '_$timestamp$_backupExtension';
    final target = File(p.join(_backupsDir.path, fileName));

    await _activeDatabaseFile.copy(target.path);
    await applyRetentionPolicy();
  }

  String _sanitizeForFileName(String input) =>
      input.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');

  // ── Consulta de Backups Disponibles ──────────────────────────────────────

  @override
  Future<List<BackupInfo>> listAvailableBackups() async {
    if (!_backupsDir.existsSync()) return const [];

    final files = _backupsDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith(_backupExtension))
        .toList();

    final infos = <BackupInfo>[];
    for (final file in files) {
      final type = _typeFromFileName(file.path);
      final version = _versionFromFileName(file.path);
      // Ignora archivos ajenos que hayan terminado en backups/ (defensivo).
      if (type == null || version == null) continue;

      final bytes = await file.readAsBytes();
      infos.add(
        BackupInfo(
          filePath: file.path,
          type: type,
          createdAt: file.statSync().modified,
          sizeBytes: bytes.length,
          schemaVersion: version,
          sha256Hash: sha256.convert(bytes).toString(),
        ),
      );
    }

    infos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return infos;
  }

  BackupType? _typeFromFileName(String path) {
    final name = p.basename(path);
    for (final type in BackupType.values) {
      if (name.startsWith('backup_${type.name}_')) return type;
    }
    return null;
  }

  int? _versionFromFileName(String path) {
    final match = RegExp(r'_v(\d+)_').firstMatch(p.basename(path));
    return match != null ? int.parse(match.group(1)!) : null;
  }

  // ── Restauración ──────────────────────────────────────────────────────────

  @override
  Future<bool> verifyBackupIntegrity(BackupInfo backup) async {
    final file = File(backup.filePath);
    if (!file.existsSync()) return false;

    final bytes = await file.readAsBytes();
    final actualHash = sha256.convert(bytes).toString();
    return actualHash == backup.sha256Hash;
  }

  @override
  Future<void> restoreFromBackup(BackupInfo backup) async {
    final isValid = await verifyBackupIntegrity(backup);
    if (!isValid) {
      throw DatabaseCorruptionException(
        message:
            'El backup ${backup.filePath} falló la verificación SHA-256 '
            'y no puede restaurarse de forma segura.',
      );
    }

    // La app debe reiniciarse después de esto: Drift ya tiene el archivo
    // anterior abierto y no reacciona a que se reemplace bajo sus pies.
    await File(backup.filePath).copy(_activeDatabaseFile.path);
  }

  // ── Limpieza ──────────────────────────────────────────────────────────────

  @override
  Future<void> applyRetentionPolicy() async {
    final all = await listAvailableBackups();

    for (final type in BackupType.values) {
      final ofType = all.where((backup) => backup.type == type).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final limit = switch (type) {
        BackupType.session => _retentionSession,
        BackupType.milestone => _retentionMilestone,
        BackupType.preMigration => _retentionPreMigration,
        BackupType.weekly => _retentionWeekly,
      };

      for (final expired in ofType.skip(limit)) {
        final file = File(expired.filePath);
        if (file.existsSync()) await file.delete();
      }
    }
  }
}
