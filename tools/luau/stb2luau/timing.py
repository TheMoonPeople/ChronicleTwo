"""Converts the PAL release's script timing to NTSC before the scripts are translated.

The PAL scripts carry the NTSC frame counts and convert them at run time: the event library scales field counts
by 50/60, monster scripts call a 30 -> 25 frame converter, a few scripts divide by 30 and multiply by 25 in
integers, and a handful of sites were retuned by hand. Each recipe matches decoded instructions inside a script's
functions and replaces the conversion with no-ops, or writes the NTSC literal at an anchored instruction after
checking the PAL one. Replaced instructions become op 22 markers that carry the original operand, so a converted
script decodes back to its PAL preimage and a second pass writes nothing.
"""

from __future__ import annotations

import dataclasses
import enum
import functools
import json
import struct
from pathlib import Path

from stb.opcodes import AddrMode, Compare, ConstType, Op
from stb.program import DecodeError, decode

INVENTORY_PATH = Path(__file__).with_name("timing_inventory.json")
MARKER_TAG = 0x4E544D54
ANCHOR_MARKER_BASE = 32
ANY_ARG1 = 1
ANY_ARG2 = 2
ZERO_RECIPES = (0,) * 8


class TimingError(ValueError):
    """A script whose timing cannot be converted, or whose recipe counts differ from the inventory."""


class _DecodeFailure(TimingError):
    """A script that the decoder rejects."""


class Recipe(enum.IntEnum):
    """The recipe classes, in the order of the inventory's count columns."""

    EVENT_ASSIGN = 0
    EVENT_CUE = 1
    EVENT_INLINE = 2
    EVENT_INLINE_FLOAT = 3
    EVENT_INVERSE = 4
    EVENT_INVERSE_FLOAT = 5
    MONSTER_CONVERT = 6
    INTEGER_30_25 = 7


_RECIPE_NAMES = ("assign", "cue", "inline", "float", "inverse", "inverse float", "convert", "integer")


@dataclasses.dataclass(frozen=True)
class Counts:
    """Sites found per recipe, plus the anchored literals and attack windows of a script."""

    recipes: tuple[int, ...] = ZERO_RECIPES
    anchors: int = 0
    windows: int = 0

    def describe(self) -> str:
        """Human-readable summary of the counts, used in mismatch errors."""
        parts = [f"{name} {count}" for name, count in zip(_RECIPE_NAMES, self.recipes)]
        return f"{', '.join(parts)}, anchors {self.anchors}, windows {self.windows}"


@dataclasses.dataclass(frozen=True)
class _Item:
    """One instruction of a pattern; flags let the first argument or the second match anything."""

    op: int
    a1: int = 0
    a2: int = 0
    flags: int = 0


@dataclasses.dataclass(frozen=True)
class _Insn:
    """A decoded instruction; the offset is positional and does not take part in comparisons."""

    op: int
    a1: int
    a2: int
    offset: int = dataclasses.field(default=0, compare=False)


@dataclasses.dataclass(frozen=True)
class _Pattern:
    """A recipe window and the positions within it that become no-ops."""

    recipe: Recipe
    items: tuple[_Item, ...]
    first_nop: int
    nops: int


@dataclasses.dataclass(frozen=True)
class AnchorWrite:
    """One instruction an anchor rewrites: a no-op marker, or the NTSC second operand."""

    pos: int
    nop: bool
    ntsc_a2: int = 0


@dataclasses.dataclass(frozen=True)
class Anchor:
    """An instruction sequence with a PAL literal that the NTSC timing rewrites, for one script or language copies."""

    id: str
    path: str
    language: bool
    offset: int
    window: bool
    items: tuple[_Item, ...]
    writes: tuple[AnchorWrite, ...]


class _Family(enum.Enum):
    """Script families that gate which recipes may apply, from the key prefix."""

    NONE = enum.auto()
    EVENT = enum.auto()
    MONSTER = enum.auto()
    EFFECT = enum.auto()


def _s32(value: int) -> int:
    return ((value + (1 << 31)) % (1 << 32)) - (1 << 31)


def _float_bits(value: float) -> int:
    return struct.unpack("<i", struct.pack("<f", value))[0]


def _op(op: Op) -> _Item:
    return _Item(op)


def _push_int(value: int) -> _Item:
    return _Item(Op.PUSH_CONST, ConstType.INT, value)


def _push_float(value: float) -> _Item:
    return _Item(Op.PUSH_CONST, ConstType.FLOAT, _float_bits(value))


def _push_float_bits(bits: int) -> _Item:
    return _Item(Op.PUSH_CONST, ConstType.FLOAT, bits)


def _local_load() -> _Item:
    return _Item(Op.LOAD, 0, AddrMode.LOCAL, ANY_ARG1)


def _local_addr() -> _Item:
    return _Item(Op.LOAD_ADDR, 0, AddrMode.LOCAL, ANY_ARG1)


def _compare(how: Compare) -> _Item:
    return _Item(Op.CMP, how, 0)


_MUL, _DIV = _op(Op.MUL), _op(Op.DIV)

# The recipe windows, tried in order at every instruction; the matched positions from first_nop become no-ops.
PATTERNS: tuple[_Pattern, ...] = (
    _Pattern(Recipe.EVENT_ASSIGN, (_local_addr(), _local_load(), _push_int(50), _MUL, _push_int(60), _DIV, _op(Op.STORE), _op(Op.POP)), 2, 4),
    _Pattern(Recipe.EVENT_CUE, (_local_addr(), _local_load(), _push_int(50), _MUL, _push_int(60), _DIV, _op(Op.STORE), _op(Op.POP)), 0, 8),
    _Pattern(Recipe.EVENT_INLINE, (_push_int(50), _MUL, _push_int(60), _DIV), 0, 4),
    _Pattern(Recipe.EVENT_INLINE_FLOAT, (_push_float(50.0), _MUL, _push_float(60.0), _DIV), 0, 4),
    _Pattern(Recipe.EVENT_INVERSE, (_push_int(60), _DIV, _push_int(50), _MUL), 0, 4),
    _Pattern(Recipe.EVENT_INVERSE_FLOAT, (_push_float(60.0), _DIV, _push_float(50.0), _MUL), 0, 4),
    _Pattern(
        Recipe.MONSTER_CONVERT,
        (_Item(Op.LOAD, 0, AddrMode.LOCAL), _op(Op.ITOF), _push_float(30.0), _DIV, _push_float(25.0), _MUL, _op(Op.FTOI), _op(Op.RET)),
        1,
        5,
    ),
    _Pattern(Recipe.INTEGER_30_25, (_push_int(30), _DIV, _push_int(25), _MUL), 0, 4),
)

# Each exact-path anchor names one script; each language anchor names the stem of the copies stem_1..stem_5.
ANCHORS: tuple[Anchor, ...] = (
    # d03 jump: PAL speeds up the jump by 6/5 (horizontal 16.0f * 1.2f, fewer steps) and retunes its vertical start;
    # the loop and the per-step move are EVENT_INLINE sites.
    Anchor(
        "d03-jump-speed",
        "map/d/d03/d03",
        True,
        -1,
        False,
        (_push_float(16.0), _push_float(1.2), _MUL),
        (AnchorWrite(1, True), AnchorWrite(2, True)),
    ),
    Anchor(
        "d03-jump-rise",
        "map/d/d03/d03",
        True,
        -1,
        False,
        (_Item(Op.LOAD_ADDR, 0, AddrMode.LOCAL_INDEX_FLOAT, ANY_ARG1), _push_float(6.2), _op(Op.NEG), _op(Op.STORE)),
        (AnchorWrite(1, False, _float_bits(6.0)),),
    ),
    # s03: a turn of pi/20 per field, sped up by 6/5 over a loop shortened from 40 to 33.
    Anchor(
        "s03-turn-step",
        "map/s/s03/s03",
        True,
        -1,
        False,
        (_push_float_bits(0x40490FDB), _push_float(20.0), _DIV, _push_float(1.2), _MUL),
        (AnchorWrite(3, True), AnchorWrite(4, True)),
    ),
    Anchor(
        "s03-turn-loop",
        "map/s/s03/s03",
        True,
        -1,
        False,
        (_local_load(), _push_int(33), _compare(Compare.LT), _Item(Op.JMP_FALSE, 0, 0, ANY_ARG1)),
        (AnchorWrite(1, False, 40),),
    ),
    # m06b: an object's motion delay and the wait after it, written as PAL literals.
    Anchor(
        "m06b-motion-delay",
        "map/m/m06/m06b",
        True,
        -1,
        False,
        (_push_float(0.08), _Item(Op.EXT, 3), _push_int(464), _push_int(4), _push_int(34), _Item(Op.EXT, 3)),
        (AnchorWrite(4, False, 30),),
    ),
    Anchor(
        "m06b-wait",
        "map/m/m06/m06b",
        True,
        -1,
        False,
        (_local_load(), _push_int(25), _compare(Compare.LT), _Item(Op.JMP_FALSE, 0, 0, ANY_ARG1)),
        (AnchorWrite(1, False, 30),),
    ),
    # i01h01b backpack scene: NTSC loops 42 times over wait(1), two resumes each, with the sound cue at step 12;
    # PAL loops over a bare wait. With the factors gone the loop counts resumes: 84, cue at 24.
    Anchor(
        "i01h01b-backpack-loop",
        "map/i/i01/h01/i01h01b",
        True,
        -1,
        False,
        (_local_load(), _push_int(42), _push_int(50), _MUL, _push_int(60), _DIV, _compare(Compare.LT)),
        (AnchorWrite(1, False, 84),),
    ),
    Anchor(
        "i01h01b-backpack-cue",
        "map/i/i01/h01/i01h01b",
        True,
        -1,
        False,
        (_local_load(), _push_int(25), _push_int(50), _MUL, _push_int(60), _DIV, _compare(Compare.EQ)),
        (AnchorWrite(1, False, 24),),
    ),
    # e221a: one turn passes conv(15) where NTSC passed 12.
    Anchor(
        "e221a-turn",
        "dungeon/monster/e221a.stb",
        False,
        0x12CD8,
        False,
        (_push_int(15), _Item(Op.CALL, 0, 0, ANY_ARG1 | ANY_ARG2)),
        (AnchorWrite(0, False, 12),),
    ),
    # Max (c01) and Monica (c02) motion-ratio windows.
    Anchor("c01-trail-start", "mainchr/c01.stb", False, 0x11A0, True, (_push_float(0.26), _Item(Op.PUSH_CONST, ConstType.FLOAT, 0, ANY_ARG2)), (AnchorWrite(0, False, _float_bits(0.27)),)),
    Anchor("c01-trail-end", "mainchr/c01.stb", False, 0x11AC, True, (_push_float(0.3), _Item(Op.PUSH_CONST, ConstType.STR, 0, ANY_ARG2)), (AnchorWrite(0, False, _float_bits(0.29)),)),
    Anchor("c01-catch-start", "mainchr/c01.stb", False, 0x87C0, True, (_push_float(0.12), _compare(Compare.GE)), (AnchorWrite(0, False, _float_bits(0.14)),)),
    Anchor("c01-catch-end", "mainchr/c01.stb", False, 0x87F0, True, (_push_float(0.24), _compare(Compare.LT)), (AnchorWrite(0, False, _float_bits(0.233)),)),
    Anchor("c01-catch2-start", "mainchr/c01.stb", False, 0x932C, True, (_push_float(0.12), _compare(Compare.GE)), (AnchorWrite(0, False, _float_bits(0.14)),)),
    Anchor("c01-catch2-end", "mainchr/c01.stb", False, 0x935C, True, (_push_float(0.24), _compare(Compare.LT)), (AnchorWrite(0, False, _float_bits(0.233)),)),
    Anchor("c02-shot-end", "mainchr/c02.stb", False, 0xB308, True, (_push_float(0.48), _compare(Compare.LE)), (AnchorWrite(0, False, _float_bits(0.45)),)),
    Anchor("c02-shot2-end", "mainchr/c02.stb", False, 0xB3BC, True, (_push_float(0.45), _compare(Compare.LE)), (AnchorWrite(0, False, _float_bits(0.42)),)),
)


@dataclasses.dataclass(frozen=True)
class _Function:
    """A decoded function: its frame layout and instructions, with the marker-free operands."""

    local: int
    arg: int
    insns: tuple[_Insn, ...]


def key(path: str) -> str:
    """Normalised inventory key of an asset path: lower case, forward slashes, no leading slash."""
    folded = []
    for char in path:
        char = "/" if char == "\\" else (chr(ord(char) + 32) if "A" <= char <= "Z" else char)
        if char == "/" and not folded:
            continue
        folded.append(char)
    return "".join(folded)


@functools.cache
def inventory() -> dict[str, Counts]:
    """Expected recipe counts of every known PAL script, keyed by normalised path."""
    document = json.loads(INVENTORY_PATH.read_text(encoding="utf-8"))
    if len(document["recipes"]) != len(Recipe):
        raise TimingError("timing inventory has the wrong recipe count")
    return {
        path: Counts(tuple(row["recipes"]), row["anchors"], row["windows"])
        for path, row in document["scripts"].items()
    }


def _family(normalised: str) -> _Family:
    if normalised.startswith(("map/", "event/")):
        return _Family.EVENT
    if normalised.startswith("dungeon/monster/"):
        return _Family.MONSTER
    if normalised.startswith("dungeon/eff_script/"):
        return _Family.EFFECT
    return _Family.NONE


def _allowed(recipe: Recipe, family: _Family) -> bool:
    if recipe == Recipe.MONSTER_CONVERT:
        return family == _Family.MONSTER
    if recipe == Recipe.INTEGER_30_25:
        return family in (_Family.MONSTER, _Family.EFFECT)
    return family == _Family.EVENT


def _matches(item: _Item, insn: _Insn) -> bool:
    return (
        item.op == insn.op
        and (bool(item.flags & ANY_ARG1) or item.a1 == insn.a1)
        and (bool(item.flags & ANY_ARG2) or item.a2 == insn.a2)
    )


def _window_at(items: tuple[_Item, ...], code: tuple[_Insn, ...], at: int) -> bool:
    if at + len(items) > len(code):
        return False
    return all(_matches(item, code[at + k]) for k, item in enumerate(items))


def _in_context(pattern: _Pattern, function: _Function, code: tuple[_Insn, ...], at: int) -> bool:
    if pattern.recipe == Recipe.EVENT_ASSIGN:
        return code[at].a1 == code[at + 1].a1
    if pattern.recipe == Recipe.EVENT_CUE:
        return code[at].a1 != code[at + 1].a1
    if pattern.recipe == Recipe.MONSTER_CONVERT:
        return at == 0 and len(code) == len(pattern.items) and function.arg == 1 and function.local == 1
    if pattern.recipe == Recipe.INTEGER_30_25:
        helper = (
            at == 2
            and function.arg >= 1
            and code[0].op == Op.LOAD_ADDR
            and code[0].a1 == 0
            and code[0].a2 == AddrMode.LOCAL
            and code[1].op == Op.LOAD
            and code[1].a1 == 0
            and code[1].a2 == AddrMode.LOCAL
            and at + 5 < len(code)
            and code[at + 4].op == Op.STORE
            and code[at + 5].op == Op.POP
        )
        literal = at >= 1 and code[at - 1].op == Op.PUSH_CONST and code[at - 1].a1 == ConstType.INT
        return helper or literal
    return True


def _anchor_applies(anchor: Anchor, normalised: str) -> bool:
    if not anchor.language:
        return normalised == anchor.path
    stem = anchor.path
    return (
        len(normalised) == len(stem) + 6
        and normalised.startswith(stem)
        and normalised[len(stem)] == "_"
        and "1" <= normalised[len(stem) + 1] <= "5"
        and normalised.endswith(".stb")
    )


def _marker(kind: int, pos: int, value: int) -> _Insn:
    return _Insn(Op.LABEL, MARKER_TAG, _s32((kind << 24) | (pos << 16) | (value & 0xFFFF)))


def _unmark(insn: _Insn) -> _Insn | None:
    """The PAL instruction a marker replaced, None for an instruction that is not a marker."""
    if insn.op != Op.LABEL or insn.a1 != MARKER_TAG:
        return None
    bits = insn.a2 & 0xFFFFFFFF
    kind = (bits >> 24) & 0xFF
    pos = (bits >> 16) & 0xFF
    value = bits & 0xFFFF
    value = value - 0x10000 if value >= 0x8000 else value
    item = None
    if kind < len(Recipe):
        items = PATTERNS[kind].items
        item = items[pos] if pos < len(items) else None
    elif ANCHOR_MARKER_BASE <= kind < ANCHOR_MARKER_BASE + len(ANCHORS):
        items = ANCHORS[kind - ANCHOR_MARKER_BASE].items
        item = items[pos] if pos < len(items) else None
    if item is None or item.flags & ANY_ARG2:
        raise TimingError("unknown recipe marker")
    a1 = value if item.flags & ANY_ARG1 else item.a1
    return _Insn(item.op, a1, item.a2, insn.offset)


def _restore(insn: _Insn) -> _Insn:
    original = _unmark(insn)
    return insn if original is None else original


def _decode(data: bytes) -> list[_Function]:
    try:
        program = decode(data)
    except DecodeError as error:
        raise _DecodeFailure(str(error)) from error
    return [
        _Function(
            function.local,
            function.arg,
            tuple(_Insn(int(i.op), i.a1, i.a2, i.offset) for i in function.instructions),
        )
        for function in program.functions.values()
    ]


def plan(key: str, data: bytes) -> tuple[dict[int, tuple[int, int, int]], Counts]:
    """Writes that convert the script to NTSC timing, keyed by absolute instruction offset, with the site counts."""
    functions = _decode(data)
    canonical = [tuple(_restore(insn) for insn in function.insns) for function in functions]
    family = _family(key)
    recipes = [0] * len(Recipe)
    sites: set[int] = set()
    target: dict[int, _Insn] = {}

    def add_write(offset: int, insn: _Insn) -> None:
        existing = target.setdefault(offset, insn)
        if existing != insn:
            raise TimingError(f"{key}: two recipes write the same instruction")

    for function, code in zip(functions, canonical):
        at = 0
        while at < len(code):
            for pattern in PATTERNS:
                if not _allowed(pattern.recipe, family) or not _window_at(pattern.items, code, at) or not _in_context(pattern, function, code, at):
                    continue
                if code[at].offset not in sites:
                    sites.add(code[at].offset)
                    recipes[pattern.recipe] += 1
                    for k in range(pattern.nops):
                        pos = pattern.first_nop + k
                        original = code[at + pos]
                        add_write(original.offset, _marker(pattern.recipe, pos, original.a1))
                at += len(pattern.items)
                break
            else:
                at += 1

    anchors = windows = 0
    for index, anchor in enumerate(ANCHORS):
        if not _anchor_applies(anchor, key):
            continue
        hits = _anchor_hits(anchor, canonical, converted=False) or _anchor_hits(anchor, canonical, converted=True)
        if len(hits) != 1:
            problem = "found more than once" if hits else "not found"
            raise TimingError(f"{key}: anchor {anchor.id} {problem}")
        if anchor.window:
            windows += 1
        else:
            anchors += 1
        function_index, at = hits[0]
        code = canonical[function_index]
        for write in anchor.writes:
            original = code[at + write.pos]
            if write.nop:
                add_write(original.offset, _marker(ANCHOR_MARKER_BASE + index, write.pos, original.a1))
            else:
                add_write(original.offset, _Insn(original.op, original.a1, write.ntsc_a2))

    counts = Counts(tuple(recipes), anchors, windows)
    return {offset: (insn.op, insn.a1, insn.a2) for offset, insn in target.items()}, counts


def _anchor_hits(anchor: Anchor, canonical: list[tuple[_Insn, ...]], converted: bool) -> list[tuple[int, int]]:
    """Function and index of each instruction sequence the anchor matches, once per instruction offset."""
    hits: list[tuple[int, int]] = []
    seen: set[int] = set()
    for function_index, code in enumerate(canonical):
        for at, insn in enumerate(code):
            if anchor.offset >= 0 and insn.offset != anchor.offset:
                continue
            if _anchor_matches(anchor, code, at, converted) and insn.offset not in seen:
                seen.add(insn.offset)
                hits.append((function_index, at))
    return hits


def _anchor_matches(anchor: Anchor, code: tuple[_Insn, ...], at: int, converted: bool) -> bool:
    """Whether the PAL preimage (or, when converted, the NTSC image) of the anchor starts at the index."""
    if at + len(anchor.items) > len(code):
        return False
    for k, item in enumerate(anchor.items):
        insn = code[at + k]
        ok = _matches(item, insn)
        for write in anchor.writes:
            if converted and write.pos == k and not write.nop:
                ok = item.op == insn.op and item.a1 == insn.a1 and insn.a2 == write.ntsc_a2
        if not ok:
            return False
    return True


def apply(key: str, data: bytes, expected: Counts | None = None) -> bytes:
    """The script converted to NTSC timing; data comes back unchanged for an unknown script that does not decode.

    The site counts must equal the inventory row of the key (zero for an unknown key), or expected when given.
    """
    row = expected if expected is not None else inventory().get(key)
    try:
        writes, counts = plan(key, data)
    except _DecodeFailure:
        if row is None:
            return data
        raise
    want = row if row is not None else Counts()
    if counts != want:
        raise TimingError(f"{key}: found {counts.describe()}; expected {want.describe()}")

    out = bytearray(data)
    for offset, (op, a1, a2) in writes.items():
        if struct.unpack_from("<iii", data, offset) != (op, a1, a2):
            struct.pack_into("<iii", out, offset, op, a1, a2)
    return bytes(out)
