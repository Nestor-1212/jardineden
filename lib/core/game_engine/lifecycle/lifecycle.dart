// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/lifecycle/lifecycle.dart
//
// RESPONSABILIDAD:
//   Barrel file de la carpeta lifecycle/ — el vocabulario común de
//   inicialización y destrucción que cualquier pieza del motor con setup/
//   liberación explícitos puede implementar.
//
// POR QUÉ ESTA CARPETA EXISTE (EXTENSIÓN AL ÁRBOL PLANEADO EN EL CHARTER):
//   game_engine_charter.dart, sección 14, planeó originalmente solo
//   loop/, session/, entities/, input/ — "ciclo de vida", "inicialización"
//   y "destrucción" no tenían carpeta propia porque el charter asumía que
//   cada pieza (GameLoop, GameSession) resolvería su propio ciclo de vida
//   de forma aislada. El sprint de "Contratos Oficiales" identificó que
//   ESO es exactamente lo que se quería evitar: sin un contrato compartido,
//   cada pieza futura inventaría su propio vocabulario de "inicializar"/
//   "destruir". Esta carpeta es la extensión correspondiente — ver la
//   entrada de changelog en game_engine_charter.dart, sección 14.
//
// CONTENIDO:
//   game_lifecycle.dart — enum GameLifecycleState + contratos
//                         GameInitializable, GameDisposable, GameLifecycle
//                         (compuesto).
//
// DEPENDENCIAS PERMITIDAS:   ver el encabezado de game_lifecycle.dart.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción.
// ─────────────────────────────────────────────────────────────────────────────

export 'game_lifecycle.dart';
