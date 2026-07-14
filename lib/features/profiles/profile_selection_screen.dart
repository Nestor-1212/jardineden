import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Pantalla de selección del perfil de jugador.
///
/// Muestra los perfiles existentes (Querubín/Discípulo/Apóstol).
/// Navega a /profiles/create si no hay perfiles o el usuario quiere uno nuevo.
/// Navega a /onboarding (primera vez) o /home (perfil conocido).
class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.profile,
      title: '¿Quién explora hoy?',
      route: AppRoutes.profiles,
    );
  }
}
