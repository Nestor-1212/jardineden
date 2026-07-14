// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/connectivity/connectivity_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de ConnectivityService.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   Connectivity() de connectivity_plus ya es un singleton internamente;
//   se envuelve una sola vez aquí para no duplicar listeners de plataforma.
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, connectivity_plus,
//                            connectivity_service_impl.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:jardindeleden/core/connectivity/connectivity_service.dart';
import 'package:jardindeleden/core/connectivity/connectivity_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service_provider.g.dart';

/// Instancia singleton de [ConnectivityService].
@Riverpod(keepAlive: true)
ConnectivityService connectivityService(ConnectivityServiceRef ref) {
  return ConnectivityServiceImpl(connectivity: Connectivity());
}
