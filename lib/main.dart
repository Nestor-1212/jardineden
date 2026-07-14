import 'package:jardindeleden/bootstrap.dart';

/// Entry point por defecto — se usa cuando se ejecuta `flutter run`/
/// `flutter test` SIN especificar un flavor (útil para pruebas rápidas de
/// sanidad). Para trabajo diario, usar el entry point del ambiente
/// correspondiente (lib/main_development.dart + `--flavor development`) —
/// ver bootstrap.dart para el porqué de esta separación.
void main() => bootstrap();
