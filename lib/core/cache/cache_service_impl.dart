// ─────────────────────────────────────────────────────────────────────────────
// core/cache/cache_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de CacheService sobre un Map en memoria.
//
// PURGA DE ENTRADAS EXPIRADAS:
//   Perezosa (lazy): una entrada expirada solo se elimina del Map cuando se
//   consulta (get/containsKey). No hay un Timer periódico — evita mantener
//   un temporizador vivo durante toda la sesión por un cache que puede no
//   usarse. [length] puede sobreestimar mientras existan expiradas sin
//   consultar todavía; es una cota superior, no un conteo exacto.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, core/cache/cache_service.dart (contrato)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/cache/cache_service.dart';

final class _CacheEntry {
  _CacheEntry(this.value, this.expiresAt);

  final Object value;
  final DateTime? expiresAt;

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

/// Implementación de [CacheService] sobre un [Map] en memoria.
final class CacheServiceImpl implements CacheService {
  final Map<String, _CacheEntry> _entries = {};

  @override
  T? get<T extends Object>(String key) {
    final entry = _entries[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _entries.remove(key);
      return null;
    }

    return entry.value as T;
  }

  @override
  void put<T extends Object>(String key, T value, {Duration? ttl}) {
    final expiresAt = ttl != null ? DateTime.now().add(ttl) : null;
    _entries[key] = _CacheEntry(value, expiresAt);
  }

  @override
  bool containsKey(String key) => get<Object>(key) != null;

  @override
  void invalidate(String key) => _entries.remove(key);

  @override
  void clear() => _entries.clear();

  @override
  int get length => _entries.length;
}
