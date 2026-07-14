// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/database/app_database.dart
//
// RESPONSABILIDAD:
//   Define la clase AppDatabase de Drift. Es el ÚNICO punto del proyecto
//   donde se declara @DriftDatabase y se controla schemaVersion/migration.
//
// ESTADO ACTUAL — Sprint de Infraestructura de Almacenamiento:
//   Sin tablas todavía (tables: [], daos: []). Cada Sprint de Feature agrega
//   sus tablas y DAOs a las listas del @DriftDatabase de abajo. Esta clase
//   NO se reescribe — solo se le agregan miembros a las listas.
//
// CIFRADO:
//   Esta clase NO sabe cómo se cifra la base de datos. Recibe un
//   QueryExecutor ya configurado (con la clave SQLCipher inyectada) desde
//   database_connection.dart vía database_provider.dart. Mantener esta
//   separación permite testear AppDatabase con NativeDatabase.memory()
//   sin tocar SQLCipher.
//
// VERSIONADO:
//   schemaVersion vive en AppConfig.databaseSchemaVersion — un único lugar,
//   nunca un literal aquí. Se incrementa en +1 en cada migración, nunca
//   decrece, nunca se salta un número (Drift ejecuta onUpgrade una vez por
//   número de versión intermedio si se usa stepByStep en el futuro).
//
// MIGRACIONES:
//   onCreate    → instalación nueva: crea todas las tablas registradas.
//   onUpgrade   → dispara onBeforeMigrate (backup pre-migración inyectado
//                 desde database_provider.dart) y luego las migraciones
//                 incrementales de cada Sprint, en bloques `if (from < N)`.
//   beforeOpen  → se ejecuta SIEMPRE (alta o apertura normal): activa
//                 foreign_keys y journal_mode WAL.
//
// POR QUÉ onBeforeMigrate ES UN CALLBACK Y NO UN IMPORT DE BackupService:
//   Esta clase solo puede depender de drift y app_config (ver abajo).
//   BackupService vive en una capa distinta y depende de dart:io — si
//   AppDatabase lo importara directamente se generaría una dependencia
//   cruzada entre core/database y core/backup. El callback desacopla
//   ambas capas: database_provider.dart (capa de composición) es quien
//   conecta AppDatabase con BackupService.
//
// TABLAS Y DAOS (se agregan en cada Sprint de Feature — ver comentario
// histórico de este archivo en git log para la lista completa planeada):
//   PlayerProfilesTable, SessionsTable, CurrencyBalanceTable, etc.
//
// DEPENDENCIAS PERMITIDAS:   drift, core/config/app_config.dart
// DEPENDENCIAS PROHIBIDAS:   features, shared, flutter/widgets.dart,
//                            core/backup, core/security (usar callbacks)
//
// NOTA: Este archivo requiere build_runner para generar app_database.g.dart.
//       Comando: flutter pub run build_runner build --delete-conflicting-outputs
// ─────────────────────────────────────────────────────────────────────────────

import 'package:drift/drift.dart';
import 'package:jardindeleden/core/config/app_config.dart';

part 'app_database.g.dart';

/// Base de datos SQLite cifrada del juego Jardín del Edén.
///
/// Sin tablas en este Sprint — solo infraestructura (versionado, migraciones,
/// pragmas de integridad). Las tablas del juego se agregan en los Sprints
/// de cada feature.
@DriftDatabase()
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor, {this.onBeforeMigrate});

  /// Hook invocado antes de aplicar cualquier migración (no se llama en
  /// onCreate, solo en onUpgrade). Inyectado desde database_provider.dart
  /// para disparar un backup pre-migración sin acoplar esta clase a
  /// BackupService.
  final Future<void> Function(int from, int to)? onBeforeMigrate;

  /// Versión del esquema. Única fuente de verdad: [AppConfig.databaseSchemaVersion].
  @override
  int get schemaVersion => AppConfig.databaseSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      await onBeforeMigrate?.call(from, to);

      // Sprint de cada feature: agregar aquí las migraciones incrementales,
      // en bloques secuenciales y SIN reordenar los ya existentes.
      // Ejemplo (Sprint Auth, v1 -> v2):
      //   if (from < 2) {
      //     await m.createTable(playerProfiles);
      //   }
    },
    beforeOpen: (OpeningDetails details) async {
      // Debe ejecutarse en cada apertura (SQLite no persiste estas
      // pragmas entre conexiones).
      await customStatement('PRAGMA foreign_keys = ON;');
      await customStatement('PRAGMA journal_mode = WAL;');
    },
  );
}
