// ─────────────────────────────────────────────────────────────────────────────
// test/helpers/golden_test_helper.dart
//
// RESPONSABILIDAD
// Helpers para golden testing (comparación pixel-a-pixel de un widget
// renderizado contra una imagen de referencia en test/golden/goldens/) sobre
// las capacidades NATIVAS de flutter_test — sin agregar golden_toolkit ni
// alchemist como dependencia.
//
// POR QUÉ NO golden_toolkit / alchemist
// Ambos paquetes existen principalmente para resolver dos problemas que
// flutter_test ya resuelve de forma nativa desde Flutter 3.x:
//   1. Carga de fuentes reales en tests → resuelto por
//      test/flutter_test_config.dart (FontLoader), sin dependencia extra.
//   2. Comparar un widget en múltiples tamaños de pantalla → resuelto aquí
//      mismo con TestWidgetsFlutterBinding.setSurfaceSize + un loop, sin
//      necesitar el "DeviceBuilder" de esos paquetes.
// Agregar una dependencia de terceros para reimplementar algo que el SDK ya
// ofrece aumenta la superficie de mantenimiento (versionado, breaking
// changes de un paquete no oficial) sin una capacidad nueva real a cambio.
// Si en el futuro aparece una necesidad concreta que matchesGoldenFile no
// cubra (ej. diffing perceptual en vez de exacto), esa sería la señal para
// reabrir esta decisión — no antes.
//
// CÓMO SE GENERAN/ACTUALIZAN LOS GOLDENS
//   flutter test --tags golden                  # compara contra los existentes
//   flutter test --tags golden --update-goldens  # (re)genera las referencias
// Todo cambio de diseño intencional debe correr con --update-goldens y el
// diff de las imágenes resultantes debe revisarse en el PR como cualquier
// otro cambio de código — una imagen golden es parte del contrato del
// widget, no un artefacto generado que se pueda ignorar.
//
// DETERMINISMO
// Los goldens son frágiles a cualquier fuente de no-determinismo: animaciones
// a medio reproducir, cursores parpadeantes, fuentes no cargadas. Por eso
// goldenGoldenTest() (más abajo) fuerza tester.pump() con un Duration grande
// en vez de pumpAndSettle() — pumpAndSettle() puede colgarse o capturar un
// frame intermedio si algo tiene una animación infinita (spinner), mientras
// que un pump() con duración explícita siempre termina en un estado conocido.
//
// DEPENDENCIAS PERMITIDAS: flutter_test, core/theme/app_breakpoints.dart
// (ScreenSize — fuente única de verdad de los tamaños de pantalla del
// proyecto), test/helpers/pump_app.dart.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jardindeleden/core/theme/app_breakpoints.dart';

/// Tamaño lógico representativo de cada [ScreenSize], usado para poblar
/// goldens responsivos. Los valores caen deliberadamente DENTRO de cada
/// rango de [AppBreakpoints] (no justo en el límite) para que un ajuste
/// futuro de +-1px en un breakpoint no reclasifique el tamaño de prueba.
const Map<ScreenSize, Size> goldenDeviceSizes = {
  ScreenSize.compactPhone: Size(360, 690), // ej. iPhone SE / Android compacto
  ScreenSize.phone: Size(540, 960), // ej. teléfono Android grande
  ScreenSize.phablet: Size(700, 1000), // plegable abierto / phablet
  ScreenSize.tablet: Size(900, 1200), // tablet 8-10"
  ScreenSize.largeTablet: Size(1200, 1600), // tablet 11"+ / Chromebook
};

/// Renderiza [child] y lo compara contra el golden en
/// `test/golden/goldens/$goldenName.png`.
///
/// A diferencia de `pumpWidget` + `expectLater(matchesGoldenFile(...))` a
/// mano, este helper:
/// 1. Usa `tester.pump(kGoldenSettleDuration)` en vez de `pumpAndSettle()`
///    (ver nota de determinismo arriba).
/// 2. Envuelve `child` en `RepaintBoundary`, requerido por
///    `matchesGoldenFile` para capturar exactamente el árbol del widget
///    (sin esto, Flutter compara el frame completo incluyendo el fondo del
///    test surface, y cualquier cambio ajeno al widget rompe el golden).
///
/// Ejemplo:
/// ```dart
/// testWidgets('LumiAvatar golden', (tester) async {
///   await expectGolden(tester, child: const LumiAvatar(), goldenName: 'lumi_avatar');
/// }, tags: ['golden']);
/// ```
Future<void> expectGolden(
  WidgetTester tester, {
  required Widget child,
  required String goldenName,
  Size surfaceSize = const Size(540, 960),
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(RepaintBoundary(child: child));
  await tester.pump(kGoldenSettleDuration);

  await expectLater(
    find.byType(RepaintBoundary).first,
    matchesGoldenFile('goldens/$goldenName.png'),
  );
}

/// Igual que [expectGolden], pero repite la captura para cada tamaño de
/// [goldenDeviceSizes] — el nombre de archivo final es `$goldenName_<size>.png`
/// (ej. `lumi_avatar_phone.png`, `lumi_avatar_tablet.png`).
///
/// Usar cuando el widget bajo prueba cambia de layout entre breakpoints
/// (ver core/theme/app_breakpoints.dart) — no para widgets de tamaño fijo,
/// donde un solo [expectGolden] alcanza.
Future<void> expectResponsiveGolden(
  WidgetTester tester, {
  required Widget Function() childBuilder,
  required String goldenName,
  Set<ScreenSize> sizes = const {
    ScreenSize.compactPhone,
    ScreenSize.phone,
    ScreenSize.phablet,
    ScreenSize.tablet,
    ScreenSize.largeTablet,
  },
}) async {
  for (final screenSize in sizes) {
    final size = goldenDeviceSizes[screenSize]!;
    await expectGolden(
      tester,
      child: childBuilder(),
      goldenName: '${goldenName}_${screenSize.name}',
      surfaceSize: size,
    );
  }
}

/// Duración de pump usada en lugar de `pumpAndSettle()` para goldens — ver
/// nota de determinismo en el encabezado de este archivo.
const Duration kGoldenSettleDuration = Duration(milliseconds: 500);
