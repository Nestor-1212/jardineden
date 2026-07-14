// ─────────────────────────────────────────────────────────────────────────────
// domain/core/failure.dart
//
// RESPONSABILIDAD:
//   Define la jerarquía de fallos del dominio de negocio.
//
// PRINCIPIO:
//   El dominio NUNCA lanza excepciones — devuelve tipos [Failure].
//   Los casos de uso retornan Future<T> y capturan excepciones de infraestructura,
//   convirtiéndolas en [Failure] antes de propagarlas a la capa de presentación.
//
// INTEGRACIÓN CON RIVERPOD:
//   Los [Notifier] de la capa de presentación reciben [Failure] y los mapean
//   a mensajes de UI usando [AppLocalizations]:
//   ```dart
//   on DatabaseFailure => context.l10n.errorDatabaseRead
//   on AuthFailure     => context.l10n.errorPinIncorrect
//   on NetworkFailure  => context.l10n.errorNoConnection
//   ```
//
// DE DÓNDE VIENEN LOS Failure (ver core/error/error_handler.dart):
//   Los casos de uso no construyen Failure a mano en cada catch — reciben un
//   AppException (de core/error/app_exception.dart, la capa de datos) y
//   llaman a ErrorHandler.toFailure(exception) para traducirlo. Esta clase
//   es deliberadamente independiente de AppException (cero import cruzado)
//   para que el dominio no dependa de detalles de infraestructura — la
//   traducción vive del lado de ErrorHandler, no aquí.
//
// DISEÑO SEALED CLASS:
//   `sealed` garantiza exhaustividad en switch expressions en Dart 3.
//   Al agregar una nueva subclase, el compilador fuerza actualizar todos los
//   switch que manejan [Failure].
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   flutter, riverpod, features, data, core/error
//                            (la relación es unidireccional: error_handler
//                            importa failure.dart, nunca al revés).
// ─────────────────────────────────────────────────────────────────────────────

/// Tipo base sellado para todos los fallos del dominio.
///
/// Todas las subclases son `final` — no pueden extenderse fuera de este archivo.
/// Usar en switch expressions para manejar todos los casos:
///
/// ```dart
/// final result = await useCase.call(params);
/// // Manejo exhaustivo garantizado por el compilador:
/// switch (result) {
///   case DatabaseFailure(:final message)    => showError(message),
///   case AuthFailure(:final message)        => showPinDialog(message),
///   case StorageFailure(:final message)     => showRetry(message),
///   case ValidationFailure(:final message)  => showValidation(message),
///   case NetworkFailure(:final message)     => showOffline(message),
///   case FileFailure(:final message)        => showRetry(message),
///   case DomainFailure(:final message)      => showBusinessMessage(message),
///   case UnexpectedFailure(:final message)  => showGenericError(message),
/// }
/// ```
sealed class Failure {
  const Failure({required this.message, this.cause});

  /// Mensaje técnico del error (para logging — no mostrar al usuario).
  final String message;

  /// Excepción original que causó este fallo, si aplica.
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType: $message${cause != null ? ' (cause: $cause)' : ''}';
}

/// Error de base de datos local (Drift/SQLite).
///
/// Causas comunes: disco lleno, base de datos corrupta, migración fallida.
final class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.cause});
}

/// Error de almacenamiento seguro (FlutterSecureStorage / Keychain / Keystore).
///
/// Causas comunes: usuario sin biometría configurada, permisos denegados en Android.
final class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.cause});
}

/// Error de validación de datos de entrada.
///
/// Causas: PIN muy corto, nombre de perfil vacío, avatar inválido.
/// Este fallo NO tiene [cause] — es una decisión de negocio, no una excepción.
final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Error de autenticación: PIN incorrecto o sesión parental expirada.
final class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.cause});
}

/// Error de conectividad de red (futuro — para contenido descargable).
///
/// Sprint Online: usar cuando el jugador intente descargar mundos sin conexión.
final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.cause});
}

/// Error de archivos (backups, exports, cualquier I/O que no sea la DB).
///
/// Causas comunes: disco lleno, permisos denegados, archivo no encontrado.
final class FileFailure extends Failure {
  const FileFailure({required super.message, super.cause});
}

/// Violación de una regla de negocio del juego (no un error técnico).
///
/// Causas: monedas insuficientes, capítulo bloqueado por el Muro de
/// Sabiduría, límite de perfiles alcanzado. Como [ValidationFailure], NO
/// tiene [cause] — es una decisión de negocio esperada, no una excepción.
final class DomainFailure extends Failure {
  const DomainFailure({required super.message});
}

/// Cualquier error que ErrorHandler no pudo ubicar en ninguna categoría
/// anterior — la red de seguridad final antes de llegar a la UI.
///
/// Si este tipo aparece con frecuencia en producción, falta una categoría
/// específica en esta jerarquía — revisar los logs (siempre trae [cause]).
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.cause});
}
