// ─────────────────────────────────────────────────────────────────────────────
// core/logging/performance_logger.dart
//
// RESPONSABILIDAD:
//   Mide la duración de operaciones (apertura de DB, carga de un mundo,
//   una query) y las registra bajo LogModules.performance. Es la única
//   forma estándar de medir rendimiento en el proyecto — evita que cada
//   feature invente su propio `Stopwatch()` con logging inconsistente.
//
// UMBRAL DE ADVERTENCIA:
//   Si una operación excede [warnThreshold], se loguea como warning en vez
//   de debug — permite filtrar "todo lo que fue lento" sin tener que leer
//   cada medición individual.
//
// QUÉ SE LOGUEA:
//   Nombre de la operación (ej. 'database_open', 'chapter_load') y su
//   duración en milisegundos. NUNCA argumentos de la operación en sí —
//   igual que NavigationLogger, mide EVENTOS técnicos, no contenido.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:async.
// DEPENDENCIAS PROHIBIDAS:   Flutter, features.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del logger de rendimiento.
abstract interface class PerformanceLogger {
  /// Ejecuta [action], mide su duración, la registra, y retorna su resultado.
  ///
  /// Si [action] lanza, la duración se registra igual (con metadata
  /// `{'failed': true}`) antes de dejar propagar la excepción original —
  /// medir cuánto tardó en fallar también es información de rendimiento.
  Future<T> measure<T>(
    String operation,
    Future<T> Function() action, {
    String? module,
  });
}
