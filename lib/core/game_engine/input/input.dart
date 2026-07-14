// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/input/input.dart
//
// RESPONSABILIDAD:
//   Barrel file de la carpeta input/ — la traducción de gestos crudos de
//   Flutter (tap, drag, swipe) a comandos de juego semánticos (ver
//   game_engine_charter.dart, Objetivo 5).
//
// POR QUÉ ESTA CARPETA EXISTE SEPARADA DE LAS DEMÁS:
//   Es la única frontera del motor que mira "hacia adentro" desde el
//   mundo de gestos físicos de Flutter en vez de hacia el ritmo (loop/),
//   el ciclo de vida (session/) o los participantes (entities/) de una
//   sesión. Aislar la traducción de gesto → intención aquí es lo que
//   permite que un minijuego futuro razone en términos de "el jugador
//   seleccionó la oveja perdida", no en términos de coordenadas de
//   pantalla — y es lo que permite testear la lógica de un minijuego sin
//   simular gestos reales de Flutter (se le inyecta un GameCommand
//   directamente).
//
// CONTENIDO:
//   game_command.dart — contrato GameCommand: la forma mínima de la
//                       intención semántica ya traducida (un `type`
//                       identificador) que la lógica de un minijuego
//                       consume — nunca un TapDownDetails ni un Offset
//                       crudo de Flutter. Sin variantes concretas todavía
//                       (ni comandos de selección ni de arrastre) por la
//                       misma razón que entities/game_entity.dart no
//                       define variantes — ver su encabezado.
//
//   La traducción EN SÍ (de gesto de Flutter a GameCommand) vive en la
//   capa de presentación del feature de minijuego que la use, no en el
//   motor — el motor solo define la FORMA del comando resultante, nunca
//   escucha un GestureDetector directamente (ver
//   game_engine_charter.dart, Regla Arquitectónica 5: el motor no expone
//   widgets ni depende de ellos).
//
// DEPENDENCIAS PERMITIDAS:   ver el encabezado de game_command.dart.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12 —
//                            en particular, ni siquiera este módulo importa
//                            flutter/gestures.dart: el gesto crudo nunca
//                            cruza hacia el motor, solo el comando ya
//                            traducido.
// ─────────────────────────────────────────────────────────────────────────────

export 'game_command.dart';
