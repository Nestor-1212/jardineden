// ─────────────────────────────────────────────────────────────────────────────
// core/permission/permission_service.dart
//
// RESPONSABILIDAD:
//   Solicita y consulta permisos del sistema operativo. Hoy solo cubre
//   notificaciones (lo único que el proyecto necesita); el enum
//   AppPermission es el punto de extensión para cámara/micrófono/etc. si
//   algún Sprint futuro los necesita — ese día también se agregaría
//   permission_handler como dependencia, hoy no hace falta.
//
// QUÉ NO DECIDE ESTE SERVICIO:
//   CUÁNDO pedir el permiso (ej: "pedir notificaciones después del segundo
//   logro") — eso es UX/negocio de la feature que lo necesite.
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:async.
// DEPENDENCIAS PROHIBIDAS:   features, shared/ui, Flutter widgets.
// ─────────────────────────────────────────────────────────────────────────────

/// Permisos del sistema operativo que el proyecto puede necesitar.
enum AppPermission { notifications }

/// Estado de un permiso.
enum AppPermissionStatus {
  granted,
  denied,

  /// El usuario todavía no respondió, O la plataforma actual no expone una
  /// forma de consultarlo sin disparar el diálogo nativo (ver la nota en
  /// PermissionServiceImpl.checkPermission sobre iOS).
  notDetermined,
}

/// Contrato del servicio de permisos del sistema operativo.
abstract interface class PermissionService {
  /// Consulta el estado actual SIN mostrar el diálogo nativo al usuario.
  Future<AppPermissionStatus> checkPermission(AppPermission permission);

  /// Solicita el permiso al usuario. Si ya fue concedido, la mayoría de
  /// plataformas retorna el estado actual sin volver a preguntar.
  Future<AppPermissionStatus> requestPermission(AppPermission permission);
}
