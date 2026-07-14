// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_text_styles.dart
//
// RESPONSABILIDAD:
//   Define todos los estilos de texto del Design System.
//   Basado en la tipografía oficial: Fredoka (principal), Nunito (secundaria).
//
// ESCALA TIPOGRÁFICA:
//   display:  48px — Títulos de mundos, pantallas de celebración
//   h1:       36px — Títulos principales de pantalla
//   h2:       28px — Subtítulos y nombres de capítulo
//   h3:       22px — Títulos de sección
//   h4:       18px — Títulos de tarjeta
//   body:     16px — Texto corriente de historia y UI
//   bodySm:   14px — Texto de apoyo, metadatos, labels
//   caption:  12px — Texto muy pequeño, timestamps, badges
//   button:   16px — Texto de botones (siempre SemiBold)
//   verse:    18px — Versículos bíblicos (serif weight especial)
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart (TextStyle, FontWeight).
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos del core.
//
// NOTA: Los nombres de familia de fuente deben coincidir exactamente con
//       los declarados en pubspec.yaml bajo flutter.fonts.
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core (Tema)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Estilos de texto del videojuego Jardín del Edén.
///
/// Basado en el Design System oficial del proyecto.
/// Se usa directamente en los widgets: `style: AppTextStyles.h1`
abstract final class AppTextStyles {
  // ── Familia de Fuentes ────────────────────────────────────────────────────

  /// Fuente principal del juego. Usada en títulos, UI principal, nombres.
  /// Warm, redondeada, amigable para niños.
  static const String _fontFredoka = 'Fredoka';

  /// Fuente secundaria. Usada en textos de historia, párrafos largos.
  /// Más legible para lectura extendida.
  static const String _fontNunito = 'Nunito';

  // ── Display (Títulos de Pantalla Especial) ────────────────────────────────

  /// Para pantallas de celebración, títulos de mundos, splash screens.
  static const TextStyle display = TextStyle(
    fontFamily: _fontFredoka,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: 0.5,
  );

  // ── Encabezados ───────────────────────────────────────────────────────────

  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFredoka,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFredoka,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFredoka,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFredoka,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ── Texto Corriente ───────────────────────────────────────────────────────

  /// Texto principal de historia, descripciones, UI general.
  static const TextStyle body = TextStyle(
    fontFamily: _fontNunito,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  /// Variante semi-bold del body. Para énfasis en párrafos.
  static const TextStyle bodySemiBold = TextStyle(
    fontFamily: _fontNunito,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.6,
  );

  /// Texto más pequeño para metadatos, labels, información secundaria.
  static const TextStyle bodySm = TextStyle(
    fontFamily: _fontNunito,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Texto mínimo para timestamps, badges, descripciones de ítem.
  static const TextStyle caption = TextStyle(
    fontFamily: _fontNunito,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Botones ───────────────────────────────────────────────────────────────

  /// Texto de botones de acción principal. Siempre SemiBold.
  static const TextStyle button = TextStyle(
    fontFamily: _fontFredoka,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.5,
  );

  /// Texto de botones secundarios y links.
  static const TextStyle buttonSm = TextStyle(
    fontFamily: _fontFredoka,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  // ── Versículos Bíblicos ───────────────────────────────────────────────────

  /// Estilo especial para la presentación de versículos de la Biblia RVR2000.
  /// Más grande y con mejor espaciado para lectura reflexiva.
  static const TextStyle verse = TextStyle(
    fontFamily: _fontNunito,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.8,
    fontStyle: FontStyle.italic,
  );

  /// Referencia del versículo (libro, capítulo, versículo).
  /// Ejemplo: "Génesis 1:1 (RVR2000)"
  static const TextStyle verseReference = TextStyle(
    fontFamily: _fontNunito,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.3,
  );

  // ── HUD del Juego ─────────────────────────────────────────────────────────

  /// Texto de contadores de monedas en el HUD. Compacto y legible.
  static const TextStyle hudCounter = TextStyle(
    fontFamily: _fontFredoka,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  /// Texto de nivel del jugador y XP (Luz).
  static const TextStyle hudLevel = TextStyle(
    fontFamily: _fontFredoka,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.2,
  );
}
