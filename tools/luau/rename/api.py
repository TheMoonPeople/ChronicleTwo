#!/usr/bin/env python3
"""Renames engine command calls in the game's Luau files after their names change in tools/luau/commands.json.

Each command is matched across two catalogs by kind and retail handler, so `event.CharaActive_2` becomes the new name
with the same variant and arity suffixes. Files are rewritten only where a namespace-qualified command name occurs.

    rename/api.py --old <catalog> [--check]

--old names the catalog the files were written against (for example `git show HEAD:tools/luau/commands.json`). With
--check nothing is written: each file must map back to its original text through the inverse renames, so the rename is
known to change nothing but command names.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[3]
CATALOG = REPO / "tools" / "luau" / "commands.json"
# Every file that calls engine commands by name. The declarations under port/src/luau/api are regenerated instead.
ROOTS = ("port/src/luau", "port/src/tests")
SUFFIXES = ("luau", "cpp")
EXCLUDED = ("port/src/luau/api/",)
OLD_EXT, NEW_EXT = "Ext", "call_command"
OLD_VARIANTS = {"s32": "Int", "f32": "Float"}
NEW_VARIANTS = {"s32": "_int", "f32": "_float"}


def renames(old: dict, new: dict) -> dict[str, dict[str, str]]:
    """Per namespace, each old command name with its variant suffix to the new one; arity suffixes carry over."""
    table: dict[str, dict[str, str]] = {}
    for kind, entry in new["kinds"].items():
        names = {command["handler"]: command["luau"] for command in old["kinds"][kind]["commands"]}
        namespace = table.setdefault(entry["namespace"], {OLD_EXT: NEW_EXT})
        for command in entry["commands"]:
            before, after = names[command["handler"]], command["luau"]
            namespace[before] = after
            for type_name, suffix in OLD_VARIANTS.items():
                namespace[before + suffix] = after + NEW_VARIANTS[type_name]
    return table


def pattern(table: dict[str, dict[str, str]]) -> re.Pattern[str]:
    namespaces = "|".join(sorted(table))
    names = "|".join(sorted({name for names in table.values() for name in names}, key=len, reverse=True))
    return re.compile(rf"\b({namespaces})\.({names})((?:_\d+v?)?)\b")


def rewrite(text: str, table: dict[str, dict[str, str]], compiled: re.Pattern[str]) -> str:
    def replace(match: re.Match[str]) -> str:
        names = table[match.group(1)]
        name = names.get(match.group(2))
        if name is None:
            return match.group(0)
        return f"{match.group(1)}.{name}{match.group(3)}"

    return compiled.sub(replace, text)


def files() -> list[Path]:
    found = []
    for root in ROOTS:
        for suffix in SUFFIXES:
            for path in (REPO / root).rglob(f"*.{suffix}"):
                if not path.relative_to(REPO).as_posix().startswith(EXCLUDED):
                    found.append(path)
    return sorted(found)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--old", type=Path, required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    old = json.loads(args.old.read_text(encoding="utf-8"))
    new = json.loads(CATALOG.read_text(encoding="utf-8"))
    forward = renames(old, new)
    inverse = {namespace: {after: before for before, after in names.items()} for namespace, names in forward.items()}
    forward_pattern, inverse_pattern = pattern(forward), pattern(inverse)

    problems, changed = [], 0
    for path in files():
        text = path.read_text(encoding="utf-8")
        relative = path.relative_to(REPO).as_posix()
        if args.check:
            original = subprocess.run(
                ["git", "show", f"HEAD:{relative}"], cwd=REPO, capture_output=True, text=True, encoding="utf-8"
            )
            if original.returncode != 0:
                continue
            if rewrite(text, inverse, inverse_pattern) != original.stdout:
                problems.append(f"{relative}: does not map back to HEAD through the inverse renames")
            continue
        renamed = rewrite(text, forward, forward_pattern)
        if renamed != text:
            path.write_text(renamed, encoding="utf-8", newline="\n")
            changed += 1
    for problem in problems:
        print(problem, file=sys.stderr)
    print(json.dumps({"files_changed": changed, "problems": len(problems)}))
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
