"""Reads external-command definitions from the decompiled sources: enums, registration tables and handlers."""

from __future__ import annotations

import dataclasses
import re
from pathlib import Path

from .corpus import Kind


@dataclasses.dataclass(frozen=True)
class KindSource:
    """Where one script kind's external commands are declared, registered and implemented."""

    kind: Kind
    header: str
    enum: str
    prefix: str
    source: str
    table: str
    table_size: int
    namespace: str


KIND_SOURCES = {
    Kind.ACTION: KindSource(Kind.ACTION, "ps2/include/actscript.hpp", "ACTION_EXT_NUMBER", "ACTION_EXT_", "ps2/src/actscript.cpp", "ext_func_info", 256, "action"),
    Kind.EFFECT: KindSource(Kind.EFFECT, "ps2/include/effscript.hpp", "EffectExternalCommand", "EFF_EXT_", "ps2/src/effscript.cpp", "ext_func_info", 256, "effect"),
    Kind.MONSTER: KindSource(Kind.MONSTER, "ps2/include/runscript_opcodes.hpp", "RS_MONSTER_EXTFUNC", "RS_MONSTER_EXT_", "ps2/src/runscript_opcodes.cpp", "ext_func_info", 256, "monster"),
    Kind.EVENT: KindSource(Kind.EVENT, "ps2/include/event_func.hpp", "EventExternalCommand", "EVENT_EXT_", "ps2/src/event_func.cpp", "ext_func_info", 0x5DC, "event"),
    Kind.EVENT_ARG: KindSource(Kind.EVENT_ARG, "ps2/include/event_func.hpp", "EventArgumentCommand", "EVENT_ARG_", "ps2/src/event_func.cpp", "esa_ext_func_info", 3, "event_arg"),
}

_ENUM_ENTRY = re.compile(r"^\s*(\w+)\s*=\s*(-?(?:0x[0-9A-Fa-f]+|\d+))\s*,?\s*(?:/\*\*<\s*(.*?)\s*\*/)?\s*$")
_TABLE_ENTRY = re.compile(r"\{\s*(\w+)\s*,\s*(\w+)\s*\}")
_HANDLER = re.compile(r"^(?:static\s+)?int\s+(_\w+)\s*\(\s*RS_STACKDATA\s*\*\s*(\w*)\s*,\s*int\s*(\w*)\s*\)\s*\{", re.M)
_PROTOTYPE = re.compile(r"^(?:static\s+)?int\s+(_\w+)\s*\(\s*RS_STACKDATA\s*\*\s*\w*\s*,\s*int\s*\w*\s*\)\s*;", re.M)
_ACCESSORS = {
    "GetStackInt": ("in", "s32"),
    "rsGetStackInt": ("in", "s32"),
    "GetStackFloat": ("in", "f32"),
    "GetStackString": ("in", "string"),
    "GetStackVector": ("in", "f32"),
    "SetStack": ("out", None),
    "rsSetStack": ("out", "s32"),
    "SetStackVector": ("out", "f32"),
}
_ACCESSOR_CALL = re.compile(r"\b(" + "|".join(sorted(_ACCESSORS, key=len, reverse=True)) + r")\s*\(")
_DECLARATION = re.compile(r"\b(int|s32|u32|s16|u16|s8|u8|float|f32|char\s*\*|sceVu0FVECTOR|bool)\s+(\w+)\s*(\[[^\]]*\])?\s*[;=,)]")
_ARITY = re.compile(r"\b(argc|arg_count|count)\s*(==|!=|<=|>=|<|>)\s*(\d+)")
_CASE = re.compile(r"\bcase\s+(\d+)\s*:")


@dataclasses.dataclass
class EnumEntry:
    """One named command number from a kind's command enum."""

    name: str
    value: int
    comment: str


@dataclasses.dataclass
class SourceParam:
    """A handler argument position inferred from the order of its stack accessor calls."""

    position: int
    direction: str
    type: str | None
    name: str | None


@dataclasses.dataclass
class Handler:
    """A decompiled external-command handler."""

    name: str
    line: int
    description: str
    arity_checks: list[str]
    polymorphic: bool
    params: list[SourceParam]
    linear: bool
    params_by_arity: dict[int, list[SourceParam]] = dataclasses.field(default_factory=dict)


def parse_enum(text: str, enum: str) -> list[EnumEntry]:
    """Entries of a C enum with their one-line field comments."""
    match = re.search(r"\benum\s+" + re.escape(enum) + r"\s*\{(.*?)\n\};", text, re.S)
    if not match:
        raise ValueError(f"enum {enum} not found")
    entries = []
    for line in match.group(1).splitlines():
        entry = _ENUM_ENTRY.match(line)
        if entry:
            entries.append(EnumEntry(entry.group(1), int(entry.group(2), 0), entry.group(3) or ""))
    return entries


def parse_table(text: str, table: str) -> list[tuple[str, str]]:
    """(handler, enum name) pairs of an RS_EXTFUNC_INFO registration table, up to its NULL terminator."""
    match = re.search(r"\bRS_EXTFUNC_INFO\s+" + re.escape(table) + r"\s*\[[^\]]*\]\s*=\s*\{(.*?)\n\};", text, re.S)
    if not match:
        raise ValueError(f"table {table} not found")
    pairs = []
    for handler, number in _TABLE_ENTRY.findall(match.group(1)):
        if handler == "NULL":
            break
        pairs.append((handler, number))
    return pairs


def _doc_before(text: str, at: int) -> str:
    before = text[:at].rstrip()
    if not before.endswith("*/"):
        return ""
    start = before.rfind("/**")
    if start < 0:
        return ""
    lines = [line.strip().lstrip("*").strip() for line in before[start + 3:-2].splitlines()]
    return " ".join(line for line in lines if line and not line.startswith("@"))


def _body(text: str, open_brace: int) -> str:
    depth = 0
    for i in range(open_brace, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[open_brace + 1:i]
    return text[open_brace + 1:]


def _call_args(text: str, open_paren: int) -> tuple[list[str], int]:
    depth, args, current = 0, [], []
    for i in range(open_paren, len(text)):
        c = text[i]
        if c in "([{":
            depth += 1
            if depth == 1:
                continue
        elif c in ")]}":
            depth -= 1
            if depth == 0:
                args.append("".join(current).strip())
                return args, i + 1
        elif c == "," and depth == 1:
            args.append("".join(current).strip())
            current = []
            continue
        current.append(c)
    return args, len(text)


def _output_name(expression: str) -> str | None:
    expression = expression.strip()
    expression = re.sub(r"^\((?:int|float|s32|u32)\)\s*", "", expression)
    if re.fullmatch(r"-?[\d.]+f?", expression):
        return None
    simple = re.fullmatch(r"(?:\w+(?:->|\.))*(\w+)(?:\(\))?", expression)
    if simple:
        name = simple.group(1)
        return None if name in ("true", "false", "NULL") or not name[0].isalpha() else _snake(name)
    indexed = re.fullmatch(r"(?:\w+(?:->|\.))*(\w+)\[(\d)\]", expression)
    if indexed:
        return _snake(indexed.group(1)) + "_" + "xyzw"[int(indexed.group(2))] if int(indexed.group(2)) < 4 else None
    return None


def _snake(name: str) -> str:
    return re.sub(r"(?<=[a-z0-9])(?=[A-Z])", "_", name).lower()


def _expression_type(expression: str, declarations: dict[str, str]) -> str | None:
    expression = expression.strip()
    if re.fullmatch(r"-?\d+\.\d*f?|-?\d+f", expression) or expression.startswith("(float)") or "GetStackFloat" in expression:
        return "f32"
    if re.fullmatch(r"-?\d+", expression) or expression.startswith("(int)") or "GetStackInt" in expression:
        return "s32"
    base = re.match(r"(\w+)", expression)
    if base and base.group(1) in declarations and re.fullmatch(r"\w+(?:\[\w+\])?", expression):
        return declarations[base.group(1)]
    return None


def _accessor_params(body: str, stack: str, declarations: dict[str, str], position: int = 0) -> tuple[dict[int, SourceParam], bool, int]:
    """Argument positions a stretch of handler code reads and writes, walking its stack accessors in order."""
    params: dict[int, SourceParam] = {}
    linear = True
    events = [(call.start(), "call", call) for call in _ACCESSOR_CALL.finditer(body)]
    pointer_step = re.compile(r"(?<![\w>.])" + re.escape(stack) + r"\s*(\+\+|\+=\s*(\d+))\s*;|(?<![\w>.])\+\+\s*" + re.escape(stack) + r"\s*;")
    events += [(step.start(), "step", step) for step in pointer_step.finditer(body)]
    if re.search(r"(?<![\w>.])" + re.escape(stack) + r"\s*(?:-=|--|=[^=])", body):
        linear = False
    for _, what, item in sorted(events, key=lambda e: e[0]):
        if what == "step":
            position += int(item.group(2)) if item.group(2) else 1
            continue
        accessor = item.group(1)
        args, _ = _call_args(body, item.end() - 1)
        operand = next((i for i, a in enumerate(args) if re.search(r"(?<![\w>.])" + re.escape(stack) + r"\b", a)), None)
        if operand is None:
            continue
        expression = args[operand].replace(" ", "")
        if expression == stack:
            at, advance = position, 0
        elif expression == stack + "++":
            at, advance = position, 1
        elif re.fullmatch(re.escape(stack) + r"\+(\d+)", expression):
            at, advance = position + int(expression[len(stack) + 1:]), 0
        elif re.fullmatch(r"&" + re.escape(stack) + r"\[(\d+)\]", expression):
            at, advance = position + int(expression[len(stack) + 2:-1]), 0
        else:
            linear = False
            continue
        direction, c_type = _ACCESSORS[accessor]
        width = 3 if accessor in ("GetStackVector", "SetStackVector") else 1
        if accessor == "SetStack" and len(args) > 1:
            c_type = _expression_type(args[1], declarations)
        statement = body[: item.start()].rsplit(";", 1)[-1].rsplit("{", 1)[-1].rsplit("}", 1)[-1].rsplit(":", 1)[-1]
        assigned = re.search(r"(\w+)\s*(?:\[[^\]]*\])?\s*=\s*$", statement)
        other = args[1 - operand].strip() if len(args) > 1 else ""
        for k in range(width):
            if width == 3:
                label = _snake(other.strip("&* ")) + "_" + "xyz"[k] if re.fullmatch(r"&?\w+", other) else None
            elif direction == "in":
                label = _snake(assigned.group(1)) if assigned else None
            else:
                label = _output_name(args[1]) if len(args) > 1 else None
            slot = at + k
            if slot in params and (params[slot].direction != direction or params[slot].name != label):
                linear = False
            params.setdefault(slot, SourceParam(slot, direction, c_type, label))
        position += advance
    return params, linear, position


def _ordered(params: dict[int, SourceParam], linear: bool) -> tuple[list[SourceParam], bool]:
    ordered = [params[k] for k in sorted(params)]
    return ordered, linear and [p.position for p in ordered] == list(range(len(ordered)))


def parse_handler(text: str, match: re.Match) -> Handler:
    """Handler description, argument-count checks and accessor-derived parameters."""
    name, stack, argc = match.group(1), match.group(2) or "<unnamed stack>", match.group(3) or "<unnamed argc>"
    body = _body(text, match.end() - 1)
    line = text.count("\n", 0, match.start()) + 1
    declarations = {}
    for c_type, variable, _ in _DECLARATION.findall(body):
        c_type = c_type.replace(" ", "")
        declarations[variable] = {"float": "f32", "f32": "f32", "sceVu0FVECTOR": "f32", "char*": "string"}.get(c_type, "s32")
    checks = [f"{op} {n}" for var, op, n in _ARITY.findall(body) if var == argc]
    switch = re.search(r"switch\s*\(\s*" + re.escape(argc) + r"\s*\)\s*\{", body)
    by_arity: dict[int, list[SourceParam]] = {}
    if switch:
        cases = _body(body, switch.end() - 1)
        checks += [f"case {n}" for n in _CASE.findall(cases)]
        prefix, prefix_linear, start = _accessor_params(body[: switch.start()], stack, declarations)
        labels = list(re.finditer(r"\bcase\s+(\d+)\s*:|\bdefault\s*:", cases))
        pending = []
        for i, label in enumerate(labels):
            segment = cases[label.end(): labels[i + 1].start() if i + 1 < len(labels) else len(cases)]
            if label.group(1) is not None:
                pending.append(int(label.group(1)))
            if not segment.strip(" \t\r\n{}"):
                continue
            params, linear, _ = _accessor_params(segment, stack, declarations, start)
            ordered, linear = _ordered({**prefix, **params}, linear and prefix_linear)
            for arity in pending:
                if linear and len(ordered) == arity:
                    by_arity[arity] = ordered
            pending = []
        ordered, linear = [], False
    else:
        params, linear, _ = _accessor_params(body, stack, declarations)
        ordered, linear = _ordered(params, linear)
    return Handler(name, line, _doc_before(text, match.start()), checks, bool(switch), ordered, linear, by_arity)


def parse_handlers(text: str) -> dict[str, Handler]:
    """Every handler definition in a source file, by name, documented by its definition or its prototype."""
    handlers = {m.group(1): parse_handler(text, m) for m in _HANDLER.finditer(text)}
    for prototype in _PROTOTYPE.finditer(text):
        handler = handlers.get(prototype.group(1))
        if handler and not handler.description:
            handler.description = _doc_before(text, prototype.start())
    return handlers


def load(repo: Path, kind: Kind) -> tuple[KindSource, list[EnumEntry], list[tuple[str, str]], dict[str, Handler]]:
    """The enum, registration table and handlers of one script kind."""
    source = KIND_SOURCES[kind]
    header = (repo / source.header).read_text(encoding="utf-8")
    code = (repo / source.source).read_text(encoding="utf-8")
    return source, parse_enum(header, source.enum), parse_table(code, source.table), parse_handlers(code)
