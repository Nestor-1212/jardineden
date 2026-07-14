// ─────────────────────────────────────────────────────────────────────────────
// test/core/game_engine/game_engine_dependency_rules_test.dart
//
// RESPONSABILIDAD:
//   Verifica mecánicamente el sistema de dependencias documentado en
//   lib/core/game_engine/game_engine_dependency_rules.dart — no es un test
//   sobre lógica de juego (no hay ninguna todavía), es un test de
//   ARQUITECTURA: analiza los imports reales de cada archivo de
//   core/game_engine/ y falla si alguno viola la Regla de Capas.
//
// POR QUÉ LEE ARCHIVOS CON dart:io EN VEZ DE package:analyzer:
//   analyzer permitiría un análisis semántico completo, pero agregarlo
//   como dependencia solo para extraer líneas `import '...'` es
//   desproporcionado — game_engine_charter.dart (sección 10) prohíbe
//   agregar dependencias nuevas sin una necesidad concreta, y una
//   expresión regular sobre el texto del archivo es suficiente para lo
//   que este test verifica (qué se importa, no cómo se usa).
//
// QUÉ NO VERIFICA:
//   Nada sobre el CONTENIDO de los contratos (eso son los tests
//   unitarios/widget que se agreguen cuando exista lógica real) — solo la
//   forma del grafo de imports.
//
// DEPENDENCIAS PERMITIDAS:   dart:io, flutter_test.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _engineRoot = 'lib/core/game_engine';
const _packagePrefix = 'package:jardindeleden/';
const _enginePackagePrefix = '${_packagePrefix}core/game_engine/';

const _prohibitedSubstrings = [
  'package:jardindeleden/features/',
  'package:flutter_riverpod',
  'package:flutter/material.dart',
  'package:flutter/cupertino.dart',
  'package:go_router',
];

/// Extrae las rutas de import (`import 'x';` o `export 'x';`) de un
/// archivo, ignorando comentarios de línea (`//`).
List<String> _importsOf(File file) {
  final content = file.readAsStringSync();
  final pattern = RegExp(
    '''^\\s*(?:import|export)\\s+['"]([^'"]+)['"]''',
    multiLine: true,
  );
  return pattern.allMatches(content).map((m) => m.group(1)!).toList();
}

/// Convierte un import `package:jardindeleden/core/game_engine/x/y.dart`
/// en la ruta relativa al proyecto `lib/core/game_engine/x/y.dart`, o
/// `null` si el import no apunta dentro del motor (es externo).
String? _internalPathOf(String importPath) {
  if (!importPath.startsWith(_enginePackagePrefix)) return null;
  return 'lib/${importPath.substring(_packagePrefix.length)}';
}

/// `true` si [path] es un archivo de Capa 0/1 (vive en una subcarpeta de
/// game_engine/), `false` si es de Capa Raíz (vive directo en
/// game_engine/).
bool _isSubfolderFile(String path) {
  final relative = path.substring('$_engineRoot/'.length);
  return relative.contains('/');
}

/// Nombre de la subcarpeta de un archivo de Capa 0/1 (p. ej. 'entities'
/// para 'lib/core/game_engine/entities/game_entity.dart').
String _subfolderOf(String path) {
  final relative = path.substring('$_engineRoot/'.length);
  return relative.split('/').first;
}

void main() {
  final engineDir = Directory(_engineRoot);
  final dartFiles =
      engineDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.replaceAll(r'\', '/').endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final normalizedPaths = {
    for (final f in dartFiles) f: f.path.replaceAll(r'\', '/'),
  };

  group('Genesis Engine — sistema oficial de dependencias', () {
    test('el motor tiene al menos los archivos esperados', () {
      expect(dartFiles, isNotEmpty);
    }, tags: ['unit']);

    test(
      'ningún archivo importa lib/features/, Riverpod, Flutter UI ni go_router',
      () {
        final violations = <String>[];
        for (final file in dartFiles) {
          final path = normalizedPaths[file]!;
          for (final import in _importsOf(file)) {
            for (final prohibited in _prohibitedSubstrings) {
              if (import.startsWith(prohibited)) {
                violations.add('$path → $import');
              }
            }
          }
        }
        expect(
          violations,
          isEmpty,
          reason: 'Imports prohibidos encontrados:\n${violations.join('\n')}',
        );
      },
      tags: ['unit'],
    );

    test(
      'ningún archivo importa la Capa Raíz (game_engine_contract.dart)',
      () {
        const rootContract = '$_engineRoot/game_engine_contract.dart';
        final violations = <String>[];
        for (final file in dartFiles) {
          final path = normalizedPaths[file]!;
          if (path == rootContract) continue;
          for (final import in _importsOf(file)) {
            final internal = _internalPathOf(import);
            if (internal == rootContract) {
              violations.add(path);
            }
          }
        }
        expect(
          violations,
          isEmpty,
          reason:
              'Estos archivos importan la Capa Raíz, invirtiendo la '
              'dirección permitida del grafo:\n${violations.join('\n')}',
        );
      },
      tags: ['unit'],
    );

    test(
      'ningún archivo de una subcarpeta importa de OTRA subcarpeta',
      () {
        final violations = <String>[];
        for (final file in dartFiles) {
          final path = normalizedPaths[file]!;
          if (!_isSubfolderFile(path)) continue; // el archivo raíz sí puede.
          final ownFolder = _subfolderOf(path);
          for (final import in _importsOf(file)) {
            final internal = _internalPathOf(import);
            if (internal == null || !_isSubfolderFile(internal)) continue;
            final importedFolder = _subfolderOf(internal);
            if (importedFolder != ownFolder) {
              violations.add(
                '$path (carpeta $ownFolder) → $internal (carpeta $importedFolder)',
              );
            }
          }
        }
        expect(
          violations,
          isEmpty,
          reason:
              'Composición cruzada entre subcarpetas — debe resolverla '
              'la Capa Raíz, no una Capa 1 hablando con otra directamente:\n'
              '${violations.join('\n')}',
        );
      },
      tags: ['unit'],
    );

    test('el grafo de imports internos es acíclico', () {
      final graph = <String, List<String>>{};
      for (final file in dartFiles) {
        final path = normalizedPaths[file]!;
        graph[path] = [
          for (final import in _importsOf(file))
            if (_internalPathOf(import) != null) _internalPathOf(import)!,
        ];
      }

      final visiting = <String>{};
      final visited = <String>{};
      final cycle = <String>[];

      bool hasCycle(String node) {
        if (visited.contains(node)) return false;
        if (visiting.contains(node)) {
          cycle.add(node);
          return true;
        }
        visiting.add(node);
        for (final neighbor in graph[node] ?? const <String>[]) {
          if (hasCycle(neighbor)) {
            cycle.add(node);
            return true;
          }
        }
        visiting.remove(node);
        visited.add(node);
        return false;
      }

      var foundCycle = false;
      for (final node in graph.keys) {
        if (hasCycle(node)) {
          foundCycle = true;
          break;
        }
      }

      expect(
        foundCycle,
        isFalse,
        reason: 'Ciclo de imports detectado: ${cycle.reversed.join(' → ')}',
      );
    }, tags: ['unit']);
  });
}
