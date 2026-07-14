import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jardindeleden/core/di/app_di.dart';
import 'package:jardindeleden/core/navigation/app_router.dart';
import 'package:jardindeleden/core/theme/app_theme.dart';
import 'package:jardindeleden/l10n/generated/app_localizations.dart';

/// Punto de entrada de la aplicación.
///
/// El orden de inicialización es crítico:
///   1. WidgetsFlutterBinding — requerido antes de usar plugins Flutter.
///   2. AppDI.init()          — calienta providers async antes del primer frame.
///   3. runApp()              — inicia el árbol de widgets con el container listo.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa el grafo de DI y precalienta SharedPreferences antes de runApp.
  // Esto evita que el splash screen muestre spinners de carga para operaciones
  // de infraestructura que pueden resolverse antes del primer frame.
  final container = await AppDI.init();

  runApp(
    // UncontrolledProviderScope pasa el container pre-calentado al árbol.
    // A diferencia de ProviderScope, no crea un container nuevo — usa el
    // que ya inicializamos con AppDI.init().
    UncontrolledProviderScope(
      container: container,
      child: const JardinDelEdenApp(),
    ),
  );
}

/// Widget raíz de la aplicación.
///
/// [ConsumerWidget] (en lugar de [StatelessWidget]) para leer
/// [appRouterProvider] desde Riverpod sin BuildContext adicional.
class JardinDelEdenApp extends ConsumerWidget {
  const JardinDelEdenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Jardín del Edén',
      debugShowCheckedModeBanner: false,

      // ── Temas Material 3 (Sprint 05) ─────────────────────────────────────
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // ── Internacionalización (Sprint 06) ─────────────────────────────────
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // ── Navegación GoRouter (Sprint 07) ───────────────────────────────────
      routerConfig: router,
    );
  }
}
