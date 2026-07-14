// ─────────────────────────────────────────────────────────────────────────────
// core/error/result.dart
//
// RESPONSABILIDAD:
//   Define el tipo Result<S, F> utilizado por todos los Casos de Uso.
//   Reemplaza el lanzamiento de excepciones en la capa de dominio.
//   Hace explícito en la firma del método que la operación puede fallar.
//
// PATRÓN:   Either / Result (programación funcional)
//   Success<S> — La operación fue exitosa. Contiene el valor de tipo S.
//   Failure<F> — La operación falló. Contiene el error de tipo F.
//
// FIRMA ESTÁNDAR DE UN CASO DE USO:
//   Future<Result<ChapterEntity, AppException>> execute(String chapterId);
//
// USO EN PRESENTACIÓN (providers de Riverpod):
//   final result = await completeChapterUseCase.execute(chapterId);
//   result.fold(
//     onSuccess: (chapter) => state = AsyncData(chapter),
//     onFailure: (error)   => state = AsyncError(error, StackTrace.current),
//   );
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, Riverpod, Drift, features, shared.
//
// NOTA: Este tipo se implementa sin librerías externas (como fpdart)
//       para mantener la capa de dominio libre de dependencias de paquetes.
//       Si en el futuro se adopta fpdart, solo este archivo cambia.
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core
// ─────────────────────────────────────────────────────────────────────────────

/// Resultado de una operación que puede exitosa [S] o fallida [F].
///
/// Todos los Casos de Uso retornan `Future<Result<S, F>>`.
/// El tipo F siempre es un subtipo de AppException en este proyecto.
sealed class Result<S, F> {
  const Result();

  /// Transforma el resultado aplicando la función correspondiente
  /// según si fue exitoso o fallido.
  T fold<T>({
    required T Function(S value) onSuccess,
    required T Function(F error) onFailure,
  });

  /// true si el resultado es Success.
  bool get isSuccess => this is Success<S, F>;

  /// true si el resultado es Failure.
  bool get isFailure => this is Failure<S, F>;

  /// Lanza si no es Success. Solo usar cuando se ha verificado [isSuccess].
  Success<S, F> get asSuccess => this as Success<S, F>;

  /// Lanza si no es Failure. Solo usar cuando se ha verificado [isFailure].
  Failure<S, F> get asFailure => this as Failure<S, F>;
}

/// Resultado exitoso. Contiene el valor de tipo [S].
final class Success<S, F> extends Result<S, F> {
  const Success(this.value);

  /// El valor resultante de la operación exitosa.
  final S value;

  @override
  T fold<T>({
    required T Function(S value) onSuccess,
    required T Function(F error) onFailure,
  }) =>
      onSuccess(value);

  @override
  String toString() => 'Success($value)';
}

/// Resultado fallido. Contiene el error de tipo [F].
final class Failure<S, F> extends Result<S, F> {
  const Failure(this.error);

  /// El error que causó el fallo de la operación.
  final F error;

  @override
  T fold<T>({
    required T Function(S value) onSuccess,
    required T Function(F error) onFailure,
  }) =>
      onFailure(error);

  @override
  String toString() => 'Failure($error)';
}
