// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/events/game_event_bus.dart
//
// RESPONSABILIDAD:
//   Contrato de comunicación entre piezas del motor — CÓMO viaja un
//   GameEvent (ver game_event.dart para QUÉ es un evento) desde quien lo
//   publica hasta quien reacciona, sin que ninguno de los dos conozca al
//   otro directamente.
//
// POR QUÉ ESTO Y NO SOLO UN Stream<GameEvent> EXPUESTO DIRECTAMENTE:
//   GameLoop.onTick y GameSession.onStatusChanged (sprint anterior) ya son
//   Streams — funcionan bien porque cada uno tiene UN solo tipo de evento
//   propio y UNA sola pieza que lo emite. GameEventBus resuelve un
//   problema distinto: MÚLTIPLES piezas (GameSession, GameEngine, y
//   futuras) publicando eventos de tipos variados hacia MÚLTIPLES
//   suscriptores, sin que cada combinación emisor-receptor necesite su
//   propio Stream dedicado. Es la diferencia entre "un teléfono directo" (
//   Stream de una pieza) y "una central telefónica" (el bus) — ambos
//   patrones son legítimos, se usan donde corresponde cada uno.
//
// POR QUÉ subscribe() RETORNA UNA FUNCIÓN DE CANCELACIÓN:
//   Evita introducir un tipo `GameSubscription` propio solo para poder
//   cancelar — una función sin argumentos que cancela es la forma más
//   pequeña posible del contrato (YAGNI), consistente con no inventar tipos
//   sin un consumidor real que los necesite (ver entities/game_entity.dart).
//
// DEPENDENCIAS PERMITIDAS:   game_event.dart de este mismo módulo.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/game_engine/events/game_event.dart';

/// Firma de una función que reacciona a un [GameEvent] publicado.
typedef GameEventListener = void Function(GameEvent event);

/// Canal de comunicación entre piezas del motor.
///
/// El mecanismo que permite, por ejemplo, que una GameSession futura
/// notifique que terminó sin importar directamente qué feature (Economy,
/// Stats) reacciona a eso — bajo acoplamiento real, no solo declarado.
abstract interface class GameEventBus {
  /// Publica [event] a todos los listeners suscritos en este momento.
  void publish(GameEvent event);

  /// Suscribe [listener] — se invoca en cada [publish] posterior a esta
  /// llamada (nunca en publicaciones pasadas).
  ///
  /// Retorna una función que, al invocarse, cancela esta suscripción.
  void Function() subscribe(GameEventListener listener);
}
