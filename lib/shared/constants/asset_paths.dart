// ─────────────────────────────────────────────────────────────────────────────
// shared/constants/asset_paths.dart
//
// RESPONSABILIDAD:
//   Define todos los paths de assets del proyecto como constantes.
//   NUNCA se escribe un path de asset como string literal en los widgets.
//   Siempre se usa la constante de este archivo.
//
// ORGANIZACIÓN:
//   Sigue exactamente la estructura de carpetas de /assets/ documentada en
//   pubspec.yaml (sección ASSETS) — ver ese comentario para el porqué de
//   cada subcarpeta (images/icons/svg/audio/animations/videos).
//
// CONVENCIÓN DE NOMBRES:
//   Prefijo del tipo:  img_, svg_, audio_, anim_, font_
//   Snake_case completo (camelCase en Dart) con el path completo como
//   sufijo descriptivo.
//
// POR QUÉ LAS CONSTANTES APUNTAN A ARCHIVOS QUE TODAVÍA NO EXISTEN:
//   Igual que el resto del proyecto (ver core/config, core/theme): esta
//   clase declara el CONTRATO de dónde vivirá cada asset antes de que el
//   archivo real exista — el Sprint de contenido solo necesita colocar el
//   archivo en la ruta ya declarada, sin tocar código. Ningún archivo real
//   se referencia todavía desde pubspec.yaml (ver la regla de "Flutter
//   falla con directorios vacíos" documentada ahí).
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, librerías, features, core.
// ─────────────────────────────────────────────────────────────────────────────

/// Paths de todos los assets del videojuego Jardín del Edén.
abstract final class AssetPaths {
  static const String _base = 'assets';

  // ── Core: Imágenes ────────────────────────────────────────────────────────

  static const String imgLogoFull = '$_base/core/images/logos/logo_full.webp';
  static const String imgLogoIcon = '$_base/core/images/logos/logo_icon.webp';
  static const String imgLogoWhite = '$_base/core/images/logos/logo_white.webp';

  static const String imgBgMenuMain =
      '$_base/core/images/backgrounds/bg_menu_main.webp';
  static const String imgBgProfileSelect =
      '$_base/core/images/backgrounds/bg_profile_select.webp';

  static const String imgCoinLuz = '$_base/core/images/ui/coin_luz.webp';
  static const String imgCoinSabiduria =
      '$_base/core/images/ui/coin_sabiduria.webp';
  static const String imgCoinJordan = '$_base/core/images/ui/coin_jordan.webp';
  static const String imgCoinAbraam = '$_base/core/images/ui/coin_abraam.webp';

  // ── Core: Íconos Vectoriales (SVG) ────────────────────────────────────────
  //
  // Reemplazan gradualmente los placeholders de Material Icons documentados
  // en core/theme/app_icons.dart (buscar "PLACEHOLDER" en ese archivo) — la
  // constante de nombre en AppIcons no cambia cuando esto pase, solo su
  // implementación interna pasa de `Icon(Icons.x)` a `AppSvgIcon(AssetPaths.svgX)`.

  static const String svgIconCurrencyLuz =
      '$_base/core/icons/svg/currency_luz.svg';
  static const String svgIconCurrencySabiduria =
      '$_base/core/icons/svg/currency_sabiduria.svg';
  static const String svgIconCurrencyJordan =
      '$_base/core/icons/svg/currency_jordan.svg';
  static const String svgIconCurrencyAbraam =
      '$_base/core/icons/svg/currency_abraam.svg';

  static const String svgIconRarityBarro =
      '$_base/core/icons/svg/rarity_barro.svg';
  static const String svgIconRarityBronce =
      '$_base/core/icons/svg/rarity_bronce.svg';
  static const String svgIconRarityPlata =
      '$_base/core/icons/svg/rarity_plata.svg';
  static const String svgIconRarityOro = '$_base/core/icons/svg/rarity_oro.svg';
  static const String svgIconRarityOnix =
      '$_base/core/icons/svg/rarity_onix.svg';
  static const String svgIconRarityGloria =
      '$_base/core/icons/svg/rarity_gloria.svg';

  // ── Core: Audio ───────────────────────────────────────────────────────────

  static const String audioMusicMainMenu =
      '$_base/core/audio/music/main_menu/main_theme.ogg';
  static const String audioSfxButtonTap =
      '$_base/core/audio/sfx/button_tap.ogg';
  static const String audioSfxCoinCollect =
      '$_base/core/audio/sfx/coin_collect.ogg';
  static const String audioSfxSuccess = '$_base/core/audio/sfx/success.ogg';
  static const String audioSfxError = '$_base/core/audio/sfx/error.ogg';
  static const String audioSfxLevelUp = '$_base/core/audio/sfx/level_up.ogg';
  static const String audioSfxPageTurn = '$_base/core/audio/sfx/page_turn.ogg';

  // ── Core: Animaciones (Lottie + Rive) ─────────────────────────────────────

  static const String animLoadingGarden =
      '$_base/core/animations/lottie/loading_garden.json';
  static const String animSuccessCelebration =
      '$_base/core/animations/lottie/success_celebration.json';
  static const String animCoinBurst =
      '$_base/core/animations/lottie/coin_burst.json';

  /// Animación Rive genérica de UI (ej. Lumi reaccionando en el HUD) —
  /// interactiva vía state machine, a diferencia de las Lottie de arriba
  /// (que solo reproducen, no reaccionan a input).
  static const String animUiRive = '$_base/core/animations/rive/ui_lumi.riv';

  // ── Mundos ────────────────────────────────────────────────────────────────
  //
  // Los 10 mundos comparten la misma estructura exacta (ver pubspec.yaml) —
  // por eso todo lo de mundos son FUNCIONES parametrizadas por número de
  // mundo, no 10 bloques de constantes repetidos.

  static String imgWorldThumbnail(String worldNumber) =>
      '$_base/worlds/world_$worldNumber/images/thumbnail.webp';

  static String imgWorldMapBackground(String worldNumber) =>
      '$_base/worlds/world_$worldNumber/images/map_background.webp';

  /// Música ambiental del mundo — SIN idioma (la música no tiene palabras).
  ///
  /// Antes de este Sprint, este path variaba por `lang`, mezclando el
  /// concepto de "música" con "narración" — un error real (ver
  /// audioWorldNarration para el audio que sí necesita idioma).
  static String audioWorldAmbient(String worldNumber) =>
      '$_base/worlds/world_$worldNumber/audio/ambient/ambient_loop.ogg';

  /// Efecto de sonido específico de un mundo (ej. sonido de agua en el
  /// Mundo del Diluvio) — sin idioma.
  static String audioWorldSfx(String worldNumber, String sfxId) =>
      '$_base/worlds/world_$worldNumber/audio/sfx/$sfxId.ogg';

  /// Narración hablada de un mundo/capítulo — CON idioma, porque a
  /// diferencia de la música, sí tiene palabras.
  ///
  /// [narrationId]: identificador de contenido (ej. 'chapter_001_intro',
  /// 'verse_gen_1_1') — lo define el Sprint de contenido de cada mundo.
  static String audioWorldNarration(
    String worldNumber,
    String narrationId, {
    String lang = 'es',
  }) =>
      '$_base/worlds/world_$worldNumber/audio/narration/$lang/$narrationId.ogg';

  /// Animación Lottie específica de un mundo.
  static String animWorldLottie(String worldNumber, String animationId) =>
      '$_base/worlds/world_$worldNumber/animations/lottie/$animationId.json';

  /// Animación Rive específica de un mundo.
  static String animWorldRive(String worldNumber, String animationId) =>
      '$_base/worlds/world_$worldNumber/animations/rive/$animationId.riv';

  // ── Personajes ────────────────────────────────────────────────────────────

  static String imgCharacterAvatar(String characterId) =>
      '$_base/characters/$characterId/images/avatar.webp';

  /// Animación Rive del personaje — formato PRIMARIO de animación de
  /// personajes (ver nota de licencia de Spine en pubspec.yaml).
  static String animCharacterRive(String characterId) =>
      '$_base/characters/$characterId/animations/rive/character.riv';

  /// Sprite esquelético Spine del personaje — RESERVADO hasta adquirir la
  /// licencia comercial de Spine. No usar en código nuevo; usar
  /// [animCharacterRive].
  static String animCharacterSpine(String characterId) =>
      '$_base/characters/$characterId/animations/spine/sprite.skel';

  // ── Personajes específicos (para evitar typos en `characterId`) ──────────

  static const String imgTobiasAvatar =
      '$_base/characters/tobias/images/avatar.webp';
  static const String imgLumiAvatar =
      '$_base/characters/lumi/images/avatar.webp';
  static const String imgNoahAvatar =
      '$_base/characters/noah/images/avatar.webp';
  static const String imgAdamAvatar =
      '$_base/characters/adam/images/avatar.webp';
  static const String imgEveAvatar = '$_base/characters/eve/images/avatar.webp';
  static const String imgAbrahamAvatar =
      '$_base/characters/abraham/images/avatar.webp';
  static const String imgMosesAvatar =
      '$_base/characters/moses/images/avatar.webp';
  static const String imgDavidAvatar =
      '$_base/characters/david/images/avatar.webp';
  static const String imgEstherAvatar =
      '$_base/characters/esther/images/avatar.webp';
  static const String imgDanielAvatar =
      '$_base/characters/daniel/images/avatar.webp';
  static const String imgJonahAvatar =
      '$_base/characters/jonah/images/avatar.webp';
  static const String imgJesusAvatar =
      '$_base/characters/jesus/images/avatar.webp';
  static const String imgPeterAvatar =
      '$_base/characters/peter/images/avatar.webp';
  static const String imgPaulAvatar =
      '$_base/characters/paul/images/avatar.webp';
}
