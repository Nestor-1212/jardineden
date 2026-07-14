// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/session/game_session.dart
//
// RESPONSABILIDAD:
//   Contrato del ciclo de vida de una sesión de juego — la única
//   superficie que Genesis Engine expone hacia features externos a un
//   minijuego. Ver game_engine_charter.dart, Objetivo 3 y Responsabilidades.
//
// POR QUÉ LAS TRANSICIONES SON MÉTODOS Y NO UN SETTER DE status:
//   Exponer `set status(GameSessionStatus)` permitiría a cualquier
//   consumidor saltar a cualquier estado sin pasar por una transición
//   válida (p. ej. de ready a completed directamente). Los métodos
//   start/pause/resume/complete/abandon documentan, cada uno, desde qué
//   estado es válido invocarlos — la máquina de estados es explícita en la
//   forma del contrato, no una convención que alguien pueda romper en
//   silencio.
//
// DEPENDENCIAS PERMITIDAS:   dart:async (Stream), game_result.dart de este
//                            mismo módulo.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:jardindeleden/core/game_engine/session/game_result.dart';

/// Estado de ciclo de vida de una sesión de juego.
enum GameSessionStatus {
  /// Creada pero todavía no iniciada.
  ready,

  /// En curso.
  running,

  /// Iniciada pero temporalmente detenida.
  paused,

  /// Terminada con un [GameResult] disponible.
  completed,

  /// Terminada sin resultado — el jugador salió antes de completarla.
  abandoned;

  /// `true` para [completed] y [abandoned] — no existe transición posible
  /// fuera de estos dos estados.
  bool get isFinished => this == completed || this == abandoned;
}

/// Ciclo de vida de una sesión de juego.
///
/// No sabe qué minijuego se está jugando ni cómo calcula su [GameResult] —
/// solo orquesta el estado (ver [GameSessionStatus]) y expone el resultado
/// una vez disponible.
abstract interface class GameSession {
  /// Estado actual de la sesión.
  GameSessionStatus get status;

  /// El resultado de la sesión una vez [status] es
  /// [GameSessionStatus.completed]. `null` en cualquier otro estado.
  GameResult? get result;

  /// Emite [status] cada vez que cambia.
  Stream<GameSessionStatus> get onStatusChanged;

  /// Transición [GameSessionStatus.ready] → [GameSessionStatus.running].
  /// Solo válida desde `ready`.
  void start();

  /// Transición [GameSessionStatus.running] → [GameSessionStatus.paused].
  /// Solo válida desde `running`.
  void pause();

  /// Transición [GameSessionStatus.paused] → [GameSessionStatus.running].
  /// Solo válida desde `paused`.
  void resume();

  /// Transición a [GameSessionStatus.completed], con [result] disponible
  /// desde ese momento. Solo válida desde `running` o `paused`.
  void complete(GameResult result);

  /// Transición a [GameSessionStatus.abandoned]. Válida desde cualquier
  /// estado que no sea ya [GameSessionStatus.isFinished].
  void abandon();
}
