// ─────────────────────────────────────────────────────────────────────────────
// core/storage/preferences_service.dart
//
// RESPONSABILIDAD:
//   Wrapper type-safe sobre SharedPreferences.
//   Ninguna feature importa SharedPreferences directamente.
//   Todas las features usan PreferencesService.
//
// DATOS QUE VIVEN AQUÍ (configuraciones clave-valor sin relaciones):
//   • ID del perfil activo (String UUID)
//   • Idioma seleccionado (String: 'es', 'en', 'pt')
//   • Volumen de música (double: 0.0 a 1.0)
//   • Volumen de efectos de sonido (double: 0.0 a 1.0)
//   • Modo oscuro preferido (bool)
//   • Tamaño de fuente de accesibilidad (enum: normal, grande, extraGrande)
//   • Modo alto contraste (bool)
//   • Tutorial completado (bool)
//   • Primer lanzamiento (bool)
//
// DATOS QUE NO VIVEN AQUÍ:
//   • El PIN del Panel de Padres → Vive en la DB con hash bcrypt.
//   • Progreso del juego → Vive en AppDatabase (Drift).
//   • Monedas y economía → Viven en AppDatabase (Drift).
//
// CLAVES DE PREFERENCIAS:
//   Todas las claves tienen el prefijo 'jde_' para evitar colisiones.
//   Se definen como constantes en esta misma clase.
//
// DEPENDENCIAS PERMITIDAS:   shared_preferences, dart:core
// DEPENDENCIAS PROHIBIDAS:   features, core/database, flutter/widgets
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core (Almacenamiento)
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del servicio de preferencias de usuario.
///
/// Se registra como singleton en el sistema de DI.
abstract interface class PreferencesService {
  // ── Claves de Preferencias ────────────────────────────────────────────────

  // Públicas (no privadas al archivo) a propósito: PreferencesServiceImpl
  // vive en un archivo separado (preferences_service_impl.dart, siguiendo
  // la convención contrato/implementación del resto del Core) y necesita
  // referenciarlas sin duplicar los literales — una sola fuente de verdad.
  static const String keyActiveProfileId = 'jde_active_profile_id';
  static const String keyLanguage = 'jde_language';
  static const String keyMusicVolume = 'jde_music_volume';
  static const String keySfxVolume = 'jde_sfx_volume';
  static const String keyDarkMode = 'jde_dark_mode';
  static const String keyAccessibilityFontSize = 'jde_accessibility_font';
  static const String keyHighContrast = 'jde_high_contrast';
  static const String keyTutorialCompleted = 'jde_tutorial_completed';
  static const String keyFirstLaunch = 'jde_first_launch';

  static final List<String> allKeys = [
    keyActiveProfileId,
    keyLanguage,
    keyMusicVolume,
    keySfxVolume,
    keyDarkMode,
    keyAccessibilityFontSize,
    keyHighContrast,
    keyTutorialCompleted,
    keyFirstLaunch,
  ];

  // ── Perfil Activo ─────────────────────────────────────────────────────────

  Future<String?> getActiveProfileId();
  Future<void> setActiveProfileId(String profileId);
  Future<void> clearActiveProfileId();

  // ── Idioma ────────────────────────────────────────────────────────────────

  /// Retorna el código de idioma activo. Null si nunca fue configurado.
  Future<String?> getLanguage();
  Future<void> setLanguage(String languageCode);

  // ── Audio ─────────────────────────────────────────────────────────────────

  Future<double> getMusicVolume();
  Future<void> setMusicVolume(double volume);
  Future<double> getSfxVolume();
  Future<void> setSfxVolume(double volume);

  // ── Apariencia ────────────────────────────────────────────────────────────

  Future<bool?> getDarkModePreference();
  Future<void> setDarkModePreference(bool isDark);
  Future<String> getAccessibilityFontSize();
  Future<void> setAccessibilityFontSize(String size);
  Future<bool> getHighContrastEnabled();
  Future<void> setHighContrastEnabled(bool enabled);

  // ── Estado de la App ──────────────────────────────────────────────────────

  Future<bool> isTutorialCompleted();
  Future<void> markTutorialCompleted();
  Future<bool> isFirstLaunch();
  Future<void> markFirstLaunchCompleted();

  // ── Limpieza (COPPA/GDPR-K) ───────────────────────────────────────────────

  /// Elimina TODAS las preferencias del jugador activo.
  /// Se llama cuando se elimina un perfil.
  Future<void> clearAllPlayerData();
}
