import 'package:jardindeleden/bootstrap.dart';

/// Entry point del ambiente Staging.
///
/// Ejecutar con:
///   flutter run --flavor staging -t lib/main_staging.dart --dart-define=ENV=staging
///
/// Ver bootstrap.dart para el porqué de este archivo y
/// core/config/app_environment.dart para lo que activa ENV=staging.
void main() => bootstrap();
