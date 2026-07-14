// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_bounce.dart
//
// RESPONSABILIDAD:
//   Primitivas de rebote del Design System — dos casos de uso bien
//   distintos que comparten la física de "rebote":
//
//   AppBounceIn — caída con rebote al aterrizar. Es exactamente lo que
//                 core/theme/app_animations.dart documenta para
//                 AppCurves.bounce: "caída de ítems coleccionables al
//                 inventario". Distinto de AppScaleIn (que hace un pop
//                 elástico EN EL LUGAR, sin desplazamiento vertical).
//   AppShake    — feedback de "incorrecto": oscilación horizontal con
//                 decaimiento, sobre AppDurations.incorrectFeedback /
//                 AppCurves.shakeVibrate.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, dart:math, core/theme/.
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_animations.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';

/// Caída con rebote al aterrizar — un ítem "cae" [dropDistance] px y rebota
/// al llegar a su posición final, usando [AppCurves.bounce].
///
/// Uso: un ítem nuevo apareciendo en el inventario o la colección.
class AppBounceIn extends StatefulWidget {
  const AppBounceIn({
    required this.child,
    super.key,
    this.duration = AppDurations.medium,
    this.curve = AppCurves.bounce,
    this.dropDistance = 40.0,
    this.delay = Duration.zero,
    this.reduceMotion = false,
  });

  final Widget child;

  /// AppDurations no tiene una constante dedicada a "caída con rebote" —
  /// [AppDurations.medium] (400ms) es la duración de contenido genérica más
  /// cercana. Si un Sprint futuro agrega una constante específica, se
  /// actualiza aquí y solo aquí.
  final Duration duration;

  final Curve curve;
  final double dropDistance;
  final Duration delay;
  final bool reduceMotion;

  @override
  State<AppBounceIn> createState() => _AppBounceInState();
}

class _AppBounceInState extends State<AppBounceIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _drop;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    final duration = context.motionDuration(
      widget.duration,
      appReduceMotionEnabled: widget.reduceMotion,
    );
    _controller = AnimationController(vsync: this, duration: duration);
    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);
    _drop = Tween<double>(begin: -widget.dropDistance, end: 0.0).animate(curved);
    // El fade usa una curva más corta y neutra — el rebote de la posición
    // ya transmite la energía; la opacidad solo necesita dejar de ser 0.
    _opacity = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4));

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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(offset: Offset(0, _drop.value), child: child),
      ),
      child: widget.child,
    );
  }
}

/// Feedback de "incorrecto" — oscilación horizontal con decaimiento.
///
/// Cambiar [trigger] (ej. incrementar un contador cada vez que el jugador
/// responde mal) dispara un nuevo shake — no hace falta desmontar/remontar
/// el widget.
class AppShake extends StatefulWidget {
  const AppShake({
    required this.child,
    super.key,
    this.trigger,
    this.duration = AppDurations.incorrectFeedback,
    this.curve = AppCurves.shakeVibrate,
    this.amplitude = 8.0,
    this.oscillations = 4,
    this.reduceMotion = false,
  });

  final Widget child;

  /// Cualquier valor que cambie de identidad dispara el shake — ver
  /// [didUpdateWidget].
  final Object? trigger;

  final Duration duration;
  final Curve curve;
  final double amplitude;
  final int oscillations;
  final bool reduceMotion;

  @override
  State<AppShake> createState() => _AppShakeState();
}

class _AppShakeState extends State<AppShake> with SingleTickerProviderStateMixin {
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
    );
  }

  @override
  void didUpdateWidget(AppShake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger && _controller.duration != Duration.zero) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = widget.curve.transform(_controller.value);
        final decay = 1 - progress;
        final offsetX = widget.amplitude *
            decay *
            math.sin(progress * widget.oscillations * 2 * math.pi);
        return Transform.translate(offset: Offset(offsetX, 0), child: child);
      },
      child: widget.child,
    );
  }
}
