// ─────────────────────────────────────────────────────────────────────────────
// core/notification/notification_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de NotificationService sobre flutter_local_notifications.
//
// CANAL DE ANDROID:
//   Un único canal genérico ("jde_general"). Si un Sprint futuro necesita
//   canales separados (ej: uno silencioso para hitos, otro con sonido para
//   recordatorios), se agregan aquí — sigue siendo infraestructura, no
//   contenido.
//
// DEPENDENCIAS PERMITIDAS:   flutter_local_notifications, timezone,
//                            core/notification/notification_service.dart (contrato)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jardindeleden/core/notification/notification_service.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Implementación de [NotificationService] sobre flutter_local_notifications.
final class NotificationServiceImpl implements NotificationService {
  NotificationServiceImpl({required FlutterLocalNotificationsPlugin plugin})
      : _plugin = plugin;

  final FlutterLocalNotificationsPlugin _plugin;

  static const String _channelId = 'jde_general';
  static const String _channelName = 'General';
  static const String _channelDescription =
      'Notificaciones generales de Jardín del Edén';

  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) {
    return _plugin.show(id, title, body, _details(), payload: payload);
  }

  @override
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.UTC);

    return _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  NotificationDetails _details() => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
        ),
        iOS: DarwinNotificationDetails(),
      );
}
