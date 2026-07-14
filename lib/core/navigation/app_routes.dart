// ─────────────────────────────────────────────────────────────────────────────
// core/navigation/app_routes.dart
//
// RESPONSABILIDAD:
//   Centraliza TODAS las rutas del proyecto en tres clases:
//     • AppRoutes    — strings de path (para go() y location matching)
//     • RouteNames   — nombres de ruta (para goNamed() sin acoplar a paths)
//     • RouteParams  — nombres de parámetros de path (para pathParameters[])
//
// POR QUÉ SEPARAR paths de names:
//   Los paths pueden cambiar (ej. /worlds → /map) sin romper el código que
//   usa goNamed(). Las pantallas que navegan usan RouteNames exclusivamente.
//   Solo AppRouter usa AppRoutes para definir la estructura.
//
// JERARQUÍA DE RUTAS:
//   / (splash)
//   /profiles               → selección de perfil
//   /profiles/create        → creación de perfil (hija de profiles)
//   /onboarding             → tutorial primera vez
//   /home                   → shell (bottom nav)
//     /home/worlds          → mapa de mundos
//       /home/worlds/:worldId → detalle del mundo con capítulos
//     /home/missions        → misiones diarias
//     /home/library         → biblioteca bíblica
//     /home/diary           → diario del jugador
//     /home/rewards         → logros y recompensas
//     /home/pet             → Lumi (mascota)
//     /home/collection      → colección de ítems
//     /home/stats           → estadísticas de progreso
//     /home/settings        → configuración
//   /chapter/:chapterId     → pantalla de juego (fullscreen, fuera del shell)
//   /sistema-44             → sesión de repaso (fullscreen)
//   /parent-pin             → entrada de PIN parental (fullscreen)
//   /parent-panel           → panel de control de padres (fullscreen)
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente (strings son Dart puro).
// DEPENDENCIAS PROHIBIDAS:   flutter, features, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

/// Paths absolutos de todas las rutas de la app.
///
/// SOLO AppRouter debe usar estas constantes para construir el árbol de rutas.
/// El resto del código usa [RouteNames] con goNamed().
abstract final class AppRoutes {
  // ── Rutas Pre-Shell ───────────────────────────────────────────────────────

  /// Pantalla de carga inicial. Punto de entrada de la app.
  static const splash = '/';

  /// Pantalla de selección de perfil de jugador.
  static const profiles = '/profiles';

  /// Pantalla de creación de nuevo perfil (sub-ruta de /profiles).
  /// Path completo: /profiles/create
  static const profileCreate = '/profiles/create';

  /// Tutorial de primera vez para un perfil recién creado.
  static const onboarding = '/onboarding';

  // ── Shell — Navegación Principal (bottom nav) ─────────────────────────────

  /// Dashboard principal. Tab 1 del bottom nav.
  static const home = '/home';

  /// Mapa de los 10 mundos bíblicos. Tab 2 del bottom nav.
  static const worlds = '/home/worlds';

  /// Detalle de un mundo con su lista de capítulos.
  /// Path completo: /home/worlds/:worldId
  static const worldDetail = '/home/worlds/:worldId';

  /// Misiones diarias del jugador. Tab 3 del bottom nav.
  static const missions = '/home/missions';

  /// Biblioteca bíblica: versículos, pasajes, concordancia.
  static const library = '/home/library';

  /// Diario del jugador: reflexiones y notas personales.
  static const diary = '/home/diary';

  /// Logros, medallas y recompensas del jugador.
  static const rewards = '/home/rewards';

  /// Pantalla de Lumi (mascota búho). Tab 4 del bottom nav.
  static const pet = '/home/pet';

  /// Colección de ítems: cartas, artefactos, monedas.
  static const collection = '/home/collection';

  /// Estadísticas de progreso y rendimiento.
  static const stats = '/home/stats';

  /// Ajustes de la app. Tab 5 del bottom nav.
  static const settings = '/home/settings';

  // ── Rutas Fullscreen (fuera del shell — sin bottom nav) ───────────────────

  /// Pantalla de juego de un capítulo específico. Experiencia inmersiva.
  /// Path completo: /chapter/:chapterId
  static const chapter = '/chapter/:chapterId';

  /// Sesión de repaso del Sistema 44 (repetición espaciada).
  static const sistema44 = '/sistema-44';

  /// Entrada de PIN parental antes de acceder al panel de padres.
  /// Query param opcional: `?redirectAfter={path}` para redirigir post-validación.
  static const parentPin = '/parent-pin';

  /// Panel de control exclusivo para padres/tutores.
  /// Solo accesible después de validar el PIN en /parent-pin.
  static const parentPanel = '/parent-panel';
}

/// Nombres de ruta para navegación con goNamed().
///
/// Todos los widgets que navegan DEBEN usar estas constantes,
/// nunca los paths de [AppRoutes] directamente.
///
/// Ejemplo: `context.goNamed(RouteNames.worlds)`
abstract final class RouteNames {
  static const splash = 'splash';
  static const profiles = 'profiles';
  static const profileCreate = 'profile-create';
  static const onboarding = 'onboarding';
  static const home = 'home';
  static const worlds = 'worlds';
  static const worldDetail = 'world-detail';
  static const missions = 'missions';
  static const library = 'library';
  static const diary = 'diary';
  static const rewards = 'rewards';
  static const pet = 'pet';
  static const collection = 'collection';
  static const stats = 'stats';
  static const settings = 'settings';
  static const chapter = 'chapter';
  static const sistema44 = 'sistema-44';
  static const parentPin = 'parent-pin';
  static const parentPanel = 'parent-panel';
}

/// Nombres de los parámetros de path dinámicos.
///
/// Uso: `state.pathParameters[RouteParams.worldId]`
abstract final class RouteParams {
  /// ID de mundo bíblico. Ejemplo: 'world_001' (Génesis).
  static const worldId = 'worldId';

  /// ID de capítulo dentro de un mundo. Ejemplo: 'cap_gen_01'.
  static const chapterId = 'chapterId';
}

/// Nombres de los query parameters usados en navegación.
///
/// Uso: `state.uri.queryParameters[RouteQuery.redirectAfter]`
abstract final class RouteQuery {
  /// Path al que redirigir después de validar el PIN parental.
  /// Ejemplo: /parent-pin?redirectAfter=%2Fparent-panel
  static const redirectAfter = 'redirectAfter';
}
