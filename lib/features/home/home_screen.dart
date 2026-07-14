import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Dashboard principal del juego (Tab 1 del bottom nav).
///
/// Muestra: saludo de Lumi, racha diaria, progreso del mundo actual,
/// accesos rápidos a misiones, biblioteca, logros, colección y estadísticas.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.home,
      title: 'Mi Jardín',
      route: AppRoutes.home,
    );
  }
}
