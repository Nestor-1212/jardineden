// ─────────────────────────────────────────────────────────────────────────────
// core/logging/navigation_logger.dart
//
// RESPONSABILIDAD:
//   Registra transiciones de pantalla (push/pop/replace) bajo
//   LogModules.navigation. Es un wrapper delgado sobre AppLogger — no sabe
//   NADA de GoRouter ni de Flutter Navigator; eso vive en
//   core/navigation/app_navigator_observer.dart, que traduce eventos de
//   Navigator a llamadas a esta interfaz.
//
// POR QUÉ SEPARAR EL LOGGER DEL OBSERVER:
//   NavigationLogger es Dart puro y testeable sin un widget tree real.
//   AppNavigatorObserver (Flutter) es el único punto que sabe cómo Flutter
//   reporta la navegación — si el proyecto migrara de GoRouter a otro
//   router, solo se reemplaza el observer, no este archivo.
//
// QUÉ SE LOGUEA:
//   Nombre de ruta (ej. 'chapter', 'parent-panel') y parámetros de ruta NO
//   sensibles (ej. worldId, chapterId — identificadores de contenido, no de
//   persona). NUNCA argumentos de query string que pudieran contener texto
//   libre del usuario.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   Flutter, go_router, features.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del logger de navegación.
abstract interface class NavigationLogger {
  /// Registra que la navegación pasó de [from] a [to].
  ///
  /// [from] es null en la primera navegación de la sesión (no hay ruta
  /// anterior). [params] son identificadores de ruta no sensibles (ej.
  /// {'worldId': 'world_003'}).
  void logRouteChange({
    required String? from,
    required String to,
    Map<String, Object?>? params,
  });
}
