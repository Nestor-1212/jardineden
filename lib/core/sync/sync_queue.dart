// ─────────────────────────────────────────────────────────────────────────────
// core/sync/sync_queue.dart
//
// RESPONSABILIDAD:
//   Define el contrato de la cola de sincronización futura con Laravel.
//
// ESTADO: ACTIVO PERO INACTIVO.
//   La cola SE LLENA desde el primer día de uso del juego
//   (cada operación crítica genera una entrada en la cola).
//   La cola NO SE PROCESA hasta que exista el servidor Laravel (Año 3).
//   Esto garantiza que cuando el servidor exista, tendrá el historial
//   COMPLETO de operaciones desde el primer día de uso.
//
// CICLO DE VIDA DE UNA OPERACIÓN EN LA COLA:
//   PENDING → IN_FLIGHT → CONFIRMED (o FAILED o SUPERSEDED)
//
// PRIORIDADES:
//   CRITICAL  : cambios del Panel de Padres
//   HIGH      : capítulos completados, versículos "Grabado en el Corazón"
//   MEDIUM    : economía, colecciones, misiones
//   LOW       : estadísticas, logs, configuración de contenido
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente (el modelo es puro)
// DEPENDENCIAS PROHIBIDAS:   Flutter, http, features, shared
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core (Sync)
// ─────────────────────────────────────────────────────────────────────────────

/// Los estados posibles de una operación en la cola de sincronización.
enum SyncOperationStatus {
  /// Esperando conectividad o prioridad para ser enviada.
  pending,

  /// Se inició el envío pero no hay confirmación del servidor.
  /// Si la app se cierra en este estado, regresa a [pending].
  inFlight,

  /// El servidor confirmó la recepción y aplicación.
  confirmed,

  /// El servidor rechazó la operación (conflicto o error de validación).
  failed,

  /// Una operación posterior sobre el mismo registro la superó.
  /// Se preserva por trazabilidad, pero no se reenvía.
  superseded,
}

/// Tipo de operación CRUD registrada en la cola.
enum SyncOperationType { create, update, delete, softDelete, restore }

/// Prioridad de procesamiento de una operación en la cola.
enum SyncOperationPriority { critical, high, medium, low }

/// Contrato del servicio de cola de sincronización.
///
/// Se activa en Año 3 del roadmap cuando exista el servidor Laravel.
/// Hasta entonces, [enqueue] guarda operaciones en la DB local
/// y [processQueue] retorna inmediatamente sin hacer nada.
abstract interface class SyncQueue {
  /// Agrega una operación a la cola de sincronización.
  ///
  /// [entityType]: tipo de entidad (ej: 'chapter_progress', 'currency_balance')
  /// [entityId]: identificador único del registro afectado
  /// [operationType]: CREATE, UPDATE, DELETE, etc.
  /// [payloadBefore]: estado del registro antes de la operación (null para CREATE)
  /// [payloadAfter]: estado del registro después (null para DELETE definitivo)
  /// [priority]: urgencia de sincronización
  Future<void> enqueue({
    required String entityType,
    required String entityId,
    required SyncOperationType operationType,
    Map<String, Object?>? payloadBefore,
    Map<String, Object?>? payloadAfter,
    SyncOperationPriority priority = SyncOperationPriority.medium,
    Map<String, Object?>? gameContext,
  });

  /// Procesa las operaciones pendientes en la cola.
  /// No hace nada hasta que el servidor Laravel exista (Año 3).
  Future<void> processQueue();

  /// Retorna el número de operaciones pendientes de sincronización.
  Future<int> getPendingCount();
}
