import 'package:jardindeleden/bootstrap.dart';

/// Entry point del ambiente Development.
///
/// Ejecutar con:
///   flutter run --flavor development -t lib/main_development.dart --dart-define=ENV=dev
///
/// Ver bootstrap.dart para el porqué de este archivo y
/// core/config/app_environment.dart para lo que activa ENV=dev.
void main() => bootstrap();
