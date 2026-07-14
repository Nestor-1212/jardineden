// ─────────────────────────────────────────────────────────────────────────────
// core/navigation/navigation_error_screen.dart
//
// RESPONSABILIDAD:
//   Pantalla que GoRouter muestra cuando ocurre un error de navegación:
//   ruta no encontrada (404), parámetro inválido, o error en redirect.
//
// CUÁNDO APARECE:
//   • El usuario (o un deep link) navega a una ruta que no existe.
//   • Un redirect lanza una excepción inesperada.
//   • Un pathParameter requerido no está presente.
//
// DEPENDENCIAS PERMITIDAS:   flutter, go_router, core/theme/design_tokens.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Pantalla de error de navegación (equivalente a una página 404).
class NavigationErrorScreen extends StatelessWidget {
  final Exception? error;

  const NavigationErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta no encontrada')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(AppIcons.close, size: 64, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Oops, esta pantalla no existe',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (error != null)
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(AppIcons.home),
                label: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
