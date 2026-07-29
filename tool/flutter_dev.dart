import 'dart:io';

void main(List<String> args) async {
  stdout.writeln('Generating build information...');

  final generateResult = await Process.run(
    'dart',
    [
      'run',
      'tool/generate_build_info.dart',
    ],
  );

  stdout.write(generateResult.stdout);
  stderr.write(generateResult.stderr);

  if (generateResult.exitCode != 0) {
    exit(generateResult.exitCode);
  }

  stdout.writeln('Starting Flutter...');

final flutterArguments = [
  'run',
  ...args,
];

final flutterResult = await Process.start(
  'flutter',
  flutterArguments,
  mode: ProcessStartMode.inheritStdio,
);

  final exitCode = await flutterResult.exitCode;

  exit(exitCode);
}