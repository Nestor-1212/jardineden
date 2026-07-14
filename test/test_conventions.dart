// ─────────────────────────────────────────────────────────────────────────────
// test/test_conventions.dart
//
// Este archivo NO contiene código ejecutable — es documentación de las
// convenciones de testing del proyecto, en el mismo formato de comentarios
// que el resto del código base (para que aparezca junto al código en el
// editor y en `git blame`, en vez de vivir en un .md aparte que se
// desactualiza sin que nadie lo note). Referenciado desde dart_test.yaml.
//
// ─────────────────────────────────────────────────────────────────────────────
// LA PIRÁMIDE DE TESTING DE ESTE PROYECTO
// ─────────────────────────────────────────────────────────────────────────────
//
//                        ▲
//                       /│\        Integration (integration_test/)
//                      / │ \       — pocos, lentos, app completa en un
//                     /  │  \        dispositivo/emulador real.
//                    /───┼───\
//                   / Golden  \    Golden (test/golden/, tag: golden)
//                  /  ┼  │  ┼  \   — una por componente visual estable.
//                 /────────────\
//                /   Widget     \  Widget (test/features/, tag: widget)
//               /  ┼  ┼  │  ┼  ┼ \ — la mayoría de los tests de UI.
//              /──────────────────\
//             /       Unit         \ Unit (test/core/, test/shared/, tag: unit)
//            /  ┼  ┼  ┼  │  ┼  ┼  ┼ \ — la base: lógica pura, la más rápida.
//           /──────────────────────\
//
// Regla general: si una lógica se puede probar sin un Widget, PROBARLA sin
// un Widget (unit). Si se puede probar sin toda la app, PROBARLA sin toda
// la app (widget). Integration es para lo que solo se puede verificar con
// el stack completo corriendo (navegación real, persistencia real).
//
// Accessibility y Performance NO son un nivel más de la pirámide, sino un
// EJE TRANSVERSAL: se aplican tanto a widget tests (accessibility, con el
// tag `accessibility`) como a integration tests (performance, ver
// integration_test/performance/).
//
// ─────────────────────────────────────────────────────────────────────────────
// 1. UNIT TESTING — test/core/, test/shared/ — tag: unit
// ─────────────────────────────────────────────────────────────────────────────
//
// QUÉ: Lógica pura sin Widget ni BuildContext — validadores, mappers,
// cálculos (AppBreakpoints.screenSizeOf, use cases, extensions).
// ESTRUCTURA: espeja lib/ 1 a 1.
//   lib/core/theme/app_breakpoints.dart → test/core/theme/app_breakpoints_test.dart
// FAKES vs MOCKS: ver test/helpers/fakes/fake_storage_service.dart para
// cuándo usar cada uno.
// VELOCIDAD: no debería haber I/O real ni `await Future.delayed` — si una
// prueba "unitaria" necesita eso, probablemente es un widget test disfrazado.
//
// ─────────────────────────────────────────────────────────────────────────────
// 2. WIDGET TESTING — test/features/ — tag: widget
// ─────────────────────────────────────────────────────────────────────────────
//
// QUÉ: Un widget o pantalla aislada, con sus interacciones (tap, scroll,
// entrada de texto) y su estado visual resultante.
// CÓMO: SIEMPRE con pumpApp() (test/helpers/pump_app.dart) en vez de
// MaterialApp a mano — ver el porqué en el encabezado de ese archivo.
// ESTRUCTURA: espeja lib/features/ 1 a 1.
//   lib/features/profiles/presentation/profile_card.dart
//     → test/features/profiles/presentation/profile_card_test.dart
// OVERRIDES: pasar los providers específicos del feature vía el parámetro
// `overrides` de pumpApp() — NUNCA leer el ProviderContainer real de
// producción en un test.
//
// ─────────────────────────────────────────────────────────────────────────────
// 3. GOLDEN TESTING — test/golden/goldens/ — tag: golden
// ─────────────────────────────────────────────────────────────────────────────
//
// QUÉ: Comparación pixel-a-pixel contra una imagen de referencia — detecta
// regresiones visuales que un `expect(find.text(...))` no puede ver (un
// color equivocado, un padding roto, un ícono mal alineado).
// CÓMO: expectGolden() / expectResponsiveGolden() de
// test/helpers/golden_test_helper.dart. Ver ese archivo para la decisión de
// no usar golden_toolkit/alchemist.
// CUÁNDO SÍ: componentes visuales ESTABLES del Design System (botones,
// cards, HUD) — el costo de mantenimiento (regenerar en cada cambio
// intencional) supera el beneficio en pantallas que cambian a cada sprint.
// CUÁNDO NO: pantallas todavía en desarrollo activo, contenido dinámico
// (fechas, datos de red) sin fijar previamente.
// REGENERAR: `flutter test --tags golden --update-goldens`. El diff de las
// imágenes se revisa en el PR igual que cualquier otro cambio.
//
// ─────────────────────────────────────────────────────────────────────────────
// 4. INTEGRATION TESTING — integration_test/ — sin tag, runner propio
// ─────────────────────────────────────────────────────────────────────────────
//
// QUÉ: La app completa, de punta a punta, en un dispositivo o emulador real
// — flujos que cruzan varias pantallas y tocan persistencia real (Drift,
// SharedPreferences reales, no fakes).
// CÓMO SE CORRE (requiere un dispositivo/emulador conectado):
//   flutter test integration_test/                    # todos
//   flutter test integration_test/auth_flow_test.dart  # uno solo
// NO usa dart_test.yaml/tags — es un runner distinto al de `flutter test`
// sobre test/. Cada archivo es su propio `main()` con
// IntegrationTestWidgetsFlutterBinding.ensureInitialized() como primera línea.
// CUÁNDO: flujos críticos de negocio (login → selección de perfil → mundo),
// NO para cada pantalla individual (eso es widget testing, mucho más rápido).
//
// ─────────────────────────────────────────────────────────────────────────────
// 5. PERFORMANCE TESTING — integration_test/performance/ + test_driver/
// ─────────────────────────────────────────────────────────────────────────────
//
// QUÉ: Captura de timeline de frames (jank, tiempo de construcción de
// widgets) durante una interacción real, vía
// IntegrationTestWidgetsFlutterBinding.instance.traceAction().
// CÓMO SE CORRE (requiere `--profile`, ver test_driver/perf_driver.dart):
//   flutter drive \
//     --driver=test_driver/perf_driver.dart \
//     --target=integration_test/performance/<nombre>_test.dart \
//     --profile
// PATRÓN DEL TEST (cuando se escriba uno real):
//   ```dart
//   final timeline = await binding.traceAction(() async {
//     // interacción a medir: scroll, animación, navegación
//   });
//   await binding.convertTimelineToSummary(timeline: timeline);
//   ```
// UMBRAL DE ACEPTACIÓN: sin jank a 60fps = ningún frame de build/raster
// > 16ms (o > 8ms si el dispositivo objetivo corre a 120fps). Se define por
// escenario al escribir el test — no hay un umbral global único porque un
// minijuego con partículas tolera más costo por frame que una pantalla de menú.
//
// ─────────────────────────────────────────────────────────────────────────────
// 6. ACCESSIBILITY TESTING — junto a los widget tests — tag: accessibility
// ─────────────────────────────────────────────────────────────────────────────
//
// QUÉ: Verificación automática de guidelines de accesibilidad (contraste,
// tamaño de objetivo táctil, etiquetado) — complementa, NO reemplaza, la
// verificación manual con TalkBack/VoiceOver real.
// CÓMO: expectMeetsAccessibilityGuidelines() de
// test/helpers/accessibility_test_helper.dart, DESPUÉS de pumpApp().
// CUÁNDO: cualquier widget interactivo nuevo (botón, card tocable, control
// de formulario) — no hace falta en widgets puramente decorativos sin
// semántica (un fondo, un separador).
// LO QUE ESTO NO CUBRE: daltonismo, alto contraste, reducción de
// animaciones — esos son axes de core/accessibility/ (ya implementados) y
// se prueban como unit/widget tests normales verificando el tema/color
// resultante, no como "guideline" — ver el encabezado de
// accessibility_test_helper.dart para el detalle completo.
//
// ─────────────────────────────────────────────────────────────────────────────
// CONVENCIONES DE NOMBRADO Y ORGANIZACIÓN
// ─────────────────────────────────────────────────────────────────────────────
//
// • Archivo: `<nombre_del_archivo_probado>_test.dart`, en la carpeta que
//   espeja la ubicación del archivo en lib/.
// • `group()`: agrupa por método/comportamiento, no por archivo (el archivo
//   ya agrupa por clase).
// • Nombres de test en español, en presente, describiendo el COMPORTAMIENTO
//   esperado, no la implementación:
//     ✓ 'retorna null cuando la clave no existe'
//     ✗ 'test getString'
// • Un `expect()` por concepto verificado — varios `expect()` en un mismo
//   test están bien si verifican la MISMA operación desde ángulos distintos;
//   si verifican operaciones distintas, son tests distintos.
// • `tags: ['unit']` / `['widget']` / `['golden']` / `['accessibility']` en
//   cada `test()`/`testWidgets()` — ver dart_test.yaml para qué agrupa cada tag.
// • `addTearDown(...)` para cualquier recurso que deba liberarse
//   (ProviderContainer.dispose, SemanticsHandle.dispose) — nunca un
//   `tearDown()` global que no sepa qué recurso pertenece a qué test.
//
// ─────────────────────────────────────────────────────────────────────────────
// QUÉ NO HACER
// ─────────────────────────────────────────────────────────────────────────────
//
// ✗ MaterialApp a mano en un widget test → usar pumpApp().
// ✗ Leer AppDI.init() (el container de PRODUCCIÓN) en un test → usar
//   ProviderScope(overrides: ...) con fakes.
// ✗ pumpAndSettle() en goldens → puede colgarse con animaciones infinitas,
//   usar tester.pump(kGoldenSettleDuration) (ver golden_test_helper.dart).
// ✗ Golden tests de pantallas en desarrollo activo → esperar a que el
//   diseño se estabilice, si no cada sprint regenera goldens sin aportar
//   señal real de regresión.
// ✗ Mock cuando el colaborador tiene estado relevante → usar un Fake (ver
//   fake_storage_service.dart).
// ✗ Integration test para algo que un widget test ya cubre → integration
//   test es caro (dispositivo real); reservarlo para lo que de verdad lo
//   necesita.
// ─────────────────────────────────────────────────────────────────────────────
