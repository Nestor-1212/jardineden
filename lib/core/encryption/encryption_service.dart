// ─────────────────────────────────────────────────────────────────────────────
// core/encryption/encryption_service.dart
//
// RESPONSABILIDAD:
//   Motor genérico de cifrado simétrico reutilizable — AES-256-GCM (cifrado
//   autenticado: detecta si el dato fue alterado, no solo lo descifra).
//
// RELACIÓN CON SecurityService:
//   EncryptionService = "CÓMO cifro/genero claves" (mecanismo, genérico,
//   reutilizable en cualquier proyecto).
//   SecurityService   = "QUÉ secretos maneja el juego y dónde viven"
//   (la clave de la DB, el PIN parental, el hash de assets — dominio).
//   SecurityService CONSUME EncryptionService para generar la clave de la
//   base de datos; EncryptionService no sabe que existe una base de datos.
//
// FORMATO DE SALIDA DE encryptText:
//   Un único string base64 que empaqueta [IV de 16 bytes][texto cifrado +
//   tag de autenticación GCM]. Basta ese string y la clave para descifrar
//   — no hace falta guardar el IV por separado.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   features, shared, Flutter, core/security
//                            (la relación es unidireccional: security → encryption).
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del motor genérico de cifrado simétrico.
abstract interface class EncryptionService {
  /// Genera una clave aleatoria criptográficamente segura (CSPRNG del SO),
  /// codificada en hexadecimal. [lengthBytes] = 32 produce una clave de 256 bits.
  String generateKeyHex({int lengthBytes = 32});

  /// Cifra [plainText] con AES-256-GCM usando [keyHex] (clave en hexadecimal).
  String encryptText(String plainText, {required String keyHex});

  /// Descifra un string producido por [encryptText] con la misma [keyHex].
  ///
  /// Lanza si el tag de autenticación GCM no coincide — indica que el dato
  /// fue alterado o que la clave es incorrecta; nunca falla en silencio.
  String decryptText(String cipherText, {required String keyHex});
}
