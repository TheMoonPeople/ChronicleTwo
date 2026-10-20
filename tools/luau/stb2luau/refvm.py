"""Python port of the retail script virtual machine, CRunScript, mirroring ps2/src/runscript.cpp opcode by opcode.

Decoded SB2/STB programs run on a list of tagged slots, with pointers held as slot indices, so the results can be
compared against the Luau translation of the same scripts.

The machine follows retail wherever retail's behaviour is defined by the script and the stack, so it can serve as the
oracle the translation is tested against. Retail never checks a local index, and neither does this machine: a local
index below the frame reaches the caller's frame or the globals, and a load or a store past the frame reaches the
operand stack, as on the PS2. Each such access is reported to outside_frame() first, which does nothing here; the
differential harness uses it to stop comparing, since the translation does not model the operand stack. VMError is
raised where retail exits, and where it would reach memory outside the stack or read a pointer's bits as a number.

float32=False is not retail: it runs float arithmetic in double precision and reads float constants as the shortest
decimal that rounds to them, which is the numeric model the Luau translation follows (docs/PORT_LUAU.md, Numbers).
"""

from __future__ import annotations

import ctypes
import ctypes.util
import dataclasses
import enum
import math
import operator
import struct
import sys
from collections.abc import Callable

from stb.opcodes import FLOAT_MODES, GLOBAL_MODES, INDEXED_MODES, POINTER_MODES, AddrMode, Compare, ConstType, Op
from stb.program import INSTRUCTION_SIZE, Program

from . import numbers


class Tag(enum.IntEnum):
    """Kind of value a stack slot holds, as RS_STACKDATA::type holds it."""

    INT = 0
    FLOAT = 1
    STR = 2
    PTR = 3


@dataclasses.dataclass
class Slot:
    """One stack or global slot: the kind of value it holds and the value itself."""

    tag: Tag
    value: object


class VMError(RuntimeError):
    """A script the retail interpreter exits on, or undefined behaviour the port refuses to guess at."""


def wrap32(value: int) -> int:
    """Wrap an integer to a signed 32-bit value."""
    return ((value + 0x8000_0000) & 0xFFFF_FFFF) - 0x8000_0000


def f32(value: float) -> float:
    """Round a double to the nearest float32, overflowing to a signed infinity."""
    try:
        return struct.unpack("<f", struct.pack("<f", value))[0]
    except OverflowError:
        return math.copysign(math.inf, value)


def _libm() -> ctypes.CDLL:
    """The C library whose sinf and cosf the game's interpreter calls: the UCRT on Windows, libm elsewhere."""
    if sys.platform == "win32":
        return ctypes.CDLL("ucrtbase")
    return ctypes.CDLL(ctypes.util.find_library("m") or "libm.so.6")


_LIBM = _libm()
for _name in ("sinf", "cosf"):
    getattr(_LIBM, _name).restype = ctypes.c_float
    getattr(_LIBM, _name).argtypes = [ctypes.c_float]


def sinf(value: float) -> float:
    """The C library's single-precision sine of a float32, as the PC interpreter computes SIN."""
    return float(_LIBM.sinf(value))


def cosf(value: float) -> float:
    """The C library's single-precision cosine of a float32, as the PC interpreter computes COS."""
    return float(_LIBM.cosf(value))


def bits_to_float(bits: int) -> float:
    """Reinterpret the low 32 bits of an integer as a float32 value."""
    return struct.unpack("<f", struct.pack("<I", bits & 0xFFFF_FFFF))[0]


def float_bits(value: float) -> int:
    """Float32 bit pattern of a value, as a signed 32-bit integer."""
    return struct.unpack("<i", struct.pack("<f", f32(value)))[0]


def is_true(slot: Slot) -> bool:
    """Whether a script value is true, where only integer zero is false."""
    return not (slot.tag == Tag.INT and slot.value == 0)


def _raw_int(slot: Slot) -> int:
    if slot.tag == Tag.INT:
        return slot.value
    if slot.tag == Tag.FLOAT:
        return float_bits(slot.value)
    return 0


def _is_zero_divisor(slot: Slot) -> bool:
    # Retail tests the divisor's raw bits, so +0.0f divides by zero and -0.0f does not.
    if slot.tag == Tag.INT:
        return slot.value == 0
    if slot.tag == Tag.FLOAT:
        return slot.value == 0.0 and math.copysign(1.0, slot.value) > 0
    return False


def _fdiv(lhs: float, rhs: float) -> float:
    if rhs == 0.0:
        if lhs == 0.0 or math.isnan(lhs):
            return math.nan
        return math.copysign(math.inf, lhs) * math.copysign(1.0, rhs)
    return lhs / rhs


def _trunc_div(lhs: int, rhs: int) -> int:
    quotient = abs(lhs) // abs(rhs)
    return quotient if (lhs < 0) == (rhs < 0) else -quotient


_ADDRESS_MODES = frozenset(AddrMode)
_ARITH = {Op.ADD: operator.add, Op.SUB: operator.sub, Op.MUL: operator.mul}
_COMPARE = {
    Compare.EQ: operator.eq,
    Compare.NE: operator.ne,
    Compare.LT: operator.lt,
    Compare.LE: operator.le,
    Compare.GT: operator.gt,
    Compare.GE: operator.ge,
}


class Machine:
    """Runs one decoded script program on a fixed operand stack and call stack, as CRunScript does."""

    def __init__(
        self,
        program: Program,
        stack_num: int = 0x80,
        call_num: int = 0x200,
        ext: Callable[[Machine, int, int], None] | None = None,
        float32: bool = True,
        max_steps: int = 1_000_000,
    ) -> None:
        """Load a program onto fresh stacks, reserving the global slots of an SB2 program."""
        self.program = program
        self.code = program.code
        self.ext = ext
        self.float32 = float32
        self.max_steps = max_steps
        self.call_num = call_num
        self.stack_end = stack_num
        self.memory = [Slot(Tag.INT, 0) for _ in range(stack_num)]
        self.global_base: int | None = None
        self.global_num = 0
        if program.magic == "SB2":
            self.global_base = 0
            self.global_num = program.global_num
        self.stack_base = self.global_num
        self.sp = self.stack_base
        self.frame = self.stack_base
        self.func: int | None = None
        self.pc: int | None = None
        self.end = 0
        self.skip_wait = 0
        self.skip_end_count = 0
        self.result = 0
        self.call_stack: list[tuple[int, int, int | None]] = []
        self.output = bytearray()
        self.log: list[bytes] = []
        self.waits = 0
        self.steps = 0
        # When set, the step at which each instruction offset first ran.
        self.trace: dict[int, int] | None = None

    def read_arg(self, index: int) -> Slot:
        """Slot at an absolute stack or global index."""
        return self._read(index)

    def write(self, index: int, slot: Slot) -> None:
        """Store a copy of a slot at an absolute stack or global index."""
        self._write(index, slot)

    def run(self, no: int) -> int:
        """Start a numbered program, or main for a negative number; returns 1 if it suspended, 0 if it ended, -1 if absent."""
        self.sp = self.stack_base
        self.call_stack.clear()
        self.func = None
        if no < 0:
            block: int | None = self.program.main
        else:
            block = next((entry for number, entry in self.program.programs if number == no), None)
        if block is None:
            self.log.append(b"not found program %d\n" % no)
            return -1
        entry = self._enter(block)
        self.end = 0
        self.skip_wait = 0
        self.skip_end_count = 0
        self.exe(entry)
        return 0 if self.end else 1

    def resume(self) -> None:
        """Continue a suspended script from its next instruction."""
        if self.pc is not None:
            self.exe(self.pc)

    def skip(self) -> None:
        """Resume a suspended script, running through its waits up to the next skip end."""
        self.skip_wait = 1
        self.resume()

    def check_program(self, no: int) -> bool:
        """Whether the program has a numbered entry."""
        return any(number == no for number, _ in self.program.programs)

    def outside_frame(self, access: str, address: int) -> None:
        """Called before a load or store reaches a slot outside the running function's frame, which retail allows."""

    def returned(self, call: int, callee: int, frame: int) -> None:
        """Called after a script function returns to the CALL at the given offset, with its frame still in memory."""

    def default_ext(self, base: int, argc: int) -> None:
        """Log an external call with no external functions registered, as retail does with an empty table."""
        self.log.append(b"not found ext %d\n" % _raw_int(self._read(base)))

    def exe(self, entry: int) -> None:
        """Run instructions from an absolute file offset until the script ends or suspends."""
        self.pc = entry
        while True:
            self.steps += 1
            if self.steps > self.max_steps:
                raise VMError("step budget exceeded")
            if self.trace is not None:
                self.trace.setdefault(self.pc, self.steps)
            op, a1, a2 = struct.unpack_from("<iii", self.program.data, self.pc)
            if op == Op.LOAD:
                address = self._address(a2, a1)
                if address is not None:
                    if a2 not in GLOBAL_MODES and self._past_frame(address):
                        self.outside_frame("load past the frame", address)
                    if a2 in FLOAT_MODES:
                        self._retag_float(address)
                    self._push(self._read(address))
            elif op == Op.LOAD_ADDR:
                address = self._address(a2, a1)
                if address is not None:
                    self._push(Slot(Tag.PTR, address))
            elif op == Op.PUSH_CONST:
                self._push_const(a1, a2)
            elif op == Op.POP:
                self._pop()
            elif op == Op.STORE:
                value = self._pop()
                target = self._pop()
                if target.tag != Tag.PTR:
                    raise VMError("store through a non-pointer")
                if self._past_frame(target.value):
                    self.outside_frame("store past the frame", target.value)
                self._write(target.value, value)
                self._push(value)
            elif op == Op.JMP:
                if not self.skip_wait:
                    self.pc = self.code + a1
                    continue
            elif op == Op.JMP_TRUE:
                if not self.skip_wait and is_true(self._pop()):
                    if a2:
                        self._push(Slot(Tag.INT, 1))
                    self.pc = self.code + a1
                    continue
            elif op == Op.JMP_FALSE:
                if not self.skip_wait and not is_true(self._pop()):
                    if a2:
                        self._push(Slot(Tag.INT, 0))
                    self.pc = self.code + a1
                    continue
            elif op == Op.CMP:
                self._compare(a1)
            elif op in _ARITH:
                self._arith(Op(op))
            elif op == Op.DIV:
                self._divide()
            elif op == Op.MOD:
                self._modulo()
            elif op == Op.AND:
                rhs = self._int(self._pop())
                self._push(Slot(Tag.INT, self._int(self._pop()) & rhs))
            elif op == Op.OR:
                rhs = self._int(self._pop())
                self._push(Slot(Tag.INT, self._int(self._pop()) | rhs))
            elif op == Op.NEG:
                self._negate()
            elif op in (Op.SIN, Op.COS):
                self._trig(Op(op))
            elif op == Op.NOT:
                self._push(Slot(Tag.INT, int(self._int(self._pop()) == 0)))
            elif op == Op.ITOF:
                self._itof()
            elif op == Op.FTOI:
                self._ftoi()
            elif op == Op.PRINT:
                self._print(a1)
            elif op == Op.EXT:
                base = self._drop(a1)
                if not self.skip_wait:
                    if self.ext is None:
                        self.default_ext(base, a1)
                    else:
                        self.ext(self, base, a1)
            elif op == Op.END:
                self.end = 1
                self.pc = None
                return
            elif op == Op.CALL:
                # Retail steps back before the loop steps forward, landing on the callee's first instruction.
                self.pc = self._call(self.code + a2, self.pc) - INSTRUCTION_SIZE
            elif op == Op.RET:
                value = self._pop()
                if self.call_stack:
                    callee, callee_frame = self.func, self.frame
                    self.sp = self.frame
                    self.pc, self.frame, self.func = self.call_stack.pop()
                    self.returned(self.pc, callee, callee_frame)
                    self._push(value)
                else:
                    self.result = _raw_int(value)
                    self._push(value)
                    self.pc = None
                    self.end = 1
                    return
            elif op == Op.WAIT:
                if not self.skip_wait:
                    self.pc += INSTRUCTION_SIZE
                    self.waits += 1
                    return
            elif op == Op.SKIP_END:
                self.skip_end_count += 1
                if self.skip_wait:
                    self.skip_wait = 0
                    self.pc += INSTRUCTION_SIZE
                    return
            self.pc += INSTRUCTION_SIZE

    def _round(self, value: float) -> float:
        return f32(value) if self.float32 else value

    def _float_from_bits(self, bits: int) -> float:
        # Double mode models a float as the shortest spelling the Luau source uses for it.
        value = bits_to_float(bits)
        return value if self.float32 else numbers.literal(value)

    def _to_float(self, value: int) -> float:
        return self._round(float(value))

    def _number(self, slot: Slot, name: str) -> float:
        if slot.tag == Tag.INT:
            return self._to_float(slot.value)
        if slot.tag == Tag.FLOAT:
            return slot.value
        raise VMError(f"operand is not number at {name}")

    def _int(self, slot: Slot) -> int:
        if slot.tag != Tag.INT:
            raise VMError("operand is not integer")
        return slot.value

    def _check_stack(self) -> None:
        if self.sp >= self.stack_end:
            raise VMError("stack overflow")

    def _push(self, slot: Slot) -> None:
        self._check_stack()
        self.memory[self.sp] = Slot(slot.tag, slot.value)
        self.sp += 1

    def _pop(self) -> Slot:
        if self.sp <= self.stack_base:
            raise VMError("stack underflow")
        self.sp -= 1
        return self.memory[self.sp]

    def _drop(self, count: int) -> int:
        if count < 0 or self.sp - count < self.stack_base:
            raise VMError("stack underflow")
        self.sp -= count
        return self.sp

    def _read(self, index: int) -> Slot:
        if not 0 <= index < len(self.memory):
            raise VMError("memory access out of range")
        return self.memory[index]

    def _write(self, index: int, slot: Slot) -> None:
        if not 0 <= index < len(self.memory):
            raise VMError("memory access out of range")
        self.memory[index] = Slot(slot.tag, slot.value)

    def _global(self, arg: int) -> int:
        if self.global_base is None:
            raise VMError("global access in a program with no globals")
        if not 0 <= arg < self.global_num:
            raise VMError("global index out of range")
        return self.global_base + arg

    def _pointer_index(self, arg: int) -> int:
        base = self._read(self.frame + arg)
        if base.tag != Tag.PTR:
            raise VMError("pointer index through a non-pointer")
        return base.value + self._int(self._pop())

    def _locals(self) -> int:
        """Number of local slots in the running function's frame."""
        return struct.unpack_from("<i", self.program.data, self.func + 8)[0] if self.func is not None else 0

    def _past_frame(self, address: int) -> bool:
        """Whether an address lies above the running function's locals, in the operand stack; globals lie below."""
        return address >= self.frame + self._locals()

    def _address(self, mode: int, arg: int) -> int | None:
        if mode not in _ADDRESS_MODES:
            return None
        if mode in POINTER_MODES:
            return self._pointer_index(arg)
        if mode in INDEXED_MODES:
            address = self.frame + arg + self._int(self._pop())
            if address < self.frame:
                self.outside_frame("local index below the frame", address)
            return address
        if mode in GLOBAL_MODES:
            return self._global(arg)
        return self.frame + arg

    def _retag_float(self, address: int) -> None:
        slot = self._read(address)
        if slot.tag == Tag.FLOAT:
            return
        if slot.tag != Tag.INT:
            raise VMError("float access to a non-integer slot")
        self.memory[address] = Slot(Tag.FLOAT, self._float_from_bits(slot.value))

    def _push_const(self, const_type: int, arg: int) -> None:
        if const_type == ConstType.INT:
            self._push(Slot(Tag.INT, arg))
        elif const_type == ConstType.STR:
            start = self.code + arg
            end = self.program.data.find(b"\0", start)
            self._push(Slot(Tag.STR, self.program.data[start:end]))
        elif const_type == ConstType.FLOAT:
            self._push(Slot(Tag.FLOAT, self._float_from_bits(arg)))

    def _arith(self, op: Op) -> None:
        rhs = self._pop()
        lhs = self._pop()
        if lhs.tag == Tag.INT and rhs.tag == Tag.INT:
            self._push(Slot(Tag.INT, wrap32(_ARITH[op](lhs.value, rhs.value))))
        else:
            left = self._number(lhs, op.name)
            right = self._number(rhs, op.name)
            self._push(Slot(Tag.FLOAT, self._round(_ARITH[op](left, right))))

    def _divide(self) -> None:
        rhs = self._pop()
        if _is_zero_divisor(rhs):
            raise VMError("divide by 0")
        lhs = self._pop()
        if lhs.tag == Tag.INT and rhs.tag == Tag.INT:
            self._push(Slot(Tag.INT, wrap32(_trunc_div(lhs.value, rhs.value))))
        else:
            left = self._number(lhs, Op.DIV.name)
            right = self._number(rhs, Op.DIV.name)
            self._push(Slot(Tag.FLOAT, self._round(_fdiv(left, right))))

    def _modulo(self) -> None:
        rhs = self._int(self._pop())
        if rhs == 0:
            raise VMError("modulo by 0")
        lhs = self._int(self._pop())
        remainder = abs(lhs) % abs(rhs)
        self._push(Slot(Tag.INT, -remainder if lhs < 0 else remainder))

    def _negate(self) -> None:
        slot = self._pop()
        if slot.tag == Tag.INT:
            self._push(Slot(Tag.INT, wrap32(-slot.value)))
        elif slot.tag == Tag.FLOAT:
            self._push(Slot(Tag.FLOAT, -slot.value))
        else:
            raise VMError("operand is not number at NEG")

    def _trig(self, op: Op) -> None:
        slot = self._pop()
        if slot.tag == Tag.INT:
            argument = self._to_float(slot.value)
        elif slot.tag == Tag.FLOAT:
            argument = slot.value
        else:
            raise VMError(f"operand is not number at {op.name}")
        function = sinf if op == Op.SIN else cosf
        self._push(Slot(Tag.FLOAT, function(argument)))

    def _itof(self) -> None:
        slot = self._pop()
        if slot.tag == Tag.INT:
            self._push(Slot(Tag.FLOAT, self._to_float(slot.value)))
        elif slot.tag == Tag.FLOAT:
            self._push(Slot(Tag.FLOAT, slot.value))
        else:
            raise VMError("operand is not number at ITOF")

    def _ftoi(self) -> None:
        slot = self._pop()
        if slot.tag == Tag.INT:
            self._push(Slot(Tag.INT, slot.value))
        elif slot.tag == Tag.FLOAT:
            if not math.isfinite(slot.value):
                raise VMError("float is not finite at FTOI")
            self._push(Slot(Tag.INT, wrap32(int(slot.value))))
        else:
            raise VMError("operand is not number at FTOI")

    def _compare(self, compare: int) -> None:
        rhs = self._pop()
        lhs = self._pop()
        if lhs.tag == Tag.INT and rhs.tag == Tag.INT:
            left, right = lhs.value, rhs.value
        else:
            left = self._number(lhs, "CMP")
            right = self._number(rhs, "CMP")
        operation = _COMPARE.get(compare)
        if operation is not None:
            self._push(Slot(Tag.INT, int(operation(left, right))))

    def _print(self, count: int) -> None:
        base = self._drop(count)
        for index in range(base, base + count):
            slot = self._read(index)
            if slot.tag == Tag.INT:
                self.output += b"%d" % slot.value
            elif slot.tag == Tag.STR:
                self.output += slot.value
            elif slot.tag == Tag.FLOAT:
                self.output += ("%f" % slot.value).encode("ascii")

    def _enter(self, block: int) -> int:
        addr, _name, local, arg = struct.unpack_from("<Iiii", self.program.data, block)
        frame = self.sp - arg
        if frame < self.stack_base:
            raise VMError("stack underflow")
        self.frame = frame
        self.sp = frame + local
        self.func = block
        self._check_stack()
        for index in range(frame + arg, frame + local):
            self.memory[index] = Slot(Tag.INT, 0)
        return self.code + addr

    def _call(self, block: int, return_pc: int) -> int:
        if len(self.call_stack) >= self.call_num:
            raise VMError("call stack overflow")
        self.call_stack.append((return_pc, self.frame, self.func))
        return self._enter(block)
