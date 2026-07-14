// ─────────────────────────────────────────────────────────────────────────────
// test/helpers/pump_app.dart
//
// RESPONSABILIDAD
// Harness único para levantar un widget bajo prueba dentro de un árbol
// mínimo pero REALISTA: ProviderScope (Riverpod) + MaterialApp con los mismos
// delegates de localización, locale soportado y tema que usa la app real
// (ver lib/bootstrap.dart). Evita que cada archivo de test reconstruya ese
// árbol a mano — la razón #1 de tests de widgets frágiles es que un test
// envuelve el widget en un MaterialApp() desnudo, sin AppLocalizations, y
// falla con "No MaterialLocalizations found" o "No Directionality widget
// found" en cuanto el widget real usa texto localizado o Directionality.
//
// POR QUÉ NO USA JardinDelEdenApp DIRECTAMENTE
// JardinDelEdenApp (bootstrap.dart) monta MaterialApp.router con GoRouter
// completo — apropiado para pruebas de INTEGRACIÓN (ver integration_test/),
// no para widget tests aislados. Un widget test quiere levantar SOLO el
// widget bajo prueba con `home:`, sin que el router real decida qué pantalla
// mostrar. Este helper replica el resto del árbol (tema, localización,
// Riverpod) sin arrastrar la navegación real.
//
// SHAREDPREFERENCES EN TESTS
// `SharedPreferences.setMockInitialValues({})` es el mecanismo OFICIAL del
// paquete shared_preferences para tests (no requiere mockear MethodChannel a
// mano) — ver https://pub.dev/packages/shared_preferences (sección Testing).
// Se llama ANTES de construir el árbol porque sharedPreferencesProvider
// (core/infrastructure/storage/shared_prefs_provider.dart) llama
// SharedPreferences.getInstance() internamente, y esa llamada debe encontrar
// los valores mock ya establecidos.
//
// DEPENDENCIAS PERMITIDAS: flutter_test, flutter_riverpod, shared_preferences,
// core/di/app_di.dart, core/theme/app_theme.dart, l10n/generated.
// DEPENDENCIAS PROHIBIDAS: core/navigation/app_router.dart (ver nota arriba
// — la navegación real es responsabilidad de integration_test/, no de
// widget tests unitarios).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jardindeleden/core/theme/app_theme.dart';
import 'package:jardindeleden/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Levanta [child] dentro de un árbol mínimo equivalente al de la app real.
///
/// Uso típico en un test de widget:
/// ```dart
/// testWidgets('muestra el botón de continuar', (tester) async {
///   await pumpApp(tester, child: const ContinueButton());
///
///   expect(find.text('Continuar'), findsOneWidget);
/// });
/// ```
///
/// Para overrides de providers específicos del feature bajo prueba (además
/// de los fakes que ya provee este helper):
/// ```dart
/// await pumpApp(
///   tester,
///   child: const ProfileCard(),
///   overrides: [profileRepositoryProvider.overrideWith((ref) => FakeProfileRepository())],
/// );
/// ```
Future<void> pumpApp(
  WidgetTester tester, {
  required Widget child,
  List<Override> overrides = const [],
  Map<String, Object>? sharedPrefsValues,
  Locale locale = const Locale('es'),
  ThemeData? theme,
  bool settle = false,
}) async {
  SharedPreferences.setMockInitialValues(sharedPrefsValues ?? const {});

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme ?? AppTheme.light,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );

  // `settle: true` espera a que terminen animaciones/microtasks pendientes
  // (transiciones, FutureProvider en loading) — NO usarlo por defecto porque
  // pumpAndSettle falla con timeout si el widget tiene una animación
  // infinita (ej. un spinner de carga permanente por diseño).
  if (settle) {
    await tester.pumpAndSettle();
  }
}

/// Redimensiona la superficie de renderizado del test (útil para simular un
/// tamaño de dispositivo específico) y registra la restauración automática
/// al tamaño por defecto al terminar el test — evita que un test deje la
/// superficie alterada y afecte al siguiente test del mismo archivo.
///
/// Ver test/helpers/golden_test_helper.dart, que usa esto para recorrer la
/// matriz de tamaños de ScreenSize (core/theme/app_breakpoints.dart) en
/// goldens responsivos.
Future<void> setSurfaceSizeForTest(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
}
