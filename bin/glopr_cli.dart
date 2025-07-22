import 'dart:io';

import 'package:args/args.dart';
import 'package:glopr_cli/glopr_cli.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('version', abbr: 'v', help: 'Show version', negatable: false)
    ..addFlag('help', abbr: 'h', help: 'Show help', negatable: false)
    ..addOption('org', abbr: 'o', help: 'Set bundle id')
    ..addCommand('create')
    ..addCommand('doctor');

  final parsed = parser.parse(args);

  if (parsed['help'] == true) {
    showHelp();
    exit(0);
  }

  if (parsed['version'] == true) {
    await showVersion();
    exit(0);
  }

  if (parsed.command?.name == 'doctor') {
    runDoctor();
    exit(0);
  }

  if (parsed.command?.name == 'create') {
    final command = parsed.command!;
    if (command.arguments.isEmpty) {
      print('❗ Missing project path. Use: glopr create <project-path>');
      exit(1);
    }
    final rawPath = command.arguments[0];
    final absolutePath = Directory(rawPath).absolute.path;
    final target = Directory(absolutePath);
    final projectName = p.basename(absolutePath);
    final bundleId = parsed['org'] ?? 'com.glopr.starter';

    stdout.write('📝 App display name: ');
    final appName = stdin.readLineSync() ?? projectName;

    stdout.write('📝 App description: ');
    final description =
        stdin.readLineSync() ?? 'A new Flutter app named $projectName';

    final current = Directory.current;
    final template = Directory(p.join(current.path, 'template'));

    if (!template.existsSync()) {
      print('❌ Template not found.');
      exit(1);
    }

    if (target.existsSync()) {
      print('❗ Project "$projectName" already exists.');
      exit(1);
    }
    print('🚀 Generating project "$projectName"...');
    await copyAndReplace(template, target, {
      '__project_name__': projectName,
      '__app_name__': appName,
      '__description__': description,
      '__bundle_id__': bundleId,
    });

    print('🚧 Create command still runs here...');
    exit(0);
  }

  // Default fallback
  showHelp();
}

Future<void> copyAndReplace(
  Directory src,
  Directory dest,
  Map<String, String> replacements,
) async {
  final textExtensions = {
    '.dart',
    '.yaml',
    '.yml',
    '.json',
    '.xml',
    '.html',
    '.md',
    '.txt',
    '.gitignore',
    '.gradle',
    '.java',
    '.kt',
    '.plist'
  };

  await for (var entity in src.list(recursive: true)) {
    final relativePath = p.relative(entity.path, from: src.path);

    // Thay thế placeholder trong tên file/thư mục
    String newPath = p.join(dest.path, relativePath);
    replacements.forEach((key, value) {
      newPath = newPath.replaceAll(key, value);
    });

    if (entity is Directory) {
      await Directory(newPath).create(recursive: true);
    } else if (entity is File) {
      final ext = p.extension(entity.path).toLowerCase();
      final isText = textExtensions.contains(ext);

      try {
        final newFile = File(newPath);
        await newFile.create(recursive: true);

        if (isText) {
          var content = await entity.readAsString();
          replacements.forEach((key, value) {
            content = content.replaceAll(key, value);
          });
          await newFile.writeAsString(content);
          print('📄 Copied text:  ${p.relative(newPath, from: dest.path)}');
        } else {
          final bytes = await entity.readAsBytes();
          await newFile.writeAsBytes(bytes);
          print('🖼️  Copied binary: ${p.relative(newPath, from: dest.path)}');
        }
      } catch (e) {
        print('❌ Failed to copy file: ${entity.path}');
        print('   Error: $e');
      }
    }
  }
}
