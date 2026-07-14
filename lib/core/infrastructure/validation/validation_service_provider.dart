// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/validation/validation_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de ValidationService.
//
// CICLO DE VIDA: Singleton (keepAlive: true) — stateless (const).
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, validation_service_impl.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/validation/validation_service.dart';
import 'package:jardindeleden/core/validation/validation_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'validation_service_provider.g.dart';

/// Instancia singleton de [ValidationService].
@Riverpod(keepAlive: true)
ValidationService validationService(ValidationServiceRef ref) =>
    const ValidationServiceImpl();
