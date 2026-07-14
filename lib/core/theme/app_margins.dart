// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_margins.dart
//
// RESPONSABILIDAD:
//   Márgenes de página adaptables — DISTINTO de AppSpacing (que da valores
//   fijos como AppSpacing.md) y de AppBreakpoints.horizontalPadding (que da
//   un solo número por breakpoint). AppMargins combina TRES fuentes en un
//   solo EdgeInsets listo para usar como padding de la pantalla:
//
//   1. El padding horizontal base del breakpoint (AppBreakpoints.horizontalPadding).
//   2. El centrado de contenido en pantallas anchas (AppBreakpoints.maxContentWidth)
//      — en una tablet, el contenido no se estira a los 1024px completos,
//      se limita a 720px y el margen absorbe la diferencia.
//   3. El área segura del sistema (notch, cámara perforada, barra de
//      gestos) en el eje horizontal — relevante en landscape, donde el
//      notch puede estar a un lado en vez de arriba.
//
// QUÉ NO HACE:
//   No reemplaza a SafeArea para el eje VERTICAL (status bar, home
//   indicator) — eso lo sigue resolviendo el widget SafeArea de Flutter en
//   cada pantalla. AppMargins es específicamente el margen HORIZONTAL de
//   contenido, que SafeArea no centra ni limita por sí solo.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart,
//                            core/theme/app_breakpoints.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_breakpoints.dart';

abstract final class AppMargins {
  /// Margen horizontal que centra el contenido dentro de
  /// [AppBreakpoints.maxContentWidth], sin considerar el área segura.
  static double horizontalContentInset(double screenWidth) {
    final basePadding = AppBreakpoints.horizontalPadding(screenWidth);
    final maxContent = AppBreakpoints.maxContentWidth(screenWidth);

    if (maxContent.isInfinite || screenWidth <= maxContent) return basePadding;

    // Pantalla más ancha que el contenido máximo: el margen absorbe la
    // diferencia para centrar, nunca por debajo del padding base.
    final centeringInset = (screenWidth - maxContent) / 2;
    return centeringInset > basePadding ? centeringInset : basePadding;
  }

  /// [EdgeInsets] horizontal completo: centrado de contenido + área segura
  /// del sistema (notch/cámara perforada en landscape).
  static EdgeInsets pageInsets(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final inset = horizontalContentInset(width);
    final safePadding = MediaQuery.paddingOf(context);

    return EdgeInsets.only(
      left: inset + safePadding.left,
      right: inset + safePadding.right,
    );
  }
}

/// Extensión de BuildContext para márgenes de página adaptables.
extension AppMarginsContext on BuildContext {
  /// Márgenes horizontales de página para esta pantalla — ver [AppMargins.pageInsets].
  ///
  /// Uso: `Padding(padding: context.pageMargin, child: ...)`.
  EdgeInsets get pageMargin => AppMargins.pageInsets(this);
}
