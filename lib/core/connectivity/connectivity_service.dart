// ─────────────────────────────────────────────────────────────────────────────
// core/connectivity/connectivity_service.dart
//
// RESPONSABILIDAD:
//   Detecta si el dispositivo tiene una conexión de red activa (wifi, datos
//   móviles, ethernet) y expone un stream de cambios.
//
// PREPARADO PARA EL FUTURO:
//   Jardín del Edén es offline-first — hoy ningún flujo depende de la red.
//   Este servicio existe para el Año 3 del roadmap (sincronización con
//   Laravel), igual que SyncQueue (core/sync/): el contrato y la
//   implementación ya están completos y funcionan, pero no tienen
//   consumidores todavía. Cuando SyncQueue necesite decidir cuándo intentar
//   sincronizar, consultará este servicio.
//
// QUÉ NO GARANTIZA:
//   Que haya INTERNET real, solo que el dispositivo tiene una interfaz de
//   red activa (puede haber wifi sin salida a internet). Verificar
//   alcanzabilidad real del servidor Laravel es responsabilidad de la
//   futura capa de sincronización, no de este servicio.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:async.
// DEPENDENCIAS PROHIBIDAS:   features, shared, core/sync (relación inversa:
//                            sync consultará connectivity, no al revés).
// ─────────────────────────────────────────────────────────────────────────────

/// Estado de conectividad de red, simplificado a lo que el proyecto necesita.
///
/// Deliberadamente no expone el tipo de red (wifi/datos/ethernet) — el
/// proyecto solo necesita saber "¿puedo intentar sincronizar o no?".
enum ConnectivityStatus {
  online,
  offline;

  bool get isOnline => this == ConnectivityStatus.online;
}

/// Contrato del servicio de conectividad de red.
abstract interface class ConnectivityService {
  /// Consulta el estado actual de conectividad, una sola vez.
  Future<ConnectivityStatus> checkStatus();

  /// Emite un nuevo valor cada vez que el estado de conectividad cambia.
  Stream<ConnectivityStatus> get onStatusChanged;
}
