#!/usr/bin/env python3
import io
import shutil
import tarfile
import tempfile
import urllib.request
from pathlib import Path
from ee_gcc import FUNCTION_COMPILERS

ROOT = Path(__file__).resolve().parents[2]


def download_archive(url):
    with urllib.request.urlopen(url) as response:
        return tarfile.open(fileobj=io.BytesIO(response.read()), mode='r:*')


def install_compiler(version):
    target = ROOT / 'tools/compilers' / version
    if (target / 'bin/ee-gcc').exists():
        return
    extension = 'tar.xz'
    url = 'https://github.com/decompme/compilers/releases/download/compilers/'
    url += version + '.' + extension
    print('Installing ' + version, flush=True)
    with download_archive(url) as archive:
        members = []
        roots = set()
        for member in archive.getmembers():
            if member.isfile():
                members.append(member)
                roots.add(Path(member.name).parts[0])
        strip_root = len(roots) == 1 and not roots.intersection(['bin', 'ee', 'lib'])
        target.mkdir(parents=True, exist_ok=True)
        for member in members:
            if strip_root:
                member.name = str(Path(*Path(member.name).parts[1:]))
            archive.extract(member, target, filter='data')
        for path in target.rglob('*'):
            if path.is_file():
                path.chmod(0o755)


def install_newlib():
    target = ROOT / 'tools/newlib/newlib-1_9_0'
    if (target / 'libc/include/reent.h').exists():
        return
    print('Installing newlib 1.9.0 headers', flush=True)
    url = 'https://github.com/mirror/newlib-cygwin/archive/refs/tags/newlib-1_9_0.tar.gz'
    with tempfile.TemporaryDirectory() as directory:
        with download_archive(url) as archive:
            archive.extractall(directory, filter='data')
        sources = list(Path(directory).glob('*/newlib'))
        if len(sources) != 1:
            raise ValueError('Expected one newlib source directory')
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(sources[0], target)


def main():
    config = ROOT / 'ps2/config/pal/gcc_units.txt'
    if not config.exists():
        return
    versions = set()
    for row in config.read_text().splitlines():
        fields = row.split()
        if fields:
            versions.add(fields[1])
    for functions in FUNCTION_COMPILERS.values():
        versions.update(functions.values())
    for version in sorted(versions):
        install_compiler(version)
    if versions:
        install_newlib()


if __name__ == '__main__':
    main()
