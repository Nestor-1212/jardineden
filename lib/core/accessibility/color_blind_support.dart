// ─────────────────────────────────────────────────────────────────────────────
// core/accessibility/color_blind_support.dart
//
// RESPONSABILIDAD:
//   Soporte de daltonismo en DOS capas independientes — la primera es la
//   que realmente garantiza accesibilidad, la segunda es un complemento:
//
//   1. REGLA DE DISEÑO (la que importa de verdad — WCAG 1.4.1 "Use of
//      Color"): NINGÚN significado del juego depende SOLO del color.
//      "Correcto" = verde + AppIcons.correct (check). "Incorrecto" = rojo +
//      AppIcons.incorrect (X). Esto ya funciona para el 100% de los tipos y
//      severidades de daltonismo, sin necesidad de detectar nada. Ver la
//      convención documentada en [ColorMeaningPairing] más abajo.
//
//   2. AJUSTE DE COLOR (complementario, heurístico): cuando el jugador
//      activa un [ColorBlindMode] específico, [AppColorBlindAdjustment]
//      separa tonos que caen sobre el eje de confusión de ese tipo,
//      rotando el matiz (hue) en HSL. Esto NO es una corrección
//      colorimétrica clínicamente calibrada (eso requeriría datos
//      individuales del usuario) — es una heurística razonable que mejora
//      la distinción sin reemplazar la regla #1.
//
// POR QUÉ NO SE IMPLEMENTÓ UN FILTRO DE MATRIZ RGB TIPO "DALTONIZE":
//   Los algoritmos de corrección real (Daltonize/Fidaner) requieren
//   simular la percepción del usuario y redistribuir el error hacia
//   canales que sí perciba — son sensibles a coeficientes calibrados por
//   estudios colorimétricos. Publicar una matriz sin poder validarla contra
//   una fuente autorizada sería peor que no ofrecer nada: podría mover
//   colores en la dirección INCORRECTA para algunos usuarios. La rotación
//   de matiz aquí es deliberadamente conservadora (empeora, en el peor
//   caso, en la misma medida que mejora — nunca invierte una distinción
//   que ya funcionaba).
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart,
//                            core/accessibility/accessibility_settings.dart (ColorBlindMode).
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/accessibility/accessibility_settings.dart';

/// Documentación viva de la convención "color + no-color" del proyecto.
///
/// No es código ejecutable — es la referencia que cualquier widget nuevo
/// debe seguir. Cada feature futura que muestre un estado (correcto/
/// incorrecto/advertencia/info) DEBE combinar el color semántico
/// (AppColors.success/error/warning/info) con el ícono correspondiente
/// (AppIcons.correct/incorrect/warning/info) — nunca el color solo.
///
/// Ejemplo correcto:
/// ```dart
/// Row(children: [
///   Icon(AppIcons.correct, color: AppColors.success),
///   Text('¡Correcto!'),
/// ])
/// ```
///
/// Ejemplo INCORRECTO (falla para daltónicos rojo-verde):
/// ```dart
/// Container(color: AppColors.success) // sin ícono ni texto
/// ```
abstract final class ColorMeaningPairing {}

/// Ajuste heurístico de color para [ColorBlindMode] — ver documentación del
/// archivo para el porqué de este enfoque y sus límites.
abstract final class AppColorBlindAdjustment {
  /// Grados de rotación de matiz. Conservador a propósito (ver doc del archivo).
  static const double _rotation = 18.0;

  /// Boost de luminosidad aplicado junto con la rotación — la separación
  /// de brillo es perceptible para TODOS los tipos de daltonismo, a
  /// diferencia del matiz.
  static const double _lightnessBoost = 0.06;

  /// Ajusta [color] para [mode]. Retorna [color] sin cambios si
  /// `mode == ColorBlindMode.none`.
  static Color adjust(Color color, ColorBlindMode mode) {
    if (!mode.isActive) return color;

    final hsl = HSLColor.fromColor(color);
    final rotation = _rotationFor(mode, hsl.hue);
    if (rotation == 0) return color;

    final adjustedHue = (hsl.hue + rotation) % 360;
    final adjustedLightness = (hsl.lightness + _lightnessBoost).clamp(0.0, 1.0);

    return hsl.withHue(adjustedHue).withLightness(adjustedLightness).toColor();
  }

  /// Aplica [adjust] a los colores semánticos de un [ColorScheme] completo.
  ///
  /// Uso esperado: `AppTheme.light.copyWith(colorScheme:
  /// AppColorBlindAdjustment.adjustScheme(AppTheme.light.colorScheme, mode))`.
  static ColorScheme adjustScheme(ColorScheme scheme, ColorBlindMode mode) {
    if (!mode.isActive) return scheme;

    return scheme.copyWith(
      primary: adjust(scheme.primary, mode),
      secondary: adjust(scheme.secondary, mode),
      tertiary: adjust(scheme.tertiary, mode),
      error: adjust(scheme.error, mode),
    );
  }

  /// Rotación en grados para [hue] (0-360) bajo [mode]. 0 = sin ajuste
  /// (el matiz ya está fuera del eje de confusión de ese tipo).
  static double _rotationFor(ColorBlindMode mode, double hue) {
    switch (mode) {
      case ColorBlindMode.protanopia:
      case ColorBlindMode.deuteranopia:
        // Eje de confusión rojo-verde (~0°-150°). Se separan rotando rojos
        // hacia naranja y verdes hacia cian — direcciones opuestas, sobre
        // el eje azul-amarillo que ambos tipos perciben con normalidad.
        if (hue < 75) return _rotation;
        if (hue < 150) return -_rotation;
        return 0;
      case ColorBlindMode.tritanopia:
        // Eje de confusión azul-amarillo (~60° y ~240°). Se separan sobre
        // el eje rojo-verde, que la tritanopia no afecta.
        if (hue > 180 && hue < 260) return _rotation;
        if (hue > 40 && hue < 90) return -_rotation;
        return 0;
      case ColorBlindMode.none:
        return 0;
    }
  }
}
