// ─────────────────────────────────────────────────────────────────────────────
// core/accessibility/accessibility_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de AccessibilityService sobre StorageService. Cada campo
//   de AccessibilitySettings se guarda bajo su propia clave (ver
//   core/infrastructure/storage/storage_keys.dart, sección Accesibilidad)
//   — mismo patrón que PreferencesServiceImpl, no un blob JSON, para poder
//   leer/escribir un solo campo sin deserializar todo el objeto.
//
// DEPENDENCIAS PERMITIDAS:   core/accessibility/ (contrato, AccessibilitySettings),
//                            core/storage/ (StorageService),
//                            core/infrastructure/storage/storage_keys.dart.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/accessibility/accessibility_service.dart';
import 'package:jardindeleden/core/accessibility/accessibility_settings.dart';
import 'package:jardindeleden/core/infrastructure/storage/storage_keys.dart';
import 'package:jardindeleden/core/storage/storage_service.dart';

/// Implementación de [AccessibilityService] sobre [StorageService].
final class AccessibilityServiceImpl implements AccessibilityService {
  AccessibilityServiceImpl({required StorageService storage})
    : _storage = storage;

  final StorageService _storage;

  @override
  Future<AccessibilitySettings> load() async {
    return AccessibilitySettings(
      textScaleMode: _readEnum(
        SharedPrefKeys.a11yTextScaleMode,
        TextScaleMode.values,
        TextScaleMode.normal,
      ),
      highContrastEnabled:
          _storage.getBool(SharedPrefKeys.a11yHighContrast) ?? false,
      colorBlindMode: _readEnum(
        SharedPrefKeys.a11yColorBlindMode,
        ColorBlindMode.values,
        ColorBlindMode.none,
      ),
      reduceMotionEnabled:
          _storage.getBool(SharedPrefKeys.a11yReduceMotion) ?? false,
      simplifiedNavigationEnabled:
          _storage.getBool(SharedPrefKeys.a11ySimplifiedNavigation) ?? false,
      largeButtonsEnabled:
          _storage.getBool(SharedPrefKeys.a11yLargeButtons) ?? false,
      narrationEnabled:
          _storage.getBool(SharedPrefKeys.a11yNarrationEnabled) ?? true,
    );
  }

  @override
  Future<void> save(AccessibilitySettings settings) async {
    await _storage.setString(
      SharedPrefKeys.a11yTextScaleMode,
      settings.textScaleMode.name,
    );
    await _storage.setBool(
      SharedPrefKeys.a11yHighContrast,
      settings.highContrastEnabled,
    );
    await _storage.setString(
      SharedPrefKeys.a11yColorBlindMode,
      settings.colorBlindMode.name,
    );
    await _storage.setBool(
      SharedPrefKeys.a11yReduceMotion,
      settings.reduceMotionEnabled,
    );
    await _storage.setBool(
      SharedPrefKeys.a11ySimplifiedNavigation,
      settings.simplifiedNavigationEnabled,
    );
    await _storage.setBool(
      SharedPrefKeys.a11yLargeButtons,
      settings.largeButtonsEnabled,
    );
    await _storage.setBool(
      SharedPrefKeys.a11yNarrationEnabled,
      settings.narrationEnabled,
    );
  }

  /// Lee un enum guardado por su `.name`, o [fallback] si no existe o el
  /// valor guardado ya no corresponde a ningún caso del enum (ej. tras
  /// eliminar un valor en una actualización futura — nunca lanza).
  T _readEnum<T extends Enum>(String key, List<T> values, T fallback) {
    final raw = _storage.getString(key);
    if (raw == null) return fallback;
    for (final value in values) {
      if (value.name == raw) return value;
    }
    return fallback;
  }
}
