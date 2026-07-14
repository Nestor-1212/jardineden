// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_microinteractions.dart
//
// RESPONSABILIDAD:
//   Microinteracciones semánticas de respuesta de minijuegos — "correcto"
//   e "incorrecto". Distintas de las primitivas genéricas (AppScale,
//   AppBounce): estas ya conocen el SIGNIFICADO del feedback y usan
//   exactamente los tokens que core/theme/app_animations.dart reservó para
//   cada uno (AppDurations.correctFeedback/incorrectFeedback,
//   AppCurves.correctPop/shakeVibrate).
//
// "INCORRECTO" YA EXISTE COMO [AppShake] (app_bounce.dart) — no se duplica
// aquí, solo se re-exporta con el nombre semántico [AppIncorrectFeedback]
// para que el código de features futuras lea "incorrecto", no "shake".
//
// ACCESIBILIDAD (ver core/accessibility/color_blind_support.dart):
// Ninguno de estos widgets reemplaza el ícono/texto de resultado — son
// SOLO el movimiento. La regla "color + no-color" sigue siendo
// responsabilidad del widget que muestre el resultado (ícono de check/X).
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, shared/ui/animations/
//                            (AppShake), core/theme/.
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_animations.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';
import 'package:jardindeleden/shared/ui/animations/app_bounce.dart';

/// Pulso de escala para feedback de "¡Correcto!" — cambiar [trigger] (ej.
/// incrementar un contador de aciertos) dispara un nuevo pulso.
class AppCorrectFeedback extends StatefulWidget {
  const AppCorrectFeedback({
    required this.child,
    super.key,
    this.trigger,
    this.duration = AppDurations.correctFeedback,
    this.curve = AppCurves.correctPop,
    this.peakScale = 1.15,
    this.reduceMotion = false,
  });

  final Widget child;
  final Object? trigger;
  final Duration duration;
  final Curve curve;

  /// Escala máxima del pulso. 1.15 es notorio sin deformar el contenido.
  final double peakScale;

  final bool reduceMotion;

  @override
  State<AppCorrectFeedback> createState() => _AppCorrectFeedbackState();
}

class _AppCorrectFeedbackState extends State<AppCorrectFeedback>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

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
    _scale = _buildScaleAnimation();
  }

  Animation<double> _buildScaleAnimation() {
    // Ida y vuelta: 1.0 → peakScale → 1.0, ambas mitades con la misma curva.
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: widget.peakScale).chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.peakScale, end: 1.0).chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(AppCorrectFeedback oldWidget) {
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
  Widget build(BuildContext context) =>
      ScaleTransition(scale: _scale, child: widget.child);
}

/// Feedback de "incorrecto" — alias semántico de [AppShake] preconfigurado
/// con los tokens de incorrecto del Design System.
///
/// Uso: `AppIncorrectFeedback(trigger: wrongAnswerCount, child: OptionCard())`.
class AppIncorrectFeedback extends StatelessWidget {
  const AppIncorrectFeedback({
    required this.child,
    super.key,
    this.trigger,
    this.reduceMotion = false,
  });

  final Widget child;
  final Object? trigger;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    // duration/curve no se pasan explícitos — AppShake ya usa
    // AppDurations.incorrectFeedback/AppCurves.shakeVibrate por defecto.
    return AppShake(
      trigger: trigger,
      reduceMotion: reduceMotion,
      child: child,
    );
  }
}
