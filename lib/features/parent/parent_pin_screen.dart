import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Pantalla de entrada del PIN parental. Paso obligatorio antes del panel.
///
/// Recibe [redirectAfter] del query parameter de GoRouter
/// (/parent-pin?redirectAfter=%2Fparent-panel).
/// Al validar el PIN con éxito navega a [redirectAfter] o a /parent-panel.
/// Al cancelar regresa a la pantalla anterior con context.pop().
class ParentPinScreen extends StatelessWidget {
  final String? redirectAfter;

  const ParentPinScreen({super.key, this.redirectAfter});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.pin,
      title: 'Código de Padres',
      route: AppRoutes.parentPin,
      iconColor: AppColors.gardenMoss,
      showBackButton: true,
    );
  }
}
