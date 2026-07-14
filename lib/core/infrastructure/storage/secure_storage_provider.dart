// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/storage/secure_storage_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia configurada de FlutterSecureStorage.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   FlutterSecureStorage es stateless — NO almacena datos en memoria.
//   Cada llamada a .read() / .write() accede directamente al Keychain (iOS)
//   o EncryptedSharedPreferences (Android). Una sola instancia es suficiente.
//
// CONFIGURACIÓN DE SEGURIDAD:
//   Android: encryptedSharedPreferences = true
//     → Usa AES-256 del Android Keystore. Disponible en Android 6+.
//   iOS: accessibility = first_unlock_this_device
//     → El ítem es accesible después del primer desbloqueo, solo en este dispositivo.
//     → Previene que las copias de iCloud tengan las claves.
//
// USO EN OTROS PROVIDERS:
//   ```dart
//   @Riverpod(keepAlive: true)
//   Future<AppDatabase> appDatabase(AppDatabaseRef ref) async {
//     final storage = ref.watch(secureStorageProvider);
//     final key = await storage.read(key: SecureStorageKeys.dbEncryptionKey);
//     ...
//   }
//   ```
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, flutter_secure_storage.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_provider.g.dart';

/// Instancia global de [FlutterSecureStorage] con configuración segura.
///
/// [keepAlive: true] — singleton; la clase es stateless, no hay motivo para
/// crear múltiples instancias.
/// Es un [Provider] síncrono (no [FutureProvider]) porque [FlutterSecureStorage]
/// no requiere inicialización asíncrona — el Keychain/Keystore es accesible
/// directamente.
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
}
