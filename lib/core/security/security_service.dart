// ─────────────────────────────────────────────────────────────────────────────
// core/security/security_service.dart
//
// RESPONSABILIDAD:
//   Centraliza todas las operaciones de seguridad del proyecto.
//
// OPERACIONES:
//   1. Gestión de la clave de cifrado de la base de datos.
//      - Genera una clave AES-256 derivada del ID único del dispositivo.
//      - La almacena en Keychain (iOS) / Keystore (Android).
//      - La lee cuando Drift necesita abrir la base de datos.
//
//   2. Hash del PIN parental.
//      - Aplica bcrypt(pin, cost=12, salt) al PIN del Panel de Padres.
//      - Verifica el PIN comparando el hash almacenado en la DB.
//      - NUNCA almacena el PIN en texto plano.
//
//   3. Verificación de integridad de assets.
//      - Calcula y verifica el hash SHA-256 de los archivos de assets.
//      - Compara con el hash registrado en la base de datos.
//
// LIBRERÍAS:
//   - flutter_secure_storage: para Keychain/Keystore.
//   - crypto: para SHA-256 (verificación de assets).
//   - El hash bcrypt para el PIN se implementa con el paquete 'bcrypt'.
//
// DEPENDENCIAS PERMITIDAS:
//   flutter_secure_storage, crypto, bcrypt, dart:typed_data
// DEPENDENCIAS PROHIBIDAS:
//   features, shared, core/database (para evitar circular dependency)
//   La SecurityService provee la CLAVE a AppDatabase, no la consume.
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core (Seguridad)
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del servicio de seguridad del proyecto.
abstract interface class SecurityService {
  // ── Clave de Cifrado de la Base de Datos ──────────────────────────────────

  /// Obtiene la clave de cifrado AES-256 para SQLCipher.
  /// Si no existe, la genera y la almacena en el Keychain/Keystore.
  /// Si existe, la lee del almacenamiento seguro.
  Future<String> getDatabaseEncryptionKey();

  // ── PIN del Panel de Padres ───────────────────────────────────────────────

  /// Genera el hash bcrypt(cost=12) de un PIN de 4-6 dígitos.
  /// El resultado se almacena en la base de datos, nunca el PIN original.
  Future<String> hashPin(String pin);

  /// Verifica si el PIN ingresado coincide con el hash almacenado.
  /// Retorna true si coinciden, false si no.
  /// Implementa rate limiting: registra intentos fallidos.
  Future<bool> verifyPin(String inputPin, String storedHash);

  // ── Integridad de Assets ──────────────────────────────────────────────────

  /// Calcula el hash SHA-256 de un archivo de asset.
  /// Se llama antes de usar un asset descargado.
  Future<String> calculateAssetHash(String filePath);

  /// Verifica que el hash del archivo coincida con el hash esperado.
  /// Retorna true si el asset es íntegro, false si fue modificado.
  Future<bool> verifyAssetIntegrity(String filePath, String expectedHash);
}
