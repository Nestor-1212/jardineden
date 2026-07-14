// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_spacing.dart
//
// RESPONSABILIDAD:
//   Define el sistema de espaciado y tamaños del proyecto.
//   Basado en una escala de 4px para garantizar alineación en grid.
//   NUNCA se usa un número de píxeles hardcodeado en widgets.
//   Siempre se usa una constante de este archivo.
//
// ESCALA BASE: 4px
//   xs:  4px    Espaciado mínimo entre elementos inline
//   sm:  8px    Espacio interno de elementos compactos
//   md:  16px   Espacio estándar (el más usado)
//   lg:  24px   Espacio entre secciones
//   xl:  32px   Espacio entre componentes grandes
//   xxl: 48px   Espacio de layout principal
//   xxxl: 64px  Espacio extra para pantallas de celebración
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente (doubles son Dart puro).
// DEPENDENCIAS PROHIBIDAS:   Flutter, features, shared, cualquier paquete.
// ─────────────────────────────────────────────────────────────────────────────

/// Sistema de espaciado del videojuego Jardín del Edén.
///
/// Basado en escala de 4px. Se usa en padding, margin, gap,
/// SizedBox.height, SizedBox.width y border radius.
abstract final class AppSpacing {
  // ── Escala Base ───────────────────────────────────────────────────────────

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  // ── Radios de Borde ───────────────────────────────────────────────────────

  /// Radio para elementos de texto (chips, badges).
  static const double radiusSm = 8;

  /// Radio estándar para tarjetas y botones.
  static const double radiusMd = 16;

  /// Radio para modales y paneles deslizables.
  static const double radiusLg = 24;

  /// Radio para elementos completamente redondeados (ícono circular).
  static const double radiusFull = 999;

  // ── Tamaños de Ícono ──────────────────────────────────────────────────────

  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;
  static const double iconXxl = 64;

  // ── Alturas de Elemento ───────────────────────────────────────────────────

  /// Altura mínima de un elemento táctil (accesibilidad: 44pt).
  static const double touchTargetMin = 44;

  /// Altura estándar de botón de acción principal.
  static const double buttonHeight = 56;

  /// Altura del HUD superior del juego.
  static const double hudHeight = 64;

  /// Altura de la barra de navegación inferior.
  static const double bottomNavHeight = 72;

  // ── Elevaciones ───────────────────────────────────────────────────────────

  /// Sin elevación. Elementos en el mismo plano que la superficie.
  static const double elevationNone = 0;

  /// Elevación mínima. Tarjetas en reposo.
  static const double elevationSm = 2;

  /// Elevación estándar. Tarjetas interactivas.
  static const double elevationMd = 4;

  /// Elevación alta. Modales y paneles flotantes.
  static const double elevationLg = 8;

  /// Elevación máxima. Dialogs y overlays de celebración.
  static const double elevationXl = 16;

  // ── Breakpoints de Layout ─────────────────────────────────────────────────

  /// Teléfono compacto. Layout de columna única.
  static const double breakpointMobile = 480;

  /// Teléfono grande / phablet.
  static const double breakpointMobileLg = 600;

  /// Tablet pequeña.
  static const double breakpointTablet = 768;

  /// Tablet grande / Chromebook.
  static const double breakpointTabletLg = 1024;
}
