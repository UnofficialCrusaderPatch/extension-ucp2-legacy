"""Package the installable module, excluding development and test files."""
import hashlib
from pathlib import Path
import re
from zipfile import ZipFile, ZIP_DEFLATED

root = Path(__file__).resolve().parents[1]
definition = (root/'definition.yml').read_text(encoding='utf-8')
assert re.search(r'^name: ucp2-legacy\s*$', definition, re.M)
version = re.search(r'^version: (\d+\.\d+\.\d+)\s*$', definition, re.M)[1]
files = [p for p in root.iterdir() if p.is_file() and p.suffix in ('.lua', '.yml', '.md')]
for folder in ('port', 'locale'):
    files.extend(p for p in (root/folder).rglob('*') if p.is_file() and p.suffix in ('.lua', '.yml'))
assert all(not p.is_symlink() and p.resolve().is_relative_to(root) for p in files)
destination = root/'dist'; destination.mkdir(exist_ok=True)
archive = destination/f'ucp2-legacy-{version}.zip'
with ZipFile(archive, 'w', ZIP_DEFLATED) as output:
    for path in sorted(files):
        output.write(path, path.relative_to(root).as_posix())
with ZipFile(archive) as output:
    assert output.testzip() is None
checksum = hashlib.sha256(archive.read_bytes()).hexdigest()
archive.with_suffix('.zip.sha256').write_text(f'{checksum}  {archive.name}\n', encoding='ascii')
print(archive)
