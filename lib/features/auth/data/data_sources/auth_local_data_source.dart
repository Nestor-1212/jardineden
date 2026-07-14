// ─────────────────────────────────────────────────────────────────────────────
// features/auth/data/data_sources/auth_local_data_source.dart
//
// CAPA:          Data → DataSource
// RESPONSABILIDAD:
//   Fuente de datos local para el feature de autenticación.
//   Interactúa directamente con la base de datos (Drift/SQLite).
//   Encapsula todas las queries SQL del feature auth.
//
// REGLAS DE LOS DATA SOURCES:
//   - La única capa que habla directamente con la DB o APIs externas.
//   - Retorna Models (nunca Entities directamente).
//   - Lanza AppException en caso de error (el repositorio las captura).
//   - No tiene lógica de negocio.
//
// DEPENDENCIAS PERMITIDAS:
//   - dart:core.
//   - core/database/ (AppDatabase — cuando Drift esté instalado en Sprint 03).
//   - core/error/ (AppException).
//   - data/models/ del mismo feature.
//
// DEPENDENCIAS PROHIBIDAS:
//   - domain layer, presentation layer, otros features.
//   - Flutter UI (material.dart, etc.).
//
// STUB:
//   La implementación real requiere Drift (Sprint 03).
//   Este stub define el contrato y documenta el patrón.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/error/app_exception.dart';
import 'package:jardindeleden/core/error/result.dart';
import 'package:jardindeleden/features/auth/data/models/player_profile_model.dart';

/// Contrato del data source local del feature auth.
abstract interface class IAuthLocalDataSource {
  /// Retorna todos los perfiles (isActive = 1) ordenados por lastActiveAt DESC.
  Future<Result<List<PlayerProfileModel>, DatabaseException>> getAllProfiles();

  /// Retorna el perfil con el [id] dado.
  Future<Result<PlayerProfileModel, DatabaseException>> getProfileById(
    String id,
  );

  /// Inserta un nuevo perfil. Falla si ya existe un perfil con el mismo id.
  Future<Result<void, DatabaseException>> insertProfile(
    PlayerProfileModel model,
  );

  /// Actualiza todos los campos de un perfil existente.
  Future<Result<void, DatabaseException>> updateProfile(
    PlayerProfileModel model,
  );

  /// Soft delete: pone isActive = 0 en el perfil con el [id] dado.
  Future<Result<void, DatabaseException>> softDeleteProfile(String id);

  /// Guarda el hash bcrypt del PIN en secure storage.
  ///
  /// La key en secure storage es: 'jde_pin_${profileId}'
  Future<Result<void, DatabaseException>> savePinHash(
    String profileId,
    String hash,
  );

  /// Recupera el hash bcrypt del PIN de secure storage.
  Future<Result<String?, DatabaseException>> getPinHash(String profileId);

  /// Elimina el hash del PIN de secure storage.
  Future<Result<void, DatabaseException>> deletePinHash(String profileId);
}

// ── Implementación (stub — se completa en Sprint 03 con Drift) ───────────────

/// Implementación del data source local que usa Drift + SQLCipher.
///
/// TODO (Sprint 03): Inyectar AppDatabase vía constructor.
///                   Reemplazar el TODO body con queries Drift reales.
///                   Inyectar FlutterSecureStorage para el PIN hash.
final class AuthLocalDataSource implements IAuthLocalDataSource {
  const AuthLocalDataSource();

  @override
  Future<Result<List<PlayerProfileModel>, DatabaseException>>
  getAllProfiles() async {
    // TODO(sprint-03): return (await _db.authDao.getAllProfiles())
    //     .map(PlayerProfileModel.fromDrift)
    //     .toList();
    throw UnimplementedError('Implementar en Sprint 03 con Drift');
  }

  @override
  Future<Result<PlayerProfileModel, DatabaseException>> getProfileById(
    String id,
  ) async {
    throw UnimplementedError('Implementar en Sprint 03 con Drift');
  }

  @override
  Future<Result<void, DatabaseException>> insertProfile(
    PlayerProfileModel model,
  ) async {
    throw UnimplementedError('Implementar en Sprint 03 con Drift');
  }

  @override
  Future<Result<void, DatabaseException>> updateProfile(
    PlayerProfileModel model,
  ) async {
    throw UnimplementedError('Implementar en Sprint 03 con Drift');
  }

  @override
  Future<Result<void, DatabaseException>> softDeleteProfile(String id) async {
    throw UnimplementedError('Implementar en Sprint 03 con Drift');
  }

  @override
  Future<Result<void, DatabaseException>> savePinHash(
    String profileId,
    String hash,
  ) async {
    throw UnimplementedError(
      'Implementar en Sprint 03 con flutter_secure_storage',
    );
  }

  @override
  Future<Result<String?, DatabaseException>> getPinHash(
    String profileId,
  ) async {
    throw UnimplementedError(
      'Implementar en Sprint 03 con flutter_secure_storage',
    );
  }

  @override
  Future<Result<void, DatabaseException>> deletePinHash(
    String profileId,
  ) async {
    throw UnimplementedError(
      'Implementar en Sprint 03 con flutter_secure_storage',
    );
  }
}
