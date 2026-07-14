// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/uuid/uuid_provider.dart
//
// RESPONSABILIDAD:
//   Proveer el generador de UUIDs compartido de la app.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   Uuid es stateless — se puede compartir sin problemas entre providers.
//   Una sola instancia reduce la presión sobre el GC.
//
// CONVENCIÓN DE USO DE UUID EN EL PROYECTO:
//   UUID v4 → device IDs, IDs efímeros donde el orden no importa.
//   UUID v7 → registros de usuario (perfiles, sesiones, progreso):
//     son ordenables cronológicamente y compatibles con índices de DB.
//
// USO EN OTROS PROVIDERS:
//   ```dart
//   @riverpod
//   ProfileRepository profileRepository(ProfileRepositoryRef ref) {
//     final uuid = ref.watch(uuidProvider);
//     return ProfileRepository(uuid: uuid);
//   }
//   ```
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, uuid.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'uuid_provider.g.dart';

/// Instancia global del generador de [Uuid].
///
/// Usar [ref.watch(uuidProvider).v7()] para IDs de registros de usuario.
/// Usar [ref.watch(uuidProvider).v4()] para IDs efímeros o de dispositivo.
@Riverpod(keepAlive: true)
Uuid uuid(UuidRef ref) => const Uuid();
