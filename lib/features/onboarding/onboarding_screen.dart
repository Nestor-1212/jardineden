import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Tutorial de primera vez que se muestra al crear un perfil.
///
/// Presenta: qué es el jardín, cómo funcionan los mundos, Lumi como guía.
/// Al completarse navega a /home.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.play,
      title: 'Bienvenido al Jardín',
      route: AppRoutes.onboarding,
    );
  }
}
