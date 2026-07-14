// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_animations.dart
//
// RESPONSABILIDAD:
//   Define el sistema completo de animaciones del Design System.
//   Incluye duraciones, curvas y constantes para las animaciones específicas
//   del videojuego: HUD Breathing, colección de monedas, revelación de cartas,
//   celebraciones de nivel, y transiciones de pantalla.
//
// ORGANIZACIÓN:
//   AppDurations  — constantes de duración (Duration)
//   AppCurves     — curvas de animación (Curve)
//   AppBreathing  — constantes del efecto HUD Breathing
//   AppTransition — constantes de transiciones de página
//
// PRINCIPIO HUD BREATHING:
//   Los elementos del HUD pulsan entre 20-30% y 100% de opacidad.
//   El ciclo completo toma 2 segundos. La curva es sinusoidal (easeInOut).
//   El scale también varía sutilmente entre 0.97 y 1.0 para reforzar el efecto.
//
// DEPENDENCIAS PERMITIDAS:   flutter/animation.dart, flutter/material.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DURACIONES
// Escala temporal del Design System. Cada categoría de interacción
// tiene su duración apropiada para transmitir la física correcta.
// ─────────────────────────────────────────────────────────────────────────────

/// Duraciones de animación estándar del videojuego Jardín del Edén.
abstract final class AppDurations {
  // ── Micro-interacciones ───────────────────────────────────────────────────

  /// Sin animación. Cambios instantáneos de estado (ej: toggle inmediato).
  static const Duration instant = Duration.zero;

  /// 100ms — Feedback táctil: press, ripple, highlight. Casi imperceptible.
  static const Duration veryFast = Duration(milliseconds: 100);

  /// 200ms — Animaciones de UI ligeras: fade in/out de iconos, cambio de color.
  static const Duration fast = Duration(milliseconds: 200);

  // ── Transiciones Estándar ─────────────────────────────────────────────────

  /// 300ms — Transición estándar de UI. Entrada/salida de componentes.
  /// Es la duración base de Material 3 para la mayoría de animaciones.
  static const Duration normal = Duration(milliseconds: 300);

  /// 400ms — Transiciones de contenido: expansión de tarjeta, aparición modal.
  static const Duration medium = Duration(milliseconds: 400);

  /// 500ms — Transiciones lentas: cambio de pantalla, revelación de resultado.
  static const Duration slow = Duration(milliseconds: 500);

  // ── Animaciones de Juego ──────────────────────────────────────────────────

  /// 600ms — Moneda flotante al ser recogida (float up + fade out).
  static const Duration coinFloat = Duration(milliseconds: 600);

  /// 400ms — Flip de tarjeta al revelar ítem o versículo.
  static const Duration cardFlip = Duration(milliseconds: 400);

  /// 350ms — Transición entre pantallas del juego con SlideTransition.
  static const Duration pageTransition = Duration(milliseconds: 350);

  /// 800ms — Animación de nivel superado (pop + scale + glow).
  static const Duration levelUp = Duration(milliseconds: 800);

  /// 1200ms — Celebración completa (levelUp + partículas Lottie).
  static const Duration celebration = Duration(milliseconds: 1200);

  /// 600ms — Aparición del mensaje de "¡Correcto!" tras respuesta acertada.
  static const Duration correctFeedback = Duration(milliseconds: 600);

  /// 400ms — Vibración visual de "Incorrecto" (shake animation).
  static const Duration incorrectFeedback = Duration(milliseconds: 400);

  /// 300ms — Aparición del diálogo de personaje con efecto typewriter.
  static const Duration dialogEnter = Duration(milliseconds: 300);

  /// 1000ms — Efecto typewriter para el texto del diálogo de personaje.
  /// Se divide por el número de caracteres para calcular el delay por char.
  static const Duration typewriterFull = Duration(milliseconds: 1000);

  // ── HUD Breathing ─────────────────────────────────────────────────────────

  /// 2000ms — Período completo de un ciclo de respiración del HUD.
  /// El HUD inhala (sube a 100% opacity) y exhala (baja a 25% opacity)
  /// en este tiempo. El ciclo se repite indefinidamente con reversión.
  static const Duration breathingCycle = Duration(seconds: 2);

  /// 1500ms — Período de transición del HUD de reposo a activo.
  /// Cuando el jugador toca el HUD, pasa de modo breathing a modo activo.
  static const Duration breathingToActive = Duration(milliseconds: 1500);

  // ── Sistema 44 ────────────────────────────────────────────────────────────

  /// 500ms — Aparición de la alerta de versículo pendiente de revisión.
  static const Duration sistema44Alert = Duration(milliseconds: 500);

  // ── Splash & Onboarding ───────────────────────────────────────────────────

  /// 800ms — Fade in del logo en la pantalla de splash.
  static const Duration splashFadeIn = Duration(milliseconds: 800);

  /// 1500ms — Duración mínima del splash antes de navegar al siguiente paso.
  static const Duration splashMinimum = Duration(milliseconds: 1500);

  /// 600ms — Animación de entrada para los tutoriales del onboarding.
  static const Duration tutorialEnter = Duration(milliseconds: 600);
}

// ─────────────────────────────────────────────────────────────────────────────
// CURVAS
// Define la física visual de cada tipo de animación.
// Cada curva transmite una sensación diferente al usuario.
// ─────────────────────────────────────────────────────────────────────────────

/// Curvas de animación del videojuego Jardín del Edén.
abstract final class AppCurves {
  // ── Curvas Estándar ───────────────────────────────────────────────────────

  /// Curva estándar de UI. Para la mayoría de transiciones de componentes.
  /// Empieza rápido, termina suave. Natural y predecible.
  static const Curve standard = Curves.easeInOut;

  /// Curva de desaceleración. Para elementos que entran a la pantalla.
  /// Llegan rápido y se detienen suavemente.
  static const Curve decelerate = Curves.easeOut;

  /// Curva de aceleración. Para elementos que salen de la pantalla.
  /// Empiezan despacio y aceleran al salir.
  static const Curve accelerate = Curves.easeIn;

  // ── Curvas Material 3 Emphasized ──────────────────────────────────────────
  // Material 3 define curvas "emphasized" para transiciones de alto impacto.

  /// Curva emphasizedDecelerate. Para elementos entrando en foco principal.
  static const Curve emphasizedDecelerate = Curves.easeOutCubic;

  /// Curva emphasizedAccelerate. Para elementos saliendo del foco principal.
  static const Curve emphasizedAccelerate = Curves.easeInCubic;

  /// Curva emphasized completa. Para transformaciones de estado significativas.
  static const Curve emphasized = Curves.easeInOutCubic;

  // ── Curvas de Juego ───────────────────────────────────────────────────────

  /// Curva de resorte. Para animaciones que "pop" con energía juvenil.
  /// Ideal para aparición de recompensas, logros y elementos de sorpresa.
  static const Curve spring = Curves.elasticOut;

  /// Curva de rebote. Para caída de ítems coleccionables al inventario.
  static const Curve bounce = Curves.bounceOut;

  /// Curva de moneda flotando. Sube rápido, desacelera al final.
  static const Curve coinFloat = Curves.easeOutQuart;

  /// Curva de flip de tarjeta. Primera mitad rápida, segunda mitad suave.
  static const Curve cardFlip = Curves.easeInOut;

  /// Curva de Level Up. Pop elástico para transmitir euforia.
  static const Curve levelUpPop = Curves.elasticOut;

  /// Curva de feedback correcto. Pop suave, no demasiado agresivo.
  static const Curve correctPop = Curves.easeOutBack;

  /// Curva de feedback incorrecto. Shake lineal para simular vibración.
  static const Curve shakeVibrate = Curves.linear;

  // ── Curvas del HUD Breathing ──────────────────────────────────────────────
  // El HUD respira con una curva sinusoidal que simula respiración humana.
  // Inhalar (ir de 25% a 100%): easeIn (empieza lento, accelera al final).
  // Exhalar (ir de 100% a 25%): easeOut (empieza rápido, desacelera).

  /// Curva de inhalación del HUD (opacidad: 25% → 100%).
  static const Curve breathingIn = Curves.easeIn;

  /// Curva de exhalación del HUD (opacidad: 100% → 25%).
  static const Curve breathingOut = Curves.easeOut;

  /// Curva para el ciclo completo de breathing cuando se usa repeat+reverse.
  static const Curve breathingCycle = Curves.easeInOut;

  // ── Curvas de Transición de Página ───────────────────────────────────────

  /// Transición de página hacia adelante (avanzar en la historia).
  static const Curve pageForward = Curves.easeOutCubic;

  /// Transición de página hacia atrás (retroceder o cerrar).
  static const Curve pageBack = Curves.easeInCubic;

  /// Fade de pantalla (para transiciones entre mundos o capítulos).
  static const Curve pageFade = Curves.easeInOut;
}

// ─────────────────────────────────────────────────────────────────────────────
// HUD BREATHING
// Sistema de animación del HUD principal del juego.
// Los elementos del HUD (contadores de monedas, nivel, racha) "respiran":
// oscilan entre una opacidad mínima y máxima en ciclos continuos.
// Esto mantiene el HUD vivo sin distraer al jugador de la tarea principal.
// ─────────────────────────────────────────────────────────────────────────────

/// Constantes del efecto de respiración del HUD del videojuego.
///
/// Implementación esperada en el HUDWidget:
/// ```
/// AnimationController(
///   vsync: this,
///   duration: AppBreathing.period,
/// )..repeat(reverse: true)
///
/// opacity = Tween(begin: AppBreathing.minOpacity, end: AppBreathing.maxOpacity)
///   .animate(CurvedAnimation(curve: AppBreathing.curve))
///
/// scale = Tween(begin: AppBreathing.minScale, end: AppBreathing.maxScale)
///   .animate(...)
/// ```
abstract final class AppBreathing {
  // ── Opacidad ──────────────────────────────────────────────────────────────

  /// Opacidad mínima del HUD en reposo (fase de "exhalación").
  /// El Design System especifica 20-30%. Se usa 25% como valor central.
  static const double minOpacity = 0.25;

  /// Opacidad máxima del HUD en estado activo (fase de "inhalación").
  static const double maxOpacity = 1.0;

  /// Opacidad del HUD cuando el jugador lo está usando activamente.
  /// Se fija en 1.0 y se cancela el breathing mientras hay interacción.
  static const double activeOpacity = 1.0;

  // ── Escala ────────────────────────────────────────────────────────────────

  /// Escala mínima del HUD en reposo. Contracción sutil para reforzar el efecto.
  static const double minScale = 0.97;

  /// Escala máxima del HUD. Sin sobredimensionamiento — solo un toque de vida.
  static const double maxScale = 1.0;

  // ── Tiempo ────────────────────────────────────────────────────────────────

  /// Período completo de un ciclo de respiración.
  static const Duration period = AppDurations.breathingCycle;

  /// Duración de la transición de "modo breathing" a "modo activo".
  static const Duration activationDuration = AppDurations.breathingToActive;

  // ── Curva ─────────────────────────────────────────────────────────────────

  /// Curva de animación del ciclo de breathing.
  static const Curve curve = AppCurves.breathingCycle;
}

// ─────────────────────────────────────────────────────────────────────────────
// TRANSICIONES DE PÁGINA
// Define las configuraciones de transición para GoRouter.
// Cada tipo de pantalla tiene su propia física de transición.
// ─────────────────────────────────────────────────────────────────────────────

/// Configuración de transiciones de pantalla para GoRouter.
abstract final class AppTransitions {
  // ── Duraciones ────────────────────────────────────────────────────────────

  /// Duración de la transición entre pantallas normales.
  static const Duration pageDefault = AppDurations.pageTransition;

  /// Duración de la transición entre mundos (más lenta, más dramática).
  static const Duration pageWorld = Duration(milliseconds: 600);

  /// Duración del fade entre capítulos del mismo mundo.
  static const Duration pageChapter = Duration(milliseconds: 450);

  /// Duración de la transición del minijuego (instantánea desde el jugador).
  static const Duration pageMinigame = Duration(milliseconds: 250);

  // ── Curvas ────────────────────────────────────────────────────────────────

  /// Curva de la transición por defecto.
  static const Curve curveDefault = AppCurves.emphasizedDecelerate;

  /// Curva para transiciones dramáticas entre mundos.
  static const Curve curveWorld = AppCurves.emphasized;

  // ── Offsets de SlideTransition ────────────────────────────────────────────
  // El juego usa SlideTransition horizontal para avanzar en la historia.

  /// Offset de entrada (nueva pantalla viene desde la derecha).
  static const Offset enterFromRight = Offset(1.0, 0.0);

  /// Offset de salida (pantalla actual va hacia la izquierda).
  static const Offset exitToLeft = Offset(-0.3, 0.0);

  /// Offset de entrada para retroceso (viene desde la izquierda).
  static const Offset enterFromLeft = Offset(-1.0, 0.0);

  /// Offset de salida para retroceso (va hacia la derecha).
  static const Offset exitToRight = Offset(0.3, 0.0);
}
