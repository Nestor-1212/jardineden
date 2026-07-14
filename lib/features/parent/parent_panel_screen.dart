import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Panel de control exclusivo para padres y tutores.
///
/// Solo accesible después de validar el PIN en /parent-pin.
/// Permite: límites de tiempo, supervisión de progreso por perfil,
/// ajustes de contenido por tier de edad, historial de sesiones.
///
/// Sprint de Auth: el redirect guard en AppRouter bloqueará el acceso
/// directo a esta ruta si el PIN no fue validado en la sesión actual.
class ParentPanelScreen extends StatelessWidget {
  const ParentPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.parentPanel,
      title: 'Panel de Padres',
      route: AppRoutes.parentPanel,
      iconColor: AppColors.gardenLeaf,
      showBackButton: true,
    );
  }
}
