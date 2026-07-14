// ─────────────────────────────────────────────────────────────────────────────
// core/logging/log_sanitizer.dart
//
// RESPONSABILIDAD:
//   Última línea de defensa contra datos personales del niño colándose en
//   cualquier log. AppLoggerImpl pasa TODA metadata por aquí antes de
//   construir un LogEntry — ningún LogSink ve metadata sin sanitizar.
//
// ESTRATEGIA: "falla ruidoso en dev, falla seguro en prod".
//   • En DEBUG:   una clave sospechosa dispara un `assert` que DETIENE la
//                 app inmediatamente, señalando el archivo/línea exacta
//                 donde se intentó loguear algo sensible. El desarrollador
//                 lo ve la primera vez que ejecuta ese código camino,
//                 nunca llega a un build de release.
//   • En RELEASE: los `assert` de Dart se eliminan en tiempo de compilación
//                 (garantía del lenguaje, no una opción configurable) — el
//                 valor simplemente se reemplaza por '[REDACTED]' sin
//                 crashear la app de un niño en producción por un bug de
//                 logging.
//
//   Por eso la redacción NUNCA depende del assert para funcionar — el
//   assert es una alarma adicional para desarrollo, la redacción ocurre
//   siempre, en ambos ambientes.
//
// QUÉ SE CONSIDERA SENSIBLE (ver _sensitiveKeyFragments):
//   Nombre, email, teléfono, dirección, fecha de nacimiento/edad exacta,
//   foto/avatar, ubicación, ID de dispositivo/IP, PIN/contraseña/tokens/
//   secretos, y cualquier "respuesta de texto libre" del niño (las
//   respuestas de minijuegos de completar versículos pueden contener lo que
//   el niño haya escrito — nunca se loguea el contenido, solo si fue
//   correcta/incorrecta).
//
// QUÉ NO ESTÁ EN LA LISTA A PROPÓSITO:
//   'id' genérico, 'profile_id' (ya es un UUID anónimo, no un nombre),
//   'world_id', 'chapter_id', 'duration_ms' — identificadores técnicos y
//   agregados estadísticos no identifican a un niño específico fuera del
//   dispositivo.
//
// LO QUE ESTE ARCHIVO NO PUEDE HACER:
//   Detectar PII dentro del VALOR de un campo con nombre inocente (ej.
//   metadata: {'note': 'Juan cumple 6 años'}). La responsabilidad de no
//   poner texto libre en los valores de metadata sigue siendo de quien
//   llama al logger — este sanitizer cubre nombres de clave conocidos, no
//   analiza contenido libre.
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// ─────────────────────────────────────────────────────────────────────────────

/// Redacta valores de metadata cuyas CLAVES sugieren datos personales.
abstract final class LogSanitizer {
  static const String redactedValue = '[REDACTED]';

  /// Fragmentos (normalizados: minúsculas, sin '_' ni '-') que marcan una
  /// clave como sensible si el nombre normalizado la CONTIENE.
  static const List<String> _sensitiveKeyFragments = [
    'name',
    'email',
    'phone',
    'address',
    'birthdate',
    'dob',
    'age',
    'photo',
    'avatarimage',
    'location',
    'latitude',
    'longitude',
    'deviceid',
    'ipaddress',
    'pin',
    'password',
    'secret',
    'token',
    'apikey',
    'answer',
    'freetext',
  ];

  /// Retorna una copia de [metadata] con los valores de claves sensibles
  /// reemplazados por [redactedValue]. Las claves no sensibles se preservan
  /// tal cual.
  static Map<String, Object?> sanitize(Map<String, Object?> metadata) {
    final sanitized = <String, Object?>{};

    for (final entry in metadata.entries) {
      final isSensitive = _isSensitiveKey(entry.key);

      assert(
        !isSensitive,
        "LogSanitizer: la clave de metadata '${entry.key}' parece contener "
        'datos personales del niño y fue redactada. Si es un falso positivo '
        '(ej. "worldName" para el nombre de un MUNDO, no de una persona), '
        'renombra la clave para que no contenga el fragmento sensible — '
        'nunca elimines ni ignores este assert.',
      );

      sanitized[entry.key] = isSensitive ? redactedValue : entry.value;
    }

    return sanitized;
  }

  static bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase().replaceAll(RegExp('[_-]'), '');
    return _sensitiveKeyFragments.any(normalized.contains);
  }
}
