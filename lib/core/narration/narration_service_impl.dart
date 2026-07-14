// ─────────────────────────────────────────────────────────────────────────────
// core/narration/narration_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de NarrationService sobre un AudioPlayer dedicado
//   (narrationPlayer, ver provider) + ducking manual del bgmPlayer
//   compartido con AudioService (core/audio/).
//
// DUCKING:
//   Al iniciar narración, el volumen de BGM se multiplica por [duckFactor]
//   (30% por defecto — sigue audible de fondo, pero claramente secundario).
//   Se restaura al volumen previo cuando la narración termina, se detiene,
//   o se llama [stop] explícitamente. Se guarda el volumen ANTES de aplicar
//   el duck (no un valor fijo) para no pisar la preferencia de volumen del
//   jugador.
//
// DEPENDENCIAS PERMITIDAS:   just_audio, core/narration/ (contrato)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/narration/narration_service.dart';
import 'package:just_audio/just_audio.dart';

/// Implementación de [NarrationService] sobre just_audio.
final class NarrationServiceImpl implements NarrationService {
  NarrationServiceImpl({
    required AudioPlayer narrationPlayer,
    required AudioPlayer bgmPlayer,
    this.duckFactor = 0.3,
  })  : _narrationPlayer = narrationPlayer,
        _bgmPlayer = bgmPlayer {
    _narrationPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _restoreBgmVolume();
      }
    });
  }

  final AudioPlayer _narrationPlayer;
  final AudioPlayer _bgmPlayer;

  /// Fracción del volumen de BGM que queda audible durante la narración.
  final double duckFactor;

  double? _bgmVolumeBeforeDucking;

  @override
  Future<void> playNarration(String assetPath) async {
    _duckBgm();
    await _narrationPlayer.setAsset(assetPath);
    await _narrationPlayer.play();
  }

  @override
  Future<void> pause() => _narrationPlayer.pause();

  @override
  Future<void> resume() => _narrationPlayer.play();

  @override
  Future<void> stop() async {
    await _narrationPlayer.stop();
    await _restoreBgmVolume();
  }

  @override
  bool get isNarrating => _narrationPlayer.playing;

  void _duckBgm() {
    _bgmVolumeBeforeDucking ??= _bgmPlayer.volume;
    _bgmPlayer.setVolume(_bgmVolumeBeforeDucking! * duckFactor);
  }

  Future<void> _restoreBgmVolume() async {
    final previousVolume = _bgmVolumeBeforeDucking;
    if (previousVolume == null) return;
    _bgmVolumeBeforeDucking = null;
    await _bgmPlayer.setVolume(previousVolume);
  }
}
