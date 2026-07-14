import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Pantalla de Lumi, la mascota búho del juego (Tab 4 del bottom nav).
///
/// Lumi reacciona al estado del jugador: racha activa, misiones pendientes,
/// hora del día. Permite interactuar con él para obtener pistas y motivación.
/// El Vinculum (nivel de relación) sube con las visitas y progresos diarios.
class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.pet,
      title: 'Lumi',
      route: AppRoutes.pet,
      iconColor: AppColors.sacredGold,
    );
  }
}
