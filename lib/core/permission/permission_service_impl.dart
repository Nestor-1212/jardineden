// ─────────────────────────────────────────────────────────────────────────────
// core/permission/permission_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de PermissionService sobre las APIs de permiso que ya
//   expone flutter_local_notifications — evita agregar permission_handler
//   como dependencia adicional solo para el único permiso que el proyecto
//   necesita hoy (notificaciones).
//
// LIMITACIÓN DOCUMENTADA:
//   checkPermission() en iOS no puede consultarse sin abrir el diálogo
//   nativo con esta librería — se reporta [AppPermissionStatus.notDetermined]
//   en vez de adivinar. Android sí soporta la consulta real
//   (areNotificationsEnabled()).
//
// DEPENDENCIAS PERMITIDAS:   flutter_local_notifications,
//                            core/permission/permission_service.dart (contrato)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jardindeleden/core/permission/permission_service.dart';

/// Implementación de [PermissionService] sobre flutter_local_notifications.
final class PermissionServiceImpl implements PermissionService {
  PermissionServiceImpl({required FlutterLocalNotificationsPlugin plugin})
      : _plugin = plugin;

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<AppPermissionStatus> checkPermission(AppPermission permission) async {
    switch (permission) {
      case AppPermission.notifications:
        final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

        if (androidPlugin != null) {
          final enabled = await androidPlugin.areNotificationsEnabled();
          return (enabled ?? false)
              ? AppPermissionStatus.granted
              : AppPermissionStatus.denied;
        }

        return AppPermissionStatus.notDetermined;
    }
  }

  @override
  Future<AppPermissionStatus> requestPermission(AppPermission permission) async {
    switch (permission) {
      case AppPermission.notifications:
        final androidGranted = await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();

        final iosGranted = await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);

        final granted = androidGranted ?? iosGranted ?? false;
        return granted ? AppPermissionStatus.granted : AppPermissionStatus.denied;
    }
  }
}
