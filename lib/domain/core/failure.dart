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
// DISEÑO SEALED CLASS:
//   `sealed` garantiza exhaustividad en switch expressions en Dart 3.
//   Al agregar una nueva subclase, el compilador fuerza actualizar todos los
//   switch que manejan [Failure].
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   flutter, riverpod, features, data.
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
///   case DatabaseFailure(:final message) => showError(message),
///   case AuthFailure(:final message)     => showPinDialog(message),
///   case StorageFailure(:final message)  => showRetry(message),
///   case ValidationFailure(:final message) => showValidation(message),
///   case NetworkFailure(:final message)  => showOffline(message),
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
