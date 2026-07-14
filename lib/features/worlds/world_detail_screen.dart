import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Detalle de un mundo bíblico específico con su lista de capítulos.
///
/// Recibe [worldId] del path parameter de GoRouter (/home/worlds/:worldId).
/// Muestra el lore del mundo, el mapa de capítulos y el progreso del jugador.
/// Desde aquí se navega a /chapter/:chapterId para jugar un capítulo.
class WorldDetailScreen extends StatelessWidget {
  final String worldId;

  const WorldDetailScreen({required this.worldId, super.key});

  @override
  Widget build(BuildContext context) {
    return NavPlaceholder(
      icon: AppIcons.world,
      title: 'Mundo: $worldId',
      route: '/home/worlds/$worldId',
      showBackButton: true,
    );
  }
}
