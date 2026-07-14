// ─────────────────────────────────────────────────────────────────────────────
// core/storage/logging_storage_service.dart
//
// RESPONSABILIDAD:
//   Decorator de StorageService que registra cada operación de escritura/
//   borrado bajo LogModules.storage — sin envolver la lógica de
//   almacenamiento en sí (delega 100% a [_inner]).
//
// PATRÓN: Decorator.
//   Cualquier StorageService (hoy SharedPreferences, mañana otro backend)
//   se puede envolver con logging sin que ninguno de los dos sepa del otro.
//   El mismo patrón se puede aplicar a FileService o CacheService si algún
//   Sprint futuro necesita loguear esas operaciones también — no fue
//   necesario para este Sprint porque StorageService es, hoy, el único
//   backend de persistencia key-value con escrituras frecuentes desde UI
//   (preferencias que cambian con cada interacción del usuario).
//
// QUÉ SE LOGUEA — Y QUÉ NUNCA:
//   Se loguea: la CLAVE (ej. 'jde_language') y el tipo de operación.
//   NUNCA se loguea el VALOR — StorageService no sabe si un valor es una
//   preferencia inocua (idioma) o, en el futuro, algo sensible. Tratar
//   TODOS los valores como potencialmente sensibles es la regla segura por
//   defecto (ver core/logging/log_sanitizer.dart para la misma filosofía
//   aplicada a metadata de logs).
//
// NIVEL: debug (no info) — las escrituras de preferencias son frecuentes
//   (cada cambio de volumen, por ejemplo) y no son eventos de negocio; ver
//   EducationalEventLogger para los eventos que sí ameritan nivel info.
//
// DEPENDENCIAS PERMITIDAS:   core/storage/ (contrato StorageService),
//                            core/logging/ (AppLogger, LogModules).
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:typed_data';

import 'package:jardindeleden/core/logging/app_logger.dart';
import 'package:jardindeleden/core/logging/log_modules.dart';
import 'package:jardindeleden/core/storage/storage_service.dart';

/// [StorageService] que loguea cada escritura/borrado antes de delegar a
/// [_inner]. Las lecturas NO se loguean (demasiado frecuentes, poco valor
/// diagnóstico) salvo que un Sprint futuro lo requiera.
final class LoggingStorageService implements StorageService {
  LoggingStorageService({
    required StorageService inner,
    required AppLogger logger,
  }) : _inner = inner,
       _logger = logger;

  final StorageService _inner;
  final AppLogger _logger;

  void _logWrite(String operation, String key) {
    _logger.debug(
      'storage_$operation',
      module: LogModules.storage,
      metadata: {'key': key},
    );
  }

  @override
  String? getString(String key) => _inner.getString(key);

  @override
  int? getInt(String key) => _inner.getInt(key);

  @override
  double? getDouble(String key) => _inner.getDouble(key);

  @override
  bool? getBool(String key) => _inner.getBool(key);

  @override
  List<String>? getStringList(String key) => _inner.getStringList(key);

  @override
  Uint8List? getBytes(String key) => _inner.getBytes(key);

  @override
  bool containsKey(String key) => _inner.containsKey(key);

  @override
  Future<void> setString(String key, String value) {
    _logWrite('write', key);
    return _inner.setString(key, value);
  }

  @override
  Future<void> setInt(String key, int value) {
    _logWrite('write', key);
    return _inner.setInt(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) {
    _logWrite('write', key);
    return _inner.setDouble(key, value);
  }

  @override
  Future<void> setBool(String key, bool value) {
    _logWrite('write', key);
    return _inner.setBool(key, value);
  }

  @override
  Future<void> setStringList(String key, List<String> value) {
    _logWrite('write', key);
    return _inner.setStringList(key, value);
  }

  @override
  Future<void> setBytes(String key, Uint8List value) {
    _logWrite('write', key);
    return _inner.setBytes(key, value);
  }

  @override
  Future<void> remove(String key) {
    _logWrite('remove', key);
    return _inner.remove(key);
  }

  @override
  Future<void> clear() {
    _logger.debug('storage_clear', module: LogModules.storage);
    return _inner.clear();
  }
}
