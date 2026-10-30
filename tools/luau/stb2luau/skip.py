"""Skip mode of event scripts: which resume points a function has, and what skipping does after each of them.

Skip mode runs a suspended script on to the next SKIP_END without calling anything. The machine takes no jump, pops
no jump condition, drops every external call, falls through every wait and still executes every store and print, so
the script runs its code from the wait to the next SKIP_END in layout order. A call enters its callee, which runs the
same way up to its first RET, and the caller goes on after the call. A RET before the SKIP_END leaves the function in
skip mode, and the caller goes on in the same way.

A function's resume points are its waits and its calls of functions that may wait. The Luau module cannot run the
retail instructions, so this module derives from the bytecode what skipping from each resume point changes:

- A stream that ends at a RET (or END) must change nothing the function's caller can see. Stores to the function's own
  variables are dead once it returns, so the stream is accepted when it stores nothing through a reference parameter or
  to a global, prints nothing and calls only functions that do the same up to their RET. Otherwise the function is
  refused.
- A stream that ends at a SKIP_END continues inside the function, so its stores matter. The stream from the start of
  the section (the code since the function's entry or the last SKIP_END) to this SKIP_END is rebuilt as a straight-line
  synthetic function that the ordinary lifter lifts, and the statements after each resume point become that point's
  chunk of the section's skip function.

A call in a stream runs its callee linearly from the entry to its first RET. That run is a synthetic function, the
callee's twin, which the ordinary lifter lifts and the module calls like any helper. The call a script was suspended in
is the one exception: its callee is partway through, so the statements that would use its result are refused.
"""

from __future__ import annotations

import dataclasses
from collections.abc import Callable

from stb.opcodes import GLOBAL_MODES, INDEXED_MODES, POINTER_MODES, AddrMode, Op
from stb.program import Function, Instruction, Program

from . import ir

INSTRUCTION_SIZE = 12
# Offset space of the synthetic functions (streams and twins), which no script reaches. Their blocks are numbered from
# the same base, so that a block is also an address that a CALL can name relative to the code.
SYNTHETIC_BASE = ir.SYNTHETIC_BASE
SYNTHETIC_SPAN = 0x100000
LIVE = frozenset(("global", "print", "bad"))

_UNARY = frozenset((Op.NEG, Op.NOT, Op.ITOF, Op.FTOI, Op.SIN, Op.COS))
_BINARY = frozenset((Op.ADD, Op.SUB, Op.MUL, Op.DIV, Op.MOD, Op.AND, Op.OR, Op.CMP))
_JUMPS = frozenset((Op.JMP, Op.JMP_FALSE, Op.JMP_TRUE))
_LOCAL_LOADS = (AddrMode.LOCAL, AddrMode.LOCAL_FLOAT)


class SkipError(ValueError):
    """A function whose skip mode the translation cannot reproduce."""


@dataclasses.dataclass
class Resume:
    """A point where a script can be suspended: a wait, or a call that may reach one."""

    index: int
    offset: int
    ordinal: int
    is_call: bool
    # Index of the run the resume point is in.
    run: int = 0
    # The operand stack under the value a call pushes, as kinds of slot.
    seed: list[str] = dataclasses.field(default_factory=list)
    # A resume point that stands for the start of a run, where a script enters in skip mode: the function's entry when
    # a skipped stream calls it, or the point after a skip end when skip mode is requested again there.
    entry: bool = False


@dataclasses.dataclass
class Run:
    """Code from the start of a function or just after a terminal up to and including the next terminal.

    Skip mode, resumed anywhere in a run, runs to its end. The terminal is a SKIP_END (the script is suspended there) or
    a RET or END (the function returns in skip mode).
    """

    start: int
    end: int
    terminal: str
    resumes: list[Resume] = dataclasses.field(default_factory=list)
    # Whether skipping leaves anything to execute: stores or prints after a resume point, or any return value.
    needs_code: bool = False
    # Block of the synthetic function that runs the run straight through, and the original offset of each instruction.
    stream: int | None = None
    origins: dict[int, int] = dataclasses.field(default_factory=dict)


@dataclasses.dataclass
class FunctionPlan:
    """The live resume points and runs of one function, and whether it catches skip mode on its way out.

    A guarded function runs its returning tails and hands the values it returns to its caller, which skip mode then
    continues in. A function that takes references is always guarded, since its references must reach the caller.
    """

    block: int
    resumes: list[Resume]
    runs: list[Run]
    skip_ends: int
    guarded: bool = False

    @property
    def by_offset(self) -> dict[int, int]:
        """The ordinal of each resume point, by the offset of its instruction."""
        return {resume.offset: resume.ordinal for resume in self.resumes if not resume.entry}

    @property
    def entries(self) -> dict[int, int]:
        """The ordinal of the entry resume point of each run that has one, by the index of the run."""
        return {resume.run: resume.ordinal for resume in self.resumes if resume.entry}


@dataclasses.dataclass
class Plan:
    """The skip plans of a script: its functions, the synthetic functions, and the functions it refuses.

    synthetic holds the straight-line stream of each section that needs one and the twin of each function those streams
    call; a twin is a function run linearly from its entry to its first RET, as skip mode runs a callee.
    """

    functions: dict[int, FunctionPlan]
    synthetic: dict[int, Function]
    errors: dict[int, str]
    twins: dict[int, int] = dataclasses.field(default_factory=dict)
    # The functions that skipped streams call and that suspend inside skip mode, which enter in skip mode.
    entered: frozenset[int] = frozenset()
    # The function twins call for a store through the zero a local starts with, which returns the value it is given.
    discard: int | None = None


@dataclasses.dataclass
class Summary:
    """What running a function linearly from its entry to its first RET does outside its own frame."""

    live: frozenset[str] = frozenset()
    # Reference parameters the run writes through.
    writes: frozenset[int] = frozenset()
    reason: str | None = None
    # Whether the run reaches a SKIP_END before its RET, directly or in a callee: skip mode then suspends inside it.
    suspends: bool = False
    # What the run returns: "zero" when it is a local nothing stored to, else "value".
    returns: str = "value"


@dataclasses.dataclass
class _Walk:
    """What a linear walk of instructions did: the kinds of store it makes and the way it ended."""

    effects: set[str] = dataclasses.field(default_factory=set)
    writes: set[int] = dataclasses.field(default_factory=set)
    terminal: Op | None = None
    stopped: int = 0
    reasons: list[str] = dataclasses.field(default_factory=list)
    # What a run that ends at its RET returns: "zero" or "value".
    returns: str = "value"
    # The indices of the STOREs whose target is the zero a local starts with, which store nowhere the script sees.
    null_stores: set[int] = dataclasses.field(default_factory=set)
    # The callees the walk enters that suspend in skip mode.
    suspending: set[int] = dataclasses.field(default_factory=set)


def may_wait(program: Program, entered: frozenset[int] = frozenset()) -> frozenset[int]:
    """The blocks of the functions that contain a wait, are entered in skip mode, or call one that does."""
    waits = {block for block, function in program.functions.items() if any(i.op == Op.WAIT for i in function.instructions)}
    waits |= entered
    callers: dict[int, set[int]] = {}
    for block, function in program.functions.items():
        for instruction in function.instructions:
            if instruction.op == Op.CALL:
                callers.setdefault(program.callee(instruction).block, set()).add(block)
    found = set(waits)
    todo = list(waits)
    while todo:
        for caller in callers.get(todo.pop(), ()):
            if caller not in found:
                found.add(caller)
                todo.append(caller)
    return frozenset(found)


def _address_class(mode: int, slot: int) -> str:
    if mode in GLOBAL_MODES:
        return "global"
    if mode in POINTER_MODES:
        return f"ptr:{slot}"
    if mode in INDEXED_MODES:
        return "array"
    return "local"


class _Machine:
    """The operand stack of a linear walk, holding what kind of value each slot is: a value or an address."""

    def __init__(
        self,
        program: Program,
        arg: int,
        summarize: Callable[[Function], Summary],
        stack: list[str] | None = None,
        from_entry: bool = False,
    ) -> None:
        self.program = program
        self.arg = arg
        self.summarize = summarize
        self.stack = list(stack or [])
        self.result = _Walk()
        self.underflow = False
        # A walk from the function's entry knows its locals start as zero until it stores to them.
        self.from_entry = from_entry
        self.locals: dict[int, str] = {}
        self.index = 0

    def pop(self) -> str:
        if not self.stack:
            self.underflow = True
            return "value"
        return self.stack.pop()

    def step(self, instruction: Instruction) -> bool:
        """Runs one instruction as skip mode does; returns True when it ends the walk."""
        op = instruction.op
        stack, result = self.stack, self.result
        if op in (Op.LOAD, Op.LOAD_ADDR):
            if instruction.a2 in INDEXED_MODES:
                self.pop()
            if op == Op.LOAD_ADDR:
                address = _address_class(instruction.a2, instruction.a1)
                stack.append(f"local:{instruction.a1}" if address == "local" else address)
            elif instruction.a2 in _LOCAL_LOADS and instruction.a1 < self.arg:
                stack.append(f"param:{instruction.a1}")
            elif instruction.a2 in _LOCAL_LOADS and self.from_entry:
                stack.append(self.locals.get(instruction.a1, "zero"))
            else:
                stack.append("value")
        elif op == Op.PUSH_CONST:
            stack.append("value")
        elif op == Op.POP:
            self.pop()
        elif op == Op.STORE:
            value, target = self.pop(), self.pop()
            if target.startswith("local:"):
                self.locals[int(target[6:])] = "zero" if value == "zero" else "value"
            if target == "zero":
                self.result.null_stores.add(self.index)
            self._store(target)
            stack.append(value)
        elif op in _UNARY:
            self.pop()
            stack.append("value")
        elif op in _BINARY:
            self.pop()
            self.pop()
            stack.append("value")
        elif op == Op.PRINT:
            for _ in range(instruction.a1):
                self.pop()
            result.effects.add("print")
        elif op == Op.EXT:
            for _ in range(instruction.a1):
                self.pop()
        elif op == Op.CALL:
            callee = self.program.callee(instruction)
            args = [self.pop() for _ in range(callee.arg)][::-1]
            summary = self.summarize(callee)
            if summary.suspends:
                # The callee runs in skip mode and may be resumed normally, so what it does is not known here: every
                # address it receives may be written.
                result.suspending.add(callee.block)
                result.effects.add("suspend")
                for arg in args:
                    if arg != "value":
                        self._store(arg)
            else:
                if summary.reason:
                    result.reasons.append(f"{callee.block:#x}: {summary.reason}")
                result.effects |= summary.live
                for position in summary.writes:
                    self._store(args[position] if position < len(args) else "value")
            for arg in args:
                if arg.startswith("local:"):
                    # The callee may write the local through the reference.
                    self.locals[int(arg[6:])] = "value"
            stack.append(summary.returns if not summary.suspends else "value")
        elif op in (Op.SKIP_END, Op.RET, Op.END):
            if op == Op.RET and stack:
                result.returns = "zero" if stack[-1] == "zero" else "value"
            result.terminal = op
            return True
        return False

    def _store(self, target: str) -> None:
        """Records a store to an address of the given kind."""
        if target.startswith("ptr:"):
            self.result.effects.add("ptr")
            self.result.writes.add(int(target[4:]))
        elif target.startswith("param:"):
            self.result.effects.add("ptr")
            self.result.writes.add(int(target[6:]))
        elif target in ("local", "array", "global") or target.startswith("local:"):
            self.result.effects.add("local" if target.startswith("local:") else target)
        elif target == "zero":
            # Retail writes through the address 0, outside the script's memory: nothing the script reads changes.
            pass
        else:
            self.result.effects.add("bad")


def walk(
    program: Program,
    instructions: list[Instruction],
    start: int,
    stop: int | None = None,
    stack: list[str] | None = None,
    *,
    arg: int,
    summarize: Callable[[Function], Summary],
) -> _Walk:
    """Walks instructions linearly as skip mode does, from index start to the first SKIP_END, RET or END."""
    machine = _Machine(program, arg, summarize, stack, from_entry=start == 0 and not stack)
    for index in range(start, len(instructions) if stop is None else stop):
        machine.index = index
        if machine.step(instructions[index]):
            machine.result.stopped = index
            return machine.result
    machine.result.stopped = len(instructions)
    return machine.result


class _Summaries:
    """The summaries of functions run linearly from their entry to their first RET."""

    def __init__(self, program: Program) -> None:
        self.program = program
        self.memo: dict[int, Summary] = {}

    def summary(self, function: Function) -> Summary:
        """The summary of a function; a call cycle or a run that does not end at a RET carries a reason."""
        block = function.block
        if block not in self.memo:
            self.memo[block] = Summary(reason="it calls itself")
            found = walk(self.program, function.instructions, 0, arg=function.arg, summarize=self.summary)
            suspends = found.terminal == Op.SKIP_END or bool(found.suspending)
            reason = None
            if suspends:
                pass
            elif found.terminal != Op.RET:
                reason = f"its linear run ends at {found.terminal.name if found.terminal else 'the end of the function'}"
            elif found.reasons:
                reason = found.reasons[0]
            self.memo[block] = Summary(
                frozenset(found.effects & LIVE), frozenset(found.writes), reason, suspends, found.returns
            )
        return self.memo[block]


def leaders(program: Program, instructions: list[Instruction]) -> list[int]:
    """Indices where a basic block starts: the entry, jump targets and the instruction after a jump or exit."""
    index_of = {instruction.offset: index for index, instruction in enumerate(instructions)}
    found = {0}
    for index, instruction in enumerate(instructions):
        if instruction.op in _JUMPS:
            found.add(index_of[program.jump_target(instruction)])
        if instruction.op in _JUMPS or instruction.op in (Op.RET, Op.END):
            found.add(index + 1)
    return sorted(found)


def pending_after_call(
    program: Program, function: Function, block_start: int, call: int, summarize: Callable[[Function], Summary]
) -> list[str] | None:
    """The operand stack just after a call, found by running its basic block up to it; None if it starts mid-expression."""
    machine = _Machine(program, function.arg, summarize)
    for index in range(block_start, call + 1):
        machine.step(function.instructions[index])
    return None if machine.underflow else machine.stack


class _Builder:
    """Builds the synthetic functions of a script: section streams and the twins of the functions they call."""

    def __init__(self, program: Program) -> None:
        self.program = program
        self.functions: dict[int, Function] = {}
        self.twins: dict[int, int] = {}
        self.summaries = _Summaries(program)
        self.count = 0
        self.discard: int | None = None

    def _new(self) -> tuple[int, int]:
        number = self.count
        self.count += 1
        base = SYNTHETIC_BASE + number * SYNTHETIC_SPAN
        return base, base

    def twin(self, callee: Function) -> int:
        """The block of the function that runs a callee linearly to its first RET."""
        if callee.block in self.twins:
            return self.twins[callee.block]
        summary = self.summaries.summary(callee)
        if summary.reason:
            raise SkipError(f"skipping runs {callee.block:#x}, and {summary.reason}")
        block, base = self._new()
        self.twins[callee.block] = block
        null_stores = walk(self.program, callee.instructions, 0, arg=callee.arg, summarize=self.summaries.summary).null_stores
        out: list[Instruction] = []
        for index, instruction in enumerate(callee.instructions):
            if index in null_stores:
                # The store's target is a local's starting zero: the function that keeps the value stands for it.
                out.append(Instruction(base + len(out) * INSTRUCTION_SIZE, Op.CALL, 0, self._discard() - self.program.code))
            else:
                self._translate(instruction, out, base)
            if instruction.op == Op.RET:
                break
        self.functions[block] = Function(block, 0, callee.local, callee.arg, out, False)
        return block

    def _discard(self) -> int:
        """The block of a function of a target and a value that returns the value, as a store through nowhere leaves it."""
        if self.discard is None:
            block, base = self._new()
            out = [
                Instruction(base, Op.LOAD, 1, AddrMode.LOCAL),
                Instruction(base + INSTRUCTION_SIZE, Op.RET, 0, 0),
            ]
            self.functions[block] = Function(block, 0, 2, 2, out, False)
            self.discard = block
        return self.discard

    def stream(self, function: Function, run: Run) -> tuple[int, dict[int, int]]:
        """The block of a straight-line function that runs a run as skip mode does, and each instruction's origin.

        A run that ends at a RET keeps it, so the stream returns what the function returns in skip mode.
        """
        block, base = self._new()
        out: list[Instruction] = []
        origins: dict[int, int] = {}
        stop = run.end + 1 if function.instructions[run.end].op == Op.RET else run.end
        for index in range(run.start, stop):
            before = len(out)
            self._translate(function.instructions[index], out, base)
            for instruction in out[before:]:
                origins[instruction.offset] = function.instructions[index].offset
        end = function.instructions[run.end].offset
        if stop == run.end:
            for op, a1, a2 in ((Op.PUSH_CONST, 1, 0), (Op.RET, 0, 0)):
                instruction = Instruction(base + len(out) * INSTRUCTION_SIZE, op, a1, a2)
                out.append(instruction)
                origins[instruction.offset] = end
        self.functions[block] = Function(block, 0, function.local, function.arg, out, False)
        return block, origins

    def _translate(self, instruction: Instruction, out: list[Instruction], base: int) -> None:
        """Appends the instructions that stand for one instruction in a straight-line skip run."""

        def add(op: Op, a1: int = 0, a2: int = 0) -> None:
            out.append(Instruction(base + len(out) * INSTRUCTION_SIZE, op, a1, a2))

        op = instruction.op
        if op in _JUMPS or op in (Op.WAIT, Op.END, Op.LABEL, Op.SKIP_END):
            add(Op.LABEL)
        elif op == Op.EXT:
            for _ in range(instruction.a1):
                add(Op.POP)
        elif op == Op.CALL:
            callee = self.program.callee(instruction)
            if self.summaries.summary(callee).suspends:
                # Skip mode enters this callee itself: it suspends partway and may be resumed normally.
                add(Op.CALL, instruction.a1, callee.block - self.program.code)
            else:
                add(Op.CALL, instruction.a1, self.twin(callee) - self.program.code)
        else:
            add(op, instruction.a1, instruction.a2)


def plan(program: Program, refs: dict[int, tuple[int, ...]]) -> Plan:
    """Plans the skip mode of every function of a script that can be suspended; refs gives each function its references.

    Skip mode enters a callee that suspends (its linear run reaches a SKIP_END), so that callee needs resume points at
    the start of every run, and a skip requested again at a skip end needs one where the code that follows it calls such
    a callee. Planning is repeated until no further entry is found.
    """
    entered: frozenset[int] = frozenset()
    entries: dict[int, frozenset[int]] = {}
    while True:
        found, more_entered, more_entries = _plan_once(program, refs, entered, entries)
        grown = {
            block: entries.get(block, frozenset()) | extra for block, extra in more_entries.items()
        }
        if more_entered <= entered and all(extra <= entries.get(block, frozenset()) for block, extra in more_entries.items()):
            found.entered = entered
            return found
        entered |= more_entered
        entries = {**entries, **grown}


def _entry_indices(program: Program, block: int, entered: frozenset[int], entries: dict[int, frozenset[int]]) -> frozenset[int]:
    """Where a function has entry resume points: -1 for its start, and the index of each SKIP_END they follow."""
    found = set(entries.get(block, ()))
    if block in entered:
        found.add(-1)
        found |= {index for index, i in enumerate(program.functions[block].instructions) if i.op == Op.SKIP_END}
    return frozenset(found)


def _linear_acts(program: Program, function: Function, start: int, summaries: _Summaries) -> tuple[bool, Op | None]:
    """Whether the straight run from start does anything skip mode must reproduce, and the terminal that ends it.

    Up to a skip end every store counts, since the code after it reads the frame; up to a return only what outlives the
    frame does. Calling a function that suspends always counts.
    """
    walked = walk(program, function.instructions, start, arg=function.arg, summarize=summaries.summary)
    if walked.terminal == Op.SKIP_END:
        return bool(walked.effects), walked.terminal
    return bool(walked.effects & {"ptr", "global", "print", "bad", "suspend"}) or bool(walked.reasons), walked.terminal


def _plan_once(
    program: Program, refs: dict[int, tuple[int, ...]], entered: frozenset[int], entries: dict[int, frozenset[int]]
) -> tuple[Plan, frozenset[int], dict[int, frozenset[int]]]:
    """One planning pass; also returns the functions and entries it found skipped streams to need."""
    waiting = may_wait(program, entered)
    builder = _Builder(program)
    scanned: dict[int, FunctionPlan] = {}
    errors: dict[int, str] = {}
    for block in sorted(waiting):
        try:
            scanned[block] = _scan(program, program.functions[block], waiting, _entry_indices(program, block, entered, entries))
        except SkipError as error:
            errors[block] = str(error)
    # A call is a live resume point when its callee can hand skip mode back, by returning while skipping.
    escapes: dict[int, bool] = {block: False for block in scanned}
    changed = True
    while changed:
        changed = False
        for block, found in scanned.items():
            if not escapes[block] and any(
                _live(program, found, r, escapes) and found.runs[r.run].terminal == "return" for r in found.resumes
            ):
                escapes[block] = changed = True
    plans: dict[int, FunctionPlan] = {}
    valued: set[int] = set()
    for block, found in scanned.items():
        found.resumes = [r for r in found.resumes if _live(program, found, r, escapes)]
        instructions = program.functions[block].instructions
        for resume in found.resumes:
            # A call whose result is used needs its callee to hand the result back.
            if resume.is_call and instructions[resume.index + 1].op != Op.POP:
                valued.add(program.callee(instructions[resume.index]).block)
    suspending: set[int] = set()
    for block, found in scanned.items():
        function = program.functions[block]
        try:
            if not found.resumes:
                continue
            for run in found.runs:
                run.resumes = [r for r in run.resumes if r in found.resumes]
            suspending |= _check(program, function, found, builder)
            found.guarded = bool(refs.get(block)) or block in valued or any(
                run.terminal == "return" and run.needs_code for run in found.runs
            )
            for run in found.runs:
                wanted = run.needs_code if run.terminal == "skip_end" else found.guarded and bool(run.resumes)
                if run.resumes and wanted:
                    run.needs_code = True
                    run.stream, run.origins = builder.stream(function, run)
        except SkipError as error:
            errors[block] = str(error)
            continue
        plans[block] = found
    wanted_entries = _repeat_entries(program, plans, builder.summaries)
    return (
        Plan(plans, builder.functions, errors, builder.twins, discard=builder.discard),
        frozenset(suspending),
        wanted_entries,
    )


def _repeat_entries(program: Program, plans: dict[int, FunctionPlan], summaries: _Summaries) -> dict[int, frozenset[int]]:
    """The skip ends after which a skip requested again runs code that skip mode must reproduce.

    Skip mode requested at a skip end runs the code that follows in layout order, without its jumps, where the
    structured body would branch. That matters when the run does anything (stores, prints, or calls a function that
    suspends), or when it ends at a RET and a caller does anything in layout order after its call. Only skip ends that
    skip mode can stop at are considered.
    """
    callers: dict[int, list[tuple[int, int]]] = {}
    for block, function in program.functions.items():
        for index, instruction in enumerate(function.instructions):
            if instruction.op == Op.CALL:
                callers.setdefault(program.callee(instruction).block, []).append((block, index))
    memo: dict[int, bool] = {}

    def returns_into_action(block: int) -> bool:
        """Whether some caller of a function, run on in layout order after the call, does anything before it stops."""
        if block in memo:
            return memo[block]
        memo[block] = False
        for caller, index in callers.get(block, ()):
            acts, terminal = _linear_acts(program, program.functions[caller], index + 1, summaries)
            if acts or (terminal in (Op.RET, Op.END) and returns_into_action(caller)):
                memo[block] = True
                break
        return memo[block]

    wanted: dict[int, frozenset[int]] = {}
    for block, found in plans.items():
        stops = {run.end for run in found.runs if run.terminal == "skip_end" and run.resumes}
        chosen = set()
        for index in sorted(stops):
            acts, terminal = _linear_acts(program, program.functions[block], index + 1, summaries)
            if acts or (terminal in (Op.RET, Op.END) and returns_into_action(block)):
                chosen.add(index)
        if chosen:
            wanted[block] = frozenset(chosen)
    return wanted


def _live(program: Program, found: FunctionPlan, resume: Resume, escapes: dict[int, bool]) -> bool:
    """Whether skip mode can be suspended at a resume point: always at a wait, at a call whose callee can return in it."""
    if not resume.is_call:
        return True
    return escapes.get(program.callee(program.functions[found.block].instructions[resume.index]).block, False)


def _scan(program: Program, function: Function, waiting: frozenset[int], entries: frozenset[int] = frozenset()) -> FunctionPlan:
    """The resume points of a function, with the run each one is in.

    entries gives the indices after which a run starts that skip mode can enter: -1 for the start of the function, and
    the index of a SKIP_END for the run that follows it.
    """
    instructions = function.instructions
    points: list[Resume] = []
    for index, instruction in enumerate(instructions):
        is_call = instruction.op == Op.CALL
        if instruction.op == Op.WAIT or (is_call and program.callee(instruction).block in waiting):
            points.append(Resume(index, instruction.offset, 0, is_call))
    for index in entries:
        offset = instructions[index].offset if index >= 0 else -1
        points.append(Resume(index, offset, 0, False, entry=True))
    points.sort(key=lambda resume: resume.index)
    resumes: list[Resume] = []
    for ordinal, resume in enumerate(points, start=1):
        resume.ordinal = ordinal
        resumes.append(resume)
    runs: list[Run] = []
    start = 0
    for index, instruction in enumerate(instructions):
        if instruction.op in (Op.SKIP_END, Op.RET, Op.END):
            runs.append(Run(start, index, "skip_end" if instruction.op == Op.SKIP_END else "return"))
            start = index + 1
    if start < len(instructions):
        raise SkipError("the function runs off its end")
    for resume in resumes:
        position = resume.index + 1 if resume.entry else resume.index
        resume.run = next(number for number, run in enumerate(runs) if run.start <= position <= run.end)
        runs[resume.run].resumes.append(resume)
    return FunctionPlan(function.block, resumes, runs, sum(1 for i in instructions if i.op == Op.SKIP_END))


def _check(program: Program, function: Function, found: FunctionPlan, builder: _Builder) -> set[int]:
    """Validates what skipping does after each live resume point and marks the runs that have something to execute.

    Returns the functions the skipped streams call that suspend, which skip mode enters.
    """
    instructions = function.instructions
    summarize = builder.summaries.summary
    starts = leaders(program, instructions)
    suspending: set[int] = set()
    for resume in found.resumes:
        where = f"{resume.offset:#x}" if resume.offset >= 0 else "the start of the function"
        if resume.is_call:
            block_start = max(start for start in starts if start <= resume.index)
            seed = pending_after_call(program, function, block_start, resume.index, summarize)
            if seed is None:
                raise SkipError(f"the call at {where} that may wait starts in the middle of an expression")
            resume.seed = seed
        run = found.runs[resume.run]
        walked = walk(program, instructions, resume.index + 1, run.end, resume.seed, arg=function.arg, summarize=summarize)
        if walked.reasons:
            raise SkipError(f"skipping from {where} calls {walked.reasons[0]}")
        if "bad" in walked.effects:
            raise SkipError(f"skipping from {where} stores through a value that is not an address")
        suspending |= walked.suspending
        if run.terminal == "skip_end" and walked.effects:
            run.needs_code = True
        elif run.terminal == "return" and walked.effects & {"ptr", "global", "print", "suspend"}:
            run.needs_code = True
    return suspending


def with_synthetic(program: Program, plan_: Plan) -> Program:
    """The program with the synthetic functions added, for analysis and lifting."""
    if not plan_.synthetic:
        return program
    functions = dict(program.functions)
    functions.update(plan_.synthetic)
    return dataclasses.replace(program, functions=functions)


def shift_temps(value: object, base: int) -> object:
    """A statement or expression with every temporary renumbered by base, so a stream's temporaries follow its function's."""
    if isinstance(value, ir.Temp):
        return ir.Temp(value.index + base, value.type)
    if isinstance(value, list):
        return [shift_temps(item, base) for item in value]
    if isinstance(value, tuple):
        return tuple(shift_temps(item, base) for item in value)
    if dataclasses.is_dataclass(value) and not isinstance(value, type):
        return dataclasses.replace(
            value, **{field.name: shift_temps(getattr(value, field.name), base) for field in dataclasses.fields(value)}
        )
    return value


def _statement_exprs(stmt) -> list[ir.Expr]:
    if isinstance(stmt, ir.Assign):
        return [stmt.value, *([stmt.target] if isinstance(stmt.target, ir.Elem) else [])]
    if isinstance(stmt, ir.Print):
        return list(stmt.args)
    if isinstance(stmt, ir.CallStmt):
        return [stmt.call]
    if isinstance(stmt, ir.Return):
        return [stmt.value]
    return []


def _reads_temp(statements: list, index: int) -> bool:
    return any(
        isinstance(sub, ir.Temp) and sub.index == index
        for stmt in statements
        for expr in _statement_exprs(stmt)
        for sub in ir.walk(expr)
    )


@dataclasses.dataclass
class Chunks:
    """What skipping a run leaves to execute: statements by resume point, prologues, and the value it returns."""

    chunks: list[tuple[int, list]]
    prologues: dict[int, list]
    value: ir.Expr | None


def build_chunks(
    function: Function,
    run: Run,
    statements: list,
    temp_base: int,
    callee_refs: dict[int, tuple[int, ...]],
    guarded: dict[int, bool],
    program: Program,
) -> Chunks:
    """The chunks of a run from the statements its lifted stream function leaves.

    A statement goes to the chunk of the last resume point before it. The call a script was suspended in is not made
    again: when its callee is guarded, a prologue stores what the callee handed back (its result, then its
    references); otherwise nothing it did can be seen, and nothing may use its result.
    """
    index_of = {instruction.offset: index for index, instruction in enumerate(function.instructions)}
    suspended = {resume.offset: resume for resume in run.resumes if resume.is_call}
    shifted = shift_temps(statements, temp_base)
    chunks: dict[int, list] = {}
    prologues: dict[int, list] = {}
    value: ir.Expr | None = None
    kept: list = []
    for stmt in shifted:
        if isinstance(stmt, ir.Return):
            value = stmt.value
            continue
        if not isinstance(stmt, (ir.Assign, ir.Print, ir.CallStmt)):
            raise SkipError(f"the stream at {function.instructions[run.start].offset:#x} holds a {type(stmt).__name__}")
        kept.append(stmt)
    ordered = sorted(run.resumes, key=lambda resume: resume.index)
    for stmt in kept:
        origin = index_of[run.origins[stmt.offset]]
        calls = [sub for expr in _statement_exprs(stmt) for sub in ir.walk(expr) if isinstance(sub, ir.Call)]
        resumed = [call for call in calls if run.origins.get(call.offset) in suspended]
        owner = [resume for resume in ordered if resume.index < origin]
        if resumed:
            call = resumed[0]
            resume = suspended[run.origins[call.offset]]
            callee = program.callee(function.instructions[resume.index]).block
            sole = len(calls) == 1 and (isinstance(stmt, ir.CallStmt) or (isinstance(stmt, ir.Assign) and stmt.value == call))
            # In skip mode a conditional jump leaves its condition on the stack, which the stream spills into a
            # temporary nothing reads: the call's result reaches nothing there either.
            dangling = (
                len(calls) == 1
                and isinstance(stmt, ir.Assign)
                and isinstance(stmt.target, ir.Temp)
                and not _reads_temp([s for s in kept if s is not stmt], stmt.target.index)
            )
            if not sole and not dangling:
                raise SkipError(f"a skipped statement at {run.origins[stmt.offset]:#x} uses the result of the call it was suspended in")
            if guarded.get(callee):
                prologue = prologues.setdefault(resume.ordinal, [])
                if isinstance(stmt, ir.Assign) and sole:
                    prologue.append(ir.Assign(stmt.target, ir.Received(0, call.type)))
                for number, position in enumerate(callee_refs.get(callee, ()), start=1):
                    arg = call.args[position]
                    if not isinstance(arg, ir.Addr):
                        raise SkipError(f"call at {resume.offset:#x} passes a value for a reference")
                    target = ir.Elem(arg.slot, arg.index, arg.type) if arg.index is not None else arg.slot
                    prologue.append(ir.Assign(target, ir.Received(number, arg.type)))
            elif isinstance(stmt, ir.Assign) and not (
                isinstance(stmt.target, ir.Temp) and not _reads_temp([s for s in kept if s is not stmt], stmt.target.index)
            ):
                raise SkipError(f"the result of the call at {resume.offset:#x} is stored, but its callee is not guarded")
            # The call itself runs only when skipping from an earlier resume point.
            owner = [earlier for earlier in ordered if earlier.index < resume.index]
            spilled = sum(
                1 for other in kept for expr in _statement_exprs(other) for sub in ir.walk(expr)
                if isinstance(sub, ir.Call) and sub.offset == call.offset
            )
            if owner and spilled > 1:
                raise SkipError(f"the call at {resume.offset:#x} the script was suspended in is spilled twice")
        if not owner:
            continue
        chunks.setdefault(owner[-1].ordinal, []).append(stmt)
    return Chunks(sorted(chunks.items()), prologues, value)


def split_sections(body: list, wanted: list[bool], skips: list[ir.Skip | None], entries: dict[int, int] | None = None) -> list:
    """The function body with the statements before each top-level SkipEnd that needs one gathered into a section.

    entries gives the ordinal of the entry resume point of each stretch between skip ends (counting from 0), which
    becomes the first statement of that stretch.
    """
    entries = entries or {}
    result: list = []
    current: list = [ir.Entry(entries[0])] if 0 in entries else []
    count = 0
    for stmt in body:
        if isinstance(stmt, ir.SkipEnd):
            if count >= len(wanted):
                raise SkipError("more skip ends than the bytecode has")
            if wanted[count]:
                result.append(ir.Section(current, skips[count]))
                current = []
            else:
                current.append(stmt)
            count += 1
            if count in entries:
                current.append(ir.Entry(entries[count]))
        else:
            current.append(stmt)
    result.extend(current)
    if count != len(wanted):
        raise SkipError("a skip end is inside a branch or loop")
    return result


def _expressions(stmt) -> list[ir.Expr]:
    """The expressions a statement evaluates itself, not those of the statements nested in it."""
    if isinstance(stmt, ir.If):
        return [stmt.cond]
    if isinstance(stmt, (ir.While, ir.Repeat)):
        return [stmt.cond]
    if isinstance(stmt, ir.NumericFor):
        return [stmt.start, stmt.limit, stmt.step]
    if isinstance(stmt, ir.ExtCall):
        return list(stmt.args)
    return _statement_exprs(stmt)


def _calls_at(stmt, offset: int) -> list[ir.Call]:
    return [sub for expr in _expressions(stmt) for sub in ir.walk(expr) if isinstance(sub, ir.Call) and sub.offset == offset]


def mentions_call(statements: list, offset: int) -> bool:
    """Whether a statement list, however nested, evaluates the call at an offset."""
    for stmt in statements:
        if _calls_at(stmt, offset):
            return True
        for nested in (getattr(stmt, "then", None), getattr(stmt, "orelse", None), getattr(stmt, "body", None)):
            if isinstance(nested, list) and mentions_call(nested, offset):
                return True
    return False


def _always_returns(statements: list) -> bool:
    """Whether a statement list never falls through its end."""
    if not statements:
        return False
    last = statements[-1]
    if isinstance(last, (ir.Return, ir.End)):
        return True
    if isinstance(last, ir.If):
        return _always_returns(last.then) and _always_returns(last.orelse)
    return False


def _with_result(cond: ir.Expr, offset: int, result: ir.Expr) -> ir.Expr | None:
    """A condition whose only operand evaluated before the call is the call itself, with the call's result in its place."""
    if isinstance(cond, ir.Call) and cond.offset == offset:
        return result
    if isinstance(cond, ir.Unary) and cond.op == "not":
        operand = _with_result(cond.operand, offset, result)
        return None if operand is None else dataclasses.replace(cond, operand=operand)
    if isinstance(cond, ir.Compare) and isinstance(cond.rhs, ir.Const):
        lhs = _with_result(cond.lhs, offset, result)
        return None if lhs is None else dataclasses.replace(cond, lhs=lhs)
    return None


def resume_after(statements: list, offset: int, result: ir.Expr | None = None) -> list:
    """The statements that run after the call at an offset when the script goes on normally from it.

    The call is a statement of its own or the value of an assignment. When it is inside branches, the rest of each
    branch is followed by what comes after the branch. A call that decides a condition by itself (compared with a
    constant, or negated) continues with the conditional on result, the variable holding what the call returned; any
    other call in a condition, or one in a loop, has no such continuation.
    """
    for index, stmt in enumerate(statements):
        if not mentions_call(statements[index : index + 1], offset):
            continue
        if isinstance(stmt, ir.If):
            if _calls_at(stmt, offset):
                cond = _with_result(stmt.cond, offset, result) if result is not None else None
                if cond is None:
                    raise SkipError(f"the call at {offset:#x} that suspends skip mode is in a condition")
                return [ir.If(cond, stmt.then, stmt.orelse), *statements[index + 1 :]]
            branch = stmt.then if mentions_call(stmt.then, offset) else stmt.orelse
            rest = resume_after(branch, offset, result)
            return rest if _always_returns(rest) else [*rest, *statements[index + 1 :]]
        if isinstance(stmt, (ir.While, ir.Repeat, ir.NumericFor)):
            raise SkipError(f"the call at {offset:#x} that suspends skip mode is in a loop")
        calls = _calls_at(stmt, offset)
        sole = isinstance(stmt, ir.CallStmt) or (isinstance(stmt, ir.Assign) and stmt.value is calls[0] and len(calls) == 1)
        if not sole or len([sub for expr in _expressions(stmt) for sub in ir.walk(expr) if isinstance(sub, ir.Call)]) != 1:
            raise SkipError(f"the call at {offset:#x} that suspends skip mode is inside an expression")
        return statements[index + 1 :]
    raise SkipError(f"the call at {offset:#x} that suspends skip mode is not in the function")


def regions_of(body: list) -> list[list]:
    """The top-level statements split at each SkipEnd: the stretches between skip ends, and the last stretch."""
    parts: list[list] = [[]]
    for stmt in body:
        if isinstance(stmt, ir.SkipEnd):
            parts.append([])
        else:
            parts[-1].append(stmt)
    return parts


def has_skip_end(statements: list) -> bool:
    """Whether any statement, however nested, is a SkipEnd."""
    for stmt in statements:
        if isinstance(stmt, ir.SkipEnd):
            return True
        for nested in (getattr(stmt, "then", None), getattr(stmt, "orelse", None), getattr(stmt, "body", None)):
            if isinstance(nested, list) and has_skip_end(nested):
                return True
    return False


def regions(found: FunctionPlan) -> list[tuple[Run, list[Run]]]:
    """For each SKIP_END of a function, its run and the returning runs between it and the previous SKIP_END."""
    result: list[tuple[Run, list[Run]]] = []
    pending: list[Run] = []
    for run in found.runs:
        if run.terminal == "skip_end":
            result.append((run, pending))
            pending = []
        else:
            pending.append(run)
    return result
