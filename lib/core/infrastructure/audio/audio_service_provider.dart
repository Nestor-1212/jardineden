// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/audio/audio_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer las instancias de AudioPlayer para música y efectos de sonido.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//   just_audio recomienda mantener una instancia de AudioPlayer por stream.
//   El juego usa dos streams simultáneos: BGM (música de fondo) + SFX (efectos).
//   Ambos players son singletons que persisten durante toda la sesión del juego.
//
// DOS PROVIDERS SEPARADOS:
//   bgmPlayerProvider → Música ambiental (looping, volumen independiente)
//   sfxPlayerProvider → Efectos de sonido (one-shot, puede solaparse)
//
//   Separar BGM y SFX permite:
//   ✓ Control de volumen independiente (mute music, keep sfx)
//   ✓ Crossfade entre mundos sin interrumpir los efectos
//   ✓ Ajuste de AudioSession por categoría (music vs. ambient)
//
// LIMPIEZA:
//   ref.onDispose(player.dispose) libera los recursos nativos cuando el
//   ProviderContainer se destruye (hot restart en dev, cierre de app en prod).
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, just_audio.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_service_provider.g.dart';

/// [AudioPlayer] dedicado a la música de fondo (BGM).
///
/// Configurado para looping continuo y control de volumen independiente.
/// Sprint Audio: aquí se configurará [AudioSession] con categoría playback.
@Riverpod(keepAlive: true)
AudioPlayer bgmPlayer(BgmPlayerRef ref) {
  final player = AudioPlayer();
  ref.onDispose(player.dispose);
  return player;
}

/// [AudioPlayer] dedicado a los efectos de sonido (SFX).
///
/// Configurado para reproducción one-shot con posible solapamiento.
/// Sprint Audio: usar [AudioPlayer] con [ConcatenatingAudioSource] para SFX pool.
@Riverpod(keepAlive: true)
AudioPlayer sfxPlayer(SfxPlayerRef ref) {
  final player = AudioPlayer();
  ref.onDispose(player.dispose);
  return player;
}
