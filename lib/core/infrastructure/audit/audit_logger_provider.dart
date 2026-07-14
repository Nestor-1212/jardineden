// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/audit/audit_logger_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de AuditLogger.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, audit_logger_impl,
//                            file_service_provider, app_logger_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/audit/audit_logger.dart';
import 'package:jardindeleden/core/audit/audit_logger_impl.dart';
import 'package:jardindeleden/core/infrastructure/file/file_service_provider.dart';
import 'package:jardindeleden/core/infrastructure/logging/app_logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audit_logger_provider.g.dart';

/// Instancia singleton de [AuditLogger].
@Riverpod(keepAlive: true)
AuditLogger auditLogger(AuditLoggerRef ref) {
  return AuditLoggerImpl(
    fileService: ref.watch(fileServiceProvider),
    logger: ref.watch(appLoggerProvider),
  );
}
