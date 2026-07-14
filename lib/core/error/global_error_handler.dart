// ─────────────────────────────────────────────────────────────────────────────
// core/error/global_error_handler.dart
//
// RESPONSABILIDAD:
//   Red de seguridad final: captura cualquier error que NO haya pasado por
//   ErrorHandler.guard() — errores de framework de Flutter (build/layout/
//   render) y errores async no atrapados en ninguna Zone. Sin esto, esos
//   errores solo aparecerían en la consola y se perderían en producción.
//
// LOS DOS CANALES QUE INTERCEPTA:
//   FlutterError.onError            → errores síncronos del framework
//                                      (excepciones durante build/layout).
//   PlatformDispatcher.instance.onError → errores async fuera de cualquier
//                                      try/catch, incluyendo los de Zone
//                                      si se usa runZonedGuarded en main().
//
// SE INSTALA UNA SOLA VEZ, EN main.dart:
//   ```dart
//   void main() {
//     runZonedGuarded(() async {
//       WidgetsFlutterBinding.ensureInitialized();
//       final container = await AppDI.init();
//       installGlobalErrorHandlers(container.read(appLoggerProvider));
//       runApp(...);
//     }, (error, stackTrace) {
//       container.read(appLoggerProvider).error(
//         error.toString(), module: 'unhandled', cause: error, stackTrace: stackTrace,
//       );
//     });
//   }
//   ```
//
// QUÉ NO HACE:
//   No intenta recuperar la app de un error de framework (eso normalmente
//   no es seguro) — solo garantiza que quede REGISTRADO antes de que
//   Flutter muestre su pantalla roja de error en dev, o silencie el error
//   en release.
//
// DEPENDENCIAS PERMITIDAS:   flutter/foundation.dart, core/logging/app_logger.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:jardindeleden/core/logging/app_logger.dart';
import 'package:jardindeleden/core/logging/log_modules.dart';

/// Instala los manejadores globales de error de Flutter, delegando el
/// registro a [logger] bajo module = 'unhandled'.
///
/// Llamar UNA SOLA VEZ, en main(), antes de runApp().
void installGlobalErrorHandlers(AppLogger logger) {
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.error(
      details.exceptionAsString(),
      module: LogModules.unhandled,
      cause: details.exception,
      stackTrace: details.stack,
      metadata: {
        'library': details.library,
        'context': details.context?.toString(),
      },
    );
    previousOnError?.call(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    logger.error(
      error.toString(),
      module: LogModules.unhandled,
      cause: error,
      stackTrace: stackTrace,
    );
    return true;
  };
}
