// ─────────────────────────────────────────────────────────────────────────────
// core/router/app_router.dart
//
// RESPONSABILIDAD:
//   Define la configuración completa de GoRouter para el proyecto.
//   Es el único archivo que conoce la estructura de navegación completa.
//
// PATRÓN:
//   appRouterProvider (Riverpod Provider) expone la instancia de GoRouter.
//   El GoRouter se reconstruye automáticamente cuando cambia el estado
//   de autenticación (perfil activo / sin perfil).
//
// GUARDS DE NAVEGACIÓN:
//   redirect() se evalúa antes de cada navegación y puede redirigir:
//   • Sin perfil activo → /profiles
//   • Acceso al Panel de Padres sin PIN verificado → /parent/verify
//   • Ruta inexistente → /error
//
// DEPENDENCIAS PERMITIDAS:
//   go_router, core/router/route_names.dart, core/di/ (para el provider)
// DEPENDENCIAS PROHIBIDAS:
//   Features directamente. Las pantallas de features se importan aquí
//   pero las features NO importan el router.
//
// REGLA: El router importa features. Las features NO importan el router.
//        Una feature navega usando context.go(RouteNames.home) o
//        context.push(RouteNames.worldDetail) — nunca referenciando
//        otros archivos de otras features.
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core
// ─────────────────────────────────────────────────────────────────────────────

// Este archivo se implementa en el Sprint del Módulo Core.
// Requiere: go_router (instalado en Sprint de Dependencias)
//           Riverpod providers de auth (implementados en Feature Auth)
//
// La implementación seguirá este esquema:
//
// final appRouterProvider = Provider<GoRouter>((ref) {
//   final isAuthenticated = ref.watch(isProfileActiveProvider);
//   return GoRouter(
//     initialLocation: RouteNames.splash,
//     redirect: (context, state) {
//       if (!isAuthenticated && state.uri.path != RouteNames.profiles) {
//         return RouteNames.profiles;
//       }
//       return null;
//     },
//     routes: [
//       GoRoute(path: RouteNames.splash, ...),
//       GoRoute(path: RouteNames.profiles, ...),
//       ShellRoute(routes: [ ... rutas principales del juego ... ]),
//     ],
//   );
// });
