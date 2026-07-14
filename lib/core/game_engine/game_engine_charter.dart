// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/game_engine_charter.dart
//
// Este archivo NO contiene código ejecutable. Es la CONSTITUCIÓN del Core
// Game Engine de Jardín del Edén — la única fuente de verdad de su
// identidad antes de que exista una sola línea de lógica. Ningún contrato,
// clase o carpeta interna se crea en este sprint; este documento define QUÉ
// se va a construir y bajo qué reglas, para que cuando se construya (sprint
// futuro), cada decisión ya esté tomada y no se improvise sobre la marcha.
//
// Mismo formato de comentarios que el resto del proyecto (ver
// lib/core/quality/code_conventions.dart y test/test_conventions.dart) —
// vive junto al código, no en un .md aparte que se desactualiza sin que
// nadie lo note.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// 1. NOMBRE OFICIAL
// ─────────────────────────────────────────────────────────────────────────────
//
// GENESIS ENGINE
//
// POR QUÉ ESTE NOMBRE:
//   Génesis es el primer libro de la Biblia — el relato del origen y la
//   fundación de todo lo demás. Es exactamente el rol de este módulo: es lo
//   que existe ANTES que cualquier minijuego, mundo o mecánica, y sobre lo
//   que todo lo demás se construye. El nombre no es decorativo — es una
//   descripción literal de su posición en la arquitectura.
//
// CÓMO SE USA EL NOMBRE:
//   "Genesis Engine" es la identidad del MÓDULO (cómo se explica el sistema
//   a un humano), no un prefijo obligatorio en cada símbolo de código. Las
//   clases futuras se llaman `GameLoop`, `GameSession`, `GameClock` — no
//   `GenesisGameLoop` — de la misma forma en que Flutter no prefija cada
//   clase con "Flutter". El prefijo real de nomenclatura en código es `Game`
//   (ver sección 11).
//
// EMPAQUETADO (decisión DIFERIDA, no tomada en este sprint):
//   Genesis Engine vive hoy dentro de core/game_engine/, en el mismo
//   paquete Flutter que el resto del proyecto — ni más ni menos que
//   cualquier otro core/<tema>/. Si en un sprint futuro se decide extraerlo
//   a un paquete Dart físicamente separado (con su propio pubspec.yaml,
//   importado vía path:), ese es un cambio de EMPAQUETADO, no de identidad
//   — este documento sigue siendo válido sin cambios. No se decide aquí
//   porque construir el motor con bajo acoplamiento real (sección 8) es lo
//   que hace esa migración futura barata SI llega a necesitarse — la
//   identidad no depende de en cuántos pubspec.yaml vive el código.
//
// ─────────────────────────────────────────────────────────────────────────────
// 2. FILOSOFÍA
// ─────────────────────────────────────────────────────────────────────────────
//
// Cinco creencias que gobiernan toda decisión futura del motor:
//
// I. EL MOTOR SIRVE AL APRENDIZAJE, NO AL REVÉS.
//    Genesis Engine no es un motor de juegos genérico que busca ser
//    reutilizable para cualquier género. Existe para hacer posible UN tipo
//    de experiencia: minijuegos educativos bíblicos cortos para niños de
//    4 a 12 años. Cualquier capacidad que el motor gane debe poder
//    explicarse en términos de qué aprendizaje o qué momento de juego
//    honesto habilita — no "porque los motores de juego suelen tenerlo".
//
// II. PREDECIBLE ANTES QUE ESPECTACULAR.
//     El público son niños pequeños en dispositivos Android de gama media/
//     baja (ver Restricciones, sección 9). Un motor determinístico,
//     testeable y depurable vale más que uno con físicas vistosas pero
//     fráil. Ver la Regla Arquitectónica 6 (sección 7) sobre el reloj de
//     juego — es la consecuencia técnica directa de este principio.
//
// III. UN MOTOR INVISIBLE.
//      Ni el niño que juega ni, idealmente, el desarrollador que construye
//      el próximo minijuego deberían tener que "pensar en el motor" como
//      una cosa aparte. Su trabajo es desaparecer detrás de contratos
//      simples que hacen que construir la siguiente mecánica sea rápido y
//      seguro, no exhibir su propia arquitectura.
//
// IV. OFFLINE-FIRST, SIEMPRE.
//     Ningún contrato del motor asume conectividad de red — consistente
//     con el resto del proyecto (ver core/connectivity/). Una sesión de
//     juego debe poder empezar, jugarse y terminar sin que exista internet
//     en el dispositivo, ni ahora ni en el roadmap futuro de sincronización.
//
// V. SEGURO PARA LA INFANCIA POR DISEÑO.
//    El motor no debe hacer que sea FÁCIL construir accidentalmente un
//    patrón de manipulación (bucles de recompensa infinitos pensados para
//    generar dependencia, presión de tiempo agresiva, cualquier gancho de
//    dinero real). Esto no es una regla de contenido — es una restricción
//    de qué primitivas expone el motor (ver sección 6, "qué NO resolverá").
//
// ─────────────────────────────────────────────────────────────────────────────
// 3. OBJETIVOS
// ─────────────────────────────────────────────────────────────────────────────
//
// Lo que Genesis Engine debe hacer posible, en orden de fundación (cada uno
// depende del anterior):
//
//   1. Un ciclo de actualización de juego (game loop) desacoplado del ciclo
//      de reconstrucción de widgets de Flutter — la lógica de una sesión
//      avanza en su propio ritmo, no cuando a Flutter se le ocurre
//      reconstruir un árbol.
//   2. Una noción de tiempo de juego (game clock) independiente del reloj
//      real — pausable, acelerable, y sustituible por un reloj falso en
//      tests sin usar `Future.delayed` real en ningún test de lógica de
//      juego.
//   3. Un ciclo de vida de sesión de juego (lista → en curso → pausada →
//      completada/abandonada) reutilizable por CUALQUIER minijuego futuro,
//      para que cada Sprint de minijuego no reinvente "qué significa
//      pausar" o "qué significa terminar".
//   4. Un contrato de resultado de sesión (puntaje, estrellas, éxito/
//      fracaso, tiempo empleado) como la ÚNICA superficie que el motor
//      expone hacia afuera — Economy, Stats y Rewards consumen ese
//      resultado sin que el motor sepa que esos features existen.
//   5. Un contrato de traducción de entrada — de gestos crudos de Flutter
//      (tap, drag, swipe) a comandos de juego semánticos — para que la
//      lógica de un minijuego razone en términos de "el jugador seleccionó
//      la oveja perdida", no en términos de coordenadas de pantalla.
//
// Lo que NO es un objetivo de este sprint: implementar ninguno de los cinco
// puntos anteriores. Son el mapa; este documento solo fija el territorio.
//
// ─────────────────────────────────────────────────────────────────────────────
// 4. RESPONSABILIDADES
// ─────────────────────────────────────────────────────────────────────────────
//
// Lo que Genesis Engine POSEE (cuando se implemente):
//   • El ritmo de una sesión de juego (cuándo avanza, cuándo se detiene).
//   • El estado de ciclo de vida de esa sesión.
//   • Los contratos que cualquier entidad de juego (un ítem coleccionable,
//     un personaje interactivo, un obstáculo) debe cumplir para participar
//     en una sesión.
//   • La traducción de entrada cruda a intención semántica.
//   • El contrato de resultado que se entrega al terminar una sesión.
//
// Lo que Genesis Engine CONSUME, nunca posee (siempre vía contrato ya
// existente en otro core/<tema>/, nunca importando la implementación
// concreta):
//   • Persistencia (core/storage/, core/infrastructure/database/).
//   • Audio (core/audio/).
//   • Logging (core/logging/) — el motor reporta diagnóstico de rendimiento
//     y errores de sesión al logger, no inventa su propio canal de logs.
//   • Manejo de errores (core/error/) — cualquier falla de una sesión se
//     modela con el mismo Result/AppException del resto del proyecto.
//
// ─────────────────────────────────────────────────────────────────────────────
// 5. ALCANCE
// ─────────────────────────────────────────────────────────────────────────────
//
// DENTRO del alcance de Genesis Engine:
//   • Todo lo transversal a CUALQUIER minijuego: ritmo, tiempo, ciclo de
//     vida de sesión, traducción de entrada, contrato de resultado.
//
// FUERA del alcance (pertenece a un feature de minijuego futuro, no al
// motor):
//   • La mecánica concreta de un minijuego específico (memoria, arrastrar-
//     soltar, trivia, secuencias).
//   • El contenido de un minijuego (qué versículo, qué mundo, qué personaje).
//   • La presentación visual de un minijuego (eso es Flutter + Design
//     System, capa de presentación del feature).
//
// El motor es la CANCHA Y LAS REGLAS DEL RELOJ, no el partido.
//
// ─────────────────────────────────────────────────────────────────────────────
// 6. QUÉ PROBLEMAS RESOLVERÁ
// ─────────────────────────────────────────────────────────────────────────────
//
//   • "Cada minijuego futuro reimplementa su propia noción de pausa/
//     reanudación de forma distinta" → un contrato de sesión único.
//   • "La lógica de juego se vuelve imposible de testear porque depende de
//     temporizadores reales o del ciclo de vida de un widget" → un reloj de
//     juego inyectable y sustituible.
//   • "Cada minijuego termina hablando directamente con AudioService o
//     StorageService, acoplándose a detalles de infraestructura que no le
//     conciernen" → el motor es la única frontera entre lógica de juego y
//     servicios de la app.
//   • "Economy/Stats/Rewards necesitan saber el detalle interno de cada
//     minijuego para poder puntuarlo" → un contrato de resultado único y
//     genérico que cualquier minijuego produce.
//
// ─────────────────────────────────────────────────────────────────────────────
// 7. QUÉ PROBLEMAS NO RESOLVERÁ
// ─────────────────────────────────────────────────────────────────────────────
//
// Non-goals explícitos — tan importantes como los objetivos:
//
//   • NO es un motor de renderizado 2D/3D. Flutter + Skia ya lo son; el
//     motor no dibuja nada, no tiene noción de píxel, canvas ni sprite.
//   • NO es un motor de físicas. Si un minijuego futuro necesita físicas
//     reales, esa es una decisión de dependencia que se evalúa en EL
//     SPRINT de ese minijuego, no una capacidad que el motor deba prever.
//   • NO gestiona estado de UI/widgets. Riverpod sigue siendo, sin
//     excepción, quien gestiona el estado de presentación — el motor
//     expone contratos que una capa de adaptación (futura, fuera del
//     motor) conecta a providers.
//   • NO conoce ninguna mecánica de minijuego concreta.
//   • NO decide economía ni recompensas — entrega un resultado de sesión;
//     qué se hace con ese resultado es decisión de Economy/Rewards.
//   • NO implementa persistencia directa — consume los contratos ya
//     existentes de core/storage/ y core/infrastructure/database/.
//   • NO resuelve multijugador ni sincronización de red — el juego es
//     offline-first y de un solo jugador (ver Filosofía IV).
//   • NO reemplaza GoRouter — la navegación entre la pantalla de selección
//     de minijuego y el minijuego en sí sigue siendo del router.
//
// ─────────────────────────────────────────────────────────────────────────────
// 8. PRINCIPIOS DE DISEÑO
// ─────────────────────────────────────────────────────────────────────────────
//
// SOLID, Clean Architecture y Feature First, aplicados concretamente a un
// motor de juego (no como lema, como consecuencia técnica):
//
//   SRP — Cada contrato futuro (GameLoop, GameClock, GameSession) tiene una
//   sola razón para cambiar. El reloj no sabe de resultados; la sesión no
//   sabe de renderizado.
//
//   OCP — Nuevas mecánicas de minijuego se agregan IMPLEMENTANDO contratos
//   existentes del motor, nunca modificando el motor para acomodar un
//   minijuego específico. Si un minijuego futuro "no encaja" en un
//   contrato existente, la señal correcta es diseñar un contrato nuevo y
//   más pequeño — no ensanchar uno existente con parámetros opcionales
//   para ese caso.
//
//   LSP — Cualquier implementación de un contrato del motor debe ser
//   sustituible sin sorpresas: un GameClock de test (tiempo falso,
//   avanzable manualmente) debe comportarse exactamente como el real
//   salvo por la fuente del tiempo — mismas garantías, mismo contrato.
//
//   ISP — Contratos pequeños y específicos. Un consumidor que solo
//   necesita leer el tiempo transcurrido no debe verse forzado a
//   implementar métodos de pausa que no usa — se divide en contratos
//   más chicos antes que crear una interfaz "todo en uno".
//
//   DIP — El motor depende de ABSTRACCIONES para todo lo externo (ver
//   sección 4, "lo que consume"). Nunca importa una clase `*ServiceImpl`
//   directamente — siempre el contrato.
//
//   CLEAN ARCHITECTURE — El motor vive en core/, nunca en features/. La
//   dirección de dependencia es de un solo sentido: un feature de
//   minijuego futuro depende DEL motor; el motor JAMÁS depende de un
//   feature (ver Regla Arquitectónica 4, sección 9. Mismo principio que ya
//   rige todo core/<tema>/ — ver code_conventions.dart, sección 2).
//
//   FEATURE FIRST — El motor no es "un feature" más — es infraestructura
//   transversal, igual que core/theme/ o core/error/. Pero está diseñado
//   para que cada minijuego futuro sea su propio feature autocontenido que
//   CONSUME el motor por composición (implementando sus contratos), nunca
//   que lo extiende por herencia profunda de clases concretas.
//
//   BAJO ACOPLAMIENTO — Comunicación vía contratos (y, donde el contrato
//   lo pida, Streams/callbacks) — nunca referencias directas a una clase
//   concreta de otra capa.
//
//   ALTA COHESIÓN — Todo lo que pertenece al "ritmo y estado de una
//   sesión de juego" vive junto dentro de core/game_engine/. Todo lo que
//   no —audio, persistencia, economía— vive en su propio core/<tema>/ y el
//   motor lo consume, nunca lo absorbe.
//
// ─────────────────────────────────────────────────────────────────────────────
// 9. REGLAS ARQUITECTÓNICAS
// ─────────────────────────────────────────────────────────────────────────────
//
//   1. El motor vive en lib/core/game_engine/ — mismo nivel que cualquier
//      otro core/<tema>/, ninguna carpeta especial ni trato distinto en
//      el árbol de dependencias.
//   2. En esta fase (identidad), el motor NO expone ninguna implementación
//      concreta — cero clases con lógica real. Ver sección 12 para la
//      organización planeada de cuando eso cambie.
//   3. Ninguna clase del motor puede importar flutter_riverpod — el motor
//      es agnóstico del framework de estado. Una capa de adaptación
//      (futura, fuera de core/game_engine/) conecta sus contratos a
//      providers de Riverpod para que la presentación los consuma.
//   4. Ninguna clase del motor puede importar nada de lib/features/.
//   5. El motor no expone Widgets. Cualquier necesidad de UI se resuelve
//      en la capa de presentación del feature de minijuego que consuma el
//      motor, nunca dentro de core/game_engine/.
//   6. Toda noción de tiempo dentro de lógica de juego pasa por el
//      contrato de reloj del motor — nunca `DateTime.now()` ni
//      `Future.delayed` directo. Consecuencia técnica directa de la
//      Filosofía II (predecible antes que espectacular): así una sesión de
//      juego es determinística y testeable sin esperas reales.
//
// ─────────────────────────────────────────────────────────────────────────────
// 10. RESTRICCIONES
// ─────────────────────────────────────────────────────────────────────────────
//
//   • PRESUPUESTO DE RENDIMIENTO: cualquier implementación futura debe
//     operar dentro de un frame budget de ~16ms (60fps) en dispositivos
//     Android de gama media/baja — el público del proyecto, no equipos de
//     referencia. Se mide contra la infraestructura de performance testing
//     ya preparada (ver integration_test/performance/, test_driver/
//     perf_driver.dart, Sprint de Testing).
//   • DETERMINISMO: dado el mismo estado inicial y la misma secuencia de
//     comandos de entrada, una sesión debe producir el mismo resultado —
//     requisito para test automatizado Y para no frustrar a un niño
//     pequeño con comportamiento que se siente "aleatorio" sin querer
//     serlo.
//   • SIN RED: ningún contrato puede asumir conectividad (Filosofía IV).
//   • SIN NUEVAS DEPENDENCIAS EN ESTA FASE: el motor no agrega ninguna
//     entrada nueva a pubspec.yaml mientras siga siendo solo identidad. Si
//     una implementación futura necesita un paquete (p. ej. algo de
//     ECS o de física), esa evaluación se hace en el sprint que la
//     implemente, con la misma disciplina de "verificar antes de asumir"
//     que ya rige el resto del proyecto.
//
// ─────────────────────────────────────────────────────────────────────────────
// 11. DEPENDENCIAS PERMITIDAS
// ─────────────────────────────────────────────────────────────────────────────
//
//   • dart:core, dart:async (Future/Stream para contratos asíncronos).
//   • package:flutter/scheduler.dart — ÚNICA razón: Flutter es la única
//     fuente de ticks de frame disponible en la plataforma. Se aísla
//     detrás de un contrato propio del motor (futuro) para que el resto
//     del motor nunca vea un import de Flutter — la dependencia se
//     detiene en un solo archivo de frontera.
//   • Contratos YA EXISTENTES de otros core/<tema>/ (p. ej.
//     core/error/result.dart para tipos de retorno) — siempre el
//     contrato, nunca la implementación concreta (`*ServiceImpl`).
//
// ─────────────────────────────────────────────────────────────────────────────
// 12. DEPENDENCIAS PROHIBIDAS
// ─────────────────────────────────────────────────────────────────────────────
//
//   • flutter_riverpod (ninguna anotación, ningún provider).
//   • flutter/material.dart, flutter/cupertino.dart (nada de widgets ni
//     temas).
//   • go_router.
//   • Cualquier archivo bajo lib/features/.
//   • Cualquier paquete de terceros de audio, base de datos o similar
//     directamente — todo pasa por el contrato de servicio ya existente
//     en core/, nunca por el paquete concreto que ese servicio envuelve.
//
// ─────────────────────────────────────────────────────────────────────────────
// 13. CONVENCIONES DE NOMBRES
// ─────────────────────────────────────────────────────────────────────────────
//
//   PREFIJO `Game`: reservado para todo concepto de nivel de motor
//   (GameLoop, GameClock, GameSession, GameEntity, GameCommand,
//   GameResult). Evita colisión semántica con nombres ya usados por
//   features existentes — p. ej. "World" ya es un feature del juego
//   (lib/features/world/); el motor hablará de `GameScene`, nunca de
//   `World`, para que un desarrollador nunca confunda un concepto del
//   motor con una entidad de contenido del juego.
//
//   SIN PREFIJO `I` EN CONTRATOS: a diferencia de los repositorios de
//   features (que sí usan `i_x_repository.dart` / `IXRepository`, ver
//   code_conventions.dart sección 1), el motor sigue la convención de
//   SERVICIOS del proyecto: el contrato es la clase con el nombre limpio
//   (`GameLoop`), la implementación futura es `GameLoopImpl`, cada una en
//   su propio archivo (`game_loop.dart` / `game_loop_impl.dart`). Se elige
//   esta convención (servicio) y no la de repositorio porque el motor es
//   infraestructura de ciclo de vida y comportamiento, no acceso a datos.
//
//   ARCHIVOS: snake_case, un contrato por archivo. No se usa el sufijo
//   `_contract.dart` (sería redundante — el prefijo `Game` de la clase ya
//   comunica que es un concepto del motor).
//
//   ENCABEZADO: todo archivo futuro de este módulo lleva el mismo bloque
//   RESPONSABILIDAD / DEPENDENCIAS PERMITIDAS / DEPENDENCIAS PROHIBIDAS que
//   el resto del proyecto — no una convención nueva, la misma de siempre.
//
// ─────────────────────────────────────────────────────────────────────────────
// 14. ORGANIZACIÓN INTERNA (PLANEADA — NADA DE ESTO EXISTE TODAVÍA)
// ─────────────────────────────────────────────────────────────────────────────
//
// El siguiente árbol es el plan de subcarpetas de core/game_engine/ para
// cuando el motor pase de identidad a contratos reales (sprint futuro).
// Ninguna de estas carpetas se crea en este sprint — documentarlas ahora
// evita que ese sprint futuro tenga que redecidir la organización desde
// cero:
//
//   core/game_engine/
//   ├── loop/        GameLoop, GameClock — el ritmo y el tiempo de una
//   │                sesión (Objetivo 1 y 2, sección 3).
//   ├── session/     GameSession, GameResult — ciclo de vida y el
//   │                contrato de salida hacia Economy/Stats/Rewards
//   │                (Objetivo 3 y 4).
//   ├── entities/     GameEntity y variantes — el contrato que cualquier
//   │                ítem/personaje/obstáculo de un minijuego debe
//   │                cumplir para participar en una sesión (sección 4).
//   └── input/        GameCommand y la traducción de gesto crudo a
//                    intención semántica (Objetivo 5).
//
// Cuando cada carpeta se implemente, contendrá el contrato (`x.dart`) y,
// en el sprint que corresponda, su implementación (`x_impl.dart`) — nunca
// una carpeta "contracts/" separada de las implementaciones, porque en
// este motor cada pieza vive junto a su propio contrato (alta cohesión,
// sección 8), no agrupada por "tipo de archivo".
//
// CHANGELOG DE ESTA SECCIÓN — Sprint "Contratos Oficiales":
//   El plan original de arriba (loop/, session/, entities/, input/) no
//   contemplaba ciclo de vida genérico, registro ni un canal de
//   comunicación explícito — el sprint de Contratos Oficiales identificó
//   que estos SON necesarios como conceptos propios, no como detalles
//   internos de otra carpeta. Se agregan aquí, documentados con el mismo
//   rigor que el plan original:
//
//   core/game_engine/
//   ├── lifecycle/    GameLifecycleState, GameInitializable,
//   │                GameDisposable, GameLifecycle (compuesto) — el
//   │                vocabulario común de inicialización/destrucción que
//   │                GameEngine (y, en el futuro, GameSession) implementan.
//   ├── registry/      GameRegistry<T> — registro genérico por id, usado
//   │                por GameEngine para rastrear las GameEntity activas
//   │                de la sesión actual sin conocer GameEntity en
//   │                absoluto (el contrato no tiene esa restricción).
//   ├── events/        GameEvent (qué es un evento) + GameEventBus (cómo
//   │                viaja un evento entre piezas que no se conocen
//   │                directamente) — resuelve "Eventos" y "Comunicación"
//   │                como dos caras de un mismo sistema.
//   └── (raíz) game_engine_contract.dart — GameEngine: el contrato que
//                    coordina TODAS las carpetas anteriores (loop/session
//                    internamente, entities vía registry, eventos vía el
//                    bus) — resuelve "Coordinación". Vive en la raíz, no
//                    en una subcarpeta, porque no pertenece a ningún
//                    concepto aislado — es sobre el motor completo.
//
//   Estas carpetas ya EXISTEN (a diferencia del resto de esta sección,
//   que sigue siendo un plan) — ver core/game_engine/lifecycle/,
//   core/game_engine/registry/, core/game_engine/events/ y
//   core/game_engine/game_engine_contract.dart.
// ─────────────────────────────────────────────────────────────────────────────
