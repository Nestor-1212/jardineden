// ─────────────────────────────────────────────────────────────────────────────
// features/auth/domain/repositories/i_auth_repository.dart
//
// CAPA:          Domain
// RESPONSABILIDAD:
//   Contrato (interface) del repositorio de autenticación y perfiles.
//   Define QUÉ puede hacer el repositorio, no CÓMO lo hace.
//   La implementación real vive en la capa Data.
//
// CONVENCIÓN DE NOMBRES:
//   Todos los contratos de repositorio llevan el prefijo 'I' (de Interface).
//   Esto distingue claramente el contrato de la implementación.
//
// REGLAS:
//   - Solo imports de: dart:core, entities del mismo domain, core/error.
//   - Todos los métodos retornan Future<Result<S,F>>.
//   - Nunca retornar null directamente: usar Result<S,F> en su lugar.
//   - El dominio no conoce detalles de la base de datos.
//
// PATRÓN DE REFERENCIA:
//   Este archivo es el ejemplo canónico de cómo debe verse un IRepository en
//   este proyecto. Todos los features deben seguir exactamente esta estructura.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/error/app_exception.dart';
import 'package:jardindeleden/core/error/result.dart';
import 'package:jardindeleden/features/auth/domain/entities/player_profile_entity.dart';

/// Contrato del repositorio de perfiles de jugador.
///
/// La capa de presentación y los use cases dependen de esta interface,
/// no de la implementación concreta. Esto permite tests con mocks.
abstract interface class IAuthRepository {
  // ── Perfiles ──────────────────────────────────────────────────────────────

  /// Retorna todos los perfiles activos del dispositivo.
  ///
  /// Máximo 5 perfiles por dispositivo (AppConstants.maxProfilesPerDevice).
  Future<Result<List<PlayerProfileEntity>, DatabaseException>> getAllProfiles();

  /// Retorna el perfil con el [id] dado.
  ///
  /// Falla con DatabaseException si el perfil no existe.
  Future<Result<PlayerProfileEntity, DatabaseException>> getProfileById(
    String id,
  );

  /// Crea un nuevo perfil y lo persiste localmente.
  ///
  /// Falla con DomainException si ya hay 5 perfiles en el dispositivo.
  Future<Result<PlayerProfileEntity, AppException>> createProfile(
    PlayerProfileEntity profile,
  );

  /// Actualiza los campos de un perfil existente.
  Future<Result<PlayerProfileEntity, DatabaseException>> updateProfile(
    PlayerProfileEntity profile,
  );

  /// Elimina un perfil (soft delete: isActive = false, 30-day grace period).
  Future<Result<void, DatabaseException>> deleteProfile(String id);

  // ── Sesión Activa ─────────────────────────────────────────────────────────

  /// Retorna el ID del perfil actualmente en sesión, o null si ninguno.
  Future<Result<String?, DatabaseException>> getActiveProfileId();

  /// Establece el perfil activo en SharedPreferences.
  Future<Result<void, DatabaseException>> setActiveProfileId(String? id);

  // ── PIN Parental ──────────────────────────────────────────────────────────

  /// Guarda el hash bcrypt del PIN parental para el [profileId] dado.
  Future<Result<void, SecurityException>> saveParentPinHash(
    String profileId,
    String pinHash,
  );

  /// Verifica si el PIN ingresado coincide con el hash almacenado.
  Future<Result<bool, SecurityException>> verifyParentPin(
    String profileId,
    String inputPin,
  );

  /// Elimina el PIN parental de un perfil.
  Future<Result<void, SecurityException>> removeParentPin(String profileId);
}
