// ─────────────────────────────────────────────────────────────────────────────
// shared/extensions/string_extensions.dart
//
// RESPONSABILIDAD:
//   Extensiones de tipo String reutilizables en todo el proyecto.
//   Métodos que se usan en múltiples features para transformar strings.
//
// CONVENCIÓN:
//   Ninguna extensión tiene efectos secundarios (sin mutación, sin I/O).
//   Todas son funciones puras que toman un String y retornan un valor.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, librerías, features, core, shared (otros).
// ─────────────────────────────────────────────────────────────────────────────

extension StringExtensions on String {
  /// Capitaliza la primera letra del string.
  ///
  /// Ejemplo: 'jardín del edén' → 'Jardín del edén'
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Convierte a Title Case (capitaliza cada palabra).
  ///
  /// Ejemplo: 'jardín del edén' → 'Jardín Del Edén'
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// true si el string es un UUID v4 o v7 válido.
  bool get isValidUuid {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(this);
  }

  /// true si el string contiene solo dígitos numéricos.
  bool get isNumericOnly => isNotEmpty && RegExp(r'^\d+$').hasMatch(this);

  /// true si el string es un PIN válido (4-6 dígitos).
  bool get isValidPin => isNumericOnly && length >= 4 && length <= 6;

  /// Trunca el string a [maxLength] caracteres añadiendo '...' si es necesario.
  ///
  /// Ejemplo: 'Jardín del Edén es un videojuego'.truncate(15) → 'Jardín del Edé...'
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }

  /// Elimina acentos y caracteres especiales para comparaciones.
  ///
  /// Ejemplo: 'Génesis' → 'Genesis'
  String get withoutDiacritics {
    const diacritics = 'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÝýÑñÇç';
    const replacement = 'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOOooooooUUUUuuuuYyNnCc';
    var result = this;
    for (var i = 0; i < diacritics.length; i++) {
      result = result.replaceAll(diacritics[i], replacement[i]);
    }
    return result;
  }

  /// Retorna el ID de mundo extraído de un ID estructurado.
  ///
  /// Ejemplo: 'CHAPTER-001-003' → 'WORLD-001'
  String? get extractWorldId {
    final match = RegExp(r'CHAPTER-(\d{3})').firstMatch(this);
    if (match == null) return null;
    return 'WORLD-${match.group(1)}';
  }
}

extension NullableStringExtensions on String? {
  /// true si el string es null o vacío.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Retorna el string o un valor por defecto si es null.
  String orDefault(String defaultValue) => this ?? defaultValue;
}
