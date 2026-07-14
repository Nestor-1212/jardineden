// ─────────────────────────────────────────────────────────────────────────────
// core/audio/audio_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de AudioService sobre dos AudioPlayer de just_audio
//   (bgmPlayer, sfxPlayer), inyectados desde
//   core/infrastructure/audio/audio_service_provider.dart.
//
// LIMITACIÓN CONOCIDA (documentada, no resuelta en este Sprint):
//   just_audio reproduce UNA fuente a la vez por AudioPlayer. playSfx()
//   interrumpe el efecto anterior si se llama de nuevo antes de que termine.
//   Un pool de AudioPlayer para SFX realmente solapados es una mejora futura
//   (Sprint Audio), no infraestructura base — se documenta aquí para que
//   quien lo necesite sepa dónde extenderlo.
//
// DEPENDENCIAS PERMITIDAS:   just_audio, core/audio/audio_service.dart (contrato)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/audio/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Implementación de [AudioService] sobre just_audio.
final class AudioServiceImpl implements AudioService {
  AudioServiceImpl({
    required AudioPlayer bgmPlayer,
    required AudioPlayer sfxPlayer,
  }) : _bgmPlayer = bgmPlayer,
       _sfxPlayer = sfxPlayer;

  final AudioPlayer _bgmPlayer;
  final AudioPlayer _sfxPlayer;

  @override
  Future<void> playBgm(String assetPath, {bool loop = true}) async {
    await _bgmPlayer.setAsset(assetPath);
    await _bgmPlayer.setLoopMode(loop ? LoopMode.one : LoopMode.off);
    await _bgmPlayer.play();
  }

  @override
  Future<void> pauseBgm() => _bgmPlayer.pause();

  @override
  Future<void> resumeBgm() => _bgmPlayer.play();

  @override
  Future<void> stopBgm() => _bgmPlayer.stop();

  @override
  Future<void> setBgmVolume(double volume) => _bgmPlayer.setVolume(volume);

  @override
  Future<void> crossFadeTo(
    String assetPath, {
    Duration duration = const Duration(seconds: 1),
  }) async {
    const steps = 10;
    final stepDuration = duration ~/ (steps * 2);
    final startVolume = _bgmPlayer.volume;

    // Fade-out de la pista actual.
    for (var i = steps; i >= 0; i--) {
      await _bgmPlayer.setVolume(startVolume * (i / steps));
      await Future<void>.delayed(stepDuration);
    }

    await playBgm(assetPath);

    // Fade-in de la pista nueva.
    for (var i = 0; i <= steps; i++) {
      await _bgmPlayer.setVolume(startVolume * (i / steps));
      await Future<void>.delayed(stepDuration);
    }
  }

  @override
  Future<void> playSfx(String assetPath) async {
    await _sfxPlayer.setAsset(assetPath);
    await _sfxPlayer.play();
  }

  @override
  Future<void> setSfxVolume(double volume) => _sfxPlayer.setVolume(volume);

  @override
  Future<void> stopAllSfx() => _sfxPlayer.stop();

  @override
  bool get isBgmPlaying => _bgmPlayer.playing;
}
