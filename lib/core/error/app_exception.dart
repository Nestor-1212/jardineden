// ─────────────────────────────────────────────────────────────────────────────
// core/error/app_exception.dart
//
// RESPONSABILIDAD:
//   Define la jerarquía completa de excepciones del proyecto.
//   Todos los errores del sistema son subtipos de AppException.
//   Nunca se lanza un Exception genérico de Dart fuera de este archivo.
//
// REGLA CRÍTICA:
//   Los Casos de Uso NO lanzan excepciones. Retornan Result<T, AppException>.
//   Las excepciones solo se usan internamente en la capa de Datos para
//   capturar errores de infraestructura y convertirlos a Result.
//
// DEPENDENCIAS PERMITIDAS:   dart:core únicamente.
// DEPENDENCIAS PROHIBIDAS:   Flutter, Riverpod, Drift, features, shared.
//
// JERARQUÍA:
//   AppException (base)
//   ├── DatabaseException
//   │   ├── DatabaseReadException
//   │   ├── DatabaseWriteException
//   │   ├── DatabaseMigrationException
//   │   └── DatabaseCorruptionException
//   ├── AssetException
//   │   ├── AssetNotFoundException
//   │   ├── AssetIntegrityException
//   │   └── AssetDownloadException
//   ├── FileException
//   │   ├── FileNotFoundException
//   │   ├── FileReadException
//   │   ├── FileWriteException
//   │   └── FileDeleteException
//   ├── ValidationException
//   │   ├── InvalidFormatException
//   │   ├── RequiredFieldException
//   │   └── OutOfRangeException
//   ├── DomainException
//   │   ├── InsufficientCurrencyException
//   │   ├── ChapterLockedException
//   │   ├── InvalidProfileException
//   │   ├── SessionExpiredException
//   │   └── MaxProfilesReachedException
//   ├── SecurityException
//   │   ├── InvalidPinException
//   │   ├── EncryptionException
//   │   └── UnauthorizedAccessException
//   └── UnexpectedException
//       (catch-all para cualquier error no clasificado — ver ErrorHandler
//       en core/error/error_handler.dart. NUNCA debería usarse a propósito
//       desde código de features; es la red de seguridad del sistema.)
//
// CÓMO SE USA ESTA JERARQUÍA (ver core/error/error_handler.dart):
//   El código de infraestructura (data sources, servicios) puede lanzar
//   directamente el subtipo específico que conoce (ej: SecurityServiceImpl
//   lanza EncryptionException). Cualquier excepción NO reconocida que llegue
//   a ErrorHandler.guard() se clasifica automáticamente en el subtipo más
//   apropiado, o en UnexpectedException si no encaja en ninguno.
//
// IMPLEMENTA EN SPRINT:   Sprint del Módulo Core
// ─────────────────────────────────────────────────────────────────────────────

/// Clase base de todos los errores del proyecto Jardín del Edén.
///
/// Cada excepción tiene:
/// - [code]: identificador legible por máquina para logging y analytics.
/// - [message]: mensaje descriptivo para logs internos (NO para el usuario).
/// - [cause]: la excepción original que causó este error, si existe.
sealed class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.cause,
  });

  /// Identificador del error. Ejemplo: 'DATABASE_WRITE_FAILED'
  final String code;

  /// Descripción técnica. Nunca se muestra al usuario.
  final String message;

  /// La excepción de bajo nivel que provocó este error.
  final Object? cause;

  @override
  String toString() => 'AppException($code): $message';
}

// ── Errores de Base de Datos ─────────────────────────────────────────────────

/// Categoría de errores de operaciones de base de datos Drift/SQLite.
sealed class DatabaseException extends AppException {
  const DatabaseException({
    required super.code,
    required super.message,
    super.cause,
  });
}

/// Fallo al leer datos de la base de datos.
final class DatabaseReadException extends DatabaseException {
  const DatabaseReadException({required super.message, super.cause})
      : super(code: 'DATABASE_READ_FAILED');
}

/// Fallo al escribir datos en la base de datos.
final class DatabaseWriteException extends DatabaseException {
  const DatabaseWriteException({required super.message, super.cause})
      : super(code: 'DATABASE_WRITE_FAILED');
}

/// Fallo durante la ejecución de una migración de esquema.
final class DatabaseMigrationException extends DatabaseException {
  const DatabaseMigrationException({required super.message, super.cause})
      : super(code: 'DATABASE_MIGRATION_FAILED');
}

/// Base de datos corrupta o clave de cifrado incorrecta.
final class DatabaseCorruptionException extends DatabaseException {
  const DatabaseCorruptionException({required super.message, super.cause})
      : super(code: 'DATABASE_CORRUPTED');
}

// ── Errores de Assets ────────────────────────────────────────────────────────

/// Categoría de errores de gestión de assets de contenido.
sealed class AssetException extends AppException {
  const AssetException({
    required super.code,
    required super.message,
    super.cause,
  });
}

/// Asset no encontrado en el sistema de archivos local.
final class AssetNotFoundException extends AssetException {
  const AssetNotFoundException({required super.message, super.cause})
      : super(code: 'ASSET_NOT_FOUND');
}

/// Hash SHA-256 del asset no coincide con el registrado en la base de datos.
final class AssetIntegrityException extends AssetException {
  const AssetIntegrityException({required super.message, super.cause})
      : super(code: 'ASSET_INTEGRITY_FAILED');
}

/// Fallo al descargar un asset desde el CDN.
final class AssetDownloadException extends AssetException {
  const AssetDownloadException({required super.message, super.cause})
      : super(code: 'ASSET_DOWNLOAD_FAILED');
}

// ── Errores de Dominio (Reglas de Negocio) ───────────────────────────────────

/// Categoría de errores de reglas de negocio del juego.
sealed class DomainException extends AppException {
  const DomainException({
    required super.code,
    required super.message,
    super.cause,
  });
}

/// El jugador no tiene suficientes monedas para la transacción solicitada.
final class InsufficientCurrencyException extends DomainException {
  const InsufficientCurrencyException({required super.message})
      : super(code: 'INSUFFICIENT_CURRENCY');
}

/// El capítulo solicitado está bloqueado por el Muro de Sabiduría
/// o por no haber completado los capítulos anteriores.
final class ChapterLockedException extends DomainException {
  const ChapterLockedException({required super.message})
      : super(code: 'CHAPTER_LOCKED');
}

/// El perfil de jugador es inválido o no existe.
final class InvalidProfileException extends DomainException {
  const InvalidProfileException({required super.message})
      : super(code: 'INVALID_PROFILE');
}

/// La sesión activa expiró o fue invalidada.
final class SessionExpiredException extends DomainException {
  const SessionExpiredException({required super.message})
      : super(code: 'SESSION_EXPIRED');
}

/// Se alcanzó el límite máximo de perfiles por dispositivo.
final class MaxProfilesReachedException extends DomainException {
  const MaxProfilesReachedException({required super.message})
      : super(code: 'MAX_PROFILES_REACHED');
}

// ── Errores de Seguridad ─────────────────────────────────────────────────────

/// Categoría de errores relacionados con seguridad y acceso.
sealed class SecurityException extends AppException {
  const SecurityException({
    required super.code,
    required super.message,
    super.cause,
  });
}

/// PIN del Panel de Padres incorrecto.
final class InvalidPinException extends SecurityException {
  const InvalidPinException({required super.message})
      : super(code: 'INVALID_PIN');
}

/// Error en las operaciones de cifrado/descifrado de la base de datos.
final class EncryptionException extends SecurityException {
  const EncryptionException({required super.message, super.cause})
      : super(code: 'ENCRYPTION_FAILED');
}

/// Intento de acceder a una funcionalidad sin los permisos requeridos.
final class UnauthorizedAccessException extends SecurityException {
  const UnauthorizedAccessException({required super.message})
      : super(code: 'UNAUTHORIZED_ACCESS');
}

// ── Errores de Archivos ──────────────────────────────────────────────────────

/// Categoría de errores del sistema de archivos (ver core/file/FileService).
///
/// Distinta de [AssetException]: AssetException es sobre el CONTENIDO del
/// juego (versículos, imágenes de mundos) y su integridad. FileException es
/// sobre la OPERACIÓN de I/O en sí (el archivo no existe, no se pudo leer/
/// escribir/borrar) — aplica a backups, exports, y cualquier archivo que no
/// sea un asset de contenido.
sealed class FileException extends AppException {
  const FileException({
    required super.code,
    required super.message,
    super.cause,
  });
}

/// El archivo solicitado no existe en la ruta indicada.
final class FileNotFoundException extends FileException {
  const FileNotFoundException({required super.message, super.cause})
      : super(code: 'FILE_NOT_FOUND');
}

/// Fallo al leer un archivo (permisos, disco desmontado, archivo bloqueado).
final class FileReadException extends FileException {
  const FileReadException({required super.message, super.cause})
      : super(code: 'FILE_READ_FAILED');
}

/// Fallo al escribir un archivo (disco lleno, permisos, ruta inválida).
final class FileWriteException extends FileException {
  const FileWriteException({required super.message, super.cause})
      : super(code: 'FILE_WRITE_FAILED');
}

/// Fallo al eliminar un archivo o directorio.
final class FileDeleteException extends FileException {
  const FileDeleteException({required super.message, super.cause})
      : super(code: 'FILE_DELETE_FAILED');
}

// ── Errores de Validación ────────────────────────────────────────────────────

/// Categoría de errores de validación de FORMATO de datos de entrada.
///
/// Distinta de las reglas de negocio en [DomainException]: ValidationException
/// es sobre la FORMA del dato (¿es un email válido? ¿está en el rango
/// permitido?), no sobre si la operación tiene sentido en el juego. Ver
/// core/validation/ValidationService para los checks que alimentan estas
/// excepciones cuando se lanzan explícitamente.
sealed class ValidationException extends AppException {
  const ValidationException({
    required super.code,
    required super.message,
    super.cause,
  });
}

/// El valor no tiene el formato esperado (email, UUID, color hex, etc.).
final class InvalidFormatException extends ValidationException {
  const InvalidFormatException({required super.message})
      : super(code: 'INVALID_FORMAT');
}

/// Un campo requerido llegó vacío o nulo.
final class RequiredFieldException extends ValidationException {
  const RequiredFieldException({required super.message})
      : super(code: 'REQUIRED_FIELD_MISSING');
}

/// Un valor numérico o de longitud está fuera del rango permitido.
final class OutOfRangeException extends ValidationException {
  const OutOfRangeException({required super.message})
      : super(code: 'OUT_OF_RANGE');
}

// ── Errores Inesperados ───────────────────────────────────────────────────────

/// Cualquier error que ErrorHandler.classify() no pudo ubicar en ninguna
/// categoría anterior. Es la red de seguridad final: garantiza que SIEMPRE
/// hay un AppException que representar y loguear, nunca una excepción cruda
/// sin clasificar propagándose por la app.
///
/// Si este tipo aparece con frecuencia en los logs de producción, es una
/// señal de que falta una categoría específica en esta jerarquía — no de
/// que el error en sí sea aceptable.
final class UnexpectedException extends AppException {
  const UnexpectedException({required super.message, super.cause})
      : super(code: 'UNEXPECTED_ERROR');
}
