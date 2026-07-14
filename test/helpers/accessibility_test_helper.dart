// ─────────────────────────────────────────────────────────────────────────────
// test/helpers/accessibility_test_helper.dart
//
// RESPONSABILIDAD
// Envolver los matchers de accesibilidad NATIVOS de flutter_test
// (meetsGuideline + AccessibilityGuideline de package:flutter_test/flutter_test.dart)
// en una API que maneja el ciclo de vida de SemanticsHandle por el
// desarrollador — el error más común al escribir estos tests a mano es
// olvidar `handle.dispose()`, lo que deja el árbol de semántica activo y
// puede hacer que EL SIGUIENTE test del mismo archivo falle de forma
// confusa (semántica de un test anterior todavía presente).
//
// GUIDELINES DISPONIBLES (todas de flutter_test, no de este proyecto):
//   • androidTapTargetGuideline   — objetivo táctil mínimo 48x48 (Android).
//   • iOSTapTargetGuideline       — objetivo táctil mínimo 44x44 (iOS).
//   • textContrastGuideline       — contraste de texto mínimo WCAG AA.
//   • labeledTapTargetGuideline   — todo nodo tap/long-press tiene label.
//
// POR QUÉ "botones grandes para niños de 4 años" NO tiene una guideline
// aparte aquí: el requisito del proyecto (ver Sprint de Accesibilidad,
// core/accessibility/) ya EXCEDE androidTapTargetGuideline/iOSTapTargetGuideline
// con AppSpacing.touchTargetLarge (64px, ver core/theme/app_spacing.dart). Correr
// ambas guidelines nativas sigue siendo útil como piso mínimo de la
// plataforma; el mínimo más estricto del proyecto se valida por separado
// comparando el tamaño real del widget contra esa constante — no hay un
// AccessibilityGuideline custom porque expectLater(tester, meetsGuideline(...))
// solo acepta el contrato de AccessibilityGuideline, y ese piso de plataforma
// ya es un subconjunto correcto para golden/widget tests de este proyecto.
//
// DALTONISMO / ALTO CONTRASTE / TalkBack / VoiceOver / reducción de
// animaciones: esas son responsabilidad de core/accessibility/ (lógica de
// producción, ya implementada — ver color_blind_support.dart,
// app_high_contrast_colors.dart, app_motion.dart) y se prueban como
// unit/widget tests normales (verificando que el ColorScheme/tema resultante
// cambie), no como "guidelines" — flutter_test no tiene un matcher nativo
// para esos ejes, a diferencia de tap target/contraste.
//
// DEPENDENCIAS PERMITIDAS: flutter_test.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_test/flutter_test.dart';

/// Conjunto por defecto de guidelines que CUALQUIER pantalla interactiva del
/// proyecto debe cumplir — ver encabezado de este archivo para el porqué de
/// cada una.
const List<AccessibilityGuideline> defaultAccessibilityGuidelines = [
  androidTapTargetGuideline,
  iOSTapTargetGuideline,
  textContrastGuideline,
  labeledTapTargetGuideline,
];

/// Evalúa [guidelines] contra el árbol ya montado por [tester] y libera el
/// [SemanticsHandle] automáticamente al finalizar (éxito o falla) — evita el
/// olvido de `handle.dispose()` mencionado en el encabezado.
///
/// Requiere que el widget ya haya sido montado (`pumpApp`/`pumpWidget`) ANTES
/// de llamar a este helper — a diferencia de `pumpApp`, este helper no monta
/// nada, solo evalúa el árbol actual.
///
/// Ejemplo:
/// ```dart
/// testWidgets('ContinueButton cumple accesibilidad mínima', (tester) async {
///   await pumpApp(tester, child: const ContinueButton());
///
///   await expectMeetsAccessibilityGuidelines(tester);
/// }, tags: ['accessibility']);
/// ```
Future<void> expectMeetsAccessibilityGuidelines(
  WidgetTester tester, {
  List<AccessibilityGuideline> guidelines = defaultAccessibilityGuidelines,
}) async {
  final handle = tester.ensureSemantics();

  try {
    for (final guideline in guidelines) {
      await expectLater(tester, meetsGuideline(guideline));
    }
  } finally {
    handle.dispose();
  }
}
