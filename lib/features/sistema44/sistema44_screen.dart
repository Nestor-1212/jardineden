import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Sesión de repaso del Sistema 44 (repetición espaciada bíblica).
///
/// Pantalla fullscreen — sin bottom nav para mantener la concentración.
/// Presenta versículos según el intervalo de repaso [24h, 72h, 168h, 336h, 720h].
/// Al completar la sesión regresa al Home con resumen de desempeño.
class Sistema44Screen extends StatelessWidget {
  const Sistema44Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.chapter,
      title: 'Sistema 44 — Repaso',
      route: AppRoutes.sistema44,
      iconColor: AppColors.piedrasJordan,
      showBackButton: true,
    );
  }
}
