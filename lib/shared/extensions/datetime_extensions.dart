// ─────────────────────────────────────────────────────────────────────────────
// shared/extensions/datetime_extensions.dart
//
// RESPONSABILIDAD:
//   Extensiones de DateTime para las necesidades específicas del juego.
//   Principalmente para el Sistema 44, límites diarios de Luz, y estadísticas.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, librerías, intl, features, core.
// ─────────────────────────────────────────────────────────────────────────────

extension DateTimeExtensions on DateTime {
  /// true si este DateTime corresponde al mismo día calendario que [other].
  ///
  /// Ignora la hora. Solo compara año, mes y día.
  /// Usado para verificar si el límite diario de Luz se resetea.
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// true si este DateTime es el día de hoy (ignorando la hora).
  bool get isToday => isSameDay(DateTime.now());

  /// true si este DateTime fue ayer.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  /// Retorna este DateTime con la hora en medianoche (00:00:00.000).
  /// Útil para comparaciones de día completo.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Retorna este DateTime al final del día (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Diferencia en días completos desde [other] hasta este DateTime.
  ///
  /// Ejemplo: si hoy es 12 y [other] es el 10, retorna 2.
  int daysSince(DateTime other) =>
      startOfDay.difference(other.startOfDay).inDays;

  /// Formato de fecha compacto para logs y persistencia.
  ///
  /// Formato: 'YYYY-MM-DD'
  String get toIsoDate =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  /// Formato de timestamp completo para logs.
  ///
  /// Formato: 'YYYY-MM-DDTHH:MM:SS.mmmZ'
  String get toIsoTimestamp => toUtc().toIso8601String();

  /// true si el intervalo del Sistema 44 ha transcurrido.
  ///
  /// [intervalHours]: el intervalo requerido en horas.
  bool hasIntervalElapsed(int intervalHours) {
    final elapsed = DateTime.now().difference(this);
    return elapsed.inHours >= intervalHours;
  }
}
