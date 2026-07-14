import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jardindeleden/core/theme/app_theme.dart';
import 'package:jardindeleden/l10n/generated/app_localizations.dart';

void main() {
  runApp(const JardinDelEdenApp());
}

class JardinDelEdenApp extends StatelessWidget {
  const JardinDelEdenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jardín del Edén',
      debugShowCheckedModeBanner: false,

      // ── Temas Material 3 (Sprint 05) ─────────────────────────────────────
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // ── Internacionalización (Sprint 06) ─────────────────────────────────
      // GlobalMaterialLocalizations → formatos de fecha/número para widgets Material
      // GlobalWidgetsLocalizations  → dirección de texto (LTR/RTL) para todos los widgets
      // GlobalCupertinoLocalizations → formatos de Cupertino (date pickers iOS)
      // AppLocalizations.delegate  → los strings del juego (ARB → Dart generado)
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Lista de locales soportados generada automáticamente por flutter gen-l10n
      // a partir de los archivos ARB: es, en, pt
      supportedLocales: AppLocalizations.supportedLocales,

      home: const _PlaceholderScreen(),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4332),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_florist,
              size: 80,
              color: Color(0xFF52B788),
            ),
            const SizedBox(height: 24),
            const Text(
              'Jardín del Edén',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).statusLoading,
              style: const TextStyle(
                color: Color(0xFF95D5B2),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
