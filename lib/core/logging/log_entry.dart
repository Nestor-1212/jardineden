// ─────────────────────────────────────────────────────────────────────────────
// core/logging/log_entry.dart
//
// RESPONSABILIDAD:
//   Representación estructurada e inmutable de UNA entrada de log. Es el
//   formato de intercambio entre AppLoggerImpl y cada LogSink — cualquier
//   sink (consola hoy, Sentry/Crashlytics/OpenTelemetry mañana) recibe
//   exactamente el mismo objeto, sin importar cómo lo escriba.
//
// POR QUÉ UN OBJETO Y NO PARÁMETROS SUELTOS:
//   Una futura herramienta de monitoreo remoto necesita serializar la
//   entrada completa (a JSON, a un protocolo binario, etc.). Un objeto con
//   toJson() hace eso trivial sin tocar AppLoggerImpl ni los call sites.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/logging/log_level.dart';

/// Una entrada de log completamente estructurada, ya sanitizada (ver
/// core/logging/log_sanitizer.dart) — ningún LogSink debe volver a
/// inspeccionar [metadata] en busca de datos sensibles, eso ya se hizo
/// antes de construir este objeto.
final class LogEntry {
  const LogEntry({
    required this.level,
    required this.module,
    required this.message,
    required this.timestamp,
    this.sessionId,
    this.anonymousProfileId,
    this.metadata = const {},
    this.cause,
    this.stackTrace,
  });

  final LogLevel level;
  final String module;
  final String message;
  final DateTime timestamp;

  /// ID de sesión anónimo (ver AppLogger.setSessionId) — nunca un identificador
  /// personal.
  final String? sessionId;

  /// ID anónimo del perfil activo (ver AppLogger.setAnonymousProfileId) —
  /// nunca el nombre del jugador.
  final String? anonymousProfileId;

  /// Metadata estructurada, YA sanitizada. Ver LogSanitizer.
  final Map<String, Object?> metadata;

  /// La excepción/error original, si esta entrada es de nivel warning/error.
  final Object? cause;

  final StackTrace? stackTrace;

  /// Representación JSON — el formato que usará cualquier sink remoto futuro.
  Map<String, Object?> toJson() => {
    'timestamp': timestamp.toUtc().toIso8601String(),
    'level': level.name,
    'module': module,
    'message': message,
    if (sessionId != null) 'session_id': sessionId,
    if (anonymousProfileId != null) 'profile_id': anonymousProfileId,
    if (metadata.isNotEmpty) 'metadata': metadata,
    if (cause != null) 'cause': cause.toString(),
  };

  @override
  String toString() => toJson().toString();
}
