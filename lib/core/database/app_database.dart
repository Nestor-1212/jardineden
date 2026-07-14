// ─────────────────────────────────────────────────────────────────────────────
// core/database/app_database.dart
//
// RESPONSABILIDAD:
//   Define la clase AppDatabase de Drift y registra todas las tablas
//   y DAOs del proyecto en un único lugar.
//
// INSTANCIACIÓN:
//   AppDatabase es un singleton. Una sola instancia existe durante
//   toda la vida de la aplicación. Se registra en core/di/.
//
// CIFRADO:
//   En staging y prod, la base de datos se abre con SQLCipher.
//   La clave de cifrado se lee de core/security/security_service.dart.
//   En dev, la base de datos se abre sin cifrar para facilitar inspección.
//
// TABLAS REGISTRADAS (se agregan en cada Sprint de Feature):
//   • PlayerProfilesTable    (Feature: auth)
//   • SessionsTable          (Feature: auth)
//   • CurrencyBalanceTable   (Feature: economy)
//   • TransactionsTable      (Feature: economy)
//   • WorldProgressTable     (Feature: world)
//   • ChapterProgressTable   (Feature: chapter)
//   • VerseFoundTable        (Feature: verse)
//   • Sistema44QueueTable    (Feature: verse)
//   • MissionsTable          (Feature: mission)
//   • InventoryTable         (Feature: inventory)
//   • PetStateTable          (Feature: pet)
//   • DiaryEntriesTable      (Feature: diary)
//   • CollectionTable        (Feature: collection)
//   • NotificationsTable     (Feature: notification)
//   • StatsSessionTable      (Feature: stats)
//   • SeasonalEventsTable    (Feature: seasonal)
//   • SyncQueueTable         (Feature: sync)
//   • SystemLogTable         (Core: logging)
//   • BackupMetaTable        (Core: backup)
//   + Tablas de catálogo de contenido (mundos, capítulos, versículos, ítems)
//
// DAOS REGISTRADOS (uno por feature, se agregan en cada Sprint):
//   • AuthDao, EconomyDao, WorldDao, ChapterDao, VerseDao,
//     MissionDao, InventoryDao, PetDao, DiaryDao, CollectionDao,
//     NotificationDao, StatsDao, SeasonalDao, SyncDao
//
// DEPENDENCIAS PERMITIDAS:   drift, core/config/app_config.dart
// DEPENDENCIAS PROHIBIDAS:   features, shared, flutter/widgets.dart
//
// NOTA: Este archivo requiere build_runner para generar app_database.g.dart.
//       Comando: flutter pub run build_runner build --delete-conflicting-outputs
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core (Base de Datos)
// ─────────────────────────────────────────────────────────────────────────────

// Archivo pendiente de implementación.
// Requiere instalación del paquete drift en pubspec.yaml.
// Se implementa en el Sprint de Dependencias + Sprint del Módulo Core.
//
// La estructura seguirá este esquema:
//
// @DriftDatabase(tables: [...], daos: [...])
// class AppDatabase extends _$AppDatabase {
//   AppDatabase(QueryExecutor executor) : super(executor);
//
//   @override
//   int get schemaVersion => AppConfig.databaseSchemaVersion;
//
//   @override
//   MigrationStrategy get migration => MigrationStrategy(
//     onCreate: (Migrator m) async { await m.createAll(); },
//     onUpgrade: (Migrator m, int from, int to) async { ... },
//     beforeOpen: (details) async {
//       await customStatement('PRAGMA foreign_keys = ON');
//       await customStatement('PRAGMA journal_mode = WAL');
//     },
//   );
// }
