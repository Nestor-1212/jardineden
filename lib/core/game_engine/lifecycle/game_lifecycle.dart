// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/lifecycle/game_lifecycle.dart
//
// RESPONSABILIDAD:
//   Contratos genéricos de ciclo de vida (inicialización + destrucción)
//   que cualquier pieza del motor con setup/liberación explícitos puede
//   implementar — no un concepto atado a GameSession ni a GameEngine en
//   particular, sino la forma común que ambos (y cualquier pieza futura)
//   comparten.
//
// POR QUÉ EXISTE COMO CONTRATO PROPIO Y NO SOLO "cada clase tiene su
// propio dispose()":
//   GameLoop (loop/game_loop.dart) ya declaraba su propio `dispose()`
//   antes de que este archivo existiera — eso es correcto y se queda así
//   (ver nota de compatibilidad más abajo). Lo que faltaba era un
//   VOCABULARIO COMÚN: sin un contrato compartido, cada pieza futura del
//   motor inventaría su propio nombre de método para "inicializar" o
//   "destruir", y un consumidor genérico (p. ej. algo que necesite
//   inicializar/destruir un conjunto heterogéneo de piezas del motor) no
//   tendría un tipo común contra el cual programar (DIP).
//
// POR QUÉ SON DOS INTERFACES (GameInitializable, GameDisposable) Y NO UNA:
//   ISP — no toda pieza que necesita liberarse necesita inicialización
//   explícita (algunas se inicializan por completo en su constructor), y
//   viceversa. Forzar ambos métodos en una sola interfaz obligaría a
//   implementaciones triviales de un método que la pieza no necesita.
//   GameLifecycle existe como el contrato COMPUESTO para piezas que sí
//   necesitan ambas capacidades juntas (el caso más común en la práctica:
//   GameEngine, GameSession).
//
// NOTA DE COMPATIBILIDAD (no se aplica retroactivamente en este sprint):
//   GameLoop, GameSession, GameEntity y los demás contratos del sprint
//   anterior NO se modifican aquí para implementar estas interfaces —
//   habría significado revisar entregas ya cerradas fuera del alcance de
//   "diseñar los contratos oficiales" de este sprint. Adoptar
//   GameLifecycle/GameInitializable/GameDisposable en esos contratos es
//   una armonización legítima para un sprint futuro, evaluada contra cada
//   caso concreto, no una tarea implícita de este.
//
// DEPENDENCIAS PERMITIDAS:   dart:async (Future).
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';

/// Estado de ciclo de vida de una pieza del motor que implementa
/// [GameLifecycle] (o alguna de sus dos mitades por separado).
enum GameLifecycleState {
  /// Creada pero `initialize()` todavía no se llamó.
  uninitialized,

  /// `initialize()` está en curso.
  initializing,

  /// Inicializada y lista para usarse.
  ready,

  /// `dispose()` ya se llamó — no puede volver a usarse.
  disposed;

  /// `true` solo cuando es válido llamar a `initialize()`.
  bool get canInitialize => this == uninitialized;

  /// `true` cuando la pieza está lista para usarse normalmente.
  bool get isUsable => this == ready;
}

/// Capacidad de inicialización explícita.
///
/// Para cualquier pieza del motor cuyo setup no puede (o no debe) ocurrir
/// dentro de su propio constructor — trabajo asíncrono, o setup que
/// depende de que otra pieza ya esté inicializada.
abstract interface class GameInitializable {
  /// Estado actual — ver [GameLifecycleState].
  GameLifecycleState get lifecycleState;

  /// Ejecuta el setup de la pieza. Solo válido cuando
  /// [GameLifecycleState.canInitialize] es `true`.
  Future<void> initialize();
}

/// Capacidad de liberación explícita de recursos.
///
/// Para cualquier pieza del motor que retenga algo que no se limpia solo
/// (un Stream sin cerrar, un Ticker, una suscripción) — ninguna pieza del
/// motor depende del garbage collector para eso.
abstract interface class GameDisposable {
  /// `true` una vez que [dispose] ya se llamó.
  bool get isDisposed;

  /// Libera los recursos de la pieza. Después de llamar a esto, la pieza
  /// no puede volver a usarse.
  void dispose();
}

/// Contrato compuesto para piezas del motor que necesitan inicialización Y
/// destrucción explícitas juntas — el caso más común (ver GameEngine en
/// game_engine_contract.dart, y GameSession en session/game_session.dart
/// como candidato de una futura armonización, no aplicada en este sprint).
abstract interface class GameLifecycle
    implements GameInitializable, GameDisposable {}
