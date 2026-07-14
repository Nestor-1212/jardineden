// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/accessibility/accessibility_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de AccessibilityService.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, accessibility_service_impl,
//                            storage_service_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/accessibility/accessibility_service.dart';
import 'package:jardindeleden/core/accessibility/accessibility_service_impl.dart';
import 'package:jardindeleden/core/infrastructure/storage/storage_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accessibility_service_provider.g.dart';

/// Instancia singleton de [AccessibilityService].
///
/// [FutureProvider] porque depende de [storageServiceProvider], asíncrono.
@Riverpod(keepAlive: true)
Future<AccessibilityService> accessibilityService(
  AccessibilityServiceRef ref,
) async {
  final storage = await ref.watch(storageServiceProvider.future);
  return AccessibilityServiceImpl(storage: storage);
}
