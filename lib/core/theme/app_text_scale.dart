// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_text_scale.dart
//
// RESPONSABILIDAD:
//   Escalado de texto en DOS ejes independientes que NUNCA deben mezclarse
//   en un mismo cálculo:
//
//   1. ACCESIBILIDAD DEL SISTEMA (TextScaler del SO — "texto grande" en
//      ajustes de accesibilidad). Flutter ya aplica esto automáticamente a
//      TODO widget Text/RichText vía el MediaQuery ambiental — NO se
//      multiplica a mano en ningún TextStyle. Lo único que hace este
//      archivo es ACOTARLO (clamp) para que un ajuste extremo del sistema
//      no rompa el HUD del juego (números que no caben, botones que se
//      desbordan). Ver [clampSystemScaler] y su uso en main.dart.
//
//   2. TAMAÑO DE PANTALLA (breakpoint). Independiente de accesibilidad —
//      en una tablet, el texto base se ve pequeño a la distancia típica de
//      lectura aunque el usuario no haya tocado ningún ajuste. Este SÍ se
//      aplica manualmente sobre un TextStyle vía [AppTextScale.scale].
//
// POR QUÉ NO SE MEZCLAN:
//   Si [AppTextScale.scale] también multiplicara por el TextScaler del
//   sistema, un usuario con accesibilidad al 130% en una tablet vería el
//   font-size multiplicado DOS veces (una por Flutter automáticamente, otra
//   a mano aquí) — bug clásico de escalado de texto duplicado.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart,
//                            core/theme/app_breakpoints.dart (ScreenSize).
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_breakpoints.dart';

abstract final class AppTextScale {
  // ── Acotamiento del TextScaler del Sistema ───────────────────────────────

  /// Límite inferior del TextScaler del sistema.
  ///
  /// Por debajo de esto, texto crítico (botones, HUD) se vuelve ilegible en
  /// niños que ya de por sí tienen dificultad leyendo textos pequeños.
  static const double minSystemScale = 0.85;

  /// Límite superior del TextScaler del sistema.
  ///
  /// Suficientemente generoso para accesibilidad real (160% es "texto muy
  /// grande" en la mayoría de configuraciones de SO), pero acotado para que
  /// el HUD (contadores, botones de tamaño fijo) no se desborde.
  static const double maxSystemScale = 1.6;

  /// Acota un [TextScaler] arbitrario a [minSystemScale]–[maxSystemScale].
  ///
  /// Uso preferido: envolver la raíz de la app una sola vez con
  /// `MediaQuery.withClampedTextScaling(minScaleFactor: AppTextScale.minSystemScale,
  /// maxScaleFactor: AppTextScale.maxSystemScale, child: ...)` — ver main.dart.
  /// Esta función existe para el caso raro de necesitar acotar un subárbol
  /// específico con un TextScaler ya obtenido.
  static TextScaler clampSystemScaler(TextScaler scaler) => scaler.clamp(
    minScaleFactor: minSystemScale,
    maxScaleFactor: maxSystemScale,
  );

  // ── Escalado por Tamaño de Pantalla ───────────────────────────────────────

  /// Multiplicador de fontSize según [ScreenSize] — eje independiente del
  /// TextScaler de accesibilidad (ver documentación del archivo).
  static double breakpointFactor(ScreenSize screenSize) => switch (screenSize) {
    ScreenSize.compactPhone => 0.95,
    ScreenSize.phone => 1.0,
    ScreenSize.phablet => 1.05,
    ScreenSize.tablet => 1.1,
    ScreenSize.largeTablet => 1.15,
  };

  /// Retorna [style] con su fontSize multiplicado por [breakpointFactor].
  ///
  /// Si `style.fontSize` es null, retorna [style] sin modificar.
  static TextStyle scale(TextStyle style, ScreenSize screenSize) {
    final fontSize = style.fontSize;
    if (fontSize == null) return style;
    return style.copyWith(fontSize: fontSize * breakpointFactor(screenSize));
  }
}

/// Extensión de BuildContext para escalado de texto por tamaño de pantalla.
extension AppTextScaleContext on BuildContext {
  /// Retorna [style] escalado para el tamaño de pantalla actual.
  ///
  /// Ejemplo: `Text('Hola', style: context.scaledTextStyle(AppTextStyles.h1))`.
  TextStyle scaledTextStyle(TextStyle style) =>
      AppTextScale.scale(style, screenSize);
}
