import 'package:flutter/material.dart';

// Punto de entrada de la aplicación.
// En este estado el proyecto es un placeholder verificable.
// El main.dart real se implementa en Sprint 02 cuando se
// instalen las dependencias (Riverpod, GoRouter, Drift, etc.)
// y se configure el árbol completo de la aplicación.
void main() {
  runApp(const JardinDelEdenApp());
}

class JardinDelEdenApp extends StatelessWidget {
  const JardinDelEdenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Jardín del Edén',
      debugShowCheckedModeBanner: false,
      home: _PlaceholderScreen(),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1B4332),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_florist,
              size: 80,
              color: Color(0xFF52B788),
            ),
            SizedBox(height: 24),
            Text(
              'Jardín del Edén',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Inicializando arquitectura...',
              style: TextStyle(
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
