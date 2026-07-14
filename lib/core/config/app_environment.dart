// ─────────────────────────────────────────────────────────────────────────────
// core/config/app_environment.dart
//
// RESPONSABILIDAD:
//   Define los CUATRO ambientes de ejecución del proyecto.
//   Cada ambiente tiene configuraciones diferentes de logging,
//   cifrado, tiempos del sistema y feature flags.
//
// LOS CUATRO AMBIENTES Y PARA QUÉ SIRVE CADA UNO:
//   dev        → el propio desarrollador, en su máquina, iterando rápido.
//   qa         → el equipo de QA interno, probando builds antes de que
//                salgan de la organización — necesita que el juego se
//                comporte lo más parecido posible a producción (cifrado
//                activo) pero con herramientas de diagnóstico visibles.
//   staging    → beta testers externos / stakeholders — el candidato a
//                producción, sin nada de tooling de desarrollo visible.
//   prod       → jugadores reales.
//
// CADA AMBIENTE ES UN "FLAVOR" NATIVO INDEPENDIENTE (ver android/app/build.gradle.kts
// y ios/Flutter/*.xcconfig) — los 4 pueden coexistir INSTALADOS a la vez en
// el mismo dispositivo (ids de aplicación e íconos/nombres distintos), no
// se pisan entre sí. Ver lib/bootstrap.dart y lib/main_*.dart para cómo se
// arranca cada uno.
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

/// Los cuatro ambientes de ejecución del videojuego Jardín del Edén.
///
/// Se seleccionan en tiempo de compilación mediante --dart-define, siempre
/// junto con el flavor nativo correspondiente (ver lib/main_*.dart):
///   flutter run --flavor development -t lib/main_development.dart --dart-define=ENV=dev
///   flutter run --flavor qa          -t lib/main_qa.dart          --dart-define=ENV=qa
///   flutter run --flavor staging     -t lib/main_staging.dart     --dart-define=ENV=staging
///   flutter run --flavor production  -t lib/main_production.dart  --dart-define=ENV=prod
enum AppEnvironment {
  /// Ambiente de desarrollo local.
  /// Logs VERBOSE activos. Base de datos sin cifrar (facilita inspeccionar
  /// el archivo .db directamente durante el desarrollo).
  /// Tiempos del Sistema 44 acelerados al máximo (1 min = 1 día).
  dev,

  /// Ambiente de QA interno — el equipo de pruebas del proyecto.
  /// Logs DEBUG activos. Base de datos CIFRADA (a diferencia de dev — QA
  /// debe poder detectar bugs relacionados con cifrado antes que staging).
  /// Tiempos del Sistema 44 acelerados moderadamente (1 hora = 1 día) —
  /// suficiente para probar la repetición espaciada sin esperar días reales.
  qa,

  /// Ambiente de staging — beta testers externos y stakeholders.
  /// Logs DEBUG activos (para diagnosticar reportes de beta testers).
  /// Base de datos cifrada. Sin herramientas de desarrollo visibles.
  /// Tiempos del Sistema 44 levemente acelerados (1 hora = 1 día).
  staging,

  /// Ambiente de producción. Usuarios reales.
  /// Solo logs INFO/WARNING/ERROR. Base de datos cifrada.
  /// Todos los tiempos en valores reales.
  prod,
}
