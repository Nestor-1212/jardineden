// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_icon_scale.dart
//
// RESPONSABILIDAD:
//   Escala los tamaños base de ícono (AppSpacing.icon*) según el tamaño de
//   pantalla. Un ícono de 24px se ve correcto en un teléfono y diminuto en
//   una tablet de 11" sostenida a la distancia típica de uso.
//
// POR QUÉ NO SIGUE EL TextScaler DEL SISTEMA:
//   Los íconos NO deben crecer con la accesibilidad de TEXTO del usuario —
//   son elementos gráficos, no texto. Si un ícono necesita ser más grande
//   por accesibilidad (objetivo táctil mínimo), eso ya está cubierto por
//   AppSpacing.touchTargetMin (44pt) en el ÁREA tocable del botón que lo
//   contiene, no en el ícono en sí. Mezclar ambos criterios produciría
//   íconos desproporcionados a los botones que los rodean.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart,
//                            core/theme/app_breakpoints.dart (ScreenSize).
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_breakpoints.dart';

abstract final class AppIconScale {
  /// Multiplicador de tamaño de ícono según [ScreenSize].
  ///
  /// Escala más conservadora que AppTextScale.breakpointFactor — los
  /// íconos no necesitan crecer tanto como el texto para seguir siendo
  /// reconocibles (la forma, no el detalle fino, es lo que se lee).
  static double factorFor(ScreenSize screenSize) => switch (screenSize) {
        ScreenSize.compactPhone => 0.9,
        ScreenSize.phone => 1.0,
        ScreenSize.phablet => 1.0,
        ScreenSize.tablet => 1.15,
        ScreenSize.largeTablet => 1.25,
      };

  /// Retorna [baseSize] (usar una constante de AppSpacing.icon*) escalado
  /// para [screenSize].
  static double of(double baseSize, ScreenSize screenSize) =>
      baseSize * factorFor(screenSize);
}

/// Extensión de BuildContext para escalado de íconos por tamaño de pantalla.
extension AppIconScaleContext on BuildContext {
  /// Retorna [baseSize] (usar AppSpacing.icon*) escalado para esta pantalla.
  ///
  /// Ejemplo: `Icon(AppIcons.play, size: context.scaledIconSize(AppSpacing.iconLg))`.
  double scaledIconSize(double baseSize) =>
      AppIconScale.of(baseSize, screenSize);
}
