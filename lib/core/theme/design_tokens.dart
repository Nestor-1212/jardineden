// ─────────────────────────────────────────────────────────────────────────────
// core/theme/design_tokens.dart
//
// RESPONSABILIDAD:
//   Archivo barrel del Design System completo.
//   Los widgets importan SOLO este archivo para acceder a todas las
//   constantes de diseño del proyecto.
//
// USO:
//   ```dart
//   import 'package:jardindeleden/core/theme/design_tokens.dart';
//
//   // Ahora disponibles:
//   AppColors.gardenMedium
//   AppSpacing.md
//   AppTextStyles.h1
//   AppBorderRadius.md
//   AppShadows.md
//   AppDurations.normal
//   AppCurves.standard
//   AppBreathing.minOpacity
//   AppTransitions.pageDefault
//   AppBreakpoints.mobile
//   context.isMobile              // via AppBreakpointsContext extension
//   context.responsive(...)       // via AppBreakpointsContext extension
//   context.screenSize            // via AppBreakpointsContext (ScreenSize)
//   context.isPortrait            // via AppOrientationContext
//   context.foldableInfo          // via AppFoldableContext
//   context.scaledTextStyle(...)  // via AppTextScaleContext
//   context.scaledIconSize(...)   // via AppIconScaleContext
//   context.scaledImageWidth(...) // via AppImageScaleContext
//   context.pageMargin            // via AppMarginsContext
//   context.responsiveGutter      // via AppResponsiveSpacingContext
//   AppIcons.play
//   AppDecorations.card(...)
//   AppBorderSide.selected
//   ```
//
// LO QUE NO SE IMPORTA AQUÍ:
//   app_theme.dart — ThemeData solo se usa en MaterialApp (main.dart).
//   Los widgets no instancian ThemeData; leen el tema via Theme.of(context).
//
// ─────────────────────────────────────────────────────────────────────────────

export 'package:jardindeleden/core/theme/app_animations.dart';
export 'package:jardindeleden/core/theme/app_borders.dart';
export 'package:jardindeleden/core/theme/app_breakpoints.dart';
export 'package:jardindeleden/core/theme/app_colors.dart';
export 'package:jardindeleden/core/theme/app_foldable.dart';
export 'package:jardindeleden/core/theme/app_high_contrast_colors.dart';
export 'package:jardindeleden/core/theme/app_icon_scale.dart';
export 'package:jardindeleden/core/theme/app_icons.dart';
export 'package:jardindeleden/core/theme/app_image_scale.dart';
export 'package:jardindeleden/core/theme/app_margins.dart';
export 'package:jardindeleden/core/theme/app_motion.dart';
export 'package:jardindeleden/core/theme/app_orientation.dart';
export 'package:jardindeleden/core/theme/app_responsive_spacing.dart';
export 'package:jardindeleden/core/theme/app_shadows.dart';
export 'package:jardindeleden/core/theme/app_spacing.dart';
export 'package:jardindeleden/core/theme/app_text_scale.dart';
export 'package:jardindeleden/core/theme/app_text_styles.dart';

// ── Accesibilidad (core/accessibility/) ──────────────────────────────────────
// Piezas puras (sin Riverpod) del sistema de accesibilidad. AccessibilityService
// / AccessibilityController / NarrationService se acceden vía
// core/di/providers_registry.dart (son servicios con estado, no design tokens).
export 'package:jardindeleden/core/accessibility/accessibility_settings.dart';
export 'package:jardindeleden/core/accessibility/color_blind_support.dart';
export 'package:jardindeleden/core/accessibility/screen_reader.dart';
