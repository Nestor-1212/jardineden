import 'package:flutter/material.dart';
import 'package:jardindeleden/core/navigation/nav_placeholder.dart';
import 'package:jardindeleden/core/theme/design_tokens.dart';

/// Pantalla de juego de un capítulo bíblico. Experiencia de pantalla completa.
///
/// Recibe [chapterId] del path parameter de GoRouter (/chapter/:chapterId).
/// No tiene bottom nav — vive fuera del ShellRoute para inmersión total.
/// Al completar el capítulo regresa a /home/worlds/:worldId o a /home.
class ChapterScreen extends StatelessWidget {
  final String chapterId;

  const ChapterScreen({required this.chapterId, super.key});

  @override
  Widget build(BuildContext context) {
    return NavPlaceholder(
      icon: AppIcons.chapter,
      title: 'Capítulo: $chapterId',
      route: '/chapter/$chapterId',
      showBackButton: true,
    );
  }
}
