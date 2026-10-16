import { existsSync } from 'node:fs';
import { delimiter, join } from 'node:path';
import { spawnSync } from 'node:child_process';

function canRunJava(environment) {
  return spawnSync('java', ['-version'], {
    env: environment,
    stdio: 'ignore',
  }).status === 0;
}

function environmentWithJava() {
  const environment = { ...process.env };

  if (canRunJava(environment)) {
    return environment;
  }

  const candidates = [
    '/opt/homebrew/opt/openjdk@21',
    '/usr/local/opt/openjdk@21',
  ];

  for (const javaHome of candidates) {
    const javaBinary = join(javaHome, 'bin', 'java');
    if (existsSync(javaBinary)) {
      environment.JAVA_HOME = javaHome;
      environment.PATH = `${join(javaHome, 'bin')}${delimiter}${environment.PATH ?? ''}`;
      return environment;
    }
  }

  throw new Error(
    'Java 21 or newer is required for the Firestore emulator. ' +
      'Install a JDK and make the java command available on PATH.',
  );
}

const firebaseArguments = [
  'emulators:exec',
  '--project',
  'demo-flutter-firebase-boilerplate',
  '--only',
  'firestore',
  'node --test firestore.rules.test.js',
];

const result = spawnSync('firebase', firebaseArguments, {
  cwd: new URL('.', import.meta.url),
  env: environmentWithJava(),
  stdio: 'inherit',
  shell: process.platform === 'win32',
});

if (result.error) {
  throw result.error;
}

process.exit(result.status ?? 1);
