"""Lifts a decoded script function's operand-stack code into expression trees, statements and block exits.

Every local is a Luau variable, except where the function indexes a local array with a computed index. Such an array
becomes a table holding the slots from its base up to the next variable the function names; when an interval analysis
cannot prove that every computed index stays inside its array, the function's whole frame becomes one table instead,
so an index that runs past its array reaches the neighbouring variables as it does on the PS2. A parameter that the
function dereferences with a pointer-index mode is a reference: its caller's variable is copied in and copied back.
"""

from __future__ import annotations

import dataclasses
import functools
import math
from collections import defaultdict

from stb.analysis import Analysis, Value, fold, join, wrap32
from stb.opcodes import FLOAT_MODES, GLOBAL_MODES, INDEXED_MODES, JUMPS, POINTER_MODES, AddrMode, ConstType, Op
from stb.opcodes import Compare as CompareOp
from stb.program import Function, Instruction, Program

from . import ir
from .refvm import f32
from .ir import ANY, BOOL, FLOAT, FRAME, INT, STR

INSTRUCTION_SIZE = 12
# Visits of a loop head after which an interval bound that still moves is widened to infinity.
WIDEN_AFTER = 3
# Passes over the blocks after widening that recover the bounds loop conditions give.
NARROW_PASSES = 3

_TYPES = {INT: INT, FLOAT: FLOAT, STR: STR, "bool": BOOL, ANY: ANY, "ptr": ANY}
_BINARY = {Op.ADD: "add", Op.SUB: "sub", Op.MUL: "mul", Op.DIV: "div", Op.MOD: "mod", Op.AND: "band", Op.OR: "bor"}
_UNARY = {Op.NEG: "neg", Op.NOT: "not", Op.ITOF: "itof", Op.FTOI: "ftoi", Op.SIN: "sin", Op.COS: "cos"}
_NUMBERS = (INT, BOOL, FLOAT)


class LiftError(ValueError):
    """A script function whose operand-stack code cannot be expressed as structured statements."""


# A float load retags its slot, so an integer constant stored there reads as itself until the first float load and as
# the float its bits spell after it. The translation can spell it only one way, which is wrong when both loads occur.
_MIXED = (
    "integer constant stored into {what}, which the script loads both as an integer and as a float, at {offset:#x}"
)


@dataclasses.dataclass
class _Frame:
    """A short-circuit whose right operand is still being lifted."""

    target: int
    op: str
    lhs: ir.Expr
    depth: int


def _static(analysis_type: str) -> str:
    return _TYPES.get(analysis_type, ANY)


def _describe(index: ir.Expr) -> str:
    return str(index.value) if isinstance(index, ir.Const) else "computed at run time"


def _unary_type(name: str, operand: str) -> str:
    if name in ("itof", "sin", "cos"):
        return FLOAT
    if name in ("not", "ftoi"):
        return INT
    if operand in (INT, BOOL):
        return INT
    return FLOAT if operand == FLOAT else ANY


def _binary_type(name: str, lhs: str, rhs: str) -> str:
    if name in ("mod", "band", "bor"):
        return INT
    if lhs in (INT, BOOL) and rhs in (INT, BOOL):
        return INT
    if FLOAT in (lhs, rhs) and lhs in _NUMBERS and rhs in _NUMBERS:
        return FLOAT
    return ANY


def _fold_float(op: Op, lhs: float, rhs: float) -> float | None:
    if op == Op.DIV and rhs == 0:
        return None
    result = {Op.ADD: lambda: lhs + rhs, Op.SUB: lambda: lhs - rhs, Op.MUL: lambda: lhs * rhs, Op.DIV: lambda: lhs / rhs}.get(op)
    if result is None:
        return None
    value = f32(result())
    return value if math.isfinite(value) else None


def _expressions(statement: ir.Statement) -> tuple[ir.Expr, ...]:
    if isinstance(statement, ir.Assign):
        return (statement.value,)
    if isinstance(statement, (ir.ExtCall, ir.Print)):
        return statement.args
    if isinstance(statement, ir.CallStmt):
        return (statement.call,)
    if isinstance(statement, ir.Return):
        return (statement.value,)
    return ()


def _written(statement: ir.Statement) -> set[ir.Slot]:
    written = set()
    if isinstance(statement, ir.Assign) and (target := ir.target_slot(statement.target)) is not None:
        written.add(target)
    for expr in _expressions(statement):
        written.update(sub.slot for sub in ir.walk(expr) if isinstance(sub, ir.Addr))
    return written


def _reads_global(expr: ir.Expr) -> bool:
    return any(space == "global" for space, _ in ir.reads(expr))


def _check_aliases(args: tuple[ir.Expr, ...], offset: int) -> None:
    """Rejects a call that passes two references which may name the same variable."""
    seen: list[ir.Addr] = []
    for arg in args:
        if not isinstance(arg, ir.Addr):
            continue
        for other in seen:
            if other.slot != arg.slot:
                continue
            if arg.index is None or other.index is None or arg.index == other.index:
                raise LiftError(f"two references to {arg.slot[0]} {arg.slot[1]} in one call at {offset:#x}")
            if not (isinstance(arg.index, ir.Const) and isinstance(other.index, ir.Const)):
                raise LiftError(f"two references that may name one element of {arg.slot[0]} {arg.slot[1]} at {offset:#x}")
        seen.append(arg)


def _check_mixed_stores(lifter: _Lifter) -> None:
    """Refuses an integer constant stored into a variable the script loads both as an integer and as a float."""
    mixed = {key for key, kinds in lifter.load_kinds.items() if len(kinds) == 2}
    mixed |= {("global", n) for n in lifter.mixed_globals}
    for block in lifter.blocks.values():
        for statement in block.statements:
            if not isinstance(statement, ir.Assign):
                continue
            value, target = statement.value, statement.target
            if not (isinstance(value, ir.Const) and value.type == INT and value.value != 0):
                continue
            key = target.array if isinstance(target, ir.Elem) else target
            if key in mixed:
                raise LiftError(_MIXED.format(what=f"{key[0]} {key[1]}", offset=statement.offset))


def _int_reads(function: Function) -> frozenset[int]:
    """The reference parameters a function loads through POINTER_INDEX, reading the slot they name as it is tagged."""
    return frozenset(
        instruction.a1
        for instruction in function.instructions
        if instruction.op == Op.LOAD and instruction.a2 == AddrMode.POINTER_INDEX
    )


def _mixed_slots(instructions, space: str) -> frozenset[int]:
    """The slots of one space that some LOAD reads with a float mode and another without one."""
    modes = (AddrMode.GLOBAL, AddrMode.GLOBAL_FLOAT) if space == "global" else (AddrMode.LOCAL, AddrMode.LOCAL_FLOAT)
    kinds: dict[int, set[bool]] = defaultdict(set)
    for instruction in instructions:
        if instruction.op == Op.LOAD and instruction.a2 in modes:
            kinds[instruction.a1].add(instruction.a2 in FLOAT_MODES)
    return frozenset(slot for slot, found in kinds.items() if len(found) == 2)


def mixed_globals(program: Program) -> frozenset[int]:
    """The globals that the script loads both as integers and as floats, in any of its functions."""
    return _mixed_slots((i for function in program.functions.values() for i in function.instructions), "global")


def _float_reads(function: Function) -> frozenset[int]:
    """The reference parameters a function loads through POINTER_INDEX_FLOAT, which retags the slot they name."""
    return frozenset(
        instruction.a1
        for instruction in function.instructions
        if instruction.op == Op.LOAD and instruction.a2 == AddrMode.POINTER_INDEX_FLOAT
    )


def references(program: Program) -> dict[int, tuple[int, ...]]:
    """The parameters each function dereferences through a pointer-index mode, keyed by header block."""
    found: dict[int, tuple[int, ...]] = {}
    for block, function in program.functions.items():
        params = {
            instruction.a1
            for instruction in function.instructions
            if instruction.op in (Op.LOAD, Op.LOAD_ADDR) and instruction.a2 in POINTER_MODES
        }
        if params:
            found[block] = tuple(sorted(params))
    return found


def lift(
    program: Program, function: Function, analysis: Analysis, refs: dict[int, tuple[int, ...]] | None = None
) -> ir.LiftedFunction:
    """Lift one decoded script function into blocks of statements with typed expression trees.

    refs gives each function's reference parameters, as references() finds them; it is computed when omitted.
    """
    if refs is None:
        refs = references(program)
    lifter = _Lifter(program, function, analysis, refs)
    lifter.run()
    if lifter.dynamic:
        lifter = _Lifter(program, function, analysis, refs, regions=_regions(function, lifter.dynamic))
        lifter.run()
        if not _indices_in_bounds(lifter):
            lifter = _Lifter(program, function, analysis, refs, frame=True)
            lifter.run()
    _check_mixed_stores(lifter)
    return ir.LiftedFunction(
        block=function.block,
        arg=function.arg,
        local=function.local,
        entry=function.instructions[0].offset,
        blocks=_mark_overflows(lifter),
        slot_types=lifter.slot_types,
        temps=lifter.temps,
        refs=refs.get(function.block, ()),
        arrays=lifter.arrays(),
        folded=frozenset(lifter.folded),
    )


@dataclasses.dataclass(frozen=True)
class _Region:
    """A local array that a computed index reaches: its base slot and its length in slots."""

    base: int
    length: int

    @property
    def key(self) -> ir.Slot:
        """The slot that names the array's table."""
        return ("array", self.base)


def _regions(function: Function, bases: set[int]) -> dict[int, _Region]:
    """The arrays at the given bases, each running up to the next slot the function names, or the frame's end."""
    named = set(range(function.arg)) | {function.local}
    for instruction in function.instructions:
        if instruction.op in (Op.LOAD, Op.LOAD_ADDR) and instruction.a2 not in GLOBAL_MODES:
            named.add(instruction.a1)
    regions = {}
    for base in sorted(bases):
        if not function.arg <= base < function.local:
            raise LiftError(f"computed index from slot {base}, which is not a local of the frame")
        end = min(slot for slot in named if slot > base)
        regions[base] = _Region(base, end - base)
    return regions


class _Lifter:
    def __init__(
        self,
        program: Program,
        function: Function,
        analysis: Analysis,
        refs: dict[int, tuple[int, ...]],
        regions: dict[int, _Region] | None = None,
        frame: bool = False,
    ):
        self.program = program
        self.function = function
        self.analysis = analysis
        self.refs = refs
        self.own_refs = frozenset(refs.get(function.block, ()))
        self.regions = regions
        self.frame = frame
        self.facts = analysis.facts[function.block]
        self.graph = analysis.graphs[function.block]
        self.jumps_to: dict[int, list[Instruction]] = defaultdict(list)
        for instruction in function.instructions:
            if instruction.op in JUMPS:
                self.jumps_to[program.jump_target(instruction)].append(instruction)
        self.next_op = {
            instruction.offset: following.op
            for instruction, following in zip(function.instructions, function.instructions[1:])
        }
        self.stack: list[ir.Expr] = []
        self.pending: list[_Frame] = []
        self.blocks: dict[int, ir.LiftedBlock] = {}
        self.current: ir.LiftedBlock | None = None
        self.slot_types: dict[ir.Slot, str] = {}
        self.temps: list[str] = []
        # Bases of the arrays that a computed index reaches, found by a first pass without regions.
        self.dynamic: set[int] = set()
        self.ref_types: dict[int, str] = {}
        # Offsets of the float operations folded into constants, which the harness's double-precision VM must round.
        self.folded: set[int] = set()
        # For each variable, or array table, whether the function loads it as a float and whether as an integer.
        self.load_kinds: dict[ir.Slot, set[bool]] = defaultdict(set)
        self.mixed_globals = mixed_globals(program)

    def arrays(self) -> dict[ir.Slot, int]:
        """The tables of this function, with their lengths in slots."""
        if self.frame:
            return {FRAME: self.function.local}
        return {region.key: region.length for region in (self.regions or {}).values()}

    def run(self) -> None:
        for instruction in self.function.instructions:
            offset = instruction.offset
            joined = self._resolve(offset)
            if self.pending or joined:
                # Interior and join points of a short-circuit stay in the current block.
                if offset in self.graph.blocks:
                    jumps = self.jumps_to.get(offset, ())
                    if any(jump.a2 == 0 for jump in jumps) or (not joined and jumps):
                        raise LiftError(f"jump into a short-circuit at {offset:#x}")
            elif self.current is None or self.current.exit is not None or offset in self.graph.blocks:
                self._start_block(offset)
            self._step(instruction)
        if self.pending:
            raise LiftError(f"unresolved short-circuit at {self.pending[-1].target:#x}")
        if self.current is None or self.current.exit is None:
            raise LiftError("function falls off the end")

    def _start_block(self, offset: int) -> None:
        if self.current is not None and self.current.exit is None:
            self._exit(ir.Jump(offset), offset)
        self.current = ir.LiftedBlock(offset, [])
        self.blocks[offset] = self.current

    def _require_flat(self, offset: int) -> None:
        if self.pending:
            raise LiftError(f"statement inside a short-circuit at {offset:#x}")

    def _exit(self, exit_: ir.Jump | ir.Branch | ir.Stop, offset: int) -> None:
        self._require_flat(offset)
        if self.stack:
            raise LiftError(f"value crosses a block boundary at {offset:#x}")
        self.current.exit = exit_

    def _pop(self, offset: int) -> ir.Expr:
        if not self.stack:
            raise LiftError(f"stack underflow at {offset:#x}")
        return self.stack.pop()

    def _pop_many(self, count: int, offset: int) -> tuple[ir.Expr, ...]:
        values = [self._pop(offset) for _ in range(count)]
        values.reverse()
        return tuple(values)

    def _temp(self, type_: str) -> ir.Temp:
        self.temps.append(type_)
        return ir.Temp(len(self.temps) - 1, type_)

    def _slot_type(self, slot: ir.Slot, float_access: bool) -> str:
        if float_access or slot in self.facts.float_slots:
            return FLOAT
        space, n = slot
        if space == "global" and n in self.analysis.global_types:
            return _static(self.analysis.global_types[n])
        types = set(self.facts.stores.get(slot, ()))
        if space == "local" and n < self.function.arg:
            parameter = self.analysis.param_types.get(self.function.block, {}).get(n)
            if parameter is not None:
                types.add(parameter)
        if not types:
            return INT
        return _static(functools.reduce(join, sorted(types)))

    def _emit(self, statement: ir.Statement, offset: int) -> None:
        self._require_flat(offset)
        written = _written(statement)
        calls = any(ir.has_call(expr) for expr in _expressions(statement))

        def stale(expr: ir.Expr) -> bool:
            # A value the statement would change if it were evaluated after the statement.
            return ir.has_call(expr) or bool(ir.reads(expr) & written) or (calls and _reads_global(expr))

        for i, entry in enumerate(self.stack):
            if isinstance(entry, ir.Addr):
                # A reference's variable is fixed, but an element reference's index is read when it is pushed.
                if entry.index is not None and stale(entry.index):
                    self.stack[i] = dataclasses.replace(entry, index=self._spill(entry.index, offset))
                continue
            if stale(entry):
                self.stack[i] = self._spill(entry, offset)
        self.current.statements.append(self._pin(statement, stale, offset))

    def _spill(self, expr: ir.Expr, offset: int) -> ir.Temp:
        temp = self._temp(expr.type)
        self.current.statements.append(ir.Assign(temp, expr, offset))
        return temp

    def _pin(self, statement: ir.Statement, stale, offset: int) -> ir.Statement:
        """The statement with the indices of its element references read before anything it writes changes them."""

        def pin(arg: ir.Expr) -> ir.Expr:
            if isinstance(arg, ir.Addr) and arg.index is not None and not isinstance(arg.index, (ir.Const, ir.Temp)):
                if stale(arg.index):
                    return dataclasses.replace(arg, index=self._spill(arg.index, offset))
            return arg

        if isinstance(statement, ir.ExtCall):
            return dataclasses.replace(statement, args=tuple(pin(arg) for arg in statement.args))
        if isinstance(statement, ir.CallStmt):
            call = statement.call
            return dataclasses.replace(statement, call=dataclasses.replace(call, args=tuple(pin(a) for a in call.args)))
        if isinstance(statement, ir.Assign) and isinstance(statement.value, ir.Call):
            call = statement.value
            return dataclasses.replace(statement, value=dataclasses.replace(call, args=tuple(pin(a) for a in call.args)))
        return statement

    def _mode(self, instruction: Instruction) -> AddrMode:
        try:
            return AddrMode(instruction.a2)
        except ValueError:
            raise LiftError(f"unknown address mode {instruction.a2:#x} at {instruction.offset:#x}") from None

    def _resolve(self, offset: int) -> bool:
        resolved = False
        while self.pending and self.pending[-1].target == offset:
            frame = self.pending.pop()
            if len(self.stack) != frame.depth + 1:
                raise LiftError(f"short-circuit stack mismatch at {offset:#x}")
            rhs = self.stack.pop()
            vtype = BOOL if rhs.type == BOOL else rhs.type
            self.stack.append(ir.Logical(frame.op, frame.lhs, rhs, vtype))
            resolved = True
        return resolved

    def _step(self, instruction: Instruction) -> None:
        op, offset = instruction.op, instruction.offset
        if op == Op.PUSH_CONST:
            self._push_const(instruction)
        elif op in (Op.LOAD, Op.LOAD_ADDR):
            self._load(instruction)
        elif op == Op.STORE:
            value = self._pop(offset)
            target = self._pop(offset)
            if not isinstance(target, ir.Addr):
                raise LiftError(f"store to non-address at {offset:#x}")
            if target.slot[0] == "stack":
                raise LiftError(f"store past the frame at {offset:#x}")
            if target.index is None:
                self._emit(ir.Assign(target.slot, value, offset), offset)
                self.stack.append(ir.Var(target.slot, target.type))
            else:
                element = ir.Elem(target.slot, target.index, target.type)
                self._emit(ir.Assign(element, value, offset), offset)
                self.stack.append(element)
        elif op == Op.POP:
            expr = self._pop(offset)
            if isinstance(expr, ir.Call):
                self._emit(ir.CallStmt(expr, offset), offset)
            elif ir.has_call(expr):
                self._emit(ir.Assign(self._temp(expr.type), expr, offset), offset)
        elif op in _BINARY:
            rhs = self._pop(offset)
            lhs = self._pop(offset)
            self._binary(op, lhs, rhs, offset)
        elif op in _UNARY:
            self._unary(op, self._pop(offset))
        elif op == Op.CMP:
            rhs = self._pop(offset)
            lhs = self._pop(offset)
            try:
                comparison = CompareOp(instruction.a1)
            except ValueError:
                raise LiftError(f"unknown comparison {instruction.a1} at {offset:#x}") from None
            self.stack.append(ir.Compare(comparison, lhs, rhs))
        elif op == Op.CALL:
            self._call(instruction)
        elif op == Op.EXT:
            values = self._pop_many(instruction.a1, offset)
            if not values:
                raise LiftError(f"external call without command at {offset:#x}")
            head = values[0]
            if not (isinstance(head, ir.Const) and head.type == INT):
                raise LiftError(f"dynamic external command at {offset:#x}")
            self._check_stack_outputs(values, offset)
            self._emit(ir.ExtCall(head.value, values[1:], offset), offset)
        elif op == Op.PRINT:
            self._emit(ir.Print(self._pop_many(instruction.a1, offset), offset), offset)
        elif op == Op.WAIT:
            self._emit(ir.Wait(offset), offset)
        elif op == Op.SKIP_END:
            raise LiftError("skip end unsupported")
        elif op == Op.RET:
            self._emit(ir.Return(self._pop(offset), offset), offset)
            self._exit(ir.Stop(), offset)
        elif op == Op.END:
            self._emit(ir.End(offset), offset)
            self._exit(ir.Stop(), offset)
        elif op == Op.JMP:
            self._exit(ir.Jump(self.program.jump_target(instruction)), offset)
        elif op in (Op.JMP_FALSE, Op.JMP_TRUE):
            self._conditional(instruction)

    def _check_stack_outputs(self, values: tuple[ir.Expr, ...], offset: int) -> None:
        """Rejects a native output past the frame unless its operand-stack slot is dead when the call returns.

        Such an address names the operand stack: slot local + p, where the call's command sits at depth len(stack)
        and its arguments above it. Below the command lie operands still waiting to be used, and the arguments are
        the handler's inputs, which it may read after writing. Only the command slot, which the handler never reads,
        and the free slots above the arguments are dead, since the next push overwrites them before any read.
        """
        below = len(self.stack)
        for value in values:
            if not (isinstance(value, ir.Addr) and value.slot[0] == "stack"):
                continue
            depth = value.slot[1] - self.function.local
            if depth < below:
                raise LiftError(f"native output at {offset:#x} overwrites an operand on the stack")
            if below < depth < below + len(values):
                raise LiftError(f"native output at {offset:#x} overwrites an argument of its own call")

    def _push_const(self, instruction: Instruction) -> None:
        offset = instruction.offset
        if instruction.a1 == ConstType.INT:
            self.stack.append(ir.Const(instruction.a2, INT))
        elif instruction.a1 == ConstType.FLOAT:
            self.stack.append(ir.Const(instruction.a2_float, FLOAT))
        elif instruction.a1 == ConstType.STR:
            self.stack.append(ir.Const(self.program.string(instruction), STR))
        else:
            raise LiftError(f"unknown constant type {instruction.a1} at {offset:#x}")

    def _call(self, instruction: Instruction) -> None:
        offset = instruction.offset
        callee = self.program.callee(instruction)
        args = self._pop_many(callee.arg, offset)
        callee_refs = set(self.refs.get(callee.block, ()))
        float_reads = _float_reads(callee)
        for position, arg in enumerate(args):
            if isinstance(arg, ir.Addr) and arg.slot[0] == "stack":
                raise LiftError(f"reference past the frame passed to {callee.block:#x} at {offset:#x}")
            if position in callee_refs:
                if not isinstance(arg, ir.Addr):
                    raise LiftError(f"value passed for reference parameter {position} of {callee.block:#x} at {offset:#x}")
                if arg.slot[0] == "global":
                    raise LiftError(f"global passed by reference to {callee.block:#x} at {offset:#x}")
                if position in float_reads and arg.type != FLOAT:
                    # The callee's float load retags the caller's slot, so an integer's bits would be read as a float.
                    raise LiftError(
                        f"{arg.type} variable passed by reference to parameter {position} of {callee.block:#x}, which "
                        f"the callee loads as a float, at {offset:#x}"
                    )
            elif isinstance(arg, ir.Addr):
                raise LiftError(
                    f"reference passed for parameter {position} of {callee.block:#x}, which the callee does not "
                    f"dereference, at {offset:#x}"
                )
        _check_aliases(args, offset)
        mixed_params = _mixed_slots(callee.instructions, "local")
        for position, arg in enumerate(args):
            if position in callee_refs:
                # The callee's loads of *p read the caller's variable.
                if position in float_reads:
                    self.load_kinds[arg.slot].add(True)
                if position in _int_reads(callee):
                    self.load_kinds[arg.slot].add(False)
            elif position in mixed_params and isinstance(arg, ir.Const) and arg.type == INT and arg.value != 0:
                raise LiftError(_MIXED.format(what=f"parameter {position} of {callee.block:#x}", offset=offset))
        return_type = _static(self.analysis.return_types.get(callee.block, ANY))
        call = ir.Call(callee.block, args, return_type, offset)
        if callee_refs and self.next_op.get(offset) != Op.POP:
            # The call copies its references back, so it runs as a statement before the expression that uses it.
            temp = self._temp(return_type)
            self._emit(ir.Assign(temp, call, offset), offset)
            self.stack.append(temp)
        else:
            self.stack.append(call)

    def _ref_type(self, param: int) -> str:
        """The type of the variable a reference parameter names: float when any access is float, else its callers'."""
        if param not in self.ref_types:
            if ("local", param) in self.facts.float_slots:
                found = FLOAT
            else:
                types = set()
                for fact in self.analysis.facts.values():
                    for callee, args in fact.call_args.values():
                        if callee != self.function.block or param >= len(args) or args[param].kind != "addr":
                            continue
                        arg = args[param]
                        if arg.mode in FLOAT_MODES or arg.slot in fact.float_slots:
                            types.add(FLOAT)
                        elif arg.mode in POINTER_MODES or arg.slot is None:
                            types.add(INT)
                        else:
                            types.update(fact.stores.get(arg.slot, ()) or {INT})
                found = _static(functools.reduce(join, sorted(types))) if types else INT
            self.ref_types[param] = found
        return self.ref_types[param]

    def _place(self, slot: ir.Slot, vtype: str) -> ir.Slot | ir.Elem:
        """Where a variable lives: its own Luau variable, or an element of its array's or its frame's table."""
        space, n = slot
        if space != "local":
            return slot
        if self.frame:
            return ir.Elem(FRAME, ir.Const(n, INT), vtype)
        for region in (self.regions or {}).values():
            if region.base <= n < region.base + region.length:
                return ir.Elem(region.key, ir.Const(n - region.base, INT), vtype)
        return slot

    def _load(self, instruction: Instruction) -> None:
        offset = instruction.offset
        mode = self._mode(instruction)
        float_access = mode in FLOAT_MODES
        if mode in POINTER_MODES:
            index = self._pop(offset)
            param = instruction.a1
            if param >= self.function.arg:
                raise LiftError(f"pointer index through local {param}, which is not a parameter, at {offset:#x}")
            if not (isinstance(index, ir.Const) and index.type == INT and index.value == 0):
                raise LiftError(
                    f"pointer index {_describe(index)} through parameter {param} at {offset:#x}: the callee "
                    "reaches past the variable its caller passed"
                )
            vtype = FLOAT if float_access else self._ref_type(param)
            place = self._place(("local", param), vtype)
        elif mode in INDEXED_MODES:
            index = self._pop(offset)
            base = instruction.a1
            vtype = self._slot_type(("local", base), float_access)
            if isinstance(index, ir.Const) and index.type == INT:
                n = base + index.value
                if n < 0:
                    raise LiftError(f"constant index {index.value} from local {base} reaches below the frame at {offset:#x}")
                if n >= self.function.local and instruction.op == Op.LOAD:
                    raise LiftError(f"constant index {index.value} from local {base} reads past the frame at {offset:#x}")
                # An address past the frame names an operand-stack slot; only a native call's output may use it.
                place = self._place(("local", n), vtype) if n < self.function.local else ("stack", n)
            else:
                if base in self.own_refs:
                    raise LiftError(f"computed index from reference parameter {base} at {offset:#x}")
                if ir.has_call(index) and not self.pending:
                    # The index's call runs here, before the operands that follow it.
                    temp = self._temp(index.type)
                    self._emit(ir.Assign(temp, index, offset), offset)
                    index = temp
                if self.frame:
                    place = ir.Elem(FRAME, ir.add_const(index, base), vtype)
                elif self.regions is None:
                    self.dynamic.add(base)
                    place = ir.Elem(("array", base), index, vtype)
                else:
                    place = ir.Elem(self.regions[base].key, index, vtype)
        else:
            space = "global" if mode in GLOBAL_MODES else "local"
            slot = (space, instruction.a1)
            if space == "local" and instruction.a1 in self.own_refs:
                raise LiftError(f"reference parameter {instruction.a1} used as a value at {offset:#x}")
            vtype = self._slot_type(slot, float_access)
            place = self._place(slot, vtype)
        if instruction.op == Op.LOAD:
            self.load_kinds[place.array if isinstance(place, ir.Elem) else place].add(float_access)
        if isinstance(place, ir.Elem):
            previous = self.slot_types.get(place.array)
            self.slot_types[place.array] = vtype if previous is None else _static(join(previous, vtype))
            if instruction.op == Op.LOAD:
                self.stack.append(place)
            else:
                self.stack.append(ir.Addr(place.array, vtype, place.index))
            return
        self.slot_types[place] = vtype
        if instruction.op == Op.LOAD:
            self.stack.append(ir.Var(place, vtype))
        else:
            self.stack.append(ir.Addr(place, vtype))

    def _binary(self, op: Op, lhs: ir.Expr, rhs: ir.Expr, offset: int) -> None:
        name = _BINARY[op]
        if isinstance(lhs, ir.Const) and isinstance(rhs, ir.Const) and lhs.type == rhs.type == INT:
            folded = fold(op, Value("const", INT, const=lhs.value), Value("const", INT, const=rhs.value))
            if folded is not None:
                self.stack.append(ir.Const(folded.const, INT))
                return
        if isinstance(lhs, ir.Const) and isinstance(rhs, ir.Const) and {lhs.type, rhs.type} <= {INT, FLOAT} and FLOAT in (lhs.type, rhs.type):
            value = _fold_float(op, f32(float(lhs.value)), f32(float(rhs.value)))
            if value is not None:
                self.folded.add(offset)
                self.stack.append(ir.Const(value, FLOAT))
                return
        self.stack.append(ir.Binary(name, lhs, rhs, _binary_type(name, lhs.type, rhs.type)))

    def _unary(self, op: Op, operand: ir.Expr) -> None:
        name = _UNARY[op]
        if op == Op.NEG and isinstance(operand, ir.Const) and operand.type in (INT, FLOAT):
            value = wrap32(-operand.value) if operand.type == INT else -operand.value
            self.stack.append(ir.Const(value, operand.type))
            return
        self.stack.append(ir.Unary(name, operand, _unary_type(name, operand.type)))

    def _conditional(self, instruction: Instruction) -> None:
        offset = instruction.offset
        cond = self._pop(offset)
        target = self.program.jump_target(instruction)
        if instruction.a2:
            op = "and" if instruction.op == Op.JMP_FALSE else "or"
            self.pending.append(_Frame(target, op, cond, len(self.stack)))
            return
        fallthrough = offset + INSTRUCTION_SIZE
        if instruction.op == Op.JMP_FALSE:
            self._exit(ir.Branch(cond, fallthrough, target), offset)
        else:
            self._exit(ir.Branch(cond, target, fallthrough), offset)


Interval = tuple[float, float]
_TOP: Interval = (-math.inf, math.inf)
_INT32: Interval = (-(2**31), 2**31 - 1)
_FLIP = {CompareOp.LT: CompareOp.GT, CompareOp.LE: CompareOp.GE, CompareOp.GT: CompareOp.LT, CompareOp.GE: CompareOp.LE}
_NEGATE = {
    CompareOp.EQ: CompareOp.NE,
    CompareOp.NE: CompareOp.EQ,
    CompareOp.LT: CompareOp.GE,
    CompareOp.LE: CompareOp.GT,
    CompareOp.GT: CompareOp.LE,
    CompareOp.GE: CompareOp.LT,
}


# Types whose values the interval analysis bounds. An expression typed any may hold an integer or a float at run time;
# its range is the range it has when it holds an integer, which is all that 32-bit wrapping depends on.
_BOUNDED = (INT, ANY)


def _unknown(type_: str) -> Interval:
    """The range of an expression of a type with nothing known about its value: an integer is a 32-bit value."""
    if type_ == BOOL:
        return (0, 1)
    return _INT32 if type_ in _BOUNDED else _TOP


def _unwrapped(expr: ir.Expr, state: dict) -> Interval | None:
    """The exact range of an integer sum, difference, product or negation before any 32-bit wrap, or None.

    For an operation typed any, the range is that of its result when both operands hold integers.
    """
    if (
        isinstance(expr, ir.Binary)
        and expr.type in _BOUNDED
        and expr.op in ("add", "sub", "mul")
        # A float operand makes the result a float, which never wraps.
        and FLOAT not in (expr.lhs.type, expr.rhs.type)
    ):
        (a, b), (c, d) = _interval(expr.lhs, state), _interval(expr.rhs, state)
        if expr.op == "add":
            return (a + c, b + d)
        if expr.op == "sub":
            return (a - d, b - c)
        if math.inf in (abs(a), abs(b), abs(c), abs(d)):
            return _TOP
        products = (a * c, a * d, b * c, b * d)
        return (min(products), max(products))
    if isinstance(expr, ir.Unary) and expr.type in _BOUNDED and expr.op == "neg":
        low, high = _interval(expr.operand, state)
        return (-high, -low)
    return None


def _overflows(found: Interval) -> bool:
    return found[0] < _INT32[0] or found[1] > _INT32[1]


def _interval(expr: ir.Expr, state: dict) -> Interval:
    """The range of integer values an expression can take, given the ranges of the scalars it reads.

    Integer arithmetic wraps at 32 bits, as on the PS2, so a result that may overflow can be any 32-bit value.
    """
    if isinstance(expr, ir.Const) and expr.type == INT:
        return (expr.value, expr.value)
    if isinstance(expr, (ir.Var, ir.Temp)):
        key = expr.slot if isinstance(expr, ir.Var) else ("temp", expr.index)
        found = state.get(key, _unknown(expr.type))
        if expr.type in _BOUNDED:
            # Widening may leave a bound at infinity, but an integer always holds a 32-bit value.
            found = (max(found[0], _INT32[0]), min(found[1], _INT32[1]))
        return found
    if isinstance(expr, ir.Compare) or (isinstance(expr, ir.Unary) and expr.op == "not"):
        return (0, 1)
    found = _unwrapped(expr, state)
    if found is not None:
        return _INT32 if _overflows(found) else found
    return _unknown(expr.type)


def _scalar_key(expr: ir.Expr) -> ir.Slot | None:
    """The key of a scalar the interval analysis tracks: a local, a global or a temporary."""
    if isinstance(expr, ir.Var) and expr.slot[0] in ("local", "global") and expr.type in _BOUNDED:
        return expr.slot
    if isinstance(expr, ir.Temp) and expr.type in _BOUNDED:
        return ("temp", expr.index)
    return None


def _forget_globals(state: dict) -> dict:
    """The ranges without the globals', which a script call may change."""
    return {key: found for key, found in state.items() if key[0] != "global"}


def _calls(expr: ir.Expr) -> bool:
    return ir.has_call(expr)


def _narrow(state: dict, key: ir.Slot | None, op: CompareOp, bound: Interval) -> None:
    """Narrows a scalar's range to the values for which `scalar op other` can hold, other lying in bound."""
    if key is None:
        return
    low, high = state.get(key, _INT32)
    if op == CompareOp.LT:
        high = min(high, bound[1] - 1)
    elif op == CompareOp.LE:
        high = min(high, bound[1])
    elif op == CompareOp.GT:
        low = max(low, bound[0] + 1)
    elif op == CompareOp.GE:
        low = max(low, bound[0])
    elif op == CompareOp.EQ:
        low, high = max(low, bound[0]), min(high, bound[1])
    state[key] = (low, high)


def _refine(state: dict | None, cond: ir.Expr, taken: bool) -> dict | None:
    """The scalar ranges on one edge of a branch on comparisons of integer scalars, or None when it cannot be taken."""
    if state is None:
        return None
    if isinstance(cond, ir.Logical) and (cond.op == "and") == taken:
        # Both operands of a taken "and", or of an untaken "or", decided the branch the same way.
        return _refine(_refine(state, cond.lhs, taken), cond.rhs, taken)
    if not isinstance(cond, ir.Compare):
        return state
    op = cond.op if taken else _NEGATE[cond.op]
    refined = dict(state)
    lhs_range, rhs_range = _interval(cond.lhs, state), _interval(cond.rhs, state)
    # A side narrows the other only when it surely holds an integer: a float there bounds nothing.
    narrowed = []
    if cond.rhs.type == INT and (key := _scalar_key(cond.lhs)) is not None:
        _narrow(refined, key, op, rhs_range)
        narrowed.append((key, cond.lhs.type))
    if cond.lhs.type == INT and (key := _scalar_key(cond.rhs)) is not None:
        _narrow(refined, key, _FLIP.get(op, op), lhs_range)
        narrowed.append((key, cond.rhs.type))
    for key, type_ in narrowed:
        low, high = refined[key]
        if low > high:
            if type_ == INT:
                return None
            # A value typed any that no integer satisfies holds a float on this edge, so no integer range applies.
            del refined[key]
    return refined


def _transfer(state: dict, statement: ir.Statement) -> dict:
    """The scalar ranges after a statement.

    A write through a reference leaves its variable unknown, and a script call or a wait leaves every global unknown,
    since another function may write them.
    """
    state = _before_statement(state, statement)
    if isinstance(statement, ir.Assign):
        target = statement.target
        if isinstance(target, ir.Temp):
            state[("temp", target.index)] = _interval(statement.value, state)
        elif isinstance(target, tuple) and target[0] in ("local", "global"):
            state[target] = _interval(statement.value, state)
    for expr in _expressions(statement):
        for sub in ir.walk(expr):
            if isinstance(sub, ir.Addr) and sub.index is None:
                state.pop(sub.slot, None)
    if isinstance(statement, ir.Wait) or any(_calls(expr) for expr in _expressions(statement)):
        state = _forget_globals(state)
    return state


def _before_statement(state: dict, statement: ir.Statement) -> dict:
    """The ranges in which a statement's operands are read: a call in it may run first and change the globals."""
    if isinstance(statement, ir.Wait) or any(_calls(expr) for expr in _expressions(statement)):
        return _forget_globals(state)
    return dict(state)


def _before_branch(state: dict, cond: ir.Expr) -> dict:
    """The ranges in which a branch condition is read: a call in it may change the globals."""
    return _forget_globals(state) if _calls(cond) else state


def _join(a: dict | None, b: dict) -> dict:
    if a is None:
        return b
    return {key: (min(a[key][0], b[key][0]), max(a[key][1], b[key][1])) for key in a.keys() & b.keys()}


def _widen(old: dict, new: dict, thresholds: list[int]) -> dict:
    """Widens each bound that moved to the next threshold beyond it, or to infinity."""
    widened = {}
    for key in old.keys() & new.keys():
        (a, b), (c, d) = old[key], new[key]
        low = a if c >= a else max((t for t in thresholds if t <= c), default=-math.inf)
        high = b if d <= b else min((t for t in thresholds if t >= d), default=math.inf)
        widened[key] = (low, high)
    return widened


def _thresholds(blocks: dict[int, ir.LiftedBlock]) -> list[int]:
    """The integer constants that the function compares with, and their neighbours, as widening thresholds."""
    found: set[int] = set()
    for block in blocks.values():
        exprs = [expr for statement in block.statements for expr in _expressions(statement)]
        if isinstance(block.exit, ir.Branch):
            exprs.append(block.exit.cond)
        for expr in exprs:
            for sub in ir.walk(expr):
                if isinstance(sub, ir.Compare):
                    for side in (sub.lhs, sub.rhs):
                        if isinstance(side, ir.Const) and side.type == INT:
                            found.update((side.value - 1, side.value, side.value + 1))
    return sorted(found)


def _ranges(lifter: _Lifter) -> dict[int, dict]:
    """The ranges of the integer scalars at the start of each reachable block, by an interval analysis.

    Locals start at zero and parameters are unknown. Each assignment of a constant, a variable, or a sum, difference,
    product or negation of those sets a scalar's range, a reference passed to a call or a native command makes its
    variable unknown, and a branch on a comparison of a scalar narrows the range on each edge. Array elements and
    globals are not tracked.
    """
    function = lifter.function
    entry = min(lifter.blocks)
    entry_state = {("local", n): (0, 0) for n in range(function.arg, function.local)}

    def edges(start: int, state: dict) -> list[tuple[int, dict]]:
        block = lifter.blocks[start]
        for statement in block.statements:
            state = _transfer(state, statement)
        exit_ = block.exit
        if isinstance(exit_, ir.Jump):
            return [(exit_.target, state)]
        if isinstance(exit_, ir.Branch):
            state = _before_branch(state, exit_.cond)
            return [(exit_.true_target, _refine(state, exit_.cond, True)), (exit_.false_target, _refine(state, exit_.cond, False))]
        return []

    thresholds = _thresholds(lifter.blocks)
    states: dict[int, dict] = {entry: entry_state}
    visits: dict[int, int] = defaultdict(int)
    work = [entry]
    while work:
        start = work.pop()
        visits[start] += 1
        for target, out in edges(start, states[start]):
            if out is None:
                continue
            previous = states.get(target)
            merged = _join(previous, out)
            # Loops jump backwards, so only a loop head is entered from a later block.
            if previous is not None and target <= start and visits[target] >= WIDEN_AFTER:
                merged = _widen(previous, merged, thresholds)
            if merged != previous:
                states[target] = merged
                work.append(target)
    for _ in range(NARROW_PASSES):
        # Recomputing every block from its predecessors' current states keeps the result sound and only tightens it.
        incoming: dict[int, dict] = {entry: entry_state}
        for start in sorted(states):
            for target, out in edges(start, states[start]):
                if out is not None:
                    incoming[target] = _join(incoming.get(target), out)
        states = {start: incoming[start] for start in states if start in incoming}
    return states


def _mark(expr: ir.Expr, state: dict) -> ir.Expr:
    """An expression with each integer operation that may overflow 32 bits marked to wrap, as the PS2 does."""
    if isinstance(expr, ir.Unary):
        expr = dataclasses.replace(expr, operand=_mark(expr.operand, state))
    elif isinstance(expr, (ir.Binary, ir.Compare, ir.Logical)):
        expr = dataclasses.replace(expr, lhs=_mark(expr.lhs, state), rhs=_mark(expr.rhs, state))
    elif isinstance(expr, ir.Call):
        expr = dataclasses.replace(expr, args=tuple(_mark(arg, state) for arg in expr.args))
    elif isinstance(expr, (ir.Elem, ir.Addr)) and expr.index is not None:
        expr = dataclasses.replace(expr, index=_mark(expr.index, state))
    found = _unwrapped(expr, state)
    if found is not None and _overflows(found):
        expr = dataclasses.replace(expr, wrap=True)
    return expr


def _mark_statement(statement: ir.Statement, state: dict) -> ir.Statement:
    if isinstance(statement, ir.Assign):
        target = statement.target
        if isinstance(target, ir.Elem):
            target = _mark(target, state)
        return dataclasses.replace(statement, target=target, value=_mark(statement.value, state))
    if isinstance(statement, (ir.ExtCall, ir.Print)):
        return dataclasses.replace(statement, args=tuple(_mark(arg, state) for arg in statement.args))
    if isinstance(statement, ir.CallStmt):
        return dataclasses.replace(statement, call=_mark(statement.call, state))
    if isinstance(statement, ir.Return):
        return dataclasses.replace(statement, value=_mark(statement.value, state))
    return statement


def _mark_overflows(lifter: _Lifter) -> dict[int, ir.LiftedBlock]:
    """The lifted blocks with every integer operation that the interval analysis cannot keep in 32 bits marked to wrap.

    A block the analysis never reaches is marked as if nothing were known.
    """
    states = _ranges(lifter)
    blocks: dict[int, ir.LiftedBlock] = {}
    for start, block in lifter.blocks.items():
        state = states.get(start, {})
        statements = []
        for statement in block.statements:
            state = _before_statement(state, statement)
            marked = _mark_statement(statement, state)
            statements.append(marked)
            state = _transfer(state, marked)
        exit_ = block.exit
        if isinstance(exit_, ir.Branch):
            exit_ = dataclasses.replace(exit_, cond=_mark(exit_.cond, _before_branch(state, exit_.cond)))
        blocks[start] = ir.LiftedBlock(block.start, statements, exit_)
    return blocks


def _indices_in_bounds(lifter: _Lifter) -> bool:
    """Whether every computed index into a local array provably stays inside that array, by the interval analysis.

    While every index stays in bounds, no write reaches a scalar, so the analysis need not track array elements.
    """
    lengths = {region.key: region.length for region in (lifter.regions or {}).values()}
    states = _ranges(lifter)

    def in_bounds(expr: ir.Expr, state: dict) -> bool:
        for sub in ir.walk(expr):
            index = None
            if isinstance(sub, ir.Elem):
                key, index = sub.array, sub.index
            elif isinstance(sub, ir.Addr) and sub.index is not None:
                key, index = sub.slot, sub.index
            if index is None or isinstance(index, ir.Const):
                continue
            low, high = _interval(index, state)
            if low < 0 or high >= lengths[key]:
                return False
        return True

    for start, block in lifter.blocks.items():
        state = states.get(start)
        if state is None:
            # A block the analysis never reaches cannot run.
            continue
        for statement in block.statements:
            targets = [statement.target] if isinstance(statement, ir.Assign) and isinstance(statement.target, ir.Elem) else []
            state = _before_statement(state, statement)
            if not all(in_bounds(expr, state) for expr in (*targets, *_expressions(statement))):
                return False
            state = _transfer(state, statement)
        if isinstance(block.exit, ir.Branch) and not in_bounds(block.exit.cond, _before_branch(state, block.exit.cond)):
            return False
    return True
