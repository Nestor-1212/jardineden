// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/entities/game_entity.dart
//
// RESPONSABILIDAD:
//   Contrato mínimo que cualquier participante de una sesión de juego debe
//   cumplir. Ver game_engine_charter.dart, Responsabilidades, y el
//   encabezado de entities/entities.dart.
//
// POR QUÉ NO TIENE POSICIÓN, TAMAÑO NI REPRESENTACIÓN VISUAL:
//   El motor no dibuja nada (game_engine_charter.dart, sección 7) — darle
//   a GameEntity una noción de posición o de widget acoplaría el motor a
//   una forma concreta de presentación antes de que exista un minijuego
//   real contra el cual validar esa forma. Lo único que el motor necesita
//   para coordinar una sesión es poder identificar y rastrear el ciclo de
//   vida de cada participante.
//
// POR QUÉ NO HAY VARIANTES (GameCollectible, GameObstacle, etc.):
//   Diseñarlas ahora sería inventar mecánicas de minijuego sin un
//   minijuego real (Filosofía I del charter: el motor sirve al
//   aprendizaje, no a la especulación arquitectónica). Se agregan, si
//   resultan necesarias, en el sprint del primer minijuego real.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12.
// ─────────────────────────────────────────────────────────────────────────────

/// Estado de ciclo de vida de un [GameEntity] dentro de una sesión.
enum GameEntityStatus {
  /// Participa activamente en la sesión (visible, interactuable).
  active,

  /// Existe en la sesión pero no participa activamente — p. ej. ya fue
  /// resuelta y espera una animación de salida antes de removerse.
  inactive,

  /// Ya no forma parte de la sesión.
  removed,
}

/// Contrato mínimo de cualquier participante de una sesión de juego — un
/// ítem coleccionable, un personaje interactivo, un obstáculo.
///
/// Deliberadamente sin ninguna noción de posición, representación visual
/// ni mecánica — ver el razonamiento en el encabezado de este archivo.
abstract interface class GameEntity {
  /// Identificador estable dentro de la sesión — único mientras la sesión
  /// exista.
  String get id;

  /// Estado de ciclo de vida actual.
  GameEntityStatus get status;
}
