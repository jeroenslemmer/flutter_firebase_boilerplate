import {spawn, spawnSync} from 'node:child_process';
import {createServer} from 'node:http';
import {createServer as createTcpServer} from 'node:net';
import {readFile, access} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import {join, dirname} from 'node:path';

const root = dirname(fileURLToPath(import.meta.url));
const project = 'demo-flutter-firebase-boilerplate';
const windows = process.platform === 'win32';
const environment = {...process.env, GCLOUD_PROJECT: project, GOOGLE_CLOUD_PROJECT: project,
  FIREBASE_AUTH_EMULATOR_HOST: '127.0.0.1:9099', FIRESTORE_EMULATOR_HOST: '127.0.0.1:8080',
  FIREBASE_CLI_DISABLE_UPDATE_CHECK: 'true'};
// Never pass production credentials or a production Firebase config into the demo.
for (const key of ['GOOGLE_APPLICATION_CREDENTIALS', 'FIREBASE_TOKEN', 'FIREBASE_CONFIG']) delete environment[key];
let emulator, server, closing = false;

function command(file, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(file, args, {cwd: root, env: environment, stdio: 'inherit', ...options});
    child.once('error', reject);
    child.once('exit', code => code === 0 ? resolve() : reject(new Error(`${file} stopte met code ${code}.`)));
  });
}
async function available(port) {
  await new Promise((resolve, reject) => {
    const probe = createTcpServer();
    probe.once('error', () => reject(new Error(`Poort ${port} is bezet. Stop andere Firebase-emulators of lokale testservers.`)));
    probe.listen(port, '127.0.0.1', () => probe.close(resolve));
  });
}
async function stop() {
  if (closing) return;
  closing = true;
  server?.close();
  if (emulator?.pid && emulator.exitCode === null) {
    if (windows) {
      await new Promise(resolve => {
        const task = spawn('taskkill', ['/pid', String(emulator.pid), '/T', '/F'], {stdio: 'ignore'});
        task.once('error', resolve); task.once('exit', resolve);
      });
    } else {
      emulator.kill('SIGINT');
      await new Promise(resolve => emulator.once('exit', resolve));
    }
  }
}
process.once('SIGINT', () => {stop().then(() => process.exit(0));});
process.once('SIGTERM', () => {stop().then(() => process.exit(0));});

try {
  if (Number(process.versions.node.split('.')[0]) !== 22) throw new Error('Installeer Node.js 22 (zie LEESMIJ.md).');
  const java = spawnSync('java', ['-version'], {encoding: 'utf8'});
  const javaVersion = `${java.stderr ?? ''} ${java.stdout ?? ''}`.match(/version\s+"(\d+)/)?.[1];
  if (java.status !== 0 || Number(javaVersion ?? 0) < 21) throw new Error('Java 21 of hoger ontbreekt op PATH. Zie LEESMIJ.md.');
  for (const port of [8787, 9099, 8080, 5001, 4400, 4500, 9150]) await available(port);
  for (const folder of ['functions', 'firebase-tests']) {
    try {await access(join(root, folder, 'node_modules', folder === 'functions' ? 'firebase-admin' : 'firebase-tools', 'package.json'));}
    catch {
      console.log(`Eenmalig dependencies installeren voor ${folder} (internet nodig)...`);
      // cmd.exe resolves npm.cmd. All arguments are fixed; no user input enters the shell.
      await command(windows ? 'cmd.exe' : 'npm', windows ? ['/d', '/s', '/c', `npm ci --prefix ${folder} --no-audit --no-fund`] : ['ci', '--prefix', folder, '--no-audit', '--no-fund']);
    }
  }
  console.log('\nLokale Firebase-emulators starten. De eerste keer kunnen downloads nodig zijn.');
  emulator = spawn(process.execPath, [join(root, 'firebase-tests/node_modules/firebase-tools/lib/bin/firebase.js'),
    'emulators:start', '--config', 'firebase.local.json', '--project', project, '--only', 'auth,firestore,functions'],
    {cwd: root, env: environment, stdio: 'inherit'});
  let startupError;
  emulator.once('error', error => {startupError = error;});
  emulator.once('exit', code => {
    if (!closing) {console.error(`Firebase is gestopt (code ${code}).`); server?.close(); process.exitCode = 1;}
  });
  const deadline = Date.now() + 240_000;
  while (true) {
    if (startupError) throw startupError;
    if (emulator.exitCode !== null) throw new Error('Firebase kon niet starten. Zie de melding hierboven.');
    try {
      const response = await fetch(`http://127.0.0.1:5001/${project}/europe-west1/adminSession`, {
        method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{"data":{}}', signal: AbortSignal.timeout(2000)});
      const body = await response.json();
      if (response.status === 401 && body.error?.status === 'UNAUTHENTICATED') break;
    } catch { /* Readiness is checked until the deadline. */ }
    if (Date.now() > deadline) throw new Error('Firebase is na vier minuten nog niet klaar. Controleer de uitvoer en internetverbinding.');
    await new Promise(resolve => setTimeout(resolve, 1000));
  }
  await command(process.execPath, ['functions/scripts/seed-demo.js']);
  const types = {'/index.html': 'text/html; charset=utf-8', '/app.js': 'text/javascript; charset=utf-8',
    '/config.js': 'text/javascript; charset=utf-8', '/styles.css': 'text/css; charset=utf-8'};
  server = createServer(async (request, response) => {
    const url = new URL(request.url, 'http://127.0.0.1:8787');
    if (!['GET', 'HEAD'].includes(request.method)) {response.writeHead(405); response.end(); return;}
    if ((url.pathname === '/' || url.pathname === '/index.html') && url.searchParams.get('emulator') !== '1') {
      response.writeHead(302, {Location: '/?emulator=1'}); response.end(); return;
    }
    const path = url.pathname === '/' ? '/index.html' : url.pathname;
    if (!types[path]) {response.writeHead(404); response.end(); return;}
    try {
      const content = await readFile(join(root, 'admin-web', path.slice(1)));
      response.writeHead(200, {'Content-Type': types[path], 'Cache-Control': 'no-store', 'X-Content-Type-Options': 'nosniff'});
      response.end(request.method === 'HEAD' ? undefined : content);
    } catch {response.writeHead(500); response.end('Bestand ontbreekt. Pak het volledige pakket opnieuw uit.');}
  });
  await new Promise((resolve, reject) => {server.once('error', reject); server.listen(8787, '127.0.0.1', resolve);});
  const url = 'http://127.0.0.1:8787/?emulator=1';
  console.log(`\nKLAAR: ${url}\nAdmin: admin@example.com\nGebruikersbeheerder: manager@example.com\nWachtwoord: Test-password-42!\n\nLaat dit venster open. Stop met Ctrl+C.\n`);
  if (windows) spawn('cmd.exe', ['/d', '/c', 'start', '', url], {stdio: 'ignore'}).on('error', () => {});
} catch (error) {
  console.error(`\n${error.message}`);
  await stop(); process.exitCode = 1;
}
