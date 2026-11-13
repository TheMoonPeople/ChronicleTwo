"""Reads Luau modules through Luau's own parser (luau-ast) and resolves their bindings.

A binding is identified by the location of its declaration, which luau-ast repeats in every reference. Each binding
belongs to the named function that declares it: a local function, a `function a.b()` statement, or a function value
assigned to a local or a field. Anonymous functions belong to the named function that encloses them, and the module
body is the context "".
"""

from __future__ import annotations

import dataclasses
import json
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

REPO = Path(__file__).resolve().parents[3]
LUAU_TOOLS = REPO / "port" / "build" / "luau-tools" / "luau-0.740"
EXE = ".exe" if sys.platform == "win32" else ""
LUAU_AST = LUAU_TOOLS / f"luau-ast{EXE}"
LUAU_ANALYZE = LUAU_TOOLS / f"luau-analyze{EXE}"
SCRIPTS = REPO / "port" / "src" / "luau"
# Globals every module may read; a binding of one of these names would shadow it.
RESERVED = {
    "action", "assert", "bit32", "buffer", "coroutine", "debug", "effect", "error", "event", "getmetatable", "ipairs",
    "math", "monster", "next", "os", "pairs", "pcall", "print", "rawequal", "rawget", "rawlen", "rawset", "require",
    "script", "select", "setmetatable", "string", "table", "tonumber", "tostring", "type", "typeof", "unpack", "utf8",
    "vector", "vm", "vmhost", "xpcall", "self",
}
KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or",
    "repeat", "return", "then", "true", "until", "while", "continue", "export", "type",
}


def is_require(function: dict) -> bool:
    """Whether a call target loads a library module: require, or vm.module, which requires on first use."""
    if function.get("type") == "AstExprGlobal":
        return function["global"] == "require"
    return (
        function.get("type") == "AstExprIndexName"
        and function["index"] == "module"
        and function["expr"].get("type") == "AstExprLocal"
        and function["expr"]["local"]["name"] == "vm"
    )


def parse_location(text: str) -> tuple[int, int, int, int]:
    start, end = text.split(" - ")
    start_line, start_column = start.split(",")
    end_line, end_column = end.split(",")
    return int(start_line), int(start_column), int(end_line), int(end_column)


@dataclasses.dataclass
class Binding:
    """One declared local: its name, the named function that declares it and where its name is written."""

    key: str
    name: str
    context: str
    span: tuple[int, int]
    references: list[tuple[int, int]] = dataclasses.field(default_factory=list)
    require: str | None = None


@dataclasses.dataclass
class Function:
    """A named function: its key, the binding that names it (local functions), and its statement's span."""

    key: str
    node: dict
    statement: dict
    binding: str | None
    name_span: tuple[int, int] | None


class Module:
    """A parsed module: its source bytes, AST, bindings, named functions and field accesses on locals."""

    def __init__(self, path: Path, source: bytes, root: dict):
        self.path = path
        self.source = source
        self.root = root
        self.line_starts = [0]
        for index, byte in enumerate(source):
            if byte == 0x0A:
                self.line_starts.append(index + 1)
        self.bindings: dict[str, Binding] = {}
        self.functions: dict[str, Function] = {}
        self.duplicate_functions: set[str] = set()
        # Accesses `<local>.<field>`: (binding key, field, span of the field name, span of the whole expression).
        self.fields: list[tuple[str, str, tuple[int, int], tuple[int, int]]] = []
        self.globals: set[str] = set()
        self._walk(root["root"], "")

    def offset(self, line: int, column: int) -> int:
        return self.line_starts[line] + column

    def span(self, location: str) -> tuple[int, int]:
        start_line, start_column, end_line, end_column = parse_location(location)
        return self.offset(start_line, start_column), self.offset(end_line, end_column)

    def text(self, span: tuple[int, int]) -> str:
        return self.source[span[0] : span[1]].decode("utf-8")

    def _declare(self, local: dict, context: str) -> Binding:
        key = local["location"]
        binding = self.bindings.get(key)
        if binding is None:
            binding = Binding(key, local["name"], context, self.span(local["location"]))
            self.bindings[key] = binding
        return binding

    def _function_key(self, target: dict) -> str | None:
        kind = target.get("type")
        if kind == "AstExprLocal":
            return target["local"]["name"]
        if kind == "AstExprGlobal":
            return target["global"]
        if kind == "AstExprIndexName":
            base = self._function_key(target["expr"])
            return None if base is None else f"{base}.{target['index']}"
        return None

    def _named(self, key: str, func: dict, statement: dict, binding: str | None, name_span) -> None:
        if key in self.functions:
            self.duplicate_functions.add(key)
        self.functions[key] = Function(key, func, statement, binding, name_span)

    def _walk(self, node, context: str) -> None:
        if isinstance(node, list):
            for item in node:
                self._walk(item, context)
            return
        if not isinstance(node, dict):
            return
        kind = node.get("type")
        if kind == "AstExprLocal":
            self._declare(node["local"], context).references.append(self.span(node["location"]))
            return
        if kind == "AstLocal":
            self._declare(node, context)
            return
        if kind == "AstExprGlobal":
            self.globals.add(node["global"])
            return
        if kind == "AstExprIndexName" and node["expr"].get("type") == "AstExprLocal":
            self.fields.append(
                (node["expr"]["local"]["location"], node["index"], self.span(node["indexLocation"]), self.span(node["location"]))
            )
        if kind == "AstStatLocalFunction":
            binding = self._declare(node["name"], context)
            self._named(binding.name, node["func"], node, binding.key, binding.span)
            self._walk(node["func"], binding.name)
            return
        if kind == "AstStatFunction":
            key = self._function_key(node["name"])
            self._walk(node["name"], context)
            if key is not None:
                name_span = self.span(node["name"]["indexLocation"]) if node["name"].get("type") == "AstExprIndexName" else None
                self._named(key, node["func"], node, None, name_span)
                self._walk(node["func"], key)
            else:
                self._walk(node["func"], context)
            return
        if kind in ("AstStatAssign", "AstStatLocal"):
            targets = node["vars"]
            values = node["values"]
            if kind == "AstStatLocal":
                for local in targets:
                    self._declare(local, context)
            if (
                len(values) == 1
                and len(targets) == 1
                and values[0].get("type") == "AstExprCall"
                and is_require(values[0]["func"])
                and kind == "AstStatLocal"
                and values[0]["args"]
                and values[0]["args"][0].get("type") == "AstExprConstantString"
            ):
                self.bindings[targets[0]["location"]].require = values[0]["args"][0]["value"]
            if len(targets) == 1 and len(values) == 1 and values[0].get("type") == "AstExprFunction":
                key = targets[0]["name"] if kind == "AstStatLocal" else self._function_key(targets[0])
                if kind == "AstStatAssign":
                    self._walk(targets, context)
                if key is not None:
                    binding = targets[0]["location"] if kind == "AstStatLocal" else None
                    self._named(key, values[0], node, binding, None)
                    self._walk(values[0], key)
                else:
                    self._walk(values[0], context)
                return
            if kind == "AstStatAssign":
                self._walk(targets, context)
            self._walk(values, context)
            return
        for name, value in node.items():
            if name in ("location", "type"):
                continue
            self._walk(value, context)

    def statement_lines(self, statement: dict) -> tuple[int, int]:
        """The byte span of a statement widened to whole lines."""
        start, end = self.span(statement["location"])
        while start > 0 and self.source[start - 1] not in (0x0A,):
            start -= 1
        while end < len(self.source) and self.source[end] != 0x0A:
            end += 1
        return start, end


def parse(path: Path) -> Module:
    source = path.read_bytes()
    result = subprocess.run([str(LUAU_AST), str(path)], capture_output=True, check=False)
    if result.returncode != 0:
        raise RuntimeError(f"luau-ast failed on {path}: {result.stderr.decode(errors='replace')}")
    return Module(path, source, json.loads(result.stdout))


def parse_many(paths: list[Path], jobs: int | None = None) -> dict[Path, Module]:
    jobs = jobs or min(8, os.cpu_count() or 4)
    with ThreadPoolExecutor(jobs) as pool:
        return dict(zip(paths, pool.map(parse, paths)))


def apply_edits(source: bytes, edits: list[tuple[int, int, str]]) -> bytes:
    """Replaces byte spans; overlapping edits with different text are an error, identical duplicates collapse."""
    unique = sorted(set(edits))
    out = bytearray()
    cursor = 0
    previous = None
    for start, end, text in unique:
        if previous is not None and start < previous[1]:
            if (start, end) == previous[:2]:
                raise ValueError(f"conflicting edits at byte {start}: {previous[2]!r} and {text!r}")
            raise ValueError(f"overlapping edits at bytes {previous[:2]} and {(start, end)}")
        out += source[cursor:start]
        out += text.encode("utf-8")
        cursor = end
        previous = (start, end, text)
    out += source[cursor:]
    return bytes(out)


# Keys whose values do not take part in what a module does.
IGNORED_KEYS = {"location", "indexLocation", "varargLocation", "debugname", "commentLocations", "hasEnd", "hasSemicolon"}


class Canonical:
    """Builds a comparable form of an AST in which local names are replaced by their declaration order.

    resolve(path, field) names the library function that `require(path)` denotes (field None) or that its field
    denotes, or None; a call through `helper_x` and one through `message.open` then compare equal, and require
    statements of library modules drop out. index_name maps a field name on a binding's table back to its name before
    a rename, and skip drops statements that a rename adds.
    """

    def __init__(self, module: Module, resolve=None, index_name=None, skip=None):
        self.module = module
        self.resolve = resolve or (lambda path, field: None)
        self.index_name = index_name or (lambda binding, field: field)
        self.skip = skip or (lambda statement: False)
        self.order: dict[str, int] = {}

    def is_library_require(self, statement: dict) -> bool:
        if statement.get("type") != "AstStatLocal" or len(statement["vars"]) != 1:
            return False
        path = self.module.bindings[statement["vars"][0]["location"]].require
        return path is not None and path.startswith("@lib/") and path != "@lib/vm"

    def binding_id(self, local: dict):
        key = local["location"]
        binding = self.module.bindings[key]
        if binding.require is not None:
            identity = self.resolve(binding.require, None)
            return ("lib", identity) if identity is not None else ("require", binding.require)
        if key not in self.order:
            self.order[key] = len(self.order)
        return ("local", self.order[key])

    def form(self, node):
        if isinstance(node, list):
            out = []
            for item in node:
                if isinstance(item, dict) and (self.is_library_require(item) or self.skip(item)):
                    continue
                out.append(self.form(item))
            return tuple(out)
        if not isinstance(node, dict):
            return node
        kind = node.get("type")
        if kind == "AstLocal":
            return ("AstLocal", self.binding_id(node), self.form(node.get("luauType")))
        if kind == "AstExprLocal":
            return ("AstExprLocal", self.binding_id(node["local"]))
        if kind == "AstExprIndexName" and node["expr"].get("type") == "AstExprLocal":
            binding = self.module.bindings[node["expr"]["local"]["location"]]
            if binding.require is not None:
                identity = self.resolve(binding.require, node["index"])
                if identity is not None:
                    return ("AstExprLocal", ("lib", identity))
            return ("AstExprIndexName", self.form(node["expr"]), self.index_name(binding, node["index"]), node.get("op"))
        return (kind,) + tuple(
            (name, self.form(value))
            for name, value in sorted(node.items())
            if name not in IGNORED_KEYS and name != "type" and not name.lower().endswith("location") and not name.lower().endswith("locations")
        )
