// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/game_engine_responsibilities.dart
//
// Este archivo NO contiene código ejecutable. Es el LEDGER DE
// RESPONSABILIDADES de Genesis Engine: para cada componente que existe hoy
// (ver game_engine_charter.dart para el porqué de cada uno, y
// game_engine_contract.dart para cómo se coordinan) define, sin
// ambigüedad, qué hace, qué NUNCA debe hacer, cómo evita acoplarse a los
// demás, y cómo mantiene su cohesión interna. Aplica SOLID, Clean
// Architecture, Feature First y DDD — no como cuatro secciones separadas,
// sino como el mismo lente aplicado a cada componente real, uno por uno.
//
// Por qué existe un archivo aparte del charter: game_engine_charter.dart
// define la identidad y las reglas GENERALES del motor (una sola vez,
// antes de que el motor tuviera componentes). Este archivo cataloga los
// componentes que YA EXISTEN, uno por uno — es la vista "por componente",
// no la vista "del motor completo". Se referencian mutuamente, no se
// repiten.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// 1. LENGUAJE UBICUO Y CONTEXTO DELIMITADO (DDD)
// ─────────────────────────────────────────────────────────────────────────────
//
// Genesis Engine es su propio CONTEXTO DELIMITADO (Bounded Context) dentro
// de Jardín del Edén: un vocabulario cerrado que significa exactamente lo
// mismo en cada archivo de core/game_engine/, y que NO se mezcla con el
// vocabulario de ningún feature (p. ej. "entidad" aquí nunca significa
// "fila de base de datos", que es el sentido de "Entity"/"Model" en
// features/<feature>/domain|data — dos contextos delimitados distintos,
// cada uno con su propio significado para palabras parecidas).
//
// GLOSARIO (lenguaje ubicuo de este contexto — usar estas palabras y
// solo con este significado en cualquier código o discusión sobre el
// motor):
//   Loop      — lo que produce ticks. Nunca "el juego".
//   Clock     — cuánto tiempo de juego transcurrió. Nunca el reloj real.
//   Session   — una partida de un minijuego, de principio a fin.
//   Entity    — un participante con identidad dentro de una Session.
//   Command   — una intención ya traducida de un gesto físico.
//   Event     — un hecho ya ocurrido que otras piezas pueden reaccionar.
//   Result    — el desenlace de una Session terminada.
//   Registry  — dónde se rastrean las Entity activas de la Session actual.
//   Engine    — la fachada que coordina todo lo anterior.
//
// ─────────────────────────────────────────────────────────────────────────────
// 2. CLASIFICACIÓN DDD DE CADA TIPO
// ─────────────────────────────────────────────────────────────────────────────
//
//   GameEntity   → ENTITY (DDD). Tiene identidad (`id`) que persiste a
//                 través de cambios de estado (`status`). Dos GameEntity
//                 con los mismos valores pero distinto `id` son
//                 DISTINTAS — la identidad es lo que importa, no el valor.
//
//   GameResult   → VALUE OBJECT (DDD). Sin identidad — dos GameResult con
//                 los mismos success/score/stars/elapsed son
//                 INTERCAMBIABLES (de ahí su `==`/`hashCode` por valor).
//                 Inmutable por diseño (todos sus campos son `final`).
//
//   GameEvent    → DOMAIN EVENT (DDD, término literal). Representa que
//                 algo YA ocurrió — de ahí que GameEventBus solo lo
//                 PUBLICA hacia el futuro (ver game_event_bus.dart: "nunca
//                 en publicaciones pasadas"), nunca lo reinterpreta ni lo
//                 revierte.
//
//   GameCommand  → objeto de intención (paralelo al "Command" de
//                 CQRS/DDD aplicado). A diferencia de un Event, representa
//                 algo que TODAVÍA NO ocurrió — es una petición, que quien
//                 la reciba puede aceptar o ignorar.
//
//   GameSession  → AGGREGATE ROOT (DDD). Es la única entrada consistente
//                 para todo lo que pasa DENTRO de una partida — todas las
//                 transiciones de estado pasan por sus métodos
//                 (start/pause/resume/complete/abandon), nunca por un
//                 setter directo (ver el razonamiento ya documentado en
//                 game_session.dart). Ver sección 5 para una tensión real
//                 de este diseño con el aislamiento estricto de Aggregate.
//
//   GameEngine   → no es parte del DOMINIO del juego en sí — es el
//                 SERVICIO DE APLICACIÓN (Application Service, DDD) que
//                 expone el Bounded Context completo hacia afuera. Un
//                 feature de minijuego habla con GameEngine, nunca
//                 reconstruye sus piezas internas por su cuenta.
//
//   GameLoop,
//   GameClock    → DOMAIN SERVICES (DDD): comportamiento puro, sin
//                 identidad propia ni estado de negocio — existen para dar
//                 servicio a GameSession, no para representar un concepto
//                 del dominio del juego en sí mismos.
//
//   GameRegistry<T> → un REPOSITORY EN MEMORIA, nunca persistente. Aclarar
//                 esto es crítico: GameRegistry NO reemplaza ni compite
//                 con core/storage/ ni core/infrastructure/database/ — se
//                 vacía al terminar cada Session (ver la nota de
//                 game_engine_contract.dart sobre `entities`) y no
//                 sobrevive un reinicio de la app.
//
//   GameLifecycle
//   (y sus dos mitades) → no pertenecen al lenguaje de DOMINIO del juego —
//                 son un contrato de INFRAESTRUCTURA TRANSVERSAL
//                 (aplicable a cualquier pieza con setup/liberación
//                 explícitos, dentro o fuera de este Bounded Context en
//                 principio, aunque hoy solo se usa aquí).
//
// ─────────────────────────────────────────────────────────────────────────────
// 3. RESPONSABILIDAD POR COMPONENTE
// ─────────────────────────────────────────────────────────────────────────────
//
// Formato por componente: Responsabilidad · Nunca debe · Acoplamiento ·
// Cohesión.
//
// GameLoop (loop/game_loop.dart)
//   Responsabilidad: producir ticks mientras está corriendo.
//   Nunca debe: saber qué es una Session, un Result o una Entity: saber
//     de tiempo ACUMULADO (eso es GameClock) — ni depender de
//     flutter_riverpod ni de ningún feature.
//   Acoplamiento: cero imports internos del motor (es una hoja del grafo
//     de dependencias — ver sección 6). Su futura implementación será la
//     ÚNICA clase de todo el motor con un import de
//     package:flutter/scheduler.dart.
//   Cohesión: todo lo que tiene que ver con "producir el siguiente tick"
//     vive aquí; nada más.
//
// GameClock (loop/game_clock.dart)
//   Responsabilidad: acumular tiempo transcurrido, pausable.
//   Nunca debe: producir ticks por sí mismo (consume los de GameLoop, no
//     los genera) ni saber qué es una Session.
//   Acoplamiento: cero imports internos del motor (hoja).
//   Cohesión: todo lo que responde "¿cuánto tiempo de juego pasó?" vive
//     aquí; nada sobre CÓMO se producen esos ticks.
//
// GameSession + GameSessionStatus (session/game_session.dart)
//   Responsabilidad: la máquina de estados de una partida y sus
//     transiciones válidas.
//   Nunca debe: calcular su propio GameResult (lo recibe ya calculado vía
//     `complete(result)` — NO sabe cómo se llega a un puntaje) ni conocer
//     ninguna GameEntity concreta ni ninguna mecánica de minijuego.
//   Acoplamiento: un solo import interno (game_result.dart) — nunca
//     importa loop/, entities/, events/ ni registry/ directamente (esas
//     dependencias, si se necesitan, las inyecta game_engine_contract.dart
//     al crear la sesión, no la propia sesión).
//   Cohesión: ciclo de vida Y su desenlace (Result) viven juntos porque
//     son una sola responsabilidad con dos caras — ver el razonamiento ya
//     documentado en session/session.dart.
//
// GameResult (session/game_result.dart)
//   Responsabilidad: transportar el desenlace de una sesión terminada.
//   Nunca debe: interpretar sus propios valores (no decide si un score es
//     "bueno"), ni importar nada de Economy/Stats/Rewards ni de ningún
//     feature — es dato neutro.
//   Acoplamiento: cero imports internos del motor (hoja).
//   Cohesión: solo los cuatro campos que definen un desenlace
//     (success/score/stars/elapsed); nada de comportamiento.
//
// GameEntity + GameEntityStatus (entities/game_entity.dart)
//   Responsabilidad: identidad estable + estado de ciclo de vida de un
//     participante de sesión.
//   Nunca debe: exponer posición, tamaño, representación visual ni
//     mecánica — ver el razonamiento ya documentado en
//     entities/game_entity.dart sobre por qué no hay variantes todavía.
//   Acoplamiento: cero imports internos del motor (hoja).
//   Cohesión: solo `id` + `status`; cualquier otra capacidad que un
//     minijuego futuro necesite se agrega en SU propio tipo, que
//     implementa esta interfaz, no aquí.
//
// GameCommand (input/game_command.dart)
//   Responsabilidad: forma mínima de una intención ya traducida.
//   Nunca debe: contener un gesto crudo de Flutter (Offset,
//     TapDownDetails) ni definir el catálogo cerrado de comandos posibles.
//   Acoplamiento: cero imports internos del motor (hoja) — y cero
//     imports de Flutter en absoluto, ni siquiera `dart:ui`.
//   Cohesión: un solo campo (`type`); el resto lo define cada minijuego en
//     su propio tipo concreto.
//
// GameLifecycleState / GameInitializable / GameDisposable / GameLifecycle
// (lifecycle/game_lifecycle.dart)
//   Responsabilidad: vocabulario común de inicialización/destrucción.
//   Nunca debe: saber QUÉ se inicializa o destruye — es un contrato de
//     forma pura, sin ninguna referencia a Session, Entity ni Engine.
//   Acoplamiento: cero imports internos del motor (hoja) — de hecho, ni
//     siquiera de dart:async más allá de Future.
//   Cohesión: las cuatro piezas son una sola responsabilidad (el ciclo
//     completo init→uso→dispose) partida en interfaces chicas por ISP, no
//     cuatro responsabilidades distintas.
//
// GameRegistry<T> (registry/game_registry.dart)
//   Responsabilidad: registrar/buscar/eliminar instancias de T por id.
//   Nunca debe: asumir que T tiene un campo `id` propio (el id se pasa
//     explícito — ver el razonamiento ya documentado), ni persistir nada
//     más allá de la sesión actual, ni saber qué es una GameEntity
//     específicamente.
//   Acoplamiento: cero imports internos del motor (hoja, genérico de
//     verdad).
//   Cohesión: cuatro operaciones (register/unregister/find/contains) +
//     dos de conveniencia (all/clear); nada de lógica de negocio sobre lo
//     que registra.
//
// GameEvent (events/game_event.dart)
//   Responsabilidad: forma mínima de un hecho ya ocurrido.
//   Nunca debe: saber quién lo publicó ni quién lo consume, ni definir el
//     catálogo cerrado de eventos posibles.
//   Acoplamiento: cero imports internos del motor (hoja).
//   Cohesión: un solo campo (`type`); el resto lo define cada publicador
//     en su propio tipo concreto.
//
// GameEventListener / GameEventBus (events/game_event_bus.dart)
//   Responsabilidad: transportar un GameEvent de quien lo publica a
//     quienes están suscritos, sin que se conozcan entre sí.
//   Nunca debe: interpretar el contenido de un GameEvent (solo lo
//     transporta) ni retener eventos para publicarlos a suscriptores
//     futuros (ver la nota ya documentada: "nunca en publicaciones
//     pasadas").
//   Acoplamiento: un solo import interno (game_event.dart) — no conoce
//     GameSession, GameEngine ni ningún feature.
//   Cohesión: publicar + suscribir + cancelar; nada de lógica de negocio
//     sobre CUÁNDO se debe publicar algo (eso lo decide quien llama a
//     `publish`, nunca el bus).
//
// GameEngine (game_engine_contract.dart, raíz)
//   Responsabilidad: coordinar sesión activa, registro de entidades y bus
//     de eventos detrás de una sola fachada, con su propio ciclo de vida.
//   Nunca debe: exponer GameLoop ni GameClock directamente (detalle
//     interno de CÓMO logra el ritmo de una sesión — ver el razonamiento
//     ya documentado, Ley de Demeter), ni permitir más de una
//     GameSession activa a la vez, ni conocer ningún feature de minijuego
//     concreto.
//   Acoplamiento: depende de TODAS las subcarpetas (es la raíz del grafo
//     de dependencias — ver sección 6) — pero NINGUNA subcarpeta depende
//     de él. La dependencia es de un solo sentido, igual que
//     features/ → core/ en el resto del proyecto.
//   Cohesión: coordinación pura — no reimplementa nada de lo que ya
//     resuelven sus piezas (GameSession, GameRegistry, GameEventBus); solo
//     las compone.
//
// ─────────────────────────────────────────────────────────────────────────────
// 4. CÓMO SE EVITA EL ACOPLAMIENTO (mecanismos concretos, no solo intención)
// ─────────────────────────────────────────────────────────────────────────────
//
//   1. Contratos, nunca implementaciones concretas importadas — ningún
//      archivo de este módulo importa un `*Impl` (no existen todavía;
//      cuando existan, seguirán esta regla).
//   2. Tipos de dato neutros (GameResult, GameCommand, GameEvent) en vez
//      de que una pieza importe directamente el vocabulario de otra capa
//      (Economy, features/) — el motor nunca importa nada fuera de sí
//      mismo (game_engine_charter.dart, sección 12).
//   3. Streams/callbacks para notificar cambios (GameLoop.onTick,
//      GameSession.onStatusChanged, GameEventBus) en vez de que una pieza
//      llame directamente a un método de otra — el emisor no conoce a
//      sus receptores.
//   4. Genéricos sin restricción (GameRegistry<T>) en vez de acoplar un
//      contrato de infraestructura a un tipo de dominio específico.
//   5. Ningún import circular — ver el grafo de dependencias en la
//      sección 6, verificado contra el código real, no solo declarado.
//
// ─────────────────────────────────────────────────────────────────────────────
// 5. CÓMO SE MANTIENE LA COHESIÓN
// ─────────────────────────────────────────────────────────────────────────────
//
//   1. Una carpeta, una pregunta que responde (sección "por qué esta
//      carpeta existe separada de las demás" en cada barrel — ver
//      loop/loop.dart, session/session.dart, entities/entities.dart,
//      input/input.dart, lifecycle/lifecycle.dart, registry/registry.dart,
//      events/events.dart).
//   2. Un archivo, un tipo (o un tipo + su enum/typedef compañero
//      inseparable — GameSession+GameSessionStatus,
//      GameEntity+GameEntityStatus, GameEventBus+GameEventListener) nunca
//      varios conceptos no relacionados en el mismo archivo.
//   3. TENSIÓN RECONOCIDA (no resuelta a propósito en este sprint):
//      GameEngine.entities expone un GameRegistry<GameEntity> completo, no
//      solo lecturas acotadas — un Aggregate Root estricto (DDD) no
//      dejaría que código externo registre/elimine entidades sin pasar
//      por la Session. Se acepta esta apertura hoy porque un minijuego
//      futuro necesita, en la práctica, iterar y observar entidades para
//      renderizarlas — restringir el acceso sin un caso de uso real
//      violaría YAGN de la misma forma que inventar variantes de
//      GameEntity sin un minijuego real (sección 2, entities/game_entity.dart).
//      Si en el sprint del primer minijuego esto resulta un problema real
//      (una feature registra/elimina entidades de forma que rompe
//      invariantes de la sesión), ESA es la señal para endurecer el
//      contrato — no antes.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// 6. GRAFO DE DEPENDENCIAS INTERNAS (verificado contra el código real)
// ─────────────────────────────────────────────────────────────────────────────
//
//   game_engine_contract.dart (GameEngine)
//     ├──> entities/game_entity.dart
//     ├──> events/game_event_bus.dart ──> events/game_event.dart
//     ├──> lifecycle/game_lifecycle.dart
//     ├──> registry/game_registry.dart
//     └──> session/game_session.dart ──> session/game_result.dart
//
//   loop/game_loop.dart, loop/game_clock.dart, input/game_command.dart:
//   sin imports internos — hojas independientes, no consumidas todavía
//   por ningún otro contrato del motor (GameEngine no las expone
//   directamente — ver sección 3, "GameEngine, nunca debe").
//
//   Es un grafo acíclico dirigido de raíz única. Ninguna hoja importa
//   hacia la raíz ni hacia otra rama — condición necesaria para que
//   "bajo acoplamiento" (game_engine_charter.dart, sección 8) sea un
//   hecho verificable, no una aspiración.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// 7. FEATURE FIRST — CÓMO UN MINIJUEGO FUTURO CONSUME ESTO
// ─────────────────────────────────────────────────────────────────────────────
//
// Cuando el primer minijuego real se construya (features/minigame/, hoy
// una carpeta vacía), lo hará:
//   • Implementando GameEntity, GameCommand y GameEvent CONCRETOS propios
//     de su mecánica (composición, nunca herencia de clases del motor —
//     no existen clases concretas del motor de las que heredar, solo
//     interfaces).
//   • Consumiendo UN GameEngine ya inicializado (inyectado, no
//     construido por el feature) para pedir `startSession()`, leer
//     `currentSession`, y suscribirse a `events`.
//   • Sin que Genesis Engine sepa, en ningún momento, que ESE minijuego
//     específico existe — el motor termina de escribirse antes de que el
//     primer minijuego se diseñe, y no cambia cuando el segundo, tercero
//     o décimo minijuego se agregue (Open/Closed, ya aplicado en la
//     práctica, no solo declarado).
// ─────────────────────────────────────────────────────────────────────────────
