// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_motion.dart
//
// RESPONSABILIDAD:
//   Resuelve duraciones/curvas de AppDurations/AppCurves a "sin animación"
//   cuando corresponde reducir movimiento — combinando DOS señales:
//
//   1. SEÑAL DEL SISTEMA OPERATIVO: `MediaQuery.disableAnimationsOf()` lee
//      "Reduce Motion" (iOS) / "Eliminar animaciones" (Android) — el
//      usuario ya lo configuró a nivel de SO, fuera de esta app.
//   2. AJUSTE DENTRO DEL JUEGO: AccessibilitySettings.reduceMotionEnabled
//      (core/accessibility/) — el jugador lo activó específicamente en
//      este juego, sin tocar los ajustes del sistema.
//
//   Cualquiera de las dos activa la reducción — no hace falta que ambas
//   coincidan.
//
// POR QUÉ IMPORTA PARA ESTE JUEGO EN PARTICULAR:
//   El HUD Breathing (core/theme/app_animations.dart, AppBreathing) es una
//   animación CONTINUA e infinita — exactamente el tipo de movimiento que
//   causa molestia real (no solo preferencia estética) a usuarios con
//   trastornos vestibulares o sensibilidad al movimiento. Reducir
//   movimiento no es opcional-cosmético para ese caso: es accesibilidad.
//
// QUÉ NO HACE:
//   No elimina TODA animación — transiciones funcionales breves (ej. un
//   fade de 100ms al cambiar de pantalla) no causan malestar vestibular y
//   ayudan a la orientación del usuario. Eliminar todo movimiento sin
//   distinción es una implementación ingenua de "reduce motion"; el widget
//   que anima decide si su animación es decorativa (usar
//   [AppMotion.resolve]) o funcional (mantenerla, quizás acortada).
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core,
//                            core/accessibility (evita ciclo — este archivo
//                            recibe el flag de la app como parámetro, no lo
//                            lee de Riverpod directamente).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

abstract final class AppMotion {
  /// Retorna [Duration.zero] si [systemPrefersReducedMotion] o
  /// [appReduceMotionEnabled] son `true`; retorna [base] en caso contrario.
  static Duration resolve({
    required Duration base,
    required bool systemPrefersReducedMotion,
    required bool appReduceMotionEnabled,
  }) {
    if (systemPrefersReducedMotion || appReduceMotionEnabled) {
      return Duration.zero;
    }
    return base;
  }

  /// Retorna [Curves.linear] (la curva "sin física") si corresponde reducir
  /// movimiento; retorna [base] en caso contrario. Usar junto a [resolve]
  /// — una duración cero ya anula la curva en la práctica, pero mantener
  /// la curva coherente evita saltos si algún widget solo lee la curva.
  static Curve resolveCurve({
    required Curve base,
    required bool systemPrefersReducedMotion,
    required bool appReduceMotionEnabled,
  }) {
    if (systemPrefersReducedMotion || appReduceMotionEnabled) {
      return Curves.linear;
    }
    return base;
  }
}

/// Extensión de BuildContext para la señal de reducción de movimiento del
/// sistema operativo.
extension AppMotionContext on BuildContext {
  /// `true` si el sistema operativo tiene activada la reducción de
  /// movimiento ("Reduce Motion" / "Eliminar animaciones").
  bool get systemPrefersReducedMotion => MediaQuery.disableAnimationsOf(this);

  /// Resuelve [base] combinando la señal del sistema con
  /// [appReduceMotionEnabled] (pasar `accessibility.reduceMotionEnabled`
  /// desde AccessibilityController en el widget que llama).
  Duration motionDuration(
    Duration base, {
    bool appReduceMotionEnabled = false,
  }) => AppMotion.resolve(
    base: base,
    systemPrefersReducedMotion: systemPrefersReducedMotion,
    appReduceMotionEnabled: appReduceMotionEnabled,
  );
}

/// [PageTransitionsTheme] sin animación — todas las plataformas usan
/// [AppInstantPageTransitionsBuilder]. Para usar cuando corresponde reducir
/// movimiento a nivel de MaterialApp completo (ver wiring en main.dart).
final PageTransitionsTheme appInstantPageTransitionsTheme =
    PageTransitionsTheme(
      builders: {
        for (final platform in TargetPlatform.values)
          platform: const AppInstantPageTransitionsBuilder(),
      },
    );

/// [PageTransitionsBuilder] que no anima — la pantalla nueva aparece
/// instantáneamente. Usado por [appInstantPageTransitionsTheme].
final class AppInstantPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppInstantPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
