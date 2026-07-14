// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_image_scale.dart
//
// RESPONSABILIDAD:
//   Dos problemas distintos de imágenes en un sistema adaptable:
//
//   1. TAMAÑO DE DISPLAY: cuánto debe medir una imagen ilustrativa (arte de
//      personaje, fondo de mundo) según el tamaño de pantalla — igual que
//      AppTextScale/AppIconScale, pero con factores más generosos: las
//      imágenes son contenido visual protagonista, se benefician más del
//      espacio extra de una tablet que un ícono de UI.
//
//   2. TAMAÑO DE DECODIFICACIÓN (cacheWidth/cacheHeight): decodificar un
//      bitmap de 2000×2000 para mostrarlo en un círculo de 64×64 desperdicia
//      memoria y tiempo de frame — especialmente relevante en un juego con
//      animaciones continuas. `Image.asset`/`Image.network` aceptan
//      `cacheWidth`/`cacheHeight` en PÍXELES FÍSICOS (no lógicos) para
//      decodificar solo lo necesario.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart,
//                            core/theme/app_breakpoints.dart (ScreenSize).
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_breakpoints.dart';

abstract final class AppImageScale {
  // ── Tamaño de Display ────────────────────────────────────────────────────

  /// Multiplicador de tamaño de imagen ilustrativa según [ScreenSize].
  ///
  /// Más generoso que AppIconScale — las imágenes son contenido, no
  /// controles de UI, y se benefician más del espacio extra de una tablet.
  static double factorFor(ScreenSize screenSize) => switch (screenSize) {
    ScreenSize.compactPhone => 0.9,
    ScreenSize.phone => 1.0,
    ScreenSize.phablet => 1.1,
    ScreenSize.tablet => 1.3,
    ScreenSize.largeTablet => 1.5,
  };

  /// Retorna [baseWidth] escalado para [screenSize]. Usar con una relación
  /// de aspecto conocida (AspectRatio widget) para calcular el alto.
  static double widthFor(double baseWidth, ScreenSize screenSize) =>
      baseWidth * factorFor(screenSize);

  // ── Tamaño de Decodificación ──────────────────────────────────────────────

  /// Calcula `cacheWidth`/`cacheHeight` en píxeles FÍSICOS para
  /// `Image.asset`/`Image.network`, a partir del tamaño de DISPLAY en
  /// píxeles lógicos y el [devicePixelRatio] del dispositivo.
  ///
  /// Ejemplo:
  /// ```dart
  /// final cache = AppImageScale.cacheSize(
  ///   displayWidth: 64, displayHeight: 64,
  ///   devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
  /// );
  /// Image.asset(path, cacheWidth: cache.width, cacheHeight: cache.height);
  /// ```
  static ({int width, int height}) cacheSize({
    required double displayWidth,
    required double displayHeight,
    required double devicePixelRatio,
  }) {
    return (
      width: (displayWidth * devicePixelRatio).round(),
      height: (displayHeight * devicePixelRatio).round(),
    );
  }
}

/// Extensión de BuildContext para escalado de imágenes.
extension AppImageScaleContext on BuildContext {
  /// Retorna [baseWidth] escalado para el tamaño de pantalla actual.
  double scaledImageWidth(double baseWidth) =>
      AppImageScale.widthFor(baseWidth, screenSize);

  /// Calcula el tamaño de decodificación (píxeles físicos) para una imagen
  /// que se mostrará a [displayWidth]×[displayHeight] píxeles lógicos en
  /// esta pantalla.
  ({int width, int height}) imageCacheSize({
    required double displayWidth,
    required double displayHeight,
  }) => AppImageScale.cacheSize(
    displayWidth: displayWidth,
    displayHeight: displayHeight,
    devicePixelRatio: MediaQuery.devicePixelRatioOf(this),
  );
}
