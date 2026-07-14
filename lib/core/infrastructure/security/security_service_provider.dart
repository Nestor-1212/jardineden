// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/security/security_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de SecurityService.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   SecurityServiceImpl es stateless (delega todo el estado en SecureStorage).
//   Una sola instancia es suficiente durante toda la sesión.
//
// PROVIDER SÍNCRONO:
//   No requiere inicialización asíncrona propia — depende de
//   secureStorageProvider, que ya es síncrono.
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, security_service_impl,
//                            core/infrastructure/storage/secure_storage_provider.dart,
//                            core/infrastructure/encryption/encryption_service_provider.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/infrastructure/encryption/encryption_service_provider.dart';
import 'package:jardindeleden/core/infrastructure/storage/secure_storage_provider.dart';
import 'package:jardindeleden/core/security/security_service.dart';
import 'package:jardindeleden/core/security/security_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_service_provider.g.dart';

/// Instancia singleton de [SecurityService].
///
/// [keepAlive: true] — la clave de cifrado y el hashing de PIN se solicitan
/// durante toda la sesión (apertura de DB, verificación del Panel de Padres).
@Riverpod(keepAlive: true)
SecurityService securityService(SecurityServiceRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final encryption = ref.watch(encryptionServiceProvider);
  return SecurityServiceImpl(secureStorage: secureStorage, encryption: encryption);
}
