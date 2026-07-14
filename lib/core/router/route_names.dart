// ─────────────────────────────────────────────────────────────────────────────
// core/router/route_names.dart
//
// RESPONSABILIDAD:
//   Define todas las rutas del juego como constantes de string.
//   NUNCA se escriben paths de rutas como literales en el código.
//   Siempre se usa la constante de este archivo.
//
// REGLA CRÍTICA:
//   Renombrar una ruta es un cambio en UN solo lugar: este archivo.
//   Si los paths estuviesen dispersos en el código, renombrar
//   requeriría buscar y reemplazar en N archivos.
//
// NOMENCLATURA:
//   Clase: RouteNames (colección de constantes estáticas)
//   Paths: kebab-case (convención web/GoRouter)
//   Constantes: lowerCamelCase con sufijo 'Route' o 'Path'
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Todo lo demás. Este es el archivo más puro.
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core
// ─────────────────────────────────────────────────────────────────────────────

/// Todas las rutas de navegación del videojuego Jardín del Edén.
///
/// Organizado en grupos según el dominio de negocio.
/// Corresponde 1:1 con la configuración de GoRouter en app_router.dart.
abstract final class RouteNames {
  // ── Sistema ───────────────────────────────────────────────────────────────

  /// Pantalla de splash y carga inicial.
  static const String splash = '/';

  // ── Autenticación y Perfiles ─────────────────────────────────────────────

  /// Selección del perfil activo al iniciar la sesión.
  static const String profiles = '/profiles';

  /// Creación de un nuevo perfil de jugador.
  static const String profileCreate = '/profiles/create';

  /// Edición de un perfil existente.
  static const String profileEdit = '/profiles/:profileId/edit';

  // ── Menú Principal y Mundos ───────────────────────────────────────────────

  /// Menú principal del juego (hub central).
  static const String home = '/home';

  /// Mapa de todos los mundos disponibles.
  static const String worlds = '/worlds';

  /// Vista detallada de un mundo específico con sus capítulos.
  static const String worldDetail = '/worlds/:worldId';

  // ── Capítulos e Historia ─────────────────────────────────────────────────

  /// Pantalla principal de un capítulo (mapa del capítulo).
  static const String chapter = '/worlds/:worldId/chapters/:chapterId';

  /// Pantalla de historia inmersiva del capítulo.
  static const String chapterStory =
      '/worlds/:worldId/chapters/:chapterId/story';

  // ── Minijuegos ───────────────────────────────────────────────────────────

  /// Motor de un minijuego específico dentro de un capítulo.
  static const String minigame =
      '/worlds/:worldId/chapters/:chapterId/minigame/:minigameId';

  // ── Misiones ─────────────────────────────────────────────────────────────

  /// Centro de misiones diarias y especiales.
  static const String missions = '/missions';

  /// Detalle de una misión específica.
  static const String missionDetail = '/missions/:missionId';

  // ── Colección e Inventario ───────────────────────────────────────────────

  /// Inventario completo del jugador (ítems, monedas, colecciones).
  static const String inventory = '/inventory';

  /// Álbum de coleccionables del jugador.
  static const String collection = '/collection';

  // ── Mascota ───────────────────────────────────────────────────────────────

  /// Pantalla de interacción con Lumi (mascota búho).
  static const String pet = '/pet';

  // ── Conocimiento Bíblico ─────────────────────────────────────────────────

  /// Biblioteca bíblica: versículos encontrados y aprendidos.
  static const String library = '/library';

  /// Detalle de un versículo específico.
  static const String verseDetail = '/library/:verseId';

  /// Diario de Miriam: entradas narrativas por capítulo completado.
  static const String diary = '/diary';

  /// Entrada específica del Diario de Miriam.
  static const String diaryEntry = '/diary/:entryId';

  // ── Recompensas ───────────────────────────────────────────────────────────

  /// Sala de recompensas: celebraciones, cofres, logros.
  static const String rewards = '/rewards';

  // ── Estadísticas ─────────────────────────────────────────────────────────

  /// Progreso general y estadísticas del jugador.
  static const String stats = '/stats';

  // ── Eventos Estacionales ─────────────────────────────────────────────────

  /// Hub de eventos estacionales activos.
  static const String seasonal = '/seasonal';

  // ── Panel de Padres ───────────────────────────────────────────────────────

  /// Pantalla de verificación de PIN del Panel de Padres.
  static const String parentPin = '/parent/verify';

  /// Panel de Padres (accesible solo con PIN verificado).
  static const String parent = '/parent';

  /// Configuración de límites de tiempo y contenido.
  static const String parentLimits = '/parent/limits';

  /// Historial de actividad del jugador para los padres.
  static const String parentActivity = '/parent/activity';

  // ── Configuración del Jugador ─────────────────────────────────────────────

  /// Configuración: idioma, audio, accesibilidad.
  static const String settings = '/settings';

  // ── Sistema y Error ───────────────────────────────────────────────────────

  /// Pantalla de error recuperable con opción de reintentar.
  static const String error = '/error';

  /// Pantalla de error crítico (corrupción de datos, error fatal).
  static const String criticalError = '/critical-error';
}
