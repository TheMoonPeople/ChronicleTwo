#!/usr/bin/env python3
"""Proves that renamed Luau modules do what the modules before the rename did.

    rename/gate.py --before <dir> [--after <dir>] [--lib <table>] [--modules <dir>]

Both trees are parsed by luau-ast and compared as canonical ASTs in which locals are numbered by declaration,
comments and locations drop out, and a library function compares equal however it is reached: through a
`helper_<hash>` module or a field of the grouped module it moved to. A numbered handler renamed to `script.<name>`
compares by its number, which its `script[<n>] = script.<name>` registration states. Every module before the rename
must have an equivalent after it, and every module after it must come from one.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import apply  # noqa: E402
import luau_ast  # noqa: E402


def module_files(root: Path) -> dict[str, Path]:
    files = {}
    for path in root.rglob("*.luau"):
        relative = path.relative_to(root)
        if relative.parts[0] == "api" or path.name.endswith(".d.luau"):
            continue
        files[relative.with_suffix("").as_posix()] = path
    return files


def defined_field(statement: dict) -> dict | None:
    """The `script.<name>` target a top-level statement defines, or None."""
    if statement["type"] == "AstStatFunction":
        target = statement["name"]
    elif statement["type"] == "AstStatAssign" and len(statement["vars"]) == 1:
        target = statement["vars"][0]
    else:
        return None
    if target.get("type") == "AstExprIndexName" and target["expr"].get("type") == "AstExprLocal" and target["expr"]["local"]["name"] == "script":
        return target
    return None


def fold_registrations(module: luau_ast.Module) -> dict[str, str]:
    """Rewrites a renamed module's body into its form before the rename, and returns name -> event_<n>.

    A registration that follows its field's definition renames the definition back to event_<n>. A registration on its
    own stands for `script.event_<n> = <the value the field was defined with>`.
    """
    body = module.root["root"]["body"]
    definitions = {}
    for statement in body:
        target = defined_field(statement)
        if target is not None:
            definitions.setdefault(target["index"], statement)
    names: dict[str, str] = {}
    folded = []
    for statement in body:
        found = registration(statement)
        if found is None:
            numbered = numbered_target(statement)
            if numbered is not None:
                target = statement["vars"][0]
                statement["vars"][0] = {"type": "AstExprIndexName", "expr": target["expr"], "index": f"event_{numbered}", "op": "."}
            folded.append(statement)
            continue
        number, name = found
        names.setdefault(name, f"event_{number}")
        previous = defined_field(folded[-1]) if folded else None
        if previous is not None and previous["index"] == name:
            previous["index"] = f"event_{number}"
        else:
            copy = json.loads(json.dumps(definitions[name]))
            defined_field(copy)["index"] = f"event_{number}"
            folded.append(copy)
    body[:] = folded
    return names


def numbered_target(statement: dict) -> int | None:
    """The number of a `script[<n>] = <value>` statement that registers a handler under its number alone, or None."""
    if statement["type"] != "AstStatAssign" or len(statement["vars"]) != 1:
        return None
    target = statement["vars"][0]
    if (
        target.get("type") == "AstExprIndexExpr"
        and target["expr"].get("type") == "AstExprLocal"
        and target["expr"]["local"]["name"] == "script"
        and target["index"].get("type") == "AstExprConstantNumber"
    ):
        return int(target["index"]["value"])
    return None


def registration(statement: dict):
    if statement["type"] != "AstStatAssign" or len(statement["vars"]) != 1 or len(statement["values"]) != 1:
        return None
    target, value = statement["vars"][0], statement["values"][0]
    if (
        target.get("type") == "AstExprIndexExpr"
        and target["expr"].get("type") == "AstExprLocal"
        and target["expr"]["local"]["name"] == "script"
        and target["index"].get("type") == "AstExprConstantNumber"
        and value.get("type") == "AstExprIndexName"
        and value["expr"].get("type") == "AstExprLocal"
        and value["expr"]["local"]["name"] == "script"
    ):
        return int(target["index"]["value"]), value["index"]
    return None


def main(argv: list[str] | None = None) -> int:
    sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--before", type=Path, required=True)
    parser.add_argument("--after", type=Path, default=luau_ast.SCRIPTS)
    parser.add_argument("--lib", type=Path)
    parser.add_argument("--modules", type=Path)
    args = parser.parse_args(argv)

    library = apply.Library(json.loads(args.lib.read_text(encoding="utf-8")) if args.lib else {})
    moved = {}
    if args.modules:
        for path in args.modules.rglob("*.json"):
            table = json.loads(path.read_text(encoding="utf-8"))
            if table.get("path"):
                moved[table["module"]] = table["path"]
    inverse = {(new_path, function): old for old, (new_path, _, function) in library.target.items()}
    grouped = set(library.modules)

    before = module_files(args.before)
    after = module_files(args.after)
    parsed_before = luau_ast.parse_many(list(before.values()))
    parsed_after = luau_ast.parse_many(list(after.values()))

    def resolve_before(path: str, field):
        if field is None and path.startswith("@lib/") and path != "@lib/vm":
            return path
        return None

    def resolve_after(path: str, field):
        if path in grouped:
            return inverse.get((path, field)) if field is not None else None
        return resolve_before(path, field)

    failures: list[str] = []
    accounted: set[str] = set()
    functions_after: dict[str, tuple[luau_ast.Module, dict]] = {}
    for relative in grouped:
        name = relative[len("@lib/") :]
        lib_relative = f"lib/{name}"
        if lib_relative not in after:
            failures.append(f"{lib_relative}: grouped module is missing")
            continue
        accounted.add(lib_relative)
        module = parsed_after[after[lib_relative]]
        alias = name.rsplit("/", 1)[-1]
        table_binding = [b for b in module.bindings.values() if b.name == alias and b.context == "" and b.require is None]
        if len(table_binding) != 1:
            failures.append(f"{lib_relative}: no module table {alias}")
            continue
        table_binding[0].require = relative
        for statement in module.root["root"]["body"]:
            kind = statement["type"]
            if kind == "AstStatFunction" and statement["name"].get("type") == "AstExprIndexName":
                functions_after[inverse.get((relative, statement["name"]["index"]), "?")] = (module, statement["func"])
            elif kind == "AstStatLocal" or kind == "AstStatReturn":
                continue
            else:
                failures.append(f"{lib_relative}: unexpected {kind} at top level")

    for relative, path in sorted(before.items()):
        module = parsed_before[path]
        require_path = f"@lib/{relative[len('lib/'):]}" if relative.startswith("lib/") else None
        if require_path in library.target:
            if require_path not in functions_after:
                failures.append(f"{relative}: its function is missing from {library.target[require_path][0]}")
                continue
            function = next(iter(module.functions.values()))
            module.bindings[function.binding].require = require_path
            old_form = luau_ast.Canonical(module, resolve_before).form(function.node)
            new_module, new_function = functions_after[require_path]
            new_form = luau_ast.Canonical(new_module, resolve_after).form(new_function)
            if old_form != new_form:
                failures.append(f"{relative}: differs in {library.target[require_path][0]}")
            continue
        target = moved.get(relative, relative)
        if target not in after:
            failures.append(f"{relative}: no module {target} after the rename")
            continue
        accounted.add(target)
        new_module = parsed_after[after[target]]
        handlers = fold_registrations(new_module)
        script = next((b.key for b in new_module.bindings.values() if b.name == "script" and b.context == ""), None)
        old_form = luau_ast.Canonical(module, resolve_before).form(module.root["root"])
        new_form = luau_ast.Canonical(
            new_module,
            resolve_after,
            index_name=lambda binding, field: handlers.get(field, field) if binding.key == script else field,
        ).form(new_module.root["root"])
        if old_form != new_form:
            failures.append(f"{relative}: differs from {target}")
    for relative in sorted(set(after) - accounted):
        failures.append(f"{relative}: does not come from a module before the rename")

    print("\n".join(failures))
    print(f"{len(failures)} failures in {len(before)} modules")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
