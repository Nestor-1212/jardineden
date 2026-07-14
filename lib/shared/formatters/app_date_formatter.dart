// ─────────────────────────────────────────────────────────────────────────────
// shared/formatters/app_date_formatter.dart
//
// RESPONSABILIDAD:
//   Formateo de fechas y tiempos de manera locale-aware para mostrar en la UI.
//   A diferencia de shared/utils/date_utils.dart (que opera sobre lógica pura
//   de fechas sin locale), este formatter produce strings para el usuario final.
//
// USO EN WIDGETS:
//   ```dart
//   // Fecha larga: "lunes, 13 de julio de 2026" / "Monday, July 13, 2026"
//   AppDateFormatter.formatFull(date, context.languageCode)
//
//   // Fecha corta para el Sistema 44: "13 jul" / "Jul 13"
//   AppDateFormatter.formatShort(date, context.languageCode)
//
//   // Tiempo relativo: "Hace 3 días" / "3 days ago"
//   AppDateFormatter.formatRelative(date, context.l10n)
//
//   // Límite de tiempo de padres: "1 hora" / "1 hour"
//   AppDateFormatter.formatTimeLimitLabel(60, context.l10n)
//   ```
//
// DEPENDENCIAS PERMITIDAS:   dart:core, intl, l10n/generated/.
// DEPENDENCIAS PROHIBIDAS:   flutter, features, core, otros módulos shared.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:intl/intl.dart';
import 'package:jardindeleden/l10n/generated/app_localizations.dart';

abstract final class AppDateFormatter {
  // ── Formatos de Fecha ─────────────────────────────────────────────────────

  /// Formato de fecha completa con nombre del día.
  ///
  /// Es: "lunes, 13 de julio de 2026"
  /// En: "Monday, July 13, 2026"
  static String formatFull(DateTime date, String languageCode) =>
      DateFormat.yMMMMEEEEd(languageCode).format(date);

  /// Formato de fecha corto: para pantallas de revisión del Sistema 44.
  ///
  /// Es: "13 jul."
  /// En: "Jul 13"
  static String formatShort(DateTime date, String languageCode) =>
      DateFormat.MMMd(languageCode).format(date);

  /// Solo el año. Útil para estadísticas anuales.
  ///
  /// Es/En: "2026"
  static String formatYear(DateTime date, String languageCode) =>
      DateFormat.y(languageCode).format(date);

  /// Formato numérico compacto para persistencia-display (no para storage).
  ///
  /// Es: "13/07/2026"
  /// En: "07/13/2026"
  static String formatNumeric(DateTime date, String languageCode) =>
      DateFormat.yMd(languageCode).format(date);

  /// Formato de hora (24h).
  ///
  /// Es/En: "14:30"
  static String formatTime(DateTime date, String languageCode) =>
      DateFormat.Hm(languageCode).format(date);

  // ── Tiempo Relativo ───────────────────────────────────────────────────────

  /// Formatea una fecha como tiempo relativo al momento actual.
  ///
  /// Usa los strings de AppLocalizations para que la UI sea coherente con el
  /// resto del idioma activo.
  ///
  /// Reglas:
  ///   < 1 min  → "Ahora mismo" / "Just now"
  ///   < 60 min → "Hace X minutos" / "X minutes ago"
  ///   < 24 h   → "Hace X horas"  / "X hours ago"
  ///   = hoy    → usa "Hoy"       / "Today"
  ///   = ayer   → usa "Ayer"      / "Yesterday"
  ///   < 7 días → "Hace X días"   / "X days ago"
  ///   ≥ 7 días → "Hace X semanas"/ "X weeks ago"
  static String formatRelative(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);

    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    final daysDiff = today.difference(dateDay).inDays;

    if (daysDiff == 0) return l10n.timeToday;
    if (daysDiff == 1) return l10n.timeYesterday;
    if (daysDiff < 7) return l10n.timeDaysAgo(daysDiff);

    return l10n.timeWeeksAgo(daysDiff ~/ 7);
  }

  /// Formatea una fecha futura como tiempo restante.
  ///
  /// Usado para mostrar cuándo vence el próximo repaso del Sistema 44.
  ///
  /// Reglas:
  ///   = hoy     → "Hoy"       / "Today"
  ///   = mañana  → "Mañana"    / "Tomorrow"
  ///   < 24 h    → "En X horas"/ "In X hours"
  ///   ≥ 1 día   → "En X días" / "In X days"
  static String formatFuture(DateTime target, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = target.difference(now);

    if (diff.isNegative) return l10n.s44DueNow;

    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(target.year, target.month, target.day);
    final daysDiff = targetDay.difference(today).inDays;

    if (daysDiff == 0) return l10n.timeToday;
    if (daysDiff == 1) return l10n.timeTomorrow;
    if (diff.inHours < 24) return l10n.timeInHours(diff.inHours);

    return l10n.timeInDays(daysDiff);
  }

  /// Formatea el próximo repaso del Sistema 44 de manera concisa.
  ///
  /// Para horas < 24: "En 3 horas" / "In 3 hours"
  /// Para días  < 30: "Mañana"     / "Tomorrow"
  /// Para más:        "13 jul."    / "Jul 13"
  static String formatNextReview(DateTime reviewDate, AppLocalizations l10n, String languageCode) {
    final hoursLeft = reviewDate.difference(DateTime.now()).inHours;

    if (hoursLeft <= 0) return l10n.s44DueNow;
    if (hoursLeft < 24) return l10n.s44DueInHours(hoursLeft);
    if (hoursLeft < 48) return l10n.s44DueTomorrow;

    return formatShort(reviewDate, languageCode);
  }

  // ── Formato de Límite de Tiempo Parental ──────────────────────────────────

  /// Formatea un límite de tiempo en minutos con etiquetas amigables.
  ///
  /// Los valores estándar tienen etiquetas especiales:
  ///   30 → "30 minutos" / "30 minutes"
  ///   60 → "1 hora"     / "1 hour"
  ///   90 → "1h 30min"   / "1h 30min"
  ///  120 → "2 horas"    / "2 hours"
  ///
  /// El ARB solo provee el formato genérico `{minutes} minutos`; esta función
  /// intercede para los casos especiales antes de llamar al string ARB.
  static String formatTimeLimitLabel(int minutes, AppLocalizations l10n) =>
      switch (minutes) {
        60 => _oneHourLabel(l10n),
        120 => _twoHoursLabel(l10n),
        90 => _oneHourHalfLabel(l10n),
        _ => l10n.parentTimeLimitMinutes(minutes),
      };

  // Los métodos privados evitan repetir lógica de idioma aquí:
  // Estas cadenas son cortas y semánticamente claras, así que las ponemos
  // en el formatter en vez de añadir 6+ keys al ARB para casos de horas.
  // Si en el futuro se necesitan en más idiomas, se promueven a ARB.
  static String _oneHourLabel(AppLocalizations l10n) =>
      l10n.languageCode == 'en' ? '1 hour' : l10n.languageCode == 'pt' ? '1 hora' : '1 hora';

  static String _twoHoursLabel(AppLocalizations l10n) =>
      l10n.languageCode == 'en' ? '2 hours' : '2 horas';

  static String _oneHourHalfLabel(AppLocalizations l10n) => '1h 30min';
}

// Extensión de AppLocalizations para acceder al languageCode desde el objeto l10n.
// Permite que formatTimeLimitLabel no necesite un parámetro de idioma extra.
extension _AppLocalizationsLang on AppLocalizations {
  String get languageCode => localeName;
}
