// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/logging/navigation_logger_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de NavigationLogger.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, navigation_logger_impl,
//                            app_logger_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/infrastructure/logging/app_logger_provider.dart';
import 'package:jardindeleden/core/logging/navigation_logger.dart';
import 'package:jardindeleden/core/logging/navigation_logger_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_logger_provider.g.dart';

/// Instancia singleton de [NavigationLogger].
@Riverpod(keepAlive: true)
NavigationLogger navigationLogger(NavigationLoggerRef ref) {
  return NavigationLoggerImpl(logger: ref.watch(appLoggerProvider));
}
