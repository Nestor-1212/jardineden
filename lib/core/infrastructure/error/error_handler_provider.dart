// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/error/error_handler_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de ErrorHandler.
//
// CICLO DE VIDA: Singleton (keepAlive: true) — es stateless, pero se
//   registra como singleton por convención de DI del proyecto.
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, error_handler_impl,
//                            app_logger_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/error/error_handler.dart';
import 'package:jardindeleden/core/error/error_handler_impl.dart';
import 'package:jardindeleden/core/infrastructure/logging/app_logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_handler_provider.g.dart';

/// Instancia singleton de [ErrorHandler].
@Riverpod(keepAlive: true)
ErrorHandler errorHandler(ErrorHandlerRef ref) {
  final logger = ref.watch(appLoggerProvider);
  return ErrorHandlerImpl(logger: logger);
}
