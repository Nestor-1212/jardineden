// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/storage/storage_keys.dart
//
// RESPONSABILIDAD:
//   Registro central de TODAS las claves de almacenamiento de la app.
//   Previene colisiones de key y facilita auditar qué se guarda y dónde.
//
// REGLAS DE NOMENCLATURA:
//   Prefijo 'jde_' en todas las claves para evitar conflictos con librerías.
//   SharedPreferences → preferencias no-sensibles (idioma, volumen, flags).
//   SecureStorage     → datos sensibles (claves AES, hashes de PIN).
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// ─────────────────────────────────────────────────────────────────────────────

/// Claves para SharedPreferences (datos no sensibles).
abstract final class SharedPrefKeys {
  // ── Perfil activo ─────────────────────────────────────────────────────────
  /// UUID del perfil de jugador seleccionado en la última sesión.
  static const activeProfileId = 'jde_active_profile_id';

  /// Flag que indica si el onboarding fue completado para el perfil activo.
  static const onboardingCompleted = 'jde_onboarding_done';

  // ── Preferencias de Audio ─────────────────────────────────────────────────
  /// Volumen maestro: 0.0 a 1.0.
  static const masterVolume = 'jde_volume_master';

  /// Volumen de música de fondo: 0.0 a 1.0.
  static const bgmVolume = 'jde_volume_bgm';

  /// Volumen de efectos de sonido: 0.0 a 1.0.
  static const sfxVolume = 'jde_volume_sfx';

  // ── Preferencias de UI ────────────────────────────────────────────────────
  /// Código ISO 639-1 del idioma seleccionado: 'es', 'en', 'pt'.
  static const selectedLanguage = 'jde_language';

  /// Modo de tema: 'system', 'light', 'dark'.
  static const themeMode = 'jde_theme_mode';

  // ── Sistema 44 ────────────────────────────────────────────────────────────
  /// Timestamp (ISO 8601) de la última sesión de repaso completada.
  static const lastReviewSession = 'jde_s44_last_review';
}

/// Claves para FlutterSecureStorage (datos sensibles — Keychain/Keystore).
abstract final class SecureStorageKeys {
  /// Clave AES-256 (hex) para cifrar la base de datos SQLCipher.
  static const dbEncryptionKey = 'jde_db_key';

  /// Hash bcrypt del PIN parental (cost=12). Nunca guardar el PIN en texto plano.
  static const parentPinHash = 'jde_parent_pin_hash';
}
