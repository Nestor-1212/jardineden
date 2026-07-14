// ─────────────────────────────────────────────────────────────────────────────
// core/accessibility/screen_reader.dart
//
// RESPONSABILIDAD:
//   Soporte de TalkBack (Android) y VoiceOver (iOS) — ambos son lectores de
//   pantalla del SISTEMA OPERATIVO que leen el ÁRBOL DE SEMÁNTICA que
//   Flutter ya construye automáticamente a partir de widgets nativos
//   (Text, Button, Icon con label, etc.). Este proyecto NO necesita (ni
//   puede) reimplementar TalkBack/VoiceOver — la infraestructura aquí es:
//
//   1. DETECCIÓN: saber si un lector de pantalla está activo, para adaptar
//      comportamiento (ej. desactivar un gesto personalizado que un lector
//      de pantalla ya usa para su propia navegación).
//   2. ANUNCIOS: notificar cambios de estado que no son obvios por el
//      árbol de widgets solo (ej. "3 de 10 correctas" tras responder un
//      minijuego) — sin esto, un lector de pantalla no se entera de
//      cambios que no mueven el foco.
//   3. CONVENCIÓN DE ETIQUETADO (documentación, no código — ver abajo) para
//      que cada pantalla futura use Semantics de forma consistente.
//
// CONVENCIÓN DE SEMÁNTICA PARA FEATURES FUTURAS (Sprint de cada pantalla):
//   • Todo IconButton/GestureDetector interactivo SIN texto visible
//     necesita `Semantics(label: '...', button: true, child: ...)` — un
//     ícono de "play" sin label es literalmente invisible para TalkBack.
//   • Imágenes puramente decorativas (fondos, adornos) usan
//     `ExcludeSemantics` — evita que un lector de pantalla anuncie "imagen"
//     sin información útil, ruido que cansa al usuario.
//   • Grupos de widgets que forman un solo concepto (ícono + texto de una
//     tarjeta) usan `MergeSemantics` para que se lean como una unidad, no
//     elemento por elemento.
//   • Cambios de estado dinámico (contador, resultado) usan
//     [AppScreenReader.announce] — ver más abajo.
//   • Números que representan cantidades de niños de 4 años (Sistema 44,
//     puntajes) deben anunciarse con contexto ("tienes 3 monedas", no solo
//     "3") — el lector de pantalla no infiere unidades.
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, flutter/semantics.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Helper de anuncios y detección de lectores de pantalla (TalkBack/VoiceOver).
abstract final class AppScreenReader {
  /// Anuncia [message] al lector de pantalla activo (TalkBack/VoiceOver),
  /// sin necesidad de que el foco se mueva a ningún widget.
  ///
  /// Uso: resultado de una acción que no cambia qué widget tiene foco
  /// (ej. "Respuesta correcta. Ganaste 5 Semillas de Luz.").
  ///
  /// Requiere [context] (para resolver el FlutterView actual vía
  /// `View.of` — `SemanticsService.sendAnnouncement` lo exige desde que
  /// Flutter soporta múltiples ventanas). No-op silencioso si no hay lector
  /// de pantalla activo — seguro de llamar siempre.
  static void announce(
    BuildContext context,
    String message, {
    TextDirection textDirection = TextDirection.ltr,
    Assertiveness assertiveness = Assertiveness.polite,
  }) {
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        message,
        textDirection,
        assertiveness: assertiveness,
      ),
    );
  }
}

/// Extensión de BuildContext para detectar lectores de pantalla activos.
extension AppScreenReaderContext on BuildContext {
  /// `true` si TalkBack, VoiceOver, u otra tecnología de navegación
  /// asistida por accesibilidad está activa en el sistema.
  ///
  /// Uso: adaptar gestos personalizados (un swipe custom puede chocar con
  /// los gestos de navegación propios del lector de pantalla) o simplificar
  /// una animación que no aporta nada a un usuario que no la ve.
  bool get isScreenReaderActive => MediaQuery.accessibleNavigationOf(this);

  /// Anuncia [message] al lector de pantalla — ver [AppScreenReader.announce].
  void announceForAccessibility(
    String message, {
    Assertiveness assertiveness = Assertiveness.polite,
  }) => AppScreenReader.announce(this, message, assertiveness: assertiveness);
}
