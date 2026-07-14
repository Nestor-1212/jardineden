// ─────────────────────────────────────────────────────────────────────────────
// flutter_test_config.dart
//
// Nombre MÁGICO reconocido por `flutter test`: si existe en test/ (o en
// cualquier subcarpeta, con alcance sobre esa subcarpeta), Flutter lo importa
// y ejecuta su testExecutable() ANTES de correr cualquier archivo *_test.dart
// del mismo alcance. Es el único hook global de setup que ofrece el test
// runner — no hay equivalente a un "beforeAll" de otros frameworks.
//
// RESPONSABILIDAD
// Cargar las fuentes reales del proyecto (Fredoka, Nunito, NotoSans) antes de
// cualquier golden test. Sin esto, Flutter renderiza texto en todos los
// goldens con la fuente de test por defecto ("Ahem", cuadros monoespaciados),
// lo que hace que las imágenes de referencia no reflejen el diseño real y que
// cualquier fuente nueva agregada al proyecto rompa goldens ya aprobados.
//
// POR QUÉ ES DEFENSIVO
// Las fuentes reales (Fredoka/Nunito/NotoSans) todavía NO existen en
// assets/core/fonts/ — están reservadas en pubspec.yaml (comentadas) desde
// el sprint de Assets, pendientes de que el equipo de diseño descargue los
// .ttf. Este archivo comprueba con File.existsSync() antes de intentar cargar
// cada familia: si el .ttf no está, la fuente se omite en silencio (los
// goldens seguirán usando la fuente de test por defecto hasta ese momento) en
// vez de que CADA test de este proyecto falle con un FileSystemException.
// Cuando el equipo agregue los archivos reales, este archivo empieza a
// cargarlos automáticamente — cero cambios de código futuros.
//
// DEPENDENCIAS PERMITIDAS: dart:io (File — lectura directa de disco, NO vía
// rootBundle/AssetBundle porque las fuentes aún no están declaradas como
// asset en pubspec.yaml), flutter_test.
// DEPENDENCIAS PROHIBIDAS: cualquier paquete de terceros (golden_toolkit,
// alchemist) — ver test/test_conventions.dart para la justificación de por
// qué este proyecto se queda con las capacidades nativas de flutter_test.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada que `flutter test` invoca en vez de correr los tests
/// directamente. `testMain` es el runner real (todos los `main()` de los
/// archivos `*_test.dart` en el alcance de esta carpeta), se lo llama al
/// final para que la suite continúe normalmente.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await _loadRealFontsIfPresent();

  await testMain();
}

/// Familias de fuentes del Design System (ver core/theme/app_text_styles.dart)
/// junto con la ruta de al menos un archivo .ttf representativo de cada una.
/// Se usa solo ese archivo (no los 4-7 pesos completos) porque para goldens
/// alcanza con que la familia esté registrada — el peso exacto (regular vs
/// bold) no afecta la métrica de layout que los goldens necesitan comparar.
const Map<String, String> _fontFamilyProbePaths = {
  'Fredoka': 'assets/core/fonts/fredoka/Fredoka-Regular.ttf',
  'Nunito': 'assets/core/fonts/nunito/Nunito-Regular.ttf',
  'NotoSans': 'assets/core/fonts/noto_sans/NotoSans-Regular.ttf',
};

Future<void> _loadRealFontsIfPresent() async {
  for (final entry in _fontFamilyProbePaths.entries) {
    final file = File(entry.value);
    if (!file.existsSync()) {
      // Fuente todavía no agregada al proyecto — se omite sin error.
      continue;
    }

    final bytes = await file.readAsBytes();
    final loader = FontLoader(entry.key)
      ..addFont(Future<ByteData>.value(bytes.buffer.asByteData()));
    await loader.load();
  }
}
