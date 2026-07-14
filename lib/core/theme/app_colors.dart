// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_colors.dart
//
// RESPONSABILIDAD:
//   Define la paleta de colores completa del Design System de Jardín del Edén.
//   Es la fuente de verdad de todos los colores del proyecto.
//   NUNCA se usa un Color(0xFF...) hardcodeado fuera de este archivo.
//
// ORGANIZACIÓN:
//   • Colores primarios del juego (verde jardín, dorado sagrado)
//   • Paleta por mundo (cada mundo tiene su paleta narrativa)
//   • Colores de monedas y economía
//   • Colores por rareza de ítem (5 rarezas)
//   • Colores de estado (error, éxito, advertencia, información)
//   • Colores semánticos del sistema (fondo, superficie, texto)
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart únicamente (para Color).
// DEPENDENCIAS PROHIBIDAS:   features, shared, core (otros módulos).
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core (Tema)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Paleta de colores completa del videojuego Jardín del Edén.
///
/// Basada en el Design System oficial del proyecto.
/// Todos los colores tienen una variante claro y oscuro donde aplica.
abstract final class AppColors {
  // ── Paleta Primaria del Jardín ────────────────────────────────────────────

  /// Verde profundo del jardín. Color de identidad principal.
  /// Uso: Fondos principales, barras de navegación, headers.
  static const Color gardenDeep = Color(0xFF1B4332);

  /// Verde medio del jardín. Color de acción primaria.
  /// Uso: Botones principales, elementos activos, íconos primarios.
  static const Color gardenMedium = Color(0xFF52B788);

  /// Verde claro del jardín. Color de acento suave.
  /// Uso: Textos secundarios en fondo oscuro, indicadores sutiles.
  static const Color gardenLight = Color(0xFF95D5B2);

  /// Verde hoja. Para detalles ornamentales y animaciones.
  static const Color gardenLeaf = Color(0xFF40916C);

  /// Verde musgo. Para superficies alternativas y capas.
  static const Color gardenMoss = Color(0xFF2D6A4F);

  // ── Dorado Sagrado ────────────────────────────────────────────────────────

  /// Dorado sagrado principal. Color de recompensas y logros máximos.
  /// Uso: Ítems de rareza Oro y Ónix, celebraciones, versículos Gloria.
  static const Color sacredGold = Color(0xFFD4AF37);

  /// Dorado claro. Para brillos y efectos de partículas.
  static const Color sacredGoldLight = Color(0xFFF5E27A);

  /// Dorado oscuro. Para bordes de elementos dorados.
  static const Color sacredGoldDark = Color(0xFFA08820);

  // ── Colores de las Monedas del Juego ─────────────────────────────────────

  /// Semillas de Luz (moneda principal de XP).
  /// Color: Amarillo cálido luminoso.
  static const Color semillasLuz = Color(0xFFFFD166);

  /// Pergaminos de Sabiduría (moneda de conocimiento).
  /// Color: Pergamino antiguo dorado rojizo.
  static const Color pergaminosSabiduria = Color(0xFFE8A838);

  /// Piedras del Jordán (moneda de aventura).
  /// Color: Azul agua río sagrado.
  static const Color piedrasJordan = Color(0xFF4ECDC4);

  /// Estrellas de Abraam (moneda de fe y promesa).
  /// Color: Plateado estelar brillante.
  static const Color estrellasAbraam = Color(0xFFB8C0D0);

  // ── Sistema de Rarezas de Ítems ──────────────────────────────────────────

  /// Rareza Barro. El nivel más básico.
  static const Color rarityBarro = Color(0xFF8B7355);

  /// Rareza Bronce.
  static const Color rarityBronce = Color(0xFFCD7F32);

  /// Rareza Plata.
  static const Color rarityPlata = Color(0xFFC0C0C0);

  /// Rareza Oro.
  static const Color rarityOro = Color(0xFFFFD700);

  /// Rareza Ónix. Nivel premium especial.
  static const Color rarityOnix = Color(0xFF2D2D2D);

  /// Rareza Gloria. El nivel máximo. Solo versículos "Grabado en el Corazón".
  static const Color rarityGloria = Color(0xFFFFEFAA);

  // ── Colores de Estado del Sistema ────────────────────────────────────────

  /// Color de éxito: operación completada, respuesta correcta.
  static const Color success = Color(0xFF52B788);

  /// Color de error: operación fallida, respuesta incorrecta.
  static const Color error = Color(0xFFE63946);

  /// Color de advertencia: situación que requiere atención.
  static const Color warning = Color(0xFFFFB703);

  /// Color de información neutral.
  static const Color info = Color(0xFF4895EF);

  // ── Paletas por Mundo (Color Narrativo Principal) ─────────────────────────

  /// Mundo 1 — Edén: La Creación. Verde paraíso primordial.
  static const Color world01Eden = Color(0xFF74C69D);

  /// Mundo 2 — El Diluvio: Noé y el Arca. Azul oceánico profundo.
  static const Color world02Flood = Color(0xFF1A759F);

  /// Mundo 3 — El Llamado: Abraham. Dorado arena del desierto.
  static const Color world03Abraham = Color(0xFFE9C46A);

  /// Mundo 4 — La Promesa: Isaac y Jacob. Ocre tierra prometida.
  static const Color world04Promise = Color(0xFFD4956A);

  /// Mundo 5 — El Sueño: José en Egipto. Púrpura real de faraón.
  static const Color world05Joseph = Color(0xFF9B59B6);

  /// Mundo 6 — La Liberación: Moisés y el Éxodo. Rojo Mar Rojo.
  static const Color world06Exodus = Color(0xFFE74C3C);

  /// Mundo 7 — El Rey: David y Salomón. Azul real de Jerusalén.
  static const Color world07David = Color(0xFF2E4057);

  /// Mundo 8 — La Profecía: Daniel y Ester. Azul babilónico.
  static const Color world08Prophecy = Color(0xFF4A6FA5);

  /// Mundo 9 — El Profeta: Jonás y Elías. Verde tormenta de mar.
  static const Color world09Prophet = Color(0xFF2D6A4F);

  /// Mundo 10 — La Gracia: Jesús y sus discípulos. Blanco luz divina.
  static const Color world10Grace = Color(0xFFF8F9FA);

  // ── Colores de Superficie y Fondo ────────────────────────────────────────

  /// Fondo principal de pantallas con modo claro.
  static const Color backgroundLight = Color(0xFFF8FFF4);

  /// Fondo principal de pantallas con modo oscuro.
  static const Color backgroundDark = Color(0xFF0D1F17);

  /// Superficie de tarjetas y modales en modo claro.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Superficie de tarjetas y modales en modo oscuro.
  static const Color surfaceDark = Color(0xFF1A2E23);

  // ── Colores de Texto ──────────────────────────────────────────────────────

  /// Texto principal sobre fondos claros.
  static const Color textPrimaryLight = Color(0xFF1B2926);

  /// Texto principal sobre fondos oscuros.
  static const Color textPrimaryDark = Color(0xFFF0FFF4);

  /// Texto secundario sobre fondos claros.
  static const Color textSecondaryLight = Color(0xFF4A6741);

  /// Texto secundario sobre fondos oscuros.
  static const Color textSecondaryDark = Color(0xFF95D5B2);

  // ── Colores del HUD Breathing ─────────────────────────────────────────────

  /// Color base del HUD en estado de reposo (20-30% opacidad aplicada en código).
  static const Color hudResting = Color(0xFF52B788);

  /// Color del HUD cuando está activo (100% opacidad).
  static const Color hudActive = Color(0xFF52B788);
}
