// ─────────────────────────────────────────────────────────────────────────────
// core/quality/code_conventions.dart
//
// Este archivo NO contiene código ejecutable — es la referencia central de
// calidad del proyecto: nomenclatura, organización, documentación y
// métricas. Lo que SÍ puede verificar el analyzer/formatter automáticamente
// vive en analysis_options.yaml; lo que requiere criterio humano vive aquí,
// en el mismo formato de comentarios que el resto del código base (para que
// aparezca junto al código en el editor, no en un .md que nadie abre).
//
// Ver también test/test_conventions.dart (convenciones específicas de
// testing) — ese archivo y este se complementan, no se repiten.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// 1. NOMENCLATURA
// ─────────────────────────────────────────────────────────────────────────────
//
// Lo que YA fuerza el analyzer (ver analysis_options.yaml, heredado de
// package:lints/core.yaml) no se repite aquí: camel_case_types, file_names
// (snake_case), non_constant_identifier_names, constant_identifier_names.
// Lo que sigue es CONVENCIÓN DE PROYECTO — el analyzer no la puede verificar,
// se aplica por revisión de código.
//
// ARCHIVOS (snake_case, sin abreviar salvo abreviaturas de dominio ya
// establecidas como "bgm" o "sfx"):
//   feature_name_screen.dart        → pantalla completa (StatefulWidget o
//                                      ConsumerWidget de nivel de ruta).
//   widget_name.dart                → widget reutilizable, no es una ruta.
//   x_notifier.dart                 → Riverpod Notifier con estado.
//   x_provider.dart                 → Provider/FutureProvider sin clase propia.
//   x_service.dart / x_service_impl.dart → contrato + implementación, SIEMPRE
//                                      en archivos separados (ver Organización).
//   i_x_repository.dart / x_repository_impl.dart → mismo patrón para repos
//                                      (el prefijo "i_" en el archivo del
//                                      contrato es la convención de ESTE
//                                      proyecto para diferenciarlo a simple
//                                      vista en un listado de carpeta).
//   x_use_case.dart                 → un caso de uso, un archivo, una clase.
//   x_entity.dart / x_model.dart     → Entity (domain, sin serialización) vs
//                                      Model (data, con fromJson/toJson o
//                                      mapeo de fila de DB).
//   x_test.dart                     → ver test/test_conventions.dart.
//
// CLASES:
//   UpperCamelCase (forzado por el analyzer). Sufijos con significado:
//     ...Service / ...ServiceImpl   — infraestructura con estado o I/O.
//     ...Repository / ...RepositoryImpl — acceso a datos de un feature.
//     ...UseCase                    — una operación de negocio, un método
//                                      público (`call()`), sin estado propio.
//     ...Notifier                   — Riverpod StateNotifier/Notifier.
//     ...Screen                     — widget de nivel de ruta (registrado en
//                                      core/navigation/app_router.dart).
//     ...Card / ...Tile / ...Button — widgets reutilizables de presentación.
//     ...Exception                  — hereda de AppException (core/error/).
//
// PROVIDERS (Riverpod):
//   camelCase + sufijo Provider explícito solo cuando NO es obvio por el
//   tipo (`sharedPreferencesProvider` sí; un `@riverpod` generado ya expone
//   el nombre correcto automáticamente vía riverpod_generator — no renombrar
//   el generado a mano).
//
// BOOLEANOS:
//   Prefijo is/has/can/should (`isNarrating`, `hasProfile`, `canRetry`) —
//   nunca un sustantivo desnudo (`narrating` es ambiguo: ¿es un booleano o
//   una acción?).
//
// ─────────────────────────────────────────────────────────────────────────────
// 2. ORGANIZACIÓN
// ─────────────────────────────────────────────────────────────────────────────
//
// lib/
// ├── core/            Infraestructura transversal, sin conocimiento de
// │                    ningún feature específico. Un archivo en core/ NUNCA
// │                    importa de features/ (dirección de dependencia de un
// │                    solo sentido — ver el encabezado "DEPENDENCIAS
// │                    PERMITIDAS/PROHIBIDAS" de cada archivo).
// │   ├── <topic>/     Un core/<topic>/ por responsabilidad (error/, di/,
// │   │                logging/, theme/, accessibility/, storage/...) — NO
// │   │                un core/utils/ genérico donde todo termina cayendo
// │   │                sin criterio de búsqueda claro.
// │   └── infrastructure/<topic>/  Variante de core/<topic>/ para piezas que
// │                    SÍ dependen de Riverpod/paquetes externos concretos
// │                    (ver core/infrastructure/storage/ vs core/storage/ —
// │                    el contrato vive en el segundo, la implementación
// │                    conectada a Riverpod en el primero).
// │
// ├── features/<feature>/   Una carpeta por dominio de negocio (auth, world,
// │   ├── domain/            chapter, economy...). Clean Architecture de 3
// │   │   ├── entities/       capas dentro de cada feature:
// │   │   ├── repositories/    domain    → entidades + contratos de
// │   │   │   (contratos)                 repositorio, sin dependencias de
// │   │   └── use_cases/                  Flutter ni de paquetes externos.
// │   ├── data/                data      → implementa los contratos de
// │   │   ├── models/                     domain, habla con DB/API/
// │   │   ├── data_sources/                storage. Nunca expone Models
// │   │   └── repositories/                fuera de esta capa (mapea a
// │   │       (implementaciones)            Entity antes de devolver).
// │   └── presentation/        presentation → widgets + Notifiers. Es la
// │       ├── screens/                     ÚNICA capa que puede importar
// │       ├── widgets/                     Flutter Material/Cupertino.
// │       └── providers/
// │
// └── shared/          Design System + utilidades genéricas SIN lógica de
//     ├── ui/           negocio (ver shared/ui/animations/, shared/ui/media/).
//     ├── extensions/   Si algo en shared/ empieza a conocer un concepto de
//     ├── constants/    negocio (ej. "moneda del juego"), es una señal de
//     └── formatters/   que en realidad pertenece a features/economy/, no
//                       aquí — shared/ se prueba sin ningún feature cargado.
//
// REGLA DE DEPENDENCIA (una sola dirección, sin ciclos):
//   features/ → shared/ → core/
//   features/ → core/
//   core/<infra> → core/<topic> (nunca al revés)
//   Nunca: core/ → features/, shared/ → features/.
//
// BARRELS (archivos que solo re-exportan, ej. core/theme/design_tokens.dart):
//   Agrupan exports por SECCIÓN semántica con comentarios "── Sección ──",
//   no alfabéticamente — ver la excepción documentada en
//   core/theme/design_tokens.dart (`// ignore_for_file: directives_ordering`)
//   para el razonamiento completo.
//
// ─────────────────────────────────────────────────────────────────────────────
// 3. DOCUMENTACIÓN
// ─────────────────────────────────────────────────────────────────────────────
//
// CADA ARCHIVO NO TRIVIAL empieza con un bloque:
//   // ───────────────────────────────────────
//   // <ruta/relativa/desde/lib>
//   //
//   // RESPONSABILIDAD:
//   //   Qué hace este archivo y por qué existe como pieza separada.
//   //
//   // [Secciones opcionales según el archivo: DECISIÓN (comparación de
//   //  alternativas + por qué se descartaron), CICLO DE VIDA, USO, POR QUÉ
//   //  NO <alternativa obvia>.]
//   //
//   // DEPENDENCIAS PERMITIDAS:   ...
//   // DEPENDENCIAS PROHIBIDAS:   ...
//   // ───────────────────────────────────────
//
// Esto documenta el PORQUÉ (la parte que se pierde con el tiempo y que
// ningún nombre de variable puede transmitir), no el QUÉ (eso ya lo dice el
// código con buenos nombres — ver Nomenclatura arriba).
//
// DOC COMMENTS (///) en símbolos públicos de core/ y de los contratos
// (domain/repositories, domain/use_cases) — documentan casos borde,
// invariantes y post-condiciones no obvias por la firma. Usar [Symbol] para
// referenciar otros símbolos SOLO si son visibles en el mismo archivo (ver
// la regla comment_references de analysis_options.yaml, que ahora este
// proyecto verifica automáticamente — una referencia rota ahora es un ERROR
// de análisis, no un descuido silencioso).
//
// POR QUÉ NO SE ACTIVÓ public_member_api_docs:
//   Esa regla exige /// en TODO miembro público de TODO archivo — pensada
//   para paquetes publicados en pub.dev, donde cada símbolo público es un
//   contrato con consumidores externos que nunca van a leer el código
//   fuente. Este proyecto es una aplicación, no un paquete: el "consumidor"
//   de un getter trivial de un widget es otro desarrollador del mismo
//   equipo, que SÍ puede (y debe) leer el código. Forzar /// en cada
//   `final Widget child;` habría generado miles de comentarios que solo
//   repiten el nombre del campo, sin aportar nada que el propio nombre no
//   dijera ya — ruido, no documentación.
//
// ─────────────────────────────────────────────────────────────────────────────
// 4. FORMATO AUTOMÁTICO
// ─────────────────────────────────────────────────────────────────────────────
//
// `dart format .` (o guardar el archivo — ver .vscode/settings.json,
// editor.formatOnSave) es la única fuente de verdad del formato. Nadie
// discute espacios/indentación/saltos de línea en un PR — si `dart format`
// lo dejó así, está bien así.
//
// Configuración (ver bloque `formatter:` en analysis_options.yaml):
//   page_width: 80        — el default de dart_style, declarado explícito.
//   trailing_commas: automate — el formatter decide cuándo una coma final
//                          fuerza el multi-línea.
//
// `dart format --set-exit-if-changed .` es el gate de CI — si alguien
// olvidó formatear antes del commit, el pipeline lo rechaza con un mensaje
// claro (a diferencia de un warning de estilo que alguien puede ignorar).
//
// ─────────────────────────────────────────────────────────────────────────────
// 5. REGLAS PERSONALIZADAS (analysis_options.yaml)
// ─────────────────────────────────────────────────────────────────────────────
//
// Categorías activas, más allá de flutter_lints (ver analysis_options.yaml
// para el detalle línea por línea de CADA regla y su justificación):
//   • Asincronía y recursos: unawaited_futures, discarded_futures,
//     avoid_void_async, cancel_subscriptions, close_sinks — previenen que un
//     error de una operación async se pierda en silencio (nunca llega al
//     GlobalErrorHandler, ver core/error/).
//   • Imports: always_use_package_imports, directives_ordering,
//     combinators_ordering.
//   • Const/final/null-safety: maximizan que Flutter salte reconstrucciones
//     innecesarias y que el tipo exprese la intención real.
//   • Documentación: comment_references (elevado a ERROR — ver sección 3).
//   • Widgets: use_colored_box, use_decorated_box (evitan el costo de
//     Container cuando no se necesita su maquinaria completa).
//
// REGLAS EVALUADAS Y DESCARTADAS (con la razón concreta, no solo "no nos
// gustó" — verificado contra el código REAL del proyecto, no en abstracto):
//   • sort_constructors_first / sort_unnamed_constructors_first — 10+ clases
//     existentes ya siguen un patrón deliberado y consistente distinto
//     (factories secundarios junto a su documentación semántica, no todos
//     apilados arriba). Ver Nomenclatura/Organización arriba para el orden
//     recomendado en código NUEVO, aplicado por revisión, no por el analyzer.
//   • public_member_api_docs — ver sección 3.
//   • sort_pub_dependencies — pubspec.yaml agrupa dependencias por CATEGORÍA
//     funcional con comentarios explicativos (State Management, Database,
//     Security...), no alfabéticamente. Es la misma decisión que los barrels
//     de core/theme/ — orden de lectura humana sobre orden mecánico.
//
// ─────────────────────────────────────────────────────────────────────────────
// 6. MÉTRICAS
// ─────────────────────────────────────────────────────────────────────────────
//
// DECISIÓN: herramientas NATIVAS por ahora, sin agregar Dart Code Metrics
// (DCM) ni ninguna otra dependencia de análisis de complejidad.
//
//   Cobertura de tests:
//     flutter test --coverage
//     genera coverage/lcov.info (ya excluido de git — ver .gitignore).
//     Para un reporte HTML navegable localmente (requiere `lcov`/`genhtml`
//     instalado en la máquina, no viene con Flutter):
//       genhtml coverage/lcov.info -o coverage/html
//     No hay un umbral global de cobertura forzado por CI todavía — el
//     proyecto está en una etapa donde MUCHO código es infraestructura
//     (contratos, stubs documentados) sin lógica que cubrir de forma
//     significativa. Un umbral numérico ciego (ej. "80% o falla el build")
//     antes de tener features completas premiaría tests triviales que
//     inflan el número sin proteger nada real.
//
//   Complejidad / mantenibilidad (tamaño de archivo, tamaño de función,
//   complejidad ciclomática): sin herramienta automatizada. Referencia para
//   revisión de código (no un límite duro que bloquee CI):
//     • Un archivo que supera ~300-400 líneas es una señal para preguntar
//       "¿esto son en realidad dos responsabilidades?" — no una regla
//       matemática exacta.
//     • Un método que necesita scrollear para leerse completo probablemente
//       se beneficia de extraer sub-métodos con nombres que documenten cada
//       paso.
//     • Un widget `build()` con más de 3-4 niveles de anidación se
//       beneficia de extraer sub-widgets con nombre propio (más fácil de
//       testear con test/helpers/pump_app.dart, además de más legible).
//
//   POR QUÉ NO DCM (Dart Code Metrics / dartcodemetrics.dev) TODAVÍA:
//     Es una herramienta real y específicamente diseñada para esto
//     (complejidad ciclomática, código duplicado, mantenibilidad, con
//     reportes automáticos) — no se descartó por falta de valor. Se
//     pospuso porque es un producto con licencia (gratuita para uso
//     individual/no-comercial bajo su licencia actual, de pago para
//     equipos) y agrega un plugin de analyzer adicional a mantener. Con el
//     proyecto todavía en fase de infraestructura (pocas features
//     completas con lógica de negocio real que medir), el costo de
//     adopción no se justifica todavía.
//     RECONSIDERAR cuando: 1) el número de features con lógica de negocio
//     real crezca lo suficiente para que la revisión manual dejar pasar
//     complejidad sea una preocupación concreta (no hipotética), o 2) el
//     equipo crezca más allá de una revisión de código por PR viable a ojo.
//     Si se activa: agregar como dev_dependency + plugin de analyzer,
//     documentar la decisión de licencia (individual vs equipo) aquí mismo.
//
// ─────────────────────────────────────────────────────────────────────────────
// QUÉ NO HACER
// ─────────────────────────────────────────────────────────────────────────────
//
// ✗ core/ importando de features/ — rompe la regla de dependencia de un
//   solo sentido (sección 2).
// ✗ Un core/utils.dart genérico — cada pieza de infraestructura vive en su
//   propio core/<topic>/, aunque sea un archivo pequeño.
// ✗ Lógica de negocio en shared/ — si necesita saber qué es una "misión" o
//   una "moneda del juego", pertenece a features/, no a shared/.
// ✗ Un Future de I/O real (storage, DB, red) ignorado sin unawaited() — ver
//   sección 5, esa es la clase de bug que unawaited_futures/discarded_futures
//   existen para atrapar.
// ✗ Renombrar a mano un provider generado por riverpod_generator — el
//   nombre lo decide la anotación @riverpod, no una preferencia de estilo.
// ✗ Copiar-pegar el bloque de encabezado de otro archivo sin adaptar
//   RESPONSABILIDAD/DEPENDENCIAS al archivo real — un encabezado
//   desactualizado es peor que no tener encabezado, porque activamente
//   desinforma (mismo principio que comment_references, sección 3).
// ─────────────────────────────────────────────────────────────────────────────
