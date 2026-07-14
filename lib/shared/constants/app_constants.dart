// ─────────────────────────────────────────────────────────────────────────────
// shared/constants/app_constants.dart
//
// RESPONSABILIDAD:
//   Constantes del dominio de negocio del videojuego.
//   Valores que definen las reglas del juego y que se usan en múltiples
//   features. Si una constante solo la usa una feature, vive en esa feature.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, librerías, features, core.
// ─────────────────────────────────────────────────────────────────────────────

/// Constantes globales del dominio de negocio de Jardín del Edén.
abstract final class AppConstants {
  // ── Sistema de Niveles de Edad ────────────────────────────────────────────

  /// Nombre del nivel para jugadores de 4-6 años.
  static const String levelQuerubin = 'Querubín';

  /// Nombre del nivel para jugadores de 7-9 años.
  static const String levelDiscipulo = 'Discípulo';

  /// Nombre del nivel para jugadores de 10-12 años.
  static const String levelApostol = 'Apóstol';

  /// Edad mínima para el nivel Querubín.
  static const int ageMinQuerubin = 4;

  /// Edad máxima para el nivel Querubín.
  static const int ageMaxQuerubin = 6;

  /// Edad mínima para el nivel Discípulo.
  static const int ageMinDiscipulo = 7;

  /// Edad máxima para el nivel Discípulo.
  static const int ageMaxDiscipulo = 9;

  /// Edad mínima para el nivel Apóstol.
  static const int ageMinApostol = 10;

  /// Edad máxima para el nivel Apóstol.
  static const int ageMaxApostol = 12;

  // ── Límites de Luz (XP) por Día ──────────────────────────────────────────

  /// Máximo de Luz que un jugador Querubín (4-6) puede ganar por día.
  static const int dailyLuzCeilingQuerubin = 300;

  /// Máximo de Luz que un jugador Discípulo (7-9) puede ganar por día.
  static const int dailyLuzCeilingDiscipulo = 500;

  /// Máximo de Luz que un jugador Apóstol (10-12) puede ganar por día.
  static const int dailyLuzCeilingApostol = 750;

  // ── Sistema Vinculum (Relación con Personajes) ────────────────────────────

  /// Nivel mínimo de Vinculum (sin relación establecida).
  static const int vinculumMin = 0;

  /// Nivel máximo de Vinculum (relación profunda con el personaje).
  static const int vinculumMax = 5;

  // ── Sistema 44 (Repetición Espaciada) ────────────────────────────────────

  /// Intervalos de revisión del Sistema 44 en horas.
  /// Índice = nivel de retención (0=nuevo, 4=dominado).
  static const List<int> sistema44IntervalsHours = [24, 72, 168, 336, 720];

  /// Nombre del estado máximo de memorización de un versículo.
  static const String grabadoEnElCorazon = 'Grabado en el Corazón';

  // ── Sistema de Monedas ────────────────────────────────────────────────────

  /// Nombre de la moneda principal (XP).
  static const String currencyLuz = 'Semillas de Luz';

  /// Nombre de la moneda de conocimiento bíblico.
  static const String currencySabiduria = 'Pergaminos de Sabiduría';

  /// Nombre de la moneda de aventura.
  static const String currencyJordan = 'Piedras del Jordán';

  /// Nombre de la moneda de fe.
  static const String currencyAbraam = 'Estrellas de Abraam';

  // ── Sistema de Rarezas ────────────────────────────────────────────────────

  /// Las 6 rarezas del sistema de ítems, en orden ascendente de valor.
  static const List<String> rarityLevels = [
    'Barro',
    'Bronce',
    'Plata',
    'Oro',
    'Ónix',
    'Gloria',
  ];

  // ── Perfiles ──────────────────────────────────────────────────────────────

  /// Máximo de perfiles de jugador por dispositivo.
  static const int maxProfilesPerDevice = 5;

  /// Longitud mínima del nombre de un perfil.
  static const int profileNameMinLength = 2;

  /// Longitud máxima del nombre de un perfil.
  static const int profileNameMaxLength = 20;

  // ── PIN del Panel de Padres ───────────────────────────────────────────────

  /// Longitud fija del PIN parental (4 dígitos numéricos).
  static const int parentPinLength = 4;

  /// Máximo de intentos fallidos antes del primer bloqueo temporal.
  static const int parentPinMaxAttempts = 3;

  // ── Contenido ─────────────────────────────────────────────────────────────

  /// Número total de mundos en el juego completo.
  static const int totalWorlds = 10;

  /// Número de capítulos por mundo.
  static const int chaptersPerWorld = 10;

  // ── Referencia Bíblica ────────────────────────────────────────────────────

  /// Nombre oficial de la versión bíblica usada en el proyecto.
  static const String biblicalVersion = 'Reina-Valera 2000';

  /// Abreviatura de la versión bíblica.
  static const String biblicalVersionShort = 'RVR2000';
}
