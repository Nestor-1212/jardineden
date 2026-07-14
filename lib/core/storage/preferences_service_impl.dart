// ─────────────────────────────────────────────────────────────────────────────
// core/storage/preferences_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de PreferencesService como fachada tipada sobre
//   StorageService. Traduce cada getter/setter de dominio a una operación
//   genérica de StorageService bajo la clave correspondiente.
//
// POR QUÉ DELEGA EN StorageService Y NO EN SharedPreferences DIRECTAMENTE:
//   Mantiene esta clase libre de detalles de backend (ver storage_service.dart).
//   Si StorageServiceImpl cambia de SharedPreferences a otro motor, esta
//   clase no se entera.
//
// DEPENDENCIAS PERMITIDAS:   core/storage/preferences_service.dart (contrato),
//                            core/storage/storage_service.dart (motor)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/storage/preferences_service.dart';
import 'package:jardindeleden/core/storage/storage_service.dart';

/// Implementación de [PreferencesService] sobre [StorageService].
final class PreferencesServiceImpl implements PreferencesService {
  PreferencesServiceImpl({required StorageService storage}) : _storage = storage;

  final StorageService _storage;

  // ── Perfil Activo ─────────────────────────────────────────────────────────

  @override
  Future<String?> getActiveProfileId() async =>
      _storage.getString(PreferencesService.keyActiveProfileId);

  @override
  Future<void> setActiveProfileId(String profileId) =>
      _storage.setString(PreferencesService.keyActiveProfileId, profileId);

  @override
  Future<void> clearActiveProfileId() =>
      _storage.remove(PreferencesService.keyActiveProfileId);

  // ── Idioma ────────────────────────────────────────────────────────────────

  @override
  Future<String?> getLanguage() async =>
      _storage.getString(PreferencesService.keyLanguage);

  @override
  Future<void> setLanguage(String languageCode) =>
      _storage.setString(PreferencesService.keyLanguage, languageCode);

  // ── Audio ─────────────────────────────────────────────────────────────────

  @override
  Future<double> getMusicVolume() async =>
      _storage.getDouble(PreferencesService.keyMusicVolume) ?? 1.0;

  @override
  Future<void> setMusicVolume(double volume) =>
      _storage.setDouble(PreferencesService.keyMusicVolume, volume);

  @override
  Future<double> getSfxVolume() async =>
      _storage.getDouble(PreferencesService.keySfxVolume) ?? 1.0;

  @override
  Future<void> setSfxVolume(double volume) =>
      _storage.setDouble(PreferencesService.keySfxVolume, volume);

  // ── Apariencia ────────────────────────────────────────────────────────────

  @override
  Future<bool?> getDarkModePreference() async =>
      _storage.getBool(PreferencesService.keyDarkMode);

  @override
  Future<void> setDarkModePreference(bool isDark) =>
      _storage.setBool(PreferencesService.keyDarkMode, isDark);

  @override
  Future<String> getAccessibilityFontSize() async =>
      _storage.getString(PreferencesService.keyAccessibilityFontSize) ?? 'normal';

  @override
  Future<void> setAccessibilityFontSize(String size) =>
      _storage.setString(PreferencesService.keyAccessibilityFontSize, size);

  @override
  Future<bool> getHighContrastEnabled() async =>
      _storage.getBool(PreferencesService.keyHighContrast) ?? false;

  @override
  Future<void> setHighContrastEnabled(bool enabled) =>
      _storage.setBool(PreferencesService.keyHighContrast, enabled);

  // ── Estado de la App ──────────────────────────────────────────────────────

  @override
  Future<bool> isTutorialCompleted() async =>
      _storage.getBool(PreferencesService.keyTutorialCompleted) ?? false;

  @override
  Future<void> markTutorialCompleted() =>
      _storage.setBool(PreferencesService.keyTutorialCompleted, true);

  @override
  Future<bool> isFirstLaunch() async =>
      _storage.getBool(PreferencesService.keyFirstLaunch) ?? true;

  @override
  Future<void> markFirstLaunchCompleted() =>
      _storage.setBool(PreferencesService.keyFirstLaunch, false);

  // ── Limpieza (COPPA/GDPR-K) ───────────────────────────────────────────────

  @override
  Future<void> clearAllPlayerData() async {
    for (final key in PreferencesService.allKeys) {
      await _storage.remove(key);
    }
  }
}
