// ─────────────────────────────────────────────────────────────────────────────
// core/narration/narration_service.dart
//
// RESPONSABILIDAD:
//   Reproduce audio de narración PRE-GRABADO (voz profesional, por idioma
//   — ver assets/worlds/world_XXX/audio/{es,en,pt}/ ya reservado en
//   pubspec.yaml) para contenido que un niño de 4 años, que aún no lee,
//   necesita escuchar en vez de leer.
//
// DECISIÓN: AUDIO PRE-GRABADO, NO TEXT-TO-SPEECH EN VIVO
//   Se evaluó agregar un motor TTS (ej. flutter_tts) para narrar cualquier
//   texto dinámicamente. Se descartó para este Sprint:
//     ✓ El proyecto YA tiene una tubería de contenido de audio por idioma
//       (carpetas assets/worlds/*/audio/{es,en,pt}/ documentadas en
//       pubspec.yaml desde el Sprint 02) — narración con voz profesional
//       grabada encaja directamente en esa tubería existente.
//     ✗ TTS robótico es una experiencia inferior para un juego bíblico
//       infantil narrativo — el tono emocional de la voz importa para
//       contar la historia, algo que TTS no logra bien todavía.
//     ✗ Agregar flutter_tts sería una dependencia nueva sin un caso de uso
//       que el audio pre-grabado no cubra ya mejor.
//   Si un Sprint futuro necesita leer texto verdaderamente dinámico en voz
//   alta (ej. el nombre que el niño escribió), ESE es el momento de
//   evaluar TTS — este archivo no lo bloquea, es una capa aparte.
//
// POR QUÉ ES UN CANAL DE AUDIO SEPARADO DE BGM/SFX (ver core/audio/):
//   La narración necesita "ducking" — bajar el volumen de la música de
//   fondo mientras narra y restaurarlo al terminar — y reproducción
//   secuencial (una narración a la vez, nunca superpuesta con otra
//   narración). Ni el canal BGM (una pista continua) ni el canal SFX
//   (efectos cortos superponibles) modelan ese comportamiento.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:async.
// DEPENDENCIAS PROHIBIDAS:   features, shared/ui, Flutter widgets.
// ─────────────────────────────────────────────────────────────────────────────

/// Contrato del servicio de narración de audio pre-grabado.
abstract interface class NarrationService {
  /// Reproduce el clip de narración en [assetPath], bajando (duck) el
  /// volumen de la música de fondo mientras dura.
  ///
  /// Si ya hay una narración en curso, la reemplaza (no se superponen).
  Future<void> playNarration(String assetPath);

  Future<void> pause();
  Future<void> resume();

  /// Detiene la narración y restaura el volumen de la música de fondo
  /// inmediatamente (sin esperar a que el clip termine solo).
  Future<void> stop();

  /// `true` si hay una narración reproduciéndose actualmente.
  bool get isNarrating;
}
