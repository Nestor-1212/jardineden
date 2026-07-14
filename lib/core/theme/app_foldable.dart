// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_foldable.dart
//
// RESPONSABILIDAD:
//   Detecta bisagras/pliegues de pantallas plegables (Samsung Fold, Pixel
//   Fold, etc.) vía `MediaQuery.displayFeaturesOf()` — la API estándar de
//   Flutter para esto, sin dependencias de terceros.
//
// POR QUÉ IMPORTA PARA ESTE JUEGO:
//   Un panel de HUD, un botón, o texto de un versículo NUNCA deben quedar
//   partidos exactamente debajo de la bisagra física — es ilegible y, en
//   dispositivos con bisagra hendida (no solo un pliegue de pantalla
//   flexible), literalmente inalcanzable al tacto. Esta clase da la
//   información; NO decide el layout — cada pantalla futura decide qué
//   hacer con [AppFoldableInfo] (evitar la zona, dividir en dos paneles,
//   ignorarla si el contenido es angosto).
//
// QUÉ ES [isSeparated]:
//   true cuando la bisagra divide físicamente la superficie en dos mitades
//   independientes (plegables con bisagra rígida tipo libro, abiertos a
//   ~90°) — en ese caso casi siempre conviene layout de dos paneles en vez
//   de intentar centrar contenido sobre la bisagra.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, dart:ui (DisplayFeature),
//                            package:collection (firstOrNull).
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Información de bisagra/pliegue de la pantalla actual.
final class AppFoldableInfo {
  const AppFoldableInfo({
    required this.hasFold,
    required this.hingeBounds,
    required this.isSeparated,
  });

  /// `true` si el dispositivo reporta una bisagra o pliegue.
  final bool hasFold;

  /// Límites físicos de la bisagra en coordenadas de pantalla, o `null` si
  /// [hasFold] es `false`.
  final Rect? hingeBounds;

  /// `true` si la bisagra separa la pantalla en dos superficies físicas
  /// independientes (plegable tipo libro abierto) — ver nota arriba.
  final bool isSeparated;

  /// Sin bisagra — el caso normal (teléfono/tablet no plegable).
  static const AppFoldableInfo none = AppFoldableInfo(
    hasFold: false,
    hingeBounds: null,
    isSeparated: false,
  );

  /// Divide [screenSize] en dos paneles a los lados de la bisagra.
  ///
  /// Retorna `null` si no hay bisagra — la pantalla debe usar layout de un
  /// solo panel. Asume una bisagra vertical (el caso más común en
  /// plegables tipo libro); si [hingeBounds] es horizontal, retorna `null`
  /// (el llamador decide su propio fallback para ese caso, poco común).
  ({Rect start, Rect end})? splitPanes(Size screenSize) {
    final bounds = hingeBounds;
    if (!hasFold || bounds == null) return null;
    if (bounds.height < bounds.width) return null; // bisagra horizontal

    return (
      start: Rect.fromLTWH(0, 0, bounds.left, screenSize.height),
      end: Rect.fromLTWH(
        bounds.right,
        0,
        screenSize.width - bounds.right,
        screenSize.height,
      ),
    );
  }
}

/// Extensión de BuildContext para detección de pantallas plegables.
extension AppFoldableContext on BuildContext {
  /// Información de bisagra/pliegue de esta pantalla — ver [AppFoldableInfo].
  AppFoldableInfo get foldableInfo {
    final features = MediaQuery.displayFeaturesOf(this);
    final hinge = features
        .where(
          (feature) =>
              feature.type == DisplayFeatureType.hinge ||
              feature.type == DisplayFeatureType.fold,
        )
        .firstOrNull;

    if (hinge == null) return AppFoldableInfo.none;

    return AppFoldableInfo(
      hasFold: true,
      hingeBounds: hinge.bounds,
      isSeparated: hinge.state == DisplayFeatureState.postureHalfOpened,
    );
  }
}
