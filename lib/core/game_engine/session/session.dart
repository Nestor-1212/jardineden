// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/session/session.dart
//
// RESPONSABILIDAD:
//   Barrel file de la carpeta session/ — el ciclo de vida de una sesión de
//   juego y el contrato de resultado que se entrega al terminar (ver
//   game_engine_charter.dart, Objetivos 3 y 4).
//
// POR QUÉ ESTA CARPETA EXISTE SEPARADA DE LAS DEMÁS:
//   Una sesión es el ÚNICO concepto del motor que conoce los cuatro
//   estados lista → en curso → pausada → completada/abandonada, y es la
//   ÚNICA superficie que el motor expone hacia afuera (Economy, Stats,
//   Rewards consumen el resultado de una sesión, nunca el reloj ni las
//   entidades directamente — ver charter, Responsabilidades). Agrupar
//   sesión y resultado en la misma carpeta refleja que son una sola
//   responsabilidad con dos caras: el ciclo de vida (mientras ocurre) y su
//   salida (cuando termina), no dos conceptos independientes.
//
// CONTENIDO:
//   game_session.dart — contrato GameSession + enum GameSessionStatus:
//                       estado actual y las transiciones válidas entre
//                       ready/running/paused/completed/abandoned.
//   game_result.dart  — tipo GameResult: puntaje, estrellas, tiempo
//                       empleado, éxito/fracaso.
//
//   game_session_impl.dart (implementación real, compuesta sobre un
//   GameLoop y un GameClock de loop/) NO se crea en este sprint — ver
//   game_engine_charter.dart: este sprint es solo contratos y tipos, sin
//   implementaciones.
//
// DEPENDENCIAS PERMITIDAS:   game_session.dart importa game_result.dart
//                            (GameSession expone un GameResult). Nunca al
//                            revés — game_result.dart no sabe que
//                            GameSession existe. Ver el encabezado de cada
//                            archivo.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción. En
//                            particular: GameResult NO puede importar
//                            nada de core/economy ni de ningún feature —
//                            es un tipo de dato neutro, quien lo consume
//                            decide qué hacer con él.
// ─────────────────────────────────────────────────────────────────────────────

export 'game_result.dart';
export 'game_session.dart';
