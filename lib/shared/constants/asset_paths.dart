// ─────────────────────────────────────────────────────────────────────────────
// shared/constants/asset_paths.dart
//
// RESPONSABILIDAD:
//   Define todos los paths de assets del proyecto como constantes.
//   NUNCA se escribe un path de asset como string literal en los widgets.
//   Siempre se usa la constante de este archivo.
//
// ORGANIZACIÓN:
//   Sigue exactamente la estructura de carpetas de /assets/
//   definida en el Documento de Arquitectura de Datos.
//
// CONVENCIÓN DE NOMBRES:
//   Prefijo del tipo:  img_, audio_, anim_, font_
//   Snake_case completo con el path completo como sufijo descriptivo.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, librerías, features, core.
// ─────────────────────────────────────────────────────────────────────────────

/// Paths de todos los assets del videojuego Jardín del Edén.
abstract final class AssetPaths {
  static const String _base = 'assets';

  // ── Core: Assets presentes en el bundle inicial ───────────────────────────

  // Logos
  static const String imgLogoFull = '$_base/core/images/logos/logo_full.webp';
  static const String imgLogoIcon = '$_base/core/images/logos/logo_icon.webp';
  static const String imgLogoWhite =
      '$_base/core/images/logos/logo_white.webp';

  // Fondos globales
  static const String imgBgMenuMain =
      '$_base/core/images/backgrounds/bg_menu_main.webp';
  static const String imgBgProfileSelect =
      '$_base/core/images/backgrounds/bg_profile_select.webp';

  // UI global
  static const String imgCoinLuz = '$_base/core/images/ui/coin_luz.webp';
  static const String imgCoinSabiduria =
      '$_base/core/images/ui/coin_sabiduria.webp';
  static const String imgCoinJordan = '$_base/core/images/ui/coin_jordan.webp';
  static const String imgCoinAbraam = '$_base/core/images/ui/coin_abraam.webp';

  // Audio del menú principal
  static const String audioMusicMainMenu =
      '$_base/core/audio/music/main_menu/main_theme.ogg';
  static const String audioSfxButtonTap =
      '$_base/core/audio/sfx/button_tap.ogg';
  static const String audioSfxCoinCollect =
      '$_base/core/audio/sfx/coin_collect.ogg';
  static const String audioSfxSuccess = '$_base/core/audio/sfx/success.ogg';
  static const String audioSfxError = '$_base/core/audio/sfx/error.ogg';
  static const String audioSfxLevelUp = '$_base/core/audio/sfx/level_up.ogg';
  static const String audioSfxPageTurn =
      '$_base/core/audio/sfx/page_turn.ogg';

  // Animaciones Lottie globales de UI
  static const String animLoadingGarden =
      '$_base/core/animations/lottie/loading_garden.json';
  static const String animSuccessCelebration =
      '$_base/core/animations/lottie/success_celebration.json';
  static const String animCoinBurst =
      '$_base/core/animations/lottie/coin_burst.json';

  // ── Mundos ────────────────────────────────────────────────────────────────

  /// Genera el path del thumbnail de un mundo.
  /// [worldNumber]: número de mundo con padding (ej: '001', '002')
  static String imgWorldThumbnail(String worldNumber) =>
      '$_base/worlds/world_$worldNumber/images/thumbnail.webp';

  /// Genera el path del fondo del mapa de un mundo.
  static String imgWorldMapBackground(String worldNumber) =>
      '$_base/worlds/world_$worldNumber/images/map_background.webp';

  /// Genera el path de la música ambiental de un mundo.
  static String audioWorldAmbient(String worldNumber, {String lang = 'es'}) =>
      '$_base/worlds/world_$worldNumber/audio/$lang/ambient_loop.ogg';

  // ── Personajes ────────────────────────────────────────────────────────────

  /// Genera el path de la imagen de perfil de un personaje.
  static String imgCharacterAvatar(String characterId) =>
      '$_base/characters/$characterId/avatar.webp';

  /// Genera el path del sprite Spine de un personaje.
  static String animCharacterSpine(String characterId) =>
      '$_base/characters/$characterId/sprite.skel';

  // ── Personajes específicos (para evitar typos) ────────────────────────────

  static const String imgTobiasAvatar =
      '$_base/characters/tobias/avatar.webp';
  static const String imgLumiAvatar = '$_base/characters/lumi/avatar.webp';
  static const String imgNoahAvatar = '$_base/characters/noah/avatar.webp';
  static const String imgAdamAvatar = '$_base/characters/adam/avatar.webp';
  static const String imgEveAvatar = '$_base/characters/eve/avatar.webp';
  static const String imgAbrahamAvatar =
      '$_base/characters/abraham/avatar.webp';
  static const String imgMosesAvatar = '$_base/characters/moses/avatar.webp';
  static const String imgDavidAvatar = '$_base/characters/david/avatar.webp';
  static const String imgEstherAvatar = '$_base/characters/esther/avatar.webp';
  static const String imgDanielAvatar = '$_base/characters/daniel/avatar.webp';
  static const String imgJonahAvatar = '$_base/characters/jonah/avatar.webp';
  static const String imgJesusAvatar = '$_base/characters/jesus/avatar.webp';
  static const String imgPeterAvatar = '$_base/characters/peter/avatar.webp';
  static const String imgPaulAvatar = '$_base/characters/paul/avatar.webp';
}
