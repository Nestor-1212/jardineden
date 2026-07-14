// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_animations_widgets.dart
//
// RESPONSABILIDAD:
//   Archivo barrel de TODOS los widgets de animación reutilizables del
//   Design System. Las features importan SOLO este archivo en vez de cada
//   primitiva por separado.
//
// RELACIÓN CON core/theme/app_animations.dart:
//   Ese archivo define los TOKENS (duraciones, curvas — valores, sin
//   widgets, sin Flutter más allá de los tipos Duration/Curve). Este barrel
//   agrupa los WIDGETS que consumen esos tokens para producir movimiento
//   real en pantalla. Un widget nuevo de animación SIEMPRE debe construirse
//   sobre AppDurations/AppCurves — nunca con un Duration/Curve suelto.
//
// CATÁLOGO:
//   Fade            → AppFadeIn, AppFadeSwitcher
//   Scale           → AppScaleIn, AppPressableScale
//   Rotation        → AppRotateIn, AppSpinner, AppFlip
//   Slide           → AppSlideIn (+ AppSlideDirection)
//   Rebotes         → AppBounceIn, AppShake
//   Hero            → AppHero (+ AppHeroTags)
//   Celebraciones   → AppCelebrationOverlay
//   Recompensas     → AppCoinFloat, AppCardReveal
//   Microinteracciones → AppCorrectFeedback, AppIncorrectFeedback
//
// REDUCCIÓN DE MOVIMIENTO:
//   Todo widget de este catálogo acepta `reduceMotion` y respeta además,
//   automáticamente, la señal del sistema operativo — ver
//   core/theme/app_motion.dart. Ningún widget nuevo de este directorio
//   debe saltarse ese parámetro.
// ─────────────────────────────────────────────────────────────────────────────

export 'app_bounce.dart';
export 'app_celebration.dart';
export 'app_fade.dart';
export 'app_hero.dart';
export 'app_microinteractions.dart';
export 'app_reward.dart';
export 'app_rotation.dart';
export 'app_scale.dart';
export 'app_slide.dart';
