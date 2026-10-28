#!/usr/bin/env python3
"""Package the static admin website for external hosting (no backend or secrets)."""
from pathlib import Path
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[1]
DESTINATION = ROOT / 'build' / 'admin-strato'
WEBSITE = DESTINATION / 'website'
FILES = ('index.html', 'styles.css', 'app.js', 'config.js')

WEBSITE.mkdir(parents=True, exist_ok=True)
# Only replace our named artifacts; do not remove unrelated files.
for name in FILES:
    shutil.copy2(ROOT / 'admin-web' / name, WEBSITE / name)
shutil.copy2(ROOT / 'docs' / 'admin-strato-install.md', DESTINATION / 'INSTALLATIE.md')
archive = ROOT / 'build' / 'admin-strato-upload.zip'
with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as output:
    for name in FILES:
        output.write(WEBSITE / name, arcname=name)
with zipfile.ZipFile(archive) as output:
    assert set(output.namelist()) == set(FILES)
    assert output.testzip() is None
print(f'Upload folder: {WEBSITE}')
print(f'Upload archive: {archive}')
print(f'Instructions: {DESTINATION / "INSTALLATIE.md"}')
