#!/usr/bin/env python3
"""Build a self-contained-source Windows demo bundle, without production config."""
from pathlib import Path
import json
import zipfile

ROOT = Path(__file__).resolve().parents[1]
DESTINATION = ROOT / 'build' / 'admin-windows-test'
PROJECT = 'demo-flutter-firebase-boilerplate'
FILES = {
    'start.cmd': 'tool/windows-admin-test/start.cmd',
    'start.mjs': 'tool/windows-admin-test/start.mjs',
    'LEESMIJ.md': 'docs/admin-windows-test.md',
    'firestore.rules': 'firestore.rules',
    **{f'admin-web/{name}': f'admin-web/{name}' for name in ('index.html', 'app.js', 'styles.css')},
    **{f'functions/{name}': f'functions/{name}' for name in (
        'index.js', 'policy.js', 'package.json', 'package-lock.json', 'scripts/seed-demo.js')},
    **{f'firebase-tests/{name}': f'firebase-tests/{name}' for name in ('package.json', 'package-lock.json')},
}
contents = {target: (ROOT / source).read_bytes() for target, source in FILES.items()}
contents['admin-web/config.js'] = (
    f"export const firebaseConfig = {{projectId: '{PROJECT}', apiKey: 'demo-api-key', "
    "appId: '1:123456789:web:demo', authDomain: 'localhost'};\n"
    "export const region = 'europe-west1';\n").encode()
config = {
    'functions': [{'source': 'functions', 'codebase': 'admin'}],
    'firestore': {'rules': 'firestore.rules'},
    'emulators': {
        'auth': {'host': '127.0.0.1', 'port': 9099},
        'firestore': {'host': '127.0.0.1', 'port': 8080},
        'functions': {'host': '127.0.0.1', 'port': 5001},
        'hub': {'host': '127.0.0.1', 'port': 4400},
        'logging': {'host': '127.0.0.1', 'port': 4500},
        'ui': {'enabled': False}, 'singleProjectMode': True,
    },
}
contents['firebase.local.json'] = (json.dumps(config, indent=2) + '\n').encode()
archive = ROOT / 'build' / 'admin-windows-test.zip'
DESTINATION.mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as output:
    for name, content in contents.items():
        target = DESTINATION / name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content)
        output.writestr(name, content)
with zipfile.ZipFile(archive) as output:
    assert output.testzip() is None
    assert set(output.namelist()) == set(contents)
    for name in output.namelist():
        assert 'node_modules' not in name and not name.endswith('.firebaserc')
        assert b'base-app-f5a6e' not in output.read(name), f'Production project reference: {name}'
print(f'Windows ZIP: {archive}')
print(f'Extracted test folder: {DESTINATION}')
