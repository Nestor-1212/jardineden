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
import 'package:flutter_test/flutter_test.dart';

import 'package:jardindeleden/main.dart';

void main() {
  group('JardinDelEdenApp', () {
    testWidgets('renders placeholder screen without crashing', (tester) async {
      await tester.pumpWidget(const JardinDelEdenApp());
      expect(find.text('Jardín del Edén'), findsOneWidget);
    });
  });
}
