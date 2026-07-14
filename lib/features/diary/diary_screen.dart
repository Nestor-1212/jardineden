import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Diario personal del jugador.
///
/// Permite anotar reflexiones sobre los versículos aprendidos y los mundos
/// explorados. Cada entrada queda vinculada al capítulo del día.
class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.diary,
      title: 'Mi Diario',
      route: AppRoutes.diary,
      showBackButton: true,
    );
  }
}
