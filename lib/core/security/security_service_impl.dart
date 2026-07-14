// ─────────────────────────────────────────────────────────────────────────────
// core/security/security_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación concreta de SecurityService (ver security_service.dart
//   para el contrato completo).
//
// CLAVE DE CIFRADO DE LA BASE DE DATOS:
//   La generación real (CSPRNG de 32 bytes → hex) vive en EncryptionService
//   (core/encryption/), el motor genérico de cifrado. Esta clase solo decide
//   DÓNDE persistir esa clave (Keychain/Keystore) y CUÁNDO generarla (una
//   sola vez, en el primer arranque). Perderla implica perder acceso a la
//   base de datos (ver core/backup para la estrategia de recuperación).
//
// PIN DEL PANEL DE PADRES:
//   bcrypt(cost=12) — el costo 12 implica ~300ms por hash, deliberadamente
//   lento para dificultar ataques de fuerza bruta offline si el hash llegara
//   a filtrarse. El salt se genera y se embebe automáticamente en el hash
//   resultante (formato estándar bcrypt: $2b$12$<22 chars salt><31 chars hash>).
//
// INTEGRIDAD DE ASSETS:
//   SHA-256 sobre el contenido del archivo. No es secreto (no hay clave),
//   solo detecta corrupción o manipulación comparando contra el hash
//   registrado en el catálogo de contenido.
//
// DEPENDENCIAS PERMITIDAS:
//   flutter_secure_storage, crypto, bcrypt, core/encryption/ (EncryptionService),
//   dart:io, dart:core
// DEPENDENCIAS PROHIBIDAS:
//   features, shared, core/database (evita dependencia circular:
//   SecurityService provee la clave a AppDatabase, no la consume)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jardindeleden/core/encryption/encryption_service.dart';
import 'package:jardindeleden/core/infrastructure/storage/storage_keys.dart';
import 'package:jardindeleden/core/security/security_service.dart';

/// Implementación de [SecurityService] sobre flutter_secure_storage,
/// EncryptionService, crypto (SHA-256) y bcrypt.
final class SecurityServiceImpl implements SecurityService {
  SecurityServiceImpl({
    required FlutterSecureStorage secureStorage,
    required EncryptionService encryption,
  }) : _secureStorage = secureStorage,
       _encryption = encryption;

  final FlutterSecureStorage _secureStorage;
  final EncryptionService _encryption;

  /// Costo de bcrypt. 12 es el mínimo recomendado en 2026 para hashing
  /// interactivo (no bloquea la UI de forma perceptible: ~300ms).
  static const int _bcryptCost = 12;

  @override
  Future<String> getDatabaseEncryptionKey() async {
    final stored = await _secureStorage.read(
      key: SecureStorageKeys.dbEncryptionKey,
    );
    if (stored != null) return stored;

    // 32 bytes = 256 bits, codificados en hexadecimal (64 caracteres) —
    // formato esperado por `PRAGMA key = "x'<hex>'"` en database_connection.dart.
    final generatedKey = _encryption.generateKeyHex();
    await _secureStorage.write(
      key: SecureStorageKeys.dbEncryptionKey,
      value: generatedKey,
    );
    return generatedKey;
  }

  @override
  Future<String> hashPin(String pin) async {
    final salt = BCrypt.gensalt(logRounds: _bcryptCost);
    return BCrypt.hashpw(pin, salt);
  }

  @override
  Future<bool> verifyPin(String inputPin, String storedHash) async {
    return BCrypt.checkpw(inputPin, storedHash);
  }

  @override
  Future<String> calculateAssetHash(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    return sha256.convert(bytes).toString();
  }

  @override
  Future<bool> verifyAssetIntegrity(
    String filePath,
    String expectedHash,
  ) async {
    final actualHash = await calculateAssetHash(filePath);
    return actualHash == expectedHash;
  }
}
