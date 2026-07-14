// ─────────────────────────────────────────────────────────────────────────────
// features/auth/domain/use_cases/create_profile_use_case.dart
//
// CAPA:          Domain
// RESPONSABILIDAD:
//   Caso de uso que encapsula toda la lógica de negocio para crear un perfil.
//   Orquesta las validaciones de dominio y delega la persistencia al repositorio.
//
// REGLAS DE LOS USE CASES:
//   - Un use case = una sola acción de negocio.
//   - Son invocables (implementan call()) para máxima ergonomía con Riverpod.
//   - Reciben dependencias por constructor (inyectadas vía Riverpod).
//   - Dependen del contrato IRepository, nunca de la implementación.
//   - Toda validación de negocio ocurre aquí, no en los widgets.
//
// DEPENDENCIAS PERMITIDAS:
//   - Contrato IAuthRepository (del mismo domain/repositories/).
//   - Entities del mismo domain/entities/.
//   - core/error/ (AppException, Result).
//   - dart:core.
//
// DEPENDENCIAS PROHIBIDAS:
//   - Flutter, widgets, providers de Riverpod, librerías externas.
//   - Data layer, presentation layer, otros features.
//
// PATRÓN DE REFERENCIA:
//   Este archivo es el ejemplo canónico de UseCase en este proyecto.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/error/app_exception.dart';
import 'package:jardindeleden/core/error/result.dart';
import 'package:jardindeleden/features/auth/domain/entities/player_profile_entity.dart';
import 'package:jardindeleden/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:jardindeleden/shared/constants/app_constants.dart';

/// Parámetros requeridos para crear un nuevo perfil de jugador.
final class CreateProfileParams {
  const CreateProfileParams({
    required this.name,
    required this.age,
    required this.avatarId,
  });

  final String name;
  final int age;
  final String avatarId;
}

/// Caso de uso: crear un nuevo perfil de jugador.
///
/// Valida las reglas de negocio y delega la persistencia al repositorio.
final class CreateProfileUseCase {
  const CreateProfileUseCase(this._repository);

  final IAuthRepository _repository;

  /// Ejecuta el caso de uso.
  ///
  /// Valida que no se exceda el límite de perfiles y que los datos sean
  /// correctos antes de persistir.
  Future<Result<PlayerProfileEntity, AppException>> call(
    CreateProfileParams params,
  ) async {
    // 1. Verificar que no se exceda el límite de perfiles del dispositivo.
    final profilesResult = await _repository.getAllProfiles();
    if (profilesResult.isFailure) {
      return Failure(profilesResult.asFailure.error);
    }
    final profiles = profilesResult.asSuccess.value;
    if (profiles.length >= AppConstants.maxProfilesPerDevice) {
      return const Failure(
        MaxProfilesReachedException(
          message: 'Límite de 5 perfiles por dispositivo alcanzado',
        ),
      );
    }

    // 2. Determinar el nivel de edad.
    final ageTier = _resolveAgeTier(params.age);

    // 3. Construir la entidad con valores iniciales.
    final now = DateTime.now().toUtc();
    // UUID v7 real se generará cuando el paquete uuid esté instalado (Sprint 03).
    // Por ahora, este stub documenta la intención.
    const placeholderUuid = '00000000-0000-7000-0000-000000000000';

    final newProfile = PlayerProfileEntity(
      id: placeholderUuid,
      name: params.name.trim(),
      age: params.age,
      ageTier: ageTier,
      avatarId: params.avatarId,
      createdAt: now,
      lastActiveAt: now,
      seedsOfLight: 0,
      scrollsOfWisdom: 0,
      stonesOfJordan: 0,
      starsOfAbraam: 0,
      totalLuzEarnedToday: 0,
      currentStreak: 0,
      longestStreak: 0,
      hasParentPin: false,
      isActive: true,
    );

    // 4. Persistir vía repositorio.
    return _repository.createProfile(newProfile);
  }

  AgeTier _resolveAgeTier(int age) {
    if (age <= AppConstants.ageMaxQuerubin) return AgeTier.querubin;
    if (age <= AppConstants.ageMaxDiscipulo) return AgeTier.discipulo;
    return AgeTier.apostol;
  }
}
