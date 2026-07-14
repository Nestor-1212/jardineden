// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/session/game_result.dart
//
// RESPONSABILIDAD:
//   Tipo compartido que representa el resultado de una sesión de juego
//   completada. Ver game_engine_charter.dart, Objetivo 4.
//
// POR QUÉ ES UN TIPO Y NO UN CONTRATO:
//   A diferencia de GameLoop/GameClock/GameSession (comportamiento —
//   abstract interface class), GameResult es puro dato inmutable — no hay
//   una segunda implementación concebible de "un resultado", solo valores
//   distintos del mismo. Se declara `final class` (igual que
//   core/logging/log_entry.dart y core/error/result.dart en el resto del
//   proyecto) para dejar explícito que no está pensado para extenderse.
//
// POR QUÉ EL MOTOR NO INTERPRETA score/stars:
//   El motor transporta estos valores, nunca decide qué significan. La
//   escala de score y la regla de cuántas estrellas corresponden a qué
//   desempeño son decisión de cada minijuego — imponerlas aquí acoplaría
//   el motor a una mecánica concreta (ver game_engine_charter.dart,
//   sección 7).
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12. En
//                            particular, ningún feature (economy, stats,
//                            rewards) se importa desde aquí — son ellos
//                            quienes importan GameResult, nunca al revés.
// ─────────────────────────────────────────────────────────────────────────────

/// Resultado de una sesión de juego completada.
///
/// La única forma en que un feature externo a un minijuego (Economy,
/// Stats, Rewards) se entera de lo que pasó, sin conocer la mecánica
/// interna que lo produjo.
final class GameResult {
  const GameResult({
    required this.success,
    required this.score,
    required this.stars,
    required this.elapsed,
  });

  /// `true` si el jugador completó el objetivo del minijuego.
  final bool success;

  /// Puntaje crudo del minijuego. La escala la define cada minijuego — el
  /// motor no la interpreta ni la limita.
  final int score;

  /// Estrellas obtenidas (convención del proyecto: 0 a 3). Cada minijuego
  /// decide cómo se calculan; el motor solo transporta el valor final.
  final int stars;

  /// Tiempo total jugado, tomado de GameClock.elapsed al momento de
  /// completar la sesión.
  final Duration elapsed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameResult &&
          other.success == success &&
          other.score == score &&
          other.stars == stars &&
          other.elapsed == elapsed;

  @override
  int get hashCode => Object.hash(success, score, stars, elapsed);

  @override
  String toString() =>
      'GameResult(success: $success, score: $score, stars: $stars, '
      'elapsed: $elapsed)';
}
