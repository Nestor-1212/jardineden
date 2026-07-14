// ─────────────────────────────────────────────────────────────────────────────
// features/auth/domain/entities/player_profile_entity.dart
//
// CAPA:          Domain
// RESPONSABILIDAD:
//   Entidad pura que representa el perfil de un jugador en el sistema.
//   Es el objeto central de la identidad del jugador y contiene su estado
//   de progreso global (nivel de edad, monedas, racha).
//
// REGLAS DE LA CAPA DOMAIN:
//   - Sin imports de Flutter (ni material.dart ni widgets).
//   - Sin imports de librerías externas (solo dart:core).
//   - Sin lógica de persistencia (ni SQL, ni JSON, ni SharedPreferences).
//   - Solo contiene la verdad del negocio, no cómo se almacena o muestra.
//   - Inmutable: todos los campos son final.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, otros entities del mismo feature.
// DEPENDENCIAS PROHIBIDAS:   Flutter, libs, data layer, presentation layer,
//                            core (excepto error/result), otros features.
//
// PATRÓN DE REFERENCIA:
//   Este archivo es el ejemplo canónico de cómo debe verse una Entity en
//   este proyecto. Todos los features deben seguir exactamente esta estructura.
// ─────────────────────────────────────────────────────────────────────────────

/// Nivel de edad que determina la dificultad y límites del juego.
///
/// Querubín  → 4-6 años  → 300  Luz/día
/// Discípulo → 7-9 años  → 500  Luz/día
/// Apóstol   → 10-12 años → 750 Luz/día
enum AgeTier { querubin, discipulo, apostol }

/// Entidad de dominio que representa el perfil de un jugador del juego.
///
/// No contiene lógica de UI ni de persistencia. Solo el estado del negocio.
final class PlayerProfileEntity {
  const PlayerProfileEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.ageTier,
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

  /// UUID v7 — identificador único del perfil, generado en el cliente.
  final String id;

  /// Nombre del jugador (2-20 caracteres, validado por InputValidators).
  final String name;

  /// Edad del jugador en años (4-12).
  final int age;

  /// Nivel de edad calculado a partir de [age].
  final AgeTier ageTier;

  /// ID del avatar seleccionado por el jugador.
  final String avatarId;

  /// Timestamp UTC de creación del perfil.
  final DateTime createdAt;

  /// Timestamp UTC de la última sesión activa.
  final DateTime lastActiveAt;

  // ── Monedas ───────────────────────────────────────────────────────────────

  /// Semillas de Luz (XP principal del juego). Sujeto al límite diario.
  final int seedsOfLight;

  /// Pergaminos de Sabiduría (conocimiento bíblico).
  final int scrollsOfWisdom;

  /// Piedras del Jordán (moneda de aventura).
  final int stonesOfJordan;

  /// Estrellas de Abraam (moneda de fe).
  final int starsOfAbraam;

  // ── Progreso del Día ──────────────────────────────────────────────────────

  /// Total de Luz ganada en el día de hoy.
  /// Se compara con [AgeTier] para aplicar el techo diario.
  final int totalLuzEarnedToday;

  // ── Rachas ────────────────────────────────────────────────────────────────

  /// Días consecutivos de sesión activa.
  final int currentStreak;

  /// Racha más larga histórica.
  final int longestStreak;

  // ── Seguridad y Estado ────────────────────────────────────────────────────

  /// true si el padre configuró un PIN para este perfil.
  final bool hasParentPin;

  /// false si el perfil fue desactivado (soft delete).
  final bool isActive;

  // ── Lógica de Negocio de Solo Lectura ────────────────────────────────────

  /// Retorna el límite diario de Luz para este perfil según su [ageTier].
  int get dailyLuzCeiling => switch (ageTier) {
    AgeTier.querubin => 300,
    AgeTier.discipulo => 500,
    AgeTier.apostol => 750,
  };

  /// true si el jugador alcanzó el techo de Luz de hoy.
  bool get hasReachedDailyLuzCeiling => totalLuzEarnedToday >= dailyLuzCeiling;

  /// Cuánta Luz puede ganar todavía hoy.
  int get remainingLuzToday =>
      (dailyLuzCeiling - totalLuzEarnedToday).clamp(0, dailyLuzCeiling);

  // ── Inmutabilidad / copyWith ──────────────────────────────────────────────

  /// Crea una copia del perfil con campos actualizados.
  ///
  /// El patrón copyWith es el único mecanismo permitido para "modificar"
  /// una entidad. Las entidades nunca se mutan in-place.
  PlayerProfileEntity copyWith({
    String? id,
    String? name,
    int? age,
    AgeTier? ageTier,
    String? avatarId,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    int? seedsOfLight,
    int? scrollsOfWisdom,
    int? stonesOfJordan,
    int? starsOfAbraam,
    int? totalLuzEarnedToday,
    int? currentStreak,
    int? longestStreak,
    bool? hasParentPin,
    bool? isActive,
  }) => PlayerProfileEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    ageTier: ageTier ?? this.ageTier,
    avatarId: avatarId ?? this.avatarId,
    createdAt: createdAt ?? this.createdAt,
    lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    seedsOfLight: seedsOfLight ?? this.seedsOfLight,
    scrollsOfWisdom: scrollsOfWisdom ?? this.scrollsOfWisdom,
    stonesOfJordan: stonesOfJordan ?? this.stonesOfJordan,
    starsOfAbraam: starsOfAbraam ?? this.starsOfAbraam,
    totalLuzEarnedToday: totalLuzEarnedToday ?? this.totalLuzEarnedToday,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    hasParentPin: hasParentPin ?? this.hasParentPin,
    isActive: isActive ?? this.isActive,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerProfileEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlayerProfileEntity(id: $id, name: $name, age: $age)';
}
