// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/narration/narration_service_provider.dart
//
// RESPONSABILIDAD:
//   Proveer la instancia singleton de NarrationService.
//
// CICLO DE VIDA: Singleton (keepAlive: true)
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, narration_service_impl,
//                            audio_service_provider (narrationPlayer, bgmPlayer).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/infrastructure/audio/audio_service_provider.dart';
import 'package:jardindeleden/core/narration/narration_service.dart';
import 'package:jardindeleden/core/narration/narration_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'narration_service_provider.g.dart';

/// Instancia singleton de [NarrationService].
@Riverpod(keepAlive: true)
NarrationService narrationService(NarrationServiceRef ref) {
  return NarrationServiceImpl(
    narrationPlayer: ref.watch(narrationPlayerProvider),
    bgmPlayer: ref.watch(bgmPlayerProvider),
  );
}
