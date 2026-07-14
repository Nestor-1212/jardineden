// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_rotation.dart
//
// RESPONSABILIDAD:
//   Primitivas de rotación del Design System.
//
// TRES WIDGETS:
//   AppRotateIn — entrada: rota levemente mientras aparece (efecto "asentarse").
//   AppSpinner  — rotación continua indefinida (indicadores de carga).
//   AppFlip     — flip 3D en eje Y entre `front` y `back` (revelar carta,
//                 ítem, versículo) — ver core/theme/app_animations.dart,
//                 AppDurations.cardFlip / AppCurves.cardFlip.
//
// POR QUÉ AppSpinner NO RESPETA reduceMotion:
//   Un spinner de carga es FUNCIONAL, no decorativo — es la única señal de
//   "la app está trabajando". Quitar la animación sin reemplazarla por otro
//   indicador dejaría al usuario sin saber si algo está pasando. Ver la
//   distinción documentada en core/theme/app_motion.dart ("QUÉ NO HACE").
//   Si una pantalla futura necesita una alternativa estática para
//   reduceMotion, debe proveer su propio indicador — no es responsabilidad
//   de este widget genérico.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, core/theme/.
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_animations.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';

/// Entrada con rotación sutil + fade — efecto "asentarse en su lugar".
///
/// Uso: aparición de un ícono de logro o badge de rareza.
class AppRotateIn extends StatefulWidget {
  const AppRotateIn({
    required this.child,
    super.key,
    this.duration = AppDurations.medium,
    this.curve = AppCurves.emphasizedDecelerate,
    this.beginTurns = -0.05,
    this.reduceMotion = false,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;

  /// Ángulo inicial en fracciones de vuelta completa (turns). -0.05 = -18°.
  /// Sutil a propósito — una rotación grande se ve como un error visual,
  /// no como una animación de entrada intencional.
  final double beginTurns;

  final bool reduceMotion;

  @override
  State<AppRotateIn> createState() => _AppRotateInState();
}

class _AppRotateInState extends State<AppRotateIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
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
    _rotation = Tween<double>(
      begin: widget.beginTurns,
      end: 0.0,
    ).animate(curved);
    _opacity = curved;

    if (duration == Duration.zero) {
      _controller.value = 1.0;
    } else {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: RotationTransition(turns: _rotation, child: widget.child),
    );
  }
}

/// Rotación continua indefinida — indicador de carga del Design System.
///
/// Uso: `AppSpinner(child: Icon(AppIcons.sync))` mientras se sincroniza
/// o se carga contenido.
class AppSpinner extends StatefulWidget {
  const AppSpinner({
    required this.child,
    super.key,
    this.period = const Duration(seconds: 1, milliseconds: 200),
  });

  final Widget child;

  /// Duración de una vuelta completa. No usa AppDurations porque ninguna
  /// constante ahí modela un período de repetición indefinida (todas son
  /// duraciones de eventos que terminan) — 1200ms es la referencia estándar
  /// de indicadores de carga de Material 3.
  final Duration period;

  @override
  State<AppSpinner> createState() => _AppSpinnerState();
}

class _AppSpinnerState extends State<AppSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period);
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      RotationTransition(turns: _controller, child: widget.child);
}

/// Flip 3D en eje Y entre [front] y [back], controlado por [flipped].
///
/// Uso: `AppFlip(flipped: isRevealed, front: CardBack(), back: VerseCard())`
/// — cambiar [flipped] desde el padre dispara la animación automáticamente.
class AppFlip extends StatefulWidget {
  const AppFlip({
    required this.flipped,
    required this.front,
    required this.back,
    super.key,
    this.duration = AppDurations.cardFlip,
    this.curve = AppCurves.cardFlip,
    this.reduceMotion = false,
  });

  final bool flipped;
  final Widget front;
  final Widget back;
  final Duration duration;
  final Curve curve;
  final bool reduceMotion;

  @override
  State<AppFlip> createState() => _AppFlipState();
}

class _AppFlipState extends State<AppFlip> with SingleTickerProviderStateMixin {
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
      value: widget.flipped ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(AppFlip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flipped != oldWidget.flipped) {
      if (_controller.duration == Duration.zero) {
        _controller.value = widget.flipped ? 1.0 : 0.0;
      } else if (widget.flipped) {
        unawaited(_controller.forward());
      } else {
        unawaited(_controller.reverse());
      }
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
      builder: (context, _) {
        final animationValue = widget.curve.transform(_controller.value);
        final isShowingFront = animationValue < 0.5;
        // Ambas mitades usan la misma matriz de perspectiva para que el
        // "encuentro" a los 90° no muestre un salto de escala.
        final rotationValue = isShowingFront
            ? animationValue * math.pi
            : (animationValue - 1.0) * math.pi;

        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(rotationValue);

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: isShowingFront ? widget.front : widget.back,
        );
      },
    );
  }
}
