import 'package:jardindeleden/bootstrap.dart';

/// Entry point del ambiente QA.
///
/// Ejecutar con:
///   flutter run --flavor qa -t lib/main_qa.dart --dart-define=ENV=qa
///
/// Ver bootstrap.dart para el porqué de este archivo y
/// core/config/app_environment.dart para lo que activa ENV=qa.
void main() => bootstrap();
