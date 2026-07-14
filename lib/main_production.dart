import 'package:jardindeleden/bootstrap.dart';

/// Entry point del ambiente Production.
///
/// Ejecutar con:
///   flutter run --flavor production -t lib/main_production.dart --dart-define=ENV=prod
///
/// Ver bootstrap.dart para el porqué de este archivo y
/// core/config/app_environment.dart para lo que activa ENV=prod.
void main() => bootstrap();
