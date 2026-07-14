// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/database/database_provider.dart
//
// RESPONSABILIDAD:
//   Inicializar y proveer la instancia singleton de AppDatabase con la clave
//   de cifrado AES-256 obtenida del Keychain/Keystore.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   La conexión a una base de datos SQLite es costosa. Se abre UNA SOLA VEZ
//   al primer acceso y permanece abierta durante toda la sesión del usuario.
//   Se cierra solo cuando el ProviderContainer se destruye (app closes / hot restart).
//
// FLUJO DE INICIALIZACIÓN:
//   1. Lee la clave AES-256 de SecureStorage (Keychain/Keystore del OS).
//   2. Si no existe, genera y almacena una nueva clave (primer arranque).
//   3. Abre AppDatabase con la clave de cifrado.
//   4. Registra ref.onDispose(db.close) para limpieza automática.
//
// DEPENDENCIAS:
//   secureStorageProvider → FlutterSecureStorage (síncrono, siempre disponible)
//
// NOTA PARA SPRINT DB:
//   Reemplazar AppDatabase(encryptionKey: key) con la apertura real de Drift:
//   ```dart
//   final executor = NativeDatabase(
//     File(join(await getApplicationDocumentsDirectory().path, 'jde.db')),
//     setup: (db) { db.execute("PRAGMA key='$key'"); },
//   );
//   return AppDatabase(executor);
//   ```
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, app_database, secure_storage_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jardindeleden/core/infrastructure/database/app_database.dart';
import 'package:jardindeleden/core/infrastructure/storage/secure_storage_provider.dart';
import 'package:jardindeleden/core/infrastructure/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// Instancia singleton de [AppDatabase] con cifrado AES-256.
///
/// [keepAlive: true] — la conexión persiste durante toda la sesión.
/// [FutureProvider] — la clave de cifrado se lee de SecureStorage (async).
@Riverpod(keepAlive: true)
Future<AppDatabase> appDatabase(AppDatabaseRef ref) async {
  final storage = ref.watch(secureStorageProvider);

  final encryptionKey = await _resolveEncryptionKey(storage);

  final db = AppDatabase(encryptionKey: encryptionKey);
  ref.onDispose(db.close);

  return db;
}

/// Lee la clave AES-256 del Keychain/Keystore o la genera en el primer arranque.
///
/// SPRINT DB: reemplazar el placeholder con crypto.dart o dart:math SecureRandom
/// para generar una clave AES-256 real de 32 bytes.
Future<String> _resolveEncryptionKey(FlutterSecureStorage storage) async {
  final stored = await storage.read(key: SecureStorageKeys.dbEncryptionKey);
  if (stored != null) return stored;

  // PLACEHOLDER: Sprint DB reemplazará esto con generación de clave real.
  // Ejemplo Sprint DB:
  //   final random = Random.secure();
  //   final keyBytes = List.generate(32, (_) => random.nextInt(256));
  //   final key = base64Url.encode(keyBytes);
  const placeholderKey = 'SPRINT_DB_REPLACE_WITH_AES256_KEY';
  await storage.write(
    key: SecureStorageKeys.dbEncryptionKey,
    value: placeholderKey,
  );
  return placeholderKey;
}
