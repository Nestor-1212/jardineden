// ─────────────────────────────────────────────────────────────────────────────
// core/cache/cache_service.dart
//
// RESPONSABILIDAD:
//   Cache genérico en memoria con expiración (TTL) opcional por entrada.
//   Para resultados costosos de recomputar dentro de una sesión (ej: un
//   cálculo de ranking, una respuesta parseada) que NO necesitan sobrevivir
//   el cierre de la app — para eso está StorageService/FileService.
//
// QUÉ NO VIVE AQUÍ:
//   Qué se cachea o por cuánto tiempo tiene sentido cachearlo — eso lo
//   decide cada feature al llamar a put() con su propio TTL.
//
// PERSISTENCIA: NINGUNA.
//   Este cache vive en memoria del proceso. Se vacía en cada reinicio de la
//   app. No es un sustituto de StorageService ni de la base de datos.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   Flutter, features, shared.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato de un cache genérico en memoria con expiración opcional.
abstract interface class CacheService {
  /// Lee el valor bajo [key]. Retorna null si no existe o si expiró.
  ///
  /// Lanza [TypeError] si el valor almacenado no es del tipo [T] solicitado
  /// — señal de un bug del llamador, no un caso a silenciar.
  T? get<T extends Object>(String key);

  /// Guarda [value] bajo [key]. Si [ttl] es null, el valor no expira por
  /// tiempo (pero puede ser desalojado por [clear] o [invalidate]).
  void put<T extends Object>(String key, T value, {Duration? ttl});

  /// true si [key] existe y no ha expirado.
  bool containsKey(String key);

  /// Elimina una entrada específica. No falla si no existe.
  void invalidate(String key);

  /// Elimina todas las entradas.
  void clear();

  /// Número de entradas actualmente almacenadas (incluye expiradas no
  /// purgadas todavía — ver nota de implementación en CacheServiceImpl).
  int get length;
}
