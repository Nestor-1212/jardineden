// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/game_engine_developer_guide.dart
//
// RESPONSABILIDAD:
//   Puerta de entrada para cualquier desarrollador que toque Genesis
//   Engine por primera vez. Sintetiza y conecta los cinco documentos que
//   ya existen — NO los reemplaza ni repite su razonamiento profundo, cada
//   sección apunta a la fuente autoritativa para quien necesite el "por
//   qué" completo. Este archivo responde una pregunta distinta: "¿por
//   dónde empiezo y cómo encajan las piezas entre sí?"
//
// ESTE ARCHIVO NO SE EXPORTA DESDE game_engine.dart (el barrel) — mismo
// motivo que game_engine_charter.dart: es documentación para humanos, no
// superficie de API en tiempo de ejecución.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// EMPIEZA AQUÍ — 60 SEGUNDOS
// ─────────────────────────────────────────────────────────────────────────────
//
// Genesis Engine es la infraestructura común que cualquier minijuego
// educativo de Jardín del Edén usará para manejar su ritmo, su ciclo de
// vida y su comunicación con el resto de la app — sin que el motor sepa
// qué minijuego es, y sin que un minijuego futuro necesite reinventar
// "cómo se pausa" o "cómo se le avisa a Economy que terminé".
//
// HOY (al momento de escribir esta guía) el motor es SOLO contratos —
// interfaces, tipos de dato, enums — cero implementaciones, cero
// widgets, cero conexión a Riverpod. Ver "Qué NO existe todavía" al final
// de este archivo antes de asumir que algo funciona en runtime.
//
// ─────────────────────────────────────────────────────────────────────────────
// MAPA DE DOCUMENTOS — a cuál ir según lo que necesitas
// ─────────────────────────────────────────────────────────────────────────────
//
//   ¿Por qué existe el motor y qué NO debe hacer nunca?
//     → game_engine_charter.dart
//
//   ¿Qué responsabilidad tiene EXACTAMENTE cada tipo, en términos de DDD?
//     → game_engine_responsibilities.dart
//
//   ¿Puedo importar X desde Y? ¿Cómo evito un ciclo?
//     → game_engine_dependency_rules.dart
//     → test/core/game_engine/game_engine_dependency_rules_test.dart
//       (lo verifica automáticamente en cada `flutter test`)
//
//   Voy a escribir un contrato nuevo — ¿qué reglas y convenciones aplico?
//     → game_engine_quality_rules.dart
//
//   Soy nuevo en este módulo y no sé por dónde empezar.
//     → ESTE ARCHIVO.
//
// ─────────────────────────────────────────────────────────────────────────────
// ARQUITECTURA (resumen — el detalle y el porqué viven en el charter)
// ─────────────────────────────────────────────────────────────────────────────
//
// Clean Architecture + SOLID + Feature First + DDD, aplicados a un motor
// de juego, no a una app CRUD:
//   • El motor vive en core/ — nunca en features/. La dirección de
//     dependencia es de un solo sentido: un feature de minijuego futuro
//     dependerá del motor, el motor JAMÁS de un feature.
//   • Es agnóstico de Flutter y de Riverpod — solo contratos Dart puros
//     (con una única excepción documentada y aislada a un solo archivo
//     futuro: package:flutter/scheduler.dart dentro de loop/).
//   • Cada pieza (loop, clock, session, entity, command, event, registry,
//     lifecycle) tiene una sola responsabilidad y se compone con las
//     demás por inyección/composición — nunca por herencia de una clase
//     concreta (no existe ninguna todavía).
//
// ─────────────────────────────────────────────────────────────────────────────
// RESPONSABILIDADES (tabla resumen — la clasificación DDD completa está
// en game_engine_responsibilities.dart)
// ─────────────────────────────────────────────────────────────────────────────
//
//   GameEngine       → coordina todo detrás de una sola fachada.
//   GameSession      → el ciclo de vida de UNA partida (Aggregate Root).
//   GameResult       → el desenlace de una sesión terminada (Value Object).
//   GameEntity       → identidad + ciclo de vida de un participante (Entity).
//   GameCommand      → una intención ya traducida de un gesto.
//   GameEvent        → un hecho ya ocurrido (Domain Event).
//   GameEventBus      → cómo viaja un GameEvent entre piezas que no se
//                     conocen.
//   GameRegistry<T>  → registro genérico por id (Repository en memoria,
//                     nunca persistente).
//   GameLoop         → produce ticks.
//   GameClock        → acumula tiempo, pausable.
//   GameLifecycle*   → vocabulario común de inicialización/destrucción.
//
// ─────────────────────────────────────────────────────────────────────────────
// ORGANIZACIÓN (el árbol — el playbook para agregar una carpeta nueva
// está en game_engine_quality_rules.dart, sección 5)
// ─────────────────────────────────────────────────────────────────────────────
//
//   core/game_engine/
//   ├── game_engine.dart                 barrel raíz — importa esto desde
//   │                                    afuera del motor, nunca las rutas
//   │                                    internas.
//   ├── game_engine_contract.dart         GameEngine — coordina todo.
//   ├── game_engine_charter.dart          identidad (no se exporta).
//   ├── game_engine_responsibilities.dart  DDD (no se exporta).
//   ├── game_engine_dependency_rules.dart  dependencias (no se exporta).
//   ├── game_engine_quality_rules.dart     calidad (no se exporta).
//   ├── game_engine_developer_guide.dart   este archivo (no se exporta).
//   ├── loop/           ritmo y tiempo — GameLoop, GameClock.
//   ├── session/        ciclo de vida + desenlace — GameSession, GameResult.
//   ├── entities/       participantes — GameEntity.
//   ├── input/          intención traducida — GameCommand.
//   ├── lifecycle/       init/dispose genéricos — GameLifecycle y sus
//   │                    dos mitades.
//   ├── registry/        registro genérico — GameRegistry<T>.
//   └── events/          qué es un evento y cómo viaja — GameEvent,
//                       GameEventBus.
//
// ─────────────────────────────────────────────────────────────────────────────
// CONVENCIONES (referencia rápida — el porqué de cada una está en
// game_engine_quality_rules.dart y game_engine_charter.dart, sección 13)
// ─────────────────────────────────────────────────────────────────────────────
//
//   • Prefijo `Game` en todo concepto de nivel de motor.
//   • Sin prefijo `I` en contratos (convención de servicios, no de
//     repositorios).
//   • Enums de estado terminan en `Status` — EXCEPTO GameLifecycleState,
//     una inconsistencia heredada y documentada, no un patrón a copiar
//     (ver game_engine_quality_rules.dart, sección 4).
//   • Booleanos con is/has/can (`isRunning`, `canInitialize`).
//   • Un contrato por archivo; su enum/typedef compañero inseparable
//     puede compartir archivo.
//
// ─────────────────────────────────────────────────────────────────────────────
// DEPENDENCIAS (la regla de oro — la matriz completa y el test que la
// verifica están en game_engine_dependency_rules.dart)
// ─────────────────────────────────────────────────────────────────────────────
//
//   Los contratos "hoja" (dentro de una subcarpeta) no importan nada
//   interno. Un contrato puede importar otro de SU MISMA subcarpeta. Solo
//   GameEngine (en la raíz) importa a través de subcarpetas — y siempre
//   el archivo específico, nunca el barrel de esa subcarpeta. Nadie
//   importa a GameEngine desde dentro del motor. Esto hace que un ciclo
//   sea estructuralmente imposible, no solo una regla de buena conducta —
//   y hay un test que lo verifica en cada `flutter test`.
//
// ─────────────────────────────────────────────────────────────────────────────
// FLUJOS — cómo se ve usar el motor en la práctica (conceptual: no hay
// implementación real todavía, esto describe cómo INTERACTÚAN los
// contratos, no código que se pueda ejecutar hoy)
// ─────────────────────────────────────────────────────────────────────────────
//
// FLUJO 1 — Arrancar el motor y jugar una sesión completa:
//   1. La app (fuera de core/game_engine/, en la futura capa de
//      composición de core/infrastructure/game_engine/) crea un
//      GameEngine y llama `initialize()` (GameLifecycle) una sola vez,
//      normalmente al entrar a la pantalla de selección de minijuego.
//   2. Un minijuego llama `engine.startSession()` → se crea una
//      GameSession en estado `ready`, `engine.entities` se vacía, y el
//      minijuego empieza a registrar sus propias GameEntity ahí.
//   3. El minijuego llama `session.start()` → estado `running`. Por
//      dentro (detalle de una implementación futura, no expuesto por el
//      contrato), esto arranca un GameLoop y un GameClock.
//   4. Mientras el jugador interactúa: gestos de Flutter se traducen a
//      GameCommand en la capa de presentación del minijuego (NUNCA dentro
//      del motor) y se aplican a las GameEntity registradas.
//   5. El minijuego decide que terminó → llama
//      `session.complete(GameResult(...))` → estado `completed`,
//      `session.result` queda disponible.
//   6. GameEngine publica un GameEvent en `engine.events` (p. ej.
//      `type: 'session_completed'`). Economy/Stats/Rewards, suscritos de
//      antemano vía `subscribe()`, reaccionan sin que GameEngine sepa que
//      existen.
//   7. La próxima llamada a `startSession()` reemplaza la sesión anterior
//      y vacía `entities` — un minijuego nunca hereda entidades de la
//      sesión previa.
//
// FLUJO 2 — Pausar y reanudar:
//   1. `session.pause()` → estado `paused`. Conceptualmente, esto detiene
//      el GameLoop interno y pausa el GameClock (dos pasos separados
//      porque son dos contratos separados — ver
//      game_engine_dependency_rules.dart, sección 1).
//   2. `session.resume()` → estado `running` de nuevo, el GameClock sigue
//      contando desde donde quedó (nunca desde cero).
//   3. Si el jugador sale del minijuego mientras está pausado,
//      `session.abandon()` → estado `abandoned`, sin GameResult — GameEngine
//      lo distingue de `completed` para que Stats no cuente una sesión
//      abandonada como jugada de verdad.
//
// FLUJO 3 — Un comando llega y un evento sale:
//   1. Un gesto de Flutter (p. ej. tocar una oveja perdida) se traduce,
//      en la capa de presentación del minijuego, a un GameCommand
//      concreto propio de ese minijuego (p. ej. algo como "seleccionar
//      entidad").
//   2. El motor nunca ve el gesto crudo — solo recibiría el GameCommand
//      ya traducido, si el minijuego decide pasárselo a alguna pieza del
//      motor (hoy ningún contrato del motor CONSUME un GameCommand
//      directamente — es una forma de dato que un minijuego futuro usa
//      internamente o publica junto a un GameEvent relacionado).
//   3. Si esa acción resulta en un hecho relevante para afuera (p. ej.
//      "el jugador encontró la oveja"), el minijuego publica un GameEvent
//      propio a través de `engine.events` — otra vez, sin que el motor
//      conozca ese evento de antemano.
//
// ─────────────────────────────────────────────────────────────────────────────
// BUENAS PRÁCTICAS — checklist antes de escribir tu primer contrato
// (el detalle completo está en game_engine_quality_rules.dart)
// ─────────────────────────────────────────────────────────────────────────────
//
//   [ ] ¿Es un concepto de motor genuino (Capa 0/1) o en realidad es una
//       mecánica de minijuego que pertenece a features/?
//   [ ] ¿Tu contrato tiene una sola responsabilidad, o son dos disfrazadas
//       de una?
//   [ ] ¿Documentaste el PORQUÉ, no solo el qué, en el encabezado?
//   [ ] ¿Corriste test/core/game_engine/game_engine_dependency_rules_test.dart?
//   [ ] ¿Tu archivo nuevo importa solo lo permitido (dart:core, dart:async,
//       y archivos de tu misma subcarpeta)?
//   [ ] ¿Actualizaste el barrel de tu carpeta (y el raíz, si la carpeta es
//       nueva)?
//
// ─────────────────────────────────────────────────────────────────────────────
// ESCALABILIDAD (la prueba, no la promesa — el detalle está en
// game_engine_quality_rules.dart, sección 6)
// ─────────────────────────────────────────────────────────────────────────────
//
//   lifecycle/, registry/ y events/ se agregaron completas sin modificar
//   una sola línea de loop/, session/, entities/ ni input/ (los contratos
//   del sprint anterior a ellas). Si necesitas agregar un concepto nuevo,
//   ese es el estándar a seguir: aditivo, nunca invasivo.
//
// ─────────────────────────────────────────────────────────────────────────────
// QUÉ NO EXISTE TODAVÍA (para no asumir de más)
// ─────────────────────────────────────────────────────────────────────────────
//
//   ✗ Ninguna implementación (`*_impl.dart`) de ningún contrato.
//   ✗ Ninguna conexión a Riverpod ni provider — vivirá en
//     core/infrastructure/game_engine/ cuando se construya (ver
//     game_engine_dependency_rules.dart, sección 5).
//   ✗ Ningún minijuego real que consuma el motor — features/minigame/
//     sigue siendo una carpeta vacía.
//   ✗ Ningún tipo de coordenada/posición propio del motor — se diseña
//     junto con el primer comando concreto que de verdad lo necesite (ver
//     input/game_command.dart).
//   ✗ Variantes concretas de GameEntity o GameCommand — se agregan en el
//     sprint del primer minijuego real, no antes.
// ─────────────────────────────────────────────────────────────────────────────
