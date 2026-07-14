// ─────────────────────────────────────────────────────────────────────────────
// features/auth/data/models/player_profile_model.dart
//
// CAPA:          Data
// RESPONSABILIDAD:
//   Modelo de datos que hace el puente entre la base de datos (Drift) y
//   la entidad de dominio PlayerProfileEntity.
//   Sabe cómo serializar/deserializar desde y hacia la capa de persistencia.
//
// REGLAS DE LOS MODELS:
//   - Un modelo puede depender de su entidad de dominio correspondiente.
//   - Implementa fromMap() (desde DB) y toMap() (hacia DB).
//   - Implementa toEntity() para convertir al tipo puro del dominio.
//   - NO contiene lógica de negocio (eso es del domain).
//   - Los campos nulos se manejan con valores por defecto explícitos.
//
// DEPENDENCIAS PERMITIDAS:
//   - dart:core.
//   - La entity correspondiente del domain layer.
//
// DEPENDENCIAS PROHIBIDAS:
//   - Flutter, librerías ORM directas en el modelo (la relación con Drift
//     se maneja en el DataSource, no en el Model).
//   - presentation layer, otros features.
//
// PATRÓN DE REFERENCIA:
//   Este archivo es el ejemplo canónico de Model en este proyecto.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/features/auth/domain/entities/player_profile_entity.dart';

/// Modelo de datos para persistencia del perfil de jugador.
///
/// Responsable de la serialización/deserialización hacia la base de datos.
final class PlayerProfileModel {
  const PlayerProfileModel({
    required this.id,
    required this.name,
    required this.age,
    required this.ageTierIndex,
    required this.avatarId,
    required this.createdAt,
    required this.lastActiveAt,
    required this.seedsOfLight,
    required this.scrollsOfWisdom,
    required this.stonesOfJordan,
    required this.starsOfAbraam,
    required this.totalLuzEarnedToday,
    required this.currentStreak,
    required this.longestStreak,
    required this.hasParentPin,
    required this.isActive,
  });

  // ── Identificadores ───────────────────────────────────────────────────────
  final String id;
  final String name;
  final int age;

  /// Índice del enum AgeTier almacenado como INTEGER en la DB.
  /// 0 = querubin, 1 = discipulo, 2 = apostol
  final int ageTierIndex;
  final String avatarId;

  // ── Timestamps (almacenados como string ISO 8601 UTC) ─────────────────────
  final String createdAt;
  final String lastActiveAt;

  // ── Monedas ───────────────────────────────────────────────────────────────
  final int seedsOfLight;
  final int scrollsOfWisdom;
  final int stonesOfJordan;
  final int starsOfAbraam;
  final int totalLuzEarnedToday;

  // ── Progreso ──────────────────────────────────────────────────────────────
  final int currentStreak;
  final int longestStreak;

  // ── Flags ─────────────────────────────────────────────────────────────────
  final int hasParentPin; // 0 = false, 1 = true (SQLite no tiene BOOLEAN)
  final int isActive; // 0 = false, 1 = true

  // ── Deserialización (DB → Model) ──────────────────────────────────────────

  /// Construye el modelo desde un Map de la base de datos.
  factory PlayerProfileModel.fromMap(Map<String, dynamic> map) =>
      PlayerProfileModel(
        id: map['id'] as String,
        name: map['name'] as String,
        age: map['age'] as int,
        ageTierIndex: map['age_tier_index'] as int,
        avatarId: map['avatar_id'] as String,
        createdAt: map['created_at'] as String,
        lastActiveAt: map['last_active_at'] as String,
        seedsOfLight: map['seeds_of_light'] as int? ?? 0,
        scrollsOfWisdom: map['scrolls_of_wisdom'] as int? ?? 0,
        stonesOfJordan: map['stones_of_jordan'] as int? ?? 0,
        starsOfAbraam: map['stars_of_abraam'] as int? ?? 0,
        totalLuzEarnedToday: map['total_luz_earned_today'] as int? ?? 0,
        currentStreak: map['current_streak'] as int? ?? 0,
        longestStreak: map['longest_streak'] as int? ?? 0,
        hasParentPin: map['has_parent_pin'] as int? ?? 0,
        isActive: map['is_active'] as int? ?? 1,
      );

  // ── Serialización (Model → DB) ────────────────────────────────────────────

  /// Convierte el modelo a un Map para insertar/actualizar en la base de datos.
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'age': age,
    'age_tier_index': ageTierIndex,
    'avatar_id': avatarId,
    'created_at': createdAt,
    'last_active_at': lastActiveAt,
    'seeds_of_light': seedsOfLight,
    'scrolls_of_wisdom': scrollsOfWisdom,
    'stones_of_jordan': stonesOfJordan,
    'stars_of_abraam': starsOfAbraam,
    'total_luz_earned_today': totalLuzEarnedToday,
    'current_streak': currentStreak,
    'longest_streak': longestStreak,
    'has_parent_pin': hasParentPin,
    'is_active': isActive,
  };

  // ── Conversión hacia el Domain ────────────────────────────────────────────

  /// Convierte el modelo a la entidad de dominio pura.
  PlayerProfileEntity toEntity() => PlayerProfileEntity(
    id: id,
    name: name,
    age: age,
    ageTier: AgeTier.values[ageTierIndex],
    avatarId: avatarId,
    createdAt: DateTime.parse(createdAt),
    lastActiveAt: DateTime.parse(lastActiveAt),
    seedsOfLight: seedsOfLight,
    scrollsOfWisdom: scrollsOfWisdom,
    stonesOfJordan: stonesOfJordan,
    starsOfAbraam: starsOfAbraam,
    totalLuzEarnedToday: totalLuzEarnedToday,
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    hasParentPin: hasParentPin == 1,
    isActive: isActive == 1,
  );

  // ── Conversión desde el Domain ────────────────────────────────────────────

  /// Construye el modelo desde una entidad de dominio.
  factory PlayerProfileModel.fromEntity(PlayerProfileEntity entity) =>
      PlayerProfileModel(
        id: entity.id,
        name: entity.name,
        age: entity.age,
        ageTierIndex: entity.ageTier.index,
        avatarId: entity.avatarId,
        createdAt: entity.createdAt.toUtc().toIso8601String(),
        lastActiveAt: entity.lastActiveAt.toUtc().toIso8601String(),
        seedsOfLight: entity.seedsOfLight,
        scrollsOfWisdom: entity.scrollsOfWisdom,
        stonesOfJordan: entity.stonesOfJordan,
        starsOfAbraam: entity.starsOfAbraam,
        totalLuzEarnedToday: entity.totalLuzEarnedToday,
        currentStreak: entity.currentStreak,
        longestStreak: entity.longestStreak,
        hasParentPin: entity.hasParentPin ? 1 : 0,
        isActive: entity.isActive ? 1 : 0,
      );
}
