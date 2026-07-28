import 'dart:io';

String runGitCommand(List<String> args) {
  final result = Process.runSync(
    'git',
    args,
  );

  if (result.exitCode == 0) {
    return result.stdout.toString().trim();
  }

  return 'unknown';
}

String readVersion() {
  final pubspec = File('pubspec.yaml');

  if (!pubspec.existsSync()) {
    return 'unknown';
  }

  final lines = pubspec.readAsLinesSync();

  for (final line in lines) {
    if (line.startsWith('version:')) {
      return line.replaceFirst('version:', '').trim();
    }
  }

  return 'unknown';
}

void main() {
  final now = DateTime.now().toIso8601String();

  final version = readVersion();
  final branch = runGitCommand([
    'branch',
    '--show-current',
  ]);

  final commit = runGitCommand([
    'rev-parse',
    '--short',
    'HEAD',
  ]);

  final file = File(
    'lib/core/generated/build_info.dart',
  );

  file.parent.createSync(recursive: true);

  file.writeAsStringSync('''
// GENERATED FILE - DO NOT EDIT

class BuildInfo {
  static const String version = '$version';
  static const String buildDate = '$now';
  static const String gitBranch = '$branch';
  static const String gitCommit = '$commit';
}
''');

  stdout.writeln('Build info generated.');
}