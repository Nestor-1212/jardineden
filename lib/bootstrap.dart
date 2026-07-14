// ─────────────────────────────────────────────────────────────────────────────
// bootstrap.dart
//
// RESPONSABILIDAD:
//   Lógica de arranque de la aplicación, COMPARTIDA por los 4 ambientes.
//   Cada lib/main_<ambiente>.dart (development/qa/staging/production) es un
//   archivo de 3 líneas que solo llama a [bootstrap] — ver esos archivos.
//
// POR QUÉ UN bootstrap() SEPARADO EN VEZ DE 4 main() DUPLICADOS:
//   El AMBIENTE (AppEnvironment: dev/qa/staging/prod) lo decide
//   `--dart-define=ENV=...` en tiempo de compilación — no importa qué
//   archivo se ejecute como entry point. Los 4 archivos main_*.dart existen
//   por una razón DISTINTA: emparejar 1 a 1 con los flavors NATIVOS de
//   Android/iOS (ver android/app/build.gradle.kts e ios/Flutter/*.xcconfig),
//   que sí necesitan un entry point (`-t lib/main_x.dart`) propio para que
//   herramientas como VSCode/CI puedan lanzar "el flavor X" sin ambigüedad.
//   Si los 4 archivos repitieran esta lógica, un cambio en la inicialización
//   (agregar un nuevo paso, como installGlobalErrorHandlers en su momento)
//   requeriría editar 4 archivos idénticos y arriesgarse a que se desincronicen.
//
// CÓMO SE EJECUTA CADA AMBIENTE (ver también .vscode/launch.json):
//   flutter run --flavor development -t lib/main_development.dart --dart-define=ENV=dev
//   flutter run --flavor qa          -t lib/main_qa.dart          --dart-define=ENV=qa
//   flutter run --flavor staging     -t lib/main_staging.dart     --dart-define=ENV=staging
//   flutter run --flavor production  -t lib/main_production.dart  --dart-define=ENV=prod
//
// El orden de inicialización es crítico:
//   1. runZonedGuarded       — red de seguridad para errores async que
//                              escapen de cualquier try/catch (ver
//                              core/error/global_error_handler.dart).
//   2. WidgetsFlutterBinding — requerido antes de usar plugins Flutter.
//   3. AppDI.init()          — calienta providers async antes del primer frame.
//   4. installGlobalErrorHandlers — conecta FlutterError.onError y
//                              PlatformDispatcher.onError a AppLogger.
//   5. runApp()              — inicia el árbol de widgets con el container listo.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jardindeleden/core/accessibility/accessibility_settings.dart';
import 'package:jardindeleden/core/accessibility/color_blind_support.dart';
import 'package:jardindeleden/core/di/app_di.dart';
import 'package:jardindeleden/core/error/global_error_handler.dart';
import 'package:jardindeleden/core/infrastructure/accessibility/accessibility_controller.dart';
import 'package:jardindeleden/core/infrastructure/logging/app_logger_provider.dart';
import 'package:jardindeleden/core/navigation/app_router.dart';
import 'package:jardindeleden/core/theme/app_high_contrast_colors.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';
import 'package:jardindeleden/core/theme/app_text_scale.dart';
import 'package:jardindeleden/core/theme/app_theme.dart';
import 'package:jardindeleden/l10n/generated/app_localizations.dart';

/// Arranca la aplicación. Llamar desde cada entry point `lib/main_*.dart`
/// (development, qa, staging, production).
void bootstrap() {
  // runZonedGuarded retorna Future<void>? (nullable porque el body es un
  // callback async) — es el patrón oficial de bootstrap de Flutter para
  // capturar errores async fuera de cualquier try/catch. Nada en main()
  // necesita esperar a que la zona termine (vive mientras la app viva), así
  // que el Future no se usa intencionalmente; unawaited() no aplica
  // directamente por la nulabilidad del retorno.
  // ignore: discarded_futures
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Inicializa el grafo de DI y precalienta SharedPreferences antes de
      // runApp. Esto evita que el splash screen muestre spinners de carga
      // para operaciones de infraestructura que pueden resolverse antes del
      // primer frame.
      final container = await AppDI.init();

      installGlobalErrorHandlers(container.read(appLoggerProvider));

      runApp(
        // UncontrolledProviderScope pasa el container pre-calentado al árbol.
        // A diferencia de ProviderScope, no crea un container nuevo — usa el
        // que ya inicializamos con AppDI.init().
        UncontrolledProviderScope(
          container: container,
          child: const JardinDelEdenApp(),
        ),
      );
    },
    (error, stackTrace) {
      // Último recurso: errores async fuera de cualquier Zone/try-catch,
      // incluyendo los que ocurren ANTES de que AppDI.init() resuelva el
      // logger. debugPrint es la única garantía que no depende de DI.
      debugPrint('[unhandled] $error\n$stackTrace');
    },
  );
}

/// Widget raíz de la aplicación.
///
/// [ConsumerWidget] (en lugar de [StatelessWidget]) para leer
/// [appRouterProvider] y [accessibilityControllerProvider] desde Riverpod
/// sin BuildContext adicional.
class JardinDelEdenApp extends ConsumerWidget {
  const JardinDelEdenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // AsyncValue en la primera carga (lee StorageService) — se usan valores
    // por defecto mientras resuelve, nunca se bloquea el primer frame por
    // esto (mismo patrón que appDatabaseProvider: infra que se activa sin
    // pantalla de carga dedicada).
    final accessibility =
        ref.watch(accessibilityControllerProvider).valueOrNull ??
        const AccessibilitySettings();

    // ── Alto Contraste + Daltonismo ────────────────────────────────────────
    //
    // Se componen en ese orden: primero se elige la paleta base (normal o
    // alto contraste), luego se le aplica el ajuste de daltonismo si
    // corresponde — ver core/theme/app_high_contrast_colors.dart y
    // core/accessibility/color_blind_support.dart para el porqué de cada uno.
    final baseLight = accessibility.highContrastEnabled
        ? AppHighContrastTheme.light
        : AppTheme.light;
    final baseDark = accessibility.highContrastEnabled
        ? AppHighContrastTheme.dark
        : AppTheme.dark;

    var lightTheme = accessibility.colorBlindMode.isActive
        ? baseLight.copyWith(
            colorScheme: AppColorBlindAdjustment.adjustScheme(
              baseLight.colorScheme,
              accessibility.colorBlindMode,
            ),
          )
        : baseLight;
    var darkTheme = accessibility.colorBlindMode.isActive
        ? baseDark.copyWith(
            colorScheme: AppColorBlindAdjustment.adjustScheme(
              baseDark.colorScheme,
              accessibility.colorBlindMode,
            ),
          )
        : baseDark;

    // ── Reducción de Movimiento ───────────────────────────────────────────
    //
    // Si el sistema operativo pide reducir movimiento O el jugador lo
    // activó dentro del juego, las transiciones de página de Material se
    // desactivan globalmente (appInstantPageTransitionsTheme). Animaciones
    // puntuales (HUD Breathing, feedback de minijuegos) siguen su propia
    // lógica en cada widget vía AppMotion.resolve — ver core/theme/app_motion.dart.
    // Se aplica directamente al ThemeData (no envolviendo con Theme() dentro
    // de builder) porque MaterialApp.builder no garantiza que Theme.of(context)
    // ya refleje `theme`/`darkTheme` en ese punto del árbol.
    if (context.systemPrefersReducedMotion ||
        accessibility.reduceMotionEnabled) {
      lightTheme = lightTheme.copyWith(
        pageTransitionsTheme: appInstantPageTransitionsTheme,
      );
      darkTheme = darkTheme.copyWith(
        pageTransitionsTheme: appInstantPageTransitionsTheme,
      );
    }

    return MaterialApp.router(
      title: 'Jardín del Edén',
      debugShowCheckedModeBanner: false,

      // ── Temas Material 3 (Sprint 05) + Accesibilidad ──────────────────────
      theme: lightTheme,
      darkTheme: darkTheme,

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

      // ── Escalado de Texto Adaptable (Design System) ───────────────────────
      //
      // Acota el TextScaler de accesibilidad del sistema operativo entre
      // AppTextScale.minSystemScale y .maxSystemScale — respeta la
      // preferencia del usuario sin permitir que un ajuste extremo rompa el
      // HUD del juego. Ver core/theme/app_text_scale.dart para el porqué de
      // los límites y por qué esto NUNCA se combina con el escalado por
      // tamaño de pantalla (AppTextScale.scale) ni con
      // AccessibilitySettings.textScaleMode, que son ejes aparte — cada
      // pantalla los combina explícitamente donde los necesita, en vez de
      // que este builder global adivine cómo componerlos.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: AppTextScale.minSystemScale,
        maxScaleFactor: AppTextScale.maxSystemScale,
        child: child!,
      ),
    );
  }
}
