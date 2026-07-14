// ─────────────────────────────────────────────────────────────────────────────
// features/auth/data/repositories/auth_repository_impl.dart
//
// CAPA:          Data → Repositories
// RESPONSABILIDAD:
//   Implementación concreta del contrato IAuthRepository definido en el domain.
//   Orquesta las operaciones entre el DataSource y el SecurityService.
//   Convierte Models → Entities antes de retornar al domain.
//   Captura excepciones del DataSource y las envuelve en Result<S,F>.
//
// REGLAS DE LOS REPOSITORIES (implementación):
//   - Implementan un IRepository del domain.
//   - Dependen de DataSources (no de la DB directamente).
//   - Convierten entre Models (data) y Entities (domain).
//   - Nunca lanzan excepciones hacia arriba: todo se envuelve en Result.
//   - Pueden combinar múltiples DataSources (local + remoto).
//
// DEPENDENCIAS PERMITIDAS:
//   - dart:core.
//   - domain/repositories/i_auth_repository.dart (el contrato).
//   - domain/entities/ del mismo feature.
//   - core/error/ (AppException, Result).
//   - core/security/ (SecurityService — para hash de PIN).
//   - core/storage/ (PreferencesService — para activeProfileId).
//   - data/data_sources/ del mismo feature.
//   - data/models/ del mismo feature.
//
// DEPENDENCIAS PROHIBIDAS:
//   - Flutter UI, presentation layer, providers de Riverpod.
//   - Otros features.
//
// PATRÓN DE REFERENCIA:
//   Este archivo es el ejemplo canónico de RepositoryImpl en este proyecto.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/error/app_exception.dart';
import 'package:jardindeleden/core/error/result.dart';
import 'package:jardindeleden/core/security/security_service.dart';
import 'package:jardindeleden/core/storage/preferences_service.dart';
import 'package:jardindeleden/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:jardindeleden/features/auth/data/models/player_profile_model.dart';
import 'package:jardindeleden/features/auth/domain/entities/player_profile_entity.dart';
import 'package:jardindeleden/features/auth/domain/repositories/i_auth_repository.dart';

/// Implementación concreta de IAuthRepository.
///
/// Usa el DataSource local como fuente de verdad (Offline First).
final class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl({
    required IAuthLocalDataSource localDataSource,
    required SecurityService securityService,
    required PreferencesService preferencesService,
  })  : _localDataSource = localDataSource,
        _securityService = securityService,
        _preferencesService = preferencesService;

  final IAuthLocalDataSource _localDataSource;
  final SecurityService _securityService;
  final PreferencesService _preferencesService;

  @override
  Future<Result<List<PlayerProfileEntity>, DatabaseException>>
      getAllProfiles() async {
    final result = await _localDataSource.getAllProfiles();
    return result.fold(
      onSuccess: (models) => Success(models.map((m) => m.toEntity()).toList()),
      onFailure: (e) => Failure(e),
    );
  }

  @override
  Future<Result<PlayerProfileEntity, DatabaseException>> getProfileById(
    String id,
  ) async {
    final result = await _localDataSource.getProfileById(id);
    return result.fold(
      onSuccess: (model) => Success(model.toEntity()),
      onFailure: (e) => Failure(e),
    );
  }

  @override
  Future<Result<PlayerProfileEntity, AppException>> createProfile(
    PlayerProfileEntity profile,
  ) async {
    final model = PlayerProfileModel.fromEntity(profile);
    final result = await _localDataSource.insertProfile(model);
    return result.fold(
      onSuccess: (_) => Success(profile),
      onFailure: (e) => Failure(e),
    );
  }

  @override
  Future<Result<PlayerProfileEntity, DatabaseException>> updateProfile(
    PlayerProfileEntity profile,
  ) async {
    final model = PlayerProfileModel.fromEntity(profile);
    final result = await _localDataSource.updateProfile(model);
    return result.fold(
      onSuccess: (_) => Success(profile),
      onFailure: (e) => Failure(e),
    );
  }

  @override
  Future<Result<void, DatabaseException>> deleteProfile(String id) =>
      _localDataSource.softDeleteProfile(id);

  @override
  Future<Result<String?, DatabaseException>> getActiveProfileId() async {
    try {
      final id = await _preferencesService.getActiveProfileId();
      return Success(id);
    } catch (e) {
      return Failure(
        DatabaseReadException(
          message: 'Error leyendo activeProfileId desde SharedPreferences',
          cause: e,
        ),
      );
    }
  }

  @override
  Future<Result<void, DatabaseException>> setActiveProfileId(
    String? id,
  ) async {
    try {
      if (id == null) {
        await _preferencesService.clearActiveProfileId();
      } else {
        await _preferencesService.setActiveProfileId(id);
      }
      return const Success(null);
    } catch (e) {
      return Failure(
        DatabaseWriteException(
          message: 'Error guardando activeProfileId en SharedPreferences',
          cause: e,
        ),
      );
    }
  }

  @override
  Future<Result<void, SecurityException>> saveParentPinHash(
    String profileId,
    String pinHash,
  ) async {
    final result = await _localDataSource.savePinHash(profileId, pinHash);
    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (e) => Failure(
        EncryptionException(
          message: 'Error guardando hash de PIN para perfil $profileId',
          cause: e,
        ),
      ),
    );
  }

  @override
  Future<Result<bool, SecurityException>> verifyParentPin(
    String profileId,
    String inputPin,
  ) async {
    final hashResult = await _localDataSource.getPinHash(profileId);
    if (hashResult.isFailure) {
      return Failure(
        EncryptionException(
          message: 'Error leyendo hash de PIN para perfil $profileId',
          cause: hashResult.asFailure.error,
        ),
      );
    }
    final storedHash = hashResult.asSuccess.value;
    if (storedHash == null) return const Success(false);

    final isValid = await _securityService.verifyPin(inputPin, storedHash);
    return Success(isValid);
  }

  @override
  Future<Result<void, SecurityException>> removeParentPin(
    String profileId,
  ) async {
    final result = await _localDataSource.deletePinHash(profileId);
    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (e) => Failure(
        EncryptionException(
          message: 'Error eliminando hash de PIN para perfil $profileId',
          cause: e,
        ),
      ),
    );
  }
}
