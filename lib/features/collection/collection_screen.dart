import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Colección de ítems del jugador: cartas de personajes bíblicos, artefactos,
/// monedas acumuladas y tabla de Vinculum con cada personaje conocido.
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavPlaceholder(
      icon: AppIcons.collection,
      title: 'Colección',
      route: AppRoutes.collection,
      showBackButton: true,
    );
  }
}
