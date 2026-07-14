import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Biblioteca bíblica del juego.
///
/// Muestra versículos desbloqueados, pasajes de la Biblia por mundo,
/// concordancia y sistema de marcadores. Accesible desde el Dashboard (Home).
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.library,
      title: 'Biblioteca',
      route: AppRoutes.library,
      showBackButton: true,
    );
  }
}
