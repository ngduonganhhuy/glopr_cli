import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../bin/holmes_cli.dart' show copyAndReplace;

void main() {
  const executable = 'dart';
  const cliPath = 'bin/holmes_cli.dart';

  group('CLI core commands', () {
    test('--version prints version', () async {
      final result =
          await Process.run(executable, ['run', cliPath, '--version']);
      expect(result.stdout.toString(), contains('holmes_cli version'));
    });

    test('--help prints usage', () async {
      final result = await Process.run(executable, ['run', cliPath, '--help']);
      expect(result.stdout.toString(), contains('Holmes CLI'));
      expect(result.stdout.toString(), contains('Usage:'));
    });

    test('doctor runs and shows flutter/dart versions', () async {
      final result = await Process.run(executable, ['run', cliPath, 'doctor']);
      expect(result.stdout.toString(), contains('Flutter:'));
      expect(result.stdout.toString(), contains('Dart:'));
    });
  });

  group('create command', () {
    late Directory tempDir;
    late Directory templateDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('starter_test_');
      templateDir = Directory(p.join(tempDir.path, 'template'));
      await templateDir.create(recursive: true);

      await File(p.join(templateDir.path, 'pubspec.yaml')).writeAsString('''
name: __project_name__
description: __description__
''');
      await File(p.join(templateDir.path, 'README.md')).writeAsString('''
# __app_name__

__description__
''');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('create replaces placeholders correctly', () async {
      final targetDir = Directory(p.join(tempDir.path, 'my_app'));
      final bundleId = 'com.test.my_app';

      // Simulate calling copyAndReplace directly
      final cliFile =
          File(p.join(Directory.current.path, 'bin', 'holmes_cli.dart'));
      expect(cliFile.existsSync(), isTrue,
          reason: 'Missing bin/holmes_cli.dart');

      // Load main copyAndReplace from lib if you’ve refactored, otherwise just test copy manually
      final replacements = {
        '__project_name__': 'my_app',
        '__app_name__': 'My App',
        '__description__': 'Test app description',
        '__bundle_id__': bundleId,
      };

      // Manually copy for test
      await copyAndReplace(templateDir, targetDir, replacements);

      final pubspec = File(p.join(targetDir.path, 'pubspec.yaml'));
      final pubspecContent = await pubspec.readAsString();

      expect(pubspecContent, contains('name: my_app'));
      expect(pubspecContent, contains('description: Test app description'));

      final readme = File(p.join(targetDir.path, 'README.md'));
      final readmeContent = await readme.readAsString();

      expect(readmeContent, contains('# My App'));
      expect(readmeContent, contains('Test app description'));
    });
  });
}
