// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_borders.dart
//
// RESPONSABILIDAD:
//   Define el sistema completo de bordes del Design System.
//   Incluye BorderRadius precompilados, anchos de borde, y decoraciones
//   estándar de BoxDecoration reutilizables en toda la UI del juego.
//
// ORGANIZACIÓN:
//   AppBorderRadius  — constantes de BorderRadius (const)
//   AppBorderWidth   — anchos de línea de borde
//   AppBorderSide    — BorderSide precompilados por uso semántico
//   AppDecorations   — BoxDecoration reutilizables (no-const, usan colores)
//
// NOTA IMPORTANTE:
//   AppDecorations NO puede ser const porque usa colores con withValues().
//   Los métodos estáticos reciben el Brightness para adaptar al tema activo.
//   Prefiere AppBorderRadius + AppColors en los widgets en lugar de
//   AppDecorations cuando necesites más control granular.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, app_colors.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BORDER RADIUS
// Todos los borderRadius del proyecto. Basados en los valores de AppSpacing
// (8/16/24/999) pero como objetos BorderRadius listos para usar en widgets.
// ─────────────────────────────────────────────────────────────────────────────

/// Constantes de BorderRadius del Design System.
///
/// Uso: `Container(decoration: BoxDecoration(borderRadius: AppBorderRadius.md))`
abstract final class AppBorderRadius {
  // ── Radios Simétricos ─────────────────────────────────────────────────────

  /// Sin radio. Para elementos que necesitan esquinas exactamente rectas.
  static const BorderRadius none = BorderRadius.zero;

  /// 8px — Chips, badges, tooltips, inputs compactos.
  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));

  /// 16px — Tarjetas de contenido, botones, modales. El radio más usado.
  static const BorderRadius md = BorderRadius.all(Radius.circular(16));

  /// 24px — Modales grandes, bottom sheets, paneles de personaje.
  static const BorderRadius lg = BorderRadius.all(Radius.circular(24));

  /// 32px — Elementos especiales de diseño, marcos decorativos.
  static const BorderRadius xl = BorderRadius.all(Radius.circular(32));

  /// 999px — Elementos perfectamente circulares o en píldora.
  /// Avatares, badges de moneda, contadores del HUD.
  static const BorderRadius full = BorderRadius.all(Radius.circular(999));

  // ── Radios Asimétricos — Solo Arriba ─────────────────────────────────────

  /// 16px solo en la parte superior. Para bottom sheets y drawers desde abajo.
  static const BorderRadius topMd = BorderRadius.vertical(
    top: Radius.circular(16),
  );

  /// 24px solo en la parte superior. Para sheets de contenido grande.
  static const BorderRadius topLg = BorderRadius.vertical(
    top: Radius.circular(24),
  );

  // ── Radios Asimétricos — Solo Abajo ──────────────────────────────────────

  /// 16px solo en la parte inferior. Para cabeceras de sección.
  static const BorderRadius bottomMd = BorderRadius.vertical(
    bottom: Radius.circular(16),
  );

  /// 24px solo en la parte inferior. Para paneles superiores.
  static const BorderRadius bottomLg = BorderRadius.vertical(
    bottom: Radius.circular(24),
  );

  // ── Radios para Bottom Sheet ──────────────────────────────────────────────

  /// Radio estándar para bottom sheets: esquinas superiores redondeadas.
  static const BorderRadius sheet = BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );

  /// Radio para top sheets (aparecen desde arriba): esquinas inferiores.
  static const BorderRadius topSheet = BorderRadius.only(
    bottomLeft: Radius.circular(24),
    bottomRight: Radius.circular(24),
  );

  // ── Radios para Elementos Específicos del Juego ───────────────────────────

  /// Radio de tarjeta de mundo en el mapa.
  static const BorderRadius worldCard = BorderRadius.all(Radius.circular(20));

  /// Radio del avatar de perfil de jugador.
  static const BorderRadius avatar = full;

  /// Radio del contador de monedas en el HUD.
  static const BorderRadius hudCoin = BorderRadius.all(Radius.circular(12));

  /// Radio del chip de rareza.
  static const BorderRadius rarityChip = full;

  /// Radio del botón del minijuego (más grande para ser más clicable).
  static const BorderRadius gameButton = BorderRadius.all(Radius.circular(20));
}

// ─────────────────────────────────────────────────────────────────────────────
// ANCHOS DE BORDE
// Grosor de línea para cada contexto de uso.
// ─────────────────────────────────────────────────────────────────────────────

/// Anchos de borde estándar del Design System.
abstract final class AppBorderWidth {
  /// 1px — Separadores, bordes sutiles de tarjeta.
  static const double thin = 1.0;

  /// 1.5px — Bordes de ítem interactivo en reposo.
  static const double regular = 1.5;

  /// 2px — Bordes de ítem seleccionado o en foco.
  static const double medium = 2.0;

  /// 3px — Bordes de rareza (Bronce/Plata/Oro) para diferenciación visual.
  static const double thick = 3.0;

  /// 4px — Borde de elemento activo/seleccionado con alta prioridad visual.
  static const double highlight = 4.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// BORDER SIDES
// BorderSide precompilados para los casos de uso más frecuentes.
// ─────────────────────────────────────────────────────────────────────────────

/// Constantes de BorderSide del Design System.
abstract final class AppBorderSide {
  // Estos BorderSide usan colores que NO pueden ser const
  // porque Color.withValues() no es const. Se definen como getters.

  /// Borde de tarjeta en modo claro. Línea sutil verde musgo.
  static BorderSide get cardLight => const BorderSide(
    color: Color(0x332D6A4F), // gardenMoss 20%
  );

  /// Borde de tarjeta en modo oscuro. Línea verde jardín suave.
  static BorderSide get cardDark => const BorderSide(
    color: Color(0x4052B788), // gardenMedium 25%
  );

  /// Borde de elemento seleccionado (modo claro y oscuro).
  static const BorderSide selected = BorderSide(
    color: AppColors.gardenMedium,
    width: AppBorderWidth.highlight,
  );

  /// Borde de error para campos de entrada con validación fallida.
  static const BorderSide error = BorderSide(
    color: AppColors.error,
    width: AppBorderWidth.medium,
  );

  /// Borde de éxito para respuestas correctas en minijuegos.
  static const BorderSide success = BorderSide(
    color: AppColors.success,
    width: AppBorderWidth.medium,
  );

  // ── Bordes de Rareza ──────────────────────────────────────────────────────

  static const BorderSide rarityBarro = BorderSide(
    color: AppColors.rarityBarro,
    width: AppBorderWidth.regular,
  );

  static const BorderSide rarityBronce = BorderSide(
    color: AppColors.rarityBronce,
    width: AppBorderWidth.thick,
  );

  static const BorderSide rarityPlata = BorderSide(
    color: AppColors.rarityPlata,
    width: AppBorderWidth.thick,
  );

  static const BorderSide rarityOro = BorderSide(
    color: AppColors.rarityOro,
    width: AppBorderWidth.thick,
  );

  static const BorderSide rarityOnix = BorderSide(
    color: AppColors.rarityOnix,
    width: AppBorderWidth.highlight,
  );

  static const BorderSide rarityGloria = BorderSide(
    color: AppColors.sacredGold,
    width: AppBorderWidth.highlight,
  );

  // ── Sin Borde ─────────────────────────────────────────────────────────────

  static const BorderSide none = BorderSide.none;
}

// ─────────────────────────────────────────────────────────────────────────────
// DECORACIONES REUTILIZABLES
// BoxDecoration completas para los patrones más frecuentes.
// Son métodos (no const) para poder adaptar colores al tema activo.
// ─────────────────────────────────────────────────────────────────────────────

/// Decoraciones de BoxDecoration reutilizables del Design System.
///
/// Métodos estáticos para poder crear decoraciones adaptadas al brightness.
abstract final class AppDecorations {
  /// Decoración estándar de tarjeta de contenido.
  static BoxDecoration card({required Brightness brightness}) => BoxDecoration(
    color: brightness == Brightness.light
        ? AppColors.surfaceLight
        : AppColors.surfaceDark,
    borderRadius: AppBorderRadius.md,
    border: Border.all(
      color: brightness == Brightness.light
          ? const Color(0x332D6A4F) // gardenMoss 20%
          : const Color(0x4052B788), // gardenMedium 25%
    ),
  );

  /// Decoración de tarjeta elevada (con sombra). Para tarjetas interactivas.
  static BoxDecoration cardElevated({required Brightness brightness}) =>
      BoxDecoration(
        color: brightness == Brightness.light
            ? AppColors.surfaceLight
            : AppColors.surfaceDark,
        borderRadius: AppBorderRadius.md,
        border: Border.all(
          color: brightness == Brightness.light
              ? const Color(0x1A2D6A4F) // gardenMoss 10%
              : const Color(0x2652B788), // gardenMedium 15%
        ),
      );

  /// Decoración de un avatar de perfil.
  static const BoxDecoration avatar = BoxDecoration(
    color: AppColors.gardenLeaf,
    shape: BoxShape.circle,
  );

  /// Decoración del panel del HUD superior.
  static BoxDecoration hud({required Brightness brightness}) => BoxDecoration(
    color: brightness == Brightness.light
        ? AppColors.gardenDeep
        : const Color(0xFF0D1F17), // backgroundDark más oscuro
    borderRadius: AppBorderRadius.bottomMd,
  );

  /// Decoración del fondo de un minijuego.
  static BoxDecoration minigameBackground({required Color worldColor}) =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [worldColor, AppColors.gardenDeep],
        ),
      );

  /// Decoración de un ítem de rareza Ónix con borde característico.
  static const BoxDecoration rarityOnix = BoxDecoration(
    color: Color(0xFF1A1A1A),
    borderRadius: AppBorderRadius.md,
    border: Border.fromBorderSide(AppBorderSide.rarityOnix),
  );

  /// Decoración de ítem de rareza Gloria (máxima rareza).
  static const BoxDecoration rarityGloria = BoxDecoration(
    color: Color(0xFF2D2416), // Dorado muy oscuro de fondo
    borderRadius: AppBorderRadius.md,
    border: Border.fromBorderSide(AppBorderSide.rarityGloria),
  );

  /// Fondo con gradiente del jardín. Para pantallas de menú principal.
  static const BoxDecoration gardenGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.gardenDeep,
        AppColors.gardenMoss,
        AppColors.gardenDeep,
      ],
      stops: [0.0, 0.5, 1.0],
    ),
  );
}
