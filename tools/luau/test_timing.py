import json
import os
import struct
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode, Compare, Op  # noqa: E402
from stb.program import DecodeError, decode  # noqa: E402
from stb2luau import timing  # noqa: E402
from stb2luau.timing import Counts, Recipe, TimingError  # noqa: E402
from stb.corpus import scripts  # noqa: E402
from survey import resolve_data  # noqa: E402

LOCAL = AddrMode.LOCAL
LABEL = Op.LABEL
ZERO = (0,) * 8


SHORT_NAMES = {
    "assign": Recipe.EVENT_ASSIGN,
    "cue": Recipe.EVENT_CUE,
    "inline": Recipe.EVENT_INLINE,
    "float": Recipe.EVENT_INLINE_FLOAT,
    "inverse": Recipe.EVENT_INVERSE,
    "inverse_float": Recipe.EVENT_INVERSE_FLOAT,
    "convert": Recipe.MONSTER_CONVERT,
    "integer": Recipe.INTEGER_30_25,
}


def recipes(**counts):
    values = [0] * len(Recipe)
    for name, count in counts.items():
        values[SHORT_NAMES[name]] = count
    return tuple(values)


def main_insns(data):
    program = decode(data)
    return program.functions[program.main].instructions


def ops(data):
    return [(insn.op, insn.a1, insn.a2) for insn in main_insns(data)]


def marker_kind(insn):
    return ((insn.a2 & 0xFFFFFFFF) >> 24) & 0xFF


def run_plan(key, data, expected):
    writes, counts = timing.plan(key, data)
    if counts != expected:
        raise AssertionError(f"{key}: plan found {counts.describe()}; expected {expected.describe()}")
    return timing.apply(key, data, expected=expected)


def float_bits(value):
    return struct.unpack("<i", struct.pack("<f", value))[0]


class KeyTest(unittest.TestCase):
    def test_normalises_paths(self):
        self.assertEqual(timing.key("\\Map\\S\\S03\\S03_1.STB"), "map/s/s03/s03_1.stb")
        self.assertEqual(timing.key("/dungeon/Monster/x.stb"), "dungeon/monster/x.stb")
        self.assertEqual(timing.key("//a/b"), "a/b")


class CountsTest(unittest.TestCase):
    def test_describe_matches_the_port_text(self):
        counts = Counts((1, 2, 3, 4, 5, 6, 7, 8), 9, 10)
        self.assertEqual(
            counts.describe(),
            "assign 1, cue 2, inline 3, float 4, inverse 5, inverse float 6, convert 7, integer 8, anchors 9, windows 10",
        )


class InventoryTest(unittest.TestCase):
    def test_totals(self):
        counts = list(timing.inventory().values())
        self.assertEqual(len(counts), 906)
        self.assertEqual([sum(c.recipes[i] for c in counts) for i in range(8)], [3220, 795, 510, 5, 5, 5, 68, 41])
        self.assertEqual(sum(c.anchors for c in counts), 41)
        self.assertEqual(sum(c.windows for c in counts), 8)

    def test_one_row(self):
        self.assertEqual(timing.inventory()["dungeon/eff_script/b02a_hibasira.stb"], Counts(recipes(integer=1)))


class RecipeTest(unittest.TestCase):
    """Fixtures assembled per recipe; apply is run with the counts the fixture must show."""

    def test_event_assign(self):
        key = "map/s/a01/a01.stb"
        data = assemble({"main": (4, 0, [
            ("LOAD_ADDR", 3, LOCAL), ("LOAD", 3, LOCAL), ("push", 50), ("MUL",),
            ("push", 60), ("DIV",), ("STORE",), ("POP",), ("RET",),
        ])}, "main")
        out = run_plan(key, data, Counts(recipes(assign=1)))
        self.assertEqual([i.op for i in main_insns(out)], [Op.LOAD_ADDR, Op.LOAD, LABEL, LABEL, LABEL, LABEL, Op.STORE, Op.POP, Op.RET])
        self.assertEqual({marker_kind(i) for i in main_insns(out) if i.op == LABEL}, {Recipe.EVENT_ASSIGN})
        self.assertEqual(main_insns(out)[2].a1, timing.MARKER_TAG)
        self.assertEqual(timing.apply(key, out, expected=Counts(recipes(assign=1))), out)

    def test_event_cue(self):
        key = "map/s/a01/a01.stb"
        data = assemble({"main": (4, 0, [
            ("LOAD_ADDR", 3, LOCAL), ("LOAD", 4, LOCAL), ("push", 50), ("MUL",),
            ("push", 60), ("DIV",), ("STORE",), ("POP",), ("RET",),
        ])}, "main")
        out = run_plan(key, data, Counts(recipes(cue=1)))
        self.assertEqual([i.op for i in main_insns(out)], [LABEL] * 8 + [Op.RET])
        self.assertEqual(timing.apply(key, out, expected=Counts(recipes(cue=1))), out)

    def test_assign_and_cue_are_told_apart(self):
        key = "map/s/a01/a01.stb"
        same = assemble({"main": (4, 0, [("LOAD_ADDR", 3, LOCAL), ("LOAD", 3, LOCAL), ("push", 50), ("MUL",), ("push", 60), ("DIV",), ("STORE",), ("POP",), ("RET",)])}, "main")
        other = assemble({"main": (4, 0, [("LOAD_ADDR", 3, LOCAL), ("LOAD", 4, LOCAL), ("push", 50), ("MUL",), ("push", 60), ("DIV",), ("STORE",), ("POP",), ("RET",)])}, "main")
        self.assertEqual(timing.plan(key, same)[1], Counts(recipes(assign=1)))
        self.assertEqual(timing.plan(key, other)[1], Counts(recipes(cue=1)))

    def test_event_inline(self):
        key = "map/s/a01/a01.stb"
        data = assemble({"main": (0, 0, [("push", 50), ("MUL",), ("push", 60), ("DIV",), ("RET",)])}, "main")
        out = run_plan(key, data, Counts(recipes(inline=1)))
        self.assertEqual([i.op for i in main_insns(out)], [LABEL] * 4 + [Op.RET])
        self.assertEqual(timing.apply(key, out, expected=Counts(recipes(inline=1))), out)

    def test_event_inline_float(self):
        key = "map/s/a01/a01.stb"
        data = assemble({"main": (0, 0, [("pushf", 50.0), ("MUL",), ("pushf", 60.0), ("DIV",), ("RET",)])}, "main")
        out = run_plan(key, data, Counts(recipes(float=1)))
        self.assertEqual([i.op for i in main_insns(out)], [LABEL] * 4 + [Op.RET])

    def test_event_inverse(self):
        key = "map/s/a01/a01.stb"
        data = assemble({"main": (0, 0, [("push", 60), ("DIV",), ("push", 50), ("MUL",), ("RET",)])}, "main")
        out = run_plan(key, data, Counts(recipes(inverse=1)))
        self.assertEqual([i.op for i in main_insns(out)], [LABEL] * 4 + [Op.RET])

    def test_event_inverse_float(self):
        key = "map/s/a01/a01.stb"
        data = assemble({"main": (0, 0, [("pushf", 60.0), ("DIV",), ("pushf", 50.0), ("MUL",), ("RET",)])}, "main")
        out = run_plan(key, data, Counts(recipes(inverse_float=1)))
        self.assertEqual([i.op for i in main_insns(out)], [LABEL] * 4 + [Op.RET])

    def test_monster_convert_is_an_exact_eight_instruction_function(self):
        key = "dungeon/monster/m_test.stb"
        convert = [("LOAD", 0, LOCAL), ("ITOF",), ("pushf", 30.0), ("DIV",), ("pushf", 25.0), ("MUL",), ("FTOI",), ("RET",)]
        data = assemble({
            "main": (0, 0, [("push", 3), ("CALL", "convert"), ("POP",), ("RET",)]),
            "convert": (1, 1, convert),
        }, "main")
        out = run_plan(key, data, Counts(recipes(convert=1)))
        program = decode(out)
        callee = program.callee(main_insns(out)[1])
        self.assertEqual([i.op for i in callee.instructions], [Op.LOAD] + [LABEL] * 5 + [Op.FTOI, Op.RET])
        self.assertEqual(timing.apply(key, out, expected=Counts(recipes(convert=1))), out)

        longer = assemble({
            "main": (0, 0, [("push", 3), ("CALL", "convert"), ("POP",), ("RET",)]),
            "convert": (1, 1, [("push", 0)] + convert),
        }, "main")
        self.assertEqual(timing.plan(key, longer)[1], Counts())

        wrong_frame = assemble({
            "main": (0, 0, [("push", 3), ("CALL", "convert"), ("POP",), ("RET",)]),
            "convert": (2, 1, convert),
        }, "main")
        self.assertEqual(timing.plan(key, wrong_frame)[1], Counts())

    def test_integer_literal_form(self):
        key = "dungeon/eff_script/fx.stb"
        data = assemble({"main": (0, 0, [("push", 7), ("push", 30), ("DIV",), ("push", 25), ("MUL",), ("RET",)])}, "main")
        out = run_plan(key, data, Counts(recipes(integer=1)))
        self.assertEqual([i.op for i in main_insns(out)], [Op.PUSH_CONST, LABEL, LABEL, LABEL, LABEL, Op.RET])

    def test_integer_helper_form(self):
        key = "dungeon/monster/m_test.stb"
        helper = [("LOAD_ADDR", 0, LOCAL), ("LOAD", 0, LOCAL), ("push", 30), ("DIV",), ("push", 25), ("MUL",), ("STORE",), ("POP",), ("RET",)]
        data = assemble({
            "main": (0, 0, [("push", 2), ("CALL", "helper"), ("POP",), ("RET",)]),
            "helper": (1, 1, helper),
        }, "main")
        out = run_plan(key, data, Counts(recipes(integer=1)))
        callee = decode(out).callee(main_insns(out)[1])
        self.assertEqual([i.op for i in callee.instructions], [Op.LOAD_ADDR, Op.LOAD] + [LABEL] * 4 + [Op.STORE, Op.POP, Op.RET])

        no_args = assemble({
            "main": (0, 0, [("push", 2), ("CALL", "helper"), ("POP",), ("RET",)]),
            "helper": (1, 0, helper),
        }, "main")
        self.assertEqual(timing.plan(key, no_args)[1], Counts())


class FamilyTest(unittest.TestCase):
    def test_event_recipes_do_not_count_in_monster_scripts(self):
        inline = assemble({"main": (0, 0, [("push", 50), ("MUL",), ("push", 60), ("DIV",), ("RET",)])}, "main")
        self.assertEqual(timing.plan("dungeon/monster/m.stb", inline)[1], Counts())
        self.assertEqual(timing.plan("map/s/a01/a01.stb", inline)[1], Counts(recipes(inline=1)))

    def test_integer_recipe_does_not_count_in_event_scripts(self):
        literal = assemble({"main": (0, 0, [("push", 7), ("push", 30), ("DIV",), ("push", 25), ("MUL",), ("RET",)])}, "main")
        self.assertEqual(timing.plan("map/s/a01/a01.stb", literal)[1], Counts())
        self.assertEqual(timing.plan("dungeon/eff_script/fx.stb", literal)[1], Counts(recipes(integer=1)))

    def test_monster_convert_only_in_monster_scripts(self):
        data = assemble({
            "main": (0, 0, [("push", 3), ("CALL", "convert"), ("POP",), ("RET",)]),
            "convert": (1, 1, [("LOAD", 0, LOCAL), ("ITOF",), ("pushf", 30.0), ("DIV",), ("pushf", 25.0), ("MUL",), ("FTOI",), ("RET",)]),
        }, "main")
        self.assertEqual(timing.plan("map/s/a01/a01.stb", data)[1], Counts())


class AnchorTest(unittest.TestCase):
    def test_language_anchors_and_converted_fallback(self):
        key = "map/s/s03/s03_1.stb"
        pal = assemble({"main": (1, 0, [
            ("pushf", 3.14159265358979), ("pushf", 20.0), ("DIV",), ("pushf", 1.2), ("MUL",),
            ("LOAD", 1, LOCAL), ("push", 33), ("CMP", Compare.LT), ("JMP_FALSE", "done"),
            ("label", "done"), ("RET",),
        ])}, "main")
        self.assertNotEqual(run_plan(key, pal, Counts(anchors=2)), pal)
        out = timing.apply(key, pal, expected=Counts(anchors=2))
        insns = main_insns(out)
        self.assertEqual([insns[i].op for i in (3, 4)], [LABEL, LABEL])
        self.assertEqual(insns[6].op, Op.PUSH_CONST)
        self.assertEqual(insns[6].a2, 40)
        self.assertEqual(timing.apply(key, out, expected=Counts(anchors=2)), out)
        self.assertEqual(timing.plan(key, out)[1], Counts(anchors=2))

    def test_missing_anchor_is_refused(self):
        key = "map/s/s03/s03_2.stb"
        data = assemble({"main": (0, 0, [("push", 1), ("RET",)])}, "main")
        with self.assertRaises(TimingError):
            timing.plan(key, data)


class ApplyTest(unittest.TestCase):
    def test_unknown_key_with_a_match_is_refused(self):
        data = assemble({"main": (0, 0, [("push", 50), ("MUL",), ("push", 60), ("DIV",), ("RET",)])}, "main")
        with self.assertRaises(TimingError) as raised:
            timing.apply("map/s/unknown.stb", data)
        self.assertIn("map/s/unknown.stb", str(raised.exception))

    def test_unknown_key_without_a_match_is_unchanged(self):
        data = assemble({"main": (0, 0, [("push", 1), ("RET",)])}, "main")
        self.assertEqual(timing.apply("map/s/unknown.stb", data), data)

    def test_undecodable_data(self):
        junk = b"not a script at all, just text"
        self.assertEqual(timing.apply("map/s/unknown.stb", junk), junk)
        with self.assertRaises(TimingError):
            timing.apply("map/s/s98/s98_1.stb", junk)

    def test_unknown_marker_is_refused(self):
        marked = assemble({"main": (0, 0, [("push", 1), ("RET",)])}, "main")
        data = bytearray(marked)
        insns_offset = main_insns(marked)[0].offset
        struct.pack_into("<iii", data, insns_offset, Op.LABEL, timing.MARKER_TAG, (99 << 24))
        with self.assertRaises(TimingError):
            timing.plan("map/s/unknown.stb", bytes(data))

    def test_second_pass_writes_nothing(self):
        key = "dungeon/eff_script/fx.stb"
        data = assemble({"main": (0, 0, [("push", 7), ("push", 30), ("DIV",), ("push", 25), ("MUL",), ("RET",)])}, "main")
        once = timing.apply(key, data, expected=Counts(recipes(integer=1)))
        self.assertNotEqual(once, data)
        self.assertEqual(timing.apply(key, once, expected=Counts(recipes(integer=1))), once)


def _data_source():
    return resolve_data(None)


DATA = _data_source()


@unittest.skipUnless(DATA is not None and os.environ.get("DC2_LUAU_CORPUS"), "set DC2_LUAU_CORPUS=1 and provide game data (DC2_DATA or port/run/data.zip)")
class CorpusTest(unittest.TestCase):
    """Reads the published corpus (opt-in via DC2_LUAU_CORPUS, takes about five minutes): every script's plan must show its inventory row, and every script must convert."""

    def test_every_script_matches_its_inventory_row(self):
        inventory = timing.inventory()
        seen = set()
        matched = 0
        failures = []
        for path, data in scripts(DATA):
            key = timing.key(path)
            seen.add(key)
            try:
                _, counts = timing.plan(key, data)
            except TimingError as error:
                if key in inventory or _decodes(data):
                    failures.append(str(error))
                continue
            expected = inventory.get(key, Counts())
            if counts != expected:
                failures.append(f"{key}: found {counts.describe()}; expected {expected.describe()}")
                continue
            matched += 1
            try:
                converted = timing.apply(key, data)
                if timing.apply(key, converted) != converted:
                    failures.append(f"{key}: second conversion changed the script")
            except TimingError as error:
                failures.append(str(error))
        self.assertEqual(failures, [])
        self.assertEqual(sorted(set(inventory) - seen), [], "inventory keys absent from the corpus")
        self.assertGreater(matched, 0)


def _decodes(data):
    try:
        decode(data)
    except DecodeError:
        return False
    return True


if __name__ == "__main__":
    unittest.main()
