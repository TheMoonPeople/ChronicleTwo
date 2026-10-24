"""Basic blocks, dominators and loop structure of a decoded script function, and where skip mode runs.

Skip mode is how an event is skipped: SkipEvent calls CRunScript::skip, which resumes the suspended script with
skip_wait set. Until the next SKIP_END the machine then runs every instruction in layout order: jumps are not taken
and a conditional jump leaves its condition on the stack, external calls pop their arguments without running, waits
fall through, and stores, prints and script calls run as usual (a callee runs in skip mode from its first
instruction). A RET returns as usual, so a sweep that reaches one goes on in the caller after its CALL. A SKIP_END
reached in skip mode clears the mode and suspends the script, and the next frame resumes it in normal mode after the
SKIP_END. skip_flow() finds the straight runs of code a sweep can follow, where they start and where normal execution
resumes after them.

A conditional jump in a sweep leaves its condition on the operand stack, and those values stay there until the
function returns, so a sweep can overflow the stack where normal execution never does; retail then exits. skip_flow
finds where that may happen, and the functions that must know where their frame starts to tell.
"""

from __future__ import annotations

import bisect
import collections
import dataclasses
import functools

from .opcodes import INDEXED_MODES, JUMPS, TERMINATORS, Op
from .program import Function, Program

INSTRUCTION_SIZE = 12
# Instructions that run alike in normal and skip mode and suspend nothing: what may follow a call that can return in
# skip mode, up to the end of its statement.
_UNMODED = frozenset(
    (
        Op.LOAD,
        Op.LOAD_ADDR,
        Op.PUSH_CONST,
        Op.STORE,
        Op.POP,
        Op.ADD,
        Op.SUB,
        Op.MUL,
        Op.DIV,
        Op.MOD,
        Op.AND,
        Op.OR,
        Op.NEG,
        Op.ITOF,
        Op.FTOI,
        Op.CMP,
        Op.NOT,
        Op.SIN,
        Op.COS,
        Op.LABEL,
    )
)
_STOPS = frozenset((Op.SKIP_END, Op.RET, Op.END))


@dataclasses.dataclass
class Block:
    """A maximal straight-line run of instructions with a single entry."""

    start: int
    instructions: list
    successors: list[int] = dataclasses.field(default_factory=list)
    predecessors: list[int] = dataclasses.field(default_factory=list)


@dataclasses.dataclass
class SkipBlock:
    """A piece of a sweep: instructions run in layout order in skip mode, then the pieces or blocks that follow.

    successors holds the next piece of the sweep and, for a piece that ends where normal execution resumes (after a
    SKIP_END, or after the statement of a call that may suspend at a callee's SKIP_END), the normal block there.
    """

    start: tuple[str, int]
    instructions: list
    successors: list = dataclasses.field(default_factory=list)


@dataclasses.dataclass
class Graph:
    """Control-flow graph of one function, with blocks keyed by their first instruction's file offset."""

    entry: int
    blocks: dict[int, Block]
    dominators: dict[int, set[int]]
    back_edges: list[tuple[int, int]]
    retreating_edges: list[tuple[int, int]]
    # The pieces of the function's sweeps, keyed ("skip", offset), and the offsets where a normal run may switch to
    # skip mode, mapped to the piece that starts there; empty when the graph was built without a skip flow.
    skip: dict[tuple[str, int], SkipBlock] = dataclasses.field(default_factory=dict)
    seeds: dict[int, tuple[str, int]] = dataclasses.field(default_factory=dict)

    @property
    def reducible(self) -> bool:
        """Whether every cycle is a natural loop entered through its header."""
        return not self.retreating_edges


@dataclasses.dataclass(frozen=True)
class Sweep:
    """One straight run of a function in skip mode: the offsets where a sweep may start in it, ascending, and the
    SKIP_END, RET or END that stops it."""

    starts: tuple[int, ...]
    stop: int


@dataclasses.dataclass
class SkipFlow:
    """Where skip mode can run in a program, by function header block.

    may_wait holds the functions that a normal call can return from in skip mode: those that wait, directly or through
    a callee, since a skip may resume the script at that wait. entered holds the functions a sweep calls, which then
    run in skip mode from their first instruction, and stops those that, so entered, may suspend at a SKIP_END (their
    own, or a callee's). seeds gives the offsets where a normal run may switch to skip mode: after a WAIT, at the end of
    the statement of a call that may return in skip mode, and at the first instruction of an entered function. A sweep
    also starts after the SKIP_END that stops the one before it, where a skip may find the script suspended. landings
    holds the offsets where normal execution resumes after a sweep: after a SKIP_END that stops one, and at the end of
    the statement of a call a sweep makes to a function in stops. errors gives the functions whose skip mode a
    translation cannot follow, with the reason.

    overflows gives, per function, the offsets of the pushes that may overflow the operand stack in normal execution
    after skip mode, sweep_overflows those in its sweeps, and overflowing_frames the functions whose frame may not fit when a sweep calls them; retail exits there. stacked
    holds those functions and every function that calls them, directly or not, which must know where their frames
    start.
    """

    may_wait: frozenset[int]
    entered: frozenset[int]
    stops: frozenset[int]
    seeds: dict[int, frozenset[int]]
    sweeps: dict[int, list[Sweep]]
    landings: dict[int, frozenset[int]]
    errors: dict[int, str]
    overflows: dict[int, frozenset[int]] = dataclasses.field(default_factory=dict)
    sweep_overflows: dict[int, frozenset[int]] = dataclasses.field(default_factory=dict)
    overflowing_frames: frozenset[int] = frozenset()
    stacked: frozenset[int] = frozenset()


def build(program: Program, function: Function, flow: SkipFlow | None = None) -> Graph:
    """Split a function into blocks at jump targets, after jumps and terminators, and where a sweep resumes normal
    execution; given a skip flow, the graph also holds the pieces of the function's sweeps."""
    instructions = function.instructions
    index = {instruction.offset: i for i, instruction in enumerate(instructions)}
    leaders = {instructions[0].offset}
    if flow is not None:
        leaders |= flow.landings.get(function.block, frozenset())
    for i, instruction in enumerate(instructions):
        if instruction.op in JUMPS:
            leaders.add(program.jump_target(instruction))
        if (instruction.op in JUMPS or instruction.op in TERMINATORS) and i + 1 < len(instructions):
            leaders.add(instructions[i + 1].offset)
    leaders = sorted(leader for leader in leaders if leader in index)

    blocks: dict[int, Block] = {}
    for n, leader in enumerate(leaders):
        stop = index[leaders[n + 1]] if n + 1 < len(leaders) else len(instructions)
        body = instructions[index[leader]:stop]
        block = Block(leader, body)
        last = body[-1]
        following = instructions[stop].offset if stop < len(instructions) else None
        if last.op in JUMPS:
            block.successors.append(program.jump_target(last))
            if last.op != Op.JMP and following is not None:
                block.successors.append(following)
        elif last.op not in TERMINATORS and following is not None:
            block.successors.append(following)
        blocks[leader] = block
    for block in blocks.values():
        for successor in block.successors:
            blocks[successor].predecessors.append(block.start)

    entry = instructions[0].offset
    order = _reverse_postorder(blocks, entry)
    dominators = _dominators(blocks, entry, order)
    back_edges, retreating = [], []
    position = {start: i for i, start in enumerate(order)}
    for start in order:
        for successor in blocks[start].successors:
            if position[successor] <= position[start]:
                if successor in dominators[start]:
                    back_edges.append((start, successor))
                else:
                    retreating.append((start, successor))
    graph = Graph(entry, blocks, dominators, back_edges, retreating)
    if flow is not None:
        _skip_blocks(function, flow, graph)
    return graph


def _skip_blocks(function: Function, flow: SkipFlow, graph: Graph) -> None:
    """Adds the pieces of a function's sweeps, split where a sweep starts or lands, and where normal runs enter them."""
    landings = flow.landings.get(function.block, frozenset())
    for sweep in flow.sweeps.get(function.block, ()):
        first = sweep.starts[0]
        splits = sorted(set(sweep.starts) | {offset for offset in landings if first < offset <= sweep.stop})
        body = [i for i in function.instructions if first <= i.offset <= sweep.stop]
        for n, split in enumerate(splits):
            following = splits[n + 1] if n + 1 < len(splits) else None
            piece = SkipBlock(
                ("skip", split), [i for i in body if split <= i.offset and (following is None or i.offset < following)]
            )
            if following is not None:
                piece.successors.append(("skip", following))
                if following in landings:
                    piece.successors.append(following)
            elif piece.instructions[-1].op == Op.SKIP_END:
                after = sweep.stop + INSTRUCTION_SIZE
                piece.successors += [("skip", after), after]
            graph.skip[piece.start] = piece
    for offset in flow.seeds.get(function.block, ()):
        graph.seeds[offset] = ("skip", offset)


def _reverse_postorder(blocks: dict[int, Block], entry: int) -> list[int]:
    seen, order, stack = {entry}, [], [(entry, iter(blocks[entry].successors))]
    while stack:
        start, successors = stack[-1]
        for successor in successors:
            if successor not in seen:
                seen.add(successor)
                stack.append((successor, iter(blocks[successor].successors)))
                break
        else:
            order.append(start)
            stack.pop()
    return order[::-1]


def _dominators(blocks: dict[int, Block], entry: int, order: list[int]) -> dict[int, set[int]]:
    reachable = set(order)
    dominators = {start: set(reachable) for start in order}
    dominators[entry] = {entry}
    changed = True
    while changed:
        changed = False
        for start in order[1:]:
            predecessors = [p for p in blocks[start].predecessors if p in reachable]
            new = set.intersection(*(dominators[p] for p in predecessors)) | {start} if predecessors else {start}
            if new != dominators[start]:
                dominators[start] = new
                changed = True
    return dominators


def stack_effect(program: Program, instruction) -> tuple[int, int]:
    """The values an instruction pops and pushes in normal mode, a conditional jump on its untaken path."""
    op = instruction.op
    if op in (Op.LOAD, Op.LOAD_ADDR):
        return (1 if instruction.a2 in INDEXED_MODES else 0, 1)
    if op == Op.PUSH_CONST:
        return (0, 1)
    if op in (Op.POP, Op.JMP_FALSE, Op.JMP_TRUE, Op.RET):
        return (1, 0)
    if op in (Op.STORE, Op.ADD, Op.SUB, Op.MUL, Op.DIV, Op.MOD, Op.AND, Op.OR, Op.CMP):
        return (2, 1)
    if op in (Op.NEG, Op.NOT, Op.ITOF, Op.FTOI, Op.SIN, Op.COS):
        return (1, 1)
    if op == Op.CALL:
        return (program.callee(instruction).arg, 1)
    if op in (Op.PRINT, Op.EXT):
        return (instruction.a1, 0)
    return (0, 0)


def depths(program: Program, function: Function) -> dict[int, int]:
    """The operand-stack depth before each reachable instruction of a function, in normal mode."""
    index = {instruction.offset: i for i, instruction in enumerate(function.instructions)}
    found = {function.instructions[0].offset: 0}
    work = [function.instructions[0].offset]
    while work:
        offset = work.pop()
        instruction = function.instructions[index[offset]]
        pops, pushes = stack_effect(program, instruction)
        after = found[offset] - pops + pushes
        if instruction.op == Op.JMP:
            targets = [(program.jump_target(instruction), found[offset])]
        elif instruction.op in (Op.JMP_FALSE, Op.JMP_TRUE):
            taken = after + (1 if instruction.a2 else 0)
            targets = [(program.jump_target(instruction), taken), (offset + INSTRUCTION_SIZE, after)]
        elif instruction.op in TERMINATORS:
            targets = []
        else:
            targets = [(offset + INSTRUCTION_SIZE, after)]
        for target, depth in targets:
            if target in index and target not in found:
                found[target] = depth
                work.append(target)
    return found


def statement_end(program: Program, function: Function, at: int, depth: int) -> int | None:
    """Where the statement of the CALL at an offset ends, given the stack depth before the CALL in normal mode: the
    offset after the instruction that empties the operand stack, or after the statement's own conditional jump, or
    None when the statement returns the value.

    Raises ValueError when the rest of the statement would run differently in skip mode: a jump that is not the
    statement's own branch, or a native or script call, print, wait or skip end.
    """
    index = (at - function.instructions[0].offset) // INSTRUCTION_SIZE
    depth = depth - program.callee(function.instructions[index]).arg + 1
    for instruction in function.instructions[index + 1 :]:
        op = instruction.op
        if op == Op.RET and depth == 1:
            return None
        if op in (Op.JMP_FALSE, Op.JMP_TRUE) and not instruction.a2 and depth == 1:
            return instruction.offset + INSTRUCTION_SIZE
        if op not in _UNMODED:
            raise ValueError(f"{op.name} at {instruction.offset:#x} follows the call at {at:#x} within its statement")
        pops, pushes = stack_effect(program, instruction)
        depth += pushes - pops
        if depth == 0:
            return instruction.offset + INSTRUCTION_SIZE
    raise ValueError(f"the statement of the call at {at:#x} does not end")


def skip_flow(program: Program, stack_num: int = 0x80) -> SkipFlow:
    """Where skip mode can run in a program: its sweeps, where they start and where normal execution resumes.

    stack_num is the operand stack's size in slots, globals included (SetEventScript gives 0x80); a function in which
    skip mode may overflow it is an error.
    """
    functions = program.functions
    may_wait = {block for block, function in functions.items() if any(i.op == Op.WAIT for i in function.instructions)}
    callers: dict[int, set[int]] = {block: set() for block in functions}
    calls: dict[int, list] = {}
    for block, function in functions.items():
        calls[block] = [i for i in function.instructions if i.op == Op.CALL]
        for instruction in calls[block]:
            callers[program.callee(instruction).block].add(block)
    todo = list(may_wait)
    while todo:
        for caller in callers[todo.pop()]:
            if caller not in may_wait:
                may_wait.add(caller)
                todo.append(caller)

    stack_depths = {block: functools.cache(functools.partial(depths, program, function)) for block, function in functions.items()}
    errors: dict[int, str] = {}

    @functools.cache
    def end_of(block: int, call) -> int | None:
        try:
            return statement_end(program, functions[block], call.offset, stack_depths[block]().get(call.offset, 0))
        except ValueError as error:
            errors.setdefault(block, str(error))
            return None

    normal: dict[int, set[int]] = {}
    stop_ops: dict[int, list] = {}
    for block, function in functions.items():
        found: set[int] = set()
        for instruction in function.instructions:
            if instruction.op == Op.WAIT:
                found.add(instruction.offset + INSTRUCTION_SIZE)
        for instruction in calls[block]:
            if program.callee(instruction).block in may_wait:
                end = end_of(block, instruction)
                if end is not None:
                    found.add(end)
        normal[block] = found
        stop_ops[block] = [i for i in function.instructions if i.op in _STOPS]

    entered: set[int] = set()
    stops: set[int] = set()
    while True:
        sweeps: dict[int, list[Sweep]] = {}
        landings: dict[int, set[int]] = {}
        next_entered: set[int] = set()
        next_stops: set[int] = set()
        for block, function in functions.items():
            starts = set(normal[block])
            if block in entered:
                starts.add(function.instructions[0].offset)
            runs: list[Sweep] = []
            if starts:
                ordered = sorted(starts)
                begin = function.instructions[0].offset
                resumed = False
                for instruction in stop_ops[block]:
                    low = bisect.bisect_left(ordered, begin)
                    high = bisect.bisect_right(ordered, instruction.offset)
                    inside = set(ordered[low:high])
                    if resumed:
                        # A skip may find the script suspended at the SKIP_END that stopped the sweep before.
                        inside.add(begin)
                    resumed = False
                    if inside:
                        runs.append(Sweep(tuple(sorted(inside)), instruction.offset))
                        if instruction.op == Op.SKIP_END:
                            landings.setdefault(block, set()).add(instruction.offset + INSTRUCTION_SIZE)
                            resumed = True
                    begin = instruction.offset + INSTRUCTION_SIZE
            first_stops = False
            for sweep in runs:
                for instruction in calls[block]:
                    if not sweep.starts[0] <= instruction.offset < sweep.stop:
                        continue
                    callee = program.callee(instruction).block
                    next_entered.add(callee)
                    if callee in stops:
                        if sweep is runs[0]:
                            first_stops = True
                        end = end_of(block, instruction)
                        if end is not None:
                            landings.setdefault(block, set()).add(end)
            if block in entered and runs and runs[0].starts[0] == function.instructions[0].offset:
                stop = next(i for i in stop_ops[block] if i.offset == runs[0].stop)
                if stop.op == Op.SKIP_END or first_stops:
                    next_stops.add(block)
            sweeps[block] = runs
        if next_entered == entered and next_stops == stops:
            break
        entered, stops = next_entered, next_stops
    seeds = {
        block: frozenset(normal[block] | ({functions[block].instructions[0].offset} if block in entered else set()))
        for block in functions
    }
    landing_sets = {block: frozenset(found) for block, found in landings.items()}
    overflows, sweep_overflows, frames = _overflows(program, sweeps, landing_sets, stack_depths, stack_num)
    callers: dict[int, set[int]] = collections.defaultdict(set)
    for block, found in calls.items():
        for instruction in found:
            callers[program.callee(instruction).block].add(block)
    stacked = set(overflows) | set(sweep_overflows) | frames
    todo = list(stacked)
    while todo:
        for caller in callers[todo.pop()]:
            if caller not in stacked:
                stacked.add(caller)
                todo.append(caller)
    return SkipFlow(
        may_wait=frozenset(may_wait),
        entered=frozenset(entered),
        stops=frozenset(stops),
        seeds=seeds,
        sweeps=sweeps,
        landings=landing_sets,
        errors=errors,
        overflows=overflows,
        sweep_overflows=sweep_overflows,
        overflowing_frames=frozenset(frames),
        stacked=frozenset(stacked),
    )


# Instructions that change nothing on the operand stack in skip mode.
_STILL = frozenset((Op.JMP, Op.LABEL, Op.WAIT, Op.SKIP_END, Op.JMP_FALSE, Op.JMP_TRUE))


def _overflows(
    program: Program,
    sweeps: dict[int, list[Sweep]],
    landings: dict[int, frozenset[int]],
    stack_depths: dict,
    stack_num: int,
) -> tuple[dict[int, frozenset[int]], dict[int, frozenset[int]], set[int]]:
    """The pushes that may overflow the operand stack in normal execution after skip mode and in sweeps, by function, and
    the functions whose frame may not fit.

    Every frame a call can start at is followed from the program's entries, in normal and in skip mode. The conditions a
    sweep leaves on the stack stay below the rest of its function's run: after a sweep that a SKIP_END stops, or that
    resumes normal execution after a call, the function goes on above them, so any of its earlier such sweeps may lie
    there. Normal execution with nothing left there is not checked, since it runs as retail ran it.
    """
    functions = program.functions
    leaks: dict[int, list[tuple[Sweep, dict[int, int], frozenset[int]]]] = {}
    left: dict[int, list[tuple[int, frozenset[int]]]] = {}
    for block, function in functions.items():
        found = []
        after: list[tuple[int, frozenset[int]]] = []
        below = frozenset({0})
        for sweep in sweeps.get(block, ()):
            heights: dict[int, int] = {}
            # A sweep that starts after a branch on a call's value finds that value on the stack: the jump ran in skip
            # mode and left it there.
            first = function.instructions[(sweep.starts[0] - function.instructions[0].offset) // INSTRUCTION_SIZE - 1]
            branched = sweep.starts[0] > function.instructions[0].offset and first.op in (Op.JMP_FALSE, Op.JMP_TRUE)
            height = 1 if branched and not first.a2 else 0
            for instruction in function.instructions:
                if not sweep.starts[0] <= instruction.offset <= sweep.stop:
                    continue
                heights[instruction.offset] = height
                if instruction.op not in _STILL:
                    pops, pushes = stack_effect(program, instruction)
                    height += pushes - pops
            found.append((sweep, heights, below))
            stop = function.instructions[(sweep.stop - function.instructions[0].offset) // INSTRUCTION_SIZE]
            lands = any(sweep.starts[0] < offset <= sweep.stop for offset in landings.get(block, ()))
            if stop.op == Op.SKIP_END or lands:
                below = below | {value + max(height, 0) for value in below}
            after.append((sweep.stop, below))
        leaks[block] = found
        left[block] = after

    order: list[int] = []
    seen: set[int] = set()

    def visit(block: int) -> None:
        if block in seen:
            return
        seen.add(block)
        for instruction in functions[block].instructions:
            if instruction.op == Op.CALL:
                visit(program.callee(instruction).block)
        order.append(block)

    # The frames each function can start at, and those a run that never skipped reaches.
    bases: dict[int, set[int]] = collections.defaultdict(set)
    plain: dict[int, set[int]] = collections.defaultdict(set)
    for root in [program.main, *(block for _, block in program.programs)]:
        bases[root].add(program.global_num)
        plain[root].add(program.global_num)
        visit(root)
    found: dict[int, set[int]] = collections.defaultdict(set)
    swept: dict[int, set[int]] = collections.defaultdict(set)
    frames: set[int] = set()
    for block in reversed(order):
        function = functions[block]
        normal = stack_depths[block]()
        for base in sorted(bases[block]):
            top = base + function.local
            below = frozenset({0})
            stops = iter(left[block])
            pending = next(stops, None)
            for instruction in function.instructions:
                while pending is not None and pending[0] < instruction.offset:
                    below = pending[1]
                    pending = next(stops, None)
                height = normal.get(instruction.offset)
                if height is None:
                    continue
                pops, pushes = stack_effect(program, instruction)
                for junk in below:
                    sp = top + junk + height
                    skipped = junk or base not in plain[block]
                    if skipped and pushes and sp - pops >= stack_num:
                        found[block].add(instruction.offset)
                    if instruction.op == Op.CALL:
                        callee = program.callee(instruction)
                        bases[callee.block].add(sp - callee.arg)
                        if not skipped:
                            plain[callee.block].add(sp - callee.arg)
            for _sweep, heights, junks in leaks[block]:
                for instruction in function.instructions:
                    height = heights.get(instruction.offset)
                    if height is None:
                        continue
                    pops, pushes = (0, 0) if instruction.op in _STILL else stack_effect(program, instruction)
                    for junk in junks:
                        sp = top + junk + height
                        if pushes and sp - pops >= stack_num:
                            swept[block].add(instruction.offset)
                        if instruction.op == Op.CALL:
                            bases[program.callee(instruction).block].add(sp - program.callee(instruction).arg)
            if top >= stack_num and base not in plain[block]:
                frames.add(block)
    return (
        {block: frozenset(offsets) for block, offsets in found.items()},
        {block: frozenset(offsets) for block, offsets in swept.items()},
        frames,
    )
