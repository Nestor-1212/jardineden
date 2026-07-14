// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_responsive_spacing.dart
//
// RESPONSABILIDAD:
//   Espaciado ENTRE elementos (gutters de grid, separación entre
//   secciones) que crece con el tamaño de pantalla — DISTINTO de:
//
//   • AppSpacing    → valores fijos de la escala de 4px (AppSpacing.md).
//     Sigue siendo la fuente de los valores reales; este archivo solo
//     decide CUÁL constante de AppSpacing usar según el breakpoint.
//   • AppMargins    → margen entre el CONTENIDO y el BORDE de la pantalla.
//     Este archivo es el espacio ENTRE elementos DENTRO del contenido.
//
// POR QUÉ EL GUTTER CRECE EN TABLET:
//   Una cuadrícula de 4 columnas con el mismo gutter de 16px que un
//   teléfono de 1 columna se ve apretada — el espacio entre tarjetas debe
//   crecer junto con el espacio disponible, no quedar fijo.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart,
//                            core/theme/app_breakpoints.dart,
//                            core/theme/app_spacing.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_breakpoints.dart';
import 'package:jardindeleden/core/theme/app_spacing.dart';

abstract final class AppResponsiveSpacing {
  /// Espacio entre elementos de una cuadrícula/lista (gutter) según [ScreenSize].
  static double gutter(ScreenSize screenSize) => switch (screenSize) {
        ScreenSize.compactPhone => AppSpacing.sm,
        ScreenSize.phone => AppSpacing.md,
        ScreenSize.phablet => AppSpacing.md,
        ScreenSize.tablet => AppSpacing.lg,
        ScreenSize.largeTablet => AppSpacing.xl,
      };

  /// Espacio vertical entre secciones de una pantalla según [ScreenSize].
  static double sectionGap(ScreenSize screenSize) => switch (screenSize) {
        ScreenSize.compactPhone => AppSpacing.lg,
        ScreenSize.phone => AppSpacing.xl,
        ScreenSize.phablet => AppSpacing.xl,
        ScreenSize.tablet => AppSpacing.xxl,
        ScreenSize.largeTablet => AppSpacing.xxxl,
      };
}

/// Extensión de BuildContext para espaciado adaptable entre elementos.
extension AppResponsiveSpacingContext on BuildContext {
  /// Gutter de grid/lista para el tamaño de pantalla actual.
  double get responsiveGutter => AppResponsiveSpacing.gutter(screenSize);

  /// Espacio entre secciones para el tamaño de pantalla actual.
  double get responsiveSectionGap => AppResponsiveSpacing.sectionGap(screenSize);
}
