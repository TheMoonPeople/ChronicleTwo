#!/usr/bin/env python3
"""Applies name tables to the game's Luau modules: library grouping, functions, handlers, locals and module paths.

    rename/apply.py [--lib <table>] [--modules <dir>] [--check]

The library table groups helper modules (`lib/<kind>/helper_<hash>.luau`) into named modules:

    {"<kind>": {"modules": {"<module>": "<doc>"},
                "helpers": {"<helper stem>": {"module": "<module>", "name": "<function>", "doc": "<doc>",
                                              "locals": {"<old>": "<new>"}}}}}

Each helper becomes `function <module>.<name>(...)` in `lib/<kind>/<module>.luau`, and its callers require the
module once and call `<module>.<name>`. A module table under --modules names one script module:

    {"module": "<path>", "path": "<new path>", "doc": "<doc>",
     "functions": {"<function>": {"name": "<new name>", "doc": "<doc>", "locals": {"<old>": "<new>"}}}}

A function is named by its key: a local function's name, `script.<field>` for a handler, or "" for the module body.
Locals rename every binding of that name the function declares, including those of the anonymous functions it
contains. A numbered handler `script.event_<n>` that is renamed keeps its number through `script[<n>] = ...` after
its definition. "path" moves the module; its loaders must then use the new name.

Names are checked for collisions with keywords and engine globals, every changed module is parsed again, and nothing
is written when any table fails. gate.py proves the result equivalent.
"""

from __future__ import annotations

import argparse
import collections
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import luau_ast  # noqa: E402

IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
# Game languages whose text-bearing helpers live in lib/<kind>/<language>/, so that each language's scripts call
# their own copy by the same name.
LANGUAGES = ("japanese", "english", "french", "german", "italian", "spanish")
NUMBERED = re.compile(r"^script\.event_(\d+)$")


class TableError(Exception):
    pass


def check_name(name: str, what: str) -> None:
    if not IDENTIFIER.match(name) or name in luau_ast.KEYWORDS or name in luau_ast.RESERVED:
        raise TableError(f"{what}: {name!r} is not a usable name")


def doc_lines(module: luau_ast.Module, statement: dict) -> tuple[int, int]:
    """The span of the `---` comment lines directly above a statement (empty when there are none)."""
    start, _ = module.statement_lines(statement)
    cursor = start
    while cursor > 0:
        previous = module.source.rfind(b"\n", 0, cursor - 1) + 1
        line = module.source[previous : cursor - 1].strip()
        if not line.startswith(b"---"):
            break
        cursor = previous
    return cursor, start


def doc_text(doc: str, indent: str = "") -> str:
    return "".join(f"{indent}--- {line}\n" if line else f"{indent}---\n" for line in doc.strip().splitlines())


class Library:
    """The library table: where each grouped helper goes and what it is called."""

    def __init__(self, table: dict):
        self.table = table
        self.target: dict[str, tuple[str, str, str]] = {}  # old require path -> (new path, module, function)
        self.helpers: dict[str, dict] = {}  # old require path -> row
        self.modules: dict[str, str] = {}  # new path -> doc
        for kind, entry in table.items():
            names = collections.defaultdict(set)
            for module, doc in entry.get("modules", {}).items():
                *language, alias = module.split("/")
                if len(language) > 1 or (language and language[0] not in LANGUAGES):
                    raise TableError(f"lib/{kind}/{module}: a module path is <name> or <language>/<name>")
                check_name(alias, f"lib/{kind} module")
                self.modules[f"@lib/{kind}/{module}"] = doc
            for stem, row in entry["helpers"].items():
                module = row["module"]
                if f"@lib/{kind}/{module}" not in self.modules:
                    raise TableError(f"lib/{kind}/{stem}: module {module!r} is not declared")
                check_name(row["name"], f"lib/{kind}/{stem}")
                if row["name"] in names[module]:
                    raise TableError(f"lib/{kind}/{module}: two helpers are named {row['name']!r}")
                names[module].add(row["name"])
                path = f"@lib/{kind}/{stem}"
                self.target[path] = (f"@lib/{kind}/{module}", module.rsplit("/", 1)[-1], row["name"])
                self.helpers[path] = row
                for old, new in row.get("locals", {}).items():
                    check_name(new, f"lib/{kind}/{stem} local {old}")

    def file(self, path: str) -> Path:
        return luau_ast.SCRIPTS / "lib" / (path[len("@lib/") :] + ".luau")


class Rewriter:
    """Collects the edits of one module."""

    def __init__(self, module: luau_ast.Module, library: Library, label: str):
        self.module = module
        self.library = library
        self.label = label
        self.edits: list[tuple[int, int, str]] = []
        self.renamed: dict[str, str] = {}  # binding key -> new name
        self.aliases: dict[str, str] = {}  # new require path -> local name
        self.removed_requires: list[tuple[int, int]] = []
        self.kept_requires: set[str] = set()

    def rename_binding(self, key: str, name: str) -> None:
        if self.renamed.get(key, name) != name:
            raise TableError(f"{self.label}: {self.module.bindings[key].name} is given two names")
        self.renamed[key] = name

    def rename_locals(self, context: str, names: dict[str, str]) -> None:
        for old, new in names.items():
            check_name(new, f"{self.label}: {context or '<module>'} local {old}")
            matches = [b for b in self.module.bindings.values() if b.context == context and b.name == old]
            if not matches:
                raise TableError(f"{self.label}: {context or '<module>'} declares no {old}")
            for binding in matches:
                self.rename_binding(binding.key, new)

    def library_calls(self, own: tuple[str, str] | None = None) -> None:
        """Turns references to grouped helpers into `<module>.<function>` and plans the module requires.

        own is (old require path of this helper, module local name) when the module being rewritten is itself a
        grouped helper: its self-references and calls into its own module go through that local.
        """
        for binding in self.module.bindings.values():
            if binding.require is None or binding.require not in self.library.target:
                continue
            new_path, module, function = self.library.target[binding.require]
            if own is not None and new_path == own[0]:
                alias = own[1]
            else:
                alias = module
                self.aliases[new_path] = alias
            for reference in binding.references:
                self.edits.append((reference[0], reference[1], f"{alias}.{function}"))
            self.removed_requires.append(binding.key)

    def finish_requires(self) -> None:
        """Deletes the replaced require lines and writes one require per grouped module where the first stood."""
        statements = {
            s["vars"][0]["location"]: s for s in self.module.root["root"]["body"] if s["type"] == "AstStatLocal" and len(s["vars"]) == 1
        }
        spans = []
        for key in self.removed_requires:
            start, end = self.module.statement_lines(statements[key])
            spans.append((start, end + 1))
        if not spans and not self.aliases:
            return
        self.check_aliases()
        lines = "".join(f'local {alias} = require("{path}")\n' for path, alias in sorted(self.aliases.items(), key=lambda item: item[1]))
        spans.sort()
        self.edits.append((spans[0][0], spans[0][1], lines))
        for start, end in spans[1:]:
            self.edits.append((start, end, ""))

    def check_aliases(self, own: str | None = None) -> None:
        """Rejects module locals that share a name with each other, a remaining local or a global the module reads."""
        names = {self.renamed.get(k, b.name) for k, b in self.module.bindings.items() if k not in self.removed_requires}
        aliases = list(self.aliases.values()) + ([own] if own else [])
        if len(set(aliases)) != len(aliases):
            raise TableError(f"{self.label}: two required modules share the local name {aliases}")
        for alias in aliases:
            if alias in names or alias in self.module.globals:
                raise TableError(f"{self.label}: module local {alias} collides with a name the module uses")

    def binding_edits(self) -> None:
        for key, name in self.renamed.items():
            binding = self.module.bindings[key]
            self.edits.append((binding.span[0], binding.span[1], name))
            for reference in binding.references:
                self.edits.append((reference[0], reference[1], name))

    def check_collisions(self) -> None:
        """Rejects renames that would make two bindings of one function share a name or shadow a global."""
        by_context = collections.defaultdict(lambda: collections.defaultdict(set))
        for key, binding in self.module.bindings.items():
            name = self.renamed.get(key, binding.name)
            by_context[binding.context][name].add(binding.name)
        for context, names in by_context.items():
            for name, originals in names.items():
                if len(originals) > 1:
                    raise TableError(f"{self.label}: {context or '<module>'} gives {name} to {', '.join(sorted(originals))}")
        for key, name in self.renamed.items():
            if name in self.module.globals:
                raise TableError(f"{self.label}: {name} shadows a global the module reads")


def numbered_statements(module: luau_ast.Module, script_key: str) -> dict[str, dict]:
    """Top-level statements that define `script.<field>`, by field."""
    found = {}
    for statement in module.root["root"]["body"]:
        target = None
        if statement["type"] == "AstStatFunction":
            target = statement["name"]
        elif statement["type"] == "AstStatAssign" and len(statement["vars"]) == 1:
            target = statement["vars"][0]
        if (
            target is not None
            and target.get("type") == "AstExprIndexName"
            and target["expr"].get("type") == "AstExprLocal"
            and target["expr"]["local"]["location"] == script_key
        ):
            found[target["index"]] = statement
    return found


def rewrite_module(module: luau_ast.Module, table: dict | None, library: Library, label: str) -> bytes:
    rewriter = Rewriter(module, library, label)
    rewriter.library_calls()
    replaced: list[tuple[int, int, str]] = []
    if table is not None:
        functions = table.get("functions", {})
        script_bindings = [b for b in module.bindings.values() if b.name == "script" and b.context == ""]
        script_key = script_bindings[0].key if script_bindings else None
        handlers = numbered_statements(module, script_key) if script_key else {}
        field_names = {field for (binding, field, _, _) in module.fields if binding == script_key}
        new_fields: dict[str, str] = {}
        for key, row in functions.items():
            if key in module.duplicate_functions:
                raise TableError(f"{label}: {key} names more than one function")
            rewriter.rename_locals(key, row.get("locals", {}))
            if key.startswith("script."):
                field = key[len("script.") :]
                if "name" in row and row["name"] != field:
                    if not NUMBERED.match(key):
                        raise TableError(f"{label}: only numbered handlers can be renamed, not {key}")
                    check_name(row["name"], f"{label}: {key}")
                    if row["name"] in field_names or row["name"] in new_fields.values():
                        raise TableError(f"{label}: handler name {row['name']} is already a field of script")
                    new_fields[field] = row["name"]
                if key not in module.functions and field not in handlers:
                    raise TableError(f"{label}: no function {key}")
            elif "name" in row:
                if key not in module.functions or module.functions[key].binding is None:
                    raise TableError(f"{label}: no local function {key}")
                check_name(row["name"], f"{label}: {key}")
                rewriter.rename_binding(module.functions[key].binding, row["name"])
            elif key and key not in module.functions:
                raise TableError(f"{label}: no function {key}")
            if row.get("doc"):
                function = module.functions.get(key)
                statement = function.statement if function else handlers.get(key[len("script.") :])
                if statement is None:
                    raise TableError(f"{label}: no statement documents {key}")
                start, end = doc_lines(module, statement)
                indent = module.source[end : module.span(statement["location"])[0]].decode()
                rewriter.edits.append((start, end, doc_text(row["doc"], indent)))
        # Local functions assigned to a numbered field take the function's new name unless the field has its own.
        for field, statement in handlers.items():
            if field in new_fields or statement["type"] != "AstStatAssign" or not NUMBERED.match(f"script.{field}"):
                continue
            value = statement["values"][0]
            if value.get("type") == "AstExprLocal" and value["local"]["location"] in rewriter.renamed:
                new_fields[field] = rewriter.renamed[value["local"]["location"]]
        for binding, field, span, _ in module.fields:
            if binding == script_key and field in new_fields:
                rewriter.edits.append((span[0], span[1], new_fields[field]))
        # A function registered under several numbers is defined as a field once; its other numbers register that field.
        defined: set[str] = set()
        for field, name in sorted(new_fields.items(), key=lambda item: module.span(handlers[item[0]]["location"]) if item[0] in handlers else (0, 0)):
            statement = handlers.get(field)
            if statement is None:
                raise TableError(f"{label}: script.{field} is not defined at the top level")
            number = NUMBERED.match(f"script.{field}").group(1)
            start, end = module.span(statement["location"])
            if name in defined:
                if statement["type"] != "AstStatAssign":
                    raise TableError(f"{label}: two handlers with bodies are named {name}")
                replaced.append((start, end, f"script[{number}] = script.{name}"))
            else:
                defined.add(name)
                rewriter.edits.append((end, end, f"\nscript[{number}] = script.{name}"))
        if table.get("doc"):
            header = re.compile(rb"^--(?!-)[^\n]*translated[^\n]*\n", re.M).search(module.source)
            if header is not None:
                rewriter.edits.append((header.start(), header.end(), doc_text(table["doc"])))
    rewriter.check_collisions()
    rewriter.binding_edits()
    rewriter.finish_requires()
    edits = [e for e in rewriter.edits if not any(s <= e[0] and e[1] <= t for s, t, _ in replaced)]
    return luau_ast.apply_edits(module.source, edits + replaced)


def build_library_module(path: str, doc: str, members: list[tuple[str, luau_ast.Module]], library: Library) -> bytes:
    """Writes a grouped module from its helpers' modules."""
    _, module_name, _ = library.target[members[0][0]]
    bodies = []
    requires: dict[str, str] = {}
    plain_requires: dict[str, str] = {}
    for old_path, module in sorted(members, key=lambda item: library.target[item[0]][2]):
        row = library.helpers[old_path]
        function = next(iter(module.functions.values()))
        rewriter = Rewriter(module, library, old_path)
        for old, new in row.get("locals", {}).items():
            matches = [b for b in module.bindings.values() if b.name == old and b.require is None and b.key != function.binding]
            if not matches:
                raise TableError(f"{old_path}: declares no {old}")
            for binding in matches:
                rewriter.rename_binding(binding.key, new)
        rewriter.library_calls(own=(path, module_name))
        for binding in module.bindings.values():
            if binding.require is not None and binding.require not in library.target:
                plain_requires[binding.name] = binding.require
        requires.update(rewriter.aliases)
        own = module.bindings[function.binding]
        statement_start, statement_end = module.span(function.statement["location"])
        for reference in own.references:
            if statement_start <= reference[0] < statement_end:
                rewriter.edits.append((reference[0], reference[1], f"{module_name}.{row['name']}"))
        rewriter.edits.append((statement_start, own.span[1], f"function {module_name}.{row['name']}"))
        rewriter.check_collisions()
        rewriter.removed_requires.append(function.binding)
        rewriter.check_aliases(own=module_name)
        rewriter.binding_edits()
        start, end = module.span(function.statement["location"])
        local_edits = [(s - start, e - start, t) for s, e, t in rewriter.edits if start <= s and e <= end]
        if len(local_edits) != len(rewriter.edits):
            raise TableError(f"{old_path}: an edit falls outside its function")
        text = luau_ast.apply_edits(module.source[start:end], local_edits).decode("utf-8")
        bodies.append(doc_text(row.get("doc") or "Helper function.") + text + "\n")
    lines = ["--!strict\n", doc_text(doc or module_name.replace("_", " ").capitalize() + " helpers."), "\n"]
    # Library modules reach each other through vm.module, which requires on first use: they may call into each other.
    if requires:
        plain_requires.setdefault("vm", "@lib/vm")
    for name, required in sorted(plain_requires.items(), key=lambda item: (item[1] != "@lib/vm", item[0])):
        lines.append(f'local {name} = require("{required}")\n')
    for required, alias in sorted(requires.items(), key=lambda item: item[1]):
        lines.append(f'local {alias} = vm.module("{required}")\n')
    lines.append(f"\nlocal {module_name} = {{}}\n\n")
    lines.append("\n".join(bodies))
    lines.append(f"\nreturn {module_name}\n")
    return "".join(lines).encode("utf-8")


def main(argv: list[str] | None = None) -> int:
    sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--lib", type=Path, help="library table")
    parser.add_argument("--modules", type=Path, help="directory of module tables")
    parser.add_argument("--root", type=Path, default=luau_ast.SCRIPTS, help="scripts root (default: port/src/luau)")
    parser.add_argument("--check", action="store_true", help="report problems without writing")
    args = parser.parse_args(argv)
    luau_ast.SCRIPTS = args.root.resolve()

    library = Library(json.loads(args.lib.read_text(encoding="utf-8")) if args.lib else {})
    tables: dict[str, dict] = {}
    if args.modules:
        for path in sorted(args.modules.rglob("*.json")):
            table = json.loads(path.read_text(encoding="utf-8"))
            if table["module"] in tables:
                raise SystemExit(f"two tables name {table['module']}")
            tables[table["module"]] = table

    files = sorted(p for p in luau_ast.SCRIPTS.rglob("*.luau") if not p.name.endswith(".d.luau") and "api" not in p.relative_to(luau_ast.SCRIPTS).parts[:1])
    library_paths = {library.file(path) for path in library.target}
    missing = [str(p) for p in library_paths if not p.is_file()]
    if missing:
        raise SystemExit("library table names missing helpers:\n" + "\n".join(missing))
    required = re.compile(rb'require\("([^"]+)"\)')
    targets = {path.encode() for path in library.target}
    selected = []
    for file in files:
        relative = file.relative_to(luau_ast.SCRIPTS).with_suffix("").as_posix()
        if file in library_paths or relative in tables or any(m in targets for m in required.findall(file.read_bytes())):
            selected.append(file)
    parsed = luau_ast.parse_many(selected)

    errors: list[str] = []
    outputs: dict[Path, bytes] = {}
    removals: set[Path] = set()

    groups = collections.defaultdict(list)
    for old_path, (new_path, _, _) in library.target.items():
        groups[new_path].append((old_path, parsed[library.file(old_path)]))
    for new_path, members in groups.items():
        try:
            outputs[library.file(new_path)] = build_library_module(new_path, library.modules[new_path], members, library)
        except TableError as error:
            errors.append(str(error))
    removals |= library_paths

    for file, module in parsed.items():
        if file in library_paths:
            continue
        relative = file.relative_to(luau_ast.SCRIPTS).with_suffix("").as_posix()
        table = tables.get(relative)
        try:
            output = rewrite_module(module, table, library, relative)
        except TableError as error:
            errors.append(str(error))
            continue
        destination = file
        if table is not None and table.get("path") and table["path"] != relative:
            destination = luau_ast.SCRIPTS / (table["path"] + ".luau")
            if destination.exists() and destination not in removals:
                errors.append(f"{relative}: {table['path']} already exists")
                continue
            removals.add(file)
        if output != module.source or destination != file:
            outputs[destination] = output
    unknown = sorted(set(tables) - {f.relative_to(luau_ast.SCRIPTS).with_suffix("").as_posix() for f in parsed})
    errors += [f"{name}: no such module" for name in unknown]

    if errors:
        print("\n".join(errors), file=sys.stderr)
        print(f"{len(errors)} problems; nothing written", file=sys.stderr)
        return 1
    if args.check:
        print(f"{len(outputs)} files would change, {len(removals - set(outputs))} would be removed")
        return 0
    for path in removals - set(outputs):
        path.unlink()
    for path, data in outputs.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    print(f"{len(outputs)} files written, {len(removals - set(outputs))} removed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
