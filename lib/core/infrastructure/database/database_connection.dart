// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/database/database_connection.dart
//
// RESPONSABILIDAD:
//   Abrir el QueryExecutor nativo (NativeDatabase) que Drift usa para
//   ejecutar SQL, con soporte de cifrado SQLCipher (AES-256-CBC + HMAC-SHA512).
//   Aísla toda la configuración de bajo nivel de plataforma para que
//   app_database.dart permanezca libre de detalles de I/O y cifrado.
//
// CIFRADO:
//   sqlcipher_flutter_libs reemplaza la build estándar de sqlite3 por una
//   compilada con soporte SQLCipher. La clave se inyecta en tiempo de
//   apertura vía `PRAGMA key`, en el formato x'<hex>' (clave binaria
//   directa de 256 bits) — esto evita que SQLCipher derive la clave con
//   PBKDF2 a partir de una passphrase de texto, que sería redundante:
//   la clave ya es aleatoria de 32 bytes, generada por SecurityService.
//
// EJECUCIÓN EN BACKGROUND:
//   NativeDatabase.createInBackground abre la conexión en un isolate
//   dedicado. Evita que operaciones de disco bloqueen el hilo de UI,
//   crítico para un juego con animaciones continuas.
//
// AMBIENTE DEV:
//   Si AppConfig.databaseEncryptionEnabled es false (solo en dev), se omite
//   el PRAGMA key para poder inspeccionar el archivo .db con herramientas
//   como "DB Browser for SQLite" durante el desarrollo.
//
// DEPENDENCIAS PERMITIDAS:   drift, sqlite3, sqlcipher_flutter_libs,
//                            path_provider, path, dart:io.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

/// Abre (o crea) el archivo de base de datos del juego con cifrado SQLCipher.
///
/// [databaseFileName]: nombre del archivo dentro de applicationDocumentsDirectory.
/// [encryptionKey]: clave AES-256 en hexadecimal (64 caracteres), provista
///   por SecurityService y almacenada en Keychain/Keystore.
/// [encryptionEnabled]: false solo en dev — abre la DB sin cifrar.
LazyDatabase openEncryptedConnection({
  required String databaseFileName,
  required String encryptionKey,
  required bool encryptionEnabled,
}) {
  return LazyDatabase(() async {
    // Android no incluye una build de sqlite3 con SQLCipher por defecto:
    // hay que solicitar explícitamente la variante cifrada del binario
    // nativo que empaqueta sqlcipher_flutter_libs.
    // iOS/macOS ya reciben la variante correcta sin necesidad de override.
    if (Platform.isAndroid) {
      open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
    }

    final documentsDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(documentsDir.path, databaseFileName));

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        if (encryptionEnabled) {
          rawDb.execute("PRAGMA key = \"x'$encryptionKey'\";");
        }
      },
    );
  });
}
