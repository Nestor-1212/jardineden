// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/media/app_lottie_animation.dart
//
// RESPONSABILIDAD:
//   Reproduce animaciones Lottie (.json) del Design System — ver
//   assets/core/animations/lottie/ y AssetPaths.anim*/animWorldLottie.
//   Envuelve package:lottie para que ningún widget del proyecto lo importe
//   directamente, y para aplicar reducción de movimiento de forma
//   consistente (ver core/theme/app_motion.dart, ya construido en el
//   Sprint de accesibilidad).
//
// REDUCCIÓN DE MOVIMIENTO:
//   Con `reduceMotion` activo (señal del sistema o
//   AccessibilitySettings.reduceMotionEnabled), la animación NO se
//   reproduce — se muestra congelada en su primer cuadro. Distinto de
//   AppSpinner (core/theme, animaciones de carga): un Lottie decorativo
//   (celebración, confeti) no comunica información funcional, así que
//   congelarlo es seguro — a diferencia de un indicador de carga.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, package:lottie,
//                            core/theme/ (AppMotion).
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';
import 'package:lottie/lottie.dart';

/// Animación Lottie del Design System — ver documentación del archivo.
class AppLottieAnimation extends StatelessWidget {
  const AppLottieAnimation(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.reduceMotion = false,
    this.onLoaded,
  });

  /// Path del asset — usar una constante de AssetPaths.anim*.
  final String assetPath;

  final double? width;
  final double? height;
  final BoxFit fit;

  /// `true` para loop indefinido (ej. loading), `false` para una sola
  /// pasada (ej. celebración de logro).
  final bool repeat;

  final bool reduceMotion;

  final void Function(LottieComposition)? onLoaded;

  @override
  Widget build(BuildContext context) {
    final shouldAnimate = !(context.systemPrefersReducedMotion || reduceMotion);

    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
      animate: shouldAnimate,
      onLoaded: onLoaded,
    );
  }
}
