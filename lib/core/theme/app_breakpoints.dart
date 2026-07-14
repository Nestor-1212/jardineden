// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_breakpoints.dart
//
// RESPONSABILIDAD:
//   Define el sistema de breakpoints responsive del Design System.
//   Proporciona constantes de ancho de pantalla y una extensión de
//   BuildContext para que los widgets adapten su layout al tamaño actual.
//
// BREAKPOINTS:
//   mobile    < 600px  — Teléfono: 1 columna
//   tablet    < 1024px — Tablet / Phablet: 2-3 columnas
//   desktop   ≥ 1024px — Chromebook / tablet grande: 4+ columnas
//
// USO EN WIDGETS:
//   ```dart
//   // Valor adaptativo
//   final padding = context.responsive<double>(
//     mobile: AppSpacing.md,
//     tablet: AppSpacing.lg,
//     desktop: AppSpacing.xl,
//   );
//
//   // Check booleano
//   if (context.isTablet) { ... }
//
//   // Columnas de grid
//   crossAxisCount: context.columnCount,
//   ```
//
// RELACIÓN CON app_spacing.dart:
//   AppSpacing ya define los valores numéricos de breakpoints.
//   Esta clase los reutiliza para construir la API responsive.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, app_spacing.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_spacing.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN SIZE
// Clasificación granular de dispositivo — el resto del Design System
// adaptable (texto, íconos, imágenes, márgenes) se apoya en este enum en
// vez de comparar anchos crudos por su cuenta.
// ─────────────────────────────────────────────────────────────────────────────

/// Categoría de tamaño de pantalla, de más pequeña a más grande.
///
/// Mapeo a los anchos de [AppBreakpoints]:
///   compactPhone < 480px  — "teléfono pequeño" (SE, mini).
///   phone        480-599  — "teléfono grande" (mayoría de Android/iOS actuales).
///   phablet      600-767  — Frontera teléfono/tablet, plegables abiertos.
///   tablet       768-1023 — Tablet de 8-10".
///   largeTablet  ≥ 1024   — Tablet de 11"+ / Chromebook.
enum ScreenSize {
  compactPhone,
  phone,
  phablet,
  tablet,
  largeTablet;

  /// `true` para [compactPhone] y [phone] — cualquier layout de columna única.
  bool get isPhone => this == compactPhone || this == phone;

  /// `true` para [phablet], [tablet] y [largeTablet].
  bool get isTabletOrLarger =>
      this == phablet || this == tablet || this == largeTablet;
}

// ─────────────────────────────────────────────────────────────────────────────
// BREAKPOINTS
// Constantes estáticas que replican AppSpacing.breakpoint* como API propia.
// ─────────────────────────────────────────────────────────────────────────────

/// Sistema de breakpoints responsive del videojuego Jardín del Edén.
///
/// Convierte el ancho de pantalla en decisiones de layout: columnas de grid,
/// tamaños de padding, visibilidad de componentes opcionales.
///
/// Nota: el juego corre principalmente en teléfonos y tablets Android/iOS.
/// Los breakpoints están calibrados para esa audiencia — no para escritorio web.
abstract final class AppBreakpoints {
  // ── Anchos de Pantalla ────────────────────────────────────────────────────

  /// < 480px — Teléfono compacto (SE, mini). Layout ultra-estrecho.
  static const double mobileCompact = AppSpacing.breakpointMobile;

  /// < 600px — Teléfono estándar. Layout de columna única. El más frecuente.
  static const double mobile = AppSpacing.breakpointMobileLg;

  /// < 768px — Phablet. Puede mostrar 2 columnas en cuadrículas.
  static const double phablet = AppSpacing.breakpointTablet;

  /// < 1024px — Tablet pequeña y Chromebook de 10 pulgadas.
  static const double tablet = AppSpacing.breakpointTabletLg;

  // ── Clasificadores de Pantalla ────────────────────────────────────────────

  /// Retorna `true` si el ancho pertenece a un teléfono compacto (<480px).
  static bool isCompactPhone(double width) => width < mobileCompact;

  /// Retorna `true` si el ancho pertenece a un teléfono estándar (<600px).
  static bool isMobileWidth(double width) => width < mobile;

  /// Retorna `true` si el ancho pertenece a tablet o phablet (600-1023px).
  static bool isTabletWidth(double width) => width >= mobile && width < tablet;

  /// Retorna `true` si el ancho es de tablet grande o superior (≥1024px).
  static bool isDesktopWidth(double width) => width >= tablet;

  /// Clasifica [width] en una categoría de [ScreenSize].
  ///
  /// Fuente única de verdad para "¿es teléfono pequeño o grande?" — todo el
  /// resto del sistema adaptable (texto, íconos, imágenes, márgenes) llama
  /// a este método en vez de comparar anchos por su cuenta.
  static ScreenSize screenSizeOf(double width) {
    if (width < mobileCompact) return ScreenSize.compactPhone;
    if (width < mobile) return ScreenSize.phone;
    if (width < phablet) return ScreenSize.phablet;
    if (width < tablet) return ScreenSize.tablet;
    return ScreenSize.largeTablet;
  }

  // ── Columnas de Grid ──────────────────────────────────────────────────────

  /// Retorna el número de columnas de grid recomendado para el ancho dado.
  ///
  /// Se usa en GridView.count y SliverGrid para el inventario, colecciones
  /// y mosaicos de mundos.
  static int columnCount(double width) {
    if (width < mobile) return 1;
    if (width < phablet) return 2;
    if (width < tablet) return 3;
    return 4;
  }

  // ── Valor Adaptativo ──────────────────────────────────────────────────────

  /// Retorna el valor correspondiente al breakpoint activo.
  ///
  /// Si `tablet` o `desktop` son null, cae al valor de nivel inferior.
  ///
  /// Ejemplo:
  /// ```dart
  /// final cols = AppBreakpoints.responsive(
  ///   width: screenWidth,
  ///   mobile: 1,
  ///   tablet: 2,
  ///   desktop: 4,
  /// );
  /// ```
  static T responsive<T>({
    required double width,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (width >= AppBreakpoints.tablet && desktop != null) return desktop;
    if (width >= AppBreakpoints.mobile && tablet != null) return tablet;
    return mobile;
  }

  // ── Padding Lateral de Pantalla ───────────────────────────────────────────

  /// Retorna el padding lateral estándar para el ancho dado.
  ///
  /// En teléfonos: 16px. En tablets: 24px. En desktop: 32px.
  static double horizontalPadding(double width) => responsive(
    width: width,
    mobile: AppSpacing.md,
    tablet: AppSpacing.lg,
    desktop: AppSpacing.xl,
  );

  /// Retorna el ancho máximo del contenido principal (para tablets y desktop).
  ///
  /// En teléfonos: sin límite (double.infinity).
  /// En tablets y desktop: 720px — evita líneas demasiado largas.
  static double maxContentWidth(double width) =>
      width >= mobile ? 720.0 : double.infinity;
}

// ─────────────────────────────────────────────────────────────────────────────
// EXTENSION DE BuildContext
// API ergonómica para acceder a los breakpoints dentro de los widgets.
// ─────────────────────────────────────────────────────────────────────────────

/// Extensión de BuildContext que expone el sistema responsive del Design System.
///
/// Uso preferido sobre `MediaQuery.sizeOf(context).width` porque:
/// 1. Lee `MediaQuery.sizeOf()` (eficiente, no reconstruye por cambios de padding).
/// 2. Expone la semántica del proyecto (isMobile, columnCount, `responsive<T>`).
extension AppBreakpointsContext on BuildContext {
  /// Ancho actual de la pantalla (no del widget).
  ///
  /// Usa `MediaQuery.sizeOf()` para evitar rebuilds por cambios de `viewInsets`
  /// o `textScaleFactor` que no afectan el ancho.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// `true` si la pantalla es de teléfono (ancho < 600px).
  bool get isMobile => AppBreakpoints.isMobileWidth(screenWidth);

  /// `true` si la pantalla es de tablet o phablet (600–1023px).
  bool get isTablet => AppBreakpoints.isTabletWidth(screenWidth);

  /// `true` si la pantalla es de tablet grande o superior (≥1024px).
  bool get isDesktop => AppBreakpoints.isDesktopWidth(screenWidth);

  /// `true` si la pantalla es teléfono compacto (< 480px).
  bool get isCompactPhone => AppBreakpoints.isCompactPhone(screenWidth);

  /// Categoría granular de tamaño de pantalla — ver [ScreenSize].
  ScreenSize get screenSize => AppBreakpoints.screenSizeOf(screenWidth);

  /// Número de columnas recomendado para el grid en el ancho actual.
  ///
  /// 1 columna en teléfono, 2 en phablet, 3 en tablet, 4 en desktop.
  int get columnCount => AppBreakpoints.columnCount(screenWidth);

  /// Padding horizontal estándar para el ancho de pantalla actual.
  double get horizontalPadding => AppBreakpoints.horizontalPadding(screenWidth);

  /// Ancho máximo del contenido principal (720px en tablet/desktop).
  double get maxContentWidth => AppBreakpoints.maxContentWidth(screenWidth);

  /// Retorna el valor correspondiente al breakpoint activo de esta pantalla.
  ///
  /// Si `tablet` o `desktop` son null, cae al valor del nivel inferior.
  ///
  /// Ejemplo:
  /// ```dart
  /// padding: EdgeInsets.all(
  ///   context.responsive(
  ///     mobile: AppSpacing.md,
  ///     tablet: AppSpacing.lg,
  ///   ),
  /// ),
  /// ```
  T responsive<T>({required T mobile, T? tablet, T? desktop}) =>
      AppBreakpoints.responsive(
        width: screenWidth,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}
