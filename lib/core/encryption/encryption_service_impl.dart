// ─────────────────────────────────────────────────────────────────────────────
// core/encryption/encryption_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de EncryptionService sobre package:encrypt (AES-256-GCM,
//   basado en PointyCastle).
//
// DEPENDENCIAS PERMITIDAS:   dart:convert, dart:math, dart:typed_data,
//                            package:encrypt, core/encryption/encryption_service.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:jardindeleden/core/encryption/encryption_service.dart';

/// Implementación de [EncryptionService] con AES-256-GCM (package:encrypt).
final class EncryptionServiceImpl implements EncryptionService {
  const EncryptionServiceImpl();

  /// Tamaño del IV/nonce en bytes. 16 bytes es el tamaño usado en los
  /// ejemplos oficiales de package:encrypt para AES-GCM.
  static const int _ivLengthBytes = 16;

  @override
  String generateKeyHex({int lengthBytes = 32}) {
    final random = Random.secure();
    final bytes = List<int>.generate(lengthBytes, (_) => random.nextInt(256));
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  @override
  String encryptText(String plainText, {required String keyHex}) {
    final key = enc.Key.fromBase16(keyHex);
    final iv = enc.IV.fromSecureRandom(_ivLengthBytes);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    final packed = Uint8List(iv.bytes.length + encrypted.bytes.length)
      ..setRange(0, iv.bytes.length, iv.bytes)
      ..setRange(
        iv.bytes.length,
        iv.bytes.length + encrypted.bytes.length,
        encrypted.bytes,
      );

    return base64Encode(packed);
  }

  @override
  String decryptText(String cipherText, {required String keyHex}) {
    final key = enc.Key.fromBase16(keyHex);
    final packed = base64Decode(cipherText);

    final iv = enc.IV(Uint8List.sublistView(packed, 0, _ivLengthBytes));
    final cipherBytes = Uint8List.sublistView(packed, _ivLengthBytes);

    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    return encrypter.decrypt(enc.Encrypted(cipherBytes), iv: iv);
  }
}
