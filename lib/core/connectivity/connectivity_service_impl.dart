// ─────────────────────────────────────────────────────────────────────────────
// core/connectivity/connectivity_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de ConnectivityService sobre connectivity_plus.
//   Traduce List<ConnectivityResult> (tipo del plugin) a ConnectivityStatus
//   (tipo propio del proyecto) — así el resto del código nunca importa
//   connectivity_plus directamente.
//
// DEPENDENCIAS PERMITIDAS:   connectivity_plus,
//                            core/connectivity/connectivity_service.dart (contrato)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:jardindeleden/core/connectivity/connectivity_service.dart';

/// Implementación de [ConnectivityService] sobre connectivity_plus.
final class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl({required Connectivity connectivity})
    : _connectivity = connectivity;

  final Connectivity _connectivity;

  @override
  Future<ConnectivityStatus> checkStatus() async {
    final results = await _connectivity.checkConnectivity();
    return _toStatus(results);
  }

  @override
  Stream<ConnectivityStatus> get onStatusChanged =>
      _connectivity.onConnectivityChanged.map(_toStatus);

  /// connectivity_plus solo reporta [ConnectivityResult.none] cuando NO hay
  /// ninguna interfaz activa; cualquier otro valor en la lista implica que
  /// al menos una interfaz de red está arriba.
  ConnectivityStatus _toStatus(List<ConnectivityResult> results) {
    final hasActiveInterface = results.any(
      (result) => result != ConnectivityResult.none,
    );
    return hasActiveInterface
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;
  }
}
