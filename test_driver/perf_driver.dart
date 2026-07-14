// ─────────────────────────────────────────────────────────────────────────────
// test_driver/perf_driver.dart
//
// RESPONSABILIDAD
// Lado "driver" (proceso de escritorio) del mecanismo OFICIAL de Flutter
// para tests de integración y rendimiento — ver
// https://docs.flutter.dev/testing/integration-tests#measuring-performance.
// Este archivo NO corre en el dispositivo/emulador: `flutter drive` lo
// ejecuta en la máquina de desarrollo/CI, y él a su vez se conecta al
// proceso de la app (que sí corre en el dispositivo) para recibir los
// resultados capturados por IntegrationTestWidgetsFlutterBinding.
//
// CÓMO SE USA (cuando exista un test de rendimiento real en
// integration_test/performance/, ver ese directorio):
//   flutter drive \
//     --driver=test_driver/perf_driver.dart \
//     --target=integration_test/performance/<nombre>_test.dart \
//     --profile
//
// `--profile` (no `--debug` ni `--release`) es OBLIGATORIO para mediciones de
// rendimiento: --debug tiene overhead de desarrollo (assertions, hot
// reload) que infla los números; --release desactiva herramientas de
// profiling que la captura de timeline necesita.
//
// QUÉ HACE integrationDriver() (de package:integration_test, no código propio
// de este proyecto): se conecta al binding de la app vía FlutterDriver,
// espera los datos reportados por `binding.reportData` (ver
// IntegrationTestWidgetsFlutterBinding.instance.traceAction() dentro del
// test de rendimiento en sí) y los escribe en
// build/integration_response_data.json — ahí es donde se leen los
// timelines para detectar jank (frames >16ms a 60fps / >8ms a 120fps).
//
// POR QUÉ ESTE ARCHIVO NO TIENE LÓGICA PROPIA
// Es un adaptador — toda la lógica de "qué medir" vive en el test de
// integración del lado de la app (integration_test/performance/*_test.dart),
// no aquí. Este archivo es el mismo para CUALQUIER test de rendimiento del
// proyecto; no se edita por feature.
//
// DEPENDENCIAS PERMITIDAS: package:integration_test/integration_test_driver.dart
// (paquete oficial de Flutter — ver pubspec.yaml).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
