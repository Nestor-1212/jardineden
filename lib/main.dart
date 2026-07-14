import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jardindeleden/core/navigation/app_router.dart';
import 'package:jardindeleden/core/theme/app_theme.dart';
import 'package:jardindeleden/l10n/generated/app_localizations.dart';

void main() {
  runApp(
    // ProviderScope: contenedor raíz de Riverpod.
    // Todos los providers del proyecto son accesibles desde aquí hacia abajo.
    const ProviderScope(
      child: JardinDelEdenApp(),
    ),
  );
}

/// Widget raíz de la aplicación.
///
/// Usa [ConsumerWidget] en lugar de [StatelessWidget] para leer el
/// [appRouterProvider] que provee la instancia de GoRouter configurada.
class JardinDelEdenApp extends ConsumerWidget {
  const JardinDelEdenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Jardín del Edén',
      debugShowCheckedModeBanner: false,

      // ── Temas Material 3 ────────────────────────────────────────────────────
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // ── Internacionalización ────────────────────────────────────────────────
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // ── Navegación GoRouter ─────────────────────────────────────────────────
      routerConfig: router,
    );
  }
}
