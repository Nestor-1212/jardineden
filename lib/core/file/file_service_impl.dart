// ─────────────────────────────────────────────────────────────────────────────
// core/file/file_service_impl.dart
//
// RESPONSABILIDAD:
//   Implementación de FileService sobre dart:io + path_provider.
//
// DEPENDENCIAS PERMITIDAS:   dart:io, dart:typed_data, path_provider, path,
//                            core/file/file_service.dart (contrato)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';
import 'dart:typed_data';

import 'package:jardindeleden/core/file/file_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Implementación de [FileService] sobre dart:io y path_provider.
final class FileServiceImpl implements FileService {
  const FileServiceImpl();

  @override
  Future<String> resolveDirectoryPath(AppDirectory type) async {
    final directory = switch (type) {
      AppDirectory.documents => await getApplicationDocumentsDirectory(),
      AppDirectory.cache => await getTemporaryDirectory(),
      AppDirectory.temporary => await getTemporaryDirectory(),
      AppDirectory.support => await getApplicationSupportDirectory(),
    };
    return directory.path;
  }

  @override
  Future<bool> fileExists(String path) async => File(path).exists();

  @override
  Future<int> fileSizeBytes(String path) => File(path).length();

  @override
  Future<String> readAsString(String path) => File(path).readAsString();

  @override
  Future<Uint8List> readAsBytes(String path) => File(path).readAsBytes();

  @override
  Future<void> writeAsString(String path, String content) async {
    await File(path).parent.create(recursive: true);
    await File(path).writeAsString(content);
  }

  @override
  Future<void> appendAsString(String path, String content) async {
    await File(path).parent.create(recursive: true);
    await File(path).writeAsString(content, mode: FileMode.append);
  }

  @override
  Future<void> writeAsBytes(String path, Uint8List bytes) async {
    await File(path).parent.create(recursive: true);
    await File(path).writeAsBytes(bytes);
  }

  @override
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> copyFile(String sourcePath, String destinationPath) async {
    await File(destinationPath).parent.create(recursive: true);
    await File(sourcePath).copy(destinationPath);
  }

  @override
  Future<void> moveFile(String sourcePath, String destinationPath) async {
    await File(destinationPath).parent.create(recursive: true);
    try {
      await File(sourcePath).rename(destinationPath);
    } on FileSystemException {
      // rename() falla si origen y destino están en particiones/volúmenes
      // distintos (común entre cache y documents en algunos dispositivos).
      // Se hace fallback a copiar + borrar el original.
      await File(sourcePath).copy(destinationPath);
      await File(sourcePath).delete();
    }
  }

  @override
  Future<bool> directoryExists(String path) async => Directory(path).exists();

  @override
  Future<void> createDirectory(String path, {bool recursive = true}) =>
      Directory(path).create(recursive: recursive).then((_) {});

  @override
  Future<void> deleteDirectory(String path, {bool recursive = true}) async {
    final directory = Directory(path);
    if (await directory.exists()) {
      await directory.delete(recursive: recursive);
    }
  }

  @override
  Future<List<String>> listFiles(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) return const [];

    return directory
        .list()
        .where((entity) => entity is File)
        .map((entity) => entity.path)
        .toList();
  }

  @override
  String joinPath(List<String> segments) => p.joinAll(segments);
}
