// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/media/app_rive_animation.dart
//
// RESPONSABILIDAD:
//   Reproduce animaciones Rive (.riv) del Design System — ver
//   assets/characters/*/animations/rive/, assets/worlds/*/animations/rive/
//   y AssetPaths.animCharacterRive/animWorldRive/animUiRive.
//
// RIVE VS. LOTTIE — CUÁNDO USAR CADA UNO:
//   Lottie   → reproduce una animación fija, sin reaccionar a nada. Ideal
//              para celebraciones, loading, confeti (ver AppLottieAnimation).
//   Rive     → animación con STATE MACHINE — reacciona a input en tiempo
//              real (ej. Lumi mirando hacia donde el jugador toca, un
//              personaje cambiando de expresión según el estado del juego).
//              Es el formato PRIMARIO de personajes mientras Spine espera
//              licencia (ver nota en pubspec.yaml).
//
// REDUCCIÓN DE MOVIMIENTO:
//   Igual que AppLottieAnimation: con `reduceMotion` activo, no se
//   reproducen animaciones de línea de tiempo (`animations`), pero los
//   STATE MACHINES sí se mantienen activos si se proveen — reaccionar a un
//   toque es una respuesta funcional puntual, no un loop decorativo
//   continuo, así que no aplica el mismo criterio (ver
//   core/theme/app_motion.dart, "QUÉ NO HACE").
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, package:rive,
//                            core/theme/ (AppMotion).
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';
import 'package:rive/rive.dart';

/// Animación Rive del Design System — ver documentación del archivo.
class AppRiveAnimation extends StatelessWidget {
  const AppRiveAnimation(
    this.assetPath, {
    super.key,
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit = BoxFit.contain,
    this.reduceMotion = false,
    this.placeholder,
  });

  /// Path del asset — usar una constante de AssetPaths.animCharacterRive/
  /// animWorldRive/animUiRive.
  final String assetPath;

  /// Artboard a usar; el artboard por defecto del archivo si es `null`.
  final String? artboard;

  /// Animaciones de línea de tiempo a reproducir — se omiten si
  /// [reduceMotion] está activo (ver documentación del archivo).
  final List<String> animations;

  /// State machines a activar — se mantienen activos incluso con
  /// [reduceMotion] (reaccionan a input puntual, no son un loop decorativo).
  final List<String> stateMachines;

  final BoxFit fit;
  final bool reduceMotion;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final shouldAnimateTimeline =
        !(context.systemPrefersReducedMotion || reduceMotion);

    return RiveAnimation.asset(
      assetPath,
      artboard: artboard,
      animations: shouldAnimateTimeline ? animations : const [],
      stateMachines: stateMachines,
      fit: fit,
      placeHolder: placeholder,
    );
  }
}
