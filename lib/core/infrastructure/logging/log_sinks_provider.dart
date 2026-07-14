// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/logging/log_sinks_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la lista de LogSink activos. ÚNICO lugar del proyecto donde se
//   decide qué destinos de log están habilitados.
//
// CÓMO SE CONECTA UNA HERRAMIENTA DE MONITOREO FUTURA (Sentry, Crashlytics,
// OpenTelemetry, etc.):
//   1. Implementar LogSink en un nuevo archivo (ej: core/logging/sentry_log_sink.dart).
//   2. Agregar la instancia a la lista de abajo.
//   3. Nada más cambia — AppLoggerImpl, y cada llamada a logger.info()/error()
//      en todo el proyecto, siguen funcionando exactamente igual.
//
// POR QUÉ HOY SOLO DeveloperLogSink:
//   Es el único sink que no requiere una cuenta/SDK de terceros ni
//   configuración de red — funciona en dev y en release sin dependencias
//   nuevas. Agregar un sink remoto es una decisión de producto (qué
//   proveedor, qué política de retención, consentimiento parental para
//   telemetría) que corresponde a un Sprint futuro, no a esta infraestructura.
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, core/logging/ (LogSink,
//                            DeveloperLogSink).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/logging/developer_log_sink.dart';
import 'package:jardindeleden/core/logging/log_sink.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'log_sinks_provider.g.dart';

/// Lista de [LogSink] activos, en el orden en que reciben cada [LogEntry].
@Riverpod(keepAlive: true)
List<LogSink> logSinks(LogSinksRef ref) {
  return const [
    DeveloperLogSink(),
    // Sprint futuro (monitoreo remoto):
    // SentryLogSink(dsn: ...),
    // CrashlyticsLogSink(),
  ];
}
