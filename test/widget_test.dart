// Test base del proyecto Jardín del Edén.
// Los tests reales se implementan en cada sprint junto a sus
// features correspondientes, siguiendo la estructura definida
// en el Flutter Technical Architecture Document (Sección 24).
//
// Estructura objetivo:
//   test/
//   ├── core/           ← Tests del módulo Core
//   ├── features/       ← Tests por feature (auth, economy, etc.)
//   ├── shared/         ← Tests de utilidades compartidas
//   └── helpers/        ← Fakes, fixtures, mocks reutilizables
//
// POR QUÉ ESTE ARCHIVO NO USA pumpApp() (test/helpers/pump_app.dart):
// pumpApp() envuelve un widget de FEATURE dentro de un MaterialApp sintético
// con `home:` — pensado para test/features/. JardinDelEdenApp, en cambio, ES
// el MaterialApp.router raíz (bootstrap.dart): trae su propio router,
// localización y tema. Envolverlo con pumpApp() duplicaría ese árbol
// (dos MaterialApp anidados). Este smoke test sí reutiliza la misma
// necesidad base de pumpApp() — ProviderScope + SharedPreferences mock —
// aplicada directamente porque el widget bajo prueba es la app completa, no
// una pantalla aislada.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jardindeleden/bootstrap.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('JardinDelEdenApp', () {
    testWidgets('renders placeholder screen without crashing', (tester) async {
      SharedPreferences.setMockInitialValues(const {});

      await tester.pumpWidget(const ProviderScope(child: JardinDelEdenApp()));

      expect(find.text('Jardín del Edén'), findsOneWidget);

      // SplashScreen arranca un Timer.delayed(2s) que navega a /profiles.
      // Se drena aquí (tiempo virtual de testWidgets, no espera real) para
      // que no quede un Timer pendiente al terminar el test — flutter_test
      // falla el test si un widget se descarta con un Timer todavía activo.
      await tester.pump(const Duration(seconds: 3));
    }, tags: ['widget']);
  });
}
