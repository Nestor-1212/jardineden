// ─────────────────────────────────────────────────────────────────────────────
// core/di/providers_registry.dart
//
// RESPONSABILIDAD:
//   Barrel de exportación de TODOS los providers del proyecto.
//   Permite importar cualquier provider con una sola línea.
//
// CÓMO USARLO:
//   En lugar de importar cada provider individualmente:
//   ```dart
//   // ✗ Antes — múltiples imports:
//   import 'package:jardindeleden/core/infrastructure/storage/shared_prefs_provider.dart';
//   import 'package:jardindeleden/core/infrastructure/storage/secure_storage_provider.dart';
//   import 'package:jardindeleden/core/infrastructure/audio/audio_service_provider.dart';
//
//   // ✓ Ahora — un solo import:
//   import 'package:jardindeleden/core/di/providers_registry.dart';
//   ```
//
// REGLA: Agregar un export por cada nuevo provider que se cree en el proyecto.
//   Los providers generados por @riverpod exportan automáticamente sus .g.dart
//   a través del archivo fuente — no es necesario exportar los .g.dart aquí.
//
// ORGANIZACIÓN POR CAPA (de infraestructura a presentación):
//   1. Core Infrastructure
//   2. Navigation
//   3. Data: Data Sources
//   4. Data: Repositories
//   5. Domain: Use Cases
//   6. Features: Notifiers
//
// ─────────────────────────────────────────────────────────────────────────────

// ── 1. Core Infrastructure ────────────────────────────────────────────────────
// Singleton providers de capa de plataforma.
// Ciclo de vida: keepAlive: true (nunca se descartan).

export 'package:jardindeleden/core/infrastructure/audio/audio_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/audit/audit_logger_provider.dart';
export 'package:jardindeleden/core/infrastructure/backup/backup_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/cache/cache_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/connectivity/connectivity_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/database/database_provider.dart';
export 'package:jardindeleden/core/infrastructure/date/date_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/encryption/encryption_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/error/error_handler_provider.dart';
export 'package:jardindeleden/core/infrastructure/file/file_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/logging/app_logger_provider.dart';
export 'package:jardindeleden/core/infrastructure/logging/educational_event_logger_provider.dart';
export 'package:jardindeleden/core/infrastructure/logging/log_sinks_provider.dart';
export 'package:jardindeleden/core/infrastructure/logging/navigation_logger_provider.dart';
export 'package:jardindeleden/core/infrastructure/logging/performance_logger_provider.dart';
export 'package:jardindeleden/core/infrastructure/notification/notification_plugin_provider.dart';
export 'package:jardindeleden/core/infrastructure/notification/notification_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/permission/permission_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/security/security_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/storage/preferences_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/storage/secure_storage_provider.dart';
export 'package:jardindeleden/core/infrastructure/storage/shared_prefs_provider.dart';
export 'package:jardindeleden/core/infrastructure/storage/storage_service_provider.dart';
export 'package:jardindeleden/core/infrastructure/uuid/uuid_provider.dart';
export 'package:jardindeleden/core/infrastructure/validation/validation_service_provider.dart';

// ── 2. Navigation ─────────────────────────────────────────────────────────────
// Router de GoRouter como Provider<GoRouter>.

export 'package:jardindeleden/core/navigation/app_router.dart';

// ── 3. Data: Data Sources ─────────────────────────────────────────────────────
// Sprint DB / Auth: agregar providers de data sources locales aquí.
// Ciclo de vida: keepAlive: true (wrappers stateless sobre AppDatabase).
//
// export 'package:jardindeleden/data/datasources/profile_local_data_source_provider.dart';
// export 'package:jardindeleden/data/datasources/progress_local_data_source_provider.dart';
// export 'package:jardindeleden/data/datasources/s44_local_data_source_provider.dart';

// ── 4. Data: Repositories ─────────────────────────────────────────────────────
// Sprint Auth: agregar providers de implementaciones de repositorios aquí.
// Registrar bajo la interfaz del dominio para facilitar mocks en tests.
//
// export 'package:jardindeleden/data/repositories/profile_repository_provider.dart';
// export 'package:jardindeleden/data/repositories/progress_repository_provider.dart';

// ── 5. Domain: Use Cases ──────────────────────────────────────────────────────
// Un export por use case a medida que se implementen los sprints de features.
// Ciclo de vida: keepAlive: true (stateless, sin recursos propios).
//
// export 'package:jardindeleden/domain/usecases/profiles/get_profiles_use_case_provider.dart';
// export 'package:jardindeleden/domain/usecases/profiles/save_profile_use_case_provider.dart';
// export 'package:jardindeleden/domain/usecases/auth/validate_pin_use_case_provider.dart';

// ── 6. Features: Notifiers ────────────────────────────────────────────────────
// Cada sprint de feature agrega sus notifiers aquí.
// Ciclo de vida: autoDispose (por pantalla) o keepAlive (estado global de sesión).
//
// export 'package:jardindeleden/features/profiles/notifiers/profiles_notifier.dart';
// export 'package:jardindeleden/features/home/notifiers/hud_notifier.dart';
// export 'package:jardindeleden/features/worlds/notifiers/worlds_notifier.dart';
