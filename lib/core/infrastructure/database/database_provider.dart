// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/database/database_provider.dart
//
// RESPONSABILIDAD:
//   Inicializar y proveer la instancia singleton de AppDatabase, componiendo
//   la clave de cifrado (SecurityService), la conexión nativa cifrada
//   (database_connection.dart) y el hook de backup pre-migración
//   (BackupService). Es la única capa que conoce las tres piezas a la vez.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   La conexión a una base de datos SQLite es costosa. Se abre UNA SOLA VEZ
//   al primer acceso y permanece abierta durante toda la sesión del usuario.
//   Se cierra solo cuando el ProviderContainer se destruye (app closes / hot restart).
//
// FLUJO DE INICIALIZACIÓN:
//   1. securityServiceProvider entrega la clave AES-256 (la genera y guarda
//      en Keychain/Keystore en el primer arranque; la lee en los siguientes).
//   2. openEncryptedConnection() abre el NativeDatabase con esa clave.
//   3. Se instancia AppDatabase con la conexión y el callback onBeforeMigrate,
//      que delega en BackupService.createPreMigrationBackup().
//   4. Se registra ref.onDispose(db.close) para limpieza automática.
//
// DEPENDENCIAS:
//   securityServiceProvider → SecurityService (clave de cifrado)
//   backupServiceProvider   → BackupService (backup pre-migración)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, app_database,
//                            database_connection, security_service_provider,
//                            backup_service_provider, app_config.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/config/app_config.dart';
import 'package:jardindeleden/core/infrastructure/backup/backup_service_provider.dart';
import 'package:jardindeleden/core/infrastructure/database/app_database.dart';
import 'package:jardindeleden/core/infrastructure/database/database_connection.dart';
import 'package:jardindeleden/core/infrastructure/security/security_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// Instancia singleton de [AppDatabase] con cifrado AES-256 (SQLCipher).
///
/// [keepAlive: true] — la conexión persiste durante toda la sesión.
/// [FutureProvider] — la clave de cifrado y el directorio de documentos
/// se resuelven de forma asíncrona.
@Riverpod(keepAlive: true)
Future<AppDatabase> appDatabase(AppDatabaseRef ref) async {
  final security = ref.watch(securityServiceProvider);
  final backup = await ref.watch(backupServiceProvider.future);

  final encryptionKey = await security.getDatabaseEncryptionKey();

  final connection = openEncryptedConnection(
    databaseFileName: AppConfig.databaseFileName,
    encryptionKey: encryptionKey,
    encryptionEnabled: AppConfig.databaseEncryptionEnabled,
  );

  final db = AppDatabase(
    connection,
    onBeforeMigrate: (from, to) =>
        backup.createPreMigrationBackup(fromVersion: from),
  );
  ref.onDispose(db.close);

  return db;
}
