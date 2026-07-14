// ─────────────────────────────────────────────────────────────────────────────
// core/logging/app_logger_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de AppLogger. NO escribe logs directamente — construye un
//   LogEntry ya sanitizado y lo reparte (fan-out) a cada LogSink registrado.
//   Ver core/logging/log_sink.dart para por qué esta indirección es la
//   preparación para herramientas de monitoreo futuras.
//
// FILTRADO POR NIVEL (dos capas, defensa en profundidad):
//   1. AppConfig.minimumLogLevel decide en runtime qué se descarta ANTES de
//      construir el LogEntry — evita el costo de sanitizar/formatear
//      mensajes verbose/debug en producción.
//   2. kDebugMode: verbose/debug NUNCA se emiten fuera de un build de
//      debug, sin importar qué diga minimumLevel — una segunda barrera
//      para que un AppConfig mal configurado no filtre logs de desarrollo
//      (potencialmente más verbosos/crudos) a un release.
//
// PRIVACIDAD:
//   TODA metadata pasa por LogSanitizer.sanitize() antes de llegar a
//   cualquier LogSink — ver core/logging/log_sanitizer.dart para la
//   estrategia completa (falla ruidoso en dev, falla seguro en prod).
//
// DEPENDENCIAS PERMITIDAS:   flutter/foundation.dart (kDebugMode — patrón ya
//                            usado en core/di/app_di.dart), core/logging/.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:jardindeleden/core/logging/app_logger.dart';
import 'package:jardindeleden/core/logging/log_entry.dart';
import 'package:jardindeleden/core/logging/log_level.dart';
import 'package:jardindeleden/core/logging/log_sanitizer.dart';
import 'package:jardindeleden/core/logging/log_sink.dart';

/// Implementación de [AppLogger] con fan-out a una lista de [LogSink].
final class AppLoggerImpl implements AppLogger {
  AppLoggerImpl({required LogLevel minimumLevel, required List<LogSink> sinks})
    : _minimumLevel = minimumLevel,
      _sinks = sinks;

  final LogLevel _minimumLevel;
  final List<LogSink> _sinks;

  String? _sessionId;
  String? _anonymousProfileId;

  @override
  void setSessionId(String sessionId) => _sessionId = sessionId;

  @override
  void setAnonymousProfileId(String anonymousId) =>
      _anonymousProfileId = anonymousId;

  @override
  void verbose(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
  }) => _log(LogLevel.verbose, message, module: module, metadata: metadata);

  @override
  void debug(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
  }) => _log(LogLevel.debug, message, module: module, metadata: metadata);

  @override
  void info(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
  }) => _log(LogLevel.info, message, module: module, metadata: metadata);

  @override
  void warning(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
    Object? cause,
  }) => _log(
    LogLevel.warning,
    message,
    module: module,
    metadata: metadata,
    cause: cause,
  );

  @override
  void error(
    String message, {
    required String module,
    Map<String, Object?>? metadata,
    Object? cause,
    StackTrace? stackTrace,
  }) => _log(
    LogLevel.error,
    message,
    module: module,
    metadata: metadata,
    cause: cause,
    stackTrace: stackTrace,
  );

  void _log(
    LogLevel level,
    String message, {
    required String module,
    Map<String, Object?>? metadata,
    Object? cause,
    StackTrace? stackTrace,
  }) {
    final isDevOnlyLevel = level == LogLevel.verbose || level == LogLevel.debug;
    if (isDevOnlyLevel && !kDebugMode) return;
    if (!level.isAtLeast(_minimumLevel)) return;

    final entry = LogEntry(
      level: level,
      module: module,
      message: message,
      timestamp: DateTime.now(),
      sessionId: _sessionId,
      anonymousProfileId: _anonymousProfileId,
      metadata: LogSanitizer.sanitize(metadata ?? const {}),
      cause: cause,
      stackTrace: stackTrace,
    );

    for (final sink in _sinks) {
      sink.write(entry);
    }
  }
}
