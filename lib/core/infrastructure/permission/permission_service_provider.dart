// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/permission/permission_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de PermissionService.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, permission_service_impl,
//                            notification_plugin_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/infrastructure/notification/notification_plugin_provider.dart';
import 'package:jardindeleden/core/permission/permission_service.dart';
import 'package:jardindeleden/core/permission/permission_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_service_provider.g.dart';

/// Instancia singleton de [PermissionService].
@Riverpod(keepAlive: true)
PermissionService permissionService(PermissionServiceRef ref) {
  final plugin = ref.watch(notificationPluginProvider);
  return PermissionServiceImpl(plugin: plugin);
}
