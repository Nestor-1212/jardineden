// ─────────────────────────────────────────────────────────────────────────────
// core/audio/audio_service.dart
//
// RESPONSABILIDAD:
//   Fachada técnica de reproducción de audio. Envuelve los dos AudioPlayer
//   (BGM y SFX, ver core/infrastructure/audio/audio_service_provider.dart)
//   en operaciones de alto nivel: reproducir, pausar, detener, volumen, loop.
//
// QUÉ NO VIVE AQUÍ:
//   Qué pista suena en qué pantalla, cross-fade entre mundos, mezclas de
//   ambiente por capítulo — eso es contenido/lógica de negocio de cada
//   feature. Este servicio solo sabe "reproducir esta ruta de asset".
//
// DOS CANALES INDEPENDIENTES:
//   BGM: una sola pista a la vez, con loop y fade.
//   SFX: reproducción one-shot, puede solaparse (varios sonidos a la vez).
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:async.
// DEPENDENCIAS PROHIBIDAS:   features, shared/ui, Flutter widgets.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del servicio de reproducción de audio.
abstract interface class AudioService {
  // ── Música de Fondo (BGM) ────────────────────────────────────────────────

  /// Reproduce [assetPath] como música de fondo. Detiene la pista anterior.
  Future<void> playBgm(String assetPath, {bool loop = true});

  Future<void> pauseBgm();
  Future<void> resumeBgm();
  Future<void> stopBgm();

  /// [volume] entre 0.0 (silencio) y 1.0 (máximo).
  Future<void> setBgmVolume(double volume);

  /// Transición suave entre la pista actual y [assetPath].
  ///
  /// [duration] es el tiempo total del fundido cruzado.
  Future<void> crossFadeTo(String assetPath, {Duration duration});

  // ── Efectos de Sonido (SFX) ──────────────────────────────────────────────

  /// Reproduce [assetPath] como efecto one-shot. Puede solaparse con otros.
  Future<void> playSfx(String assetPath);

  Future<void> setSfxVolume(double volume);

  /// Detiene todos los efectos de sonido en reproducción.
  Future<void> stopAllSfx();

  // ── Estado ────────────────────────────────────────────────────────────────

  /// true si hay música de fondo reproduciéndose actualmente.
  bool get isBgmPlaying;
}
