// ─────────────────────────────────────────────────────────────────────────────
// core/date/date_service.dart
//
// RESPONSABILIDAD:
//   Abstrae el acceso al reloj del sistema detrás de una interfaz inyectable.
//   Es el problema clásico de "Clock" en arquitecturas testeables: código
//   que llama a DateTime.now() directamente es imposible de testear de forma
//   determinista (el resultado cambia según cuándo corra el test).
//
// QUÉ NO VIVE AQUÍ:
//   Formateo para UI (eso es shared/formatters/app_date_formatter.dart, que
//   SÍ puede depender de intl y de l10n). Lógica de calendario del juego
//   como el Sistema 44 (eso es shared/utils/date_utils.dart y
//   shared/extensions/datetime_extensions.dart). DateService es más bajo
//   nivel que ambos: es la única fuente de "qué hora es ahora" en el
//   sistema, para que esos otros módulos —y cualquier feature— dependan de
//   una hora inyectable en vez de DateTime.now() disperso por el código.
//
// USO EN TESTS:
//   ```dart
//   final fixedClock = FixedDateService(DateTime(2026, 1, 1));
//   final container = ProviderContainer(
//     overrides: [dateServiceProvider.overrideWithValue(fixedClock)],
//   );
//   ```
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, intl, features, shared.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del servicio de reloj del sistema.
abstract interface class DateService {
  /// Hora actual en la zona horaria local del dispositivo.
  DateTime now();

  /// Hora actual en UTC. Usar para todo lo que se persiste (ver
  /// DateUtils.toStorageString, que asume que ya recibe una hora UTC).
  DateTime nowUtc();

  /// Milisegundos desde epoch (UTC). Útil para IDs ordenables y timestamps
  /// compactos en logs.
  int nowEpochMillis();
}
