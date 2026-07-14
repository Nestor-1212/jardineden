// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/game_engine_contract.dart
//
// RESPONSABILIDAD:
//   Contrato raíz de Genesis Engine — el único punto de coordinación entre
//   GameSession, el registro de entidades activas y el bus de eventos. Un
//   feature de minijuego futuro depende de UN GameEngine, nunca de sus
//   piezas internas por separado.
//
// POR QUÉ ESTE ARCHIVO VIVE EN LA RAÍZ Y NO EN UNA SUBCARPETA:
//   Es el único contrato que conoce y compone TODAS las subcarpetas
//   (lifecycle/, session/, registry/, entities/, events/) — no pertenece a
//   ninguna en particular. La raíz de core/game_engine/ es, por
//   convención de este módulo, donde vive lo que es sobre el motor
//   COMPLETO (ver también game_engine.dart, el barrel, y
//   game_engine_charter.dart, la identidad) — nunca sobre un concepto
//   aislado.
//
// POR QUÉ implements GameLifecycle:
//   El motor en sí necesita un setup explícito (p. ej. preparar su
//   GameLoop interno) antes de poder crear sesiones, y una liberación
//   explícita al cerrar la app — exactamente el contrato ya definido en
//   lifecycle/game_lifecycle.dart. Reusarlo aquí (en vez de declarar
//   initialize()/dispose() de nuevo) es la razón de ser de ese contrato:
//   un vocabulario común entre piezas del motor que lo necesitan.
//
// POR QUÉ SOLO UNA GameSession A LA VEZ (currentSession, no una lista):
//   Genesis Engine es para minijuegos cortos y secuenciales — un niño
//   juega un minijuego a la vez, nunca varios en paralelo (ver
//   game_engine_charter.dart, Filosofía, Público objetivo). Modelar
//   múltiples sesiones concurrentes sería una capacidad sin consumidor
//   real hoy.
//
// POR QUÉ NO EXPONE EL GameLoop NI EL GameClock DIRECTAMENTE:
//   Son detalles internos de CÓMO GameEngine implementa el ritmo de una
//   sesión — no algo que un feature de minijuego deba tocar directamente
//   (Ley de Demeter / bajo acoplamiento). Un minijuego futuro interactúa
//   con GameEngine y con la GameSession que este produce, nunca con el
//   loop o el reloj subyacentes.
//
// DEPENDENCIAS PERMITIDAS:   lifecycle/game_lifecycle.dart,
//                            session/game_session.dart,
//                            registry/game_registry.dart,
//                            entities/game_entity.dart,
//                            events/game_event_bus.dart — todos de este
//                            mismo módulo.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/game_engine/entities/game_entity.dart';
import 'package:jardindeleden/core/game_engine/events/game_event_bus.dart';
import 'package:jardindeleden/core/game_engine/lifecycle/game_lifecycle.dart';
import 'package:jardindeleden/core/game_engine/registry/game_registry.dart';
import 'package:jardindeleden/core/game_engine/session/game_session.dart';

/// Contrato raíz de Genesis Engine.
///
/// La única superficie que un feature de minijuego futuro debería
/// necesitar conocer del motor — coordina el ciclo de vida propio, la
/// sesión activa, las entidades registradas y la comunicación entre
/// piezas, sin exponer cómo logra cada una de esas cosas internamente.
abstract interface class GameEngine implements GameLifecycle {
  /// La sesión de juego activa. `null` antes de la primera llamada a
  /// [startSession], o después de que esa sesión termine (ver
  /// session/game_session.dart, GameSessionStatus.isFinished) y todavía no
  /// se haya iniciado una nueva.
  GameSession? get currentSession;

  /// Registro de las entidades activas en [currentSession].
  ///
  /// Se vacía automáticamente al iniciar una sesión nueva — un minijuego
  /// nunca hereda entidades de la sesión anterior.
  GameRegistry<GameEntity> get entities;

  /// Canal de comunicación entre piezas del motor y consumidores externos
  /// (Economy, Stats, Rewards) — ver events/game_event_bus.dart.
  GameEventBus get events;

  /// Crea y arranca una nueva [GameSession], reemplazando
  /// [currentSession] si ya existía una activa. Solo válida cuando
  /// [GameLifecycleState.isUsable] es `true` (el motor ya fue
  /// inicializado).
  GameSession startSession();
}
