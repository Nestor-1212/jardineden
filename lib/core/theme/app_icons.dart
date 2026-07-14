// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_icons.dart
//
// RESPONSABILIDAD:
//   Registro central de todos los íconos del videojuego Jardín del Edén.
//   Define aliases semánticos sobre Material Icons para que el código de los
//   widgets use nombres de dominio del juego, no nombres de Material.
//
//   Ventaja: si en el futuro se reemplaza un ícono de Material por uno
//   custom (Spine, SVG, PNG), solo se cambia en este archivo.
//
// SISTEMA DE ÍCONOS:
//   • Capa 1 — Material Icons: disponibles inmediatamente (sin assets)
//   • Capa 2 — Custom Icons: sprites PNG para monedas y rarezas (Sprint futuros)
//
// NOTAS PARA CUSTOM ICONS (futuros sprints):
//   Los íconos de monedas (Luz, Sabiduría, Jordán, Abraam) se reemplazarán
//   por sprites PNG de los assets del juego. Las constantes de nombre
//   permanecen iguales — solo cambia la implementación del widget.
//
//   El sistema de rarezas también tendrá íconos custom de símbolo por nivel.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart únicamente.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Registro de íconos semánticos del videojuego Jardín del Edén.
///
/// NUNCA usar `Icons.xyz` directamente en los widgets.
/// Siempre usar `AppIcons.xyz` para mantener la indirección.
abstract final class AppIcons {
  // ── Navegación Principal ──────────────────────────────────────────────────
  // Íconos del bottom navigation bar del juego.

  static const IconData home = Icons.home_rounded;
  static const IconData worlds = Icons.explore_rounded;
  static const IconData missions = Icons.assignment_rounded;
  static const IconData inventory = Icons.inventory_2_rounded;
  static const IconData library = Icons.menu_book_rounded;
  static const IconData pet = Icons.flutter_dash;
  static const IconData diary = Icons.book_rounded;
  static const IconData rewards = Icons.emoji_events_rounded;
  static const IconData stats = Icons.bar_chart_rounded;
  static const IconData seasonal = Icons.celebration_rounded;
  static const IconData collection = Icons.collections_bookmark_rounded;

  // ── Perfiles y Autenticación ──────────────────────────────────────────────

  static const IconData profile = Icons.person_rounded;
  static const IconData addProfile = Icons.person_add_rounded;
  static const IconData editProfile = Icons.edit_rounded;
  static const IconData deleteProfile = Icons.delete_rounded;
  static const IconData avatar = Icons.face_rounded;
  static const IconData parentPanel = Icons.shield_rounded;
  static const IconData pin = Icons.pin_rounded;
  static const IconData lock = Icons.lock_rounded;
  static const IconData unlock = Icons.lock_open_rounded;

  // ── Controles de Juego ────────────────────────────────────────────────────

  static const IconData play = Icons.play_arrow_rounded;
  static const IconData pause = Icons.pause_rounded;
  static const IconData stop = Icons.stop_rounded;
  static const IconData replay = Icons.replay_rounded;
  static const IconData skip = Icons.skip_next_rounded;
  static const IconData next = Icons.arrow_forward_rounded;
  static const IconData back = Icons.arrow_back_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData moreOptions = Icons.more_vert_rounded;

  // ── Navegación de Contenido ───────────────────────────────────────────────

  static const IconData world = Icons.public_rounded;
  static const IconData chapter = Icons.auto_stories_rounded;
  static const IconData minigame = Icons.games_rounded;
  static const IconData mission = Icons.task_alt_rounded;
  static const IconData verse = Icons.format_quote_rounded;
  static const IconData diaryEntry = Icons.edit_note_rounded;

  // ── Feedback y Resultado ──────────────────────────────────────────────────

  static const IconData correct = Icons.check_circle_rounded;
  static const IconData incorrect = Icons.cancel_rounded;
  static const IconData hint = Icons.lightbulb_rounded;
  static const IconData celebrate = Icons.auto_awesome_rounded;
  static const IconData trophy = Icons.emoji_events_rounded;
  static const IconData star = Icons.star_rounded;
  static const IconData starOutline = Icons.star_outline_rounded;
  static const IconData sparkle = Icons.auto_awesome_rounded;

  // ── Monedas del Juego ─────────────────────────────────────────────────────
  // NOTA: Estos íconos de Material son placeholders temporales.
  // En el Sprint de Assets se reemplazarán por imágenes PNG custom.
  // La constante de nombre permanece igual — solo el widget de íconos cambia.

  /// Semillas de Luz — XP principal. Placeholder: sol/destello.
  static const IconData currencyLuz = Icons.flare_rounded;

  /// Pergaminos de Sabiduría. Placeholder: libro abierto/contactos.
  static const IconData currencySabiduria = Icons.import_contacts_rounded;

  /// Piedras del Jordán. Placeholder: gota de agua.
  static const IconData currencyJordan = Icons.water_drop_rounded;

  /// Estrellas de Abraam. Placeholder: estrella.
  static const IconData currencyAbraam = Icons.star_rounded;

  // ── Mecánicas del Juego ───────────────────────────────────────────────────

  /// Vinculum: relación con personaje bíblico. Placeholder: apretón de manos.
  static const IconData vinculum = Icons.handshake_rounded;

  /// Sistema 44 de revisión espaciada. Placeholder: reloj/calendario.
  static const IconData sistema44 = Icons.schedule_rounded;

  /// Versículo "Grabado en el Corazón" (nivel máximo de memorización).
  static const IconData grabadoCorazon = Icons.favorite_rounded;

  /// Muro de Sabiduría (gate de comprensión entre capítulos).
  static const IconData muroSabiduria = Icons.gavel_rounded;

  /// Racha de días consecutivos.
  static const IconData streak = Icons.local_fire_department_rounded;

  /// Nivel del jugador.
  static const IconData level = Icons.military_tech_rounded;

  /// XP (Luz) del jugador.
  static const IconData xp = Icons.flare_rounded;

  // ── Rarezas de Ítems ──────────────────────────────────────────────────────
  // NOTA: En el Sprint de Assets se crearán iconos custom por rareza.
  // Estos son placeholders de Material Icons.

  static const IconData rarityBarro = Icons.circle_outlined;
  static const IconData rarityBronce = Icons.shield_outlined;
  static const IconData rarityPlata = Icons.shield_rounded;
  static const IconData rarityOro = Icons.workspace_premium_rounded;
  static const IconData rarityOnix = Icons.diamond_rounded;
  static const IconData rarityGloria = Icons.auto_awesome_rounded;

  // ── Personajes Bíblicos ───────────────────────────────────────────────────
  // Los personajes tendrán sprites Spine en el Sprint de Personajes.
  // Estos son placeholders hasta que los assets existan.

  static const IconData characterGeneric = Icons.person_rounded;
  static const IconData characterJesus = Icons.brightness_5_rounded;
  static const IconData npc = Icons.support_agent_rounded;

  // ── Audio y Multimedia ────────────────────────────────────────────────────

  static const IconData musicOn = Icons.music_note_rounded;
  static const IconData musicOff = Icons.music_off_rounded;
  static const IconData volumeHigh = Icons.volume_up_rounded;
  static const IconData volumeLow = Icons.volume_down_rounded;
  static const IconData volumeOff = Icons.volume_off_rounded;
  static const IconData headphones = Icons.headphones_rounded;

  // ── Configuración ────────────────────────────────────────────────────────

  static const IconData settings = Icons.settings_rounded;
  static const IconData language = Icons.language_rounded;
  static const IconData accessibility = Icons.accessibility_new_rounded;
  static const IconData brightness = Icons.brightness_6_rounded;
  static const IconData darkMode = Icons.dark_mode_rounded;
  static const IconData lightMode = Icons.light_mode_rounded;
  static const IconData notification = Icons.notifications_rounded;
  static const IconData notificationOff = Icons.notifications_off_rounded;

  // ── Información y Ayuda ───────────────────────────────────────────────────

  static const IconData info = Icons.info_rounded;
  static const IconData help = Icons.help_rounded;
  static const IconData question = Icons.quiz_rounded;
  static const IconData about = Icons.info_outlined;
  static const IconData terms = Icons.gavel_rounded;
  static const IconData privacy = Icons.privacy_tip_rounded;

  // ── Estado del Sistema ────────────────────────────────────────────────────

  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData success = Icons.check_circle_rounded;
  static const IconData loading = Icons.hourglass_empty_rounded;
  static const IconData offline = Icons.wifi_off_rounded;
  static const IconData sync = Icons.sync_rounded;

  // ── UI General ────────────────────────────────────────────────────────────

  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData sort = Icons.sort_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData upload = Icons.upload_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData expandMore = Icons.expand_more_rounded;
  static const IconData expandLess = Icons.expand_less_rounded;
  static const IconData arrowForward = Icons.chevron_right_rounded;
  static const IconData arrowBack = Icons.chevron_left_rounded;
  static const IconData arrowUp = Icons.keyboard_arrow_up_rounded;
  static const IconData arrowDown = Icons.keyboard_arrow_down_rounded;
  static const IconData add = Icons.add_rounded;
  static const IconData remove = Icons.remove_rounded;
  static const IconData visible = Icons.visibility_rounded;
  static const IconData hidden = Icons.visibility_off_rounded;
  static const IconData calendar = Icons.calendar_today_rounded;
  static const IconData time = Icons.access_time_rounded;

  // ── Lumi — Mascota del Juego ──────────────────────────────────────────────
  // Lumi es el búho mascota. Placeholder hasta que el sprite esté disponible.

  static const IconData lumi = Icons.flutter_dash;
  static const IconData lumiHappy = Icons.sentiment_very_satisfied_rounded;
  static const IconData lumiSad = Icons.sentiment_very_dissatisfied_rounded;
  static const IconData lumiThinking = Icons.psychology_rounded;
  static const IconData lumiExcited = Icons.star_rounded;

  // ── Mapas de Constantes ───────────────────────────────────────────────────
  // Para casos donde se necesita obtener el ícono de forma dinámica.

  /// Retorna el ícono de moneda correspondiente a la moneda dada.
  ///
  /// Uso: `AppIcons.forCurrency('Semillas de Luz')`
  static IconData forCurrency(String currencyName) => switch (currencyName) {
    'Semillas de Luz' => currencyLuz,
    'Pergaminos de Sabiduría' => currencySabiduria,
    'Piedras del Jordán' => currencyJordan,
    'Estrellas de Abraam' => currencyAbraam,
    _ => star,
  };

  /// Retorna el ícono de rareza correspondiente al nivel dado.
  ///
  /// Uso: `AppIcons.forRarity('Oro')`
  static IconData forRarity(String rarityName) => switch (rarityName) {
    'Barro' => rarityBarro,
    'Bronce' => rarityBronce,
    'Plata' => rarityPlata,
    'Oro' => rarityOro,
    'Ónix' => rarityOnix,
    'Gloria' => rarityGloria,
    _ => rarityBarro,
  };
}
