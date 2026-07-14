// ─────────────────────────────────────────────────────────────────────────────
// core/game_engine/registry/game_registry.dart
//
// RESPONSABILIDAD:
//   Contrato genérico de registro — lleva la cuenta de instancias de un
//   mismo tipo dentro de una sesión (el caso principal: las GameEntity
//   activas, ver entities/game_entity.dart) sin que el motor necesite
//   conocer ninguna implementación concreta de [T].
//
// POR QUÉ EL ID ES UN PARÁMETRO EXPLÍCITO Y NO UNA PROPIEDAD DE [T]:
//   Una alternativa más corta sería `GameRegistry<T extends GameEntity>` y
//   leer `item.id` internamente. Se descarta a propósito: acoplaría este
//   contrato genérico a GameEntity específicamente, cuando "llevar la
//   cuenta de instancias por id" es útil para cualquier tipo que el motor
//   necesite rastrear en el futuro, no solo entidades. Pasar el id
//   explícito en [register] mantiene GameRegistry<T> genérico de verdad —
//   sin ninguna restricción sobre [T].
//
// POR QUÉ NO IMPLEMENTA GameLifecycle (lifecycle/game_lifecycle.dart):
//   Un registro no tiene un estado de "inicializado" propio distinto de
//   "recién creado, vacío" — y [clear] ya cubre la necesidad de resetear
//   su contenido. Forzarlo a implementar GameInitializable/GameDisposable
//   sin una necesidad real violaría ISP en la dirección opuesta (una
//   interfaz que no le queda).
//
// DEPENDENCIAS PERMITIDAS:   dart:core.
// DEPENDENCIAS PROHIBIDAS:   ver game_engine_charter.dart, sección 12,
//                            aplicable a todo el motor sin excepción. En
//                            particular, este archivo no importa
//                            entities/game_entity.dart — el registro es
//                            anterior y ajeno a cualquier tipo concreto
//                            que termine usándolo.
// ─────────────────────────────────────────────────────────────────────────────

/// Registro genérico de instancias de [T], identificadas por una clave
/// [String] explícita.
///
/// El motor lo usa para rastrear las entidades activas de una sesión
/// (`GameRegistry<GameEntity>`, compuesto en game_engine_contract.dart) sin
/// que este contrato conozca GameEntity en absoluto.
abstract interface class GameRegistry<T> {
  /// Registra [item] bajo la clave [id]. Si ya existía un item con ese
  /// [id], lo reemplaza.
  void register(String id, T item);

  /// Elimina el item asociado a [id]. No-op si no existe.
  void unregister(String id);

  /// Busca el item asociado a [id]. `null` si no está registrado.
  T? find(String id);

  /// `true` si existe un item registrado bajo [id].
  bool contains(String id);

  /// Todos los items registrados actualmente.
  Iterable<T> get all;

  /// Elimina todos los items registrados.
  void clear();
}
