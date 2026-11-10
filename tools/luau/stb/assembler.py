"""Assembles small SB2/STB programs, laid out as the retail compiler lays them out, for test fixtures.

A function is a list of instructions. Each instruction is a tuple whose first element names an Op, plus the
pseudo-instructions "label" (defines a jump target), "push" (integer), "pushf" (float) and "pushs" (bytes).
Jump operands name labels, and CALL operands name functions.
"""

from __future__ import annotations

import struct

from .opcodes import ConstType, Op

FUNCTION_PREAMBLE = 56


def assemble(functions: dict[str, tuple[int, int, list]], main: str, programs: dict[int, str] | None = None, magic: str = "SB2", global_num: int = 0) -> bytes:
    """Build a program file from {name: (locals, args, instructions)}."""
    programs = programs or {}
    code = 28 + 8 * len(programs)
    blocks, layout, at = {}, {}, code
    for name, (_, _, body) in functions.items():
        blocks[name] = at
        at += FUNCTION_PREAMBLE
        labels = {}
        count = 0
        for item in body:
            if item[0] == "label":
                labels[item[1]] = at + count * 12
            else:
                count += 1
        layout[name] = labels
        at += count * 12
    strings = bytearray()
    string_at = {}
    out = bytearray(at)
    out[:3] = magic.encode("ascii")
    struct.pack_into("<iiiiii", out, 4, blocks[main], code, 28, len(programs), 0, global_num)
    for i, (no, name) in enumerate(sorted(programs.items())):
        struct.pack_into("<ii", out, 28 + i * 8, no, blocks[name])
    for name, (local, args, body) in functions.items():
        block = blocks[name]
        struct.pack_into("<iiii", out, block, block + FUNCTION_PREAMBLE - code, 0, local, args)
        pc = block + FUNCTION_PREAMBLE
        for item in body:
            kind = item[0]
            if kind == "label":
                continue
            if kind == "push":
                words = (Op.PUSH_CONST, ConstType.INT, item[1])
            elif kind == "pushf":
                words = (Op.PUSH_CONST, ConstType.FLOAT, struct.unpack("<i", struct.pack("<f", item[1]))[0])
            elif kind == "pushs":
                if item[1] not in string_at:
                    string_at[item[1]] = len(strings)
                    strings += item[1] + b"\0"
                words = (Op.PUSH_CONST, ConstType.STR, ("string", item[1]))
            else:
                op = Op[kind] if isinstance(kind, str) else Op(kind)
                a1 = item[1] if len(item) > 1 else 0
                a2 = item[2] if len(item) > 2 else 0
                if op in (Op.JMP, Op.JMP_FALSE, Op.JMP_TRUE):
                    a1 = layout[name][a1] - code
                elif op == Op.CALL:
                    a2, a1 = blocks[a1] - code, 0
                words = (op, a1, a2)
            struct.pack_into("<ii", out, pc, int(words[0]), int(words[1]))
            if isinstance(words[2], tuple):
                struct.pack_into("<i", out, pc + 8, at + string_at[words[2][1]] - code)
            else:
                struct.pack_into("<i", out, pc + 8, int(words[2]))
            pc += 12
    return bytes(out + strings)
