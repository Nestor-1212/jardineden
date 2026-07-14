// ─────────────────────────────────────────────────────────────────────────────
// core/logging/log_modules.dart
//
// RESPONSABILIDAD:
//   Registro central de los nombres de módulo usados en AppLogger.
//   Sin esto, cada llamada a logger.info(..., module: 'navegacion') vs
//   'navigation' vs 'nav' crea entradas inconsistentes imposibles de filtrar
//   en una herramienta de monitoreo futura. Un solo string por concepto.
//
// REGLA: Cualquier módulo nuevo se agrega AQUÍ antes de usarse en un logger.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// ─────────────────────────────────────────────────────────────────────────────

/// Nombres de módulo estándar para AppLogger y los loggers especializados.
abstract final class LogModules {
  // ── Infraestructura Core ─────────────────────────────────────────────────
  static const String database = 'database';
  static const String security = 'security';
  static const String backup = 'backup';
  static const String storage = 'storage';
  static const String sync = 'sync';

  // ── Categorías de observabilidad (este Sprint) ───────────────────────────
  static const String navigation = 'navigation';
  static const String performance = 'performance';
  static const String education = 'education';
  static const String audit = 'audit';

  // ── Errores ───────────────────────────────────────────────────────────────
  /// Usado por ErrorHandler.guard()/guardWithRetry() (core/error/).
  static const String error = 'error';

  /// Usado exclusivamente por installGlobalErrorHandlers — errores que
  /// escaparon de cualquier try/catch o de ErrorHandler.
  static const String unhandled = 'unhandled';
}
