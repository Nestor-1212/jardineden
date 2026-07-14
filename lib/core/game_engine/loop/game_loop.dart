// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/loop/game_loop.dart
//
// RESPONSABILIDAD:
//   Contrato de la fuente de ritmo de una sesión de juego — produce ticks
//   (deltas de tiempo entre frames) de forma desacoplada del ciclo de
//   reconstrucción de widgets de Flutter. Ver game_engine_charter.dart,
//   Objetivo 1.
//
// POR QUÉ NO TIENE start()/pause()/resume() DE SESIÓN:
//   GameLoop es deliberadamente más pequeño que el ciclo de vida completo
//   de una sesión (ISP — game_engine_charter.dart, sección 8). Solo sabe
//   producir o no producir ticks (start/stop). La semántica de "pausa" de
//   más alto nivel la construye GameSession componiendo esto con
//   GameClock — GameLoop no necesita saberlo.
//
// DEPENDENCIAS PERMITIDAS:   dart:async (Stream). La implementación futura
//                            (game_loop_impl.dart, sprint posterior) será
//                            la ÚNICA clase de todo el motor que importe
//                            package:flutter/scheduler.dart — ver
//                            game_engine_charter.dart, sección 11.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';

/// Fuente de ritmo de una sesión de juego.
///
/// No sabe qué es una sesión, un resultado ni una entidad — solo produce
/// ticks mientras está corriendo. Ver GameClock para la noción de tiempo
/// transcurrido, que es un contrato aparte y deliberadamente independiente.
abstract interface class GameLoop {
  /// `true` mientras el loop está produciendo ticks activamente.
  bool get isRunning;

  /// Empieza a producir ticks. No-op si [isRunning] ya es `true`.
  void start();

  /// Detiene la producción de ticks. No-op si [isRunning] ya es `false`.
  ///
  /// Detener el loop no reinicia ningún estado de tiempo — eso es
  /// responsabilidad de GameClock, no de este contrato.
  void stop();

  /// Emite el tiempo transcurrido desde el tick anterior. Emite un evento
  /// por cada frame disponible mientras [isRunning] es `true`; no emite
  /// nada mientras está detenido.
  Stream<Duration> get onTick;

  /// Libera los recursos del loop (p. ej. el Ticker subyacente de la
  /// implementación futura). El loop no puede volver a usarse después de
  /// llamar a esto.
  void dispose();
}
