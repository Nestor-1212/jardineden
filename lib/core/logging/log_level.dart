// ─────────────────────────────────────────────────────────────────────────────
// core/logging/log_level.dart
//
// RESPONSABILIDAD:
//   Define los 5 niveles de severidad del sistema de logging.
//   El nivel activo se configura en AppConfig según el ambiente.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Cualquier paquete, Flutter, features, shared.
// ─────────────────────────────────────────────────────────────────────────────

/// Los 5 niveles de severidad del sistema de logging.
///
/// Se procesan en orden ascendente de severidad.
/// Un log se registra solo si su nivel >= el nivel mínimo configurado.
enum LogLevel {
  /// Trazabilidad de muy alta granularidad. Solo en desarrollo local.
  /// Registra operaciones de base de datos, pasos de navegación,
  /// eventos individuales de Riverpod.
  verbose(0),

  /// Información útil para debugging durante el desarrollo.
  /// Resultados de casos de uso, estados de carga de assets.
  debug(1),

  /// Eventos significativos del flujo normal del juego.
  /// Inicio/fin de capítulo, transacciones de economía, logros.
  /// Activo en producción. Máximo 1000 entradas en el log local.
  info(2),

  /// Situaciones anómalas que no son errores pero merecen atención.
  /// Asset no encontrado (se usa fallback), tiempo de DB > 50ms.
  warning(3),

  /// Errores que afectan la funcionalidad del juego.
  /// Siempre se registran en producción.
  error(4);

  const LogLevel(this.value);

  /// Valor numérico para comparación de severidad.
  final int value;

  /// true si este nivel es mayor o igual al nivel mínimo configurado.
  bool isAtLeast(LogLevel minimum) => value >= minimum.value;
}
