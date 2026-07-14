import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Pantalla de configuración de la app (Tab 5 del bottom nav).
///
/// Incluye: idioma, volumen, notificaciones, perfil activo, y acceso
/// al panel de padres (requiere PIN). Navega a /parent-pin al pulsar
/// "Control Parental".
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.settings,
      title: 'Ajustes',
      route: AppRoutes.settings,
    );
  }
}
