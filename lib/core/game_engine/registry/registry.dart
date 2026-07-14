// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/registry/registry.dart
//
// RESPONSABILIDAD:
//   Barrel file de la carpeta registry/ — el mecanismo de registro
//   genérico que el motor usa para rastrear instancias de un tipo (p. ej.
//   las GameEntity activas de una sesión) sin conocer implementaciones
//   concretas.
//
// POR QUÉ ESTA CARPETA EXISTE (EXTENSIÓN AL ÁRBOL PLANEADO EN EL CHARTER):
//   No estaba en el plan original de game_engine_charter.dart, sección 14.
//   El sprint de "Contratos Oficiales" identificó que GameEngine
//   (game_engine_contract.dart) necesita una forma de rastrear las
//   entidades activas de una sesión sin acoplarse a una lista concreta —
//   ver la entrada de changelog en el charter, sección 14.
//
// CONTENIDO:
//   game_registry.dart — contrato genérico GameRegistry<T>.
//
// DEPENDENCIAS PERMITIDAS:   ver el encabezado de game_registry.dart.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción.
// ─────────────────────────────────────────────────────────────────────────────

export 'game_registry.dart';
