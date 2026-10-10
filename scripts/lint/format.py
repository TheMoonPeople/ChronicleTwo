import argparse
import os
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
ASSEMBLY = re.compile(r"^[ \t]*(?:static\s+)?asm\b[^{};]*\{", re.MULTILINE)
EXTENSIONS = {".c", ".cc", ".cpp", ".cxx", ".h", ".hh", ".hpp", ".hxx"}


def format_source(source, filename, formatter):
    blocks = []
    position = 0
    masked = ""
    for match in ASSEMBLY.finditer(source):
        end = source.index("}", match.end()) + 1
        if "{" in source[match.end():end]:
            raise ValueError(f"Nested assembly block in {filename}")
        marker = f"chronicletwo_format_assembly_{len(blocks)}"
        if marker in source:
            raise ValueError(f"Formatting marker already exists in {filename}")
        original = source[match.start():end]
        declaration = "" if re.search(r"\basm\s*\{", match.group()) else "void "
        masked += source[position:match.start()] + declaration + marker + "();"
        blocks.append((marker, original))
        position = end
    masked += source[position:]
    result = subprocess.run([formatter, f"--assume-filename={filename}"], input=masked, text=True, capture_output=True, check=True).stdout
    for marker, original in blocks:
        pattern = re.compile(r"^[ \t]*(?:void )?" + marker + r"\(\);", re.MULTILINE)
        matches = list(pattern.finditer(result))
        if len(matches) != 1:
            raise ValueError(f"Assembly marker changed in {filename}")
        match = matches[0]
        result = result[:match.start()] + original + result[match.end():]
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    formatter = os.environ.get("CLANG_FORMAT", "clang-format")
    files = subprocess.check_output(["git", "ls-files", "-z"], cwd=ROOT).decode().split("\0")
    changed = []
    count = 0
    for name in files:
        if Path(name).suffix not in EXTENSIONS:
            continue
        count += 1
        file = ROOT / name
        source = file.read_text()
        formatted = format_source(source, file, formatter)
        if source == formatted:
            continue
        changed.append(name)
        if not args.check:
            file.write_text(formatted)
    if args.check and changed:
        print("Formatting needed:\n" + "\n".join(changed))
        return 1
    print(f"Checked {count} C/C++ files; {len(changed)} formatted; assembly preserved.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
