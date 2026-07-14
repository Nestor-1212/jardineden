// ─────────────────────────────────────────────────────────────────────────────
// core/logging/log_sink.dart
//
// RESPONSABILIDAD:
//   Contrato de un DESTINO de log. AppLoggerImpl no escribe logs
//   directamente — construye un LogEntry y se lo entrega a cada LogSink
//   registrado. Esta indirección es TODA la preparación que este Sprint
//   necesita para futuras herramientas de monitoreo:
//
//   HOY:     [DeveloperLogSink]  → dart:developer.log (consola/DevTools).
//   MAÑANA:  SentryLogSink, CrashlyticsLogSink, OtelLogSink, etc. — cada
//            uno implementa [write] a su manera (llamar al SDK del
//            proveedor) y se agrega a la lista de sinks en
//            core/infrastructure/logging/log_sinks_provider.dart.
//            NINGÚN call site de AppLogger cambia cuando eso pase.
//
// POR QUÉ FAN-OUT (varios sinks a la vez) Y NO UNO SOLO:
//   Permite tener consola (dev) + servicio remoto (prod) simultáneamente sin
//   condicionales en el código de logging — cada sink decide internamente
//   si le interesa esa entrada (ej: un RemoteLogSink futuro podría ignorar
//   [LogLevel.verbose] aunque la consola sí la muestre).
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:async, core/logging/log_entry.dart.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/logging/log_entry.dart';

/// Contrato de un destino de log.
abstract interface class LogSink {
  /// Escribe [entry] en este destino.
  ///
  /// NUNCA debe lanzar — un sink roto (ej: sin conexión a un servicio
  /// remoto) no puede tumbar el logging del resto de la app. Los sinks
  /// remotos deben atrapar sus propios errores de red internamente.
  void write(LogEntry entry);
}
