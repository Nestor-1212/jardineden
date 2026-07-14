// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/loop/loop.dart
//
// RESPONSABILIDAD:
//   Barrel file de la carpeta loop/ — el ritmo y el tiempo de una sesión de
//   juego (ver game_engine_charter.dart, Objetivos 1 y 2, y Organización
//   Interna, sección 14).
//
// POR QUÉ ESTA CARPETA EXISTE SEPARADA DE LAS DEMÁS:
//   "Cuándo avanza la lógica de juego" (game loop) y "qué hora es dentro de
//   la sesión" (game clock) son un solo concepto cohesivo: ambos existen
//   para que una sesión de juego progrese de forma determinística e
//   independiente del ciclo de reconstrucción de widgets de Flutter (ver
//   Filosofía II y Regla Arquitectónica 6 del charter). Ninguno de los dos
//   sabe qué es una "sesión" completa (eso vive en session/) ni qué es una
//   "entidad" (eso vive en entities/) — solo saben de tiempo y ritmo. Esa es
//   la frontera de cohesión: todo lo que responde "¿cuándo?" vive aquí;
//   todo lo que responde "¿qué?" o "¿quién?" vive en otra carpeta.
//
// CONTENIDO:
//   game_loop.dart   — contrato GameLoop: produce ticks, sin lógica de
//                      sesión.
//   game_clock.dart  — contrato GameClock: tiempo transcurrido, pausable.
//
//   Las implementaciones (game_loop_impl.dart sobre
//   package:flutter/scheduler.dart, game_clock_impl.dart) NO se crean en
//   este sprint — ver game_engine_charter.dart, Reglas del sprint de
//   abstracciones: solo contratos, sin implementaciones ni lógica.
//
// DEPENDENCIAS PERMITIDAS:   ver el encabezado de cada archivo de esta
//                            carpeta.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción.
// ─────────────────────────────────────────────────────────────────────────────

export 'game_clock.dart';
export 'game_loop.dart';
