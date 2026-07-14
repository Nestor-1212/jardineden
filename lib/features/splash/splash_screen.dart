import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';
import 'package:jardindeleden/shared/extensions/localization_extensions.dart';

/// Pantalla de carga inicial del juego.
///
/// Punto de entrada de la app. En Sprint de Auth:
///   • Inicializa Hive/SQLite y los servicios core.
///   • Decide si ir a /profiles (sin perfil) o /home (perfil existente).
///
/// Sprint 07: redirige a /profiles para validar la navegación.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_navigateAfterDelay());
  }

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) context.go(AppRoutes.profiles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gardenDeep,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_florist,
              size: 80,
              color: AppColors.gardenMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Jardín del Edén',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.statusLoading,
              style: const TextStyle(
                color: AppColors.gardenLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
