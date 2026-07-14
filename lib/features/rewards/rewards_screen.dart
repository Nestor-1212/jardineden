import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Pantalla de logros y recompensas del jugador.
///
/// Muestra medallas obtenidas, trofeos de mundo, rachas completadas y
/// el historial de recompensas por rareza (Barro → Gloria).
class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.rewards,
      title: 'Mis Logros',
      route: AppRoutes.rewards,
      iconColor: AppColors.sacredGold,
      showBackButton: true,
    );
  }
}
