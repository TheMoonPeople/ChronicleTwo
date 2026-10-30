"""Inventory native C++ allocations, deletes, and child-arena bindings by compiled source location."""

from __future__ import annotations

import argparse
import json
import subprocess
from functools import lru_cache
from pathlib import Path

from clang import cindex


C_ALLOCATION_CALLS = {
    "malloc": "heap_alloc_call",
    "calloc": "heap_alloc_call",
    "realloc": "heap_realloc_call",
    "aligned_alloc": "heap_alloc_call",
    "operator new": "heap_alloc_call",
    "operator new[]": "heap_alloc_call",
    "free": "heap_release_call",
    "operator delete": "heap_release_call",
    "operator delete[]": "heap_release_call",
    "mmap": "vm_map_call",
    "munmap": "vm_unmap_call",
    "VirtualAlloc": "vm_map_call",
    "VirtualFree": "vm_unmap_call",
}
TYPED_ARENA_CALLS = {
    "NewObject": "arena_object_call",
    "NewArray": "arena_array_call",
    "Allocate": "arena_template_call",
}
OWNERSHIP_FACTORIES = {
    "make_unique", "make_unique_for_overwrite", "make_shared", "make_shared_for_overwrite",
    "allocate_shared", "allocate_shared_for_overwrite",
}


def is_standard_ownership_factory(cursor) -> bool:
    """Include standard owning factories at their caller, excluding same-name project helpers."""
    if cursor.kind != cindex.CursorKind.CALL_EXPR or cursor.spelling not in OWNERSHIP_FACTORIES:
        return False
    declaration = cursor.referenced
    namespace = declaration.semantic_parent if declaration is not None else None
    while namespace is not None and namespace.kind == cindex.CursorKind.NAMESPACE:
        if namespace.spelling == "std":
            return namespace.semantic_parent.kind == cindex.CursorKind.TRANSLATION_UNIT
        namespace = namespace.semantic_parent
    return False


def is_raw_arena_allocation(cursor) -> bool:
    """Identify the allocator method itself, excluding unrelated methods named Alloc."""
    if cursor.kind != cindex.CursorKind.CALL_EXPR or cursor.spelling != "Alloc":
        return False
    method = cursor.referenced
    return (method is not None and method.kind == cindex.CursorKind.CXX_METHOD
            and method.semantic_parent is not None and method.semantic_parent.spelling == "mgCMemory")


@lru_cache(maxsize=None)
def compiler_resource_dir(compiler: str) -> str:
    return subprocess.check_output([compiler, "-print-resource-dir"], text=True).strip()


def compile_arguments(command: cindex.CompileCommand, source: Path) -> list[str]:
    command_line = list(command.arguments)
    original = command_line[1:]
    result: list[str] = []
    skip_next = False
    for argument in original:
        if skip_next:
            skip_next = False
        elif argument == "-o":
            skip_next = True
        elif argument != "-c" and (Path(command.directory) / argument).resolve() != source:
            result.append(argument)
    result.append(f"-working-directory={command.directory}")
    if not any(argument.startswith("-resource-dir") for argument in result):
        result.append(f"-resource-dir={compiler_resource_dir(command_line[0])}")
    return result


@lru_cache(maxsize=None)
def owned_roots(root: Path, owned_prefixes: tuple[Path, ...]) -> tuple[Path, ...]:
    """Keep the default port roots and separately selected dependency ownership."""
    root = root.resolve()
    prefixes = [root / "port/src", root / "port/include"]
    for prefix in owned_prefixes:
        selected = (root / prefix).resolve()
        if not selected.is_relative_to(root):
            raise ValueError(f"owned audit prefix lies outside the project: {selected}")
        if not selected.exists():
            raise ValueError(f"owned audit prefix does not exist: {selected}")
        prefixes.append(selected)
    return tuple(prefixes)


@lru_cache(maxsize=None)
def owned_file(filename: str, root: Path, owned_prefixes: tuple[Path, ...]) -> str | None:
    """Canonicalize each included file once while excluding unowned dependencies."""
    path = Path(filename).resolve()
    if not any(path.is_relative_to(prefix) for prefix in owned_roots(root, owned_prefixes)):
        return None
    return path.relative_to(root.resolve()).as_posix()


def owned_location(location, root: Path, owned_prefixes: tuple[Path, ...] = ()) -> tuple[str, int, int] | None:
    """Resolve an expression to an explicitly owned project path, regardless of suffix."""
    if location.file is None:
        return None
    path = owned_file(location.file.name, root, owned_prefixes)
    return None if path is None else (path, location.line, location.column)


def translation_units(build: Path, root: Path, owned_prefixes: tuple[Path, ...] = (), coverage: dict | None = None):
    """Parse every production command, retaining flag variants and failing on any error."""
    database = cindex.CompilationDatabase.fromDirectory(str(build))
    index = cindex.Index.create()
    source_root = (root / "port/src").resolve()
    test_root = source_root / "tests"
    extra_roots = owned_roots(root, owned_prefixes)[2:]
    seen = set()
    if coverage is not None:
        coverage["translation_units"] = []
    for command in database.getAllCompileCommands() or ():
        source = Path(command.filename)
        if not source.is_absolute():
            source = Path(command.directory) / source
        source = source.resolve()
        if source.is_relative_to(test_root) or not (
                source.is_relative_to(source_root) or any(source.is_relative_to(prefix) for prefix in extra_roots)):
            continue
        args = compile_arguments(command, source)
        key = source, tuple(args)
        if key in seen:
            continue
        seen.add(key)
        unit = index.parse(str(source), args=args)
        errors = [str(diagnostic) for diagnostic in unit.diagnostics
                  if diagnostic.severity >= cindex.Diagnostic.Error]
        if errors:
            raise RuntimeError(f"libclang could not parse {source}: {'; '.join(errors[:5])}")
        if coverage is not None:
            coverage["translation_units"].append(source.relative_to(root).as_posix())
        yield source, unit
    if not seen:
        raise RuntimeError("no production compile commands match the owned audit roots")


def owner(path: str) -> str:
    if path.startswith("tools/kazarov/"):
        return "owned_dependency"
    if "/src/render/" in path or "/src/memory/" in path or "/src/platform/" in path or "/src/audio/" in path:
        return "render_memory_platform"
    if "/src/object/character/" in path or "/src/object/event/" in path or "/src/script/" in path:
        return "character_event_script"
    return "menu_world_other"


def inventory(build: Path, root: Path, owned_prefixes: tuple[Path, ...] = (), coverage: dict | None = None) -> list[tuple]:
    rows = {}
    for _, unit in translation_units(build, root, owned_prefixes, coverage):
        for cursor in unit.cursor.walk_preorder():
            location = owned_location(cursor.location, root, owned_prefixes)
            if location is None:
                continue
            if cursor.kind == cindex.CursorKind.CXX_NEW_EXPR:
                tokens = [token.spelling for token in cursor.get_tokens()]
                new_index = tokens.index("new")
                kind = "placement_new" if len(tokens) > new_index + 1 and tokens[new_index + 1] == "(" else "new"
            elif cursor.kind == cindex.CursorKind.CXX_DELETE_EXPR:
                tokens = [token.spelling for token in cursor.get_tokens()]
                kind = "delete"
            elif cursor.kind == cindex.CursorKind.CALL_EXPR and cursor.spelling in {"stSetBuffer", "stSetChildBuffer", "stSetBorrowedBuffer", "stShareBuffer", "stShareStack"}:
                tokens = [token.spelling for token in cursor.get_tokens()]
                kind = "child_arena"
            elif cursor.kind == cindex.CursorKind.CALL_EXPR and cursor.spelling in C_ALLOCATION_CALLS | TYPED_ARENA_CALLS:
                tokens = [token.spelling for token in cursor.get_tokens()]
                kind = C_ALLOCATION_CALLS.get(cursor.spelling, TYPED_ARENA_CALLS.get(cursor.spelling))
            elif is_raw_arena_allocation(cursor):
                tokens = [token.spelling for token in cursor.get_tokens()]
                kind = "raw_arena_call"
            elif is_standard_ownership_factory(cursor):
                tokens = [token.spelling for token in cursor.get_tokens()]
                kind = "ownership_factory_call"
            else:
                continue
            path, line, column = location
            concrete_type = cursor.type.get_canonical().spelling
            expression = " ".join(tokens[:48]).replace("	", " ").replace("\n", " ")
            key = path, line, column, concrete_type, kind
            rows[key] = (path, line, column, kind, concrete_type, owner(path), "unreviewed", expression)
    return sorted(rows.values())


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build", type=Path, required=True)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--owned-prefix", type=Path, action="append", default=[], help="Additional explicit owned file or directory under the project root")
    parser.add_argument("--coverage", type=Path, help="Write the successfully parsed production command coverage as JSON")
    args = parser.parse_args()
    print("file\tline\tcolumn\tkind\ttype\towner\tstatus\texpression")
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
