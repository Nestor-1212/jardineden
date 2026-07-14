// ─────────────────────────────────────────────────────────────────────────────
// core/file/file_service.dart
//
// RESPONSABILIDAD:
//   Abstrae el sistema de archivos: operaciones de bajo nivel sobre archivos
//   y directorios, más la resolución de los directorios estándar de la app.
//
// DIFERENCIA CON OTROS SERVICIOS DE PERSISTENCIA:
//   StorageService  → pares clave-valor pequeños (settings).
//   CacheService    → datos efímeros en memoria con expiración.
//   FileService     → archivos reales en disco: blobs grandes, assets
//                     descargados, y la base para BackupService (que ya
//                     usa dart:io directamente hoy; queda documentado como
//                     candidato a migrar a FileService en un futuro Sprint
//                     de refactor, sin urgencia — no es lógica de negocio).
//
// QUÉ NO VIVE AQUÍ:
//   Qué se descarga, de dónde, o cómo se verifica (eso es SecurityService
//   para el hash y una futura AssetService para la descarga en sí).
//
// DEPENDENCIAS PERMITIDAS:   dart:core, dart:typed_data.
// DEPENDENCIAS PROHIBIDAS:   features, shared/ui, Flutter widgets.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:typed_data';

/// Directorios estándar de la app, resueltos por plataforma.
enum AppDirectory {
  /// Datos persistentes del usuario (documentos, DB, backups).
  documents,

  /// Cache que el SO puede borrar bajo presión de espacio.
  cache,

  /// Archivos temporales — pueden desaparecer entre sesiones.
  temporary,

  /// Soporte de la app, no visible ni respaldada por el usuario (iOS:
  /// Application Support; Android: equivalente a documents).
  support,
}

/// Contrato del servicio de archivos.
abstract interface class FileService {
  /// Ruta absoluta del directorio [type] para esta plataforma.
  Future<String> resolveDirectoryPath(AppDirectory type);

  // ── Archivos ──────────────────────────────────────────────────────────────

  Future<bool> fileExists(String path);
  Future<int> fileSizeBytes(String path);
  Future<String> readAsString(String path);
  Future<Uint8List> readAsBytes(String path);
  Future<void> writeAsString(String path, String content);
  Future<void> writeAsBytes(String path, Uint8List bytes);

  /// Agrega [content] al final de [path] sin reescribir el archivo completo
  /// (crea el archivo si no existe). Pensado para logs append-only como
  /// AuditLogger — evita el costo O(tamaño del archivo) de leer + concatenar
  /// + volver a escribir en cada entrada.
  Future<void> appendAsString(String path, String content);
  Future<void> deleteFile(String path);
  Future<void> copyFile(String sourcePath, String destinationPath);
  Future<void> moveFile(String sourcePath, String destinationPath);

  // ── Directorios ───────────────────────────────────────────────────────────

  Future<bool> directoryExists(String path);
  Future<void> createDirectory(String path, {bool recursive = true});
  Future<void> deleteDirectory(String path, {bool recursive = true});

  /// Lista las rutas de los archivos directos dentro de [path] (no recursivo).
  Future<List<String>> listFiles(String path);

  /// Une segmentos de ruta de forma independiente de plataforma.
  String joinPath(List<String> segments);
}
