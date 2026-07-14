// ─────────────────────────────────────────────────────────────────────────────
// core/storage/storage_service.dart
//
// RESPONSABILIDAD:
//   Motor genérico de almacenamiento clave-valor, agnóstico del backend real.
//   Es la capa MÁS BAJA de persistencia no-relacional del proyecto — no sabe
//   qué es un "idioma" o un "volumen", solo sabe guardar tipos primitivos
//   bajo una clave String.
//
// POR QUÉ EXISTE UNA CAPA SEPARADA DE PreferencesService:
//   PreferencesService (core/storage/preferences_service.dart) es la fachada
//   de dominio: expone getLanguage()/setMusicVolume() con las claves ya
//   resueltas. StorageService es el motor genérico que esa fachada consume
//   por debajo. Esta separación permite:
//   ✓ Cambiar el backend (hoy SharedPreferences, mañana otro) sin tocar
//     ninguna feature — solo se reemplaza StorageServiceImpl.
//   ✓ Testear PreferencesService con un StorageService en memoria (fake),
//     sin necesitar SharedPreferences.getInstance() real en tests.
//
// QUÉ NO VIVE AQUÍ:
//   Nombres de claves específicas del juego (eso vive en storage_keys.dart
//   y en PreferencesService). Este contrato no conoce ningún dominio.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:typed_data.
// DEPENDENCIAS PROHIBIDAS:   features, shared, Flutter, cualquier paquete
//                            concreto de storage (eso vive en el Impl).
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:typed_data';

/// Contrato del motor genérico de almacenamiento clave-valor.
abstract interface class StorageService {
  // ── Lectura ───────────────────────────────────────────────────────────────

  String? getString(String key);
  int? getInt(String key);
  double? getDouble(String key);
  bool? getBool(String key);
  List<String>? getStringList(String key);

  /// Lee un valor binario crudo (para blobs pequeños que no ameritan un
  /// archivo propio — ver FileService para blobs grandes).
  Uint8List? getBytes(String key);

  /// true si existe un valor almacenado bajo [key], sin importar el tipo.
  bool containsKey(String key);

  // ── Escritura ─────────────────────────────────────────────────────────────

  Future<void> setString(String key, String value);
  Future<void> setInt(String key, int value);
  Future<void> setDouble(String key, double value);
  Future<void> setBool(String key, bool value);
  Future<void> setStringList(String key, List<String> value);
  Future<void> setBytes(String key, Uint8List value);

  // ── Limpieza ──────────────────────────────────────────────────────────────

  /// Elimina un único valor. No falla si [key] no existe.
  Future<void> remove(String key);

  /// Elimina TODOS los valores del backend. Usar con cuidado —
  /// PreferencesService.clearAllPlayerData() es la vía correcta para
  /// borrar datos de un jugador específico; este método es total.
  Future<void> clear();
}
