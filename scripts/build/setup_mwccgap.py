#!/usr/bin/env python3
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def apply_patch():
    module = ROOT / 'tools/mwccgap'
    patch = ROOT / 'scripts/build/patches/mwccgap-relocations.patch'
    if not (module / 'mwccgap.py').exists():
        raise RuntimeError('Initialize submodules before building')
    command = ['git', '-C', str(module), 'apply']
    result = subprocess.run(command + ['--reverse', '--check', str(patch)], capture_output=True)
    if result.returncode == 0:
        return
    subprocess.run(command + ['--check', str(patch)], check=True)
    subprocess.run(command + [str(patch)], check=True)


if __name__ == '__main__':
    apply_patch()
