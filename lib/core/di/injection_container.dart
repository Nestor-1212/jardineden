// ─────────────────────────────────────────────────────────────────────────────
// core/di/injection_container.dart
//
// RESPONSABILIDAD:
//   Registra todos los providers de infraestructura del Core en Riverpod.
//   Es el punto de entrada del sistema de Inyección de Dependencias.
//
// PATRÓN:
//   Riverpod actúa como el contenedor de DI del proyecto.
//   Los providers definidos aquí son los "bindings" entre:
//     • Las interfaces del dominio (IChapterRepository)
//     • Las implementaciones concretas (DriftChapterRepository)
//
// PROVIDERS DEL CORE (se expanden con cada sprint):
//   • appConfigProvider         → AppConfig (singleton de configuración)
//   • appLoggerProvider         → AppLogger (singleton de logging)
//   • appDatabaseProvider       → AppDatabase (singleton de Drift)
//   • preferencesServiceProvider → PreferencesService
//   • securityServiceProvider   → SecurityService
//   • backupServiceProvider     → BackupService
//   • syncQueueProvider         → SyncQueue
//   • appRouterProvider         → GoRouter (singleton)
//
// PROVIDERS DE FEATURES (se agregan en el sprint de cada feature):
//   • authRepositoryProvider    → IAuthRepository impl
//   • economyRepositoryProvider → IEconomyRepository impl
//   • etc.
//
// CONVENCIÓN:
//   Los providers de infraestructura del Core se definen AQUÍ.
//   Los providers de estado de la UI (NotifierProviders) se definen
//   en features/[feature]/presentation/providers/
//
// DEPENDENCIAS PERMITIDAS:   riverpod, flutter_riverpod, todos los módulos core
// DEPENDENCIAS PROHIBIDAS:   Flutter widgets directamente, features (solo los
//                             tipos de retorno son permitidos para el binding)
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core (DI)
// ─────────────────────────────────────────────────────────────────────────────

// Este archivo se implementa cuando se instala Riverpod (Sprint de Dependencias).
//
// La estructura seguirá este patrón:
//
// /// Proveedor de la instancia singleton de AppDatabase.
// /// La instancia se crea una vez y se mantiene mientras la app está viva.
// final appDatabaseProvider = Provider<AppDatabase>((ref) {
//   final config = ref.read(appConfigProvider);
//   final security = ref.read(securityServiceProvider);
//   return AppDatabase.connect(config, security);
// });
//
// /// Proveedor del logger central del proyecto.
// final appLoggerProvider = Provider<AppLogger>((ref) {
//   return AppLoggerImpl(
//     minimumLevel: AppConfig.minimumLogLevel,
//     environment: AppConfig.environment,
//   );
// });
//
// /// Proveedor del servicio de preferencias.
// final preferencesServiceProvider = Provider<PreferencesService>((ref) {
//   return SharedPreferencesService();
// });
//
// // ... más providers a medida que se implementan los sprints
