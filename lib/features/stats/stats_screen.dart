import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Estadísticas de progreso del jugador.
///
/// Muestra gráficos de racha semanal, versículos memorizados por mundo,
/// tiempo de juego por categoría y evolución del nivel en el Sistema 44.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.stats,
      title: 'Mi Progreso',
      route: AppRoutes.stats,
      showBackButton: true,
    );
  }
}
