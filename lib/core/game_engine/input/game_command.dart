// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/input/game_command.dart
//
// RESPONSABILIDAD:
//   Contrato base de cualquier comando de juego — la intención semántica
//   ya traducida de un gesto crudo de Flutter. Ver
//   game_engine_charter.dart, Objetivo 5.
//
// POR QUÉ NO HAY VARIANTES CONCRETAS (SelectCommand, DragCommand, etc.):
//   Misma razón que entities/game_entity.dart: inventar el vocabulario de
//   comandos ahora sería diseñar mecánicas de minijuego sin un minijuego
//   real. Cada minijuego futuro define sus propios comandos implementando
//   este contrato — el motor no necesita cambiar para soportarlos
//   (Open/Closed, game_engine_charter.dart sección 8).
//
// POR QUÉ NO HAY UN TIPO DE POSICIÓN/COORDENADA AQUÍ:
//   Un comando como "mover a una posición" necesitaría un tipo de
//   coordenada — pero `dart:ui`/`Offset` no está en las dependencias
//   permitidas del motor (game_engine_charter.dart, sección 11) y
//   definir un tipo de vector propio sin un comando real que lo necesite
//   sería la misma especulación que se evita en game_entity.dart. Se
//   diseña junto con el primer comando concreto que de verdad lo requiera.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12. En
//                            particular, ni siquiera dart:ui — el gesto
//                            crudo nunca cruza hacia el motor, solo el
//                            comando ya traducido.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato base de cualquier comando de juego.
///
/// El motor no conoce ningún comando concreto — cada minijuego futuro
/// define su propio vocabulario implementando esta interfaz.
abstract interface class GameCommand {
  /// Identificador semántico del tipo de comando (p. ej. `'select'`,
  /// `'drag'`). Cadena y no un enum cerrado porque el motor no impone un
  /// catálogo fijo de comandos — cada minijuego define el suyo.
  String get type;
}
