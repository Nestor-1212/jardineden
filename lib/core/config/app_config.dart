// ─────────────────────────────────────────────────────────────────────────────
// core/config/app_config.dart
//
// RESPONSABILIDAD:
//   Centraliza toda la configuración dependiente del ambiente.
//   Es el único lugar del proyecto donde se leen las variables
//   de compilación --dart-define. El resto del código consume
//   AppConfig, nunca las variables directamente.
//
// PATRÓN:   Singleton inmutable. Se inicializa una vez en main().
//           Disponible globalmente mediante el provider de Riverpod
//           registrado en core/di/injection_container.dart
//
// DEPENDENCIAS PERMITIDAS:   dart:core, app_environment.dart
// DEPENDENCIAS PROHIBIDAS:   Flutter, features, shared, cualquier paquete.
//
// IMPLEMENTA EN SPRINT:   Sprint de Configuración de Ambientes
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/config/app_environment.dart';

/// Configuración centralizada del ambiente de ejecución.
///
/// Cada campo tiene un valor por ambiente.
/// Los features observan estos valores mediante el appConfigProvider.
abstract final class AppConfig {
  // ── Información de la Aplicación ─────────────────────────────────────────

  /// Nombre de la aplicación mostrado al sistema operativo.
  static const String appName = 'Jardín del Edén';

  /// Identificador único del paquete — incluye el sufijo de flavor nativo
  /// (ver android/app/build.gradle.kts) para que coincida exactamente con
  /// el applicationId real de cada instalación. Solo producción no lleva
  /// sufijo — es el único id que se publica en las tiendas.
  static String get packageName => switch (environment) {
        AppEnvironment.dev => 'com.jardindeleden.app.dev',
        AppEnvironment.qa => 'com.jardindeleden.app.qa',
        AppEnvironment.staging => 'com.jardindeleden.app.staging',
        AppEnvironment.prod => 'com.jardindeleden.app',
      };

  // ── Ambiente Activo ───────────────────────────────────────────────────────

  /// Ambiente de ejecución actual, determinado en tiempo de compilación.
  ///
  /// Uso: AppConfig.environment == AppEnvironment.prod
  /// byName() no es const, por eso se usa final (no const).
  static final AppEnvironment environment = AppEnvironment.values.byName(
    const String.fromEnvironment('ENV', defaultValue: 'dev'),
  );

  // ── Base de Datos ─────────────────────────────────────────────────────────

  /// Nombre del archivo de base de datos en el sistema de archivos.
  static const String databaseFileName = 'jardindeleden.db';

  /// Versión actual del esquema de la base de datos.
  /// Se incrementa en cada migración. NUNCA decrece.
  static const int databaseSchemaVersion = 1;

  /// Cifrado activo. false solo en dev para facilitar inspección.
  static bool get databaseEncryptionEnabled =>
      environment != AppEnvironment.dev;

  // ── Logging ───────────────────────────────────────────────────────────────

  /// Nivel mínimo de log que se registra.
  /// dev: verbose | qa/staging: debug | prod: info
  static String get minimumLogLevel => switch (environment) {
        AppEnvironment.dev => 'verbose',
        AppEnvironment.qa => 'debug',
        AppEnvironment.staging => 'debug',
        AppEnvironment.prod => 'info',
      };

  // ── Sistema 44 (Repetición Espaciada) ────────────────────────────────────

  /// Factor de aceleración del tiempo para el Sistema 44.
  /// dev: 1440 (1 min = 1 día) | qa: 120 (12 min = 1 día) |
  /// staging: 24 (1h = 1d) | prod: 1 (tiempo real)
  ///
  /// QA queda a propósito ENTRE dev y staging: necesita probar varios
  /// ciclos de repetición espaciada en una sesión de prueba (más rápido que
  /// staging), pero sin ser tan instantáneo como dev, que dificultaría
  /// notar bugs de timing que sí aparecerían con staging/producción.
  static int get sistema44TimeAccelerationFactor => switch (environment) {
        AppEnvironment.dev => 1440,
        AppEnvironment.qa => 120,
        AppEnvironment.staging => 24,
        AppEnvironment.prod => 1,
      };

  // ── Sincronización Futura ─────────────────────────────────────────────────

  /// URL base del servidor Laravel. null en esta fase (sin backend).
  /// Se activa en el sprint de sincronización del Año 3 del roadmap.
  static const String? apiBaseUrl = null;

  // ── Feature Flags ─────────────────────────────────────────────────────────

  /// Habilita las herramientas de debugging visual en la UI.
  /// Disponible en dev Y qa — el equipo de QA necesita ver el mismo
  /// overlay de diagnóstico para reportar bugs con contexto (estado
  /// interno, valores de AppConfig activos). Nunca en staging/prod.
  static bool get debugOverlayEnabled =>
      environment == AppEnvironment.dev || environment == AppEnvironment.qa;

  /// Habilita el botón de "Reset completo" en la pantalla de desarrollo.
  /// Igual que [debugOverlayEnabled]: QA necesita reiniciar datos de
  /// prueba entre corridas tan seguido como un desarrollador.
  static bool get devResetButtonEnabled =>
      environment == AppEnvironment.dev || environment == AppEnvironment.qa;
}
