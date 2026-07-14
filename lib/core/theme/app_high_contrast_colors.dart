// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_high_contrast_colors.dart
//
// RESPONSABILIDAD:
//   Paleta de alto contraste — texto y superficies en extremos de la escala
//   de luminosidad (blanco/negro puros) para maximizar la relación de
//   contraste. Objetivo: cumplir WCAG 2.1 AA (≥4.5:1 texto normal, ≥3:1
//   texto grande/componentes gráficos) con margen amplio, no al límite.
//
// POR QUÉ NEGRO/BLANCO PUROS Y NO UNA VARIANTE MÁS SUAVE DE AppColors:
//   Cualquier gris intermedio reduce el contraste medible. Alto contraste
//   es, por definición, el modo que sacrifica la estética de marca por
//   legibilidad máxima — es lo que un usuario con baja visión activa
//   precisamente porque la paleta normal no le funciona.
//
// CÓMO SE CONSTRUYE EL ThemeData (limitación documentada):
//   En vez de reimplementar los ~24 builders privados de AppTheme (appBar,
//   card, botones, etc.), este archivo toma AppTheme.light/dark YA
//   CONSTRUIDO y le reemplaza el ColorScheme — la mayoría de los
//   componentes Material 3 heredan color de `Theme.colorScheme` por
//   defecto, así que el reemplazo se propaga. EXCEPCIÓN: si algún builder
//   de AppTheme referencia un Color de AppColors directamente (en vez de
//   `colorScheme.xyz`), ese componente específico NO se verá afectado por
//   este archivo. Auditar AppTheme para eliminar esos casos queda como
//   tarea de un Sprint de accesibilidad visual dedicado — no se hizo aquí
//   para no reescribir un archivo de 1450 líneas sin verificación visual.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, core/theme/app_theme.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_theme.dart';

abstract final class AppHighContrastColors {
  // ── Superficies ───────────────────────────────────────────────────────────

  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF000000);

  // ── Texto (negro/blanco puros — contraste 21:1) ──────────────────────────

  static const Color onSurfaceLight = Color(0xFF000000);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);

  // ── Colores de Marca (oscurecidos/aclarados para cumplir AA) ────────────

  /// Verde oscurecido — contraste ≥4.5:1 sobre blanco puro.
  static const Color primaryLight = Color(0xFF0B4D33);

  /// Verde aclarado — contraste ≥4.5:1 sobre negro puro.
  static const Color primaryDark = Color(0xFF6FFFB0);

  // ── Estado (rojo/ámbar de alto contraste estándar) ───────────────────────

  static const Color errorLight = Color(0xFFB00020);
  static const Color errorDark = Color(0xFFFF6679);
}

/// Construye variantes de alto contraste de [AppTheme.light]/[AppTheme.dark]
/// reemplazando su [ColorScheme] — ver limitación documentada arriba.
abstract final class AppHighContrastTheme {
  static ThemeData get light => AppTheme.light.copyWith(
    colorScheme: AppTheme.light.colorScheme.copyWith(
      brightness: Brightness.light,
      surface: AppHighContrastColors.surfaceLight,
      onSurface: AppHighContrastColors.onSurfaceLight,
      primary: AppHighContrastColors.primaryLight,
      onPrimary: AppHighContrastColors.backgroundLight,
      error: AppHighContrastColors.errorLight,
      onError: AppHighContrastColors.backgroundLight,
    ),
    scaffoldBackgroundColor: AppHighContrastColors.backgroundLight,
  );

  static ThemeData get dark => AppTheme.dark.copyWith(
    colorScheme: AppTheme.dark.colorScheme.copyWith(
      brightness: Brightness.dark,
      surface: AppHighContrastColors.surfaceDark,
      onSurface: AppHighContrastColors.onSurfaceDark,
      primary: AppHighContrastColors.primaryDark,
      onPrimary: AppHighContrastColors.backgroundDark,
      error: AppHighContrastColors.errorDark,
      onError: AppHighContrastColors.backgroundDark,
    ),
    scaffoldBackgroundColor: AppHighContrastColors.backgroundDark,
  );
}
