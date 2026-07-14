// ─────────────────────────────────────────────────────────────────────────────
// core/accessibility/accessibility_service.dart
//
// RESPONSABILIDAD:
//   Persiste y lee AccessibilitySettings. Capa de almacenamiento pura — sin
//   estado reactivo (eso es AccessibilityController, que envuelve a este
//   servicio con un Riverpod Notifier para que la UI se reconstruya cuando
//   algo cambia).
//
// DEPENDENCIAS PERMITIDAS:   dart:core, core/accessibility/accessibility_settings.dart.
// DEPENDENCIAS PROHIBIDAS:   Flutter, Riverpod, features.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/accessibility/accessibility_settings.dart';

/// Contrato de persistencia de AccessibilitySettings.
abstract interface class AccessibilityService {
  /// Carga las preferencias guardadas, o [AccessibilitySettings] por
  /// defecto si nunca se configuraron.
  Future<AccessibilitySettings> load();

  /// Persiste [settings] completo.
  Future<void> save(AccessibilitySettings settings);
}
