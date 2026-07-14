// ─────────────────────────────────────────────────────────────────────────────
// core/audit/audit_entry.dart
//
// RESPONSABILIDAD:
//   Estructura inmutable de UNA entrada del registro de auditoría local.
//
// POR QUÉ AUDITORÍA ES DISTINTA DE UN LOG NORMAL:
//   Un log técnico (AppLogger) es efímero por diseño — sirve para depurar
//   la sesión actual y puede perderse sin consecuencias. Un registro de
//   auditoría es la prueba local de "qué acción parental ocurrió y cuándo"
//   (validación de PIN, borrado de un perfil, exportación de datos) — debe
//   PERSISTIR entre sesiones para que un padre pueda revisarlo. Por eso
//   AuditLogger escribe a disco (ver audit_logger_impl.dart) además de
//   pasar por AppLogger para observabilidad en desarrollo.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// ─────────────────────────────────────────────────────────────────────────────

/// Las acciones auditables del proyecto.
///
/// `sealed`-like por convención (enum ya es cerrado en Dart) — agregar una
/// acción nueva es una decisión deliberada, no un string libre.
enum AuditAction {
  pinVerified,
  pinFailed,
  profileCreated,
  profileDeleted,
  parentalSettingChanged,
  dataExported,
  dataDeleted,
}

/// Una entrada inmutable del registro de auditoría local.
final class AuditEntry {
  const AuditEntry({
    required this.timestamp,
    required this.action,
    required this.actorAnonymousId,
    this.target,
    this.metadata = const {},
  });

  final DateTime timestamp;
  final AuditAction action;

  /// UUID anónimo de quién realizó la acción (nunca un nombre).
  final String actorAnonymousId;

  /// UUID del recurso afectado, si aplica (ej. el perfil que se borró).
  final String? target;

  final Map<String, Object?> metadata;

  Map<String, Object?> toJson() => {
        'timestamp': timestamp.toUtc().toIso8601String(),
        'action': action.name,
        'actor': actorAnonymousId,
        if (target != null) 'target': target,
        if (metadata.isNotEmpty) 'metadata': metadata,
      };

  factory AuditEntry.fromJson(Map<String, Object?> json) => AuditEntry(
        timestamp: DateTime.parse(json['timestamp']! as String),
        action: AuditAction.values.byName(json['action']! as String),
        actorAnonymousId: json['actor']! as String,
        target: json['target'] as String?,
        metadata: (json['metadata'] as Map<String, Object?>?) ?? const {},
      );
}
