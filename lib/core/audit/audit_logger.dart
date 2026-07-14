// ─────────────────────────────────────────────────────────────────────────────
// core/audit/audit_logger.dart
//
// RESPONSABILIDAD:
//   Registra y persiste acciones administrativas/parentales sensibles —
//   ver audit_entry.dart para por qué esto es distinto de un log técnico.
//
// QUÉ REGISTRAR AQUÍ (y qué no):
//   SÍ: intentos de PIN (éxito/fallo), creación/borrado de perfiles,
//       cambios de configuración parental, exportación/borrado de datos.
//   NO: eventos de juego normales (usar EducationalEventLogger) ni logs
//       técnicos de infraestructura (usar AppLogger directamente).
//
// DEPENDENCIAS PERMITIDAS:   dart:core, core/audit/audit_entry.dart.
// DEPENDENCIAS PROHIBIDAS:   Flutter, features.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/audit/audit_entry.dart';

/// Contrato del registro de auditoría local.
abstract interface class AuditLogger {
  /// Registra y persiste una acción auditable.
  Future<void> record({
    required AuditAction action,
    required String actorAnonymousId,
    String? target,
    Map<String, Object?>? metadata,
  });

  /// Lee todas las entradas persistidas, más recientes primero.
  Future<List<AuditEntry>> readAll();

  /// Borra el registro completo. Usar solo en flujos explícitos de borrado
  /// de datos del jugador (COPPA/GDPR-K) — nunca como parte de limpieza
  /// rutinaria.
  Future<void> clear();
}
