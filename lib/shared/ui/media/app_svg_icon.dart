// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/media/app_svg_icon.dart
//
// RESPONSABILIDAD:
//   Renderiza íconos vectoriales (.svg) del Design System — la contraparte
//   de AppIcons (core/theme/app_icons.dart) para cuando un ícono deja de
//   ser un placeholder de Material Icons y pasa a ser un vector propio del
//   proyecto (ver assets/core/icons/svg/ y AssetPaths.svgIcon*).
//
// POR QUÉ EXISTE SI YA HAY AppIcons:
//   AppIcons envuelve `Icon(IconData)` — Material Icons son GLIFOS de una
//   fuente de íconos, no admiten multi-color ni detalle fino. Los íconos
//   custom del juego (monedas, rarezas) sí lo necesitan (ver el degradado
//   dorado de "rarityOro", por ejemplo). Cuando el archivo .svg exista,
//   AppIcons.forCurrency/forRarity cambian su implementación interna de
//   `Icon(Icons.x)` a `AppSvgIcon(AssetPaths.svgIconX)` — el nombre de la
//   constante en AppIcons no cambia, así que ningún widget que ya use
//   AppIcons.currencyLuz necesita tocarse cuando eso pase.
//
// TAMAÑO: se integra con el sistema de escalado adaptable (Sprint de
//   Diseño Adaptable) — igual que Icon(), acepta un [size] en vez de
//   requerir que el llamador use AppIconScale manualmente cada vez.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, package:flutter_svg,
//                            core/theme/ (AppIconScale).
// DEPENDENCIAS PROHIBIDAS:   features, core/infrastructure, Riverpod.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jardindeleden/core/theme/app_icon_scale.dart';

/// Ícono vectorial del Design System — ver documentación del archivo.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.assetPath, {
    super.key,
    this.size = 24.0,
    this.color,
    this.semanticLabel,
  });

  /// Path del asset — usar una constante de AssetPaths.svgIcon*, nunca un
  /// string literal.
  final String assetPath;

  /// Tamaño base — se escala automáticamente según el tamaño de pantalla
  /// vía [AppIconScaleContext.scaledIconSize], igual que [Icon.size].
  final double size;

  /// Tinte de color opcional (equivalente a `Icon(color: ...)`). Dejar
  /// `null` para respetar los colores originales del SVG (necesario para
  /// íconos multi-color como monedas con degradado).
  final Color? color;

  /// Descripción para lectores de pantalla (TalkBack/VoiceOver) — ver
  /// core/accessibility/screen_reader.dart. Si el ícono es puramente
  /// decorativo y ya hay texto adyacente que lo describe, dejar `null` (el
  /// SVG se excluye de la semántica automáticamente en ese caso).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scaledSize = context.scaledIconSize(size);

    return SvgPicture.asset(
      assetPath,
      width: scaledSize,
      height: scaledSize,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
