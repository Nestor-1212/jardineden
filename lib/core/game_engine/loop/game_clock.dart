// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/loop/game_clock.dart
//
// RESPONSABILIDAD:
//   Contrato de tiempo transcurrido dentro de una sesión de juego —
//   independiente del reloj real del sistema. Ver game_engine_charter.dart,
//   Objetivo 2 y Filosofía II ("predecible antes que espectacular").
//
// POR QUÉ ES UN CONTRATO APARTE DE GameLoop:
//   GameLoop sabe PRODUCIR ticks; GameClock sabe ACUMULAR tiempo a partir
//   de ellos, con su propia noción de pausa. Mantenerlos separados (SRP)
//   es lo que permite sustituir GameClock por una versión de test —
//   avanzable manualmente con [Duration] arbitrarios, sin ningún
//   [GameLoop] real ni espera asíncrona — para testear lógica de sesión de
//   forma determinística (Regla Arquitectónica 6 del charter).
//
// DEPENDENCIAS PERMITIDAS:   dart:core (Duration).
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12.
// ─────────────────────────────────────────────────────────────────────────────

/// Tiempo transcurrido dentro de una sesión de juego.
///
/// No sabe de dónde vienen los ticks (eso es GameLoop) ni qué es una
/// sesión — solo acumula tiempo y puede pausarse.
abstract interface class GameClock {
  /// Tiempo total transcurrido desde el último [reset], excluyendo
  /// cualquier intervalo en que el reloj estuvo en pausa.
  Duration get elapsed;

  /// `true` mientras el reloj está en pausa — [elapsed] no avanza.
  bool get isPaused;

  /// Pausa el avance de [elapsed]. No-op si [isPaused] ya es `true`.
  void pause();

  /// Reanuda el avance de [elapsed]. No-op si [isPaused] ya es `false`.
  void resume();

  /// Reinicia [elapsed] a [Duration.zero] y sale de cualquier pausa activa.
  void reset();
}
