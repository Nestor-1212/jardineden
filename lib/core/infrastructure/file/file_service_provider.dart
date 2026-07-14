// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/file/file_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de FileService.
//
// CICLO DE VIDA: Singleton (keepAlive: true) — stateless (const).
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, file_service_impl.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/file/file_service.dart';
import 'package:jardindeleden/core/file/file_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_service_provider.g.dart';

/// Instancia singleton de [FileService].
@Riverpod(keepAlive: true)
FileService fileService(FileServiceRef ref) => const FileServiceImpl();
