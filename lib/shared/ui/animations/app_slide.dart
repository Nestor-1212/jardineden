// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_slide.dart
//
// RESPONSABILIDAD:
//   Primitiva de deslizamiento (slide) de entrada del Design System, sobre
//   los offsets ya definidos en core/theme/app_animations.dart
//   (AppTransitions.enterFromRight/enterFromLeft) más las dos direcciones
//   verticales que ese archivo no cubre (fromBottom/fromTop — usadas por
//   toasts, hojas inferiores y notificaciones, no por transiciones de
//   página completas).
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, core/theme/.
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_animations.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';

/// Dirección desde la que entra el contenido en [AppSlideIn].
enum AppSlideDirection {
  /// AppTransitions.enterFromRight — avanzar en la historia.
  fromRight,

  /// AppTransitions.enterFromLeft — retroceder.
  fromLeft,

  /// Entrada desde abajo — toasts, hojas inferiores, notificaciones.
  fromBottom,

  /// Entrada desde arriba — alertas superiores (ej. Sistema 44).
  fromTop,
}

/// Aparición con deslizamiento — se reproduce una vez al montar el widget.
///
/// Uso: `AppSlideIn(direction: AppSlideDirection.fromBottom, child: Toast())`.
class AppSlideIn extends StatefulWidget {
  const AppSlideIn({
    required this.child,
    super.key,
    this.direction = AppSlideDirection.fromBottom,
    this.duration = AppDurations.pageTransition,
    this.curve = AppTransitions.curveDefault,
    this.delay = Duration.zero,
    this.reduceMotion = false,
  });

  final Widget child;
  final AppSlideDirection direction;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final bool reduceMotion;

  static const Offset _fromBottomOffset = Offset(0.0, 1.0);
  static const Offset _fromTopOffset = Offset(0.0, -1.0);

  Offset get _beginOffset => switch (direction) {
    AppSlideDirection.fromRight => AppTransitions.enterFromRight,
    AppSlideDirection.fromLeft => AppTransitions.enterFromLeft,
    AppSlideDirection.fromBottom => _fromBottomOffset,
    AppSlideDirection.fromTop => _fromTopOffset,
  };

  @override
  State<AppSlideIn> createState() => _AppSlideInState();
}

class _AppSlideInState extends State<AppSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    final duration = context.motionDuration(
      widget.duration,
      appReduceMotionEnabled: widget.reduceMotion,
    );
    _controller = AnimationController(vsync: this, duration: duration);
    _offset = Tween<Offset>(
      begin: widget._beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

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
      SlideTransition(position: _offset, child: widget.child);
}
