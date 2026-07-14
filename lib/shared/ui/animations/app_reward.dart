// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_reward.dart
//
// RESPONSABILIDAD:
//   Composiciones de animación para recompensas del juego — construidas
//   sobre las primitivas de este mismo directorio (AppFlip) y los tokens de
//   core/theme/app_animations.dart pensados específicamente para esto
//   (AppDurations.coinFloat/cardFlip, AppCurves.coinFloat/cardFlip).
//
// DOS WIDGETS:
//   AppCoinFloat  — la moneda recogida flota hacia arriba y se desvanece.
//   AppCardReveal — una carta (versículo, ítem de colección) se voltea de
//                   su reverso al contenido real tras una pequeña pausa de
//                   suspenso — composición sobre [AppFlip].
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, shared/ui/animations/
//                            (AppFlip), core/theme/.
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_animations.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';
import 'package:jardindeleden/shared/ui/animations/app_rotation.dart';

/// Moneda (o cualquier ícono de recompensa) que flota hacia arriba
/// [floatDistance] px mientras se desvanece — feedback de "recompensa
/// recogida". Llama a [onCompleted] al terminar para que la feature
/// remueva el widget de su árbol.
class AppCoinFloat extends StatefulWidget {
  const AppCoinFloat({
    required this.child,
    super.key,
    this.floatDistance = 60.0,
    this.duration = AppDurations.coinFloat,
    this.curve = AppCurves.coinFloat,
    this.onCompleted,
    this.reduceMotion = false,
  });

  final Widget child;
  final double floatDistance;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onCompleted;
  final bool reduceMotion;

  @override
  State<AppCoinFloat> createState() => _AppCoinFloatState();
}

class _AppCoinFloatState extends State<AppCoinFloat> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rise;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    final duration = context.motionDuration(
      widget.duration,
      appReduceMotionEnabled: widget.reduceMotion,
    );
    _controller = AnimationController(vsync: this, duration: duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onCompleted?.call();
      });

    _rise = Tween<double>(begin: 0.0, end: -widget.floatDistance).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    // El desvanecimiento ocurre en la segunda mitad del recorrido — la
    // moneda debe verse sólida mientras sube, no desvanecerse desde el inicio.
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ).drive(Tween<double>(begin: 1.0, end: 0.0));

    _controller.forward();
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
        child: Transform.translate(offset: Offset(0, _rise.value), child: child),
      ),
      child: widget.child,
    );
  }
}

/// Revela [revealed] volteando desde [hidden] (el reverso) tras
/// [suspenseDelay] — composición sobre [AppFlip] con auto-disparo, sin
/// necesitar que el padre controle un booleano de estado.
///
/// Uso: revelar un versículo "Grabado en el Corazón" o un ítem de colección
/// nuevo — el reverso genérico se muestra primero para generar expectativa.
class AppCardReveal extends StatefulWidget {
  const AppCardReveal({
    required this.hidden,
    required this.revealed,
    super.key,
    this.suspenseDelay = const Duration(milliseconds: 400),
    this.duration = AppDurations.cardFlip,
    this.curve = AppCurves.cardFlip,
    this.onRevealed,
    this.reduceMotion = false,
  });

  /// Lo que se ve ANTES de revelar (reverso de la carta).
  final Widget hidden;

  /// Lo que se ve DESPUÉS de revelar (contenido real).
  final Widget revealed;

  final Duration suspenseDelay;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onRevealed;
  final bool reduceMotion;

  @override
  State<AppCardReveal> createState() => _AppCardRevealState();
}

class _AppCardRevealState extends State<AppCardReveal> {
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    final delay = context.motionDuration(
      widget.suspenseDelay,
      appReduceMotionEnabled: widget.reduceMotion,
    );
    Future.delayed(delay, () {
      if (!mounted) return;
      setState(() => _isRevealed = true);
      widget.onRevealed?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    // AppFlip ya resuelve reduceMotion internamente para su propia
    // duración — no hace falta repetir el cálculo aquí.
    return AppFlip(
      flipped: _isRevealed,
      front: widget.hidden,
      back: widget.revealed,
      duration: widget.duration,
      curve: widget.curve,
      reduceMotion: widget.reduceMotion,
    );
  }
}
