import dataclasses
import json
import math
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode, Compare, Op  # noqa: E402
from stb.program import decode  # noqa: E402
from stb2luau import harness, refvm, transpile  # noqa: E402

REPO = HERE.parents[1]
LOCAL, LOCAL_INDEX = AddrMode.LOCAL, AddrMode.LOCAL_INDEX
LOCAL_FLOAT, POINTER_INDEX = AddrMode.LOCAL_FLOAT, AddrMode.POINTER_INDEX
CATALOG = {
    "namespace": "action",
    "commands": [{"no": 2, "luau": "ProgGet", "signatures": [{"argc": 1, "params": [{"name": "prog", "dir": "out", "type": "s32"}]}]}],
}
GOOD_MODULE = """local vm = require("@lib/vm")
local function p100()
    local x = 0
    x = action.ProgGet() or x
    vm.wait()
    print(x)
    return x
end
local script = {}
script.setup = function() end
script[100] = p100
return script
"""
WRONG_MODULE = GOOD_MODULE.replace("print(x)", "print(x + 1)")
STATE_CATALOG = {
    "namespace": "action",
    "commands": [
        {"no": 1, "luau": "ProgSet", "signatures": [{"argc": 1, "params": [{"name": "prog", "dir": "in", "type": "s32"}]}]},
        CATALOG["commands"][0],
    ],
}


def fixture():
    """Program 100 calls command 2 with a local out, waits, prints the local and returns it."""
    body = [
        ("push", 2),
        ("LOAD_ADDR", 0, LOCAL),
        ("EXT", 2),
        ("WAIT",),
        ("LOAD", 0, LOCAL),
        ("PRINT", 1),
        ("LOAD", 0, LOCAL),
        ("RET",),
    ]
    return decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))


def compare_fixture():
    """Program 101 writes a local through command 2, prints "hit" only when it equals 176, and returns 0."""
    body = [
        ("push", 2),
        ("LOAD_ADDR", 0, LOCAL),
        ("EXT", 2),
        ("LOAD", 0, LOCAL),
        ("push", 176),
        ("CMP", int(Compare.EQ)),
        ("JMP_FALSE", "skip"),
        ("pushs", b"hit"),
        ("PRINT", 1),
        ("label", "skip"),
        ("push", 0),
        ("RET",),
    ]
    return decode(assemble({"main": (0, 0, [("END",)]), "p101": (1, 0, body)}, "main", {101: "p101"}))


def set_then_get_fixture():
    """Program 100 sets 42 through command 1, reads it back through command 2 into a local, prints it and returns 0."""
    body = [
        ("push", 1),
        ("push", 42),
        ("EXT", 2),
        ("push", 2),
        ("LOAD_ADDR", 0, LOCAL),
        ("EXT", 2),
        ("LOAD", 0, LOCAL),
        ("PRINT", 1),
        ("push", 0),
        ("RET",),
    ]
    return decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))


MONSTER_CATALOG = {
    "namespace": "monster",
    "commands": [
        {"no": 35, "luau": "GetRnd", "signatures": [{"argc": 2, "params": [
            {"name": "range", "dir": "in", "type": "s32"}, {"name": "argc", "dir": "out", "type": "s32"}]}]},
        {"no": 37, "luau": "VPush", "signatures": [{"argc": 2, "params": [
            {"name": "index", "dir": "in", "type": "s32"}, {"name": "value", "dir": "in", "type": "s32"}]}]},
        {"no": 38, "luau": "VPop", "signatures": [{"argc": 2, "params": [
            {"name": "index", "dir": "in", "type": "s32"}, {"name": "out2", "dir": "out", "type": "s32"}]}]},
    ],
}
# Program 100 calls bump(&x) twice, printing x after each; bump adds one to the variable its reference names.
REFERENCE_FUNCTIONS = {
    "main": (0, 0, [("END",)]),
    "p100": (1, 0, [
        ("LOAD_ADDR", 0, LOCAL), ("CALL", "bump"), ("POP",), ("LOAD", 0, LOCAL), ("PRINT", 1),
        ("LOAD_ADDR", 0, LOCAL), ("CALL", "bump"), ("POP",), ("LOAD", 0, LOCAL), ("PRINT", 1),
        ("push", 0), ("RET",),
    ]),
    "bump": (1, 1, [
        ("push", 0), ("LOAD_ADDR", 0, POINTER_INDEX), ("push", 0), ("LOAD", 0, POINTER_INDEX), ("push", 1), ("ADD",),
        ("STORE",), ("POP",), ("push", 0), ("RET",),
    ]),
}
REFERENCE_MODULE = """local function bump(arg0)
    arg0 = arg0 + 1
    return arg0
end
local script = {}
script.setup = function() end
script[100] = function()
    local x = 0
    x = bump(x)
    __ref(CALL1, x)
    print(x)
    x = bump(x)
    __ref(CALL2, x)
    print(x)
end
return script
"""


def reference_fixture():
    """Program 100 of REFERENCE_FUNCTIONS, with the offsets of its two CALL instructions."""
    program = decode(assemble(REFERENCE_FUNCTIONS, "main", {100: "p100"}))
    p100 = next(block for number, block in program.programs if number == 100)
    calls = [i.offset for i in program.functions[p100].instructions if i.op == Op.CALL]
    return program, calls


def past_frame_fixture():
    """Program 100 prints "a", stores 5 two slots past its one-slot frame, prints "b" and returns 0.

    Retail writes the operand stack there and goes on; the translation raises an error, as b02a1.stb's function 0x1a80
    does when a native output sends its index past the frame.
    """
    body = [
        ("pushs", b"a"), ("PRINT", 1),
        ("push", 2), ("LOAD_ADDR", 0, LOCAL_INDEX), ("push", 5), ("STORE",), ("POP",),
        ("pushs", b"b"), ("PRINT", 1),
        ("push", 0), ("RET",),
    ]
    return decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))


PAST_FRAME_MODULE = """local script = {}
script.setup = function() end
script[100] = function()
    print("a")
    error("slot index 2 is outside the frame of 1 slots")
end
return script
"""


PAST_FRAME_ERROR = '    error("slot index 2 is outside the frame of 1 slots")\n'
# A module whose program 100 runs the given statements.
PROGRAM_100 = """local script = {{}}
script.setup = function() end
script[100] = function()
    {body}
end
return script
"""


def endless_fixture():
    """Program 100 calls command 2 in a loop that never ends."""
    body = [("label", "top"), ("push", 2), ("LOAD_ADDR", 0, LOCAL), ("EXT", 2), ("JMP", "top"), ("push", 0), ("RET",)]
    return decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))


ENDLESS_MODULE = """local script = {}
script.setup = function() end
script[100] = function()
    local x = 0
    while true do
        x = action.ProgGet() or x
    end
end
return script
"""


def nested_fixture():
    """Program 100 calls f, which calls g, which calls h: three calls deep."""
    return decode(assemble({
        "main": (0, 0, [("END",)]),
        "p100": (0, 0, [("CALL", "f"), ("RET",)]),
        "f": (0, 0, [("CALL", "g"), ("RET",)]),
        "g": (0, 0, [("CALL", "h"), ("RET",)]),
        "h": (0, 0, [("push", 0), ("RET",)]),
    }, "main", {100: "p100"}))


def float_fixture():
    """Main pushes the float 4.5 and ends."""
    return decode(assemble({"main": (0, 0, [("pushf", 4.5), ("POP",), ("END",)])}, "main"))


class RecordTest(unittest.TestCase):
    def test_record_traces_ext_wait_print_and_end(self):
        program = fixture()
        for seed in range(64):
            scenario = harness.record(program, CATALOG, [100], seed, f"100/s{seed}")
            value = scenario.events[0][4][0]
            if value is not None:
                break
        else:
            self.fail("no seed wrote the out value")
        self.assertIsNone(scenario.cut)
        self.assertEqual(scenario.compared, scenario.covered)
        self.assertEqual(scenario.globals, [])
        self.assertEqual(
            scenario.events,
            [("ext", 2, 1, (), (value,)), ("wait",), ("print", (value,)), ("end", value)],
        )

    def test_pushed_constants_are_output_candidates(self):
        self.assertIn(176, harness.value_pools(compare_fixture()).ints)
        self.assertIn(4.5, harness.value_pools(float_fixture()).floats)

    def test_compared_constant_takes_branch_for_some_seed(self):
        program = compare_fixture()
        runs = [harness.record(program, CATALOG, [101], seed, f"101/s{seed}") for seed in range(64)]
        taken = [run for run in runs if ("print", ("hit",)) in run.events]
        self.assertTrue(taken, "no seed wrote the compared value")
        self.assertLess(len(taken), len(runs))

    def test_handler_rejected_command_is_recorded_without_writes(self):
        catalog = {
            "namespace": "action",
            "commands": [
                {
                    "no": 2,
                    "luau": "ProgGet",
                    "signatures": [{"argc": 1, "handler_rejects": True, "params": [{"name": "prog", "dir": "out", "type": "s32"}]}],
                }
            ],
        }
        scenario = harness.record(fixture(), catalog, [100], 0, "100/s0")
        self.assertEqual(scenario.events, [("ext", 2, 1, (0,), ()), ("wait",), ("print", (0,)), ("end", 0)])

    def test_kind_mismatched_command_is_recorded_without_writes(self):
        catalog = {
            "namespace": "action",
            "commands": [
                {
                    "no": 30,
                    "luau": "SetPallet",
                    "signatures": [
                        {
                            "argc": 2,
                            "params": [
                                {"name": "arg1", "dir": "in", "type": "string"},
                                {"name": "out2", "dir": "out", "type": "s32"},
                            ],
                        }
                    ],
                }
            ],
        }
        body = [("push", 30), ("push", 1), ("LOAD_ADDR", 0, LOCAL), ("EXT", 3), ("push", 0), ("RET",)]
        program = decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))
        for seed in range(4):
            scenario = harness.record(program, catalog, [100], seed, f"100/s{seed}")
            self.assertEqual(scenario.events, [("ext", 30, 2, (1, 0), ()), ("end", 0)])

    def test_get_mostly_returns_the_value_last_set(self):
        program = set_then_get_fixture()
        runs = [harness.record(program, STATE_CATALOG, [100], seed, f"100/s{seed}", namespace="action") for seed in range(64)]
        for run in runs:
            self.assertEqual(run.events[0], ("ext", 1, 1, (42,), ()))
        read_back = [run.events[1][4][0] for run in runs]
        self.assertGreater(sum(value == 42 for value in read_back), 32, read_back)

    def test_state_is_not_shared_without_a_namespace(self):
        program = set_then_get_fixture()
        runs = [harness.record(program, STATE_CATALOG, [100], seed, f"100/s{seed}") for seed in range(64)]
        self.assertLess(sum(run.events[1][4][0] == 42 for run in runs), 48)

    def test_outputs_are_often_zero(self):
        program = set_then_get_fixture()
        runs = [harness.record(program, STATE_CATALOG, [100], seed, f"100/s{seed}") for seed in range(64)]
        read_back = [run.events[1][4][0] for run in runs]
        self.assertGreater(sum(value == 0 for value in read_back), 16, read_back)

    def test_keyed_state_reads_back_the_value_stored_under_its_key(self):
        body = [
            ("push", 37), ("push", 5), ("push", 42), ("EXT", 3),
            ("push", 37), ("push", 6), ("push", 7), ("EXT", 3),
            ("push", 38), ("push", 5), ("LOAD_ADDR", 0, LOCAL), ("EXT", 3),
            ("push", 0), ("RET",),
        ]
        program = decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))
        runs = [harness.record(program, MONSTER_CATALOG, [100], seed, f"100/s{seed}", namespace="monster") for seed in range(64)]
        read_back = [run.events[2][4][0] for run in runs]
        self.assertGreater(sum(value == 42 for value in read_back), 32, read_back)

    def test_random_command_stays_inside_its_range(self):
        body = [("push", 35), ("push", 8), ("LOAD_ADDR", 0, LOCAL), ("EXT", 3), ("push", 0), ("RET",)]
        program = decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))
        runs = [harness.record(program, MONSTER_CATALOG, [100], seed, f"100/s{seed}", namespace="monster") for seed in range(64)]
        values = {run.events[0][4][0] for run in runs}
        self.assertTrue(values <= set(range(8)), values)
        self.assertGreater(len(values), 2)

    def test_tagged_call_records_the_tag_its_handler_reads(self):
        tagged = {
            "namespace": "monster",
            "commands": [
                {"no": 37, "luau": "VPush", "signatures": [{"argc": 2, "params": [
                    {"name": "index", "dir": "in", "type": "s32"},
                    {"name": "value", "dir": "in", "type": "s32", "tagged": True}]}]},
            ],
        }
        body = [
            ("push", 37), ("push", 1), ("pushf", 2.5), ("EXT", 3),
            ("push", 37), ("push", 2), ("push", 3), ("EXT", 3),
            ("push", 37), ("push", 3), ("LOAD_ADDR", 0, LOCAL), ("EXT", 3),
            ("push", 0), ("RET",),
        ]
        program = decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))
        scenario = harness.record(program, tagged, [100], 0, "100/s0", namespace="monster")
        # The reference makes the handler store nothing, so that call leaves no event.
        self.assertEqual(
            [event for event in scenario.events if event[0] == "ext"],
            [("ext", 37, 2, (1, 2.5), (), "f32"), ("ext", 37, 2, (2, 3), (), "s32")],
        )

    def test_output_takes_the_handlers_type_and_loads_read_its_bits(self):
        # ProgGet writes an integer; the script loads the variable as a float, which reads the integer's bits.
        body = [("push", 2), ("LOAD_ADDR", 0, LOCAL_FLOAT), ("EXT", 2), ("LOAD", 0, LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",)]
        program = decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))
        ext = next(i.offset for i in program.functions[max(program.functions)].instructions if i.op == Op.EXT)
        views = harness.FloatViews({ext: (True,)}, frozenset())
        for seed in range(16):
            scenario = harness.record(program, CATALOG, [100], seed, f"100/s{seed}", views=views)
            value = scenario.events[0][4][0]
            if value is not None:
                self.assertIsInstance(value, int)
                self.assertEqual(scenario.events[1], ("print", (refvm.bits_to_float(value),)))

    def test_probed_call_records_the_referenced_values(self):
        program, calls = reference_fixture()
        scenario = harness.record(program, CATALOG, [100], 0, "100/s0", probes=frozenset(calls[:1]))
        self.assertEqual(scenario.events, [("ref", calls[0], (1,)), ("print", (1,)), ("print", (2,)), ("end", 0)])

    def test_folded_float_operation_is_the_float32_result(self):
        body = [("pushf", 3.1415927), ("pushf", 2.0), ("DIV",), ("PRINT", 1), ("push", 0), ("RET",)]
        program = decode(assemble({"main": (0, 0, [("END",)]), "p100": (0, 0, body)}, "main", {100: "p100"}))
        divide = next(i.offset for i in program.functions[max(program.functions)].instructions if i.op == Op.DIV)
        exact = harness.record(program, CATALOG, [100], 0, "100/s0").events[0][1][0]
        folded = harness.record(program, CATALOG, [100], 0, "100/s0", folded=frozenset({divide})).events[0][1][0]
        self.assertEqual(folded, refvm.f32(refvm.f32(3.1415927) / 2.0))
        self.assertEqual(folded, exact)

    def test_store_past_the_frame_cuts_the_trace_where_retail_goes_on(self):
        program = past_frame_fixture()
        scenario = harness.record(program, CATALOG, [100], 0, "100/s0")
        store = next(i.offset for i in program.functions[max(program.functions)].instructions if i.op == Op.STORE)
        self.assertEqual(scenario.cut, f"store past the frame at {store:#x}")
        self.assertTrue(scenario.unsupported)
        self.assertEqual(scenario.events, [("print", ("a",)), ("cut", "frame")])
        # The reference run went on to print "b", but only what ran before the first print was compared.
        printed = [i.offset for i in program.functions[max(program.functions)].instructions if i.op == Op.PRINT]
        self.assertIn(printed[1], scenario.covered)
        self.assertNotIn(printed[1], scenario.compared)
        self.assertIn(printed[0], scenario.compared)
        self.assertLess(harness.coverage(program, [scenario], compared=True), harness.coverage(program, [scenario]))

    def test_step_budget_cuts_the_trace_after_its_events(self):
        with mock.patch.object(harness, "MAX_STEPS", 200):
            scenario = harness.record(endless_fixture(), CATALOG, [100], 0, "100/s0")
        self.assertEqual(scenario.cut, harness.BUDGET)
        self.assertFalse(scenario.unsupported)
        self.assertEqual(scenario.events[-1], ("cut", "budget"))
        self.assertGreater(len(scenario.events), 10)
        self.assertTrue(all(event[0] == "ext" for event in scenario.events[:-1]))

    def test_effect_scripts_get_retails_call_depth_of_two(self):
        effect = {"namespace": "effect", "commands": []}
        self.assertEqual(harness.record(nested_fixture(), effect, [100], 0, "100/s0", namespace="effect").events, [("error",)])
        self.assertEqual(harness.record(nested_fixture(), CATALOG, [100], 0, "100/s0").events, [("end", 0)])

    def test_scenarios_run_each_program_twice_in_one_instance(self):
        recorded = harness.scenarios(fixture(), CATALOG, range(2))
        names = {scenario.name: scenario for scenario in recorded}
        self.assertIn("100x2/s0", names)
        self.assertIn("100x2/s1", names)
        twice = names["100x2/s0"]
        self.assertEqual(twice.programs, [100, 100])
        self.assertEqual([event[0] for event in twice.events].count("end"), 2)
        self.assertEqual([event[0] for event in twice.events].count("ext"), 2)

    def test_straight_line_program_is_fully_covered(self):
        program = fixture()
        self.assertEqual(harness.coverage(program, harness.scenarios(program, CATALOG, range(1))), 1.0)

    def test_unrun_branch_leaves_coverage_partial(self):
        program = compare_fixture()
        runs = [harness.record(program, CATALOG, [101], seed, f"101/s{seed}") for seed in range(64)]
        not_taken = next(run for run in runs if ("print", ("hit",)) not in run.events)
        self.assertLess(harness.coverage(program, [not_taken]), 1.0)
        self.assertEqual(harness.coverage(program, harness.scenarios(program, CATALOG, range(64))), 1.0)


@unittest.skipUnless(harness.HOST.exists(), "luau-harness is not built")
class DifferentialTest(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = Path(directory.name)
        (self.root / "lib").mkdir()
        shutil.copyfile(REPO / "port/src/luau/lib/vm.luau", self.root / "lib" / "vm.luau")

    def write_module(self, source):
        (self.root / "prog.luau").write_text(source, encoding="utf-8")

    def test_matching_module_passes_every_scenario(self):
        self.write_module(GOOD_MODULE)
        result = harness.run(self.root, "prog", fixture(), CATALOG, "action", seeds=range(4))
        self.assertEqual(result["returncode"], 0, result["stderr"])
        self.assertEqual(result["fail"], [])
        self.assertEqual(result["prefix"], [])
        self.assertEqual(result["unsupported"], [])
        self.assertEqual(result["pass"], 4 * 4)
        self.assertEqual(result["coverage"], 1.0)
        self.assertEqual(result["compared"], 1.0)

    def tagged_output_fixture(self, command, store):
        """Program 100 gives local 0 a float or an integer tag, has the command write it, and prints it as a float."""
        body = [
            ("LOAD_ADDR", 0, LOCAL), store, ("STORE",), ("POP",),
            ("push", command), ("LOAD_ADDR", 0, LOCAL), ("EXT", 2),
            ("LOAD", 0, LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",),
        ]
        return decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, body)}, "main", {100: "p100"}))

    TAGGED_CATALOG = {
        "namespace": "action",
        "commands": [
            {"no": 163, "luau": "GetLife", "signatures": [{"argc": 1, "params": [
                {"name": "life", "dir": "out", "type": "f32", "tagged": True}]}]},
            {"no": 38, "luau": "VPop", "signatures": [{"argc": 1, "params": [
                {"name": "value", "dir": "out", "type": "s32", "tagged": True, "copies": True}]}]},
        ],
    }

    def tagged_module(self, call):
        return (
            'local script = {}\nscript.setup = function() end\n'
            f'script[100] = function()\n    local x = 0.5\n    x = {call} or x\n    print(x)\n    return 0\nend\n'
            'return script\n'
        )

    def test_wrong_variant_of_a_tag_branching_output_fails(self):
        # The destination holds a float tag, so the handler writes the fraction; the Int variant asks for the life.
        program = self.tagged_output_fixture(163, ("pushf", 0.5))
        self.write_module(self.tagged_module("action.GetLife()"))
        good = harness.run(self.root, "prog", program, self.TAGGED_CATALOG, "action", seeds=range(4))
        self.assertEqual(good["fail"], [], good)
        self.write_module(self.tagged_module("action.GetLifeInt()"))
        bad = harness.run(self.root, "prog", program, self.TAGGED_CATALOG, "action", seeds=range(4))
        self.assertTrue(any("the handler read f32, the call passes s32" in line for line in bad["fail"]), bad)

    def test_wrong_variant_of_a_bit_copying_output_fails(self):
        # VPop copies the stored bits; the script reads them as a float, which the Int variant reads as an integer.
        program = self.tagged_output_fixture(38, ("pushf", 0.5))
        self.write_module(self.tagged_module("action.VPopFloat()"))
        good = harness.run(self.root, "prog", program, self.TAGGED_CATALOG, "action", seeds=range(8))
        self.assertEqual(good["fail"], [], good)
        self.write_module(self.tagged_module("action.VPopInt()"))
        bad = harness.run(self.root, "prog", program, self.TAGGED_CATALOG, "action", seeds=range(8))
        self.assertTrue(bad["fail"], bad)

    PUT_CATALOG = {
        "namespace": "action",
        "commands": [{"no": 1, "luau": "Put", "signatures": [{"argc": 1, "params": [{"name": "x", "dir": "in", "type": "f32"}]}]}],
    }

    def native_float_input(self, body, expressions):
        """Runs program 100 (body, then EXT 1 with one float) against a module passing each expression to Put."""
        program = decode(assemble(
            {"main": (0, 0, [("END",)]), "p100": (0, 0, [("push", 1), *body, ("EXT", 2), ("push", 0), ("RET",)])},
            "main", {100: "p100"},
        ))
        results = []
        for expression in expressions:
            self.write_module('local vm = require("@lib/vm")\n' + PROGRAM_100.format(body=f"action.Put({expression})"))
            results.append(harness.run(self.root, "prog", program, self.PUT_CATALOG, "action", seeds=range(4)))
        return results

    def test_a_sine_off_by_one_ulp_fails(self):
        # With the Windows UCRT, sinf of float32(0.779) and the double sine rounded to float32 differ in the last bit; a
        # C library whose sinf rounds correctly gives the same value, so there the mutant is the next float32 instead.
        x = refvm.f32(0.779)
        right = refvm.sinf(x)
        if refvm.f32(math.sin(x)) != right:
            wrong = "vm.f32(math.sin(vm.f32(0.779)))"
        else:
            wrong = repr(refvm.bits_to_float(refvm.float_bits(right) + 1))
        good, bad = self.native_float_input([("pushf", 0.779), ("SIN",)], ["vm.sin(vm.f32(0.779))", wrong])
        self.assertEqual(good["fail"], [], good)
        self.assertEqual(good["pass"], 4 * 4)
        self.assertTrue(any("event 1" in line for line in bad["fail"]), (wrong, bad))

    def test_a_float_zero_of_the_other_sign_fails(self):
        # The handler receives -0.0's bits, 0x80000000, which differ from 0.0's; integer zeros have no sign in Luau.
        good, bad = self.native_float_input([("pushf", 0.0)], ["0.0", "-0.0"])
        self.assertEqual(good["fail"], [], good)
        self.assertTrue(bad["fail"], bad)

    def monster_mutation(self, locals_, body, call, wrong_call):
        """Transpiles monster program 100 with the real catalogue; runs the module and the one with call replaced."""
        catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
        data = assemble({"main": (0, 0, [("push", 0), ("RET",)]), "p100": (locals_, 0, body)}, "main", {100: "p100"})
        path = "dungeon/monster/zero.stb"
        lifted, module = transpile.transpile(path, data)
        self.assertIsNotNone(module, lifted.error)
        module = dataclasses.replace(module, expose_globals=True, probe_refs=True)
        emitted = transpile.emit_corpus([(lifted, module)], catalog).modules[path]
        self.assertIn(call, emitted.text)
        kind = catalog["kinds"]["monster"]
        good, bad = (
            transpile._harness_job((lifted, dataclasses.replace(emitted, text=text), kind, range(4), transpile.OUTPUT))
            for text in (emitted.text, emitted.text.replace(call, wrong_call))
        )
        self.assertEqual((good.passed, good.failed), (16, 0), good.lines)
        self.assertGreater(bad.failed, 0, bad.lines)

    def test_a_signed_zero_stored_and_read_back_as_an_integer_fails(self):
        # Monster VPush stores a float's bits and VPop copies them into an integer variable: 0.0 reads back as 0 and
        # -0.0 as -2147483648, so a module that pushes the other zero is a wrong translation.
        body = [
            ("push", 37), ("push", 0), ("pushf", 0.0), ("EXT", 3),
            ("push", 38), ("push", 0), ("LOAD_ADDR", 0, LOCAL), ("EXT", 3),
            ("LOAD", 0, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
        ]
        self.monster_mutation(1, body, "monster.VPushFloat(0, 0.0)", "monster.VPushFloat(0, -0.0)")

    def test_a_negative_zero_passed_for_an_integer_zero_to_a_float_parameter_fails(self):
        # Retail pushes the integer 0 to CopyVector, whose handler reads it as the float +0.0 and copies its bits into
        # the integer output, which reads 0. The runtime passes -0.0 to the float parameter as is, and the output then
        # reads -2147483648, although the trace marks the input as an integer.
        body = [
            ("push", 1), ("LOAD_ADDR", 0, LOCAL), ("LOAD_ADDR", 1, LOCAL), ("LOAD_ADDR", 2, LOCAL),
            ("push", 0), ("push", 0), ("push", 0), ("EXT", 7),
            ("LOAD", 0, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
        ]
        self.monster_mutation(3, body, "monster.CopyVector(0, 0, 0)", "monster.CopyVector(-0.0, 0, 0)")

    VPUSH_BODY = [
        ("push", 37), ("push", 0), "value", ("EXT", 3),
        ("push", 38), ("push", 0), ("LOAD_ADDR", 0, LOCAL), ("EXT", 3),
        ("LOAD", 0, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
    ]

    def test_an_integer_passed_as_a_float_slot_to_a_tagged_handler_fails(self):
        # Retail pushes INT 1, which VPush stores as is. 1.00000001 does not fit an integer, so the runtime passes FLOAT
        # 1.0, which VPush stores as the bits 1065353216: the same float32, but another slot.
        body = [("push", 1) if step == "value" else step for step in self.VPUSH_BODY]
        self.monster_mutation(1, body, "monster.VPush(0, 1)", "monster.VPush(0, 1.00000001)")

    def test_an_ext_call_that_changes_a_tagged_handlers_slot_fails(self):
        # Ext marshals 1.0 as an unknown type, so as INT 1, where retail and VPushFloat pass FLOAT 1.0.
        body = [("pushf", 1.0) if step == "value" else step for step in self.VPUSH_BODY]
        self.monster_mutation(1, body, "monster.VPushFloat(0, 1.0)", "monster.Ext(37, 0, 1.0)")

    def test_a_nan_of_another_payload_or_sign_stored_by_a_tagged_handler_fails(self):
        # VPush stores the FLOAT's bits and VPop reads them into an integer: 0x7fc00001 reads back as 2143289345, and
        # the NaNs 0x7fc00002 and 0xffc00001 as 2143289346 and -4194303.
        nan = refvm.bits_to_float(0x7FC00001)
        body = [("pushf", nan) if step == "value" else step for step in self.VPUSH_BODY]
        right = 'monster.VPushFloat(0, (string.unpack("<f", string.pack("<I4", 0x7fc00001))))'
        for wrong in ("0x7fc00002", "0xffc00001"):
            with self.subTest(wrong=wrong):
                self.monster_mutation(1, body, right, right.replace("0x7fc00001", wrong))

    def test_host_trig_is_the_reference_machines(self):
        # The host's cmath.sinf and cmath.cosf, which vm.sin and vm.cos call, give the reference machine's float32 bits.
        values = [refvm.f32(x / 64.0) for x in range(-2000, 2001, 7)] + [refvm.f32(x) for x in (1e5, -3e6, 1e-30, 0.779)]
        driver = self.root / "trig.luau"
        driver.write_text(
            "for _, x in { " + ", ".join(repr(value) for value in values) + " } do\n"
            '    print((string.unpack("<I4", string.pack("<f", cmath.sinf(x)))), '
            '(string.unpack("<I4", string.pack("<f", cmath.cosf(x)))))\n'
            "end\n",
            encoding="utf-8",
        )
        completed = subprocess.run([str(harness.HOST), str(self.root), str(driver)], capture_output=True, text=True, check=True)
        bits = lambda value: struct.unpack("<I", struct.pack("<f", value))[0]  # noqa: E731
        expected = [f"{bits(refvm.sinf(x))}\t{bits(refvm.cosf(x))}" for x in values]
        self.assertEqual(completed.stdout.splitlines(), expected)

    def test_a_float_input_one_ulp_off_fails(self):
        good, rounded, bad = self.native_float_input([("pushf", 0.5)], ["0.5", "0.50000000001", "0.5000000596046448"])
        self.assertEqual(good["fail"], [], good)
        # The handler receives a float32, so a double that rounds to the same float32 is the same argument.
        self.assertEqual(rounded["fail"], [], rounded)
        self.assertTrue(bad["fail"], bad)

    def test_integers_compare_exactly(self):
        self.write_module(GOOD_MODULE.replace("print(x)", "print(x + 0.0000001)"))
        result = harness.run(self.root, "prog", fixture(), CATALOG, "action", seeds=range(4))
        self.assertEqual(result["returncode"], 0, result["stderr"])
        failed = [line for line in result["fail"] if "print" in line]
        self.assertTrue(failed, result)

    def test_unsupported_scenario_compares_its_prefix(self):
        self.write_module(PAST_FRAME_MODULE)
        result = harness.run(self.root, "prog", past_frame_fixture(), CATALOG, "action", seeds=range(1))
        self.assertEqual(result["returncode"], 0, result["stderr"])
        self.assertEqual(result["fail"], [])
        self.assertEqual(len(result["unsupported"]), 3, result)
        self.assertTrue(all(scenario.cut.startswith("store past the frame") for scenario in result["unsupported"]))
        self.assertLess(result["compared"], result["coverage"])

    def test_unsupported_scenario_fails_when_the_module_returns_instead(self):
        self.write_module(PAST_FRAME_MODULE.replace(PAST_FRAME_ERROR, ""))
        result = harness.run(self.root, "prog", past_frame_fixture(), CATALOG, "action", seeds=range(1))
        self.assertEqual(result["unsupported"], [])
        self.assertTrue(any("FAIL 100/s0" in line and "cut" in line for line in result["fail"]), result)

    def test_unsupported_scenario_fails_on_an_unrelated_error(self):
        self.write_module(PAST_FRAME_MODULE.replace("slot index 2 is outside the frame of 1 slots", "attempt to index nil"))
        result = harness.run(self.root, "prog", past_frame_fixture(), CATALOG, "action", seeds=range(1))
        self.assertEqual(result["unsupported"], [])
        self.assertTrue(any("FAIL 100/s0" in line for line in result["fail"]), result)

    def replay(self, module, events):
        """Replays one hand-written trace of program 100 against a module; returns the host's output lines."""
        self.write_module(module)
        scenario = harness.Scenario("100/s0", [100], 0, events, [])
        driver = self.root / "driver.luau"
        driver.write_text(harness.driver("prog", "action", CATALOG, [scenario], {}), encoding="utf-8")
        completed = subprocess.run([str(harness.HOST), str(self.root), str(driver)], capture_output=True, text=True, check=False)
        return completed.stdout.splitlines()

    def test_budget_cut_counts_as_a_prefix_whatever_the_module_does_next(self):
        # Program 100 prints "a", counts to 50 and prints "b"; a budget of 400 steps cuts it after "a". The module that
        # then prints "wrong" and the one that returns at once are not passed: they count as compared prefixes, as the
        # right module does, since nothing after the cut is checked.
        count = [
            ("pushs", b"a"), ("PRINT", 1),
            ("label", "top"),
            ("LOAD", 0, LOCAL), ("push", 50), ("CMP", Compare.LT), ("JMP_FALSE", "done"),
            ("LOAD_ADDR", 0, LOCAL), ("LOAD", 0, LOCAL), ("push", 1), ("ADD",), ("STORE",), ("POP",),
            ("JMP", "top"),
            ("label", "done"),
            ("pushs", b"b"), ("PRINT", 1), ("push", 0), ("RET",),
        ]
        program = decode(assemble({"main": (0, 0, [("END",)]), "p100": (1, 0, count)}, "main", {100: "p100"}))
        for body in ('print("a") print("wrong")', 'print("a") return 0', 'print("a") print("b")'):
            self.write_module(PROGRAM_100.format(body=body))
            with mock.patch.object(harness, "MAX_STEPS", 400):
                result = harness.run(self.root, "prog", program, CATALOG, "action", seeds=range(1))
            self.assertEqual(result["fail"], [], body)
            self.assertEqual(result["pass"], 1, body)  # main/s0, which never runs program 100
            self.assertEqual(sorted(scenario.name for scenario in result["prefix"]), ["100/s0", "100x2/s0", "all/s0"])

    def test_infinity_matches_only_the_same_infinity(self):
        program = decode(assemble(
            {"main": (0, 0, [("END",)]), "p100": (0, 0, [("pushf", math.inf), ("PRINT", 1), ("push", 0), ("RET",)])},
            "main", {100: "p100"},
        ))
        events = harness.record(program, CATALOG, [100], 0, "100/s0").events
        self.assertEqual(events, [("print", (math.inf,)), ("end", 0)])
        self.assertEqual(self.replay(PROGRAM_100.format(body="print(math.huge)"), events), ["PASS 100/s0"])
        for wrong in ("print(0)", "print(-math.huge)", "print(0 / 0)", "print(1e300)"):
            lines = self.replay(PROGRAM_100.format(body=wrong), events)
            self.assertTrue(lines and lines[0].startswith("FAIL 100/s0"), (wrong, lines))

    def test_nan_matches_only_nan(self):
        events = [("print", (math.nan,)), ("end", 0)]
        self.assertEqual(self.replay(PROGRAM_100.format(body="print(0 / 0)"), events), ["PASS 100/s0"])
        lines = self.replay(PROGRAM_100.format(body="print(0)"), events)
        self.assertTrue(lines and lines[0].startswith("FAIL 100/s0"), lines)
        lines = self.replay(PROGRAM_100.format(body="print(0 / 0)"), [("print", (0.0,)), ("end", 0)])
        self.assertTrue(lines and lines[0].startswith("FAIL 100/s0"), lines)

    def test_unsupported_scenario_fails_when_its_prefix_differs(self):
        self.write_module(PAST_FRAME_MODULE.replace('print("a")', 'print("c")'))
        result = harness.run(self.root, "prog", past_frame_fixture(), CATALOG, "action", seeds=range(1))
        self.assertEqual(result["unsupported"], [])
        self.assertTrue(any("FAIL 100/s0" in line for line in result["fail"]), result)

    def test_step_budget_scenario_compares_its_prefix(self):
        self.write_module(ENDLESS_MODULE)
        with mock.patch.object(harness, "MAX_STEPS", 2000):
            result = harness.run(self.root, "prog", endless_fixture(), CATALOG, "action", seeds=range(1))
        self.assertEqual(result["returncode"], 0, result["stderr"])
        self.assertEqual(result["fail"], [])
        self.assertTrue(result["prefix"], result)
        self.assertTrue(all(scenario.cut == harness.BUDGET for scenario in result["prefix"]))

    def test_step_budget_scenario_fails_when_its_prefix_differs(self):
        self.write_module(ENDLESS_MODULE.replace("        x = action.ProgGet() or x\n", "        x = action.ProgGet() or x\n        print(x)\n"))
        with mock.patch.object(harness, "MAX_STEPS", 2000):
            result = harness.run(self.root, "prog", endless_fixture(), CATALOG, "action", seeds=range(1))
        self.assertEqual(result["prefix"], [])
        self.assertTrue(result["fail"], result)

    def test_wrong_module_fails_scenarios_with_prints(self):
        self.write_module(WRONG_MODULE)
        result = harness.run(self.root, "prog", fixture(), CATALOG, "action", seeds=range(4))
        self.assertEqual(result["returncode"], 0, result["stderr"])
        failed = [line for line in result["fail"] if line.startswith("FAIL 100/s")]
        self.assertEqual(len(failed), 4, result["fail"])
        self.assertEqual(result["pass"], 4)

    def test_module_that_copies_references_back_passes(self):
        program, calls = reference_fixture()
        source = REFERENCE_MODULE.replace("CALL1", str(calls[0])).replace("CALL2", str(calls[1]))
        self.write_module(source)
        result = harness.run(self.root, "prog", program, CATALOG, "action", seeds=range(2), probes=frozenset(calls))
        self.assertEqual(result["returncode"], 0, result["stderr"])
        self.assertEqual(result["fail"], [])
        self.assertEqual(result["pass"], 2 * 4)

    def test_module_that_loses_a_reference_fails_at_its_probe(self):
        program, calls = reference_fixture()
        source = REFERENCE_MODULE.replace("CALL1", str(calls[0])).replace("CALL2", str(calls[1]))
        self.write_module(source.replace("    x = bump(x)\n    __ref(" + str(calls[1]), "    bump(x)\n    __ref(" + str(calls[1])))
        result = harness.run(self.root, "prog", program, CATALOG, "action", seeds=range(1), probes=frozenset(calls))
        self.assertEqual(result["returncode"], 0, result["stderr"])
        self.assertTrue(any("ref" in line for line in result["fail"]), result["fail"])


if __name__ == "__main__":
    unittest.main()
