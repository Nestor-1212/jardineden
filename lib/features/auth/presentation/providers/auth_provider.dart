// ─────────────────────────────────────────────────────────────────────────────
// features/auth/presentation/providers/auth_provider.dart
//
// CAPA:          Presentation → Providers
// RESPONSABILIDAD:
//   Providers de Riverpod que exponen el estado de autenticación a los widgets.
//   Conectan la capa de presentación con los Use Cases del domain.
//   Manejan el estado de carga, éxito y error mediante AsyncValue.
//
// REGLAS DE LOS PROVIDERS:
//   - Solo dependen de Use Cases (nunca de Repositories directamente).
//   - Usan inject() pattern de Riverpod para recibir dependencias.
//   - El estado es AsyncValue<T> para manejar loading/data/error.
//   - Los providers son ref.watch-able (reactivos).
//   - Nunca contienen lógica de negocio (eso es del domain).
//
// DEPENDENCIAS PERMITIDAS:
//   - flutter_riverpod (cuando se instale en Sprint 03).
//   - domain/entities/ del mismo feature.
//   - domain/use_cases/ del mismo feature.
//   - core/error/ (AppException, Result).
//   - Flutter (dart:ui para BuildContext si es necesario).
//
// DEPENDENCIAS PROHIBIDAS:
//   - Data layer directamente, otros features.
//
// STUB:
//   Este archivo documenta el patrón de providers.
//   La implementación real requiere flutter_riverpod (Sprint 03).
//
// PATRÓN DE REFERENCIA:
//   Este archivo es el ejemplo canónico de Provider en este proyecto.
// ─────────────────────────────────────────────────────────────────────────────

// IMPLEMENTACIÓN PENDIENTE SPRINT 03
//
// Cuando flutter_riverpod esté instalado, este archivo contendrá:
//
// ── Notifier del perfil activo ────────────────────────────────────────────────
//
// @riverpod
// class ActiveProfile extends _$ActiveProfile {
//   @override
//   Future<PlayerProfileEntity?> build() async {
//     final useCase = ref.watch(getActiveProfileUseCaseProvider);
//     final result = await useCase();
//     return result.fold(onSuccess: (p) => p, onFailure: (_) => null);
//   }
// }
//
// ── Notifier de lista de perfiles ─────────────────────────────────────────────
//
// @riverpod
// class ProfileList extends _$ProfileList {
//   @override
//   Future<List<PlayerProfileEntity>> build() async {
//     final useCase = ref.watch(getAllProfilesUseCaseProvider);
//     final result = await useCase();
//     return result.fold(
//       onSuccess: (profiles) => profiles,
//       onFailure: (e) => throw e,
//     );
//   }
//
//   Future<void> createProfile(CreateProfileParams params) async {
//     state = const AsyncLoading();
//     final useCase = ref.read(createProfileUseCaseProvider);
//     final result = await useCase(params);
//     result.fold(
//       onSuccess: (_) => ref.invalidateSelf(),
//       onFailure: (e) => state = AsyncError(e, StackTrace.current),
//     );
//   }
//
//   Future<void> selectProfile(String profileId) async {
//     final useCase = ref.read(selectProfileUseCaseProvider);
//     await useCase(profileId);
//     ref.invalidate(activeProfileProvider);
//   }
// }
//
// ── Providers de Use Cases (para DI via Riverpod) ─────────────────────────────
//
// @riverpod
// CreateProfileUseCase createProfileUseCase(Ref ref) =>
//     CreateProfileUseCase(ref.watch(authRepositoryProvider));
//
// @riverpod
// IAuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
//       localDataSource: ref.watch(authLocalDataSourceProvider),
//       securityService: ref.watch(securityServiceProvider),
//       preferencesService: ref.watch(preferencesServiceProvider),
//     );
//
// ── Estado de PIN parental ─────────────────────────────────────────────────────
//
// @riverpod
// class ParentPinState extends _$ParentPinState {
//   @override
//   int build() => 0; // número de intentos fallidos actuales
//
//   Future<bool> verify(String profileId, String pin) async { ... }
// }

// Este placeholder existe para que el archivo sea válido en Dart.
// Se reemplazará completamente en Sprint 03.
