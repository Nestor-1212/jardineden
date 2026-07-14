// ─────────────────────────────────────────────────────────────────────────────
// shared/validators/input_validators.dart
//
// RESPONSABILIDAD:
//   Validadores de entrada de usuario reutilizables en múltiples features.
//   Retornan String? (null = válido, string = mensaje de error).
//   Compatibles con TextFormField.validator de Flutter.
//
// CONVENCIÓN:
//   - Retornar null si el valor es válido.
//   - Retornar un string con el mensaje de error si no es válido.
//   - Los mensajes de error están en español (el idioma base del proyecto).
//   - No usar AppLocalizations aquí — los mensajes hardcodeados son suficientes
//     porque los validators se usan en contextos donde l10n ya está disponible
//     a nivel de widget; la localización del mensaje ocurre en el widget.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, librerías, features, core, shared (otros).
// ─────────────────────────────────────────────────────────────────────────────

abstract final class InputValidators {
  // ── Nombre de Perfil ──────────────────────────────────────────────────────

  /// Valida el nombre de un perfil de jugador.
  ///
  /// Reglas: 2-20 caracteres, no solo espacios, no caracteres especiales.
  static String? profileName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre no puede estar vacío';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    if (trimmed.length > 20) {
      return 'El nombre no puede tener más de 20 caracteres';
    }
    final validChars = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ '\-]+$");
    if (!validChars.hasMatch(trimmed)) {
      return 'El nombre solo puede contener letras, espacios y guiones';
    }
    return null;
  }

  // ── Edad del Jugador ──────────────────────────────────────────────────────

  /// Valida la edad de un jugador.
  ///
  /// Rango: 4-12 años (los únicos rangos de edad del juego).
  static String? playerAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'La edad es requerida';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'La edad debe ser un número';
    }
    if (age < 4 || age > 12) {
      return 'La edad debe estar entre 4 y 12 años';
    }
    return null;
  }

  // ── PIN Parental ──────────────────────────────────────────────────────────

  /// Valida un PIN parental de exactamente 4 dígitos.
  static String? parentPin(String? value) {
    if (value == null || value.isEmpty) {
      return 'El PIN es requerido';
    }
    if (value.length != 4) {
      return 'El PIN debe tener exactamente 4 dígitos';
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'El PIN solo puede contener dígitos';
    }
    // Prevenir PINs trivialmente inseguros
    if (value == '0000' || value == '1234' || value == '1111') {
      return 'El PIN es demasiado simple. Elige otro';
    }
    return null;
  }

  /// Valida que la confirmación del PIN coincida con el PIN original.
  static String? pinConfirmation(String? value, String originalPin) {
    final basicError = parentPin(value);
    if (basicError != null) return basicError;
    if (value != originalPin) {
      return 'Los PINs no coinciden';
    }
    return null;
  }

  // ── Respuesta de Minijuego ────────────────────────────────────────────────

  /// Valida que una respuesta de texto no esté vacía.
  ///
  /// Usado en minijuegos de completar versículos.
  static String? gameTextAnswer(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Escribe tu respuesta';
    }
    return null;
  }

  // ── Búsqueda ──────────────────────────────────────────────────────────────

  /// Valida un término de búsqueda.
  ///
  /// Mínimo 2 caracteres para iniciar una búsqueda.
  static String? searchQuery(String? value) {
    if (value == null || value.trim().length < 2) {
      return 'Escribe al menos 2 caracteres';
    }
    return null;
  }
}
