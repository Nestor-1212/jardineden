// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/date/date_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de DateService (reloj real del sistema).
//
// CICLO DE VIDA: Singleton (keepAlive: true) — es stateless (SystemDateService
//   es const), pero se registra como singleton por convención de DI.
//
// TESTING:
//   ProviderContainer(overrides: [dateServiceProvider.overrideWithValue(
//   FixedDateService(DateTime(2026, 1, 1)))]) — ver date_service_impl.dart.
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, date_service_impl.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/date/date_service.dart';
import 'package:jardindeleden/core/date/date_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_service_provider.g.dart';

/// Instancia singleton de [DateService].
@Riverpod(keepAlive: true)
DateService dateService(DateServiceRef ref) => const SystemDateService();
