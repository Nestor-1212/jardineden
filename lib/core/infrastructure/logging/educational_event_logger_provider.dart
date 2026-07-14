// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/logging/educational_event_logger_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de EducationalEventLogger.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, educational_event_logger_impl,
//                            app_logger_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/infrastructure/logging/app_logger_provider.dart';
import 'package:jardindeleden/core/logging/educational_event_logger.dart';
import 'package:jardindeleden/core/logging/educational_event_logger_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'educational_event_logger_provider.g.dart';

/// Instancia singleton de [EducationalEventLogger].
@Riverpod(keepAlive: true)
EducationalEventLogger educationalEventLogger(EducationalEventLoggerRef ref) {
  return EducationalEventLoggerImpl(logger: ref.watch(appLoggerProvider));
}
