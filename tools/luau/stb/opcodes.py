"""Enumerations of the script virtual machine, mirroring ps2/include/runscript.hpp."""

import enum


class Op(enum.IntEnum):
    """Opcodes of the script virtual machine, as vmcode_t::op holds them."""

    LOAD = 1
    LOAD_ADDR = 2
    PUSH_CONST = 3
    POP = 4
    STORE = 5
    ADD = 6
    SUB = 7
    MUL = 8
    DIV = 9
    MOD = 10
    NEG = 11
    ITOF = 12
    FTOI = 13
    CMP = 14
    RET = 15
    JMP = 16
    JMP_FALSE = 17
    JMP_TRUE = 18
    CALL = 19
    PRINT = 20
    EXT = 21
    LABEL = 22
    WAIT = 23
    AND = 24
    OR = 25
    NOT = 26
    END = 27
    SKIP_END = 28
    SIN = 29
    COS = 30


class AddrMode(enum.IntEnum):
    """How a load or address-load instruction finds its variable, as vmcode_t::arg2 holds it."""

    LOCAL = 0x1
    LOCAL_INDEX = 0x2
    POINTER_INDEX = 0x4
    LOCAL_FLOAT = 0x8
    LOCAL_INDEX_FLOAT = 0x10
    POINTER_INDEX_FLOAT = 0x20
    GLOBAL = 0x40
    GLOBAL_FLOAT = 0x200


class ConstType(enum.IntEnum):
    """Kind of constant a push-constant instruction pushes, as vmcode_t::arg1 holds it."""

    INT = 1
    FLOAT = 2
    STR = 3


class Compare(enum.IntEnum):
    """Comparisons of the compare opcode, as vmcode_t::arg1 holds them."""

    EQ = 40
    NE = 41
    LT = 42
    LE = 43
    GT = 44
    GE = 45


JUMPS = frozenset((Op.JMP, Op.JMP_FALSE, Op.JMP_TRUE))
TERMINATORS = frozenset((Op.RET, Op.END))
FLOAT_MODES = frozenset((AddrMode.LOCAL_FLOAT, AddrMode.LOCAL_INDEX_FLOAT, AddrMode.POINTER_INDEX_FLOAT, AddrMode.GLOBAL_FLOAT))
INDEXED_MODES = frozenset((AddrMode.LOCAL_INDEX, AddrMode.POINTER_INDEX, AddrMode.LOCAL_INDEX_FLOAT, AddrMode.POINTER_INDEX_FLOAT))
POINTER_MODES = frozenset((AddrMode.POINTER_INDEX, AddrMode.POINTER_INDEX_FLOAT))
GLOBAL_MODES = frozenset((AddrMode.GLOBAL, AddrMode.GLOBAL_FLOAT))
