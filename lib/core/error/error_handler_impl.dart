// ─────────────────────────────────────────────────────────────────────────────
// core/error/error_handler_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de ErrorHandler. A diferencia del contrato (que solo
//   conoce AppException/Failure/Result), esta clase SÍ conoce las
//   excepciones crudas de paquetes concretos (sqlite3, dart:io) para poder
//   clasificarlas.
//
// CLASIFICACIÓN (classify):
//   SqliteException      → DatabaseCorruptionException (códigos CORRUPT/
//                           NOTADB — este último es también lo que se ve si
//                           la clave de SQLCipher es incorrecta) o
//                           DatabaseWriteException (resto de códigos).
//   FileSystemException  → FileNotFoundException / FileWriteException /
//                           FileDeleteException / FileReadException, según
//                           palabras clave en el mensaje del error (best
//                           effort — dart:io no tipa la operación).
//   FormatException      → InvalidFormatException.
//   TimeoutException      → UnexpectedException (no hay categoría propia;
//                           ver nota en classify()).
//   Ya es AppException   → se retorna sin modificar (idempotente).
//   Cualquier otra cosa   → UnexpectedException.
//
// RECUPERACIÓN (guardWithRetry):
//   Solo se reintentan errores de lectura/escritura de DB y de archivos —
//   son los que plausiblemente se deben a contención momentánea (disco,
//   locks). Corrupción, migraciones, validación, dominio y seguridad NUNCA
//   se reintentan: reintentar un PIN incorrecto o una DB corrupta no arregla
//   nada, solo demora el error real.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:async, dart:io, sqlite3,
//                            core/error/ (contrato, AppException, Result),
//                            core/logging/app_logger.dart, domain/core/failure.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'dart:io';

import 'package:jardindeleden/core/error/app_exception.dart';
import 'package:jardindeleden/core/error/error_handler.dart';
import 'package:jardindeleden/core/error/result.dart';
import 'package:jardindeleden/core/logging/app_logger.dart';
// 'Failure' colisiona con Result.Failure (el caso de fallo del wrapper
// genérico) — se importa con prefijo para desambiguar en toda la firma.
import 'package:jardindeleden/domain/core/failure.dart' as domain;
import 'package:sqlite3/common.dart' show SqliteException;

/// Implementación de [ErrorHandler].
final class ErrorHandlerImpl implements ErrorHandler {
  ErrorHandlerImpl({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  /// Códigos primarios de SQLite que indican corrupción irreversible del
  /// archivo, no un problema transitorio. SQLITE_NOTADB (26) también ocurre
  /// cuando SQLCipher recibe la clave de cifrado incorrecta.
  static const Set<int> _sqliteCorruptionCodes = {11, 26};

  @override
  Future<Result<T, AppException>> guard<T>(
    Future<T> Function() action, {
    required String module,
  }) async {
    try {
      return Success(await action());
    } catch (error, stackTrace) {
      final exception = classify(error, stackTrace);
      _logError(exception, module: module, stackTrace: stackTrace);
      return Failure(exception);
    }
  }

  @override
  Future<Result<T, AppException>> guardWithRetry<T>(
    Future<T> Function() action, {
    required String module,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(milliseconds: 300),
  }) async {
    var attempt = 0;
    var delay = initialDelay;

    while (true) {
      attempt++;
      try {
        return Success(await action());
      } catch (error, stackTrace) {
        final exception = classify(error, stackTrace);
        final isLastAttempt = attempt >= maxAttempts;

        if (!_isTransient(exception) || isLastAttempt) {
          _logError(
            exception,
            module: module,
            stackTrace: stackTrace,
            attempt: attempt,
          );
          return Failure(exception);
        }

        _logger.warning(
          'Reintentando tras error transitorio (intento $attempt/$maxAttempts)',
          module: module,
          cause: exception,
          metadata: {'code': exception.code},
        );
        await Future<void>.delayed(delay);
        delay *= 2;
      }
    }
  }

  void _logError(
    AppException exception, {
    required String module,
    required StackTrace stackTrace,
    int? attempt,
  }) {
    _logger.error(
      exception.message,
      module: module,
      cause: exception.cause ?? exception,
      stackTrace: stackTrace,
      metadata: {'code': exception.code, 'attempt': ?attempt},
    );
  }

  @override
  AppException classify(Object error, StackTrace stackTrace) {
    if (error is AppException) return error;

    if (error is SqliteException) return _classifySqlite(error);
    if (error is FileSystemException) return _classifyFileSystem(error);

    if (error is FormatException) {
      return InvalidFormatException(message: error.message);
    }

    if (error is TimeoutException) {
      return UnexpectedException(
        message: 'La operación excedió el tiempo límite',
        cause: error,
      );
    }

    return UnexpectedException(message: error.toString(), cause: error);
  }

  AppException _classifySqlite(SqliteException error) {
    if (_sqliteCorruptionCodes.contains(error.resultCode)) {
      return DatabaseCorruptionException(message: error.message, cause: error);
    }
    return DatabaseWriteException(message: error.message, cause: error);
  }

  AppException _classifyFileSystem(FileSystemException error) {
    final message = error.message.toLowerCase();

    if (message.contains('cannot find') || message.contains('no such file')) {
      return FileNotFoundException(message: error.toString(), cause: error);
    }
    if (message.contains('delete') || message.contains('remove')) {
      return FileDeleteException(message: error.toString(), cause: error);
    }
    if (message.contains('write') ||
        message.contains('creat') ||
        message.contains('rename')) {
      return FileWriteException(message: error.toString(), cause: error);
    }
    return FileReadException(message: error.toString(), cause: error);
  }

  /// true si reintentar [exception] tiene sentido — solo contención
  /// momentánea de I/O, nunca corrupción/validación/dominio/seguridad.
  bool _isTransient(AppException exception) => switch (exception) {
    DatabaseReadException() => true,
    DatabaseWriteException() => true,
    FileReadException() => true,
    FileWriteException() => true,
    DatabaseMigrationException() => false,
    DatabaseCorruptionException() => false,
    AssetException() => false,
    FileException() => false,
    ValidationException() => false,
    DomainException() => false,
    SecurityException() => false,
    UnexpectedException() => false,
  };

  @override
  domain.Failure toFailure(AppException exception) => switch (exception) {
    SessionExpiredException() => domain.AuthFailure(
      message: exception.message,
      cause: exception,
    ),
    DatabaseException() => domain.DatabaseFailure(
      message: exception.message,
      cause: exception.cause ?? exception,
    ),
    AssetException() => domain.FileFailure(
      message: exception.message,
      cause: exception.cause ?? exception,
    ),
    FileException() => domain.FileFailure(
      message: exception.message,
      cause: exception.cause ?? exception,
    ),
    ValidationException() => domain.ValidationFailure(
      message: exception.message,
    ),
    DomainException() => domain.DomainFailure(message: exception.message),
    SecurityException() => domain.AuthFailure(
      message: exception.message,
      cause: exception.cause ?? exception,
    ),
    UnexpectedException() => domain.UnexpectedFailure(
      message: exception.message,
      cause: exception.cause ?? exception,
    ),
  };
}
