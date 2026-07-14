// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/backup/backup_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de BackupService, configurada con el
//   directorio de documentos de la app y el nombre de archivo de la DB.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   BackupServiceImpl es stateless respecto a la sesión — cada llamada lee
//   el sistema de archivos directamente. Una sola instancia basta.
//
// PROVIDER ASÍNCRONO:
//   getApplicationDocumentsDirectory() es asíncrono (path_provider), por
//   eso este es un FutureProvider. Se consume con `ref.watch(x.future)`.
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, path_provider,
//                            backup_service_impl, core/config/app_config.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/backup/backup_service.dart';
import 'package:jardindeleden/core/backup/backup_service_impl.dart';
import 'package:jardindeleden/core/config/app_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_service_provider.g.dart';

/// Instancia singleton de [BackupService].
///
/// [keepAlive: true] — se usa desde el arranque (backups de sesión) hasta
/// el cierre de la app (no hay motivo para descartarla entre pantallas).
@Riverpod(keepAlive: true)
Future<BackupService> backupService(BackupServiceRef ref) async {
  final documentsDirectory = await getApplicationDocumentsDirectory();

  return BackupServiceImpl(
    documentsDirectory: documentsDirectory,
    databaseFileName: AppConfig.databaseFileName,
    currentSchemaVersion: () => AppConfig.databaseSchemaVersion,
  );
}
