"""Emission of structured script functions as one --!strict Luau module that follows the runtime contract.

Each function is printed from its structured IR with a precedence-aware printer. Values and conditions are printed
separately: a retail truth value is an integer, so a comparison used as a value becomes an if-expression, and a
boolean-typed variable is stored as a Luau boolean and converted back at each read.
"""

from __future__ import annotations

import dataclasses
import enum
import functools
import json
import math
import re
import struct
from collections.abc import Callable, Iterator
from pathlib import Path

from stb import opcodes

from . import api, ir, numbers

PROGRAMS = Path(__file__).resolve().parents[1] / "programs.json"
# Program number of the script's setup, which the engine runs when the script is loaded.
SETUP = -1


class EmitError(ValueError):
    """A construct that cannot be emitted as Luau."""


@dataclasses.dataclass(frozen=True)
class Handler:
    """A named program of one script kind: its number, handler name and description."""

    no: int
    name: str
    description: str


@functools.cache
def _handler_table() -> dict[str, dict[int, Handler]]:
    data = json.loads(PROGRAMS.read_text(encoding="utf-8"))
    return {
        kind: {entry["no"]: Handler(entry["no"], entry["name"], entry["description"]) for entry in info["programs"]}
        for kind, info in data["kinds"].items()
    }


def handlers(kind: str) -> dict[int, Handler]:
    """The named programs of a script kind, keyed by program number."""
    return _handler_table().get(kind, {})


class Prec(enum.IntEnum):
    """Luau operator precedence levels, lowest first."""

    IF = 0
    OR = 1
    AND = 2
    COMPARE = 3
    ADD = 4
    MUL = 5
    UNARY = 6
    ATOM = 7


# A printed expression with the precedence of its outermost operator.
Text = tuple[str, Prec]

_ANNOTATIONS = {ir.INT: "s32", ir.FLOAT: "f32", ir.STR: "string", ir.BOOL: "boolean", ir.ANY: "any"}
FRAME = ir.FRAME
# Slot spaces whose variables are tables: a local array, or the whole frame.
TABLE_SPACES = frozenset(("array", "frame"))
_DEFAULTS = {ir.STR: '""', ir.BOOL: "false"}
_COMPARISONS = {
    opcodes.Compare.EQ: "==",
    opcodes.Compare.NE: "~=",
    opcodes.Compare.LT: "<",
    opcodes.Compare.LE: "<=",
    opcodes.Compare.GT: ">",
    opcodes.Compare.GE: ">=",
}
_ESCAPES = {"\\": "\\\\", '"': '\\"', "\n": "\\n", "\r": "\\r", "\t": "\\t"}
_LUAU_RESERVED = frozenset(
    "and break continue do else elseif end false for function if in local nil not or repeat return then true until "
    "while export type".split()
)
_LUAU_BUILTINS = frozenset(
    "_ _G _VERSION vm print math bit32 string table coroutine utf8 os io debug error pcall xpcall select tostring "
    "tonumber assert require setmetatable getmetatable rawget rawset rawequal rawlen next pairs ipairs unpack load "
    "loadstring collectgarbage".split()
)
NUMERIC_TYPES = frozenset("s8 u8 s16 u16 s32 u32 f32".split())
# Expression types whose value may carry an integer tag, which a float load reinterprets bit for bit.
_MAYBE_INT = frozenset((ir.INT, ir.BOOL, ir.ANY))
_IDENTIFIER = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
_POSITIONAL = re.compile(r"(arg|out)\d+")


@dataclasses.dataclass
class FunctionInput:
    """One script function ready for emission."""

    block: int
    arg: int
    local: int
    slot_types: dict[ir.Slot, str]
    temps: list[str]
    body: list
    programs: list[int]
    is_main: bool
    refs: tuple[int, ...] = ()
    arrays: dict[ir.Slot, int] = dataclasses.field(default_factory=dict)


@dataclasses.dataclass
class ModuleInput:
    """One script ready for emission, with its globals and functions keyed by header block."""

    path: str
    kind: str
    globals: dict[ir.Slot, str]
    functions: dict[int, FunctionInput]
    expose_globals: bool = False
    libraries: dict[int, str] = dataclasses.field(default_factory=dict)
    returns_value: set[int] = dataclasses.field(default_factory=set)
    # For the differential harness: report the referenced values after each call that takes references.
    probe_refs: bool = False


@dataclasses.dataclass
class Module:
    """An emitted Luau module, the retail quirks it translates approximately, and the call offsets it probes."""

    text: str
    diagnostics: list[str]
    probes: list[int] = dataclasses.field(default_factory=list)


@dataclasses.dataclass
class _Plan:
    """A resolved external call: its Luau function, input arguments and by-reference outputs."""

    name: str
    ins: list
    outs: list[ir.Addr]
    out_names: list[str]
    comment: str
    diagnostics: list[str]
    dropped: bool = False
    inouts: list[ir.Addr] = dataclasses.field(default_factory=list)
    # Per output, the vm helper that reinterprets the bits the handler writes as the variable holds them, or None.
    conversions: list[str | None] = dataclasses.field(default_factory=list)


@dataclasses.dataclass
class _Usage:
    """Variables that one function mentions, reads, and receives through by-reference outputs."""

    mentioned: set[ir.Slot] = dataclasses.field(default_factory=set)
    reads: set[ir.Slot] = dataclasses.field(default_factory=set)
    out_names: dict[ir.Slot, set[str]] = dataclasses.field(default_factory=dict)
    temp_reads: set[int] = dataclasses.field(default_factory=set)
    loop_vars: set[ir.Slot] = dataclasses.field(default_factory=set)


def emit(module: ModuleInput, catalog: dict) -> Module:
    """Emits one script module from its structured functions and the command catalog."""
    return _Module(module, catalog).run()


def _bits_to_float(bits: int) -> float:
    return struct.unpack("<f", struct.pack("<I", bits & 0xFFFFFFFF))[0]


def nan_text(value: float) -> str:
    """A Luau expression for a float32 NaN with its sign and payload, which 0 / 0 would replace with the default NaN."""
    bits = struct.unpack("<I", struct.pack("<f", value))[0]
    return f'(string.unpack("<f", string.pack("<I4", {bits:#010x})))'


def _float_text(value: float) -> Text:
    if math.isnan(value):
        return nan_text(value), Prec.ATOM
    if math.isinf(value):
        return ("-math.huge", Prec.UNARY) if value < 0 else ("math.huge", Prec.ATOM)
    text = numbers.shortest(abs(value))
    if math.copysign(1.0, value) < 0:
        return f"-{text}", Prec.UNARY
    return text, Prec.ATOM


def _inexact_float(const: ir.Const) -> bool:
    """Whether a float constant's shortest spelling reads back in Luau as a double other than its float32."""
    if const.type != ir.FLOAT:
        return False
    value = float(const.value)
    return math.isfinite(value) and float(numbers.shortest(abs(value))) != abs(value)


def _string_text(raw: bytes) -> str:
    try:
        text = raw.decode("cp932")
    except UnicodeDecodeError as error:
        raise EmitError("string is not valid cp932") from error
    pieces = []
    for char in text:
        if char in _ESCAPES:
            pieces.append(_ESCAPES[char])
        elif ord(char) < 0x20 or ord(char) == 0x7F:
            pieces.append(f"\\{ord(char):03d}")
        else:
            pieces.append(char)
    return '"' + "".join(pieces) + '"'


def _const_text(const: ir.Const) -> Text:
    if const.type in (ir.INT, ir.BOOL):
        number = int(const.value)
        return str(number), (Prec.UNARY if number < 0 else Prec.ATOM)
    if const.type == ir.FLOAT:
        return _float_text(float(const.value))
    if const.type == ir.STR:
        if not isinstance(const.value, bytes):
            raise EmitError("string constant is not bytes")
        return _string_text(const.value), Prec.ATOM
    raise EmitError(f"unknown constant type {const.type}")


def _wrap(text: Text, minimum: int) -> str:
    return text[0] if text[1] >= minimum else f"({text[0]})"


def _infix(lhs: Text, op: str, rhs: Text, prec: Prec) -> Text:
    # Left-associative: the right operand needs a strictly higher precedence.
    return f"{_wrap(lhs, prec)} {op} {_wrap(rhs, prec + 1)}", prec


def _kind_mismatch(position: int, param_type: str, arg: ir.Expr) -> str | None:
    """Why a value argument's kind differs from its catalogued parameter type, or None when they agree."""
    if isinstance(arg, ir.Addr):
        return None
    if param_type == "string" and arg.type in (ir.INT, ir.FLOAT, ir.BOOL):
        return f"argument {position} is a number where the handler reads a string"
    if param_type in NUMERIC_TYPES and arg.type == ir.STR:
        return f"argument {position} is a string where the handler reads a number"
    return None


def _wrapper(expr: ir.Binary | ir.Unary) -> str:
    """The vm helper that wraps an operation marked to overflow: vm.i32 for integers, vm.wrap where it may hold a float."""
    if expr.type == ir.INT:
        return "vm.i32"
    if expr.type == ir.ANY:
        return "vm.wrap"
    raise EmitError(f"{expr.op} of {expr.type} values is marked to wrap")


def _nonnegative(expr: ir.Expr) -> bool:
    return isinstance(expr, ir.Const) and expr.type == ir.INT and expr.value >= 0


def _default(type_name: str) -> str:
    return _DEFAULTS.get(type_name, "0")


def _roots(stmts: list) -> Iterator[tuple[ir.Expr, bool]]:
    """Every expression of a statement list, paired with whether the call at its root has its result used."""
    for stmt in stmts:
        if isinstance(stmt, ir.Assign):
            yield stmt.value, True
            if isinstance(stmt.target, ir.Elem):
                yield stmt.target, True
        elif isinstance(stmt, ir.ExtCall):
            for arg in stmt.args:
                yield arg, True
        elif isinstance(stmt, ir.CallStmt):
            yield stmt.call, False
        elif isinstance(stmt, ir.Print):
            for arg in stmt.args:
                yield arg, True
        elif isinstance(stmt, ir.Return):
            yield stmt.value, True
        elif isinstance(stmt, ir.If):
            yield stmt.cond, True
            yield from _roots(stmt.then)
            yield from _roots(stmt.orelse)
        elif isinstance(stmt, ir.While):
            yield stmt.cond, True
            yield from _roots(stmt.body)
        elif isinstance(stmt, ir.Repeat):
            yield from _roots(stmt.body)
            yield stmt.cond, True
        elif isinstance(stmt, ir.NumericFor):
            yield stmt.start, True
            yield stmt.limit, True
            yield stmt.step, True
            yield from _roots(stmt.body)


def statements(stmts: list) -> Iterator:
    """Every statement of a statement list, including those nested in its branches and loops."""
    for stmt in stmts:
        yield stmt
        if isinstance(stmt, ir.If):
            yield from statements(stmt.then)
            yield from statements(stmt.orelse)
        elif isinstance(stmt, (ir.While, ir.Repeat, ir.NumericFor)):
            yield from statements(stmt.body)


def called_blocks(stmts: list) -> set[int]:
    """Blocks of the functions that a statement list calls, in any position."""
    return {sub.function for expr, _used in _roots(stmts) for sub in ir.walk(expr) if isinstance(sub, ir.Call)}


def used_call_blocks(stmts: list) -> set[int]:
    """Blocks of the functions whose return value a statement list uses in an expression."""
    blocks: set[int] = set()
    for expr, used in _roots(stmts):
        for sub in ir.walk(expr):
            if isinstance(sub, ir.Call) and (used or sub is not expr):
                blocks.add(sub.function)
    return blocks


def mentioned_slots(stmts: list) -> set[ir.Slot]:
    """Every variable slot a statement list reads, writes or passes by reference."""
    slots: set[ir.Slot] = set()
    for expr, _used in _roots(stmts):
        slots.update(ir.reads(expr))
    for stmt in statements(stmts):
        if isinstance(stmt, ir.Assign) and (target := ir.target_slot(stmt.target)) is not None:
            slots.add(target)
        elif isinstance(stmt, ir.NumericFor):
            slots.add(stmt.var)
    return slots


def emit_library(
    name: str,
    kind: str,
    function: FunctionInput,
    functions: dict[int, FunctionInput],
    libraries: dict[int, str],
    returns_value: bool,
    users: int,
    catalog: dict,
) -> Module:
    """Emits one shared helper as a module that returns the helper, requiring the shared helpers it calls."""
    module = ModuleInput(
        path=f"lib/{kind}/{name}",
        kind=kind,
        globals={},
        functions=functions,
        libraries=libraries,
        returns_value={function.block} if returns_value else set(),
    )
    return _Module(module, catalog).run_library(function, name, users)


def _mention(slot: ir.Slot, usage: _Usage, active: frozenset[ir.Slot], read: bool = False) -> None:
    # Inside its own loop, a control variable is the loop's local, so the use does not reach the function's variable.
    if slot in active:
        return
    usage.mentioned.add(slot)
    if read:
        usage.reads.add(slot)


def _read(expr: ir.Expr, usage: _Usage, active: frozenset[ir.Slot]) -> None:
    for sub in ir.walk(expr):
        if isinstance(sub, (ir.Var, ir.Addr)):
            _mention(sub.slot, usage, active, read=True)
        elif isinstance(sub, ir.Elem):
            _mention(sub.array, usage, active, read=True)
        elif isinstance(sub, ir.Temp):
            usage.temp_reads.add(sub.index)


def _write(target: ir.Slot | ir.Elem, usage: _Usage, active: frozenset[ir.Slot]) -> None:
    """Records a write: the variable or array is mentioned, and an element's index is read."""
    if isinstance(target, ir.Elem):
        _read(target.index, usage, active)
        _mention(target.array, usage, active)
    else:
        _mention(target, usage, active)


def _collect(
    mod: _Module, stmts: list, usage: _Usage, active: frozenset[ir.Slot] = frozenset(), keeps_return: bool = True
) -> None:
    """Records the variables a statement list mentions; active holds the loop variables of the enclosing loops.

    keeps_return is False for a helper whose return value nobody uses, so that a variable read only by its dropped
    return value is not declared.
    """
    for stmt in stmts:
        if isinstance(stmt, ir.Assign):
            _read(stmt.value, usage, active)
            if not isinstance(stmt.target, ir.Temp):
                _write(stmt.target, usage, active)
        elif isinstance(stmt, ir.ExtCall):
            plan = mod.resolve(stmt)
            if plan.dropped:
                continue
            for arg in plan.ins:
                # An in-out reference past the frame is passed as 0, so it reads no variable.
                if not (isinstance(arg, ir.Addr) and arg.slot[0] == "stack"):
                    _read(arg, usage, active)
            for out, name in zip(plan.outs, plan.out_names):
                if out.slot in active:
                    continue
                usage.mentioned.add(out.slot)
                if out.index is None:
                    usage.out_names.setdefault(out.slot, set()).add(name)
                else:
                    _read(out.index, usage, active)
        elif isinstance(stmt, ir.CallStmt):
            for arg in stmt.call.args:
                _read(arg, usage, active)
        elif isinstance(stmt, ir.Print):
            for arg in stmt.args:
                _read(arg, usage, active)
        elif isinstance(stmt, ir.Return):
            if keeps_return or ir.has_call(stmt.value):
                _read(stmt.value, usage, active)
        elif isinstance(stmt, ir.If):
            _read(stmt.cond, usage, active)
            _collect(mod, stmt.then, usage, active, keeps_return)
            _collect(mod, stmt.orelse, usage, active, keeps_return)
        elif isinstance(stmt, ir.While):
            _read(stmt.cond, usage, active)
            _collect(mod, stmt.body, usage, active, keeps_return)
        elif isinstance(stmt, ir.Repeat):
            _collect(mod, stmt.body, usage, active, keeps_return)
            _read(stmt.cond, usage, active)
        elif isinstance(stmt, ir.NumericFor):
            for expr in (stmt.start, stmt.limit, stmt.step):
                _read(expr, usage, active)
            if stmt.var[0] == "local":
                # The loop's own variable is not a mention; only its uses outside the loop are.
                usage.loop_vars.add(stmt.var)
                _collect(mod, stmt.body, usage, active | {stmt.var}, keeps_return)
            else:
                usage.mentioned.add(stmt.var)
                _collect(mod, stmt.body, usage, active, keeps_return)


def _keeps_return(mod: _Module, fn: FunctionInput) -> bool:
    """Whether a function's return statements keep their value: always for entries, for helpers when it is used."""
    return fn.is_main or bool(fn.programs) or fn.block in mod.used_returns


def _usage(mod: _Module, fn: FunctionInput) -> _Usage:
    """The variables a function mentions and reads, including the frame table its returned references live in."""
    usage = _Usage()
    _collect(mod, fn.body, usage, keeps_return=_keeps_return(mod, fn))
    if fn.refs and FRAME in fn.arrays:
        usage.mentioned.add(FRAME)
        usage.reads.add(FRAME)
    return usage


def _allocate_names(fn: FunctionInput, usage: _Usage, reserved: set[str]) -> dict[ir.Slot, str]:
    names: dict[ir.Slot, str] = {("local", n): f"arg{n}" for n in range(fn.arg)}
    for slot in usage.mentioned | usage.loop_vars:
        if slot[0] in ("local", "array") and slot[1] >= fn.arg:
            names[slot] = f"var{slot[1]}"
    if FRAME in fn.arrays:
        names[FRAME] = "frame"
    # A local written only as one catalogued, non-positional output takes that output's name.
    candidates: dict[ir.Slot, str] = {}
    for slot, found in usage.out_names.items():
        if slot[0] == "local" and slot[1] >= fn.arg and len(found) == 1:
            (name,) = found
            if _IDENTIFIER.fullmatch(name) and not _POSITIONAL.fullmatch(name):
                candidates[slot] = name
    taken = set(reserved) | {f"t{index}" for index in range(len(fn.temps))}
    taken |= {name for slot, name in names.items() if slot not in candidates}
    for slot in sorted(candidates, key=lambda s: s[1]):
        base = candidates[slot]
        name, suffix = base, 2
        while name in taken or name in _LUAU_RESERVED or name in _LUAU_BUILTINS:
            name = f"{base}_{suffix}"
            suffix += 1
        names[slot] = name
        taken.add(name)
    return names


def _effective(body: list) -> list:
    stmts = list(body)
    if stmts and isinstance(stmts[-1], ir.Return):
        value = stmts[-1].value
        if isinstance(value, ir.Const) and value.type == ir.INT and value.value == 0:
            stmts.pop()
    return stmts


def _direct_callee(body: list) -> int | None:
    stmts = _effective(body)
    if len(stmts) == 1 and isinstance(stmts[0], ir.CallStmt) and not stmts[0].call.args:
        return stmts[0].call.function
    return None


@dataclasses.dataclass
class _Module:
    """Module-wide state of one emission: the command table, function names and diagnostics."""

    module: ModuleInput
    catalog: dict
    kind_name: str = dataclasses.field(init=False)
    namespace: str = dataclasses.field(init=False)
    commands: dict[int, dict] = dataclasses.field(init=False)
    diagnostics: dict[str, None] = dataclasses.field(init=False, default_factory=dict)
    uses_vm: bool = dataclasses.field(init=False, default=False)
    names: dict[int, str] = dataclasses.field(init=False, default_factory=dict)
    used_returns: set[int] = dataclasses.field(init=False, default_factory=set)
    read_globals: set[int] = dataclasses.field(init=False, default_factory=set)
    used_libraries: set[str] = dataclasses.field(init=False, default_factory=set)
    handlers: dict[int, Handler] = dataclasses.field(init=False, default_factory=dict)
    probes: set[int] = dataclasses.field(init=False, default_factory=set)

    def __post_init__(self) -> None:
        kind = self.catalog["kinds"].get(self.module.kind)
        if kind is None:
            raise EmitError(f"unknown script kind {self.module.kind}")
        self.kind_name = self.module.kind
        self.handlers = handlers(self.kind_name)
        self.namespace = kind["namespace"]
        self.commands = {command["no"]: command for command in kind["commands"]}

    def function(self, block: int) -> FunctionInput:
        """The function whose header block is given."""
        try:
            return self.module.functions[block]
        except KeyError:
            raise EmitError(f"call to unknown function {block:#x}") from None

    def function_name(self, block: int) -> str:
        """The Luau name of an emitted function."""
        try:
            name = self.names[block]
        except KeyError:
            raise EmitError(f"function {block:#x} is not emitted") from None
        if block in self.module.libraries:
            self.used_libraries.add(name)
        return name

    def diagnose(self, message: str) -> None:
        """Records a retail quirk that was translated approximately."""
        self.diagnostics.setdefault(message)

    def run(self) -> Module:
        """Emits the whole module."""
        functions = self.module.functions
        mains = [fn for fn in functions.values() if fn.is_main]
        if len(mains) > 1:
            raise EmitError("more than one main function")
        # Handler number to header block; the setup is numbered SETUP.
        targets: dict[int, int] = {}
        if mains:
            targets[SETUP] = mains[0].block
        for fn in sorted(functions.values(), key=lambda f: f.block):
            if fn.refs and (fn.is_main or fn.programs):
                raise EmitError(f"entry function {fn.block:#x} takes references")
            for number in fn.programs:
                if number in targets:
                    raise EmitError(f"program {number} has more than one entry")
                targets[number] = fn.block
        owners: dict[int, list[int]] = {}
        for number in sorted(targets):
            owners.setdefault(targets[number], []).append(number)
        order = self._post_order(list(owners))
        called: set[int] = set()
        for block in order:
            called |= called_blocks(self.function(block).body)

        for block in order:
            if block in self.module.libraries:
                if block in owners:
                    raise EmitError(f"shared function {block:#x} is a main or program entry")
                self.names[block] = self.module.libraries[block]
            elif block in owners:
                self.names[block] = self._local_name(owners[block][0])
            else:
                self.names[block] = f"helper_{block:x}"
        # A program whose body only calls one helper is assigned that helper, unless other functions call it.
        direct: dict[int, int] = {}
        for block in order:
            fn = self.function(block)
            if block in self.module.libraries or fn.is_main or block not in owners or block in called:
                continue
            callee = _direct_callee(fn.body)
            if callee is not None:
                direct[block] = callee
        # Shared functions are defined by their library, so only the local ones are emitted here.
        local = [
            block
            for block in order
            if block not in self.module.libraries
            and block not in direct
            and (block not in owners or block in called or len(owners[block]) > 1)
        ]
        inline = [
            block
            for block in order
            if block not in self.module.libraries and block not in direct and block not in local
        ]
        self.used_returns |= set(self.module.returns_value)
        for block in order:
            if block not in self.module.libraries:
                self.used_returns |= used_call_blocks(self.function(block).body)

        usages = {block: _usage(self, self.function(block)) for block in local + inline}
        global_numbers = {slot[1] for u in usages.values() for slot in u.mentioned if slot[0] == "global"}
        global_numbers |= {slot[1] for slot in self.module.globals}
        self.read_globals = {slot[1] for u in usages.values() for slot in u.reads if slot[0] == "global"}
        reserved = set(self.names.values()) | {f"global{n}" for n in global_numbers}
        reserved |= {self.namespace, "script"} | _LUAU_RESERVED | _LUAU_BUILTINS

        texts: dict[int, list[str]] = {}
        for block in local:
            texts[block] = _Function(
                self, self.function(block), usages[block], reserved, f"local function {self.names[block]}",
                self._doc(owners.get(block, [])),
            ).lines()
        for block in inline:
            fn = self.function(block)
            number = owners[block][0]
            field = self._field(number)
            named = self._handler_name(number) is not None
            head = f"function {field}" if named else f"{field} = function"
            doc = self._doc([number])
            if number != SETUP and not _effective(fn.body):
                doc.append("-- Defined empty, so the engine runs this instead of its default.")
            texts[block] = _Function(self, fn, usages[block], reserved, head, doc).lines()
        declared_globals = sorted(n for n in global_numbers if self.global_declared(n))

        handler_sections: list[list[str]] = []
        for number in sorted(targets):
            block = targets[number]
            if block in direct:
                callee = self.function_name(direct[block])
                handler_sections.append([*self._doc([number]), f"{self._field(number)} = {callee}"])
            elif block in local:
                handler_sections.append([f"{self._field(number)} = {self.names[block]}"])
            else:
                handler_sections.append(texts[block])
        tail = []
        if self.module.expose_globals:
            items = ", ".join(f"global{n}" for n in sorted(global_numbers))
            listed = f"{{ {items} }}" if items else "{}"
            tail.append(f"script.__globals = function() return {listed} end")

        header = [
            "--!strict",
            f"-- {self.module.path}: {self.module.kind} script, translated from the NTSC-timed bytecode by "
            "tools/luau/stb2luau.",
        ]
        sections: list[list[str]] = []
        requires = ['local vm = require("@lib/vm")'] if self.uses_vm else []
        requires += [f'local {name} = require("@lib/{self.kind_name}/{name}")' for name in sorted(self.used_libraries)]
        if requires:
            sections.append(requires)
        if declared_globals:
            sections.append([
                f"local global{n}: {_ANNOTATIONS[self._global_type(n)]} = {_default(self._global_type(n))}"
                for n in declared_globals
            ])
        sections += [texts[block] for block in local]
        sections.append(["local script = {}"])
        sections += handler_sections
        if tail:
            sections.append(tail)
        sections.append(["return script"])

        lines = list(header)
        for section in sections:
            lines.append("")
            lines.extend(section)
        return Module("\n".join(lines) + "\n", list(self.diagnostics), sorted(self.probes))

    def run_library(self, function: FunctionInput, name: str, users: int) -> Module:
        """Emits a shared helper as a module that returns it, requiring the shared helpers it calls."""
        if function.is_main or function.programs:
            raise EmitError("a shared function must be an ordinary helper")
        self.names[function.block] = name
        for block in self._post_order([function.block]):
            if block == function.block:
                continue
            if block not in self.module.libraries:
                raise EmitError(f"shared function {function.block:#x} calls {block:#x}, which is not shared")
            self.names[block] = self.module.libraries[block]
        self.used_returns = set(self.module.returns_value)
        usage = _usage(self, function)
        reserved = set(self.names.values()) | {self.namespace} | _LUAU_RESERVED | _LUAU_BUILTINS
        body = _Function(self, function, usage, reserved, f"local function {name}", ["--- Helper function."]).lines()
        requires = ['local vm = require("@lib/vm")'] if self.uses_vm else []
        requires += [f'local {dep} = require("@lib/{self.kind_name}/{dep}")' for dep in sorted(self.used_libraries)]
        header = [
            "--!strict",
            f"-- Shared {self.kind_name} helper used by {users} scripts, translated by tools/luau/stb2luau.",
        ]
        sections = [requires, body, [f"return {name}"]] if requires else [body, [f"return {name}"]]
        lines = list(header)
        for section in sections:
            lines.append("")
            lines.extend(section)
        return Module("\n".join(lines) + "\n", list(self.diagnostics))

    def resolve(self, stmt: ir.ExtCall, type_of: Callable[[ir.Expr], str] | None = None) -> _Plan:
        """Maps an external call to its Luau function, input arguments and by-reference outputs.

        type_of gives an argument's type at the call site; a command whose handler reads a parameter's integer or float
        tag is then called through the variant for the type of its first tagged argument.
        """
        args = list(stmt.args)
        number = ir.Const(stmt.command, ir.INT)
        command = self.commands.get(stmt.command)
        if command is None:
            message = f"command {stmt.command} is not registered by {self.kind_name} scripts"
            return _Plan(
                f"{self.namespace}.Ext",
                [number, *args],
                [],
                [],
                f"retail: command {stmt.command} is not registered",
                [message],
            )
        luau = command["luau"]
        signature = next((s for s in command["signatures"] if s["argc"] == len(args)), None)
        if signature is None or len(signature["params"]) != len(args):
            return _Plan(
                f"{self.namespace}.Ext",
                [number, *args],
                [],
                [],
                f"retail: {len(args)} arguments are not catalogued for {luau}",
                [f"{len(args)} arguments to {luau} are not catalogued"],
            )
        ins: list = []
        outs: list[ir.Addr] = []
        out_names: list[str] = []
        inouts: list[ir.Addr] = []
        diagnostics: list[str] = []
        clauses: list[str] = []
        mismatched = False
        refs_as_values: list[int] = []
        for position, (param, arg) in enumerate(zip(signature["params"], args), 1):
            if param["dir"] in api.OUTPUTS:
                if isinstance(arg, ir.Addr):
                    # An in-out reference passes the variable's value in as well.
                    if param["dir"] == "inout":
                        ins.append(arg)
                        inouts.append(arg)
                    outs.append(arg)
                    out_names.append(param["name"])
                else:
                    diagnostics.append(f"value passed as output of {luau}")
                    clauses.append(
                        f"argument {position} is a value where the handler writes an output; "
                        "the output is discarded"
                    )
            else:
                if isinstance(arg, ir.Addr):
                    diagnostics.append(f"reference passed as input to {luau}")
                    clauses.append(f"argument {position} passes a reference where the handler reads a value")
                    refs_as_values.append(position)
                mismatch = _kind_mismatch(position, param["type"], arg)
                if mismatch is not None:
                    mismatched = True
                    diagnostics.append(mismatch)
                    clauses.append(mismatch)
                ins.append(arg)
        comment = f"retail: {'; '.join(clauses)}" if clauses else ""
        if signature.get("handler_rejects"):
            # The typed entry point does not fit the arguments these scripts pass, so the raw command is used.
            return _Plan(
                f"{self.namespace}.Ext",
                [number, *args],
                [],
                [],
                f"retail: the handler rejects {len(args)} arguments",
                [],
            )
        if mismatched:
            # The handler reads a string's pointer as a number, or a number as a string's pointer, which on the PC are the
            # bits of an address: the interpreter keeps the script.
            raise EmitError(f"{luau}: {'; '.join(diagnostics)}; the interpreter reads an address there")
        if api.ignores_reference(signature, args, lambda arg: isinstance(arg, ir.Addr)):
            # The handler stores a tagged input only when it holds an integer or a float, so retail did nothing.
            name = f"{self.namespace}.{self._dispatch_name(command, signature)}"
            message = f"reference passed as the value {luau} stores"
            return _Plan(name, args, [], [], "", [message], dropped=True)
        if refs_as_values:
            # The handler reads the reference's slot as a value: on the PC, the low bits of the variable's address.
            positions = ", ".join(map(str, refs_as_values))
            raise EmitError(f"{luau}: argument {positions} passes a reference the handler reads as a value, an address")
        variant, conversions = self._typing(command, signature, args, stmt.tags, type_of)
        name = f"{self.namespace}.{self._dispatch_name(command, signature)}"
        default = next((param["type"] for param in signature["params"] if param.get("tagged")), None)
        if variant is not None and variant != default:
            variants = [sig for sig in command["signatures"] if api.tagged(sig)]
            suffixed = {**command, "luau": luau + api.VARIANTS[variant], "signatures": variants}
            name = f"{self.namespace}.{self._dispatch_name(suffixed, signature)}"
        out_conversions = [
            conversions.get(position)
            for position, (param, arg) in enumerate(zip(signature["params"], args), 1)
            if param["dir"] in api.OUTPUTS and isinstance(arg, ir.Addr)
        ]
        return _Plan(name, ins, outs, out_names, comment, diagnostics, inouts=inouts, conversions=out_conversions)

    def _typing(
        self, command: dict, signature: dict, args: list, tags: tuple, type_of: Callable[[ir.Expr], str] | None
    ) -> tuple[str | None, dict[int, str]]:
        """The type a call gives its tagged parameters, and the reinterpretation of each output it writes.

        A native output writes its bits without retagging the variable, so the script reads them as its loads say. The
        tag analysis (tags) gives, per output, how every read of the written value interprets it; the module's variable
        holds one interpretation, its type, so a write of the other type is reinterpreted (vm.bits_float or
        vm.float_bits), and a value the script reads both ways, or that the analysis cannot follow, is refused. A tagged
        handler branches on its input's tags, or on the tag its destination holds: these must be known.
        """
        luau = command["luau"]
        params = signature["params"]
        info = dict(enumerate(tags, 1)) if tags else {}

        def single(found: tuple, what: str) -> str:
            kinds = set(found)
            if kinds == {"int"}:
                return "s32"
            if kinds == {"float"}:
                return "f32"
            raise EmitError(f"{luau}: {what} may be {' or '.join(sorted(kinds)) or 'unknown'}, on which its handler branches")

        def held(arg: ir.Expr) -> str | None:
            kind = type_of(arg) if type_of is not None else None
            return "f32" if kind == ir.FLOAT else "s32" if kind in (ir.INT, ir.BOOL) else None

        variant = None
        positions = list(enumerate(params, 1))
        tagged_in = [position for position, param in positions if param.get("tagged") and param["dir"] == "in"]
        tagged_out = [position for position, param in positions if param.get("tagged") and param["dir"] in api.OUTPUTS]
        if tagged_in:
            position = tagged_in[0]
            entry = info.get(position)
            if entry is not None:
                variant = single(entry[1], f"argument {position}")
            elif type_of is not None:
                variant = "f32" if type_of(args[position - 1]) == ir.FLOAT else "s32"
        elif tagged_out and isinstance(args[tagged_out[0] - 1], ir.Addr):
            position = tagged_out[0]
            entry = info.get(position)
            if params[position - 1].get("copies"):
                # Either branch copies the same bits (VPop, GetValue), so the variant reads them as the variable holds
                # them; the handler writes only into an integer or a float.
                if entry is not None and not set(entry[1]) <= {"int", "float"}:
                    single(entry[1], f"the variable argument {position} names")
                variant = (held(args[position - 1]) if type_of is not None else None) or params[position - 1]["type"]
            elif entry is not None:
                variant = single(entry[1], f"the variable argument {position} names")
            elif type_of is not None:
                variant = held(args[position - 1]) or params[position - 1]["type"]
        conversions: dict[int, str] = {}
        if type_of is None:
            # Usage collection needs only the arguments; the function's emission decides the typing.
            return variant, conversions
        for position, param in positions:
            arg = args[position - 1]
            if param["dir"] not in api.OUTPUTS or not isinstance(arg, ir.Addr) or param["type"] == "string":
                continue
            written = variant if param.get("tagged") and variant else ("f32" if param["type"] == "f32" else "s32")
            target = held(arg)
            entry = info.get(position)
            reads = set(entry[2]) if entry is not None and entry[0] == "ref" else set()
            if reads:
                wanted = {"f32": "float", "s32": "int"}.get(target or "")
                if wanted is None or reads != {wanted}:
                    raise EmitError(
                        f"{luau}: the script reads what argument {position} receives as {' and '.join(sorted(reads))}, "
                        f"where its variable holds {target or 'an unknown type'}"
                    )
            if target is not None and written != target:
                conversions[position] = "vm.bits_float" if written == "s32" else "vm.float_bits"
        return variant, conversions

    def _dispatch_name(self, command: dict, signature: dict) -> str:
        # The unsuffixed name dispatches on the input count, so it is used only when no other signature of the
        # command takes the same number of inputs.
        def inputs(sig: dict) -> int:
            return sum(param["dir"] != "out" for param in sig["params"])

        same = [sig for sig in command["signatures"] if inputs(sig) == inputs(signature)]
        if len(same) == 1:
            return command["luau"]
        return f"{command['luau']}_{signature['argc']}"

    def _global_type(self, number: int) -> str:
        return self.module.globals.get(("global", number), ir.ANY)

    def global_declared(self, number: int) -> bool:
        """Whether a global has a module-level declaration: all of them when exposed, else the ones read."""
        return self.module.expose_globals or number in self.read_globals

    def _handler_name(self, number: int) -> str | None:
        if number == SETUP:
            return "setup"
        info = self.handlers.get(number)
        return info.name if info is not None else None

    def _local_name(self, number: int) -> str:
        return self._handler_name(number) or f"program_{number}"

    def _field(self, number: int) -> str:
        name = self._handler_name(number)
        return f"script.{name}" if name is not None else f"script[{number}]"

    def _doc(self, numbers_: list[int]) -> list[str]:
        if not numbers_:
            return ["--- Helper function."]
        return [self._doc_line(number) for number in numbers_]

    def _doc_line(self, number: int) -> str:
        if number == SETUP:
            return "--- Runs when the script is loaded, before any program."
        info = self.handlers.get(number)
        return f"--- {info.description}" if info is not None else f"--- Program {number}."

    def _post_order(self, roots: list[int]) -> list[int]:
        order: list[int] = []
        finished: set[int] = set()
        active: set[int] = set()

        def visit(block: int) -> None:
            if block in finished:
                return
            if block in active:
                raise EmitError("recursive script functions are unsupported")
            active.add(block)
            for expr, _used in _roots(self.function(block).body):
                for sub in ir.walk(expr):
                    if isinstance(sub, ir.Call):
                        visit(sub.function)
            active.discard(block)
            finished.add(block)
            order.append(block)

        for root in roots:
            visit(root)
        return order


class _Function:
    """Emission of one function: its names, variable scopes and statements."""

    def __init__(
        self, mod: _Module, fn: FunctionInput, usage: _Usage, reserved: set[str], head: str, doc: list[str]
    ) -> None:
        self.mod = mod
        self.fn = fn
        self.head = head
        self.doc = doc
        self.reads = usage.reads
        self.temp_reads = usage.temp_reads
        self.names = _allocate_names(fn, usage, reserved)
        self.declared_slots = sorted(
            (
                slot
                for slot in usage.reads
                if (slot[0] == "local" and slot[1] >= fn.arg) or slot[0] in TABLE_SPACES
            ),
            key=lambda slot: (slot[0] != "frame", slot[1]),
        )
        # A loop variable read outside its loop shares a name with the declaration, so the loop uses a distinct one.
        # A value written outside the loop and never read there is dead, since the loop sets the variable itself.
        self.renamed_loops = {slot for slot in usage.loop_vars if slot in usage.reads}
        # Control variables of the loops being printed, mapped to the names they take inside those loops.
        self.active_loops: dict[ir.Slot, str] = {}
        self.scopes: list[set[int]] = [set()]
        # Retail quirks found while printing the current statement, which its first line notes.
        self.notes: list[str] = []
        if fn.is_main:
            self.role = "main"
        elif fn.programs:
            self.role = "program"
        else:
            self.role = "helper"

    # Names and types.

    def name_of(self, slot: ir.Slot) -> str:
        """The Luau name of a variable slot."""
        if slot in self.active_loops:
            return self.active_loops[slot]
        if slot[0] == "global":
            return f"global{slot[1]}"
        try:
            return self.names[slot]
        except KeyError:
            raise EmitError(f"variable {slot} has no name") from None

    def loop_name(self, slot: ir.Slot) -> str:
        """The name a NumericFor gives its control variable: distinct from the function's variable when both exist."""
        name = self.name_of(slot)
        if slot in self.renamed_loops:
            return f"{name}_i"
        return name

    def temp_name(self, index: int) -> str:
        """The Luau name of a temporary that is visible at this point."""
        if not any(index in scope for scope in self.scopes):
            raise EmitError(f"temp t{index} is read outside its assignment scope")
        return f"t{index}"

    def declared(self, slot: ir.Slot) -> bool:
        """Whether a variable has a Luau declaration here, so that a value written to it is kept."""
        if slot[0] == "global":
            return self.mod.global_declared(slot[1])
        if slot[0] == "local" and (slot in self.active_loops or slot[1] < self.fn.arg):
            return True
        return slot in self.reads

    def slot_type(self, slot: ir.Slot) -> str:
        """The storage type of a variable slot."""
        if slot in self.fn.slot_types:
            return self.fn.slot_types[slot]
        return self.mod.module.globals.get(slot, ir.ANY)

    def temp_type(self, index: int) -> str:
        """The storage type of a temporary."""
        return self.fn.temps[index] if index < len(self.fn.temps) else ir.ANY

    def expr_type(self, expr: ir.Expr) -> str:
        """The type of an expression, using the storage type of variables."""
        if isinstance(expr, ir.Addr) and expr.index is not None:
            return expr.type
        if isinstance(expr, (ir.Var, ir.Addr)):
            return self.slot_type(expr.slot)
        if isinstance(expr, ir.Temp):
            return self.temp_type(expr.index)
        return expr.type

    def may_be_int(self, expr: ir.Expr) -> bool:
        """Whether a value may carry an integer tag: arithmetic with a float operand always yields a float."""
        if isinstance(expr, ir.Binary) and expr.op in ("add", "sub", "mul", "div"):
            if ir.FLOAT in (self.expr_type(expr.lhs), self.expr_type(expr.rhs)):
                return False
        return self.expr_type(expr) in _MAYBE_INT

    def _variable(self, expr: ir.Expr) -> tuple[str, str]:
        if isinstance(expr, ir.Temp):
            return self.temp_name(expr.index), self.temp_type(expr.index)
        if isinstance(expr, ir.Elem):
            return self.element(expr.array, expr.index), expr.type
        if isinstance(expr, ir.Addr) and expr.index is not None:
            return self.element(expr.slot, expr.index), expr.type
        return self.name_of(expr.slot), self.slot_type(expr.slot)

    def element(self, array: ir.Slot, index: ir.Expr) -> str:
        """An element of an array's or the frame's table, whose first element is at 1."""
        name = self.name_of(array)
        if array == FRAME and not isinstance(index, ir.Const):
            # Only a frame holds an index that may leave it; vm.index raises an error there.
            text = self._call_text("vm.index", self.value(index)[0], str(self.fn.arrays[FRAME]))[0]
        else:
            text = self.value(ir.add_const(index, 1))[0]
        return f"{name}[{text}]"

    def target_text(self, ref: ir.Addr) -> str:
        """The assignable text of a variable or element that a reference names."""
        if ref.index is not None:
            return self.element(ref.slot, ref.index)
        return self.name_of(ref.slot)

    def ref_value(self, param: int) -> str:
        """The current value of a reference parameter, which a frame table holds when the function has one."""
        if FRAME in self.fn.arrays:
            return self.element(FRAME, ir.Const(param, ir.INT))
        return self.name_of(("local", param))

    def _call_text(self, name: str, *args: str) -> Text:
        if name.startswith("vm."):
            self.mod.uses_vm = True
        return f"{name}({', '.join(args)})", Prec.ATOM

    def function_call(self, expr: ir.Call) -> Text:
        """A call of a script function, passing boolean parameters as booleans."""
        callee = self.mod.function(expr.function)
        args = []
        for index, arg in enumerate(expr.args):
            if index in callee.refs:
                args.append(self.value(arg)[0])
                continue
            if index < callee.arg and callee.slot_types.get(("local", index)) == ir.BOOL:
                args.append(self.cond(arg)[0])
            elif (
                callee.slot_types.get(("local", index)) == ir.FLOAT
                and isinstance(arg, ir.Const)
                and arg.type == ir.INT
                and arg.value != 0
            ):
                # The callee loads the parameter as a float, which reinterprets the integer's bits.
                args.append(_float_text(_bits_to_float(arg.value))[0])
                self.notes.append(f"the integer {arg.value} is passed where the callee reads a float, so it reads its bits")
            elif callee.slot_types.get(("local", index)) == ir.FLOAT and self.may_be_int(arg):
                raise EmitError(
                    f"a value that may be an integer is passed to parameter {index} of {self.mod.function_name(expr.function)}, "
                    "which the callee loads as a float"
                )
            else:
                args.append(self.value(arg)[0])
        return self._call_text(self.mod.function_name(expr.function), *args)

    # Expressions.

    def is_boolish(self, expr: ir.Expr) -> bool:
        """Whether an expression is a truth value that prints best as a condition."""
        if isinstance(expr, ir.Compare):
            return True
        if isinstance(expr, ir.Unary):
            return expr.op == "not"
        if isinstance(expr, ir.Logical):
            return self.is_boolish(expr.rhs)
        if isinstance(expr, ir.Binary) and expr.op in ("band", "bor"):
            return self.is_boolish(expr.lhs) and self.is_boolish(expr.rhs) and not ir.has_call(expr)
        return False

    def cond(self, expr: ir.Expr) -> Text:
        """An expression in condition context, yielding a Luau boolean."""
        if self.is_boolish(expr):
            return self._boolish(expr)
        if isinstance(expr, ir.Const) and expr.type in (ir.INT, ir.BOOL):
            return ("true" if expr.value != 0 else "false"), Prec.ATOM
        if isinstance(expr, (ir.Var, ir.Addr, ir.Temp, ir.Elem)):
            name, storage = self._variable(expr)
            if storage == ir.BOOL:
                return name, Prec.ATOM
        if self.expr_type(expr) in (ir.FLOAT, ir.STR):
            self.mod.diagnose("condition on a float/string value is always true")
            return "true", Prec.ATOM
        return _infix(self.value(expr), "~=", ("0", Prec.ATOM), Prec.COMPARE)

    def _boolish(self, expr: ir.Expr) -> Text:
        if isinstance(expr, ir.Compare):
            return _infix(self.value(expr.lhs), _COMPARISONS[expr.op], self.value(expr.rhs), Prec.COMPARE)
        if isinstance(expr, ir.Unary):
            operand = expr.operand
            if self.is_boolish(operand):
                return f"not {_wrap(self.cond(operand), Prec.UNARY)}", Prec.UNARY
            return _infix(self.value(operand), "==", ("0", Prec.ATOM), Prec.COMPARE)
        if isinstance(expr, ir.Binary):
            conjunctive, lhs, rhs = expr.op == "band", expr.lhs, expr.rhs
        else:
            conjunctive, lhs, rhs = expr.op == "and", expr.lhs, expr.rhs
        prec = Prec.AND if conjunctive else Prec.OR
        word = "and" if conjunctive else "or"
        return f"{_wrap(self.cond(lhs), prec)} {word} {_wrap(self.cond(rhs), prec + 1)}", prec

    def value(self, expr: ir.Expr) -> Text:
        """An expression in value context, yielding a retail integer or float."""
        if self.is_boolish(expr):
            return f"if {self.cond(expr)[0]} then 1 else 0", Prec.IF
        if isinstance(expr, ir.Const):
            # A float constant takes its float32 value, as the PS2 holds it, where the spelling reads as another double.
            if _inexact_float(expr):
                return self._call_text("vm.f32", _const_text(expr)[0])
            return _const_text(expr)
        if isinstance(expr, (ir.Var, ir.Addr, ir.Temp, ir.Elem)):
            name, storage = self._variable(expr)
            if storage == ir.BOOL:
                return f"if {name} then 1 else 0", Prec.IF
            return name, Prec.ATOM
        if isinstance(expr, ir.Unary):
            return self._unary(expr)
        if isinstance(expr, ir.Binary):
            return self._binary(expr)
        if isinstance(expr, ir.Logical):
            if expr.op == "and":
                return f"if {self.cond(expr.lhs)[0]} then {self.value(expr.rhs)[0]} else 0", Prec.IF
            if expr.op == "or":
                return f"if {self.cond(expr.lhs)[0]} then 1 else {self.value(expr.rhs)[0]}", Prec.IF
            raise EmitError(f"unknown logical operator {expr.op}")
        if isinstance(expr, ir.Call):
            if self.mod.function(expr.function).refs:
                raise EmitError("a call that copies references back is used inside an expression")
            return self.function_call(expr)
        raise EmitError(f"unknown expression {type(expr).__name__}")

    def _unary(self, expr: ir.Unary) -> Text:
        operand = expr.operand
        if expr.op == "neg":
            inner = _wrap(self.value(operand), Prec.UNARY)
            if inner.startswith("-"):
                inner = f"({inner})"
            if expr.wrap:
                # -(-2^31) overflows, and the PS2 wraps it back to -2^31.
                return self._call_text(_wrapper(expr), f"-{inner}")
            return f"-{inner}", Prec.UNARY
        if expr.op == "itof":
            return self.value(operand)
        if expr.op == "ftoi":
            if self.expr_type(operand) == ir.INT:
                return self.value(operand)
            return self._call_text("vm.ftoi", self.value(operand)[0])
        if expr.op in ("sin", "cos"):
            return self._call_text(f"vm.{expr.op}", self.value(operand)[0])
        raise EmitError(f"unknown unary operator {expr.op}")

    def _binary(self, expr: ir.Binary) -> Text:
        text = self._binary_text(expr)
        # The PS2 rounds every float operation to float32; Luau computes in double, so the result is rounded the same.
        if expr.type == ir.FLOAT and expr.op in ("add", "sub", "mul", "div"):
            return self._call_text("vm.f32", text[0])
        return text

    def _binary_text(self, expr: ir.Binary) -> Text:
        lhs, rhs = self.value(expr.lhs), self.value(expr.rhs)
        both_int = self.expr_type(expr.lhs) == ir.INT and self.expr_type(expr.rhs) == ir.INT
        # An integer operation the lifter could not keep inside 32 bits wraps, as on the PS2.
        if expr.op == "add":
            total = _infix(lhs, "+", rhs, Prec.ADD)
            return self._call_text(_wrapper(expr), total[0]) if expr.wrap else total
        if expr.op == "sub":
            difference = _infix(lhs, "-", rhs, Prec.ADD)
            return self._call_text(_wrapper(expr), difference[0]) if expr.wrap else difference
        if expr.op == "mul":
            product = _infix(lhs, "*", rhs, Prec.MUL)
            if expr.wrap:
                return self._call_text(_wrapper(expr), product[0])
            if both_int and not isinstance(expr.lhs, ir.Const) and not isinstance(expr.rhs, ir.Const):
                return self._call_text("vm.i32", product[0])
            return product
        if expr.op == "div":
            if both_int:
                return self._call_text("vm.idiv", lhs[0], rhs[0])
            if isinstance(expr.rhs, ir.Const) and (expr.rhs.value != 0 or math.copysign(1.0, expr.rhs.value) < 0):
                return _infix(lhs, "/", rhs, Prec.MUL)
            # Retail exits when the divisor's bits are zero, which a variable may hold.
            return self._call_text("vm.fdiv", lhs[0], rhs[0])
        if expr.op == "mod":
            return self._call_text("vm.imod", lhs[0], rhs[0])
        if expr.op == "band":
            masked = self._call_text("bit32.band", lhs[0], rhs[0])
            if _nonnegative(expr.lhs) or _nonnegative(expr.rhs):
                return masked
            return self._call_text("vm.i32", masked[0])
        if expr.op == "bor":
            joined = self._call_text("bit32.bor", lhs[0], rhs[0])
            if _nonnegative(expr.lhs) and _nonnegative(expr.rhs):
                return joined
            return self._call_text("vm.i32", joined[0])
        raise EmitError(f"unknown binary operator {expr.op}")

    # Statements.

    def block(self, stmts: list, depth: int, tail: bool = False) -> list[str]:
        """The lines of a statement list at one indentation depth; tail marks a list that ends the function."""
        lines: list[str] = []
        for index, stmt in enumerate(stmts):
            last = index == len(stmts) - 1
            lines += self.statement(stmt, depth, last, tail and last)
        return lines

    def nested(self, stmts: list, depth: int, tail: bool = False) -> list[str]:
        """The lines of a nested statement list, in its own variable scope."""
        self.scopes.append(set())
        try:
            return self.block(stmts, depth, tail)
        finally:
            self.scopes.pop()

    def statement(self, stmt, depth: int, last: bool, tail: bool) -> list[str]:
        """The lines of one statement, the first of them noting the retail quirks its own expressions translate."""
        outer, self.notes = self.notes, []
        try:
            lines = self._statement(stmt, depth, last, tail)
            if self.notes and lines:
                separator = "; " if " -- retail: " in lines[0] else " -- retail: "
                lines[0] += separator + "; ".join(dict.fromkeys(self.notes))
            return lines
        finally:
            self.notes = outer

    def _statement(self, stmt, depth: int, last: bool, tail: bool) -> list[str]:
        ind = "\t" * depth
        if isinstance(stmt, ir.Assign):
            return self.assign(stmt, ind)
        if isinstance(stmt, ir.ExtCall):
            return self.ext_call(stmt, ind)
        if isinstance(stmt, ir.CallStmt):
            if self.mod.function(stmt.call.function).refs:
                return self.ref_call(stmt.call, None, ind)
            return [f"{ind}{self.function_call(stmt.call)[0]}"]
        if isinstance(stmt, ir.Print):
            return [f"{ind}print({', '.join(self.value(arg)[0] for arg in stmt.args)})"]
        if isinstance(stmt, ir.Wait):
            self.mod.uses_vm = True
            return [f"{ind}vm.wait()"]
        if isinstance(stmt, ir.Return):
            return self.return_(stmt, depth, last, tail)
        if isinstance(stmt, ir.If):
            return self.if_(stmt, depth, tail)
        if isinstance(stmt, ir.While):
            return [
                f"{ind}while {self.cond(stmt.cond)[0]} do",
                *self.nested(stmt.body, depth + 1),
                f"{ind}end",
            ]
        if isinstance(stmt, ir.Repeat):
            self.scopes.append(set())
            try:
                body = self.block(stmt.body, depth + 1)
                until = self.cond(stmt.cond)[0]
            finally:
                self.scopes.pop()
            return [f"{ind}repeat", *body, f"{ind}until {until}"]
        if isinstance(stmt, ir.NumericFor):
            start = self.value(stmt.start)[0]
            limit = self.value(stmt.limit)[0]
            step = ""
            if not (isinstance(stmt.step, ir.Const) and stmt.step.value == 1):
                step = f", {self.value(stmt.step)[0]}"
            header = self.loop_name(stmt.var)
            previous = self.active_loops.get(stmt.var)
            self.active_loops[stmt.var] = header
            try:
                body = self.nested(stmt.body, depth + 1)
            finally:
                if previous is None:
                    del self.active_loops[stmt.var]
                else:
                    self.active_loops[stmt.var] = previous
            return [f"{ind}for {header} = {start}, {limit}{step} do", *body, f"{ind}end"]
        if isinstance(stmt, ir.Break):
            return [f"{ind}break"]
        if isinstance(stmt, ir.Continue):
            return [f"{ind}continue"]
        if isinstance(stmt, ir.End):
            raise EmitError("end opcode unsupported")
        raise EmitError(f"unknown statement {type(stmt).__name__}")

    def if_(self, stmt: ir.If, depth: int, tail: bool) -> list[str]:
        """An if statement, flattening a single nested if in the else branch to elseif."""
        ind = "\t" * depth
        first = self.cond(stmt.cond)[0]
        lines = [f"{ind}if {first} then", *self.nested(stmt.then, depth + 1, tail)]
        tested = {first}
        orelse = stmt.orelse
        while len(orelse) == 1 and isinstance(orelse[0], ir.If):
            branch = orelse[0]
            cond = self.cond(branch.cond)[0]
            if cond in tested:
                # A repeated test stays a nested if, which keeps the script's dead branch without a duplicate elseif.
                break
            tested.add(cond)
            lines.append(f"{ind}elseif {cond} then")
            lines += self.nested(branch.then, depth + 1, tail)
            orelse = branch.orelse
        if orelse:
            lines.append(f"{ind}else")
            if len(orelse) == 1 and isinstance(orelse[0], ir.If) and self.cond(orelse[0].cond)[0] in tested:
                never = "" if ir.has_call(orelse[0].cond) else ", so its branch never runs"
                lines.append(f"{ind}\t-- retail: the script tests this condition again{never}")
            lines += self.nested(orelse, depth + 1, tail)
        lines.append(f"{ind}end")
        return lines

    def return_(self, stmt: ir.Return, depth: int, last: bool, tail: bool) -> list[str]:
        """A return statement; values nobody reads are dropped unless they carry a call.

        A function that takes references returns their values after its own, which it returns when any caller uses it.
        """
        ind = "\t" * depth
        expr = stmt.value
        if self.fn.refs:
            lines = []
            values = [self.ref_value(p) for p in self.fn.refs]
            if self.fn.block in self.mod.used_returns:
                values.insert(0, self.value(expr)[0])
            elif ir.has_call(expr):
                lines.append(f"local _ = {self.value(expr)[0]}")
            lines.append(f"return {', '.join(values)}")
            if last:
                return [f"{ind}{line}" for line in lines]
            return [f"{ind}do", *(f"{ind}\t{line}" for line in lines), f"{ind}end"]
        if self.role == "helper":
            keep = self.fn.block in self.mod.used_returns
        else:
            keep = not (isinstance(expr, ir.Const) and expr.type == ir.INT and expr.value == 0)
        keep = keep or ir.has_call(expr)
        if not keep and tail:
            return []
        text = f"return {self.value(expr)[0]}" if keep else "return"
        return [f"{ind}{text}"] if last else [f"{ind}do {text} end"]

    def ref_call(self, call: ir.Call, result: ir.Temp | None, ind: str) -> list[str]:
        """A call of a function that takes references: its result and the referenced values come back together."""
        callee = self.mod.function(call.function)
        lines: list[str] = []
        targets: list[str] = []
        if call.function in self.mod.used_returns:
            if result is not None and result.index in self.temp_reads:
                name = f"t{result.index}"
                if not any(result.index in scope for scope in self.scopes):
                    self.scopes[-1].add(result.index)
                    lines.append(f"{ind}local {name}: {_ANNOTATIONS[self.temp_type(result.index)]}")
                targets.append(name)
            else:
                targets.append("_")
        refs = [call.args[p] for p in callee.refs]
        for position, ref in zip(callee.refs, refs):
            if not isinstance(ref, ir.Addr):
                raise EmitError("a value is passed for a reference parameter")
            if self.expr_type(ref) == ir.FLOAT and callee.slot_types.get(("local", position)) != ir.FLOAT:
                # The callee may store an integer through the reference, whose bits the caller's float loads would read.
                raise EmitError(
                    f"float variable passed by reference to parameter {position} of "
                    f"{self.mod.function_name(call.function)}, which may store an integer there"
                )
            targets.append(self.target_text(ref) if self.declared(ref.slot) else "_")
        text = self.function_call(call)[0]
        if all(target == "_" for target in targets):
            lines.append(f"{ind}{text}")
        else:
            lines.append(f"{ind}{', '.join(targets)} = {text}")
        if self.mod.module.probe_refs and all(self.declared(ref.slot) for ref in refs):
            self.mod.probes.add(call.offset)
            lines.append(f"{ind}__ref({call.offset}, {', '.join(self.target_text(ref) for ref in refs)})")
        return lines

    def store(self, expr: ir.Expr, storage: str, name: str) -> tuple[str, str]:
        """The printed value stored into a variable of the given storage type, with its trailing comment."""
        if storage == ir.BOOL:
            return self.cond(expr)[0], ""
        if storage == ir.FLOAT:
            if isinstance(expr, ir.Const) and expr.type == ir.INT:
                if expr.value == 0:
                    return "0", ""
                number = _bits_to_float(expr.value)
                return _float_text(number)[0], " -- retail: integer bits read as a float"
            if self.may_be_int(expr):
                # The script loads this variable as a float, which would read an integer's bits; a constant is spelled
                # as those bits above, but a computed integer cannot be.
                raise EmitError(f"a value that may be an integer is stored into float variable {name}")
        return self.value(expr)[0], ""

    def assign(self, stmt: ir.Assign, ind: str) -> list[str]:
        """An assignment to a variable or a temporary."""
        target = stmt.target
        if isinstance(stmt.value, ir.Call) and self.mod.function(stmt.value.function).refs:
            if not isinstance(target, ir.Temp):
                raise EmitError("a call that copies references back is stored straight into a variable")
            return self.ref_call(stmt.value, target, ind)
        if isinstance(target, ir.Elem):
            if not self.declared(target.array):
                if ir.has_call(stmt.value):
                    return [f"{ind}local _ = {self.value(stmt.value)[0]}"]
                return []
            name = self.element(target.array, target.index)
            text, comment = self.store(stmt.value, self.slot_type(target.array), name)
            return [f"{ind}{name} = {text}{comment}"]
        if isinstance(target, ir.Temp):
            name = f"t{target.index}"
            text, comment = self.store(stmt.value, self.temp_type(target.index), name)
            if target.index not in self.temp_reads:
                return [f"{ind}local _ = {text}{comment}"]
            if any(target.index in scope for scope in self.scopes):
                return [f"{ind}{name} = {text}{comment}"]
            self.scopes[-1].add(target.index)
            return [f"{ind}local {name} = {text}{comment}"]
        if not self.declared(target):
            if ir.has_call(stmt.value):
                return [f"{ind}local _ = {self.value(stmt.value)[0]}"]
            return []
        name = self.name_of(target)
        text, comment = self.store(stmt.value, self.slot_type(target), name)
        return [f"{ind}{name} = {text}{comment}"]

    def _int_inout(self, plan: _Plan, arg: ir.Expr) -> bool:
        # An integer variable passed in-out: the handler reads its bits as a float.
        return any(arg is inout for inout in plan.inouts) and self.expr_type(arg) != ir.FLOAT

    def _input(self, plan: _Plan, arg: ir.Expr) -> str:
        # An in-out reference past the frame reads an operand-stack slot the module cannot name, and its result is lost,
        # so it passes 0.
        if self._past_frame(arg):
            return "0"
        if self._int_inout(plan, arg):
            return f"{self._call_text('vm.bits_float', self.value(arg)[0])[0]} :: number"
        return self._argument(arg)

    def _out_assign(self, out: ir.Addr, expr: str, conversion: str | None = None) -> str:
        # A call leaves an unwritten output nil, so the variable keeps its value. A conversion reinterprets the bits the
        # handler writes as the variable holds them; it passes nil through.
        name = self.target_text(out)
        if conversion is not None:
            expr = self._call_text(conversion, expr)[0]
        if out.index is None and self.slot_type(out.slot) == ir.BOOL:
            return f"{name} = ({expr} or (if {name} then 1 else 0)) ~= 0"
        return f"{name} = {expr} or {name}"

    def _argument(self, arg: ir.Expr) -> str:
        # A native call receives a float as a float32, so neither a float constant nor the last operation of a float
        # expression needs rounding of its own.
        if isinstance(arg, ir.Const):
            return _const_text(arg)[0]
        if isinstance(arg, ir.Binary) and arg.type == ir.FLOAT and not self.is_boolish(arg):
            return self._binary_text(arg)[0]
        return self.value(arg)[0]

    def _dropped_arg(self, arg: ir.Expr) -> str:
        # A dropped call's reference may name a variable that nothing else declares; it keeps its automatic name.
        if not isinstance(arg, ir.Addr):
            return self._argument(arg)
        try:
            return self.target_text(arg)
        except EmitError:
            return f"var{arg.slot[1]}"

    def _past_frame(self, expr: ir.Expr) -> bool:
        # An operand-stack slot past the frame, which a constant index reached. The lifter admits it only as a native
        # output into a slot that is dead when the call returns, so dropping the value is exact.
        return isinstance(expr, ir.Addr) and expr.slot[0] == "stack"

    def ext_call(self, stmt: ir.ExtCall, ind: str) -> list[str]:
        """An external command call, capturing the by-reference outputs that are declared."""
        plan = self.mod.resolve(stmt, self.expr_type)
        for message in plan.diagnostics:
            self.mod.diagnose(message)
        if plan.dropped:
            args = ", ".join(self._dropped_arg(arg) for arg in plan.ins)
            return [f"{ind}-- retail: {plan.name}({args}) does nothing, since its handler stores only an integer or a float"]
        if any(self._past_frame(arg) and not any(arg is inout for inout in plan.inouts) for arg in plan.ins):
            raise EmitError("a reference past the frame is passed where the handler reads a value")
        args = ", ".join(self._input(plan, arg) for arg in plan.ins)
        call = f"{plan.name}({args})"
        clauses = [plan.comment.removeprefix("retail: ")] if plan.comment else []
        lost = [position for position, out in enumerate(plan.outs, 1) if self._past_frame(out)]
        if lost:
            self.mod.diagnose("output written past the frame")
            clauses.append(
                f"output {', '.join(map(str, lost))} points past the frame, at the operand stack, so the value is lost"
            )
        comment = f" -- retail: {'; '.join(clauses)}" if clauses else ""
        if not any(self.declared(out.slot) for out in plan.outs):
            return [f"{ind}{call}{comment}"]
        conversions = plan.conversions or [None] * len(plan.outs)
        if len(plan.outs) == 1:
            return [f"{ind}{self._out_assign(plan.outs[0], call, conversions[0])}{comment}"]
        names = [f"out{index}" if self.declared(out.slot) else "_" for index, out in enumerate(plan.outs, 1)]
        lines = [f"{ind}do", f"{ind}\tlocal {', '.join(names)} = {call}{comment}"]
        for index, out in enumerate(plan.outs, 1):
            if self.declared(out.slot):
                lines.append(f"{ind}\t{self._out_assign(out, f'out{index}', conversions[index - 1])}")
        lines.append(f"{ind}end")
        return lines

    def lines(self) -> list[str]:
        """The lines of the function's declaration."""
        fn = self.fn
        params = ", ".join(
            f"{self.name_of(('local', n))}: {_ANNOTATIONS[self.slot_type(('local', n))]}" for n in range(fn.arg)
        )
        decls = []
        for slot in self.declared_slots:
            name, storage = self.name_of(slot), self.slot_type(slot)
            if slot[0] not in TABLE_SPACES:
                decls.append(f"\tlocal {name}: {_ANNOTATIONS[storage]} = {_default(storage)}")
                continue
            if slot == FRAME:
                decls.append(
                    "\t-- retail: a computed index here may leave its array, so the frame's slots live in one table "
                    "and such an index reaches the neighbouring variables, as it does on the PS2"
                )
            decls.append(f"\tlocal {name}: {{ {_ANNOTATIONS[storage]} }} = table.create({fn.arrays[slot]}, {_default(storage)})")
            if slot == FRAME:
                decls += [f"\t{self.element(FRAME, ir.Const(n, ir.INT))} = {self.name_of(('local', n))}" for n in range(fn.arg)]
        body = self.block(fn.body, 1, tail=True)
        return [
            *self.doc,
            f"{self.head}({params})",
            *decls,
            *body,
            "end",
        ]
