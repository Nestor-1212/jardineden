// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/events/game_event.dart
//
// RESPONSABILIDAD:
//   Contrato base de cualquier evento que una pieza del motor publica para
//   que otras reaccionen sin conocerse directamente entre sí. Ver
//   game_event_bus.dart para CÓMO viaja un evento (el mecanismo de
//   publicación/suscripción) — este archivo define únicamente QUÉ es un
//   evento.
//
// POR QUÉ NO HAY VARIANTES CONCRETAS (SessionCompletedEvent,
// EntityRemovedEvent, etc.):
//   Mismo razonamiento que entities/game_entity.dart e
//   input/game_command.dart: el motor no impone un catálogo fijo de
//   eventos. Cada pieza que publique eventos (GameSession, GameEngine)
//   define los suyos implementando este contrato — el bus (GameEventBus)
//   los transporta sin conocer sus tipos concretos.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato base de cualquier evento del motor.
///
/// El motor no conoce ningún evento concreto — cada pieza que publica
/// eventos define su propio vocabulario implementando esta interfaz.
abstract interface class GameEvent {
  /// Identificador semántico del tipo de evento (p. ej.
  /// `'session_completed'`, `'entity_removed'`). Cadena y no un enum
  /// cerrado por la misma razón que GameCommand.type
  /// (input/game_command.dart): el motor no impone un catálogo fijo.
  String get type;
}
