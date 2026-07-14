// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_shadows.dart
//
// RESPONSABILIDAD:
//   Define el sistema completo de sombras del Design System.
//   Incluye sombras para elevaciones de UI y efectos de brillo (glow)
//   específicos del juego: monedas, rarezas, HUD.
//
// SISTEMA DE SOMBRAS:
//   Modo claro: sombras oscuras suaves (estándar Material 3)
//   Modo oscuro: brillos verdes sutiles (identidad del jardín)
//   Efectos de juego: brillos de color por moneda y rareza
//
// CONVENCIÓN:
//   Las listas *Dark se usan cuando el tema activo es oscuro.
//   Los brillos de juego (glow*) son independientes del tema.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart únicamente.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Sistema de sombras y efectos de brillo del videojuego Jardín del Edén.
///
/// Sombras estándar de UI y brillos (glow) específicos del juego.
abstract final class AppShadows {
  // ── Sombras — Tema Claro ──────────────────────────────────────────────────
  // Sombras clásicas oscuras sobre fondos claros. Equivalencia con Material 3.

  /// Sin sombra. Elementos en el mismo plano que la superficie.
  static const List<BoxShadow> none = [];

  /// Elevación 2dp — Tarjetas en reposo, chips, badges.
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x14000000), // negro 8%
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A000000), // negro 4%
      blurRadius: 2,
      offset: Offset(0, 1),
      spreadRadius: -1,
    ),
  ];

  /// Elevación 4dp — Tarjetas interactivas, botones flotantes en reposo.
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1F000000), // negro 12%
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x14000000), // negro 8%
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: -1,
    ),
  ];

  /// Elevación 8dp — Modales, paneles laterales, drawer.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x29000000), // negro 16%
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x1F000000), // negro 12%
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  /// Elevación 16dp — Dialogs, overlays de celebración, overlays de victoria.
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x33000000), // negro 20%
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x1F000000), // negro 12%
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: -4,
    ),
  ];

  // ── Sombras — Tema Oscuro ─────────────────────────────────────────────────
  // En fondos oscuros, las sombras negras son invisibles.
  // Se reemplazan por brillos verdes del jardín (identidad de la marca).

  /// Elevación 2dp — Modo oscuro.
  static const List<BoxShadow> smDark = [
    BoxShadow(
      color: Color(0x2052B788), // gardenMedium 12%
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Elevación 4dp — Modo oscuro.
  static const List<BoxShadow> mdDark = [
    BoxShadow(
      color: Color(0x2D52B788), // gardenMedium 18%
      blurRadius: 14,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x1440916C), // gardenLeaf 8%
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  /// Elevación 8dp — Modo oscuro.
  static const List<BoxShadow> lgDark = [
    BoxShadow(
      color: Color(0x3D52B788), // gardenMedium 24%
      blurRadius: 24,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x1A40916C), // gardenLeaf 10%
      blurRadius: 10,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  /// Elevación 16dp — Modo oscuro.
  static const List<BoxShadow> xlDark = [
    BoxShadow(
      color: Color(0x4D52B788), // gardenMedium 30%
      blurRadius: 40,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color(0x2640916C), // gardenLeaf 15%
      blurRadius: 18,
      offset: Offset(0, 4),
      spreadRadius: -4,
    ),
  ];

  // ── Brillo Dorado Sagrado ─────────────────────────────────────────────────
  // Para ítems de rareza Oro, Gloria, logros máximos, versículos dominados.

  /// Brillo dorado suave. Rareza Oro.
  static const List<BoxShadow> glowGold = [
    BoxShadow(
      color: Color(0x4DD4AF37), // sacredGold 30%
      blurRadius: 12,
      spreadRadius: 1,
    ),
  ];

  /// Brillo dorado intenso. Rareza Gloria — "Grabado en el Corazón".
  static const List<BoxShadow> glowGloria = [
    BoxShadow(
      color: Color(0x80D4AF37), // sacredGold 50%
      blurRadius: 24,
      spreadRadius: 4,
    ),
    BoxShadow(
      color: Color(0x40F5E27A), // sacredGoldLight 25%
      blurRadius: 48,
      spreadRadius: 8,
    ),
  ];

  // ── Brillos de Monedas ────────────────────────────────────────────────────

  /// Brillo para Semillas de Luz (moneda principal XP).
  static const List<BoxShadow> glowLuz = [
    BoxShadow(
      color: Color(0x4DFFD166), // semillasLuz 30%
      blurRadius: 10,
      spreadRadius: 1,
    ),
  ];

  /// Brillo para Pergaminos de Sabiduría.
  static const List<BoxShadow> glowSabiduria = [
    BoxShadow(
      color: Color(0x4DE8A838), // pergaminosSabiduria 30%
      blurRadius: 10,
      spreadRadius: 1,
    ),
  ];

  /// Brillo para Piedras del Jordán.
  static const List<BoxShadow> glowJordan = [
    BoxShadow(
      color: Color(0x4D4ECDC4), // piedrasJordan 30%
      blurRadius: 10,
      spreadRadius: 1,
    ),
  ];

  /// Brillo para Estrellas de Abraam.
  static const List<BoxShadow> glowAbraam = [
    BoxShadow(
      color: Color(0x4DB8C0D0), // estrellasAbraam 30%
      blurRadius: 10,
      spreadRadius: 1,
    ),
  ];

  // ── Brillos de Rareza ─────────────────────────────────────────────────────

  /// Brillo rareza Bronce.
  static const List<BoxShadow> glowBronce = [
    BoxShadow(
      color: Color(0x33CD7F32), // rarityBronce 20%
      blurRadius: 8,
    ),
  ];

  /// Brillo rareza Plata.
  static const List<BoxShadow> glowPlata = [
    BoxShadow(
      color: Color(0x33C0C0C0), // rarityPlata 20%
      blurRadius: 8,
    ),
  ];

  /// Brillo rareza Ónix.
  static const List<BoxShadow> glowOnix = [
    BoxShadow(
      color: Color(0x662D2D2D), // rarityOnix 40% — outline visible sobre fondo
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];

  // ── Brillo del HUD Breathing ──────────────────────────────────────────────
  // El HUD pulsa entre opacidades bajas y altas. La sombra también pulsa.
  // La animación se controla en el widget mediante AnimationController.

  /// Sombra del HUD en estado de reposo (opacidad reducida).
  static const List<BoxShadow> hudResting = [
    BoxShadow(
      color: Color(0x2052B788), // gardenMedium 12%
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];

  /// Sombra del HUD en estado activo (opacidad completa).
  static const List<BoxShadow> hudActive = [
    BoxShadow(
      color: Color(0x4052B788), // gardenMedium 25%
      blurRadius: 12,
      spreadRadius: 1,
    ),
  ];

  // ── Sombras de Estado ─────────────────────────────────────────────────────

  /// Sombra de error. Para campos con validación fallida.
  static const List<BoxShadow> error = [
    BoxShadow(
      color: Color(0x33E63946), // error 20%
      blurRadius: 8,
      spreadRadius: 1,
    ),
  ];

  /// Sombra de éxito. Para respuesta correcta en minijuegos.
  static const List<BoxShadow> success = [
    BoxShadow(
      color: Color(0x3352B788), // gardenMedium 20%
      blurRadius: 8,
      spreadRadius: 1,
    ),
  ];
}
