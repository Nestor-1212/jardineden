// ─────────────────────────────────────────────────────────────────────────────
// domain/core/i_use_case.dart
//
// RESPONSABILIDAD:
//   Interfaz genérica que estandariza todos los casos de uso del dominio.
//
// POR QUÉ INTERFAZ GENÉRICA:
//   Un contrato uniforme [call(Input) → Future<Output>] permite:
//   ✓ Testing predecible: siempre se mockea el mismo método.
//   ✓ Middleware opcional: logging, métricas, retry wrapping.
//   ✓ Documentación implícita: cualquier clase IUseCase es un comando.
//
// CICLO DE VIDA EN RIVERPOD:
//   Use cases son stateless — no tienen estado propio.
//   → Registrar como @Riverpod(keepAlive: true) (Singleton) si el use case
//     solo llama al repositorio sin lógica de estado.
//   → Usar @riverpod (Factory/autoDispose) solo si el use case crea recursos
//     efímeros por sesión (caso raro en este proyecto).
//
// CASOS DE USO SIN PARÁMETROS:
//   Usar `void` como Input:
//   ```dart
//   class GetActiveProfileUseCase implements IUseCase<void, Profile?> {
//     @override
//     Future<Profile?> call(void _) => _repository.getActive();
//   }
//   // Llamada: await useCase.call(null);
//   ```
//
// EJEMPLO COMPLETO:
//   ```dart
//   // 1. Definición
//   // lib/domain/usecases/save_profile_use_case.dart
//   class SaveProfileUseCase implements IUseCase<Profile, void> {
//     const SaveProfileUseCase(this._repository);
//     final IProfileRepository _repository;
//
//     @override
//     Future<void> call(Profile profile) => _repository.save(profile);
//   }
//
//   // 2. Provider (DI)
//   // lib/domain/usecases/save_profile_use_case_provider.dart
//   @Riverpod(keepAlive: true)
//   SaveProfileUseCase saveProfileUseCase(SaveProfileUseCaseRef ref) =>
//       SaveProfileUseCase(ref.watch(profileRepositoryProvider));
//
//   // 3. Uso en Notifier
//   // lib/features/profiles/notifiers/profiles_notifier.dart
//   final saveUseCase = ref.watch(saveProfileUseCaseProvider);
//   await saveUseCase.call(newProfile);
//   ```
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   flutter, riverpod, data, features, infrastructure.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato genérico para todos los casos de uso del dominio.
///
/// [Input]  — tipo del parámetro de entrada. Usar [void] si no hay parámetros.
/// [Output] — tipo del resultado. Generalmente el tipo de dominio o [void].
///
/// Convención: el único método público es [call()], que permite invocar el
/// use case directamente como función: `await useCase(params)`.
abstract interface class IUseCase<Input, Output> {
  Future<Output> call(Input input);
}
