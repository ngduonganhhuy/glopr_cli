import 'dart:io';

import 'package:ansi_styles/ansi_styles.dart';
import 'package:yaml/yaml.dart';

Future<void> showVersion() async {
  final version = await getVersion();
  print('${AnsiStyles.blue('glopr_cli')} version ${AnsiStyles.bold(version)}');
}

void showHelp() {
  print('''
${AnsiStyles.green('Holmes CLI')}
Create a Flutter project from your custom template

Usage:
  glopr create <project_name> [-o com.example.org]
  glopr -v | --version
  glopr -h | --help
  glopr doctor

Options:
  -o, --org       Set the bundleId (eg: com.example.app)
  -v, --version   Show CLI version
  -h, --help      Show this help message

Commands:
  create          Generate a new Flutter project based on template
  doctor          Check system requirements
''');
}

void runDoctor() {
  print(AnsiStyles.yellow('🔍 Running doctor...'));

  final flutter = Process.runSync('flutter', ['--version']);
  print(AnsiStyles.cyan('Flutter:'));
  print(flutter.stdout);

  final dart = Process.runSync('dart', ['--version']);
  print(AnsiStyles.cyan('Dart:'));
  print(dart.stderr); // Dart writes version to stderr

  print(AnsiStyles.green('✅ Environment check complete.'));
}

Future<String> getVersion() async {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return 'unknown';

  final content = await file.readAsString();
  final yaml = loadYaml(content);

  return yaml['version']?.toString() ?? 'unknown';
}
