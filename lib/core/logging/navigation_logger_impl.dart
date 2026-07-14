// ─────────────────────────────────────────────────────────────────────────────
// core/logging/navigation_logger_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de NavigationLogger sobre AppLogger.
//
// DEPENDENCIAS PERMITIDAS:   core/logging/ (contrato, AppLogger, LogModules)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/logging/app_logger.dart';
import 'package:jardindeleden/core/logging/log_modules.dart';
import 'package:jardindeleden/core/logging/navigation_logger.dart';

/// Implementación de [NavigationLogger] sobre [AppLogger].
final class NavigationLoggerImpl implements NavigationLogger {
  NavigationLoggerImpl({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  @override
  void logRouteChange({
    required String? from,
    required String to,
    Map<String, Object?>? params,
  }) {
    _logger.info(
      'route_change',
      module: LogModules.navigation,
      metadata: {'from': ?from, 'to': to, ...?params},
    );
  }
}
