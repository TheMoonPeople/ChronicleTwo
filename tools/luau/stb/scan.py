"""Per-script facts gathered from the whole corpus for the command catalog and the corpus report."""

from __future__ import annotations

import collections
import concurrent.futures
import dataclasses
import os
from pathlib import Path

from .analysis import FLOAT, INT, PTR, STR, Analysis, Value
from .corpus import Kind, classify, scripts
from .opcodes import INDEXED_MODES, GLOBAL_MODES, AddrMode, Op
from .program import DecodeError, body_hashes, decode

LUAU_TYPES = {INT: "s32", FLOAT: "f32", STR: "string"}


@dataclasses.dataclass(frozen=True)
class Argument:
    """How one external-call argument is supplied at a call site."""

    direction: str
    type: str
    shape: str
    const: object = None


@dataclasses.dataclass
class ScriptFacts:
    """Facts about one script file."""

    path: str
    kind: Kind
    size: int
    error: str | None = None
    magic: str = ""
    global_num: int = 0
    programs: list[int] = dataclasses.field(default_factory=list)
    functions: int = 0
    referenced: int = 0
    bodies: dict[str, int] = dataclasses.field(default_factory=dict)
    max_local: int = 0
    max_arg: int = 0
    opcodes: collections.Counter = dataclasses.field(default_factory=collections.Counter)
    load_modes: collections.Counter = dataclasses.field(default_factory=collections.Counter)
    addr_modes: collections.Counter = dataclasses.field(default_factory=collections.Counter)
    counters: collections.Counter = dataclasses.field(default_factory=collections.Counter)
    irreducible: list[int] = dataclasses.field(default_factory=list)
    loops: int = 0
    recursive: int = 0
    stack_errors: list[str] = dataclasses.field(default_factory=list)
    strings: int = 0
    non_ascii_strings: int = 0
    non_round_trip_strings: list[str] = dataclasses.field(default_factory=list)
    ext_sites: list[tuple[int | None, tuple[Argument, ...]]] = dataclasses.field(default_factory=list)


def argument(value: Value) -> Argument:
    """Classify an external-call argument value."""
    if value.kind == "addr":
        if value.mode in GLOBAL_MODES:
            shape = "global"
        elif value.mode in INDEXED_MODES:
            shape = "element" if value.indexed_const else "indexed_element"
        else:
            shape = "variable"
        return Argument("out", LUAU_TYPES.get(value.target_type, "unknown"), shape)
    if value.type == PTR:
        return Argument("out", "array", "forwarded")
    const = value.const if value.kind == "const" and value.type in (INT, FLOAT) else None
    return Argument("in", LUAU_TYPES.get(value.type, "unknown"), "const" if value.kind == "const" else "value", const)


def _recursive_functions(program) -> int:
    calls = {b: {program.code + i.a2 for i in f.instructions if i.op == Op.CALL} for b, f in program.functions.items()}
    recursive = 0
    for start in calls:
        seen, todo = set(), list(calls[start])
        while todo:
            block = todo.pop()
            if block == start:
                recursive += 1
                break
            if block not in seen:
                seen.add(block)
                todo.extend(calls.get(block, ()))
    return recursive


def facts(path: str, data: bytes) -> ScriptFacts:
    """Decode and analyse one script."""
    result = ScriptFacts(path, classify(path), len(data))
    try:
        program = decode(data)
    except DecodeError as error:
        result.error = str(error)
        return result
    analysis = Analysis(program)
    result.magic, result.global_num = program.magic, program.global_num
    result.programs = [no for no, _ in program.programs]
    result.functions = len(program.functions)
    result.referenced = sum(f.referenced for f in program.functions.values())
    result.bodies = collections.Counter(body_hashes(program).values())
    result.recursive = _recursive_functions(program)
    for block, function in program.functions.items():
        result.max_local = max(result.max_local, function.local)
        result.max_arg = max(result.max_arg, function.arg)
        for instruction in function.instructions:
            result.opcodes[instruction.op.name] += 1
            if instruction.op in (Op.LOAD, Op.LOAD_ADDR):
                name = AddrMode(instruction.a2).name if instruction.a2 in AddrMode._value2member_map_ else hex(instruction.a2)
                (result.load_modes if instruction.op == Op.LOAD else result.addr_modes)[name] += 1
            elif instruction.op == Op.PUSH_CONST and instruction.a1 == 3:
                text = program.string(instruction)
                result.strings += 1
                if not text.isascii():
                    result.non_ascii_strings += 1
                    try:
                        if text.decode("cp932").encode("cp932") != text:
                            raise UnicodeError
                    except UnicodeError:
                        result.non_round_trip_strings.append(text.hex())
        fact = analysis.facts[block]
        result.counters.update(fact.counters)
        result.stack_errors.extend(f"{block:#x}: {e}" for e in fact.stack_errors)
        if not fact.graph.reducible:
            result.irreducible.append(block)
        result.loops += len({header for _, header in fact.graph.back_edges})
        for site in fact.ext_sites.values():
            result.ext_sites.append((site.command, tuple(argument(v) for v in site.args)))
    return result


def _facts(item: tuple[str, bytes]) -> ScriptFacts:
    return facts(*item)


def scan(source: Path, jobs: int | None = None) -> list[ScriptFacts]:
    """Facts for every script in a data directory or data.zip, in path order."""
    items = list(scripts(source))
    jobs = jobs or os.cpu_count() or 1
    if jobs == 1:
        return [_facts(item) for item in items]
    with concurrent.futures.ProcessPoolExecutor(max_workers=jobs) as pool:
        return list(pool.map(_facts, items, chunksize=4))
