"""The integer or float tags a script's variables hold, and how the script reads what native calls write into them.

The machine tags every slot. A store gives the slot its value's tag, a float load (`*_FLOAT`) retags the slot as a
float, a call zeroes its locals as integers, and a native output writes its bits through a reference without retagging.
So what a script sees of a native output depends on the slot's history: a float load reads the bits as a float, and an
integer load reads them as the slot's tag says. Native handlers also branch on these tags (GetMonsterLife writes the
life or the fraction by its destination's tag, GetRand an integer or a float by its range's).

`analyse` interprets every function over its control-flow graph with sets of possible tags, until the parameters,
references, returns and globals agree across the program, and reports for each native call:

- for each value argument, the tags it may have;
- for each reference argument the handler writes, the tags its variable may hold at the call, and how the script reads
  the value written there: the union of the interpretations ("int", "float", or "?" when not followed) of every read the
  written value may reach before the variable is written again, in the function, in its callers through a reference
  parameter, and, for a global, anywhere in the program.
"""

from __future__ import annotations

import collections
import dataclasses

from stb import cfg
from stb.opcodes import FLOAT_MODES, GLOBAL_MODES, INDEXED_MODES, POINTER_MODES, ConstType, Op
from stb.program import Function, Program

INT, FLOAT, STR, PTR, UNKNOWN = "int", "float", "str", "ptr", "?"
Tags = frozenset
Slot = tuple[str, int]
OutputId = tuple[int, int]

_INT = Tags({INT})
_FLOAT = Tags({FLOAT})
_UNKNOWN = Tags({UNKNOWN})
_ROUNDS = 12


@dataclasses.dataclass(frozen=True)
class _Value:
    """An abstract operand-stack entry: its possible tags, or the variable an address names."""

    tags: Tags
    slot: Slot | None = None
    dynamic: bool = False
    const: object = None


@dataclasses.dataclass
class CallFacts:
    """What the analysis knows about one native call's arguments, by position (1 for the first argument)."""

    values: dict[int, Tags] = dataclasses.field(default_factory=dict)
    destinations: dict[int, Tags] = dataclasses.field(default_factory=dict)
    reads: dict[int, Tags] = dataclasses.field(default_factory=dict)


@dataclasses.dataclass
class Facts:
    """The analysis of a whole program: per native call offset, its CallFacts."""

    calls: dict[int, CallFacts]


@dataclasses.dataclass
class _Deref:
    """What a function does with the variable a reference parameter names: its reads ("float", or "slot" for the
    variable's tag), the tags it may give the variable (by storing there, or by a float load, which retags it) and the
    native outputs it writes there."""

    reads: set[str] = dataclasses.field(default_factory=set)
    stores: set[str] = dataclasses.field(default_factory=set)
    outputs: set[OutputId] = dataclasses.field(default_factory=set)

    def snapshot(self) -> tuple:
        return (frozenset(self.reads), frozenset(self.stores), frozenset(self.outputs))


@dataclasses.dataclass
class _State:
    stack: tuple[_Value, ...]
    tags: dict[Slot, Tags]
    pending: dict[Slot, frozenset[OutputId]]


def _arith(lhs: Tags, rhs: Tags) -> Tags:
    result = set()
    for a in lhs:
        for b in rhs:
            if a == INT and b == INT:
                result.add(INT)
            elif a in (INT, FLOAT) and b in (INT, FLOAT):
                result.add(FLOAT)
            else:
                result.add(UNKNOWN)
    return Tags(result)


def _fold(op: Op, a: int, b: int) -> int | None:
    """An integer operation on two constants as the machine computes it, or None for a division by zero."""
    if op == Op.DIV:
        if b == 0:
            return None
        result = abs(a) // abs(b) * (1 if (a < 0) == (b < 0) else -1)
    else:
        result = {Op.ADD: a + b, Op.SUB: a - b, Op.MUL: a * b}[op]
    return (result + 0x80000000) % 0x100000000 - 0x80000000


def _join_values(a: _Value, b: _Value) -> _Value:
    if a == b:
        return a
    if a.slot == b.slot and a.dynamic == b.dynamic:
        return _Value(a.tags | b.tags, a.slot, a.dynamic)
    return _Value(a.tags | b.tags)


def _join(a: _State, b: _State) -> _State:
    stack = tuple(_join_values(x, y) for x, y in zip(a.stack, b.stack))
    tags = dict(a.tags)
    for slot, value in b.tags.items():
        tags[slot] = tags.get(slot, Tags()) | value
    pending = dict(a.pending)
    for slot, value in b.pending.items():
        pending[slot] = pending.get(slot, frozenset()) | value
    return _State(stack, tags, pending)


class _Analysis:
    def __init__(self, program: Program, directions: dict[tuple[int, int], tuple[str, ...]]):
        self.program = program
        self.directions = directions
        self.graphs = {block: cfg.build(program, function) for block, function in program.functions.items()}
        self.named: dict[int, set[int]] = {}
        # Summaries of the previous round, which each round reads.
        self.param_tags: dict[int, dict[int, Tags]] = {}
        self.ref_tags: dict[int, dict[int, Tags]] = {}
        self.return_tags: dict[int, Tags] = {}
        self.global_tags: dict[int, Tags] = {}
        self.global_reads: dict[int, Tags] = {}
        self.derefs: dict[int, dict[int, _Deref]] = {}
        self.calls: dict[int, CallFacts] = {}

    def run(self) -> Facts:
        for _ in range(_ROUNDS):
            self.next_params: dict[int, dict[int, Tags]] = collections.defaultdict(dict)
            self.next_refs: dict[int, dict[int, Tags]] = collections.defaultdict(dict)
            self.next_returns: dict[int, Tags] = collections.defaultdict(Tags)
            self.next_globals: dict[int, Tags] = collections.defaultdict(lambda: _INT)
            self.next_global_reads: dict[int, Tags] = collections.defaultdict(Tags)
            self.next_derefs: dict[int, dict[int, _Deref]] = collections.defaultdict(
                lambda: collections.defaultdict(_Deref)
            )
            self.global_outputs: dict[int, set[OutputId]] = collections.defaultdict(set)
            self.calls = {}
            for function in self.program.functions.values():
                self._function(function)
            previous = (
                self.param_tags,
                self.ref_tags,
                self.return_tags,
                self.global_tags,
                self.global_reads,
                {b: {p: d.snapshot() for p, d in ds.items()} for b, ds in self.derefs.items()},
            )
            self.param_tags = {b: dict(v) for b, v in self.next_params.items()}
            self.ref_tags = {b: dict(v) for b, v in self.next_refs.items()}
            self.return_tags = dict(self.next_returns)
            self.global_tags = dict(self.next_globals)
            self.global_reads = dict(self.next_global_reads)
            self.derefs = {b: dict(v) for b, v in self.next_derefs.items()}
            current = (
                self.param_tags,
                self.ref_tags,
                self.return_tags,
                self.global_tags,
                self.global_reads,
                {b: {p: d.snapshot() for p, d in ds.items()} for b, ds in self.derefs.items()},
            )
            if current == previous:
                break
        # A value written into a global reaches every read of that global, in any function and any later run.
        for number, outputs in self.global_outputs.items():
            for output in outputs:
                self._read(output, self.global_reads.get(number, Tags()))
        return Facts(self.calls)

    def _read(self, output: OutputId, tags: Tags) -> None:
        facts = self.calls.setdefault(output[0], CallFacts())
        facts.reads[output[1]] = facts.reads.get(output[1], Tags()) | tags

    def _array_slots(self, function: Function, base: int) -> list[Slot]:
        # A computed index stays in its array: the slots from its base up to the next slot the function names, as the
        # lifter bounds it (stb2luau/lift.py _regions).
        if function.block not in self.named:
            named = set(range(function.arg)) | {function.local}
            for instruction in function.instructions:
                if instruction.op in (Op.LOAD, Op.LOAD_ADDR) and instruction.a2 not in GLOBAL_MODES | POINTER_MODES:
                    named.add(instruction.a1)
            self.named[function.block] = named
        end = min((slot for slot in self.named[function.block] if slot > base), default=function.local)
        return [("local", n) for n in range(base, end)]

    def _function(self, function: Function) -> None:
        program = self.program
        graph = self.graphs[function.block]
        derefs_out = self.next_derefs[function.block]
        entry_tags: dict[Slot, Tags] = {}
        for n in range(function.local):
            if n < function.arg:
                entry_tags[("local", n)] = self.param_tags.get(function.block, {}).get(n, _UNKNOWN)
            else:
                entry_tags[("local", n)] = _INT
        for n in range(function.arg):
            entry_tags[("ptr", n)] = self.ref_tags.get(function.block, {}).get(n, _UNKNOWN)
        states: dict[int, _State] = {graph.entry: _State((), entry_tags, {})}
        work = [graph.entry]
        visits = collections.Counter()
        while work:
            start = work.pop()
            visits[start] += 1
            if visits[start] > 200:
                continue
            state = states[start]
            stack = list(state.stack)
            tags = dict(state.tags)
            pending = dict(state.pending)
            block = graph.blocks[start]

            def tag_of(slot: Slot) -> Tags:
                if slot[0] == "global":
                    return tags.get(slot, self.global_tags.get(slot[1], _INT))
                return tags.get(slot, _UNKNOWN)

            def slots_of(value: _Value) -> list[Slot]:
                if value.slot is None:
                    return []
                if value.dynamic:
                    return self._array_slots(function, value.slot[1])
                return [value.slot]

            def read(slot: Slot, interpretation: Tags) -> None:
                for output in pending.get(slot, ()):
                    self._read(output, interpretation)

            def pop() -> _Value:
                return stack.pop() if stack else _Value(_UNKNOWN)

            successors: list[tuple[int, tuple[_Value, ...]]] = []
            for instruction in block.instructions:
                op = instruction.op
                if op in (Op.LOAD, Op.LOAD_ADDR):
                    mode = instruction.a2
                    dynamic = False
                    index = 0
                    if mode in INDEXED_MODES:
                        popped = pop()
                        if isinstance(popped.const, int):
                            index = popped.const
                        else:
                            dynamic = True
                    if mode in POINTER_MODES:
                        slot: Slot = ("ptr", instruction.a1)
                        dynamic = False
                    elif mode in GLOBAL_MODES:
                        slot = ("global", instruction.a1)
                    else:
                        slot = ("local", instruction.a1 + index)
                    targets = slots_of(_Value(Tags(), slot, dynamic))
                    if op == Op.LOAD_ADDR:
                        stack.append(_Value(Tags({PTR}), slot, dynamic))
                        continue
                    if mode in FLOAT_MODES:
                        for target in targets:
                            read(target, _FLOAT)
                            tags[target] = tag_of(target) | _FLOAT if dynamic else _FLOAT
                        if slot[0] == "global":
                            self.next_global_reads[slot[1]] |= _FLOAT
                            self.next_globals[slot[1]] = self.next_globals[slot[1]] | _FLOAT
                        if slot[0] == "ptr":
                            # A float load through a reference retags the caller's variable as well.
                            derefs_out[slot[1]].reads.add(FLOAT)
                            derefs_out[slot[1]].stores.add(FLOAT)
                        stack.append(_Value(_FLOAT))
                    else:
                        loaded = Tags().union(*(tag_of(target) for target in targets)) if targets else _UNKNOWN
                        for target in targets:
                            read(target, tag_of(target))
                        if slot[0] == "global":
                            self.next_global_reads[slot[1]] |= tag_of(slot)
                        if slot[0] == "ptr":
                            derefs_out[slot[1]].reads.add("slot")
                        stack.append(_Value(loaded))
                elif op == Op.PUSH_CONST:
                    if instruction.a1 == ConstType.INT:
                        stack.append(_Value(_INT, const=instruction.a2))
                    elif instruction.a1 == ConstType.FLOAT:
                        stack.append(_Value(_FLOAT))
                    else:
                        stack.append(_Value(Tags({STR})))
                elif op == Op.POP:
                    pop()
                elif op == Op.STORE:
                    value, target = pop(), pop()
                    for slot in slots_of(target):
                        if target.dynamic:
                            tags[slot] = tag_of(slot) | value.tags
                        else:
                            tags[slot] = value.tags
                            pending[slot] = frozenset()
                        if slot[0] == "global":
                            self.next_globals[slot[1]] = self.next_globals[slot[1]] | value.tags
                        if slot[0] == "ptr":
                            derefs_out[slot[1]].stores |= value.tags
                    stack.append(_Value(value.tags))
                elif op in (Op.ADD, Op.SUB, Op.MUL, Op.DIV):
                    rhs, lhs = pop(), pop()
                    # Command numbers are often sums of constants (60 + 15), so integer constants are folded.
                    folded = None
                    if isinstance(lhs.const, int) and isinstance(rhs.const, int):
                        folded = _fold(op, lhs.const, rhs.const)
                    stack.append(_Value(_arith(lhs.tags, rhs.tags), const=folded))
                elif op in (Op.MOD, Op.AND, Op.OR, Op.CMP):
                    pop()
                    pop()
                    stack.append(_Value(_INT))
                elif op in (Op.NOT, Op.FTOI):
                    pop()
                    stack.append(_Value(_INT))
                elif op == Op.NEG:
                    operand = pop()
                    negated = -operand.const if isinstance(operand.const, int) else None
                    stack.append(_Value(operand.tags, const=negated))
                elif op in (Op.ITOF, Op.SIN, Op.COS):
                    pop()
                    stack.append(_Value(_FLOAT))
                elif op == Op.JMP:
                    successors.append((program.jump_target(instruction), tuple(stack)))
                elif op in (Op.JMP_FALSE, Op.JMP_TRUE):
                    pop()
                    taken = list(stack)
                    if instruction.a2:
                        taken.append(_Value(_INT))
                    successors.append((program.jump_target(instruction), tuple(taken)))
                elif op == Op.CALL:
                    callee = program.callee(instruction)
                    args = [pop() for _ in range(callee.arg)][::-1]
                    callee_derefs = self.derefs.get(callee.block, {})
                    params = self.next_params[callee.block]
                    refs = self.next_refs[callee.block]
                    for i, arg in enumerate(args):
                        if arg.slot is None or PTR not in arg.tags:
                            params[i] = params.get(i, Tags()) | arg.tags
                            continue
                        params[i] = params.get(i, Tags()) | Tags({PTR})
                        deref = callee_derefs.get(i, _Deref())
                        for slot in slots_of(arg):
                            refs[i] = refs.get(i, Tags()) | tag_of(slot)
                            read(slot, Tags().union(*(tag_of(slot) if kind == "slot" else Tags({kind}) for kind in deref.reads)))
                            # The callee may or may not store, retag or write through the reference.
                            if deref.stores:
                                tags[slot] = tag_of(slot) | Tags(deref.stores)
                            if deref.outputs:
                                pending[slot] = pending.get(slot, frozenset()) | frozenset(deref.outputs)
                            if slot[0] == "global":
                                self.global_outputs[slot[1]].update(deref.outputs)
                            if slot[0] == "ptr":
                                passed = derefs_out[slot[1]]
                                passed.reads |= deref.reads
                                passed.stores |= deref.stores
                                passed.outputs |= deref.outputs
                    stack.append(_Value(self.return_tags.get(callee.block, _UNKNOWN)))
                elif op == Op.PRINT:
                    for _ in range(instruction.a1):
                        pop()
                elif op == Op.EXT:
                    values = [pop() for _ in range(instruction.a1)][::-1]
                    if not values:
                        continue
                    head, args = values[0], values[1:]
                    command = head.const if isinstance(head.const, int) else None
                    directions = self.directions.get((command, len(args)), ())
                    facts = self.calls.setdefault(instruction.offset, CallFacts())
                    for position, arg in enumerate(args, 1):
                        direction = directions[position - 1] if directions else None
                        if arg.slot is None or PTR not in arg.tags:
                            facts.values[position] = facts.values.get(position, Tags()) | arg.tags
                            continue
                        if direction not in ("out", "inout"):
                            continue
                        targets = slots_of(arg)
                        facts.destinations[position] = facts.destinations.get(position, Tags()).union(
                            *(tag_of(slot) for slot in targets)
                        )
                        output = (instruction.offset, position)
                        facts.reads.setdefault(position, Tags())
                        for slot in targets:
                            if arg.dynamic:
                                pending[slot] = pending.get(slot, frozenset()) | {output}
                            else:
                                pending[slot] = frozenset({output})
                            if slot[0] == "global":
                                self.global_outputs[slot[1]].add(output)
                            if slot[0] == "ptr":
                                derefs_out[slot[1]].outputs.add(output)
                elif op == Op.RET:
                    self.next_returns[function.block] = self.next_returns[function.block] | pop().tags
            last = block.instructions[-1]
            if last.op in (Op.JMP_FALSE, Op.JMP_TRUE):
                following = last.offset + 12
                if following in graph.blocks:
                    successors.append((following, tuple(stack)))
            elif last.op not in (Op.JMP, Op.RET, Op.END):
                successors.extend((successor, tuple(stack)) for successor in block.successors)
            for successor, out_stack in successors:
                current = states.get(successor)
                if current is None:
                    states[successor] = _State(out_stack, dict(tags), dict(pending))
                    work.append(successor)
                    continue
                if len(current.stack) != len(out_stack):
                    continue
                merged = _join(current, _State(out_stack, tags, pending))
                if merged.stack != current.stack or merged.tags != current.tags or merged.pending != current.pending:
                    states[successor] = merged
                    work.append(successor)


def analyse(program: Program, directions: dict[tuple[int, int], tuple[str, ...]]) -> Facts:
    """Tags and output reads of a program's native calls; directions maps (command, argc) to each parameter's dir."""
    return _Analysis(program, directions).run()
