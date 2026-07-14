// ─────────────────────────────────────────────────────────────────────────────
// core/navigation/nav_placeholder.dart
//
// RESPONSABILIDAD:
//   Widget temporal que muestran todas las pantallas pendientes de implementar.
//   Permite validar la arquitectura de navegación antes de crear la UI real.
//
// CICLO DE VIDA:
//   Cada screen que use NavPlaceholder será reemplazada en su sprint específico.
//   Cuando una screen recibe su UI real, deja de importar este archivo.
//
// DEPENDENCIAS PERMITIDAS:   flutter, core/theme/design_tokens.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, go_router.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Scaffold de marcador de posición para pantallas aún no implementadas.
///
/// Muestra el nombre de la pantalla, su ícono semántico y la ruta de GoRouter.
/// Tiene su propio [Scaffold] + [AppBar] por lo que puede usarse tanto dentro
/// del shell (ShellRoute) como en rutas fullscreen sin bottom nav.
class NavPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final Color? iconColor;
  final bool showBackButton;

  const NavPlaceholder({
    required this.icon,
    required this.title,
    required this.route,
    super.key,
    this.iconColor,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor ?? AppColors.gardenMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.gardenDeep.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              child: Text(
                route,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Sprint pendiente',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
