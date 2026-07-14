// ─────────────────────────────────────────────────────────────────────────────
// core/backup/backup_service.dart
//
// RESPONSABILIDAD:
//   Gestiona el sistema de backup automático y la recuperación de datos.
//   Es la red de seguridad que protege el progreso del jugador.
//
// TIPOS DE BACKUP:
//   1. Backup de Sesión: cada 4 horas / inicio de sesión
//   2. Backup de Hito: al completar un mundo, al obtener ítem Ónix/Gloria,
//      cada 10 versículos "Grabado en el Corazón"
//   3. Backup Pre-Migración: antes de cada migración de esquema
//   4. Backup Semanal: domingos, cuando el dispositivo está cargando
//
// POLÍTICA DE RETENCIÓN:
//   • 3 backups de sesión más recientes
//   • 5 backups de hito más recientes
//   • El último backup pre-migración
//   • 4 backups semanales más recientes
//
// UBICACIÓN:
//   Los backups se guardan en getApplicationDocumentsDirectory()/backups/
//   con nombres en formato: backup_[tipo]_[timestamp].db.bak
//
// PROCESO DE RESTAURACIÓN:
//   1. Verificar integridad del archivo de backup (SHA-256)
//   2. Copiar el backup sobre el archivo de base de datos activo
//   3. Verificar que la copia fue exitosa
//   4. Reabrir la conexión de Drift con el archivo restaurado
//
// DEPENDENCIAS PERMITIDAS:   dart:io, dart:core, core/security/
// DEPENDENCIAS PROHIBIDAS:   features, shared/ui, flutter/widgets
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core (Backup)
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del servicio de backup y restauración de datos.
abstract interface class BackupService {
  // ── Creación de Backups ───────────────────────────────────────────────────

  /// Crea un backup de tipo 'session'. Máximo 3 en el sistema.
  Future<void> createSessionBackup();

  /// Crea un backup de tipo 'milestone' (hito de progreso importante).
  /// [milestoneDescription]: descripción del hito para el nombre del archivo.
  Future<void> createMilestoneBackup({required String milestoneDescription});

  /// Crea un backup inmediato antes de aplicar una migración de esquema.
  /// Bloquea la ejecución hasta completarse — la migración espera al backup.
  Future<void> createPreMigrationBackup({required int fromVersion});

  /// Crea el backup semanal del domingo.
  Future<void> createWeeklyBackup();

  // ── Consulta de Backups Disponibles ──────────────────────────────────────

  /// Lista todos los backups disponibles ordenados por fecha (más reciente primero).
  Future<List<BackupInfo>> listAvailableBackups();

  // ── Restauración ─────────────────────────────────────────────────────────

  /// Verifica la integridad de un backup antes de restaurarlo.
  /// Retorna true si el backup es válido y puede restaurarse.
  Future<bool> verifyBackupIntegrity(BackupInfo backup);

  /// Restaura la base de datos desde un backup específico.
  /// La aplicación debe reiniciarse después de la restauración.
  Future<void> restoreFromBackup(BackupInfo backup);

  // ── Limpieza ──────────────────────────────────────────────────────────────

  /// Aplica la política de retención: elimina backups más allá del máximo.
  Future<void> applyRetentionPolicy();
}

/// Metadatos de un archivo de backup.
final class BackupInfo {
  const BackupInfo({
    required this.filePath,
    required this.type,
    required this.createdAt,
    required this.sizeBytes,
    required this.schemaVersion,
    required this.sha256Hash,
  });

  final String filePath;
  final BackupType type;
  final DateTime createdAt;
  final int sizeBytes;
  final int schemaVersion;
  final String sha256Hash;
}

enum BackupType { session, milestone, preMigration, weekly }
