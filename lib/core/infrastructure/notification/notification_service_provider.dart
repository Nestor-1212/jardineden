// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/notification/notification_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de NotificationService.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   No se llama a initialize() aquí — queda a cargo del consumidor (Sprint
//   futuro) llamarlo cuando corresponda, ej: después de que el usuario
//   acepte el permiso. Igual que appDatabaseProvider, esta infraestructura
//   se deja lista pero se activa explícitamente, no en warm-up de AppDI.
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, notification_service_impl,
//                            notification_plugin_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/infrastructure/notification/notification_plugin_provider.dart';
import 'package:jardindeleden/core/notification/notification_service.dart';
import 'package:jardindeleden/core/notification/notification_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service_provider.g.dart';

/// Instancia singleton de [NotificationService].
@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  final plugin = ref.watch(notificationPluginProvider);
  return NotificationServiceImpl(plugin: plugin);
}
