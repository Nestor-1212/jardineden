// ─────────────────────────────────────────────────────────────────────────────
// core/config/app_environment.dart
//
// RESPONSABILIDAD:
//   Define los tres ambientes de ejecución del proyecto.
//   Cada ambiente tiene configuraciones diferentes de logging,
//   cifrado, tiempos del sistema y feature flags.
//
// REGLA DE ARQUITECTURA:
//   Este enum es Dart puro. Cero imports de Flutter.
//   Cero imports de librerías de terceros.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, Riverpod, Drift, cualquier paquete.
//
// USADO POR:   core/config/app_config.dart
// NO USADO POR: Features directamente. Las features usan AppConfig.
// ─────────────────────────────────────────────────────────────────────────────

/// Los tres ambientes de ejecución del videojuego Jardín del Edén.
///
/// Se seleccionan en tiempo de compilación mediante --dart-define:
///   flutter run --dart-define=ENV=dev
///   flutter run --dart-define=ENV=staging
///   flutter run --dart-define=ENV=prod
enum AppEnvironment {
  /// Ambiente de desarrollo local.
  /// Logs VERBOSE activos. Base de datos sin cifrar.
  /// Tiempos del Sistema 44 acelerados (1 min = 1 día).
  dev,

  /// Ambiente de pruebas y QA.
  /// Logs DEBUG activos. Base de datos cifrada.
  /// Tiempos del Sistema 44 levemente acelerados (1 hora = 1 día).
  staging,

  /// Ambiente de producción. Usuarios reales.
  /// Solo logs INFO/WARNING/ERROR. Base de datos cifrada.
  /// Todos los tiempos en valores reales.
  prod,
}
