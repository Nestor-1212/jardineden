// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/animations/app_hero.dart
//
// RESPONSABILIDAD:
//   Wrapper de [Hero] con transición de vuelo (flightShuttleBuilder)
//   consistente en todo el proyecto, y una convención de tags que evita
//   colisiones — dos problemas reales de usar Hero "a mano" en cada
//   feature:
//
//   1. El flightShuttleBuilder por defecto de Hero hace un morph directo
//      de tamaño/posición entre el widget de origen y destino. Si ambos
//      widgets se ven muy distintos (ej. un ícono pequeño en una lista →
//      una imagen grande en detalle), el morph se ve como un "estiramiento"
//      incómodo. AppHero cruza en fade entre ambos durante el vuelo — más
//      predecible visualmente sin importar cuán distintos sean origen/destino.
//   2. Los tags de Hero deben ser ÚNICOS por Navigator — un string literal
//      duplicado por accidente entre dos features (ej. dos pantallas usando
//      'card' como tag) causa una excepción en tiempo de ejecución difícil
//      de rastrear. [AppHeroTags.build] centraliza la convención
//      `categoría::id` para que nunca se escriba un tag suelto.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, core/theme/.
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Construye tags de [Hero] únicos con la convención `categoría::id`.
///
/// Uso: `AppHero(tag: AppHeroTags.build('world_card', worldId), child: ...)`
/// en la pantalla de origen, y el MISMO `AppHeroTags.build(...)` en destino.
abstract final class AppHeroTags {
  static String build(String category, String id) => '$category::$id';
}

/// [Hero] con flightShuttleBuilder de fade cruzado — ver documentación del
/// archivo.
///
/// Uso: idéntico a [Hero]: el mismo [tag] en la pantalla de origen y en la
/// pantalla de destino conecta la animación entre ambas.
class AppHero extends StatelessWidget {
  const AppHero({
    required this.tag,
    required this.child,
    super.key,
  });

  final Object tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (
        flightContext,
        animation,
        direction,
        fromHeroContext,
        toHeroContext,
      ) {
        final fromHero = fromHeroContext.widget as Hero;
        final toHero = toHeroContext.widget as Hero;

        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Opacity(opacity: 1 - animation.value, child: fromHero.child),
                Opacity(opacity: animation.value, child: toHero.child),
              ],
            );
          },
        );
      },
      child: child,
    );
  }
}
