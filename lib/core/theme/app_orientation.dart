// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_orientation.dart
//
// RESPONSABILIDAD:
//   Extiende BuildContext con helpers de orientación (vertical/horizontal),
//   complementando a AppBreakpoints (que solo mira el ancho). Un teléfono
//   en horizontal puede tener el mismo ancho que una tablet en vertical —
//   los widgets que necesiten distinguir ambos casos usan este archivo,
//   no comparan `MediaQuery.orientationOf` directamente.
//
// POR QUÉ NO SE FUSIONA CON AppBreakpoints:
//   Breakpoint (ancho) y orientación son ejes independientes — un mismo
//   ancho puede darse en portrait o landscape según el dispositivo. Combinar
//   ambos en una sola clase obligaría a un enum 2D (5 tamaños × 2
//   orientaciones = 10 casos) que en la práctica solo un puñado de pantallas
//   necesita. Se exponen por separado y se combinan en el widget que los
//   necesite (ver responsiveByOrientation más abajo).
//
// CUÁNDO IMPORTA LA ORIENTACIÓN EN ESTE JUEGO:
//   El juego está diseñado principalmente para portrait (como la mayoría de
//   apps para niños). landscape importa en: tablets (el layout de 2 columnas
//   se beneficia del ancho extra), minijuegos específicos que se declaren
//   landscape-only (Sprint de Minijuegos), y pantallas de video/celebración
//   a pantalla completa.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Extensión de BuildContext para consultas de orientación de pantalla.
extension AppOrientationContext on BuildContext {
  /// Orientación actual reportada por el sistema operativo.
  ///
  /// Usa `MediaQuery.orientationOf()` (no `.of(context).orientation`) por la
  /// misma razón que AppBreakpointsContext usa `MediaQuery.sizeOf()` — evita
  /// reconstruir el widget por cambios de MediaQuery no relacionados.
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// `true` si el dispositivo está en orientación vertical (portrait).
  bool get isPortrait => orientation == Orientation.portrait;

  /// `true` si el dispositivo está en orientación horizontal (landscape).
  bool get isLandscape => orientation == Orientation.landscape;

  /// Retorna [portrait] o [landscape] según la orientación actual.
  ///
  /// Ejemplo:
  /// ```dart
  /// crossAxisCount: context.responsiveByOrientation(portrait: 2, landscape: 4),
  /// ```
  T responsiveByOrientation<T>({required T portrait, required T landscape}) =>
      isPortrait ? portrait : landscape;
}
