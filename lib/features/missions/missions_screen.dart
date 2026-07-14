import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Pantalla de misiones diarias (Tab 3 del bottom nav).
///
/// Muestra las misiones del día con su progreso, XP disponible y tiempo
/// restante para completarlas. Las misiones completadas muestran su recompensa.
class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.missions,
      title: 'Misiones del Día',
      route: AppRoutes.missions,
    );
  }
}
