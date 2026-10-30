"""Inventory compiled C string writes and their destination expression types."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from clang import cindex


SINKS = {"strcpy", "strcat", "sprintf", "strncpy", "strncat", "snprintf"}


try:
    from .ownership_audit import owned_location, owner, translation_units
except ImportError:
    from ownership_audit import owned_location, owner, translation_units


def destination_type(expression: cindex.Cursor) -> str:
    for cursor in expression.walk_preorder():
        if cursor.kind in {cindex.CursorKind.DECL_REF_EXPR, cindex.CursorKind.MEMBER_REF_EXPR}:
            if cursor.type.kind == cindex.TypeKind.CONSTANTARRAY:
                return cursor.type.get_canonical().spelling
    return expression.type.get_canonical().spelling


def inventory(build: Path, root: Path, owned_prefixes: tuple[Path, ...] = (), coverage: dict | None = None) -> list[tuple]:
    rows = {}
    for _, unit in translation_units(build, root, owned_prefixes, coverage):
        for cursor in unit.cursor.walk_preorder():
            if cursor.kind != cindex.CursorKind.CALL_EXPR or cursor.spelling not in SINKS:
                continue
            location = owned_location(cursor.location, root, owned_prefixes)
            if location is None:
                continue
            arguments = list(cursor.get_arguments())
            if not arguments:
                continue
            path, line, column = location
            destination = arguments[0]
            concrete_type = destination_type(destination)
            dest_tokens = " ".join(token.spelling for token in list(destination.get_tokens())[:24])
            key = path, line, column, concrete_type, cursor.spelling
            rows[key] = (path, line, column, cursor.spelling, concrete_type, owner(path), "unreviewed", dest_tokens)
    return sorted(rows.values())


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build", type=Path, required=True)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--owned-prefix", type=Path, action="append", default=[])
    parser.add_argument("--coverage", type=Path)
    args = parser.parse_args()
    print("file\tline\tcolumn\tcall\tdestination_type\towner\tstatus\tdestination")
    if args.coverage:
        args.coverage.unlink(missing_ok=True)
    coverage = {"owned_prefixes": [str(prefix) for prefix in args.owned_prefix]}
    rows = inventory(args.build.resolve(), args.root.resolve(), tuple(args.owned_prefix), coverage)
    if args.coverage:
        coverage["parsed_commands"] = len(coverage["translation_units"])
        coverage["unique_sources"] = len(set(coverage["translation_units"]))
        coverage["findings"] = len(rows)
        args.coverage.write_text(json.dumps(coverage, indent=2) + "\n")
    for row in rows:
        print("\t".join(str(value) for value in row))
    print(f"inventory rows: {len(rows)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
