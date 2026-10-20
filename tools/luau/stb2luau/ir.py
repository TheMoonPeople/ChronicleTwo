"""Intermediate representation of a lifted script function: expression trees, statements and block exits."""

from __future__ import annotations

import dataclasses
from collections.abc import Iterator

from stb import opcodes

INT, FLOAT, STR, BOOL, ANY = "int", "float", "str", "bool", "any"

Slot = tuple[str, int]
# The table that holds a whole frame when a computed index may leave its array.
FRAME: Slot = ("frame", 0)


@dataclasses.dataclass(frozen=True)
class Const:
    """A literal integer, float or string."""

    value: int | float | bytes
    type: str


@dataclasses.dataclass(frozen=True)
class Var:
    """A read of a variable."""

    slot: Slot
    type: str


@dataclasses.dataclass(frozen=True)
class Addr:
    """A by-reference argument naming a variable, or with an index, one element of a local array."""

    slot: Slot
    type: str
    index: Expr | None = None


@dataclasses.dataclass(frozen=True)
class Elem:
    """A read of one element of a local array, held in a table and keyed by the array's slot."""

    array: Slot
    index: Expr
    type: str


@dataclasses.dataclass(frozen=True)
class Temp:
    """A temporary holding a value spilled off the operand stack."""

    index: int
    type: str


@dataclasses.dataclass(frozen=True)
class Unary:
    """An operation on one operand: neg, not, itof, ftoi, sin or cos.

    wrap marks an integer negation that may overflow 32 bits, which the PS2 wraps.
    """

    op: str
    operand: Expr
    type: str
    wrap: bool = False


@dataclasses.dataclass(frozen=True)
class Binary:
    """An arithmetic or bitwise operation on two operands.

    wrap marks an integer sum, difference or product that may overflow 32 bits, which the PS2 wraps.
    """

    op: str
    lhs: Expr
    rhs: Expr
    type: str
    wrap: bool = False


@dataclasses.dataclass(frozen=True)
class Compare:
    """A comparison of two operands, yielding a truth value."""

    op: opcodes.Compare
    lhs: Expr
    rhs: Expr

    @property
    def type(self) -> str:
        """Comparisons always produce a boolean."""
        return BOOL


@dataclasses.dataclass(frozen=True)
class Logical:
    """A short-circuit "and" or "or" that yields the operand which decided the result."""

    op: str
    lhs: Expr
    rhs: Expr
    type: str


@dataclasses.dataclass(frozen=True)
class Call:
    """A call of a script function, identified by its header block, yielding its return value.

    The offset is the CALL instruction's, which the harness uses to match the values a call's references hold.
    """

    function: int
    args: tuple[Expr, ...]
    type: str
    offset: int = dataclasses.field(default=-1, compare=False)


Expr = Const | Var | Addr | Elem | Temp | Unary | Binary | Compare | Logical | Call


@dataclasses.dataclass(frozen=True)
class Assign:
    """A store of a value into a variable, an array element or a temporary."""

    target: Slot | Temp | Elem
    value: Expr
    offset: int = -1


@dataclasses.dataclass(frozen=True)
class ExtCall:
    """A call of an external command; by-reference arguments may be written by it."""

    command: int
    args: tuple[Expr, ...]
    offset: int = -1
    # Per argument, from stb2luau/tags.py: ("value", tags) for a value, ("ref", tags at the call, interpretations of the
    # reads of what the call writes) for a reference, or None; empty when the call was not analysed.
    tags: tuple = ()


@dataclasses.dataclass(frozen=True)
class CallStmt:
    """A script call whose return value is discarded."""

    call: Call
    offset: int = -1


@dataclasses.dataclass(frozen=True)
class Print:
    """A debug print of the given values."""

    args: tuple[Expr, ...]
    offset: int = -1


@dataclasses.dataclass(frozen=True)
class Wait:
    """Yields control until the next frame."""

    offset: int = -1


@dataclasses.dataclass(frozen=True)
class Return:
    """Returns a value from the function."""

    value: Expr
    offset: int = -1


@dataclasses.dataclass(frozen=True)
class End:
    """Ends the script."""

    offset: int = -1


Statement = Assign | ExtCall | CallStmt | Print | Wait | Return | End


@dataclasses.dataclass
class If:
    """A two-way conditional with optional else branch."""

    cond: Expr
    then: list
    orelse: list


@dataclasses.dataclass
class While:
    """A loop that tests its condition before each iteration."""

    cond: Expr
    body: list


@dataclasses.dataclass
class Repeat:
    """A loop that runs its body until the condition holds."""

    body: list
    cond: Expr


@dataclasses.dataclass
class NumericFor:
    """A counted loop whose limit is inclusive, as Luau's numeric for."""

    var: Slot
    start: Expr
    limit: Expr
    step: Expr
    body: list


@dataclasses.dataclass
class Break:
    """Leaves the innermost loop."""


@dataclasses.dataclass
class Continue:
    """Skips to the next iteration of the innermost loop."""


@dataclasses.dataclass(frozen=True)
class Jump:
    """Unconditional transfer to another block."""

    target: int


@dataclasses.dataclass(frozen=True)
class Branch:
    """Transfer to one of two blocks depending on a condition."""

    cond: Expr
    true_target: int
    false_target: int


@dataclasses.dataclass(frozen=True)
class Stop:
    """Leaves the function, after a return or the end of the script."""


@dataclasses.dataclass
class LiftedBlock:
    """A straight-line run of statements ending in one block exit."""

    start: int
    statements: list
    exit: Jump | Branch | Stop | None = None


@dataclasses.dataclass
class LiftedFunction:
    """A script function lifted to expression trees, with the types of its slots and temporaries."""

    block: int
    arg: int
    local: int
    entry: int
    blocks: dict[int, LiftedBlock]
    slot_types: dict[Slot, str]
    temps: list[str]
    refs: tuple[int, ...] = ()
    arrays: dict[Slot, int] = dataclasses.field(default_factory=dict)
    folded: frozenset[int] = frozenset()


def walk(expr: Expr) -> Iterator[Expr]:
    """Every sub-expression of an expression in pre-order, including the expression itself."""
    yield expr
    if isinstance(expr, Unary):
        yield from walk(expr.operand)
    elif isinstance(expr, (Binary, Compare, Logical)):
        yield from walk(expr.lhs)
        yield from walk(expr.rhs)
    elif isinstance(expr, Call):
        for arg in expr.args:
            yield from walk(arg)
    elif isinstance(expr, Elem) or (isinstance(expr, Addr) and expr.index is not None):
        yield from walk(expr.index)


def reads(expr: Expr) -> set[Slot]:
    """Variables and arrays an expression reads, including those it takes by reference."""
    found: set[Slot] = set()
    for sub in walk(expr):
        if isinstance(sub, (Var, Addr)):
            found.add(sub.slot)
        elif isinstance(sub, Elem):
            found.add(sub.array)
    return found


def target_slot(target: Slot | Temp | Elem) -> Slot | None:
    """The variable or array an assignment writes, or None for a temporary."""
    if isinstance(target, Temp):
        return None
    if isinstance(target, Elem):
        return target.array
    return target


def has_call(expr: Expr) -> bool:
    """Whether evaluating an expression runs a script function."""
    return any(isinstance(sub, Call) for sub in walk(expr))


def add_const(expr: Expr, amount: int) -> Expr:
    """An integer expression plus a constant, folded into a constant or a trailing constant operand."""
    if amount == 0:
        return expr
    if isinstance(expr, Const) and expr.type == INT:
        return Const(_wrap32(expr.value + amount), INT)
    if (
        isinstance(expr, Binary)
        and expr.op in ("add", "sub")
        and not expr.wrap
        and isinstance(expr.rhs, Const)
        and expr.rhs.type == INT
    ):
        total = expr.rhs.value + amount if expr.op == "add" else amount - expr.rhs.value
        if total == 0:
            return expr.lhs
        if total > 0:
            return Binary("add", expr.lhs, Const(total, INT), expr.type)
        return Binary("sub", expr.lhs, Const(-total, INT), expr.type)
    if amount > 0:
        return Binary("add", expr, Const(amount, INT), INT)
    return Binary("sub", expr, Const(-amount, INT), INT)


def _wrap32(value: int) -> int:
    return ((value + 0x8000_0000) & 0xFFFF_FFFF) - 0x8000_0000
