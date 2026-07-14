// ─────────────────────────────────────────────────────────────────────────────
// core/di/app_di.dart
//
// RESPONSABILIDAD:
//   Bootstrap central de Dependency Injection para Jardín del Edén.
//
// DECISIÓN: Riverpod como DI Framework (ver comparación completa en Sprint 08)
//
//   get_it:
//     ✗ Service locator (anti-patrón) — las dependencias son ocultas.
//     ✗ No reactivo — los cambios de estado no se propagan.
//     ✗ Duplica lo que Riverpod ya hace mejor.
//     → Descartado.
//
//   Provider (InheritedWidget wrapper):
//     ✗ Requiere BuildContext para acceder a dependencias.
//     ✗ Sin code generation — más boilerplate.
//     ✗ Supersedido por Riverpod del mismo autor.
//     → Descartado.
//
//   Injectable (get_it + code generation):
//     ✓ Tipo-safe gracias a anotaciones.
//     ✗ Requiere get_it + build_runner + injectable (3 paquetes adicionales).
//     ✗ build_runner ya lo usa Drift + Riverpod — agregar otro builder ralentiza.
//     ✗ La API de get_it es inferior a Riverpod en reactividad.
//     → Descartado.
//
//   BLoC/Cubit:
//     ✓ Patrón conocido en Flutter.
//     ✗ No provee DI nativo — necesita get_it o similar por separado.
//     ✗ Más boilerplate que Riverpod Notifiers.
//     → Descartado.
//
//   Riverpod + riverpod_generator (SELECCIONADO):
//     ✓ DI + State Management en un solo framework (sin duplicación).
//     ✓ @Riverpod(keepAlive: true) = Singleton; @riverpod = Factory.
//     ✓ Grafo de dependencias explícito y verificado en compile time.
//     ✓ Testing con ProviderContainer(overrides: [...]) sin mocks externos.
//     ✓ Reactivo: los providers se recalculan cuando sus dependencias cambian.
//     ✓ Ya en pubspec.yaml desde el inicio del proyecto.
//     → SELECCIONADO.
//
// CICLOS DE VIDA DE PROVIDERS:
//
//   @Riverpod(keepAlive: true) = Singleton
//     Se crea una sola vez. Nunca se descarta mientras el ProviderContainer viva.
//     Usar para: Database, SecureStorage, SharedPreferences, AudioPlayer, Uuid,
//     HttpClient (futuro), Repositories, Use Cases (stateless).
//
//   @riverpod (autoDispose: true) = Factory
//     Se crea cuando alguien lo observa (ref.watch). Se descarta automáticamente
//     cuando ya nadie lo observa (salida de pantalla, etc).
//     Usar para: ViewModels/Notifiers de pantalla, form states, búsquedas.
//
//   @Riverpod(keepAlive: true) + class Notifier = Singleton con Estado
//     Un Notifier que persiste durante toda la sesión.
//     Usar para: AuthState, AudioSettings, AppSettings.
//
// PATRÓN DE INICIALIZACIÓN:
//   AppDI.init() crea un ProviderContainer pre-calentado con los providers
//   asincrónicos críticos ya resueltos. Esto evita que el splash muestre
//   indicadores de carga para operaciones que pueden ser eager.
//
// DEPENDENCIAS PERMITIDAS:   flutter, flutter_riverpod, shared_preferences,
//                            core/infrastructure/storage.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jardindeleden/core/infrastructure/storage/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bootstrap central de Dependency Injection.
///
/// Inicializa el [ProviderContainer] antes de [runApp()] para que los
/// providers asincrónicos estén disponibles desde el primer frame.
abstract final class AppDI {
  // ── API de Producción ─────────────────────────────────────────────────────

  /// Inicializa el grafo de dependencias de producción.
  ///
  /// Llama a este método en [main()] ANTES de [runApp()]:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   final container = await AppDI.init();
  ///   runApp(
  ///     UncontrolledProviderScope(
  ///       container: container,
  ///       child: const JardinDelEdenApp(),
  ///     ),
  ///   );
  /// }
  /// ```
  static Future<ProviderContainer> init() async {
    final container = ProviderContainer(
      observers: kDebugMode ? const [_ProviderLogger()] : const [],
    );

    // ── Warm-up de providers asincrónicos críticos ───────────────────────────
    //
    // SharedPreferences: ~5ms en primer acceso. Calentarlo aquí evita un
    // FutureProvider spinner en el splash screen.
    await container.read(sharedPreferencesProvider.future);

    // secureStorageProvider: síncrono — no necesita warm-up.
    // appDatabaseProvider: diferido — se inicializa al primer acceso autenticado.
    //   La clave de cifrado requiere que el usuario haya pasado por /profiles.
    //   Sprint Auth: precalentar aquí después de validar el perfil activo.

    return container;
  }

  // ── API de Testing ────────────────────────────────────────────────────────

  /// Crea los overrides para tests unitarios.
  ///
  /// Permite reemplazar cualquier provider de infraestructura con un fake.
  /// Sprint DB: agregar override para appDatabaseProvider con DB en memoria.
  ///
  /// ```dart
  /// // test/features/profiles/profile_test.dart
  /// final container = ProviderContainer(
  ///   overrides: [
  ///     ...AppDI.testOverrides(sharedPrefs: FakeSharedPreferences()),
  ///     profileRepositoryProvider.overrideWith(
  ///       (ref) => FakeProfileRepository(),
  ///     ),
  ///   ],
  /// );
  /// addTearDown(container.dispose);
  /// ```
  static List<Override> testOverrides({SharedPreferences? sharedPrefs}) {
    return [
      if (sharedPrefs != null)
        sharedPreferencesProvider.overrideWith((_) async => sharedPrefs),
    ];
  }
}

/// Observer de Riverpod que loguea el ciclo de vida de providers en debug.
///
/// Solo activo en [kDebugMode] (eliminado en release builds).
final class _ProviderLogger extends ProviderObserver {
  const _ProviderLogger();

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint('[DI] + ${provider.name ?? provider.runtimeType}');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint('[DI] ✗ ${provider.name ?? provider.runtimeType}: $error');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    debugPrint('[DI] ⌫ ${provider.name ?? provider.runtimeType}');
  }
}
