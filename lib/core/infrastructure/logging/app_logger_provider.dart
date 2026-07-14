// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/logging/app_logger_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de AppLogger, con el nivel mínimo fijado
//   por AppConfig.minimumLogLevel (verbose en dev, debug en staging, info
//   en prod).
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   El logger acumula sessionId/profileId en memoria — debe sobrevivir toda
//   la sesión, no reiniciarse por pantalla.
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, app_logger_impl, app_config,
//                            log_sinks_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/config/app_config.dart';
import 'package:jardindeleden/core/infrastructure/logging/log_sinks_provider.dart';
import 'package:jardindeleden/core/logging/app_logger.dart';
import 'package:jardindeleden/core/logging/app_logger_impl.dart';
import 'package:jardindeleden/core/logging/log_level.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_logger_provider.g.dart';

/// Instancia singleton de [AppLogger].
@Riverpod(keepAlive: true)
AppLogger appLogger(AppLoggerRef ref) {
  return AppLoggerImpl(
    minimumLevel: LogLevel.values.byName(AppConfig.minimumLogLevel),
    sinks: ref.watch(logSinksProvider),
  );
}
