// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/storage/shared_prefs_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de SharedPreferences para toda la app.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   SharedPreferences.getInstance() carga un caché interno la primera vez.
//   Llamadas posteriores devuelven el mismo objeto del sistema.
//   Se calienta en AppDI.init() antes de runApp() para evitar FutureProvider
//   spinners durante el splash screen.
//
// USO EN OTROS PROVIDERS:
//   ```dart
//   @riverpod
//   MyClass myThing(MyThingRef ref) {
//     // Esperar a que SharedPrefs esté disponible (es FutureProvider)
//     final prefs = ref.watch(sharedPreferencesProvider).requireValue;
//     return MyClass(prefs: prefs);
//   }
//   ```
//
// USO EN WIDGETS (dentro de ConsumerWidget):
//   ```dart
//   final prefsAsync = ref.watch(sharedPreferencesProvider);
//   prefsAsync.when(
//     data: (prefs) => Text(prefs.getString(SharedPrefKeys.selectedLanguage) ?? 'es'),
//     loading: () => const CircularProgressIndicator(),
//     error: (e, _) => Text('Error: $e'),
//   );
//   ```
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, shared_preferences.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_provider.g.dart';

/// Instancia global de [SharedPreferences].
///
/// [keepAlive: true] — nunca se descarta mientras la app esté viva.
/// Es un [FutureProvider] porque [SharedPreferences.getInstance()] es asíncrono.
/// Pre-calentado en [AppDI.init()] para que esté disponible desde el primer frame.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) =>
    SharedPreferences.getInstance();
