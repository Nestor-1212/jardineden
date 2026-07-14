// ─────────────────────────────────────────────────────────────────────────────
// core/logging/educational_event_logger_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de EducationalEventLogger sobre AppLogger.
//
// DEPENDENCIAS PERMITIDAS:   core/logging/ (contrato, AppLogger, LogModules)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/logging/app_logger.dart';
import 'package:jardindeleden/core/logging/educational_event_logger.dart';
import 'package:jardindeleden/core/logging/log_modules.dart';

/// Implementación de [EducationalEventLogger] sobre [AppLogger].
final class EducationalEventLoggerImpl implements EducationalEventLogger {
  EducationalEventLoggerImpl({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  @override
  void logEvent(
    String eventName, {
    required String anonymousProfileId,
    Map<String, Object?>? metadata,
  }) {
    // Se incluye explícitamente en vez de mutar el estado global de
    // AppLogger.setAnonymousProfileId() — ese setter es para el perfil
    // ACTIVO de la sesión (se llama una vez al iniciar sesión), no en cada
    // evento individual.
    _logger.info(
      eventName,
      module: LogModules.education,
      metadata: {
        'profile_id': anonymousProfileId,
        if (metadata != null) ...metadata,
      },
    );
  }
}
