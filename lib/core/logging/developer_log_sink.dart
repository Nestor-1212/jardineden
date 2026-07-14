// ─────────────────────────────────────────────────────────────────────────────
// core/logging/developer_log_sink.dart
//
// RESPONSABILIDAD:
//   Implementación de LogSink sobre dart:developer.log — visible en
//   DevTools/Observatory y en la consola de `flutter run`. Es el ÚNICO sink
//   activo hoy (ver core/infrastructure/logging/log_sinks_provider.dart).
//
// DEPENDENCIAS PERMITIDAS:   dart:developer, core/logging/ (LogEntry, LogSink).
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:developer' as developer;

import 'package:jardindeleden/core/logging/log_entry.dart';
import 'package:jardindeleden/core/logging/log_level.dart';
import 'package:jardindeleden/core/logging/log_sink.dart';

/// [LogSink] sobre `dart:developer.log`.
final class DeveloperLogSink implements LogSink {
  const DeveloperLogSink();

  @override
  void write(LogEntry entry) {
    final context = <String, Object?>{
      if (entry.sessionId != null) 'session_id': entry.sessionId,
      if (entry.anonymousProfileId != null) 'profile_id': entry.anonymousProfileId,
      ...entry.metadata,
    };

    developer.log(
      context.isEmpty ? entry.message : '${entry.message} | $context',
      time: entry.timestamp,
      level: _developerLevel(entry.level),
      name: entry.module,
      error: entry.cause,
      stackTrace: entry.stackTrace,
    );
  }

  /// Traduce [LogLevel] a la escala de severidad de dart:developer.log,
  /// que sigue la convención de java.util.logging.Level.
  int _developerLevel(LogLevel level) => switch (level) {
        LogLevel.verbose => 300,
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      };
}
