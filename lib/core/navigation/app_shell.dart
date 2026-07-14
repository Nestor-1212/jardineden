// ─────────────────────────────────────────────────────────────────────────────
// core/navigation/app_shell.dart
//
// RESPONSABILIDAD:
//   Widget que envuelve todas las pantallas dentro del ShellRoute de GoRouter.
//   Provee la barra de navegación inferior (NavigationBar de Material 3) que
//   persiste mientras el usuario navega entre los tabs principales del juego.
//
// ARQUITECTURA:
//   ShellRoute (GoRouter) → AppShell (este widget) → child (tab actual)
//
//   El [child] es la pantalla activa del tab actual, inyectada por GoRouter.
//   AppShell NO sabe qué pantalla es el child — solo gestiona el scaffold
//   exterior y la selección del tab.
//
// TABS PRIMARIOS (bottom nav, 5 destinos):
//   0 → Home        /home             Dashboard del jardín
//   1 → Worlds      /home/worlds      Mapa de los 10 mundos bíblicos
//   2 → Missions    /home/missions    Misiones diarias
//   3 → Lumi        /home/pet         Mascota búho
//   4 → Settings    /home/settings    Configuración y control parental
//
// TABS SECUNDARIOS (accesibles via push desde Home, no en bottom nav):
//   Library, Diary, Rewards, Collection, Stats
//
// NOTA PARA EL SPRINT DE UI:
//   Cuando se implemente la UI real, considerar StatefulShellRoute de GoRouter
//   para preservar el estado de scroll de cada tab al cambiar.
//
// DEPENDENCIAS PERMITIDAS:   flutter, go_router, core/theme, core/navigation.
// DEPENDENCIAS PROHIBIDAS:   features, shared.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jardindeleden/core/navigation/app_routes.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';
import 'package:jardindeleden/shared/extensions/localization_extensions.dart';

/// Scaffold persistente del shell de navegación principal.
///
/// Mantiene el [NavigationBar] visible mientras el usuario navega entre tabs.
/// Usa la URI actual de GoRouter para sincronizar el tab seleccionado.
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexForLocation(location),
        onDestinationSelected: (index) => _onTabTapped(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.home),
            label: context.l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.worlds),
            label: context.l10n.navWorlds,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.missions),
            label: context.l10n.navMissions,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.pet),
            label: context.l10n.navPet,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.settings),
            label: context.l10n.navSettings,
          ),
        ],
      ),
    );
  }

  /// Resuelve qué índice del bottom nav corresponde a la ruta activa.
  ///
  /// Las rutas secundarias dentro del shell (Library, Diary, Rewards,
  /// Collection, Stats) no tienen tab propio — mantienen el tab de Home
  /// activo ya que son destinos accesibles desde el dashboard.
  int _indexForLocation(String location) {
    if (location.startsWith('/home/worlds')) return 1;
    if (location.startsWith('/home/missions')) return 2;
    if (location.startsWith('/home/pet')) return 3;
    if (location.startsWith('/home/settings')) return 4;
    return 0;
  }

  /// Navega al tab seleccionado usando go() para reemplazar la ruta actual.
  ///
  /// go() en lugar de push() evita apilar rutas de tabs en el historial.
  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.worlds);
      case 2:
        context.go(AppRoutes.missions);
      case 3:
        context.go(AppRoutes.pet);
      case 4:
        context.go(AppRoutes.settings);
    }
  }
}
