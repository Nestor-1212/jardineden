// ─────────────────────────────────────────────────────────────────────────────
// core/logging/performance_logger_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de PerformanceLogger sobre AppLogger + Stopwatch.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, core/logging/ (contrato, AppLogger,
//                            LogModules).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/logging/app_logger.dart';
import 'package:jardindeleden/core/logging/log_modules.dart';
import 'package:jardindeleden/core/logging/performance_logger.dart';

/// Implementación de [PerformanceLogger] sobre [AppLogger].
final class PerformanceLoggerImpl implements PerformanceLogger {
  PerformanceLoggerImpl({
    required AppLogger logger,
    this.warnThreshold = const Duration(milliseconds: 500),
  }) : _logger = logger;

  final AppLogger _logger;

  /// Duración a partir de la cual una operación se loguea como warning en
  /// vez de debug.
  final Duration warnThreshold;

  @override
  Future<T> measure<T>(
    String operation,
    Future<T> Function() action, {
    String? module,
  }) async {
    final stopwatch = Stopwatch()..start();
    final effectiveModule = module ?? LogModules.performance;

    try {
      final result = await action();
      stopwatch.stop();
      _log(operation, stopwatch.elapsedMilliseconds, effectiveModule, failed: false);
      return result;
    } catch (_) {
      stopwatch.stop();
      _log(operation, stopwatch.elapsedMilliseconds, effectiveModule, failed: true);
      rethrow;
    }
  }

  void _log(String operation, int elapsedMs, String module, {required bool failed}) {
    final metadata = {'duration_ms': elapsedMs, if (failed) 'failed': true};

    if (elapsedMs >= warnThreshold.inMilliseconds) {
      _logger.warning('slow_operation: $operation', module: module, metadata: metadata);
    } else {
      _logger.debug(operation, module: module, metadata: metadata);
    }
  }
}
