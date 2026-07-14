// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/game_engine.dart
//
// RESPONSABILIDAD:
//   Barrel file raíz de Genesis Engine — el único archivo que un feature de
//   minijuego futuro debería necesitar importar para acceder a todo el
//   motor:
//     import 'package:jardindeleden/core/game_engine/game_engine.dart';
//   En vez de conocer la ruta interna de cada contrato individual. El mismo
//   patrón que core/theme/design_tokens.dart ya usa para el Design System.
//
// ESTADO ACTUAL:
//   Reexporta los 7 barrels de subcarpeta (entities/, events/,
//   lifecycle/, loop/, registry/, session/, input/) más
//   game_engine_contract.dart, el contrato raíz que coordina todo lo
//   demás. Todos exponen ya contratos y tipos reales — sin
//   implementaciones (ver game_engine_charter.dart: este módulo sigue
//   siendo solo contratos).
//
// QUÉ NO EXPORTA A PROPÓSITO:
//   game_engine_charter.dart — es documentación de arquitectura para
//   desarrolladores, no superficie pública en tiempo de ejecución. Un
//   barrel exporta API; el charter se lee directamente en el editor o se
//   referencia por ruta, nunca se "importa" como si fuera código consumible.
//
// SOBRE "NAMESPACES" EN ESTE MÓDULO:
//   Dart no tiene namespaces como C#/Java — el namespace real de cada
//   símbolo es la ruta de import completa
//   (package:jardindeleden/core/game_engine/loop/game_loop.dart). Este
//   proyecto tampoco usa directivas `library` en ningún otro archivo (ver
//   core/theme/, core/error/) — Genesis Engine no introduce un patrón
//   nuevo aquí. Lo que SÍ actúa como namespace lógico es:
//     1. La ruta de carpeta (core/game_engine/<tema>/...).
//     2. El prefijo `Game` en el nombre de cada clase (ver
//        game_engine_charter.dart, sección 13).
//
// DEPENDENCIAS PERMITIDAS:   los 7 barrels de subcarpeta +
//                            game_engine_contract.dart, todos de este
//                            mismo módulo.
// DEPENDENCIAS PROHIBIDAS:   cualquier cosa fuera de core/game_engine/ —
//                            ver game_engine_charter.dart, secciones 11-12,
//                            para la lista completa aplicable a todo el
//                            motor.
// ─────────────────────────────────────────────────────────────────────────────

export 'entities/entities.dart';
export 'events/events.dart';
export 'game_engine_contract.dart';
export 'input/input.dart';
export 'lifecycle/lifecycle.dart';
export 'loop/loop.dart';
export 'registry/registry.dart';
export 'session/session.dart';
