// ─────────────────────────────────────────────────────────────────────────────
// core/navigation/app_router.dart
//
// RESPONSABILIDAD:
//   Configura la instancia de GoRouter que gestiona toda la navegación del juego.
//   Expone [appRouterProvider] como un Riverpod Provider<GoRouter> para que
//   MaterialApp.router pueda inyectarlo y para facilitar el testing.
//
// DECISIÓN: GoRouter sobre Navigator 2.0 y AutoRoute
//
//   Navigator 2.0 (raw):
//     ✗ Requiere implementar RouterDelegate + RouteInformationParser manualmente.
//     ✗ Más de 300 líneas de boilerplate para rutas simples.
//     ✓ Control máximo, sin dependencias extra.
//     → Descartado: la complejidad no aporta valor en este proyecto.
//
//   AutoRoute:
//     ✓ Tipo-safe gracias a code generation.
//     ✗ Requiere build_runner en cada cambio de ruta (latencia de iteración).
//     ✗ El proyecto ya usa build_runner para Riverpod + Drift — agregar otro
//       builder aumenta el tiempo de compilación sin beneficio claro.
//     ✗ Las anotaciones ocultan la estructura — más difícil de auditar.
//     → Descartado: la generación de código no justifica la complejidad añadida.
//
//   GoRouter (seleccionado):
//     ✓ Paquete oficial del equipo de Flutter (publisher: flutter.dev).
//     ✓ Árbol de rutas declarativo y legible sin generación de código.
//     ✓ ShellRoute para bottom nav persistente con estado por tab.
//     ✓ Named routes + typed path parameters sin build_runner.
//     ✓ redirect() para guardar rutas (PIN parental, perfil no seleccionado).
//     ✓ refreshListenable para reaccionar a cambios de auth con Riverpod.
//     ✓ Deep links iOS/Android configurados desde el mismo árbol de rutas.
//     ✓ errorBuilder para pantalla 404 personalizada.
//     → Seleccionado. Ya en pubspec.yaml desde el inicio del proyecto.
//
// INTEGRACIÓN CON RIVERPOD:
//   appRouterProvider es un Provider<GoRouter> simple en Sprint 07.
//   En Sprint de Auth (Sprint 08+), se añadirá refreshListenable conectado
//   al authStateProvider para que los redirects reaccionen al login/logout.
//
//   ```dart
//   // Sprint 08+ — implementación futura del refreshListenable:
//   ref.listen(authStateProvider, (_, __) {});
//   final notifier = ref.read(authStateProvider.notifier);
//   return GoRouter(refreshListenable: notifier, redirect: _authRedirect, ...);
//   ```
//
// DEPENDENCIAS PERMITIDAS:   flutter, go_router, flutter_riverpod,
//                            core/navigation/*, features/*/screens.
// DEPENDENCIAS PROHIBIDAS:   features (business logic), shared/services.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jardindeleden/core/infrastructure/logging/navigation_logger_provider.dart';
import 'package:jardindeleden/core/logging/navigation_logger.dart';
import 'package:jardindeleden/core/navigation/app_navigator_observer.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/app_shell.dart';
import 'package:jardindeleden/core/navigation/navigation_error_screen.dart';
import 'package:jardindeleden/features/chapter/chapter_screen.dart';
import 'package:jardindeleden/features/collection/collection_screen.dart';
import 'package:jardindeleden/features/diary/diary_screen.dart';
import 'package:jardindeleden/features/home/home_screen.dart';
import 'package:jardindeleden/features/library/library_screen.dart';
import 'package:jardindeleden/features/missions/missions_screen.dart';
import 'package:jardindeleden/features/onboarding/onboarding_screen.dart';
import 'package:jardindeleden/features/parent/parent_panel_screen.dart';
import 'package:jardindeleden/features/parent/parent_pin_screen.dart';
import 'package:jardindeleden/features/pet/pet_screen.dart';
import 'package:jardindeleden/features/profiles/profile_create_screen.dart';
import 'package:jardindeleden/features/profiles/profile_selection_screen.dart';
import 'package:jardindeleden/features/rewards/rewards_screen.dart';
import 'package:jardindeleden/features/settings/settings_screen.dart';
import 'package:jardindeleden/features/sistema44/sistema44_screen.dart';
import 'package:jardindeleden/features/splash/splash_screen.dart';
import 'package:jardindeleden/features/stats/stats_screen.dart';
import 'package:jardindeleden/features/worlds/world_detail_screen.dart';
import 'package:jardindeleden/features/worlds/worlds_screen.dart';

/// Proveedor de la instancia de GoRouter.
///
/// Usar en MaterialApp.router:
/// ```dart
/// final router = ref.watch(appRouterProvider);
/// MaterialApp.router(routerConfig: router, ...)
/// ```
final appRouterProvider = Provider<GoRouter>(
  (ref) => _buildRouter(navigationLogger: ref.watch(navigationLoggerProvider)),
  name: 'appRouterProvider',
);

GoRouter _buildRouter({required NavigationLogger navigationLogger}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

    // Logs de navegación (LogModules.navigation) — ver
    // core/navigation/app_navigator_observer.dart.
    observers: [AppNavigatorObserver(navigationLogger)],

    // ── Redirect Guard ────────────────────────────────────────────────────────
    //
    // Sprint 07: sin redirects activos — todas las rutas son accesibles.
    // Sprint 08 (Auth): aquí se conectará el authStateProvider de Riverpod
    // para redirigir a /profiles si no hay perfil seleccionado, y bloquear
    // /parent-panel si el PIN no fue validado en esta sesión.
    //
    // Patrón para Sprint 08:
    //   redirect: (context, state) {
    //     final authState = ref.read(authStateProvider);
    //     final isAtSplash = state.matchedLocation == AppRoutes.splash;
    //     if (authState.isLoading) return isAtSplash ? null : AppRoutes.splash;
    //     if (authState.hasNoProfile) return AppRoutes.profiles;
    //     if (state.matchedLocation == AppRoutes.parentPanel) {
    //       if (!authState.parentPinValidated) return AppRoutes.parentPin;
    //     }
    //     return null;
    //   },
    redirect: (BuildContext context, GoRouterState state) => null,

    // ── Error Handler ─────────────────────────────────────────────────────────
    errorBuilder: (context, state) => NavigationErrorScreen(error: state.error),

    routes: [
      // ── Splash ───────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ── Perfiles ─────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.profiles,
        name: RouteNames.profiles,
        builder: (context, state) => const ProfileSelectionScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: RouteNames.profileCreate,
            builder: (context, state) => const ProfileCreateScreen(),
          ),
        ],
      ),

      // ── Onboarding ────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ── Shell — Navegación Principal ──────────────────────────────────────────
      //
      // ShellRoute envuelve todas las rutas con el AppShell (bottom NavigationBar).
      // Las rutas hijas del ShellRoute se renderizan como el `child` de AppShell.
      //
      // NOTA: Las rutas secundarias (library, diary, rewards, collection, stats)
      // están dentro del shell para mantener el AppBar consistente y permitir
      // el botón de regreso al tab padre. El índice del bottom nav permanece
      // en "Home" (0) cuando el usuario está en estas rutas secundarias.
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // Tab 1 — Inicio (Dashboard)
          GoRoute(
            path: AppRoutes.home,
            name: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),

          // Tab 2 — Mundos (Mapa de los 10 mundos bíblicos)
          GoRoute(
            path: AppRoutes.worlds,
            name: RouteNames.worlds,
            builder: (context, state) => const WorldsScreen(),
            routes: [
              GoRoute(
                path: ':${RouteParams.worldId}',
                name: RouteNames.worldDetail,
                builder: (context, state) {
                  final worldId =
                      state.pathParameters[RouteParams.worldId] ?? '';
                  return WorldDetailScreen(worldId: worldId);
                },
              ),
            ],
          ),

          // Tab 3 — Misiones Diarias
          GoRoute(
            path: AppRoutes.missions,
            name: RouteNames.missions,
            builder: (context, state) => const MissionsScreen(),
          ),

          // Tab 4 — Lumi (Mascota)
          GoRoute(
            path: AppRoutes.pet,
            name: RouteNames.pet,
            builder: (context, state) => const PetScreen(),
          ),

          // Tab 5 — Ajustes
          GoRoute(
            path: AppRoutes.settings,
            name: RouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
          ),

          // ── Destinos Secundarios (sin tab propio, accesibles desde Home) ─────
          GoRoute(
            path: AppRoutes.library,
            name: RouteNames.library,
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: AppRoutes.diary,
            name: RouteNames.diary,
            builder: (context, state) => const DiaryScreen(),
          ),
          GoRoute(
            path: AppRoutes.rewards,
            name: RouteNames.rewards,
            builder: (context, state) => const RewardsScreen(),
          ),
          GoRoute(
            path: AppRoutes.collection,
            name: RouteNames.collection,
            builder: (context, state) => const CollectionScreen(),
          ),
          GoRoute(
            path: AppRoutes.stats,
            name: RouteNames.stats,
            builder: (context, state) => const StatsScreen(),
          ),
        ],
      ),

      // ── Rutas Fullscreen (fuera del shell, sin bottom nav) ────────────────────
      //
      // Estas rutas se renderizan SIN AppShell — experiencia de pantalla completa.
      // Ideal para gameplay inmersivo (capítulos, Sistema 44) y flujos de
      // autenticación parental que no deben interrumpirse con la nav principal.

      // Juego: pantalla de un capítulo específico
      GoRoute(
        path: '/chapter/:${RouteParams.chapterId}',
        name: RouteNames.chapter,
        builder: (context, state) {
          final chapterId = state.pathParameters[RouteParams.chapterId] ?? '';
          return ChapterScreen(chapterId: chapterId);
        },
      ),

      // Repaso Sistema 44 (repetición espaciada)
      GoRoute(
        path: AppRoutes.sistema44,
        name: RouteNames.sistema44,
        builder: (context, state) => const Sistema44Screen(),
      ),

      // PIN parental — paso previo obligatorio al panel de padres
      GoRoute(
        path: AppRoutes.parentPin,
        name: RouteNames.parentPin,
        builder: (context, state) {
          final redirectAfter =
              state.uri.queryParameters[RouteQuery.redirectAfter];
          return ParentPinScreen(redirectAfter: redirectAfter);
        },
      ),

      // Panel de padres — solo accesible post-validación del PIN
      GoRoute(
        path: AppRoutes.parentPanel,
        name: RouteNames.parentPanel,
        builder: (context, state) => const ParentPanelScreen(),
      ),
    ],
  );
}
