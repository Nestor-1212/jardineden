// ─────────────────────────────────────────────────────────────────────────────
// core/validation/validation_service.dart
//
// RESPONSABILIDAD:
//   Primitivas de validación de FORMATO, genéricas y reutilizables en
//   cualquier proyecto — no conocen ninguna regla del juego.
//
// DIFERENCIA CON shared/validators/input_validators.dart:
//   InputValidators contiene las reglas DE NEGOCIO de Jardín del Edén
//   (nombre de perfil 2-20 caracteres, edad 4-12, PIN de 4 dígitos sin
//   secuencias triviales) y devuelve mensajes de error en español listos
//   para TextFormField.validator. ValidationService es la capa de abajo:
//   "¿es un email con forma válida?", "¿es un UUID?", "¿está en este
//   rango?" — sin mensajes, sin idioma, sin saber qué es un "perfil".
//   InputValidators podría (Sprint futuro, no aquí) delegar en
//   ValidationService para sus chequeos de formato puros.
//
// POR QUÉ ES UN "SERVICIO" (con DI) Y NO SOLO FUNCIONES ESTÁTICAS:
//   Se registra en el sistema de DI para que las features lo consuman de
//   forma consistente con el resto de la infraestructura, y para permitir
//   sustituirlo en tests si algún día una regla de formato necesita
//   configuración (ej: locale-aware).
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   Flutter, features, shared, constantes del juego.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato de validaciones de formato genéricas.
abstract interface class ValidationService {
  /// true si [value] no es null y no queda vacío tras trim().
  bool isNotBlank(String? value);

  /// true si [value] tiene forma de correo electrónico (RFC 5322 simplificado).
  bool isEmail(String value);

  /// true si [value] es un UUID (v1-v7) con formato válido.
  bool isUuid(String value);

  /// true si [value] coincide completamente con [pattern].
  bool matchesPattern(String value, RegExp pattern);

  /// true si [value] contiene solo dígitos (sin signo, sin decimales).
  bool isDigitsOnly(String value);

  /// true si el largo de [value] está entre [min] y [max] (inclusive).
  bool hasLengthInRange(String value, {required int min, required int max});

  /// true si [value] está entre [min] y [max] (inclusive).
  bool isInRange(num value, {required num min, required num max});

  /// true si [value] es un color hexadecimal válido (#RGB, #RRGGBB o #AARRGGBB).
  bool isValidHexColor(String value);
}
