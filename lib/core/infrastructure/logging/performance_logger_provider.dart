// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/logging/performance_logger_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de PerformanceLogger.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, performance_logger_impl,
//                            app_logger_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/infrastructure/logging/app_logger_provider.dart';
import 'package:jardindeleden/core/logging/performance_logger.dart';
import 'package:jardindeleden/core/logging/performance_logger_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'performance_logger_provider.g.dart';

/// Instancia singleton de [PerformanceLogger].
@Riverpod(keepAlive: true)
PerformanceLogger performanceLogger(PerformanceLoggerRef ref) {
  return PerformanceLoggerImpl(logger: ref.watch(appLoggerProvider));
}
