// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/cache/cache_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de CacheService.
//
// CICLO DE VIDA: Singleton (keepAlive: true) — si no fuera singleton, cada
//   consumidor tendría su propio Map y el cache dejaría de tener sentido.
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, cache_service_impl.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/cache/cache_service.dart';
import 'package:jardindeleden/core/cache/cache_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_service_provider.g.dart';

/// Instancia singleton de [CacheService].
@Riverpod(keepAlive: true)
CacheService cacheService(CacheServiceRef ref) => CacheServiceImpl();
