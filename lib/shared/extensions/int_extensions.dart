// ─────────────────────────────────────────────────────────────────────────────
// shared/extensions/int_extensions.dart
//
// RESPONSABILIDAD:
//   Extensiones de tipo int para formato de números en el juego.
//   Principalmente para formatear monedas, contadores y estadísticas.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, librerías, features, core, shared (otros).
// ─────────────────────────────────────────────────────────────────────────────

extension IntExtensions on int {
  /// Formatea el número como cantidad de moneda del juego.
  ///
  /// Usa sufijos para grandes cantidades:
  /// 1234 → '1,234'
  /// 12345 → '12.3K'
  /// 1234567 → '1.2M'
  String get toCurrencyFormat {
    if (this >= 1000000) {
      final millions = this / 1000000;
      return '${millions.toStringAsFixed(1)}M';
    }
    if (this >= 10000) {
      final thousands = this / 1000;
      return '${thousands.toStringAsFixed(1)}K';
    }
    // Para números < 10,000, format con coma como separador de miles
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  /// Formatea una duración en segundos como string legible.
  ///
  /// 65 → '1:05'
  /// 3661 → '1:01:01'
  String get toTimeFormat {
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;
    final seconds = this % 60;
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Convierte el número a representación ordinal en español.
  ///
  /// 1 → '1°'
  /// 2 → '2°'
  String get toOrdinalEs => '$this°';

  /// Interpola este entero entre [min] y [max].
  ///
  /// Útil para validar rangos de monedas, edades, PIN.
  bool isBetween(int min, int max) => this >= min && this <= max;

  /// Clamp entre 0 e infinito (garantiza que el valor no sea negativo).
  /// Útil para saldos de monedas que nunca pueden ser negativos.
  int get clampToPositive => clamp(0, 999999999).toInt();
}
