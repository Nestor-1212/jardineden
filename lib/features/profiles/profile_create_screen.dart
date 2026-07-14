import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Pantalla de creación de nuevo perfil de jugador.
///
/// Permite configurar nombre, avatar, tier de edad y avatar de inicio.
/// Una vez creado el perfil navega a /onboarding.
class ProfileCreateScreen extends StatelessWidget {
  const ProfileCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.addProfile,
      title: 'Nuevo explorador',
      route: AppRoutes.profileCreate,
      showBackButton: true,
    );
  }
}
