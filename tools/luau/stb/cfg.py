"""Basic blocks, dominators and loop structure of a decoded script function."""

from __future__ import annotations

import dataclasses

from .opcodes import JUMPS, TERMINATORS, Op
from .program import Function, Program


@dataclasses.dataclass
class Block:
    """A maximal straight-line run of instructions with a single entry."""

    start: int
    instructions: list
    successors: list[int] = dataclasses.field(default_factory=list)
    predecessors: list[int] = dataclasses.field(default_factory=list)


@dataclasses.dataclass
class Graph:
    """Control-flow graph of one function, with blocks keyed by their first instruction's file offset."""

    entry: int
    blocks: dict[int, Block]
    dominators: dict[int, set[int]]
    back_edges: list[tuple[int, int]]
    retreating_edges: list[tuple[int, int]]

    @property
    def reducible(self) -> bool:
        """Whether every cycle is a natural loop entered through its header."""
        return not self.retreating_edges


def build(program: Program, function: Function) -> Graph:
    """Split a function into blocks at jump targets and after jumps and terminators."""
    instructions = function.instructions
    index = {instruction.offset: i for i, instruction in enumerate(instructions)}
    leaders = {instructions[0].offset}
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
    return Graph(entry, blocks, dominators, back_edges, retreating)


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
