"""Reject texture palette memory accesses in the native runtime and its retail build copies."""

import re
import sys
from pathlib import Path


def main():
    errors = []
    for root in map(Path, sys.argv[1:]):
        if not root.is_dir():
            errors.append(f"Missing native source directory: {root}")
            continue
        for path in root.rglob("*.cpp"):
            if "tests" in path.relative_to(root).parts:
                continue
            for number, line in enumerate(path.read_text(encoding="latin-1").splitlines(), 1):
                # Retained ABI fields may be cleared, but native code must never read a CLUT.
                line = re.sub(r"(?:->|\.)clut\s*=\s*(?:nullptr|NULL|0)\s*;", "", line)
                if re.search(r"(?:->|\.)clut\b|\.CBP\b|\.CPSM\b", line):
                    # The renderer's registry key also occupies CBP in the retained TEX0 ABI.
                    if path.name == "mg_texture.cpp" and "texture->tex0.CBP = entry.key;" in line:
                        continue
                    errors.append(f"{path}:{number}: {line.strip()}")
    if errors:
        sys.exit("Native palette access found:\n" + "\n".join(errors))


if __name__ == "__main__":
    main()
