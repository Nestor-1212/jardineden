// ─────────────────────────────────────────────────────────────────────────────
// core/notification/notification_service.dart
//
// RESPONSABILIDAD:
//   Wrapper técnico de notificaciones LOCALES del sistema operativo (no
//   push/remotas — no hay servidor todavía). Mostrar, programar, cancelar.
//
// DIFERENCIA CON features/notification/:
//   features/notification/ es la BANDEJA de notificaciones DENTRO del
//   juego (una tabla futura en Drift con el historial de eventos: "Lumi
//   completó el Mundo 1"). Ese es contenido/dominio.
//   core/notification/ es la capa que, cuando una feature decida avisarle
//   algo al usuario fuera de la app (recordatorio de racha, etc.), sabe
//   CÓMO mostrar un banner del sistema — sin saber POR QUÉ ni CUÁNDO.
//
// ZONA HORARIA (scheduleAt):
//   Este Sprint programa notificaciones en UTC, no en la hora local real
//   del dispositivo (evita agregar flutter_timezone solo para resolver el
//   nombre IANA de la zona horaria). Si un Sprint futuro necesita "todos
//   los días a las 8am hora local con cambios de horario de verano
//   correctos", ese es el momento de agregar esa dependencia — hoy no hay
//   ningún consumidor con ese requisito.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:async.
// DEPENDENCIAS PROHIBIDAS:   features, shared/ui, Flutter widgets.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del servicio de notificaciones locales del sistema operativo.
abstract interface class NotificationService {
  /// Inicializa el plugin nativo. Debe llamarse una vez, antes de show()/
  /// scheduleAt(). Es seguro llamarlo más de una vez (no-op tras la primera).
  Future<void> initialize();

  /// Muestra una notificación inmediatamente.
  ///
  /// [id] identifica la notificación — reutilizar el mismo [id] reemplaza
  /// la notificación anterior en vez de crear una nueva.
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  });

  /// Programa una notificación para [scheduledDate] (interpretada en UTC —
  /// ver nota de zona horaria arriba).
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  });

  /// Cancela una notificación (mostrada o programada) por [id].
  Future<void> cancel(int id);

  /// Cancela TODAS las notificaciones de la app.
  Future<void> cancelAll();
}
