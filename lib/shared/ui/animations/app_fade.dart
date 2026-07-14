// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_fade.dart
//
// RESPONSABILIDAD:
//   Primitivas de fade del Design System. Envuelven AnimationController +
//   FadeTransition con las duraciones/curvas de
//   core/theme/app_animations.dart — ningún valor de tiempo se hardcodea
//   aquí ni en quien use estos widgets.
//
// DOS WIDGETS:
//   AppFadeIn      — aparición de entrada, se reproduce una vez al montarse.
//   AppFadeSwitcher — cross-fade entre dos estados del mismo lugar (como
//                     AnimatedSwitcher, preconfigurado con los tokens del
//                     proyecto en vez de valores por defecto de Flutter).
//
// REDUCCIÓN DE MOVIMIENTO:
//   Todo widget de esta librería acepta `reduceMotion` (pásale
//   `accessibility.reduceMotionEnabled` desde AccessibilityController) y
//   además respeta automáticamente la señal del sistema operativo — ver
//   core/theme/app_motion.dart. Con movimiento reducido, el fade no se
//   anima: aparece directo en su estado final.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, core/theme/.
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_animations.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';

/// Aparición con fade — se reproduce una sola vez al montar el widget.
///
/// Uso: `AppFadeIn(child: RewardCard(...))` dentro de una lista o al
/// revelar un elemento nuevo en pantalla.
class AppFadeIn extends StatefulWidget {
  const AppFadeIn({
    required this.child,
    super.key,
    this.duration = AppDurations.normal,
    this.curve = AppCurves.standard,
    this.delay = Duration.zero,
    this.reduceMotion = false,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;

  /// Espera antes de iniciar la animación — útil para efectos escalonados
  /// (stagger) en listas, sumando `index * step` en el widget padre.
  final Duration delay;

  final bool reduceMotion;

  @override
  State<AppFadeIn> createState() => _AppFadeInState();
}

class _AppFadeInState extends State<AppFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    final duration = context.motionDuration(
      widget.duration,
      appReduceMotionEnabled: widget.reduceMotion,
    );
    _controller = AnimationController(vsync: this, duration: duration);
    _opacity = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (duration == Duration.zero) {
      _controller.value = 1.0;
    } else if (widget.delay == Duration.zero) {
      unawaited(_controller.forward());
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) unawaited(_controller.forward());
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FadeTransition(opacity: _opacity, child: widget.child);
}

/// Cross-fade entre el hijo anterior y el nuevo cuando [child] cambia de
/// [Key] — envoltorio de [AnimatedSwitcher] con los tokens del proyecto.
///
/// Uso: resultado de un minijuego que cambia de "esperando" a "¡Correcto!".
class AppFadeSwitcher extends StatelessWidget {
  const AppFadeSwitcher({
    required this.child,
    super.key,
    this.duration = AppDurations.fast,
    this.curve = AppCurves.standard,
    this.reduceMotion = false,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final effectiveDuration = context.motionDuration(
      duration,
      appReduceMotionEnabled: reduceMotion,
    );

    return AnimatedSwitcher(
      duration: effectiveDuration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: child,
    );
  }
}
