// ─────────────────────────────────────────────────────────────────────────────
// core/validation/validation_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de ValidationService con expresiones regulares
//   compiladas una sola vez (static final) — no en cada llamada.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, core/validation/validation_service.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/validation/validation_service.dart';

/// Implementación de [ValidationService] basada en expresiones regulares.
final class ValidationServiceImpl implements ValidationService {
  const ValidationServiceImpl();

  static final RegExp _emailPattern = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
  );

  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  static final RegExp _digitsOnlyPattern = RegExp(r'^\d+$');

  static final RegExp _hexColorPattern = RegExp(
    r'^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
  );

  @override
  bool isNotBlank(String? value) => value != null && value.trim().isNotEmpty;

  @override
  bool isEmail(String value) => _emailPattern.hasMatch(value);

  @override
  bool isUuid(String value) => _uuidPattern.hasMatch(value);

  @override
  bool matchesPattern(String value, RegExp pattern) =>
      pattern.hasMatch(value);

  @override
  bool isDigitsOnly(String value) => _digitsOnlyPattern.hasMatch(value);

  @override
  bool hasLengthInRange(String value, {required int min, required int max}) =>
      value.length >= min && value.length <= max;

  @override
  bool isInRange(num value, {required num min, required num max}) =>
      value >= min && value <= max;

  @override
  bool isValidHexColor(String value) => _hexColorPattern.hasMatch(value);
}
