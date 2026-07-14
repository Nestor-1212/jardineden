// ─────────────────────────────────────────────────────────────────────────────
// core/logging/educational_event_logger.dart
//
// RESPONSABILIDAD:
//   Registra hitos educativos del juego (capítulo completado, versículo
//   memorizado, misión cumplida) bajo LogModules.education, con nivel
//   [info] (son eventos de negocio significativos, no ruido técnico).
//
// PARA QUÉ SIRVE (más allá de debugging):
//   Es la base para métricas agregadas de aprendizaje ("¿qué capítulos se
//   abandonan más seguido?", "¿cuánto tarda en promedio memorizar un
//   versículo?") — el mismo LogSink que hoy imprime a consola, mañana
//   podría alimentar un dashboard de analítica educativa (ver
//   core/logging/log_sink.dart).
//
// CAMPOS SEGUROS (whitelist, no denylist — a propósito):
//   [eventName] es un identificador técnico fijo (ej. 'chapter_completed'),
//   nunca texto libre. [anonymousProfileId] es el UUID anónimo del perfil,
//   NUNCA el nombre del niño. [metadata] pasa igualmente por
//   LogSanitizer.sanitize() (vía AppLogger) antes de cualquier sink, pero
//   además esta interfaz documenta explícitamente qué es seguro incluir:
//
//   SEGURO:    world_id, chapter_id, mission_id, verse_id, stars_earned,
//              duration_seconds, attempts_count, correct (bool).
//   PROHIBIDO: el texto que el niño escribió como respuesta, su nombre,
//              su edad exacta, cualquier campo de un formulario libre.
//              Para "¿acertó o no?" usar el booleano `correct`, nunca el
//              contenido de la respuesta.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   Flutter, features (esto es infraestructura;
//                            las features LLAMAN a esto, no lo extienden).
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del logger de eventos educativos.
abstract interface class EducationalEventLogger {
  /// Registra un evento educativo.
  ///
  /// [eventName] debe ser un identificador técnico estable (snake_case),
  /// nunca un mensaje en lenguaje natural — eso permite agregarlos
  /// después (contar cuántas veces ocurrió cada `eventName`).
  void logEvent(
    String eventName, {
    required String anonymousProfileId,
    Map<String, Object?>? metadata,
  });
}
