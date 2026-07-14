// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/storage/preferences_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de PreferencesService.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, preferences_service_impl,
//                            storage_service_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/infrastructure/storage/storage_service_provider.dart';
import 'package:jardindeleden/core/storage/preferences_service.dart';
import 'package:jardindeleden/core/storage/preferences_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_service_provider.g.dart';

/// Instancia singleton de [PreferencesService].
@Riverpod(keepAlive: true)
Future<PreferencesService> preferencesService(PreferencesServiceRef ref) async {
  final storage = await ref.watch(storageServiceProvider.future);
  return PreferencesServiceImpl(storage: storage);
}
