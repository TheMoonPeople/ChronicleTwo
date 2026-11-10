"""Decodes compiled SB2/STB script programs into functions and instructions.

Function discovery matches scripts/port/audit_script_resources.py and the runtime timing validator: the main
function, every program-table entry and everything they call are reachable; compiled helpers that nothing calls
are recovered by scanning the code section for a function header followed by a valid instruction.
"""

from __future__ import annotations

import dataclasses
import hashlib
import struct

from .opcodes import JUMPS, TERMINATORS, ConstType, Op

HEADER_SIZE = 28
INSTRUCTION_SIZE = 12
FUNCTION_SIZE = 16
MAX_PROGRAMS = 4096


class DecodeError(ValueError):
    """A script that the virtual machine could not run as its header describes."""


@dataclasses.dataclass(frozen=True)
class Instruction:
    """One 12-byte virtual-machine instruction at an absolute file offset."""

    offset: int
    op: Op
    a1: int
    a2: int

    @property
    def a2_float(self) -> float:
        """Second operand reinterpreted as the float a RS_CONST_FLOAT push holds."""
        return struct.unpack("<f", struct.pack("<i", self.a2))[0]


@dataclasses.dataclass
class Function:
    """A compiled script function: its frame layout and straight-line instruction list."""

    block: int
    addr: int
    local: int
    arg: int
    instructions: list[Instruction]
    referenced: bool

    @property
    def start(self) -> int:
        """Absolute file offset of the first instruction."""
        return self.instructions[0].offset

    @property
    def end(self) -> int:
        """Absolute file offset just past the last instruction."""
        return self.instructions[-1].offset + INSTRUCTION_SIZE


@dataclasses.dataclass
class Program:
    """A decoded script file."""

    data: bytes
    magic: str
    main: int
    code: int
    programs: list[tuple[int, int]]
    global_num: int
    functions: dict[int, Function]

    @property
    def version(self) -> int:
        """RS_VERSION of the program: 2 for "SB2" programs with a global block, otherwise 1."""
        return 2 if self.magic == "SB2" else 1

    def callee(self, instruction: Instruction) -> Function:
        """Function a CALL instruction enters."""
        return self.functions[self.code + instruction.a2]

    def jump_target(self, instruction: Instruction) -> int:
        """Absolute file offset a jump instruction transfers to."""
        return self.code + instruction.a1

    def string(self, instruction: Instruction) -> bytes:
        """Bytes of the string a RS_CONST_STR push refers to, without its terminator."""
        start = self.code + instruction.a2
        if instruction.a2 < 0 or start >= len(self.data):
            raise DecodeError("string outside file")
        end = self.data.find(b"\0", start)
        if end < 0:
            raise DecodeError("unterminated script string")
        return self.data[start:end]


def word(data: bytes, at: int) -> int:
    """Signed little-endian word of the file, rejecting reads outside it."""
    if at < 0 or at + 4 > len(data):
        raise DecodeError(f"script word outside file: {at:#x}")
    return struct.unpack_from("<i", data, at)[0]


def is_script(data: bytes) -> bool:
    """Whether the data carries an SB2 or STB program signature."""
    return data[:4] in (b"SB2\0", b"STB\0")


def _function(data: bytes, code: int, block: int, referenced: bool) -> Function:
    if block < HEADER_SIZE or block % 4:
        raise DecodeError("invalid function block")
    relative, local, args = word(data, block), word(data, block + 8), word(data, block + 12)
    if args < 0 or args > local:
        raise DecodeError("invalid function frame")
    at = code + relative
    if relative < 0 or at % 4:
        raise DecodeError("invalid function code offset")
    farthest, instructions = at, []
    while True:
        op, a1, a2 = word(data, at), word(data, at + 4), word(data, at + 8)
        if not 1 <= op <= 30:
            raise DecodeError(f"invalid opcode {op} at {at:#x}")
        op = Op(op)
        if op in JUMPS:
            target = code + a1
            if a1 < 0 or target % 4 or target + INSTRUCTION_SIZE > len(data):
                raise DecodeError("jump outside file")
            farthest = max(farthest, target)
        if op == Op.CALL and (a2 < 0 or code + a2 + FUNCTION_SIZE > len(data)):
            raise DecodeError("call outside file")
        instructions.append(Instruction(at, op, a1, a2))
        at += INSTRUCTION_SIZE
        if op in TERMINATORS and at > farthest:
            return Function(block, relative, local, args, instructions, referenced)


def decode(data: bytes) -> Program:
    """Decode a whole script file, validating every function, jump, call and string operand."""
    data = bytes(data)
    if len(data) < HEADER_SIZE or data[:3] not in (b"SB2", b"STB"):
        raise DecodeError("not an SB2/STB program")
    main, code, prog, count = word(data, 4), word(data, 8), word(data, 12), word(data, 16)
    if code < HEADER_SIZE or code >= len(data) or code % 4 or prog < HEADER_SIZE or not 0 <= count <= MAX_PROGRAMS:
        raise DecodeError("invalid script sections")
    if prog + count * 8 > len(data):
        raise DecodeError("invalid script sections")
    magic = data[:3].decode("ascii")
    global_num = word(data, 24) if magic == "SB2" else 0
    if global_num < 0:
        raise DecodeError("invalid global count")
    programs = [(word(data, prog + i * 8), word(data, prog + i * 8 + 4)) for i in range(count)]

    functions: dict[int, Function] = {}
    covered = bytearray(len(data))
    todo = [main] + [block for _, block in programs]
    for block in todo:
        if block in functions:
            continue
        function = _function(data, code, block, True)
        functions[block] = function
        covered[function.start:function.end] = b"\1" * (function.end - function.start)
        todo.extend(code + i.a2 for i in function.instructions if i.op == Op.CALL)

    # Helpers compiled into the file but never called: a funcdata directly before its own code.
    at = code
    while at + 56 + INSTRUCTION_SIZE <= len(data):
        if word(data, at) == at - code + 56 and not covered[at] and at not in functions:
            local, args = word(data, at + 8), word(data, at + 12)
            if 0 <= args <= local < 256 and 1 <= word(data, at + 56) <= 30:
                try:
                    function = _function(data, code, at, False)
                except DecodeError:
                    pass
                else:
                    functions[at] = function
                    covered[function.start:function.end] = b"\1" * (function.end - function.start)
                    at = function.end - 4
        at += 4

    result = Program(data, magic, main, code, programs, global_num, dict(sorted(functions.items())))
    for function in result.functions.values():
        for instruction in function.instructions:
            if instruction.op == Op.PUSH_CONST and instruction.a1 == ConstType.STR:
                result.string(instruction)
    return result


def body_key(program: Program, function: Function) -> bytes:
    """Location-independent encoding of a function body: jumps relative to its start, strings by content."""
    out = bytearray(struct.pack("<ii", function.local, function.arg))
    for instruction in function.instructions:
        a1, a2 = instruction.a1, instruction.a2
        if instruction.op in JUMPS:
            a1 = program.jump_target(instruction) - function.start
        elif instruction.op == Op.CALL:
            callee = program.callee(instruction)
            a2 = callee.arg
        out += struct.pack("<iii", instruction.op, a1, a2 if instruction.op != Op.PUSH_CONST or instruction.a1 != ConstType.STR else 0)
        if instruction.op == Op.PUSH_CONST and instruction.a1 == ConstType.STR:
            out += program.string(instruction) + b"\0"
    return bytes(out)


def body_hashes(program: Program) -> dict[int, str]:
    """Hash of every function body, including the bodies of the functions it calls one level deep."""
    shallow = {block: hashlib.sha1(body_key(program, f)).digest() for block, f in program.functions.items()}
    result = {}
    for block, function in program.functions.items():
        digest = hashlib.sha1(shallow[block])
        for instruction in function.instructions:
            if instruction.op == Op.CALL:
                digest.update(shallow[program.code + instruction.a2])
        result[block] = digest.hexdigest()
    return result
