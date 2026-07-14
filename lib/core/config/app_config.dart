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

  /// Identificador único del paquete en las tiendas de aplicaciones.
  static const String packageName = 'com.jardindeleden.app';

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
  /// dev: verbose | staging: debug | prod: info
  static String get minimumLogLevel => switch (environment) {
        AppEnvironment.dev => 'verbose',
        AppEnvironment.staging => 'debug',
        AppEnvironment.prod => 'info',
      };

  // ── Sistema 44 (Repetición Espaciada) ────────────────────────────────────

  /// Factor de aceleración del tiempo para el Sistema 44.
  /// dev: 1440 (1 min = 1 día) | staging: 24 (1h = 1d) | prod: 1 (tiempo real)
  static int get sistema44TimeAccelerationFactor => switch (environment) {
        AppEnvironment.dev => 1440,
        AppEnvironment.staging => 24,
        AppEnvironment.prod => 1,
      };

  // ── Sincronización Futura ─────────────────────────────────────────────────

  /// URL base del servidor Laravel. null en esta fase (sin backend).
  /// Se activa en el sprint de sincronización del Año 3 del roadmap.
  static const String? apiBaseUrl = null;

  // ── Feature Flags ─────────────────────────────────────────────────────────

  /// Habilita las herramientas de debugging visual en la UI.
  /// Solo disponible en dev.
  static bool get debugOverlayEnabled => environment == AppEnvironment.dev;

  /// Habilita el botón de "Reset completo" en la pantalla de desarrollo.
  static bool get devResetButtonEnabled => environment == AppEnvironment.dev;
}
