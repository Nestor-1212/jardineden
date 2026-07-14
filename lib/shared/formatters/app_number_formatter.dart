// ─────────────────────────────────────────────────────────────────────────────
// shared/formatters/app_number_formatter.dart
//
// RESPONSABILIDAD:
//   Formateo de números, cantidades de moneda del juego y porcentajes
//   de manera locale-aware para mostrar en la UI del videojuego.
//
// DISEÑO:
//   Los métodos reciben un `languageCode` String en lugar de una Locale
//   para mantenerse independientes de BuildContext. Esto permite usarlos
//   en ViewModels y providers de Riverpod sin acceder al árbol de widgets.
//
// USO:
//   ```dart
//   // En HUD: "1,250" / "1.250"
//   AppNumberFormatter.formatGameCurrency(1250, context.languageCode)
//
//   // Compacto: "1.2K" / "12.5M"
//   AppNumberFormatter.formatCompact(12500, context.languageCode)
//
//   // Posición: "1°" / "2nd"
//   AppNumberFormatter.formatRank(3, context.languageCode)
//
//   // Porcentaje: "75 %" / "75%"
//   AppNumberFormatter.formatPercentage(0.75, context.languageCode)
//   ```
//
// DEPENDENCIAS PERMITIDAS:   dart:core, intl.
// DEPENDENCIAS PROHIBIDAS:   flutter, features, core, otros módulos shared.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:intl/intl.dart';

abstract final class AppNumberFormatter {
  // ── Monedas del Juego ─────────────────────────────────────────────────────

  /// Formatea una cantidad de moneda del juego sin decimales.
  ///
  /// Usa separador de miles según el locale.
  ///
  /// Es: "1.250"  (punto como separador)
  /// En: "1,250"  (coma como separador)
  ///
  /// Úsalo para las 4 monedas: Semillas de Luz, Pergaminos, Jordán, Abraam.
  static String formatGameCurrency(int amount, String languageCode) =>
      NumberFormat.decimalPattern(languageCode).format(amount);

  /// Formatea una cantidad grande de forma compacta.
  ///
  /// Es/En: 1250 → "1.2K", 1200000 → "1.2M"
  ///
  /// Úsalo en el HUD cuando el espacio es limitado.
  static String formatCompact(int amount, String languageCode) =>
      NumberFormat.compact(locale: languageCode).format(amount);

  // ── Estadísticas ──────────────────────────────────────────────────────────

  /// Formatea un porcentaje (valor entre 0.0 y 1.0).
  ///
  /// Es: "75 %"   (con espacio antes del %)
  /// En: "75%"    (sin espacio)
  ///
  /// Úsalo para: % misiones completadas, % versículos memorizados.
  static String formatPercentage(double value, String languageCode) =>
      NumberFormat.percentPattern(languageCode).format(value);

  /// Formatea una puntuación de minijuego con separador de miles.
  ///
  /// Igual que formatGameCurrency pero más semánticamente claro para scores.
  static String formatScore(int score, String languageCode) =>
      NumberFormat.decimalPattern(languageCode).format(score);

  // ── Posición / Ranking ────────────────────────────────────────────────────

  /// Formatea una posición de ranking con sufijo ordinal según el locale.
  ///
  /// Es: "1.°", "2.°", "3.°"  (uso del punto ordinal español)
  /// En: "1st", "2nd", "3rd", "4th"
  /// Pt: "1.°", "2.°"
  ///
  /// Úsalo en tablas de líderes y posiciones en desafíos.
  static String formatRank(int position, String languageCode) {
    if (languageCode == 'en') return _englishOrdinal(position);
    return '$position.°';
  }

  // ── XP y Niveles ──────────────────────────────────────────────────────────

  /// Formatea una cantidad de XP con símbolo + para ganancias positivas.
  ///
  /// Es/En: "+1,250"
  ///
  /// Úsalo en las notificaciones flotantes de XP ganado.
  static String formatXpGain(int amount, String languageCode) =>
      '+${NumberFormat.decimalPattern(languageCode).format(amount)}';

  /// Formatea el nivel del jugador como número sin separadores.
  ///
  /// Es/En: "42"  (nunca "42.0" ni "42,000")
  static String formatLevel(int level, String languageCode) =>
      NumberFormat.decimalPattern(languageCode).format(level);

  // ── Helpers Privados ──────────────────────────────────────────────────────

  static String _englishOrdinal(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    return switch (n % 10) {
      1 => '${n}st',
      2 => '${n}nd',
      3 => '${n}rd',
      _ => '${n}th',
    };
  }
}
