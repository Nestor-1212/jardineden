// ─────────────────────────────────────────────────────────────────────────────
// shared/ui/media/app_media_widgets.dart
//
// RESPONSABILIDAD:
//   Barrel de los widgets que renderizan assets de medios (vectores,
//   animaciones) del Design System. Las features importan SOLO este
//   archivo en vez de cada wrapper por separado.
//
// CATÁLOGO:
//   AppSvgIcon         → íconos vectoriales (.svg) — core/icons/svg/.
//   AppLottieAnimation → animaciones Lottie (.json) — animations/lottie/.
//   AppRiveAnimation   → animaciones Rive (.riv) — animations/rive/.
//
// RELACIÓN CON OTROS CATÁLOGOS DEL PROYECTO:
//   shared/ui/animations/ → animación de WIDGETS de Flutter (fade, scale,
//                            slide, bounce) construidos con
//                            AnimationController — mueven cualquier widget.
//   shared/ui/media/      → renderizado de ARCHIVOS de asset (vector,
//                            Lottie, Rive) — muestran contenido, no mueven
//                            widgets arbitrarios.
//   Ambos catálogos son complementarios: un AppSvgIcon puede envolverse en
//   un AppScaleIn para su aparición, por ejemplo.
// ─────────────────────────────────────────────────────────────────────────────

export 'app_lottie_animation.dart';
export 'app_rive_animation.dart';
export 'app_svg_icon.dart';
