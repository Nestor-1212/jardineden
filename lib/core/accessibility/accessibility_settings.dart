// ─────────────────────────────────────────────────────────────────────────────
// core/accessibility/accessibility_settings.dart
//
// RESPONSABILIDAD:
//   Modelo inmutable de TODAS las preferencias de accesibilidad del
//   jugador. Es el estado que AccessibilityController mantiene en memoria
//   y que AccessibilityService persiste — ver esos dos archivos para el
//   resto del sistema.
//
// POR QUÉ UN MODELO RICO (enums) Y NO SOLO BOOLEANOS SUELTOS:
//   "Texto grande" no es sí/no — hay grados (normal/grande/extra grande).
//   "Daltonismo" no es un booleano — hay 3 tipos con necesidades de color
//   distintas. Modelarlo como enums desde el día uno evita una migración
//   incómoda de bool a enum más adelante.
//
// PRESETS: LA DECISIÓN DE DISEÑO MÁS IMPORTANTE DE ESTE ARCHIVO
//   En vez de que cada pantalla futura tenga que saber "para un niño de 4
//   años hay que activar narración + botones grandes + texto grande +
//   navegación simple", el preset lo encapsula en un solo factory. Esto
//   imita cómo los sistemas operativos reales resuelven accesibilidad por
//   perfil (ej. "Acceso Guiado"/"Assistive Access" de iOS) — el usuario (o
//   el padre, en el Panel de Padres) elige UN perfil, no ocho toggles.
//   Los toggles individuales siguen existiendo para ajuste fino después.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   Flutter, Riverpod, features, shared.
// ─────────────────────────────────────────────────────────────────────────────

/// Grado de escalado de texto, independiente del TextScaler del sistema
/// operativo (ver core/theme/app_text_scale.dart) — este es un ajuste
/// DENTRO del juego, adicional al de accesibilidad del SO.
enum TextScaleMode {
  normal,
  large,
  extraLarge;

  /// Multiplicador de fontSize aplicado sobre los estilos base de AppTextStyles.
  double get factor => switch (this) {
    TextScaleMode.normal => 1.0,
    TextScaleMode.large => 1.2,
    TextScaleMode.extraLarge => 1.45,
  };
}

/// Tipo de daltonismo a corregir. `none` es el valor por defecto (sin ajuste).
///
/// Los tres tipos cubren >99% de los casos de daltonismo hereditario:
/// protanopia/protanomalía (rojo), deuteranopia/deuteranomalía (verde,
/// la más común, ~5% de hombres), tritanopia/tritanomalía (azul, rara).
enum ColorBlindMode {
  none,
  protanopia,
  deuteranopia,
  tritanopia;

  bool get isActive => this != ColorBlindMode.none;
}

/// Perfiles de accesibilidad predefinidos — combinaciones curadas de todos
/// los ajustes individuales para un caso de uso concreto.
enum AccessibilityProfile {
  /// Sin ajustes especiales — el juego tal como está diseñado.
  standard,

  /// Niños de 4-6 años: motricidad fina en desarrollo, lectura incipiente
  /// o nula. Ver [AccessibilitySettings.youngChildPreset].
  youngChild,

  /// Baja visión: texto y botones grandes, alto contraste.
  lowVision,
}

/// Snapshot inmutable de todas las preferencias de accesibilidad del jugador.
final class AccessibilitySettings {
  const AccessibilitySettings({
    this.textScaleMode = TextScaleMode.normal,
    this.highContrastEnabled = false,
    this.colorBlindMode = ColorBlindMode.none,
    this.reduceMotionEnabled = false,
    this.simplifiedNavigationEnabled = false,
    this.largeButtonsEnabled = false,
    this.narrationEnabled = true,
  });

  /// Escalado de texto DENTRO del juego (eje independiente del TextScaler
  /// del sistema — ver core/theme/app_text_scale.dart).
  final TextScaleMode textScaleMode;

  /// Activa la paleta de alto contraste (ver core/theme/app_high_contrast_colors.dart).
  final bool highContrastEnabled;

  /// Corrección de color activa — ver [ColorBlindMode].
  final ColorBlindMode colorBlindMode;

  /// Reduce/elimina animaciones no esenciales — ver core/accessibility/app_motion.dart.
  final bool reduceMotionEnabled;

  /// Reduce la cantidad de opciones visibles en menús/navegación — señal
  /// que futuras pantallas de navegación deben consultar (ver
  /// core/accessibility/screen_reader.dart y la nota de "no pantallas" en
  /// el resumen de esta sesión: esta bandera se define aquí, pero qué
  /// menú específico oculta qué opción es responsabilidad de cada feature).
  final bool simplifiedNavigationEnabled;

  /// Aumenta el tamaño mínimo de objetivo táctil de 44pt a 64pt (ver
  /// AppSpacing.touchTargetLarge).
  final bool largeButtonsEnabled;

  /// Reproduce narración de audio pre-grabada para contenido de texto (ver
  /// core/narration/narration_service.dart). Por defecto ACTIVA — la
  /// audiencia del juego incluye niños de 4 años que aún no leen.
  final bool narrationEnabled;

  /// Tamaño de objetivo táctil efectivo según [largeButtonsEnabled].
  double get touchTargetSize =>
      largeButtonsEnabled ? 64.0 : 44.0; // AppSpacing.touchTargetLarge/Min

  AccessibilitySettings copyWith({
    TextScaleMode? textScaleMode,
    bool? highContrastEnabled,
    ColorBlindMode? colorBlindMode,
    bool? reduceMotionEnabled,
    bool? simplifiedNavigationEnabled,
    bool? largeButtonsEnabled,
    bool? narrationEnabled,
  }) {
    return AccessibilitySettings(
      textScaleMode: textScaleMode ?? this.textScaleMode,
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      colorBlindMode: colorBlindMode ?? this.colorBlindMode,
      reduceMotionEnabled: reduceMotionEnabled ?? this.reduceMotionEnabled,
      simplifiedNavigationEnabled:
          simplifiedNavigationEnabled ?? this.simplifiedNavigationEnabled,
      largeButtonsEnabled: largeButtonsEnabled ?? this.largeButtonsEnabled,
      narrationEnabled: narrationEnabled ?? this.narrationEnabled,
    );
  }

  /// Preset para [AccessibilityProfile.youngChild] — niños de 4-6 años.
  ///
  /// NO activa alto contraste ni corrección de daltonismo — esos son
  /// ajustes para necesidades visuales específicas, no una función de la
  /// edad. Mezclar "edad" con "discapacidad visual" sería un supuesto
  /// incorrecto y potencialmente ofensivo del sistema.
  factory AccessibilitySettings.youngChildPreset() =>
      const AccessibilitySettings(
        textScaleMode: TextScaleMode.large,
        largeButtonsEnabled: true,
        simplifiedNavigationEnabled: true,
        // narrationEnabled ya es `true` por defecto — se omite explícito.
      );

  /// Preset para [AccessibilityProfile.lowVision].
  factory AccessibilitySettings.lowVisionPreset() =>
      const AccessibilitySettings(
        textScaleMode: TextScaleMode.extraLarge,
        highContrastEnabled: true,
        largeButtonsEnabled: true,
      );

  /// Retorna el preset correspondiente a [profile].
  factory AccessibilitySettings.forProfile(
    AccessibilityProfile profile,
  ) => switch (profile) {
    AccessibilityProfile.standard => const AccessibilitySettings(),
    AccessibilityProfile.youngChild => AccessibilitySettings.youngChildPreset(),
    AccessibilityProfile.lowVision => AccessibilitySettings.lowVisionPreset(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilitySettings &&
          runtimeType == other.runtimeType &&
          textScaleMode == other.textScaleMode &&
          highContrastEnabled == other.highContrastEnabled &&
          colorBlindMode == other.colorBlindMode &&
          reduceMotionEnabled == other.reduceMotionEnabled &&
          simplifiedNavigationEnabled == other.simplifiedNavigationEnabled &&
          largeButtonsEnabled == other.largeButtonsEnabled &&
          narrationEnabled == other.narrationEnabled;

  @override
  int get hashCode => Object.hash(
    textScaleMode,
    highContrastEnabled,
    colorBlindMode,
    reduceMotionEnabled,
    simplifiedNavigationEnabled,
    largeButtonsEnabled,
    narrationEnabled,
  );
}
