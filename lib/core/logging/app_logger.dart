// ─────────────────────────────────────────────────────────────────────────────
// core/logging/app_logger.dart
//
// RESPONSABILIDAD:
//   Fachada única de logging para todo el proyecto.
//   Ninguna feature importa el paquete 'logger' directamente.
//   Todas las features usan AppLogger.
//
// GARANTÍAS:
//   • Ningún dato personal (nombre, PIN, UUID de usuario) aparece en logs.
//   • Los logs usan IDs anónimos (session_id, anonymous profile_id).
//   • En producción, solo INFO/WARNING/ERROR se registran.
//   • Los logs de producción se rotan automáticamente (3 archivos, 1MB c/u).
//
// ESTRUCTURA DE CADA ENTRADA DE LOG:
//   {
//     "timestamp": "2026-07-12T10:23:45.123Z",
//     "level": "INFO",
//     "module": "chapter",
//     "session_id": "sess_a1b2c3",
//     "profile_id": "anon_x9y8z7",   ← No el nombre, el UUID anónimo
//     "message": "chapter_completed",
//     "metadata": { "world_id": "WORLD-001", "chapter_id": "CHAPTER-001-001" }
//   }
//
// DEPENDENCIAS PERMITIDAS:   dart:core, log_level.dart
// DEPENDENCIAS PROHIBIDAS:   features, shared, Flutter.
//   El paquete 'logger' se importa SOLO en la implementación concreta
//   (AppLoggerImpl) que vive en la capa de data del Core.
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/logging/log_level.dart';

/// Contrato del servicio de logging del proyecto.
///
/// Se registra como singleton en el sistema de DI.
/// Los features lo obtienen mediante ref.read(appLoggerProvider).
abstract interface class AppLogger {
  /// Registra un mensaje de nivel [LogLevel.verbose].
  /// Solo activo en ambiente de desarrollo.
  void verbose(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
  });

  /// Registra un mensaje de nivel [LogLevel.debug].
  /// Activo en desarrollo y staging.
  void debug(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
  });

  /// Registra un evento significativo del juego.
  /// Activo en todos los ambientes.
  void info(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
  });

  /// Registra una situación anómala no crítica.
  /// Activo en todos los ambientes.
  void warning(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
    Object? cause,
  });

  /// Registra un error que afecta la funcionalidad.
  /// Activo en todos los ambientes. Siempre persiste en el archivo de log.
  void error(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
    Object? cause,
    StackTrace? stackTrace,
  });

  /// Establece el ID de sesión para todos los logs subsiguientes.
  /// Se llama al inicio de cada sesión de juego.
  void setSessionId(String sessionId);

  /// Establece el ID anónimo del perfil activo para todos los logs.
  /// Se llama al activar un perfil de jugador.
  void setAnonymousProfileId(String anonymousId);
}
