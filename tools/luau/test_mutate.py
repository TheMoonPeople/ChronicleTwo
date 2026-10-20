import json
import sys
import unittest
from pathlib import Path
from unittest import mock

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode  # noqa: E402
from stb2luau import harness, mutate, refvm, transpile  # noqa: E402

CATALOG = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
MONSTER = CATALOG["kinds"]["monster"]


def vpush_fixture(value=("push", 1)):
    """Monster program 100 pushes a value (the integer 1) with VPush, reads it back into an integer with VPop and prints it."""
    local = AddrMode.LOCAL
    body = [
        ("push", 37), ("push", 0), value, ("EXT", 3),
        ("push", 38), ("push", 0), ("LOAD_ADDR", 0, local), ("EXT", 3),
        ("LOAD", 0, local), ("PRINT", 1), ("push", 0), ("RET",),
    ]
    return assemble({"main": (0, 0, [("push", 0), ("RET",)]), "p100": (1, 0, body)}, "main", {100: "p100"})


class CallsTest(unittest.TestCase):
    def test_calls_outside_comments_and_strings_with_their_arguments(self):
        text = (
            '-- retail: monster.VPush(1, 2)\n'
            'local s = "monster.VPush(3, 4)"\n'
            'monster.VPush(var1, f(1, { 2, 3 }))\n'
            'monster.Ext(37, 0, 1.0)\n'
        )
        found = mutate.calls(text, "monster", MONSTER)
        self.assertEqual([call.name for call in found], ["VPush", "Ext"])
        self.assertEqual([text[a:b] for a, b in found[0].args], ["var1", "f(1, { 2, 3 })"])
        # VPush's value is tagged and its key an integer; Ext's command number is not mutated, and VPush accepts two
        # arguments, so they are read as VPush reads them, marshalled as an unknown type.
        self.assertEqual((found[0].reads, found[0].integers, found[0].tagged, found[0].variant), ("it", "11", 1, "VPushFloat"))
        self.assertEqual((found[1].reads, found[1].integers), ("xit", "111"))


@unittest.skipUnless(harness.HOST.exists(), "luau-harness is not built")
class SweepTest(unittest.TestCase):
    def test_every_reached_mutation_of_a_tagged_call_is_killed(self):
        report = mutate.sweep("dungeon/monster/sweep.stb", vpush_fixture(), CATALOG, range(4), 2)
        self.assertIsNone(report.error)
        self.assertGreater(report.reached, 0)
        self.assertEqual((report.killed, report.survivors), (report.reached, []))

    def test_nan_payload_and_sign_mutations_are_reached_and_killed(self):
        nan = ("pushf", refvm.bits_to_float(0x7FC00001))
        report = mutate.sweep("dungeon/monster/sweep.stb", vpush_fixture(nan), CATALOG, range(4), 2)
        self.assertIsNone(report.error)
        # The NaN's payload and sign changes, besides inc, which leaves a NaN unchanged and so is not reached.
        self.assertGreaterEqual(report.reached, 2)
        self.assertEqual((report.killed, report.survivors), (report.reached, []))

    def test_a_comparison_blind_to_inputs_leaves_survivors(self):
        # With the inputs unchecked, the mutated VPush still replays VPop's recorded output, so its mutants pass.
        driver = harness.driver
        blind = "local function same_inputs(expected, got, reads, integers)\n    do return expected.n == got.n end"

        def weaker(*args, **kwargs):
            return driver(*args, **kwargs).replace("local function same_inputs(expected, got, reads, integers)", blind)

        with mock.patch.object(harness, "driver", weaker):
            report = mutate.sweep("dungeon/monster/sweep.stb", vpush_fixture(), CATALOG, range(4), 2)
        self.assertIsNone(report.error)
        self.assertTrue(report.survivors, report)


if __name__ == "__main__":
    unittest.main()
