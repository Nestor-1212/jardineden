// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_scale.dart
//
// RESPONSABILIDAD:
//   Primitivas de escala del Design System.
//
// DOS WIDGETS:
//   AppScaleIn        — aparición "pop" de entrada (0 → 1), una sola vez.
//   AppPressableScale — MICROINTERACCIÓN: reduce la escala mientras el
//                       usuario mantiene presionado, vuelve al soltar. Es
//                       el feedback táctil que hace sentir "físico" cualquier
//                       elemento tocable (tarjetas, íconos, botones custom)
//                       sin reimplementar el gesto en cada feature.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, core/theme/.
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_animations.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';

/// Aparición "pop" de entrada — escala de 0 a 1, una sola vez al montar.
///
/// Uso: revelar una recompensa o un ítem de colección nuevo.
class AppScaleIn extends StatefulWidget {
  const AppScaleIn({
    required this.child,
    super.key,
    this.duration = AppDurations.medium,
    this.curve = AppCurves.spring,
    this.delay = Duration.zero,
    this.reduceMotion = false,
  });

  final Widget child;
  final Duration duration;

  /// [AppCurves.spring] (elástico) por defecto — transmite energía juvenil,
  /// apropiado para recompensas. Usar [AppCurves.standard] para apariciones
  /// neutras que no deben sentirse "juguetonas".
  final Curve curve;
  final Duration delay;
  final bool reduceMotion;

  @override
  State<AppScaleIn> createState() => _AppScaleInState();
}

class _AppScaleInState extends State<AppScaleIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    final duration = context.motionDuration(
      widget.duration,
      appReduceMotionEnabled: widget.reduceMotion,
    );
    _controller = AnimationController(vsync: this, duration: duration);
    _scale = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (duration == Duration.zero) {
      _controller.value = 1.0;
    } else if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
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
      ScaleTransition(scale: _scale, child: widget.child);
}

/// Escala interactiva al tocar — la microinteracción de "presionar" del
/// Design System. Envuelve [child] en un [GestureDetector] que lo encoge
/// levemente mientras está presionado.
///
/// Uso: `AppPressableScale(onTap: ..., child: MyCard())` en cualquier
/// elemento tocable que no sea ya un botón Material (que tiene su propio
/// feedback de ripple).
class AppPressableScale extends StatefulWidget {
  const AppPressableScale({
    required this.child,
    super.key,
    this.onTap,
    this.pressedScale = 0.95,
    this.duration = AppDurations.veryFast,
    this.reduceMotion = false,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Factor de escala mientras está presionado. 0.95 es sutil a propósito
  /// — un encogimiento agresivo se siente "roto", no responsivo.
  final double pressedScale;

  final Duration duration;
  final bool reduceMotion;

  @override
  State<AppPressableScale> createState() => _AppPressableScaleState();
}

class _AppPressableScaleState extends State<AppPressableScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: context.motionDuration(
        widget.duration,
        appReduceMotionEnabled: widget.reduceMotion,
      ),
      lowerBound: widget.pressedScale,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) => _controller.forward(),
      onTapCancel: () => _controller.forward(),
      onTap: widget.onTap,
      child: ScaleTransition(scale: _controller, child: widget.child),
    );
  }
}
