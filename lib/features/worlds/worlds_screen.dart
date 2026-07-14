import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Mapa de los 10 mundos bíblicos (Tab 2 del bottom nav).
///
/// Muestra los mundos como un mapa interactivo. Los mundos bloqueados
/// muestran sus requisitos de desbloqueo. Al tocar un mundo navega a
/// /home/worlds/:worldId para ver sus capítulos.
class WorldsScreen extends StatelessWidget {
  const WorldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.worlds,
      title: 'Mundos Bíblicos',
      route: AppRoutes.worlds,
    );
  }
}
