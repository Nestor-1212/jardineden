// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/storage/storage_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de StorageService, construida sobre el
//   SharedPreferences ya precalentado por sharedPreferencesProvider, y
//   envuelta en LoggingStorageService (logs de almacenamiento — ver
//   core/storage/logging_storage_service.dart).
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, storage_service_impl,
//                            logging_storage_service, shared_prefs_provider,
//                            app_logger_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/infrastructure/logging/app_logger_provider.dart';
import 'package:jardindeleden/core/infrastructure/storage/shared_prefs_provider.dart';
import 'package:jardindeleden/core/storage/logging_storage_service.dart';
import 'package:jardindeleden/core/storage/storage_service.dart';
import 'package:jardindeleden/core/storage/storage_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service_provider.g.dart';

/// Instancia singleton de [StorageService], decorada con logging.
///
/// [FutureProvider] porque depende de [sharedPreferencesProvider], que es
/// asíncrono. Ya está precalentado en [AppDI.init()].
@Riverpod(keepAlive: true)
Future<StorageService> storageService(StorageServiceRef ref) async {
  final preferences = await ref.watch(sharedPreferencesProvider.future);
  final logger = ref.watch(appLoggerProvider);
  return LoggingStorageService(
    inner: StorageServiceImpl(preferences: preferences),
    logger: logger,
  );
}
