// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/events/events.dart
//
// RESPONSABILIDAD:
//   Barrel file de la carpeta events/ — qué es un evento del motor
//   (game_event.dart) y cómo viaja entre piezas que no se conocen
//   directamente entre sí (game_event_bus.dart).
//
// POR QUÉ ESTA CARPETA EXISTE (EXTENSIÓN AL ÁRBOL PLANEADO EN EL CHARTER):
//   No estaba en el plan original de game_engine_charter.dart, sección 14.
//   El sprint de "Contratos Oficiales" pidió explícitamente "Eventos" y
//   "Comunicación" como conceptos propios — game_event.dart resuelve el
//   primero (QUÉ es un evento), game_event_bus.dart el segundo (CÓMO viaja)
//   — ver la entrada de changelog en el charter, sección 14.
//
// CONTENIDO:
//   game_event.dart      — contrato base GameEvent.
//   game_event_bus.dart  — typedef GameEventListener + contrato
//                         GameEventBus (publicar/suscribir).
//
// DEPENDENCIAS PERMITIDAS:   ver el encabezado de cada archivo de esta
//                            carpeta.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción.
// ─────────────────────────────────────────────────────────────────────────────

export 'game_event.dart';
export 'game_event_bus.dart';
