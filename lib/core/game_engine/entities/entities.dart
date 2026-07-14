// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/entities/entities.dart
//
// RESPONSABILIDAD:
//   Barrel file de la carpeta entities/ — el contrato que cualquier
//   ítem, personaje interactivo u obstáculo de un minijuego debe cumplir
//   para participar en una sesión de juego (ver game_engine_charter.dart,
//   Responsabilidades, sección 4).
//
// POR QUÉ ESTA CARPETA EXISTE SEPARADA DE LAS DEMÁS:
//   Una entidad responde "¿qué o quién participa?", nunca "¿cuándo?"
//   (eso es loop/) ni "¿cómo termina la sesión?" (eso es session/). El
//   motor no sabe ni le importa si una entidad es una oveja perdida, una
//   carta de memoria o un ítem de arrastrar-soltar — ver
//   game_engine_charter.dart, sección 7 ("qué problemas NO resolverá"): el
//   motor no conoce ninguna mecánica de minijuego concreta. Esta carpeta
//   define el contrato mínimo y genérico de "participar en una sesión", no
//   ninguna entidad real.
//
// CONTENIDO:
//   game_entity.dart — contrato GameEntity + enum GameEntityStatus: el
//                      conjunto mínimo de capacidades que el motor
//                      necesita de cualquier participante (identidad
//                      estable, ciclo de vida propio) — sin imponer NADA
//                      sobre su representación visual, posición en
//                      pantalla o mecánica.
//
//   Deliberadamente un solo contrato por ahora: no se definen variantes
//   (GameCollectible, GameObstacle, etc.) porque hacerlo hoy sería diseñar
//   mecánicas de minijuego sin tener un minijuego real contra el cual
//   validar el contrato (ver Filosofía I — el motor sirve al aprendizaje,
//   no a la especulación arquitectónica). Esas variantes, si resultan
//   necesarias, se agregan en el sprint del primer minijuego real, contra
//   un caso de uso concreto.
//
// DEPENDENCIAS PERMITIDAS:   ver el encabezado de game_entity.dart.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción.
// ─────────────────────────────────────────────────────────────────────────────

export 'game_entity.dart';
