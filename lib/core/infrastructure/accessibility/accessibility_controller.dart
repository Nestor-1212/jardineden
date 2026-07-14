// ─────────────────────────────────────────────────────────────────────────────
// core/infrastructure/accessibility/accessibility_controller.dart
//
// RESPONSABILIDAD:
//   Estado reactivo de accesibilidad — la UI observa esto (`ref.watch`),
//   no AccessibilityService directamente. Carga las preferencias guardadas
//   una vez (build()), y cada setter actualiza memoria Y persistencia
//   atómicamente, para que ningún widget necesite recordar "guardar
//   después de cambiar".
//
// POR QUÉ AsyncNotifier Y NO Notifier SIMPLE:
//   build() lee de StorageService, que es asíncrono (ver
//   StorageServiceProvider). El estado inicial real no está disponible
//   sincrónicamente al arrancar la app — AsyncNotifier<AccessibilitySettings>
//   modela correctamente el estado de carga con AsyncValue (loading/data/error),
//   igual que cualquier FutureProvider del proyecto.
//
// CICLO DE VIDA: keepAlive: true — sigue el patrón "Singleton con Estado"
//   documentado en core/di/app_di.dart (mismo trato que AuthState/AudioSettings).
//
// USO (cuando exista una pantalla de Ajustes de Accesibilidad — Sprint futuro):
//   ```dart
//   final settingsAsync = ref.watch(accessibilityControllerProvider);
//   settingsAsync.when(
//     data: (settings) => Switch(
//       value: settings.highContrastEnabled,
//       onChanged: (v) => ref.read(accessibilityControllerProvider.notifier)
//           .setHighContrastEnabled(v),
//     ),
//     loading: () => const CircularProgressIndicator(),
//     error: (e, _) => Text('Error: $e'),
//   );
//   ```
//
// DEPENDENCIAS PERMITIDAS:   riverpod_annotation, core/accessibility/,
//                            accessibility_service_provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:jardindeleden/core/accessibility/accessibility_settings.dart';
import 'package:jardindeleden/core/infrastructure/accessibility/accessibility_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accessibility_controller.g.dart';

/// Estado reactivo de [AccessibilitySettings] para toda la app.
@Riverpod(keepAlive: true)
class AccessibilityController extends _$AccessibilityController {
  @override
  Future<AccessibilitySettings> build() async {
    final service = await ref.watch(accessibilityServiceProvider.future);
    return service.load();
  }

  Future<void> setTextScaleMode(TextScaleMode mode) =>
      _update((settings) => settings.copyWith(textScaleMode: mode));

  Future<void> setHighContrastEnabled(bool enabled) =>
      _update((settings) => settings.copyWith(highContrastEnabled: enabled));

  Future<void> setColorBlindMode(ColorBlindMode mode) =>
      _update((settings) => settings.copyWith(colorBlindMode: mode));

  Future<void> setReduceMotionEnabled(bool enabled) =>
      _update((settings) => settings.copyWith(reduceMotionEnabled: enabled));

  Future<void> setSimplifiedNavigationEnabled(bool enabled) => _update(
    (settings) => settings.copyWith(simplifiedNavigationEnabled: enabled),
  );

  Future<void> setLargeButtonsEnabled(bool enabled) =>
      _update((settings) => settings.copyWith(largeButtonsEnabled: enabled));

  Future<void> setNarrationEnabled(bool enabled) =>
      _update((settings) => settings.copyWith(narrationEnabled: enabled));

  /// Aplica un perfil completo de accesibilidad de una sola vez — ver
  /// [AccessibilitySettings.forProfile]. Reemplaza TODOS los campos, no los
  /// combina con los valores actuales.
  Future<void> applyProfile(AccessibilityProfile profile) async {
    final settings = AccessibilitySettings.forProfile(profile);
    final service = await ref.read(accessibilityServiceProvider.future);
    await service.save(settings);
    state = AsyncData(settings);
  }

  Future<void> _update(
    AccessibilitySettings Function(AccessibilitySettings current) transform,
  ) async {
    final current = await future;
    final updated = transform(current);
    final service = await ref.read(accessibilityServiceProvider.future);
    await service.save(updated);
    state = AsyncData(updated);
  }
}
