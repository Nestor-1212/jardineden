// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/encryption/encryption_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de EncryptionService.
//
// CICLO DE VIDA: Singleton (keepAlive: true) — stateless (const).
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, encryption_service_impl.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/encryption/encryption_service.dart';
import 'package:jardindeleden/core/encryption/encryption_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encryption_service_provider.g.dart';

/// Instancia singleton de [EncryptionService].
@Riverpod(keepAlive: true)
EncryptionService encryptionService(EncryptionServiceRef ref) =>
    const EncryptionServiceImpl();
