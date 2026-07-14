// ─────────────────────────────────────────────────────────────────────────────
// test/helpers/fakes/fake_storage_service.dart
//
// RESPONSABILIDAD
// Fake en memoria de StorageService (core/storage/storage_service.dart) —
// EJEMPLO DE REFERENCIA para el resto de fakes del proyecto. Nuevas features
// que necesiten fakear una dependencia propia (repositorios, otros
// services) deben seguir este mismo patrón, no el de mocktail.
//
// FAKE vs MOCK (mocktail) — CUÁNDO USAR CADA UNO
//   Fake (esta clase):
//     ✓ El colaborador tiene ESTADO real que el test necesita observar
//       (guardar un valor y luego leerlo de vuelta).
//     ✓ El comportamiento es simple y determinista — reimplementarlo a mano
//       es más simple y legible que configurar stubs.
//     ✓ Se reutiliza en MUCHOS tests sin cambios (una sola implementación).
//     Ejemplo: StorageService, un repositorio en memoria.
//
//   Mock (mocktail, ya en pubspec.yaml):
//     ✓ El test verifica UNA interacción específica ("¿se llamó
//       logger.error() exactamente una vez con este mensaje?").
//     ✓ El colaborador no tiene estado relevante — solo importa qué se le
//       llamó y con qué argumentos.
//     ✓ Cada test configura su propio comportamiento (`when(...).thenReturn`).
//     Ejemplo: verificar que AudioService.playSfx() se invocó al tocar un botón.
//
// Ninguno reemplaza al otro — este proyecto usa ambos según el caso.
//
// POR QUÉ NO IMPLEMENTA PERSISTENCIA REAL
// Es deliberadamente un Map<String, Object> en memoria, sin tocar disco ni
// plugins de plataforma — el punto de un fake es que el test corra rápido y
// sin side effects que sobrevivan al proceso de test.
//
// DEPENDENCIAS PERMITIDAS: dart:typed_data, core/storage/storage_service.dart.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:typed_data';

import 'package:jardindeleden/core/storage/storage_service.dart';

/// Implementación en memoria de [StorageService] para tests.
///
/// Ejemplo:
/// ```dart
/// final storage = FakeStorageService();
/// await storage.setString('idioma', 'es');
///
/// expect(storage.getString('idioma'), 'es');
/// ```
///
/// Para pre-poblar valores antes de un test (simular "el jugador ya tenía
/// esto guardado"), usar el constructor con `initialValues`:
/// ```dart
/// final storage = FakeStorageService(initialValues: {'idioma': 'en'});
/// ```
class FakeStorageService implements StorageService {
  FakeStorageService({Map<String, Object>? initialValues})
    : _values = {...?initialValues};

  final Map<String, Object> _values;

  // ── Lectura ───────────────────────────────────────────────────────────────

  @override
  String? getString(String key) => _values[key] as String?;

  @override
  int? getInt(String key) => _values[key] as int?;

  @override
  double? getDouble(String key) => _values[key] as double?;

  @override
  bool? getBool(String key) => _values[key] as bool?;

  @override
  List<String>? getStringList(String key) => _values[key] as List<String>?;

  @override
  Uint8List? getBytes(String key) => _values[key] as Uint8List?;

  @override
  bool containsKey(String key) => _values.containsKey(key);

  // ── Escritura ─────────────────────────────────────────────────────────────

  @override
  Future<void> setString(String key, String value) async =>
      _values[key] = value;

  @override
  Future<void> setInt(String key, int value) async => _values[key] = value;

  @override
  Future<void> setDouble(String key, double value) async =>
      _values[key] = value;

  @override
  Future<void> setBool(String key, bool value) async => _values[key] = value;

  @override
  Future<void> setStringList(String key, List<String> value) async =>
      _values[key] = value;

  @override
  Future<void> setBytes(String key, Uint8List value) async =>
      _values[key] = value;

  // ── Limpieza ──────────────────────────────────────────────────────────────

  @override
  Future<void> remove(String key) async => _values.remove(key);

  @override
  Future<void> clear() async => _values.clear();
}
