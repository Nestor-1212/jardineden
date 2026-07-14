// ─────────────────────────────────────────────────────────────────────────────
// domain/core/i_repository.dart
//
// RESPONSABILIDAD:
//   Interfaz marcador base para todos los repositorios del dominio.
//
// PRINCIPIO DE INVERSIÓN DE DEPENDENCIAS:
//   El dominio define la INTERFAZ del repositorio. La implementación vive en
//   la capa de datos (lib/data/repositories/). Los casos de uso dependen
//   de la interfaz, nunca de la implementación concreta.
//
//   Dominio:  IProfileRepository (interfaz)
//   Datos:    ProfileRepository  implements IProfileRepository (implementación)
//   DI:       Riverpod registra ProfileRepository como IProfileRepository
//
// CONVENCIÓN DE NOMENCLATURA:
//   Interfaz:       lib/domain/repositories/i_{name}_repository.dart
//   Implementación: lib/data/repositories/{name}_repository.dart
//   Provider:       lib/data/repositories/{name}_repository_provider.dart
//
// EJEMPLO COMPLETO DE USO:
//   ```dart
//   // 1. Dominio: interfaz
//   // lib/domain/repositories/i_profile_repository.dart
//   abstract interface class IProfileRepository implements IRepository {
//     Future<List<Profile>> getAll();
//     Future<void> save(Profile profile);
//     Future<void> deleteById(String id);
//   }
//
//   // 2. Datos: implementación
//   // lib/data/repositories/profile_repository.dart
//   final class ProfileRepository implements IProfileRepository {
//     const ProfileRepository(this._dataSource);
//     final ProfileLocalDataSource _dataSource;
//
//     @override
//     Future<List<Profile>> getAll() => _dataSource.fetchAll();
//
//     @override
//     Future<void> save(Profile profile) => _dataSource.upsert(profile);
//
//     @override
//     Future<void> deleteById(String id) => _dataSource.delete(id);
//   }
//
//   // 3. DI: registrar la implementación bajo la interfaz
//   // lib/data/repositories/profile_repository_provider.dart
//   @Riverpod(keepAlive: true)
//   IProfileRepository profileRepository(ProfileRepositoryRef ref) =>
//       ProfileRepository(ref.watch(profileLocalDataSourceProvider));
//   ```
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   flutter, riverpod, data, features.
// ─────────────────────────────────────────────────────────────────────────────

/// Interfaz marcador base para todos los repositorios del dominio.
///
/// No define métodos comunes: los repositorios son demasiado específicos
/// para compartir una API uniforme. Su función es:
///   1. Documentar que una clase es un repositorio del dominio.
///   2. Permitir type-checking genérico si fuera necesario.
///   3. Garantizar que toda implementación de datos satisface el contrato.
///
/// Implementar con `abstract interface class`:
/// ```dart
/// abstract interface class IProfileRepository implements IRepository { ... }
/// ```
abstract interface class IRepository {}
