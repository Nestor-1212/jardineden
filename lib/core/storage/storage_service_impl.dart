// ─────────────────────────────────────────────────────────────────────────────
// core/storage/storage_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de StorageService sobre SharedPreferences.
//
// SOBRE getBytes/setBytes:
//   SharedPreferences no tiene un tipo binario nativo. Se codifica como
//   base64 en un String internamente — transparente para quien consume
//   StorageService, que solo ve Uint8List de entrada y salida.
//
// DEPENDENCIAS PERMITIDAS:   shared_preferences, dart:convert, dart:typed_data,
//                            core/storage/storage_service.dart (contrato)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'dart:typed_data';

import 'package:jardindeleden/core/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementación de [StorageService] sobre [SharedPreferences].
final class StorageServiceImpl implements StorageService {
  StorageServiceImpl({required SharedPreferences preferences})
      : _preferences = preferences;

  final SharedPreferences _preferences;

  @override
  String? getString(String key) => _preferences.getString(key);

  @override
  int? getInt(String key) => _preferences.getInt(key);

  @override
  double? getDouble(String key) => _preferences.getDouble(key);

  @override
  bool? getBool(String key) => _preferences.getBool(key);

  @override
  List<String>? getStringList(String key) => _preferences.getStringList(key);

  @override
  Uint8List? getBytes(String key) {
    final encoded = _preferences.getString(key);
    if (encoded == null) return null;
    return base64Decode(encoded);
  }

  @override
  bool containsKey(String key) => _preferences.containsKey(key);

  @override
  Future<void> setString(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<void> setInt(String key, int value) => _preferences.setInt(key, value);

  @override
  Future<void> setDouble(String key, double value) =>
      _preferences.setDouble(key, value);

  @override
  Future<void> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  @override
  Future<void> setStringList(String key, List<String> value) =>
      _preferences.setStringList(key, value);

  @override
  Future<void> setBytes(String key, Uint8List value) =>
      _preferences.setString(key, base64Encode(value));

  @override
  Future<void> remove(String key) => _preferences.remove(key);

  @override
  Future<void> clear() => _preferences.clear();
}
