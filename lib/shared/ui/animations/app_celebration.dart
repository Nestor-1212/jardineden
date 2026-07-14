// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_celebration.dart
//
// RESPONSABILIDAD:
//   Composición visual de una celebración (subir de nivel, completar un
//   mundo) — SOLO la animación, no la lógica de cuándo mostrarla ni cómo
//   se monta en pantalla (eso decide la feature que la use: un Dialog, un
//   overlay en un Stack, una ruta completa — esto no lo impone).
//
// SECUENCIA (sobre AppDurations.celebration = 1200ms):
//   1. Scrim (fondo oscuro semitransparente) hace fade-in.
//   2. [child] (el contenido central — insignia, trofeo, texto de logro)
//      aparece con un pop elástico (AppCurves.levelUpPop).
//   3. [backgroundEffect] opcional (confeti/partículas — Sprint de Assets:
//      un Lottie) se muestra detrás de [child] durante toda la secuencia.
//   4. Al terminar la animación de entrada, se llama [onCompleted] — la
//      feature decide qué pasa después (esperar un toque, auto-cerrar).
//
// POR QUÉ backgroundEffect ES Widget? Y NO UN PARÁMETRO DE LOTTIE:
//   El proyecto ya tiene el paquete `lottie` en pubspec.yaml, pero los
//   assets de partículas todavía no existen (Sprint de Assets, pendiente).
//   Acoplar este archivo a un asset que no existe lo dejaría roto hasta
//   ese Sprint. Un slot genérico de [Widget] permite plantar CUALQUIER cosa
//   ahí (un Lottie más adelante, o nada hoy) sin tocar este archivo.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, core/theme/.
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod,
//                            navegación (mostrar/cerrar rutas no es
//                            responsabilidad de este widget).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_animations.dart';
import 'package:jardindeleden/core/theme/app_motion.dart';

/// Composición animada de una celebración — ver documentación del archivo.
class AppCelebrationOverlay extends StatefulWidget {
  const AppCelebrationOverlay({
    required this.child,
    super.key,
    this.backgroundEffect,
    this.onCompleted,
    this.scrimColor = const Color(0x99000000),
    this.duration = AppDurations.celebration,
    this.popCurve = AppCurves.levelUpPop,
    this.reduceMotion = false,
  });

  /// Contenido central: insignia, texto de logro, ícono de trofeo.
  final Widget child;

  /// Efecto de fondo opcional (confeti, partículas) — ver nota del archivo.
  final Widget? backgroundEffect;

  /// Se invoca una vez cuando termina la animación de entrada.
  final VoidCallback? onCompleted;

  final Color scrimColor;
  final Duration duration;
  final Curve popCurve;
  final bool reduceMotion;

  @override
  State<AppCelebrationOverlay> createState() => _AppCelebrationOverlayState();
}

class _AppCelebrationOverlayState extends State<AppCelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scrimOpacity;
  late final Animation<double> _contentScale;
  late final Animation<double> _contentOpacity;

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

    // El scrim entra rápido (primer 25% del tiempo); el contenido hace su
    // pop elástico en el resto — un elasticOut necesita más recorrido de
    // tiempo que un fade simple para no sentirse cortado.
    _scrimOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );
    _contentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
    );
    _contentScale = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 1.0, curve: widget.popCurve),
    );

    // Siempre forward() (incluso con duration cero) — nunca se asigna
    // `.value` directamente, porque eso NO dispara el AnimationStatusListener
    // que llama a [onCompleted]. Con duration cero, forward() completa en el
    // siguiente tick y el listener se dispara igual, de forma confiable.
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
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: _scrimOpacity.value,
                child: ColoredBox(color: widget.scrimColor),
              ),
            ),
            if (widget.backgroundEffect != null)
              Opacity(opacity: _scrimOpacity.value, child: widget.backgroundEffect),
            Opacity(
              opacity: _contentOpacity.value,
              child: Transform.scale(scale: _contentScale.value, child: widget.child),
            ),
          ],
        );
      },
    );
  }
}
