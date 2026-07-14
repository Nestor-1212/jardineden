// ─────────────────────────────────────────────────────────────────────────────
// core/audit/audit_logger_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de AuditLogger. Persiste cada entrada como una línea
//   JSON (formato JSONL/NDJSON) en un archivo append-only vía FileService,
//   y además la espeja en AppLogger (module = LogModules.audit) para que
//   sea visible en el flujo normal de observabilidad durante desarrollo.
//
// FORMATO JSONL:
//   Una línea = un AuditEntry serializado. Permite agregar entradas con
//   una sola escritura O(1) (FileService.appendAsString) sin parsear el
//   archivo completo, y facilita exportarlo/inspeccionarlo línea por línea.
//
// UBICACIÓN DEL ARCHIVO:
//   documents/audit_log.jsonl — junto al archivo de la base de datos,
//   mismo directorio que usa BackupService para sus respaldos.
//
// DEPENDENCIAS PERMITIDAS:   dart:convert, core/audit/ (contrato, AuditEntry),
//                            core/file/ (FileService), core/logging/
//                            (AppLogger, LogModules).
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';

import 'package:jardindeleden/core/audit/audit_entry.dart';
import 'package:jardindeleden/core/audit/audit_logger.dart';
import 'package:jardindeleden/core/file/file_service.dart';
import 'package:jardindeleden/core/logging/app_logger.dart';
import 'package:jardindeleden/core/logging/log_modules.dart';

/// Implementación de [AuditLogger] con persistencia JSONL vía [FileService].
final class AuditLoggerImpl implements AuditLogger {
  AuditLoggerImpl({required FileService fileService, required AppLogger logger})
      : _fileService = fileService,
        _logger = logger;

  final FileService _fileService;
  final AppLogger _logger;

  static const String _fileName = 'audit_log.jsonl';

  Future<String> _filePath() async {
    final dir = await _fileService.resolveDirectoryPath(AppDirectory.documents);
    return _fileService.joinPath([dir, _fileName]);
  }

  @override
  Future<void> record({
    required AuditAction action,
    required String actorAnonymousId,
    String? target,
    Map<String, Object?>? metadata,
  }) async {
    final entry = AuditEntry(
      timestamp: DateTime.now(),
      action: action,
      actorAnonymousId: actorAnonymousId,
      target: target,
      metadata: metadata ?? const {},
    );

    final path = await _filePath();
    await _fileService.appendAsString(path, '${jsonEncode(entry.toJson())}\n');

    _logger.info(
      'audit_${action.name}',
      module: LogModules.audit,
      metadata: {
        'actor': actorAnonymousId,
        'target': ?target,
        ...entry.metadata,
      },
    );
  }

  @override
  Future<List<AuditEntry>> readAll() async {
    final path = await _filePath();
    if (!await _fileService.fileExists(path)) return const [];

    final content = await _fileService.readAsString(path);
    final entries = content
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) => AuditEntry.fromJson(
              jsonDecode(line) as Map<String, Object?>,
            ))
        .toList();

    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  @override
  Future<void> clear() async {
    final path = await _filePath();
    await _fileService.deleteFile(path);
  }
}
