"""Turns an event argument script into a Luau module that returns its commands as data.

An event argument script is straight-line code: program 100 pushes constants and calls the two argument commands
(0 and 1), which the engine records as ARG_DATA lists (CEventScriptArg::BuildArgData). Nothing in it depends on the
state of the game, so the module is a plain table the runtime reads, with no handlers:

    return {
        { command = 0, args = { { type = "int", value = 1 }, { type = "float", value = 1.25 } } },
    }

Each entry is one command in execution order. `type` is "int", "float" or "string", the tag the retail machine gives the
slot, and a string is UTF-8 text that holds the CP932 text of the script.
"""

from __future__ import annotations

import dataclasses

from stb.opcodes import ConstType, Op
from stb.program import DecodeError, Instruction, Program, decode

from . import ir
from .emit import _const_text

COMMANDS = (0, 1)
PROGRAM = 100


@dataclasses.dataclass(frozen=True)
class Value:
    """A constant and the tag the retail machine gives its slot."""

    type: str
    value: int | float | bytes


@dataclasses.dataclass(frozen=True)
class Action:
    """One argument command in execution order."""

    command: int
    args: tuple[Value, ...]


def _constant(program: Program, instruction: Instruction) -> Value:
    if instruction.a1 == ConstType.INT:
        return Value("int", instruction.a2)
    if instruction.a1 == ConstType.FLOAT:
        return Value("float", instruction.a2_float)
    if instruction.a1 == ConstType.STR:
        return Value("string", program.string(instruction))
    raise DecodeError(f"unknown argument constant type {instruction.a1} at {instruction.offset:#x}")


def actions(program: Program) -> tuple[Action, ...]:
    """Evaluates the constant command stream of program 100."""
    targets = [block for number, block in program.programs if number == PROGRAM]
    if len(targets) != 1:
        raise DecodeError("an event argument script must have exactly one program 100")
    stack: list[Value] = []
    found: list[Action] = []
    for instruction in program.functions[targets[0]].instructions:
        op = instruction.op
        if op == Op.PUSH_CONST:
            stack.append(_constant(program, instruction))
        elif op == Op.NEG:
            if not stack or stack[-1].type not in ("int", "float"):
                raise DecodeError(f"invalid NEG operand at {instruction.offset:#x}")
            value = stack.pop()
            stack.append(Value(value.type, -value.value))
        elif op == Op.OR:
            if len(stack) < 2 or any(value.type != "int" for value in stack[-2:]):
                raise DecodeError(f"invalid OR operands at {instruction.offset:#x}")
            right, left = stack.pop(), stack.pop()
            stack.append(Value("int", left.value | right.value))
        elif op == Op.EXT:
            if instruction.a1 < 1 or len(stack) < instruction.a1:
                raise DecodeError(f"invalid EXT stack at {instruction.offset:#x}")
            values = stack[-instruction.a1 :]
            del stack[-instruction.a1 :]
            command = values[0]
            if command.type != "int" or command.value not in COMMANDS:
                raise DecodeError(f"unknown event argument command at {instruction.offset:#x}")
            found.append(Action(command.value, tuple(values[1:])))
        elif op in (Op.RET, Op.END):
            if len(stack) > 1:
                raise DecodeError(f"an event argument script leaves values on its stack at {instruction.offset:#x}")
            return tuple(found)
        elif op != Op.LABEL:
            raise DecodeError(f"unsupported event argument opcode {op.name} at {instruction.offset:#x}")
    raise DecodeError("event argument program 100 has no return")


_TYPES = {"int": ir.INT, "float": ir.FLOAT, "string": ir.STR}


def _literal(value: Value) -> str:
    return _const_text(ir.Const(value.value, _TYPES[value.type]))[0]


def emit(program: Program, path: str) -> str:
    """The module text of an event argument script: a table with one entry per command."""
    lines = ["--!strict", f"-- {path}: event argument script, translated from the bytecode by tools/luau/stb2luau.", "return {"]
    for action in actions(program):
        args = ", ".join(f'{{ type = "{value.type}", value = {_literal(value)} }}' for value in action.args)
        lines.append(f"\t{{ command = {action.command}, args = {{ {args} }} }},")
    lines.append("}")
    return "\n".join(lines) + "\n"


def transpile(path: str, data: bytes) -> str:
    """Decodes an event argument SB2 or STB and returns its data module."""
    return emit(decode(data), path)


def verify(program: Program) -> str | None:
    """Runs program 100 on the reference machine and compares the commands it calls with the module's data.

    Returns a description of the first difference, or None when the commands, their arguments and the tags of the
    arguments agree.
    """
    from . import refvm

    called: list[tuple[int, tuple[tuple[str, object], ...]]] = []

    def record(machine: refvm.Machine, base: int, argc: int) -> None:
        slots = machine.memory[base : base + argc]
        names = {refvm.Tag.INT: "int", refvm.Tag.FLOAT: "float", refvm.Tag.STR: "string"}
        called.append((slots[0].value, tuple((names[slot.tag], slot.value) for slot in slots[1:])))

    machine = refvm.Machine(program, ext=record)
    machine.run(PROGRAM)
    expected = [
        (action.command, tuple((value.type, value.value) for value in action.args)) for action in actions(program)
    ]
    for index, (got, want) in enumerate(zip(called, expected)):
        if got != want:
            return f"command {index}: the machine called {got}, the module holds {want}"
    if len(called) != len(expected):
        return f"the machine called {len(called)} commands, the module holds {len(expected)}"
    return None
