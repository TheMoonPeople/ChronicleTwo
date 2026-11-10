"""Abstract interpretation of the operand stack: value types, external calls and script calls.

Each function is interpreted over its control-flow graph with an abstract stack of Values. Variable types come
from the address modes the compiler chose (the *_FLOAT modes mark float variables), from the values stored into
each slot, and from the arguments callers pass; the analysis iterates over the whole program until those agree.
"""

from __future__ import annotations

import collections
import dataclasses

from . import cfg
from .opcodes import FLOAT_MODES, GLOBAL_MODES, INDEXED_MODES, POINTER_MODES, AddrMode, ConstType, Op
from .program import Function, Program

INT, FLOAT, STR, PTR, ANY = "int", "float", "str", "ptr", "any"


@dataclasses.dataclass(frozen=True)
class Value:
    """An abstract operand-stack entry."""

    kind: str
    type: str
    slot: tuple[str, int] | None = None
    mode: int | None = None
    const: object = None
    indexed_const: bool = False

    @property
    def target_type(self) -> str:
        """Type of the variable an address value points at."""
        return FLOAT if self.mode in FLOAT_MODES else self.const or INT


@dataclasses.dataclass
class ExtSite:
    """One external-function call: its command number (None if not a constant) and argument values."""

    offset: int
    command: int | None
    args: tuple[Value, ...]


@dataclasses.dataclass
class FunctionFacts:
    """Everything the stack interpretation of one function established."""

    ext_sites: dict[int, ExtSite] = dataclasses.field(default_factory=dict)
    call_args: dict[int, tuple[int, tuple[Value, ...]]] = dataclasses.field(default_factory=dict)
    stores: dict[tuple[str, int], set[str]] = dataclasses.field(default_factory=lambda: collections.defaultdict(set))
    float_slots: set[tuple[str, int]] = dataclasses.field(default_factory=set)
    returns: set[str] = dataclasses.field(default_factory=set)
    stack_errors: list[str] = dataclasses.field(default_factory=list)
    counters: collections.Counter = dataclasses.field(default_factory=collections.Counter)
    graph: cfg.Graph | None = None


def join(a: str, b: str) -> str:
    """Least upper bound of two value types."""
    return a if a == b else ANY


def wrap32(value: int) -> int:
    """Value as the virtual machine's 32-bit two's-complement integer."""
    return (value + 0x80000000) % 0x100000000 - 0x80000000


def fold(op: Op, lhs: Value, rhs: Value) -> Value | None:
    """Constant result of an integer operation on two integer constants, as the virtual machine computes it."""
    if not (lhs.kind == rhs.kind == "const" and lhs.type == rhs.type == INT):
        return None
    a, b = lhs.const, rhs.const
    if op in (Op.DIV, Op.MOD) and b == 0:
        return None
    result = {
        Op.ADD: lambda: a + b,
        Op.SUB: lambda: a - b,
        Op.MUL: lambda: a * b,
        Op.DIV: lambda: abs(a) // abs(b) * (1 if (a < 0) == (b < 0) else -1),
        Op.MOD: lambda: abs(a) % abs(b) * (1 if a >= 0 else -1),
        Op.AND: lambda: a & b,
        Op.OR: lambda: a | b,
    }[op]()
    return Value("const", INT, const=wrap32(result))


def _arith(lhs: Value, rhs: Value) -> str:
    if lhs.type == INT and rhs.type == INT:
        return INT
    if FLOAT in (lhs.type, rhs.type) and lhs.type in (INT, FLOAT) and rhs.type in (INT, FLOAT):
        return FLOAT
    return ANY


class Analysis:
    """Whole-program stack interpretation with interprocedural slot typing."""

    def __init__(self, program: Program):
        self.program = program
        self.param_types: dict[int, dict[int, str]] = collections.defaultdict(dict)
        self.global_types: dict[int, str] = {}
        self.return_types: dict[int, str] = {}
        self.facts: dict[int, FunctionFacts] = {}
        self.graphs = {block: cfg.build(program, function) for block, function in program.functions.items()}
        for _ in range(6):
            facts = {block: self._interpret(function) for block, function in program.functions.items()}
            params, globals_, returns = self._summaries(facts)
            stable = (params, globals_, returns) == (self.param_types, self.global_types, self.return_types)
            self.facts = facts
            self.param_types, self.global_types, self.return_types = params, globals_, returns
            if stable:
                break

    def _summaries(self, facts):
        params: dict[int, dict[int, str]] = collections.defaultdict(dict)
        globals_: dict[int, str] = {}
        returns: dict[int, str] = {}
        for block, fact in facts.items():
            for callee, args in fact.call_args.values():
                for i, value in enumerate(args):
                    previous = params[callee].get(i)
                    params[callee][i] = value.type if previous is None else join(previous, value.type)
            for (space, n), types in fact.stores.items():
                if space == "global":
                    for t in types:
                        globals_[n] = t if n not in globals_ else join(globals_[n], t)
            for (space, n) in fact.float_slots:
                if space == "global":
                    globals_[n] = FLOAT
            if fact.returns:
                kinds = sorted(fact.returns)
                returns[block] = kinds[0] if len(kinds) == 1 else ANY
        return params, globals_, returns

    def _slot_type(self, function: Function, slot: tuple[str, int], previous: FunctionFacts | None) -> str:
        space, n = slot
        if space == "global":
            return self.global_types.get(n, INT)
        types = set(previous.stores.get(slot, ())) if previous else set()
        if n < function.arg:
            parameter = self.param_types.get(function.block, {}).get(n)
            if parameter is None and not types:
                return ANY
            if parameter is not None:
                types.add(parameter)
        if not types:
            return INT
        return types.pop() if len(types) == 1 else ANY

    def _interpret(self, function: Function) -> FunctionFacts:
        program = self.program
        previous = self.facts.get(function.block)
        fact = FunctionFacts(graph=self.graphs[function.block])
        graph = fact.graph
        entry_stacks: dict[int, tuple[Value, ...]] = {graph.entry: ()}
        work = [graph.entry]
        visits = collections.Counter()
        recorded = set()

        def slot_of(instruction) -> tuple[str, int]:
            return ("global" if instruction.a2 in GLOBAL_MODES else "local", instruction.a1)

        while work:
            start = work.pop()
            visits[start] += 1
            if visits[start] > 64:
                fact.stack_errors.append(f"stack did not converge at {start:#x}")
                continue
            stack = list(entry_stacks[start])
            block = graph.blocks[start]
            first_visit = start not in recorded
            recorded.add(start)

            def pop() -> Value:
                if not stack:
                    fact.stack_errors.append(f"stack underflow at {instruction.offset:#x}")
                    return Value("unknown", ANY)
                return stack.pop()

            def count(name: str):
                if first_visit:
                    fact.counters[name] += 1

            successors: list[tuple[int, tuple[Value, ...]]] = []
            for instruction in block.instructions:
                op = instruction.op
                if op in (Op.LOAD, Op.LOAD_ADDR):
                    mode = instruction.a2
                    try:
                        AddrMode(mode)
                    except ValueError:
                        fact.stack_errors.append(f"unknown address mode {mode:#x} at {instruction.offset:#x}")
                    indexed_const = False
                    if mode in INDEXED_MODES:
                        index = pop()
                        indexed_const = index.kind == "const"
                    slot = slot_of(instruction)
                    if mode in FLOAT_MODES:
                        fact.float_slots.add(slot)
                    if op == Op.LOAD:
                        if mode in FLOAT_MODES:
                            vtype = FLOAT
                        elif mode in POINTER_MODES:
                            vtype = INT
                        else:
                            vtype = self._slot_type(function, slot, previous)
                        stack.append(Value("load", vtype, slot, mode, indexed_const=indexed_const))
                    else:
                        target = FLOAT if mode in FLOAT_MODES else INT
                        if mode not in FLOAT_MODES and mode not in POINTER_MODES and mode not in INDEXED_MODES:
                            target = self._slot_type(function, slot, previous)
                            target = INT if target in (ANY, PTR) else target
                        stack.append(Value("addr", PTR, slot, mode, target, indexed_const))
                elif op == Op.PUSH_CONST:
                    if instruction.a1 == ConstType.INT:
                        stack.append(Value("const", INT, const=instruction.a2))
                    elif instruction.a1 == ConstType.FLOAT:
                        stack.append(Value("const", FLOAT, const=instruction.a2_float))
                    elif instruction.a1 == ConstType.STR:
                        stack.append(Value("const", STR, const=program.string(instruction)))
                    else:
                        fact.stack_errors.append(f"unknown constant type {instruction.a1} at {instruction.offset:#x}")
                        stack.append(Value("unknown", ANY))
                elif op == Op.POP:
                    pop()
                elif op == Op.STORE:
                    value, target = pop(), pop()
                    if target.kind == "addr" and target.slot is not None:
                        if target.mode in POINTER_MODES:
                            count("store_through_pointer")
                        else:
                            fact.stores[target.slot].add(value.type)
                    elif target.type == PTR:
                        count("store_through_pointer")
                    else:
                        fact.stack_errors.append(f"store to non-address at {instruction.offset:#x}")
                    stack.append(value)
                elif op in (Op.ADD, Op.SUB, Op.MUL, Op.DIV):
                    rhs, lhs = pop(), pop()
                    vtype = _arith(lhs, rhs)
                    folded = fold(op, lhs, rhs)
                    if folded:
                        stack.append(folded)
                        continue
                    if vtype == INT:
                        count({Op.ADD: "int_add", Op.SUB: "int_sub", Op.MUL: "int_mul", Op.DIV: "int_div"}[op])
                    elif vtype == ANY:
                        count("untyped_arithmetic")
                    if op == Op.DIV and rhs.kind == "const" and rhs.const == 0:
                        count("constant_division_by_zero")
                    stack.append(Value("expr", vtype))
                elif op in (Op.MOD, Op.AND, Op.OR):
                    rhs, lhs = pop(), pop()
                    folded = fold(op, lhs, rhs)
                    if folded:
                        stack.append(folded)
                        continue
                    if FLOAT in (lhs.type, rhs.type):
                        count("float_operand_to_int_only_op")
                    count({Op.MOD: "int_mod", Op.AND: "bit_and", Op.OR: "bit_or"}[op])
                    stack.append(Value("expr", INT))
                elif op == Op.NEG:
                    operand = pop()
                    if operand.kind == "const" and operand.type == INT:
                        stack.append(Value("const", INT, const=wrap32(-operand.const)))
                    elif operand.kind == "const" and operand.type == FLOAT:
                        stack.append(Value("const", FLOAT, const=-operand.const))
                    else:
                        stack.append(Value("expr", operand.type))
                elif op == Op.NOT:
                    if pop().type == FLOAT:
                        count("float_operand_to_int_only_op")
                    stack.append(Value("expr", INT))
                elif op in (Op.ITOF, Op.SIN, Op.COS):
                    pop()
                    stack.append(Value("expr", FLOAT))
                elif op == Op.FTOI:
                    pop()
                    stack.append(Value("expr", INT))
                elif op == Op.CMP:
                    rhs, lhs = pop(), pop()
                    if {lhs.type, rhs.type} == {INT, FLOAT}:
                        count("mixed_compare")
                    if STR in (lhs.type, rhs.type):
                        count("string_compare")
                    stack.append(Value("expr", INT))
                elif op == Op.JMP:
                    successors.append((program.jump_target(instruction), tuple(stack)))
                elif op in (Op.JMP_FALSE, Op.JMP_TRUE):
                    condition = pop()
                    if condition.type == FLOAT:
                        count("float_condition")
                    elif condition.type == STR:
                        count("string_condition")
                    taken = list(stack)
                    if instruction.a2:
                        count("short_circuit")
                        taken.append(Value("const", INT, const=0 if op == Op.JMP_FALSE else 1))
                    successors.append((program.jump_target(instruction), tuple(taken)))
                elif op == Op.CALL:
                    callee = program.callee(instruction)
                    args = tuple(pop() for _ in range(callee.arg))[::-1]
                    fact.call_args[instruction.offset] = (callee.block, args)
                    stack.append(Value("call", self.return_types.get(callee.block, ANY), const=callee.block))
                elif op == Op.PRINT:
                    for _ in range(instruction.a1):
                        pop()
                elif op == Op.EXT:
                    values = [pop() for _ in range(instruction.a1)][::-1]
                    if values:
                        head = values[0]
                        command = head.const if head.kind == "const" and head.type == INT else None
                        fact.ext_sites[instruction.offset] = ExtSite(instruction.offset, command, tuple(values[1:]))
                elif op == Op.RET:
                    fact.returns.add(pop().type)
                elif op in (Op.END, Op.WAIT, Op.SKIP_END, Op.LABEL):
                    pass
            last = block.instructions[-1]
            if last.op in (Op.JMP_FALSE, Op.JMP_TRUE):
                following = _fallthrough(graph, block)
                if following is not None:
                    successors.append((following, tuple(stack)))
            elif last.op not in (Op.JMP, Op.RET, Op.END):
                successors.extend((successor, tuple(stack)) for successor in block.successors)
            for successor, out in successors:
                current = entry_stacks.get(successor)
                if current is None:
                    entry_stacks[successor] = out
                    work.append(successor)
                    continue
                if len(current) != len(out):
                    fact.stack_errors.append(f"stack height {len(current)} vs {len(out)} at {successor:#x}")
                    continue
                merged = tuple(a if a == b else Value("merged", join(a.type, b.type)) for a, b in zip(current, out))
                if merged != current:
                    entry_stacks[successor] = merged
                    work.append(successor)
        return fact


def _fallthrough(graph: cfg.Graph, block: cfg.Block) -> int | None:
    """Offset of the block that follows a conditional jump when it is not taken."""
    following = block.instructions[-1].offset + 12
    return following if following in graph.blocks else None
