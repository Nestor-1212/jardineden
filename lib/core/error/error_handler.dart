// ─────────────────────────────────────────────────────────────────────────────
// core/error/error_handler.dart
//
// RESPONSABILIDAD:
//   Punto ÚNICO y uniforme de manejo de errores para todo el proyecto.
//   Es la pieza que conecta las tres partes que antes vivían aisladas:
//     • AppException  (core/error/app_exception.dart)  — vocabulario técnico
//     • Failure       (domain/core/failure.dart)        — vocabulario de negocio
//     • AppLogger     (core/logging/app_logger.dart)     — registro central
//
// LAS CUATRO OPERACIONES:
//   1. classify()       — convierte CUALQUIER Object lanzado (una excepción
//                          de Drift, dart:io, un FormatException, o ya un
//                          AppException) en el AppException más específico
//                          posible. Nunca falla; en el peor caso retorna
//                          UnexpectedException.
//   2. guard()          — ejecuta una operación async, atrapa lo que sea que
//                          lance, la clasifica, la REGISTRA vía AppLogger, y
//                          retorna Result<T, AppException>. Éste es el único
//                          lugar del proyecto donde se hace try/catch de
//                          infraestructura — todo repositorio lo usa igual.
//   3. guardWithRetry() — igual que guard(), pero reintenta con backoff
//                          exponencial cuando el error es transitorio
//                          (ver _isTransient en la implementación). Es la
//                          estrategia de RECUPERACIÓN del sistema.
//   4. toFailure()      — traduce un AppException (vocabulario técnico) a un
//                          Failure (vocabulario de negocio). Los casos de uso
//                          llaman a esto sobre el AppException que reciben
//                          del repositorio, nunca construyen Failure a mano.
//
// QUIÉN LLAMA A QUÉ:
//   Repositorio (capa de datos):
//     return errorHandler.guard(() => _dao.insertProfile(profile), module: 'auth');
//     // => Result<void, AppException>
//
//   Caso de uso (capa de dominio):
//     final result = await _repository.save(profile);
//     return result.fold(
//       onSuccess: (value) => Success(value),
//       onFailure: (exception) => Failure(errorHandler.toFailure(exception)),
//     );
//     // => Result<void, Failure>
//
// ERRORES INESPERADOS (fuera de guard/guardWithRetry):
//   Cualquier error que NO pase por un caso de uso (un error async no
//   atrapado, un error de framework de Flutter) lo captura la red de
//   seguridad global — ver core/error/global_error_handler.dart,
//   instalada una sola vez en main.dart. También pasa por AppLogger, con
//   module = 'unhandled'.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:async,
//                            core/error/app_exception.dart,
//                            core/error/result.dart,
//                            domain/core/failure.dart
// DEPENDENCIAS PROHIBIDAS:   Flutter, features, shared.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/error/app_exception.dart';
import 'package:jardindeleden/core/error/result.dart';
// 'Failure' colisiona con Result.Failure (el caso de fallo del wrapper
// genérico) — se importa con prefijo para desambiguar en toda la firma.
import 'package:jardindeleden/domain/core/failure.dart' as domain;

/// Contrato del manejador uniforme de errores del proyecto.
abstract interface class ErrorHandler {
  /// Ejecuta [action], clasifica y registra cualquier error, y retorna un
  /// [Result] — nunca deja escapar una excepción cruda.
  ///
  /// [module] identifica el origen para los logs (ej: 'auth', 'database',
  /// 'backup') — el mismo valor que se pasaría a AppLogger directamente.
  Future<Result<T, AppException>> guard<T>(
    Future<T> Function() action, {
    required String module,
  });

  /// Igual que [guard], pero reintenta con backoff exponencial si el error
  /// clasificado es transitorio (ver _isTransient en ErrorHandlerImpl).
  ///
  /// [maxAttempts] incluye el primer intento (2 = 1 reintento).
  /// [initialDelay] es la espera antes del primer reintento; se duplica en
  /// cada intento subsiguiente.
  Future<Result<T, AppException>> guardWithRetry<T>(
    Future<T> Function() action, {
    required String module,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(milliseconds: 300),
  });

  /// Clasifica cualquier [error] lanzado en el [AppException] más específico
  /// posible. Si [error] ya es un [AppException], lo retorna sin modificar.
  /// Nunca lanza — en el peor caso retorna [UnexpectedException].
  AppException classify(Object error, StackTrace stackTrace);

  /// Traduce un [AppException] (vocabulario técnico) a un [domain.Failure]
  /// (vocabulario de negocio) para que la capa de dominio lo propague a
  /// presentación sin exponer detalles de infraestructura.
  domain.Failure toFailure(AppException exception);
}
