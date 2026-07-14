// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/game_engine_quality_rules.dart
//
// Este archivo NO contiene código ejecutable. Es el reglamento de CALIDAD
// interna de Genesis Engine — distinto de los archivos ya existentes:
//   game_engine_charter.dart            → identidad, filosofía, alcance.
//   game_engine_responsibilities.dart    → qué hace cada componente (DDD).
//   game_engine_dependency_rules.dart     → qué puede importar qué.
//   ESTE ARCHIVO                        → cómo se escribe, organiza y
//                                         mantiene código NUEVO en este
//                                         módulo para que siga siendo
//                                         igual de claro dentro de dos
//                                         años y con diez veces más
//                                         contratos.
//
// No repite las reglas de calidad del PROYECTO completo (ver
// lib/core/quality/code_conventions.dart y analysis_options.yaml) — asume
// que ya se cumplen (flutter_lints + reglas personalizadas, formato
// automático) y agrega SOLO lo específico de este módulo.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// 1. REGLAS (no negociables — un PR que las rompa se rechaza)
// ─────────────────────────────────────────────────────────────────────────────
//
//   R1. Un contrato público por archivo. Su enum/typedef COMPAÑERO
//       inseparable puede vivir en el mismo archivo (GameSession +
//       GameSessionStatus, GameEventBus + GameEventListener) — "compañero
//       inseparable" significa que nadie usaría uno sin el otro, nunca
//       "está relacionado".
//   R2. Todo archivo nuevo debe pasar
//       test/core/game_engine/game_engine_dependency_rules_test.dart antes
//       de integrarse — no es opcional, es el mismo gate que
//       flutter analyze/dart format del resto del proyecto.
//   R3. Ninguna interfaz pública supera ~5-6 miembros sin una revisión
//       explícita de si en realidad son dos responsabilidades (ver ISP,
//       game_engine_charter.dart sección 8). GameSession tiene 6
//       (status, result, onStatusChanged, start, pause, resume, complete,
//       abandon — de hecho 8) porque un ciclo de vida completo es
//       legítimamente eso de grande; una interfaz nueva que se acerque a
//       ese tamaño sin ser un ciclo de vida completo es la señal de
//       alerta, no el número exacto.
//   R4. Todo tipo público lleva doc comment `///` explicando su contrato
//       — no su implementación (no existe todavía), sino qué garantiza a
//       quien lo consume.
//   R5. Ningún archivo de este módulo se escribe sin el bloque de
//       encabezado RESPONSABILIDAD + DEPENDENCIAS (ver sección 7) — sin
//       excepción, incluyendo archivos de una sola pantalla de texto.
//
// ─────────────────────────────────────────────────────────────────────────────
// 2. BUENAS PRÁCTICAS (recomendadas, revisables caso por caso)
// ─────────────────────────────────────────────────────────────────────────────
//
//   • Preferir varios métodos pequeños y con nombre claro (start/pause/
//     resume/complete/abandon) sobre un solo método genérico con un
//     parámetro que decide el comportamiento (`transition(Action action)`)
//     — la forma del contrato debe documentar la máquina de estados, no
//     esconderla detrás de un parámetro (ver el razonamiento ya dado en
//     game_session.dart).
//   • Explicar el PORQUÉ antes que el QUÉ en cada encabezado — un lector
//     que ya sabe Dart puede inferir el qué del código; nadie puede
//     inferir por qué se descartó una alternativa sin que se lo cuenten.
//   • Cuando una decisión de este módulo tiene una alternativa razonable
//     que se descartó (p. ej. `GameRegistry<T extends GameEntity>` vs
//     `GameRegistry<T>` con id explícito), documentar la alternativa Y la
//     razón del descarte — no solo la decisión final.
//   • Preferir tipos genéricos sin restricción (`GameRegistry<T>`) sobre
//     variantes concretas especulativas — ver la regla ya aplicada en
//     entities/game_entity.dart y input/game_command.dart: no inventar
//     variantes sin un consumidor real.
//
// ─────────────────────────────────────────────────────────────────────────────
// 3. RESTRICCIONES
// ─────────────────────────────────────────────────────────────────────────────
//
//   • Ningún método de un contrato acepta más de 3 parámetros posicionales
//     u opcionales sueltos — a partir de ahí, agruparlos en un tipo propio
//     (mismo espíritu que GameResult agrupa 4 valores relacionados en vez
//     de que GameSession.complete() reciba 4 parámetros sueltos).
//   • Ningún tipo de dato (Value Object DDD — GameResult, futuros
//     similares) expone campos mutables. Si algo necesita cambiar, se
//     construye una instancia nueva — nunca un setter.
//   • Ninguna Capa 0 (ver game_engine_dependency_rules.dart, sección 1)
//     puede depender de un paquete de terceros — dart:core y, donde el
//     archivo lo documente, dart:async, nada más.
//
// ─────────────────────────────────────────────────────────────────────────────
// 4. CONVENCIONES — INCONSISTENCIA RECONOCIDA (Status vs State)
// ─────────────────────────────────────────────────────────────────────────────
//
//   Auditoría honesta de este mismo sprint: hoy existen tres enums —
//   GameSessionStatus, GameEntityStatus (sufijo "Status") y
//   GameLifecycleState (sufijo "State"). No hay una razón semántica real
//   para la diferencia — es inconsistencia de nomenclatura, no una
//   distinción deliberada.
//
//   REGLA A PARTIR DE AHORA: el sufijo oficial es `Status` (2 de 3 casos
//   ya lo usan). GameLifecycleState queda como EXCEPCIÓN HEREDADA,
//   documentada aquí explícitamente para que nadie la copie como patrón
//   en un archivo nuevo. No se renombra en este sprint (renombrar un tipo
//   ya usado por otros contratos —game_engine_contract.dart importa
//   GameLifecycleState— es un cambio de código, fuera del alcance de "no
//   crear código funcional"). Se corrige en un sprint de mantenimiento
//   dedicado, como un cambio propio y visible, no escondido dentro de otro
//   sprint.
//
//   Resto de convenciones — ya vigentes, se reafirman sin cambios:
//     • Prefijo `Game` para todo concepto de nivel de motor
//       (game_engine_charter.dart, sección 13).
//     • Sin prefijo `I` en contratos — el motor sigue la convención de
//       servicios del proyecto, no la de repositorios.
//     • Booleanos con prefijo is/has/can (`isRunning`, `isPaused`,
//       `isDisposed`, `canInitialize`) — nunca un adjetivo desnudo.
//     • Un enum expuesto públicamente siempre se consume con `switch`
//       exhaustivo (ya forzado por `exhaustive_cases`, activo en todo el
//       proyecto vía analysis_options.yaml) — ningún consumidor futuro de
//       GameSessionStatus/GameEntityStatus/GameLifecycleState debe usar un
//       `default:` que esconda un caso nuevo agregado después.
//
// ─────────────────────────────────────────────────────────────────────────────
// 5. ORGANIZACIÓN — CÓMO AGREGAR UNA CARPETA NUEVA AL MOTOR
// ─────────────────────────────────────────────────────────────────────────────
//
// Playbook paso a paso (ya ejecutado tres veces — lifecycle/, registry/,
// events/ — durante el sprint de Contratos Oficiales; esto documenta ESE
// proceso para que la cuarta vez no se improvise):
//
//   1. Confirmar que es un concepto de CAPA 0/1 genuino (game_engine_
//      dependency_rules.dart, sección 1) — no una mecánica de minijuego
//      (eso pertenece a features/, nunca a core/game_engine/).
//   2. Crear la carpeta con su(s) contrato(s) — un archivo por contrato
//      (Regla R1) — y su propio barrel `<carpeta>.dart` que los reexporta.
//   3. Actualizar game_engine.dart (el barrel raíz) para reexportar el
//      barrel nuevo — en orden alfabético (directives_ordering, ya
//      forzado por analysis_options.yaml para todo el proyecto).
//   4. Si la carpeta nueva participa de la coordinación general, componerla
//      en game_engine_contract.dart (GameEngine) — importando el archivo
//      específico, nunca el barrel (game_engine_dependency_rules.dart,
//      sección 3, prohibición 5).
//   5. Documentar la extensión en game_engine_charter.dart, sección 14,
//      como una entrada de CHANGELOG fechada/nombrada por sprint — nunca
//      reescribiendo el plan original en silencio (ver el precedente ya
//      sentado ahí mismo).
//   6. Correr test/core/game_engine/game_engine_dependency_rules_test.dart
//      — si algo del paso 2-4 rompió la Regla de Capas, esto lo atrapa
//      antes de que llegue a revisión humana.
//
// ─────────────────────────────────────────────────────────────────────────────
// 6. ESCALABILIDAD
// ─────────────────────────────────────────────────────────────────────────────
//
//   Ya demostrada, no solo prometida: lifecycle/, registry/ y events/ se
//   agregaron completas sin modificar una sola línea de loop/, session/,
//   entities/ ni input/ (los contratos del sprint anterior). Esa es la
//   prueba de que Open/Closed funciona en la práctica en este módulo, no
//   solo en el papel.
//
//   Lo que hace que esto siga siendo cierto a futuro:
//     • El test de dependencias (sección 5, paso 6) escanea la carpeta
//       completa dinámicamente — no tiene una lista de archivos escrita a
//       mano que alguien deba recordar actualizar.
//     • El barrel raíz solo necesita un cambio cuando se agrega una
//       CARPETA nueva, nunca cuando se agrega un archivo a una carpeta ya
//       existente (el barrel de esa carpeta absorbe el cambio).
//     • Los contratos genéricos (GameRegistry<T>) escalan a casos de uso
//       nuevos sin necesitar un tipo nuevo — GameRegistry<GameEntity> hoy,
//       cualquier `GameRegistry<X>` futuro sin tocar registry/.
//
// ─────────────────────────────────────────────────────────────────────────────
// 7. MANTENIBILIDAD
// ─────────────────────────────────────────────────────────────────────────────
//
//   POLÍTICA DE CAMBIOS A UN CONTRATO YA EXISTENTE (aplica desde el
//   momento en que exista al menos una implementación real — hoy no hay
//   ninguna, pero la política se fija ahora para no improvisarla bajo
//   presión más adelante):
//     • Agregar un miembro nuevo a una interfaz existente es un cambio
//       BREAKING para cualquier implementación futura — se prefiere un
//       contrato nuevo (que la implementación adopte cuando le convenga)
//       sobre ensanchar uno existente, salvo que el miembro nuevo sea
//       genuinamente parte de la MISMA responsabilidad (R3).
//     • Un método que deja de ser la forma correcta de hacer algo se
//       marca `@Deprecated('usar X en su lugar')` con una nota de
//       migración concreta — nunca se elimina en el mismo cambio que
//       introduce su reemplazo. Se elimina en un sprint posterior, una vez
//       que nada lo use.
//     • Todo cambio estructural (carpeta nueva, contrato movido,
//       renombrado) se documenta como entrada de CHANGELOG en
//       game_engine_charter.dart, sección 14 — el mismo mecanismo que ya
//       registró la adición de lifecycle/registry/events. La sección 4 de
//       este archivo (Status vs State) es la primera entrada pendiente de
//       ese changelog de mantenimiento futuro.
//     • Sin versionado semver — este módulo vive dentro de un único
//       paquete de aplicación (no uno publicado, ver la nota de
//       EMPAQUETADO DIFERIDO en game_engine_charter.dart, sección 1) — el
//       historial de commits + el changelog en comentarios cumplen el
//       mismo rol de trazabilidad sin la maquinaria de versionado de un
//       paquete independiente.
// ─────────────────────────────────────────────────────────────────────────────
