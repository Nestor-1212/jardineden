// ─────────────────────────────────────────────────────────────────────────────
// shared/utils/date_utils.dart
//
// RESPONSABILIDAD:
//   Funciones utilitarias de fecha y tiempo que no encajan como extensiones.
//   A diferencia de las extensiones, estas son funciones estáticas que pueden
//   operar sobre múltiples valores o sin un valor receptor.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, librerías, features, core, shared (otros).
// ─────────────────────────────────────────────────────────────────────────────

abstract final class DateUtils {
  /// Construye un DateTime en UTC desde un string ISO 8601.
  ///
  /// Retorna null si el string no es parseable.
  /// Usar para deserializar fechas almacenadas en la base de datos.
  static DateTime? tryParseUtc(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toUtc();
  }

  /// Calcula cuántos días completos han pasado desde [date] hasta hoy.
  static int daysSinceToday(DateTime date) {
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final dateMidnight = DateTime(date.year, date.month, date.day);
    return todayMidnight.difference(dateMidnight).inDays;
  }

  /// Determina si dos periodos de tiempo definen el mismo día calendario.
  ///
  /// Usado por el Sistema 44 para agrupar sesiones del mismo día.
  static bool areSameCalendarDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Calcula el próximo DateTime de revisión para el Sistema 44.
  ///
  /// [lastReview]: cuándo ocurrió la última revisión.
  /// [intervalHours]: el intervalo requerido en horas (de AppConstants.sistema44IntervalsHours).
  static DateTime nextReviewAt(DateTime lastReview, int intervalHours) =>
      lastReview.add(Duration(hours: intervalHours));

  /// true si [reviewDate] ya puede ser revisado (el intervalo ha pasado).
  static bool isDueForReview(DateTime reviewDate) =>
      DateTime.now().isAfter(reviewDate) ||
      areSameCalendarDay(reviewDate, DateTime.now());

  /// Serializa un DateTime a string ISO 8601 en UTC para persistencia.
  ///
  /// Siempre convierte a UTC antes de serializar para evitar problemas de zona.
  static String toStorageString(DateTime date) => date.toUtc().toIso8601String();

  /// Retorna cuántas horas faltan hasta [target] desde ahora.
  ///
  /// Retorna 0 si [target] ya pasó.
  static int hoursUntil(DateTime target) {
    final diff = target.difference(DateTime.now()).inHours;
    return diff < 0 ? 0 : diff;
  }
}
