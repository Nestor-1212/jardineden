// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/database/app_database.dart
//
// RESPONSABILIDAD:
//   Clase base de la base de datos SQLite cifrada del juego.
//
// ESTADO ACTUAL: PLACEHOLDER — Sprint DB
//   Este archivo es un placeholder que permite al DI compilar antes de que
//   el sprint de base de datos (Drift + SQLCipher) esté implementado.
//
// SPRINT DB — Lo que reemplazará este archivo:
//   • Drift database class con @DriftDatabase annotation
//   • Todas las tablas del juego (Profiles, Sessions, Progress, etc.)
//   • Migraciones de schema con versioning y rollback
//   • Cifrado AES-256 via NativeDatabase con SQLCipher
//   • DAOs por feature (ProfileDao, ProgressDao, etc.)
//
// EJEMPLO DE LO QUE VENDRÁ:
//   ```dart
//   @DriftDatabase(tables: [Profiles, Sessions, S44Progress, ...], daos: [...])
//   class AppDatabase extends _$AppDatabase {
//     AppDatabase(QueryExecutor executor) : super(executor);
//
//     @override
//     int get schemaVersion => 1;
//
//     @override
//     MigrationStrategy get migration => MigrationStrategy(
//       onCreate: (m) => m.createAll(),
//       onUpgrade: (m, from, to) async { ... },
//     );
//   }
//   ```
//
// DEPENDENCIAS PERMITIDAS:   dart:async.
// DEPENDENCIAS PROHIBIDAS:   drift (hasta Sprint DB), features.
// ─────────────────────────────────────────────────────────────────────────────

/// Base de datos SQLite cifrada del juego Jardín del Edén.
///
/// Sprint actual: placeholder sin tablas.
/// Sprint DB: implementación completa con Drift + SQLCipher + todas las tablas.
class AppDatabase {
  AppDatabase({required this.encryptionKey});

  /// Clave AES-256 usada para cifrar la base de datos con SQLCipher.
  final String encryptionKey;

  /// Cierra la conexión a la base de datos liberando recursos nativos.
  ///
  /// Llamado automáticamente desde [appDatabaseProvider] via ref.onDispose().
  Future<void> close() async {
    // Sprint DB: await _database.close();
  }
}
