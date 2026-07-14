// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/game_engine_dependency_rules.dart
//
// Este archivo NO contiene código ejecutable. Es el sistema OFICIAL de
// dependencias de Genesis Engine: qué puede depender de qué, qué está
// prohibido, cómo se evitan los ciclos, y cómo se aplica inversión de
// dependencias. game_engine_charter.dart (secciones 11-12) y
// game_engine_responsibilities.dart (secciones 4 y 6) ya establecieron
// reglas generales y verificaron el grafo actual — este archivo las
// consolida en un SISTEMA formal, con capas nombradas, y agrega la pieza
// que faltaba: infraestructura que lo verifica automáticamente, no solo
// documentación que alguien podría dejar de cumplir sin darse cuenta. Ver
// test/core/game_engine/game_engine_dependency_rules_test.dart.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// 1. LAS TRES CAPAS DEL GRAFO DE DEPENDENCIAS INTERNAS
// ─────────────────────────────────────────────────────────────────────────────
//
// Todo archivo de core/game_engine/ pertenece a exactamente una de estas
// tres capas. La capa determina, sin ambigüedad, qué le está permitido
// importar.
//
//   CAPA 0 — Contratos hoja.
//     Viven dentro de una subcarpeta (loop/, session/, entities/, input/,
//     lifecycle/, registry/, events/). NO importan ningún otro archivo de
//     core/game_engine/. Ejemplo: loop/game_loop.dart, entities/game_entity.dart,
//     registry/game_registry.dart.
//
//   CAPA 1 — Composición de carpeta.
//     Viven en la MISMA subcarpeta que lo que importan — nunca cruzan a
//     otra subcarpeta. Ejemplo: session/game_session.dart importa
//     session/game_result.dart (misma carpeta); events/game_event_bus.dart
//     importa events/game_event.dart (misma carpeta).
//
//   CAPA RAÍZ — Coordinación.
//     Vive directamente en core/game_engine/ (no en una subcarpeta).
//     Puede importar de CUALQUIER subcarpeta (Capa 0 o Capa 1). Hoy es un
//     solo archivo: game_engine_contract.dart. NINGÚN archivo de Capa 0 o
//     Capa 1 puede importar la Capa Raíz — la dependencia es de un solo
//     sentido, raíz → hojas, nunca al revés.
//
// Los barrels (loop.dart, session.dart, entities.dart, input.dart,
// lifecycle.dart, registry.dart, events.dart, y el barrel raíz
// game_engine.dart) siguen la MISMA regla de capa que el archivo que los
// contiene: un barrel de subcarpeta solo reexporta su propia carpeta
// (Capa 0/1 exportándose a sí misma); el barrel raíz reexporta todas las
// subcarpetas y game_engine_contract.dart (Capa Raíz reexportando todo).
//
// ─────────────────────────────────────────────────────────────────────────────
// 2. QUÉ PUEDE DEPENDER DE QUÉ (la matriz)
// ─────────────────────────────────────────────────────────────────────────────
//
//   Capa 0  →  nada dentro de core/game_engine/. Solo dart:core y, donde
//             el propio archivo lo documente, dart:async.
//   Capa 1  →  únicamente archivos de Capa 0 de SU MISMA subcarpeta.
//   Raíz    →  archivos de Capa 0 o Capa 1 de CUALQUIER subcarpeta —
//             siempre el archivo específico (game_entity.dart), NUNCA el
//             barrel de esa carpeta (entities.dart). Ver sección 3 para
//             el porqué de esta distinción.
//
//   Fuera de core/game_engine/: ver game_engine_charter.dart, secciones
//   11-12 — dart:core, dart:async, y (únicamente en una futura
//   *_impl.dart de loop/) package:flutter/scheduler.dart. Nada más, para
//   ninguna capa.
//
// ─────────────────────────────────────────────────────────────────────────────
// 3. QUÉ ESTÁ PROHIBIDO
// ─────────────────────────────────────────────────────────────────────────────
//
//   1. Cualquier archivo de core/game_engine/ importando lib/features/ —
//      sin excepción, para cualquier capa (game_engine_charter.dart,
//      sección 12).
//   2. Cualquier archivo importando flutter_riverpod, flutter/material.dart,
//      flutter/cupertino.dart o go_router — el motor es agnóstico del
//      framework de estado y no dibuja nada.
//   3. Un archivo de Capa 0 o Capa 1 importando la Capa Raíz
//      (game_engine_contract.dart) — invertiría la única dirección
//      permitida del grafo.
//   4. Un archivo de Capa 1 importando una subcarpeta DISTINTA a la suya
//      (p. ej. session/game_session.dart importando algo de entities/) —
//      si dos subcarpetas necesitan coordinarse, esa coordinación es
//      trabajo de la Capa Raíz, nunca de una Capa 1 hablando con otra
//      directamente.
//   5. UN ARCHIVO DE CAPA RAÍZ IMPORTANDO EL BARREL DE UNA SUBCARPETA EN
//      VEZ DEL ARCHIVO ESPECÍFICO — los barrels son para consumidores
//      EXTERNOS a core/game_engine/ (un feature de minijuego futuro). Un
//      archivo interno que importa su propio barrel es una dependencia
//      circular en potencia apenas ese barrel crezca (el barrel raíz
//      reexporta a game_engine_contract.dart — si este importara el
//      barrel de una subcarpeta y esa subcarpeta terminara reexportando
//      algo que reexporta el barrel raíz, se cierra un ciclo). Importar
//      el archivo específico elimina el riesgo estructuralmente, no solo
//      por disciplina.
//
// ─────────────────────────────────────────────────────────────────────────────
// 4. CÓMO SE EVITAN LAS DEPENDENCIAS CIRCULARES
// ─────────────────────────────────────────────────────────────────────────────
//
// La respuesta corta: la Regla de Capas (sección 1) hace que un ciclo sea
// ESTRUCTURALMENTE imposible, no solo improbable:
//   • Capa 0 no importa nada interno → no puede participar en un ciclo.
//   • Capa 1 solo importa Capa 0 de su misma carpeta → como Capa 0 nunca
//     importa nada, esta relación nunca puede "devolverse".
//   • Raíz solo importa Capa 0/1 → como ninguna de las dos importa nunca
//     la Raíz, esta relación tampoco puede devolverse.
//
// La respuesta larga, y la razón de que este archivo no sea solo un
// argumento en prosa: test/core/game_engine/game_engine_dependency_rules_test.dart
// construye el grafo real de imports leyendo cada archivo de
// core/game_engine/, y verifica mecánicamente:
//   1. Que ningún archivo de core/game_engine/ importe lib/features/,
//      flutter_riverpod, flutter/material.dart, flutter/cupertino.dart ni
//      go_router (sección 3, prohibiciones 1-2).
//   2. Que ningún archivo importe game_engine_contract.dart (prohibición 3).
//   3. Que ningún archivo de una subcarpeta importe de OTRA subcarpeta
//      (prohibición 4) — la única excepción permitida es el archivo raíz.
//   4. Que el grafo completo sea acíclico (detección de ciclos por DFS),
//      como red de seguridad ante cualquier violación futura que las tres
//      reglas anteriores no hayan previsto explícitamente.
//
// Este test corre en cada `flutter test` (tag `unit`, sin bindings de
// Flutter) — un ciclo o una dependencia prohibida rompe el build ese mismo
// día, no se descubre meses después al intentar entender por qué un
// archivo no compila.
//
// ─────────────────────────────────────────────────────────────────────────────
// 5. CÓMO SE APLICA INVERSIÓN DE DEPENDENCIAS (DIP)
// ─────────────────────────────────────────────────────────────────────────────
//
// Ya aplicado en la práctica, no solo declarado — tres ejemplos concretos
// del código real:
//
//   1. GameEngine (game_engine_contract.dart) depende de GameSession,
//      GameRegistry<GameEntity> y GameEventBus — los TRES son interfaces
//      (`abstract interface class`), nunca una implementación concreta.
//      Hoy no existe ninguna `*Impl` — cuando exista, GameEngine seguirá
//      sin conocerla: solo conoce el contrato.
//   2. GameRegistry<T> es genérico sin restricción sobre T — no depende
//      de "saber qué es una entidad", invierte esa dependencia: quien lo
//      use decide qué tipo registra.
//   3. GameEventBus transporta GameEvent sin conocer ningún evento
//      concreto — igual que GameCommand (input/game_command.dart): el
//      motor depende de la FORMA abstracta, cada consumidor futuro aporta
//      el contenido concreto.
//
// DÓNDE VIVIRÁ LA IMPLEMENTACIÓN (pregunta que quedaba abierta desde
// game_engine_charter.dart — se resuelve aquí):
//   Siguiendo el patrón YA establecido en el resto del proyecto para
//   cada core/<tema>/ (ver code_conventions.dart, sección 2: contrato en
//   core/<tema>/, implementación + provider de Riverpod en
//   core/infrastructure/<tema>/), las implementaciones futuras de
//   GameLoop, GameClock, GameSession, GameRegistry y GameEventBus vivirán
//   en core/infrastructure/game_engine/ — NUNCA dentro de
//   core/game_engine/. Esa es, precisamente, la capa de adaptación que
//   game_engine_charter.dart (sección 1) dejó pendiente: es
//   core/infrastructure/game_engine/ quien podrá importar
//   flutter_riverpod y package:flutter/scheduler.dart, exponer
//   gameEngineProvider, y ensamblar las implementaciones concretas detrás
//   de los contratos — sin que core/game_engine/ necesite cambiar una
//   sola línea cuando eso ocurra (Open/Closed, aplicado de nuevo).
// ─────────────────────────────────────────────────────────────────────────────
