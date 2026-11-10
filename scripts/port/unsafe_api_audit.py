"""List compiled PC call sites that still select capacityless or borrowed APIs."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from clang import cindex


BUFFER_CALLS = {
    "LoadFile",
    "LoadFile2",
    "LoadFileBG",
    "LoadBGM",
    "LoadSeSrc",
    "LoadSeEnv",
    "LoadSeBattle",
    "LoadSeBase",
}
PATH_CALLS = {
    "GetCurrentDir": 0,
    "DivPathName": 1,
    "DivPathNameExt": 1,
    "GetItemFileName": -1,
    "GetItemFilePath": -1,
    "GetCharacterSnd": -1,
}
ARENA_CURSOR_FIELDS = {"stack_used", "lock"}
ARENA_WRITE_KINDS = {
    cindex.CursorKind.BINARY_OPERATOR,
    cindex.CursorKind.COMPOUND_ASSIGNMENT_OPERATOR,
    cindex.CursorKind.UNARY_OPERATOR,
}
ARENA_LVALUE_WRAPPERS = {
    cindex.CursorKind.UNEXPOSED_EXPR,
    cindex.CursorKind.PAREN_EXPR,
    cindex.CursorKind.CSTYLE_CAST_EXPR,
    cindex.CursorKind.CXX_STATIC_CAST_EXPR,
    cindex.CursorKind.CXX_REINTERPRET_CAST_EXPR,
}


try:
    from .ownership_audit import owned_location, translation_units
except ImportError:
    from ownership_audit import owned_location, translation_units


def is_unsafe(call: cindex.Cursor) -> bool:
    name = call.spelling
    declaration = call.referenced
    if declaration is None:
        return False
    parameters = list(declaration.get_arguments())
    if name in BUFFER_CALLS:
        if len(parameters) < 2:
            return False
        owner = declaration.semantic_parent
        if name.startswith("LoadSe") or name == "LoadBGM":
            if owner.spelling != "CScene":
                return False
            return parameters[1].type.get_canonical().kind == cindex.TypeKind.POINTER
        if owner.kind != cindex.CursorKind.TRANSLATION_UNIT:
            return False
        destination = parameters[1].type.get_canonical()
        if destination.kind != cindex.TypeKind.POINTER:
            return False
        pointee = destination.get_pointee().get_canonical()
        return (pointee.kind in {cindex.TypeKind.VOID, cindex.TypeKind.VECTOR} or
                pointee.spelling in {"char", "signed char", "unsigned char", "std::byte", "u_long128"})
    if name in PATH_CALLS:
        if declaration.semantic_parent.kind != cindex.CursorKind.TRANSLATION_UNIT:
            return False
        expected = PATH_CALLS[name]
        if expected >= 0:
            return len(parameters) != expected
        return declaration.result_type.get_canonical().kind == cindex.TypeKind.POINTER
    return False


def arena_field_lvalue(cursor: cindex.Cursor) -> str | None:
    """Name an arena cursor field reached through lvalue-preserving wrappers."""
    if cursor.kind == cindex.CursorKind.MEMBER_REF_EXPR:
        field = cursor.referenced
        if (field is not None and field.kind == cindex.CursorKind.FIELD_DECL
                and field.spelling in ARENA_CURSOR_FIELDS
                and field.semantic_parent is not None
                and field.semantic_parent.spelling == "mgCMemory"):
            return field.spelling
        return None
    if cursor.kind in ARENA_LVALUE_WRAPPERS:
        return next((arena_field_lvalue(child) for child in cursor.get_children()), None)
    if cursor.kind == cindex.CursorKind.UNARY_OPERATOR:
        tokens = [token.spelling for token in cursor.get_tokens()]
        if tokens and tokens[0] in {"*", "&"}:
            return next((arena_field_lvalue(child) for child in cursor.get_children()), None)
    return None


def arena_cursor_write(cursor: cindex.Cursor) -> str | None:
    """Find direct assignment, compound assignment or increment of an arena cursor."""
    if cursor.kind not in ARENA_WRITE_KINDS:
        return None
    children = list(cursor.get_children())
    if not children:
        return None
    if cursor.kind == cindex.CursorKind.BINARY_OPERATOR:
        if len(children) != 2:
            return None
        between = [token.spelling for token in cursor.get_tokens()
                   if children[0].extent.end.offset <= token.location.offset
                   < children[1].extent.start.offset]
        if between != ["="]:
            return None
    if cursor.kind == cindex.CursorKind.UNARY_OPERATOR:
        tokens = [token.spelling for token in cursor.get_tokens()]
        if "++" not in tokens and "--" not in tokens:
            return None
    return arena_field_lvalue(children[0])


def scan(build: Path, root: Path, arena_cursors_only: bool = False,
         owned_prefixes: tuple[Path, ...] = (), coverage: dict | None = None) -> list[tuple]:
    findings = {}
    allocator = (root / "port/src/memory/mg_memory.cpp").resolve()
    for _, unit in translation_units(build, root, owned_prefixes, coverage):
        for cursor in unit.cursor.walk_preorder():
            location = owned_location(cursor.location, root, owned_prefixes)
            if location is None:
                continue
            path, line, column = location
            if not arena_cursors_only and cursor.kind == cindex.CursorKind.CALL_EXPR and cursor.spelling in BUFFER_CALLS | PATH_CALLS.keys() and is_unsafe(cursor):
                parameters = ", ".join(parameter.type.get_canonical().spelling for parameter in cursor.referenced.get_arguments())
                concrete_type = cursor.referenced.type.get_canonical().spelling
                findings[(path, line, column, concrete_type)] = (path, line, column, cursor.spelling, parameters)
            elif (root / path).resolve() != allocator and (field := arena_cursor_write(cursor)):
                concrete_type = cursor.type.get_canonical().spelling
                findings[(path, line, column, concrete_type, field)] = (path, line, column, "arena_cursor_write", field)
    return sorted(findings.values())


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build", type=Path, required=True)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--check", action="store_true", help="Fail if any legacy call remains")
    parser.add_argument("--arena-cursors-only", action="store_true", help="Check direct writes to mgCMemory cursor and lock fields")
    parser.add_argument("--owned-prefix", type=Path, action="append", default=[])
    parser.add_argument("--coverage", type=Path)
    args = parser.parse_args()
    if args.coverage:
        args.coverage.unlink(missing_ok=True)
    coverage = {"owned_prefixes": [str(prefix) for prefix in args.owned_prefix]}
    findings = scan(args.build.resolve(), args.root.resolve(), args.arena_cursors_only, tuple(args.owned_prefix), coverage)
    if args.coverage:
        coverage["parsed_commands"] = len(coverage["translation_units"])
        coverage["unique_sources"] = len(set(coverage["translation_units"]))
        coverage["findings"] = len(findings)
        args.coverage.write_text(json.dumps(coverage, indent=2) + "\n")
    for path, line, column, name, parameters in findings:
        print(f"{path}:{line}:{column}\t{name}\t{parameters}")
    print(f"legacy call sites: {len(findings)}")
    return 1 if args.check and findings else 0


if __name__ == "__main__":
    raise SystemExit(main())
