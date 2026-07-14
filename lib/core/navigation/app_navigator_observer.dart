// ─────────────────────────────────────────────────────────────────────────────
// core/navigation/app_navigator_observer.dart
//
// RESPONSABILIDAD:
//   Traduce los eventos de Flutter Navigator (push/pop/replace) a llamadas
//   a NavigationLogger. Es el ÚNICO archivo del proyecto que sabe que la
//   navegación se registra vía NavigatorObserver — core/logging/ no importa
//   Flutter (ver navigation_logger.dart).
//
// POR QUÉ VIVE EN core/navigation Y NO EN core/logging:
//   core/navigation/app_router.dart ya importa flutter/material.dart y
//   go_router — este archivo pertenece a la misma capa. core/logging se
//   mantiene libre de Flutter (ver la regla documentada en cada contrato).
//
// USO:
//   GoRouter(observers: [AppNavigatorObserver(navigationLogger)], ...)
//
// DEPENDENCIAS PERMITIDAS:   flutter/widgets.dart, core/logging/navigation_logger.dart.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/widgets.dart';
import 'package:jardindeleden/core/logging/navigation_logger.dart';

/// [NavigatorObserver] que reporta cada transición a [NavigationLogger].
final class AppNavigatorObserver extends NavigatorObserver {
  AppNavigatorObserver(this._navigationLogger);

  final NavigationLogger _navigationLogger;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _navigationLogger.logRouteChange(
      from: _routeName(previousRoute),
      to: _routeName(route) ?? 'unknown',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _navigationLogger.logRouteChange(
      from: _routeName(route),
      to: _routeName(previousRoute) ?? 'unknown',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _navigationLogger.logRouteChange(
      from: _routeName(oldRoute),
      to: _routeName(newRoute) ?? 'unknown',
    );
  }

  String? _routeName(Route<dynamic>? route) => route?.settings.name;
}
