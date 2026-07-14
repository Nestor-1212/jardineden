// ─────────────────────────────────────────────────────────────────────────────
// core/date/date_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de DateService sobre el reloj real del sistema.
//   Ver FixedDateService en este mismo archivo para la variante de test.
//
// DEPENDENCIAS PERMITIDAS:   core/date/date_service.dart (contrato)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/date/date_service.dart';

/// Implementación de [DateService] sobre el reloj real del sistema operativo.
final class SystemDateService implements DateService {
  const SystemDateService();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();

  @override
  int nowEpochMillis() => DateTime.now().toUtc().millisecondsSinceEpoch;
}

/// Implementación de [DateService] con una hora fija — para tests
/// deterministas que no dependen de cuándo corre la suite.
final class FixedDateService implements DateService {
  FixedDateService(this._fixedTime);

  final DateTime _fixedTime;

  @override
  DateTime now() => _fixedTime;

  @override
  DateTime nowUtc() => _fixedTime.toUtc();

  @override
  int nowEpochMillis() => _fixedTime.toUtc().millisecondsSinceEpoch;
}
