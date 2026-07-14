// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/notification/notification_plugin_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de FlutterLocalNotificationsPlugin.
//   Compartida por NotificationService Y PermissionService (ambos necesitan
//   la MISMA instancia — el plugin nativo mantiene estado de inicialización
//   por instancia).
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, flutter_local_notifications.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_plugin_provider.g.dart';

/// Instancia singleton de [FlutterLocalNotificationsPlugin].
@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin notificationPlugin(NotificationPluginRef ref) {
  return FlutterLocalNotificationsPlugin();
}
