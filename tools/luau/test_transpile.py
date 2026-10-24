import contextlib
import dataclasses
import io
import json
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.analysis import Analysis  # noqa: E402
from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode, Compare, Op  # noqa: E402
from stb.program import decode  # noqa: E402
from stb2luau import ir, transpile  # noqa: E402
from stb2luau.emit import FunctionInput, emit_library  # noqa: E402
from stb2luau.transpile import canonical_key, float_globals, float_references, shareable_blocks  # noqa: E402

CATALOG = {"kinds": {"action": {"namespace": "action", "commands": []}}}


def var(n):
    return ir.Var(("local", n), ir.INT)


def const(value):
    return ir.Const(value, ir.INT)


def function(block, body, *, arg=0, slots=None, programs=(), main=False, refs=(), arrays=None):
    return FunctionInput(block, arg, 0, dict(slots or {}), [], list(body), list(programs), main, refs, dict(arrays or {}))


def call(block, *args):
    return ir.Call(block, tuple(args), ir.INT)


class CanonicalKeyTest(unittest.TestCase):
    def test_offsets_are_ignored(self):
        first = function(0x10, [ir.Assign(("local", 0), const(1), offset=0x100)], arg=1)
        second = function(0x20, [ir.Assign(("local", 0), const(1), offset=0x900)], arg=1)
        self.assertEqual(canonical_key(first, {0x10: first}), canonical_key(second, {0x20: second}))

    def test_different_callee_bodies_give_different_keys(self):
        callee_a = function(0x30, [ir.Print((const(1),))])
        callee_b = function(0x30, [ir.Print((const(2),))])
        caller = function(0x10, [ir.CallStmt(call(0x30))])
        keys_a = canonical_key(caller, {0x10: caller, 0x30: callee_a})
        keys_b = canonical_key(caller, {0x10: caller, 0x30: callee_b})
        self.assertNotEqual(keys_a, keys_b)

    def test_call_names_callee_by_key_not_block(self):
        callee = function(0x30, [ir.Print((const(1),))])
        caller_a = function(0x10, [ir.CallStmt(call(0x30))])
        caller_b = function(0x40, [ir.CallStmt(call(0x50))])
        other = function(0x50, [ir.Print((const(1),))])
        self.assertEqual(
            canonical_key(caller_a, {0x10: caller_a, 0x30: callee}),
            canonical_key(caller_b, {0x40: caller_b, 0x50: other}),
        )


    def test_references_and_arrays_are_part_of_the_key(self):
        body = [ir.Assign(("local", 0), const(1))]
        plain = function(0x10, body, arg=1)
        reference = function(0x10, body, arg=1, refs=(0,))
        table = function(0x10, body, arg=1, arrays={("array", 1): 3})
        keys = {canonical_key(f, {0x10: f}) for f in (plain, reference, table)}
        self.assertEqual(len(keys), 3)

    def test_an_unindexed_reference_keeps_its_key(self):
        # A field at its default is left out, so keys of helpers without element references stay as they were.
        first = function(0x10, [ir.ExtCall(2, (ir.Addr(("local", 0), ir.INT),))], arg=1)
        second = function(0x10, [ir.ExtCall(2, (ir.Addr(("local", 0), ir.INT, const(0)),))], arg=1)
        self.assertNotEqual(canonical_key(first, {0x10: first}), canonical_key(second, {0x10: second}))
        self.assertEqual(
            canonical_key(first, {0x10: first}),
            canonical_key(function(0x20, [ir.ExtCall(2, (ir.Addr(("local", 0), ir.INT),))], arg=1), {}),
        )


class FloatReferencesTest(unittest.TestCase):
    def test_arguments_naming_float_variables(self):
        body = [
            ("push", 53), ("LOAD_ADDR", 0, AddrMode.LOCAL_FLOAT), ("LOAD_ADDR", 1, AddrMode.LOCAL), ("push", 2), ("EXT", 4),
            ("LOAD", 0, AddrMode.GLOBAL_FLOAT), ("PRINT", 1),
            ("END",),
        ]
        program = decode(assemble({"main": (2, 0, body)}, "main", global_num=1))
        analysis = Analysis(program)
        ext = next(i.offset for i in program.functions[program.main].instructions if i.op == Op.EXT)
        self.assertEqual(float_references(analysis)[ext], (True, False, False))
        self.assertEqual(float_globals(analysis), frozenset({0}))


class ShareableTest(unittest.TestCase):
    def test_pure_helper_is_shareable(self):
        helper = function(0x10, [ir.Print((var(0),))], arg=1, slots={("local", 0): ir.INT})
        self.assertEqual(shareable_blocks({0x10: helper}), {0x10})

    def test_global_write_makes_helper_unshareable(self):
        helper = function(0x10, [ir.Assign(("global", 0), const(1))])
        self.assertEqual(shareable_blocks({0x10: helper}), set())

    def test_global_read_makes_helper_unshareable(self):
        helper = function(0x10, [ir.Print((ir.Var(("global", 1), ir.INT),))])
        self.assertEqual(shareable_blocks({0x10: helper}), set())

    def test_global_use_in_a_callee_makes_caller_unshareable(self):
        leaf = function(0x30, [ir.Print((ir.Var(("global", 2), ir.INT),))])
        caller = function(0x10, [ir.CallStmt(call(0x30))])
        self.assertEqual(shareable_blocks({0x10: caller, 0x30: leaf}), set())

    def test_main_and_program_entries_are_not_shareable(self):
        main = function(0x10, [ir.Print((const(1),))], main=True)
        program = function(0x20, [ir.Print((const(1),))], programs=[3])
        self.assertEqual(shareable_blocks({0x10: main, 0x20: program}), set())

    def test_caller_of_a_program_entry_is_not_shareable(self):
        program = function(0x30, [ir.Print((const(1),))], programs=[3])
        caller = function(0x10, [ir.CallStmt(call(0x30))])
        self.assertEqual(shareable_blocks({0x10: caller, 0x30: program}), set())


class EmitLibraryTest(unittest.TestCase):
    def test_tiny_helper_returns_itself(self):
        helper = function(0x10, [ir.Print((var(0),))], arg=1, slots={("local", 0): ir.INT})
        module = emit_library("helper_abcd1234", "action", helper, {0x10: helper}, {}, False, set(), 3, CATALOG)
        self.assertEqual(
            module.text,
            "--!strict\n"
            "-- Shared action helper used by 3 scripts, translated by tools/luau/stb2luau.\n"
            "\n"
            "--- Helper function.\n"
            "local function helper_abcd1234(arg0: s32)\n"
            "\tprint(arg0)\n"
            "end\n"
            "\n"
            "return helper_abcd1234\n",
        )

    def test_callee_is_required_from_its_library(self):
        callee = function(0x30, [ir.Print((var(0),))], arg=1, slots={("local", 0): ir.INT})
        helper = function(0x10, [ir.CallStmt(call(0x30, var(0)))], arg=1, slots={("local", 0): ir.INT})
        module = emit_library(
            "helper_abcd1234",
            "action",
            helper,
            {0x10: helper, 0x30: callee},
            {0x10: "helper_abcd1234", 0x30: "helper_11112222"},
            True,
            set(),
            2,
            CATALOG,
        )
        self.assertIn('local helper_11112222 = require("@lib/action/helper_11112222")\n', module.text)
        self.assertIn("\thelper_11112222(arg0)\n", module.text)
        self.assertIn("\nreturn helper_abcd1234\n", module.text)

    def test_return_value_is_kept_when_used(self):
        helper = function(0x10, [ir.Return(const(7))])
        module = emit_library("helper_abcd1234", "action", helper, {0x10: helper}, {}, True, set(), 2, CATALOG)
        self.assertIn("\treturn 7\n", module.text)

    def test_uncalled_callee_outside_the_libraries_is_rejected(self):
        callee = function(0x30, [ir.Print((const(1),))])
        helper = function(0x10, [ir.CallStmt(call(0x30))])
        from stb2luau.emit import EmitError

        with self.assertRaises(EmitError):
            emit_library("helper_abcd1234", "action", helper, {0x10: helper, 0x30: callee}, {}, False, set(), 2, CATALOG)


def _write_texts(texts):
    """Stands in for the StyLua pass: writes each text unformatted."""
    for path, text in texts.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8", newline="\n")
    return dict(texts)


SCRIPT = "dungeon/act_script/t01.stb"


def emit_script(functions, programs=None, **options):
    """Transpiles and emits one assembled action script; returns the lift error or the emit error, or the module text."""
    path = SCRIPT
    result, module = transpile.transpile(path, assemble(functions, "main", programs, **options))
    if module is None:
        return result.error
    catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
    corpus_ = transpile.emit_corpus([(result, module)], catalog)
    return corpus_.errors.get(path) or corpus_.modules[path].text


def differential(functions, programs=None, seeds=2, **options):
    """Transpiles one assembled action script and runs the differential harness on it; returns its harness row."""
    result, module = transpile.transpile(SCRIPT, assemble(functions, "main", programs, **options))
    if module is None:
        raise AssertionError(result.error)
    catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
    exposed = transpile.emit_corpus([(result, dataclasses.replace(module, expose_globals=True, probe_refs=True))], catalog)
    if SCRIPT in exposed.errors:
        raise AssertionError(exposed.errors[SCRIPT])
    with tempfile.TemporaryDirectory() as scratch:
        job = (result, exposed.modules[SCRIPT], catalog["kinds"]["action"], range(seeds), Path(scratch))
        return transpile._harness_job(job)


class ScriptTest(unittest.TestCase):
    def test_unbounded_float_index_refuses_ambiguous_native_output(self):
        local = AddrMode.LOCAL
        body = [
            ("push", 13), ("push", 10.0), ("LOAD_ADDR", 3, local), ("EXT", 3),
            ("push", 13), ("push", 4.0), ("LOAD_ADDR", 0, local), ("EXT", 3),
            ("LOAD", 0, local), ("LOAD", 1, AddrMode.LOCAL_INDEX_FLOAT), ("PRINT", 1),
            ("LOAD", 3, local), ("PRINT", 1), ("push", 0), ("RET",),
        ]
        path = "dungeon/eff_script/t01.stb"
        result, module = transpile.transpile(path, assemble({"main": (4, 0, body)}, "main"))
        self.assertIsNotNone(module, result.error)
        catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
        corpus = transpile.emit_corpus([(result, module)], catalog)
        self.assertIn("float and int", corpus.errors[path])

    def test_integer_from_a_helper_passed_to_a_float_reference_is_rejected(self):
        # x = f() returns the integer 1065353216; read(&x) loads *p as a float and the caller then loads x as one. Retail
        # prints 1.0 twice, where copying the integer in and back would print 1065353216.
        functions = {
            "main": (1, 0, [
                ("LOAD_ADDR", 0, AddrMode.LOCAL), ("CALL", "f"), ("STORE",), ("POP",),
                ("LOAD_ADDR", 0, AddrMode.LOCAL), ("CALL", "read"), ("POP",),
                ("LOAD", 0, AddrMode.LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
            "f": (0, 0, [("push", 1065353216), ("RET",)]),
            "read": (1, 1, [("push", 0), ("LOAD", 0, AddrMode.POINTER_INDEX_FLOAT), ("PRINT", 1), ("push", 0), ("RET",)]),
        }
        self.assertIn("may be an integer is stored into float variable", emit_script(functions))

    def test_printed_float_keeps_its_decimals(self):
        # Retail prints a float slot with %f, so 2.0 prints 2.000000, where the runtime's print would show 2.
        functions = {"main": (1, 0, [
            ("LOAD_ADDR", 0, AddrMode.LOCAL_FLOAT), ("pushf", 2.0), ("STORE",), ("POP",),
            ("LOAD", 0, AddrMode.LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",),
        ])}
        text = emit_script(functions)
        self.assertIn('print(string.format("%f", var0))', text)
        if transpile.harness.HOST.exists():
            self.assertEqual(differential(functions).failed, 0)
            result, module = transpile.transpile(SCRIPT, assemble(functions, "main"))
            catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
            exposed = transpile.emit_corpus([(result, dataclasses.replace(module, expose_globals=True, probe_refs=True))], catalog)
            changed = dataclasses.replace(
                exposed.modules[SCRIPT], text=exposed.modules[SCRIPT].text.replace('string.format("%f", var0)', "var0")
            )
            with tempfile.TemporaryDirectory() as scratch:
                row = transpile._harness_job((result, changed, catalog["kinds"]["action"], range(2), Path(scratch)))
            self.assertGreater(row.failed, 0)

    def test_print_of_an_integer_or_a_float_is_rejected(self):
        h = (1, 1, [
            ("LOAD", 0, AddrMode.LOCAL), ("JMP_FALSE", "int"), ("pushf", 1.5), ("RET",),
            ("label", "int"), ("push", 2), ("RET",),
        ])
        functions = {"main": (1, 0, [
            ("LOAD_ADDR", 0, AddrMode.LOCAL), ("push", 1), ("CALL", "h"), ("STORE",), ("POP",),
            ("LOAD", 0, AddrMode.LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
        ]), "h": h}
        self.assertIn("print argument 1 may hold float or int", emit_script(functions))

    def test_dropped_value_of_a_shared_helper_another_script_uses_is_skipped(self):
        # set(&x) stores 5 through x and returns 7. One script prints the value, the other drops it: the shared helper
        # returns 7 and then x, so the second script must take x from the second result.
        def script(use):
            call = [("LOAD_ADDR", 0, AddrMode.LOCAL), ("CALL", "set")] + ([("PRINT", 1)] if use else [("POP",)])
            return {
                "main": (1, 0, [*call, ("LOAD", 0, AddrMode.LOCAL), ("PRINT", 1), ("push", 0), ("RET",)]),
                "set": (1, 1, [
                    ("push", 0), ("LOAD_ADDR", 0, AddrMode.POINTER_INDEX), ("push", 5), ("STORE",), ("POP",),
                    ("push", 7), ("RET",),
                ]),
            }

        catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
        paths = ("dungeon/act_script/t01.stb", "dungeon/act_script/t02.stb")
        lifted = [transpile.transpile(path, assemble(script(path == paths[0]), "main")) for path in paths]
        corpus_ = transpile.emit_corpus(lifted, catalog)
        self.assertEqual(corpus_.errors, {})
        self.assertIn("\t_, var0 = helper_", corpus_.modules[paths[1]].text)

    def test_integer_constant_read_as_an_integer_and_later_as_a_float_is_rejected(self):
        # x = 1065353216; print(x); read(&x); print(x as a float): retail prints 1065353216, then 1.0 twice, but the
        # translation can spell the constant only one way.
        functions = {
            "main": (1, 0, [
                ("LOAD_ADDR", 0, AddrMode.LOCAL), ("push", 1065353216), ("STORE",), ("POP",),
                ("LOAD", 0, AddrMode.LOCAL), ("PRINT", 1),
                ("LOAD_ADDR", 0, AddrMode.LOCAL), ("CALL", "read"), ("POP",),
                ("LOAD", 0, AddrMode.LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
            "read": (1, 1, [("push", 0), ("LOAD", 0, AddrMode.POINTER_INDEX_FLOAT), ("PRINT", 1), ("push", 0), ("RET",)]),
        }
        self.assertIn("loads both as an integer and as a float", emit_script(functions))

    def test_integer_constant_passed_to_a_parameter_read_both_ways_is_rejected(self):
        functions = {
            "main": (0, 0, [("push", 1065353216), ("CALL", "f"), ("POP",), ("push", 0), ("RET",)]),
            "f": (1, 1, [("LOAD", 0, AddrMode.LOCAL), ("PRINT", 1), ("LOAD", 0, AddrMode.LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",)]),
        }
        self.assertIn("loads both as an integer and as a float", emit_script(functions))

    def test_integer_constant_read_only_as_a_float_is_its_bits(self):
        functions = {
            "main": (1, 0, [
                ("LOAD_ADDR", 0, AddrMode.LOCAL), ("push", 1065353216), ("STORE",), ("POP",),
                ("LOAD", 0, AddrMode.LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
        }
        self.assertIn("var0 = 1.0 -- retail: integer bits read as a float", emit_script(functions))


class WrapTest(unittest.TestCase):
    def test_loop_whose_step_overflows_stays_a_while_loop(self):
        # i = 2147483647; while i <= 2147483647 do if i == 2147483647 then print(i) end; i = i + 1 end runs for ever on
        # the PS2, where the step wraps; a numeric for would run once.
        top = [
            ("LOAD_ADDR", 0, AddrMode.LOCAL), ("push", 2147483647), ("STORE",), ("POP",),
            ("label", "top"),
            ("LOAD", 0, AddrMode.LOCAL), ("push", 2147483647), ("CMP", Compare.LE), ("JMP_FALSE", "done"),
            ("LOAD", 0, AddrMode.LOCAL), ("push", 2147483647), ("CMP", Compare.EQ), ("JMP_FALSE", "next"),
            ("LOAD", 0, AddrMode.LOCAL), ("PRINT", 1),
            ("label", "next"),
            ("LOAD_ADDR", 0, AddrMode.LOCAL), ("LOAD", 0, AddrMode.LOCAL), ("push", 1), ("ADD",), ("STORE",), ("POP",),
            ("JMP", "top"),
            ("label", "done"),
            ("push", 0), ("RET",),
        ]
        text = emit_script({"main": (1, 0, top)})
        self.assertIn("while var0 <= 2147483647 do", text)
        self.assertIn("var0 = vm.i32(var0 + 1)", text)
        self.assertNotIn("for ", text)

    @unittest.skipUnless(transpile.harness.HOST.exists(), "luau-harness is not built")
    def test_wrapped_sum_matches_the_reference(self):
        # x = 2147483647; x = x + 1; print(x) prints -2147483648 on the PS2.
        body = [
            ("LOAD_ADDR", 0, AddrMode.LOCAL), ("push", 2147483647), ("STORE",), ("POP",),
            ("LOAD_ADDR", 0, AddrMode.LOCAL), ("LOAD", 0, AddrMode.LOCAL), ("push", 1), ("ADD",), ("STORE",), ("POP",),
            ("LOAD", 0, AddrMode.LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
        ]
        row = differential({"main": (1, 0, body)})
        self.assertEqual((row.failed, row.lines), (0, []))
        self.assertEqual(row.passed, 2 * 2)

    # f sets the global to 2147483647 and returns 1, after the caller last set it to 0.
    GLOBAL_SETTER = (0, 0, [("LOAD_ADDR", 0, AddrMode.GLOBAL), ("push", 2147483647), ("STORE",), ("POP",), ("push", 1), ("RET",)])
    CLEAR_GLOBAL = [("LOAD_ADDR", 0, AddrMode.GLOBAL), ("push", 0), ("STORE",), ("POP",)]

    def test_global_a_call_in_the_same_expression_sets_wraps(self):
        # g = 0; print(f() + g) prints -2147483648: f runs before g is read.
        body = [*self.CLEAR_GLOBAL, ("CALL", "f"), ("LOAD", 0, AddrMode.GLOBAL), ("ADD",), ("PRINT", 1), ("push", 0), ("RET",)]
        functions = {"main": (0, 0, body), "f": self.GLOBAL_SETTER}
        self.assertIn("vm.i32(helper_", emit_script(functions, magic="SB2", global_num=1))
        if transpile.harness.HOST.exists():
            row = differential(functions, magic="SB2", global_num=1)
            self.assertEqual((row.failed, row.lines), (0, []))

    def test_global_a_call_in_a_branch_condition_sets_wraps(self):
        # g = 0; if f() then print(g + 1) end prints -2147483648.
        body = [
            *self.CLEAR_GLOBAL, ("CALL", "f"), ("JMP_FALSE", "done"),
            ("LOAD", 0, AddrMode.GLOBAL), ("push", 1), ("ADD",), ("PRINT", 1),
            ("label", "done"), ("push", 0), ("RET",),
        ]
        functions = {"main": (0, 0, body), "f": self.GLOBAL_SETTER}
        self.assertIn("print(vm.i32(global0 + 1))", emit_script(functions, magic="SB2", global_num=1))
        if transpile.harness.HOST.exists():
            row = differential(functions, magic="SB2", global_num=1)
            self.assertEqual((row.failed, row.lines), (0, []))

    def test_sum_that_may_hold_an_integer_or_a_float_wraps_only_an_integer(self):
        # h(0) returns 2147483647 and h(1) returns 1.5, so x is typed any: x + 1 stores -2147483648, then 2.5.
        h = (1, 1, [
            ("LOAD", 0, AddrMode.LOCAL), ("JMP_FALSE", "int"), ("pushf", 1.5), ("RET",),
            ("label", "int"), ("push", 2147483647), ("RET",),
        ])
        body = []
        for which in (0, 1):
            body += [
                ("LOAD_ADDR", 0, AddrMode.LOCAL), ("push", which), ("CALL", "h"), ("STORE",), ("POP",),
                ("LOAD_ADDR", which, AddrMode.GLOBAL), ("LOAD", 0, AddrMode.LOCAL), ("push", 1), ("ADD",), ("STORE",),
                ("POP",),
            ]
        functions = {"main": (1, 0, [*body, ("push", 0), ("RET",)]), "h": h}
        result, module = transpile.transpile(SCRIPT, assemble(functions, "main", global_num=2))
        catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
        exposed = transpile.emit_corpus([(result, dataclasses.replace(module, expose_globals=True))], catalog)
        self.assertIn("global0 = vm.wrap(var0 + 1)", exposed.modules[SCRIPT].text)
        if transpile.harness.HOST.exists():
            row = differential(functions, global_num=2)
            self.assertEqual((row.failed, row.lines), (0, []))


EVENT = "map/t/t01.stb"
SET_RAIN = 21
LOCAL, LOCAL_FLOAT = AddrMode.LOCAL, AddrMode.LOCAL_FLOAT


def event_script(functions, programs):
    """Transpiles and emits one assembled event script; returns the result and the module text or the error."""
    result, module = transpile.transpile(EVENT, assemble(functions, "main", programs))
    if module is None:
        return result, result.error
    catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
    exposed = transpile.emit_corpus([(result, dataclasses.replace(module, expose_globals=True, probe_refs=True))], catalog)
    return result, exposed.errors.get(EVENT) or exposed.modules[EVENT]


def event_differential(functions, programs, seeds=2):
    """Runs the differential harness, skip scenarios included, on one assembled event script."""
    result, module = event_script(functions, programs)
    if isinstance(module, str):
        raise AssertionError(module)
    catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
    with tempfile.TemporaryDirectory() as scratch:
        return transpile._harness_job((result, module, catalog["kinds"]["event"], range(seeds), Path(scratch)))


def store(slot, *value, mode=LOCAL):
    return [("LOAD_ADDR", slot, mode), *value, ("STORE",), ("POP",)]


def rain(*value):
    return [("push", SET_RAIN), *value, ("EXT", 2)]


# A helper that waits three frames, counting in local 0; its sweep counts once more and returns.
WAITER = (1, 0, [
    ("label", "loop"),
    ("LOAD", 0, LOCAL), ("push", 3), ("CMP", Compare.LT), ("JMP_FALSE", "done"),
    *rain(("LOAD", 0, LOCAL)),
    ("WAIT",),
    *store(0, ("LOAD", 0, LOCAL), ("push", 1), ("ADD",)),
    ("JMP", "loop"),
    ("label", "done"),
    ("LOAD", 0, LOCAL), ("RET",),
])


@unittest.skipUnless(transpile.harness.HOST.exists(), "luau-harness is not built")
class SkipModeTest(unittest.TestCase):
    def test_sweep_runs_both_branches_and_stops_at_the_skip_end(self):
        # A skip during the waiter sweeps on in layout order: the if's two stores both run, the second winning, and the
        # native calls do not; the skip end then suspends, and the script prints after it.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (2, 0, [
                *store(0, ("CALL", "waiter")),
                ("LOAD", 0, LOCAL), ("push", 2), ("CMP", Compare.GT), ("JMP_FALSE", "else"),
                *store(1, ("push", 10)), *rain(("push", 1)), ("JMP", "join"),
                ("label", "else"), *store(1, ("push", 20)),
                ("label", "join"),
                ("SKIP_END",),
                ("LOAD", 0, LOCAL), ("LOAD", 1, LOCAL), ("PRINT", 2), ("WAIT",),
                ("LOAD", 1, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
            "waiter": WAITER,
        }
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)
        self.assertGreater(row.passed, 0)

    def test_sweep_that_calls_a_skip_end_resumes_normal_execution_after_the_call(self):
        # The skip in the waiter sweeps on into cut, which runs in skip mode up to its skip end and suspends there; the
        # next frame finishes cut normally, and p100 goes on normally after the call.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (1, 0, [
                ("CALL", "waiter"), ("POP",),
                ("CALL", "cut"), ("POP",),
                *rain(("push", 7)), ("WAIT",),
                ("push", 0), ("RET",),
            ]),
            "cut": (1, 0, [
                *store(0, ("push", 5)), *rain(("push", 1)),
                ("SKIP_END",),
                ("LOAD", 0, LOCAL), ("PRINT", 1), ("WAIT",), *rain(("push", 2)),
                ("push", 0), ("RET",),
            ]),
            "waiter": WAITER,
        }
        result, module = event_script(functions, {100: "p100"})
        self.assertIn("if not vm.skipping() then", module.text)
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)

    def test_store_through_a_leaked_condition_is_refused(self):
        # x = a && b in skip mode stores b through a, the condition the jump left on the stack.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (3, 0, [
                ("WAIT",),
                ("LOAD_ADDR", 0, LOCAL), ("LOAD", 1, LOCAL), ("JMP_FALSE", "short", 1), ("LOAD", 2, LOCAL),
                ("label", "short"), ("STORE",), ("POP",),
                ("push", 0), ("RET",),
            ]),
        }
        _, error = event_script(functions, {100: "p100"})
        self.assertIn("skip mode reads a condition a jump left on the stack", error)

    def test_sweep_that_overflows_the_stack_raises_where_retail_exits(self):
        # Each if leaks its condition in skip mode, so a skip overflows the 128 slots; the helper's frame starts above
        # p100's, which passes where its frame starts.
        leaks = []
        for n in range(110):
            leaks += [("LOAD", 0, LOCAL), ("JMP_FALSE", f"skip{n}"), *store(0, ("push", n)), ("label", f"skip{n}")]
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (20, 0, [("WAIT",), ("push", 1), ("CALL", "leaky"), ("POP",), ("LOAD", 0, LOCAL), ("PRINT", 1), ("push", 0), ("RET",)]),
            "leaky": (8, 1, [*rain(("push", 2)), ("WAIT",), *leaks, *rain(("push", 3)), ("LOAD", 1, LOCAL), ("PRINT", 1), ("push", 0), ("RET",)]),
        }
        _, module = event_script(functions, {100: "p100"})
        self.assertIn("vm.stack(sp + ", module.text)
        self.assertIn("sp: number", module.text)
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)

    def test_deferred_output_is_read_after_the_wait(self):
        # GotoUseItem keeps the reference and writes the item used when its menu closes, during the wait after it.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (1, 0, [
                ("push", 31), ("LOAD_ADDR", 0, LOCAL), ("push", 376), ("EXT", 3), ("WAIT",),
                ("LOAD", 0, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
        }
        _, module = event_script(functions, {100: "p100"})
        self.assertIn("var0 = event.DeferredOutput() or var0", module.text)
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)

    def test_deferred_output_into_a_float_variable_reads_its_bits(self):
        # GotoUseItem writes an integer through the reference without retagging; a float load reads its bits.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (1, 0, [
                ("push", 31), ("LOAD_ADDR", 0, LOCAL_FLOAT), ("push", 376), ("EXT", 3), ("WAIT",),
                ("LOAD", 0, LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
        }
        _, module = event_script(functions, {100: "p100"})
        self.assertIn("vm.bits_float(event.DeferredOutput())", module.text)
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)

    def test_condition_a_skipped_call_leaves_on_the_stack_counts(self):
        # Skipping the waiter returns 1, which the skipped branch leaves on the stack at slot 126; the native call's
        # command then fills the last slot, and its argument overflows, where retail exits.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (126, 0, [("CALL", "waiter"), ("JMP_FALSE", "done"), *rain(("push", 7)), ("label", "done"), ("push", 0), ("RET",)]),
            "waiter": (0, 0, [("WAIT",), ("push", 1), ("RET",)]),
        }
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)

    def test_division_a_sweep_stores_into_an_unread_local_still_runs(self):
        # Normal execution jumps over 1 / 0; a skip runs it, where retail exits.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (1, 0, [
                ("WAIT",), ("push", 1), ("JMP_FALSE", "bad"), ("JMP", "done"),
                ("label", "bad"), *store(0, ("push", 1), ("push", 0), ("DIV",)),
                ("label", "done"), ("push", 0), ("RET",),
            ]),
        }
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)

    def mutated(self, functions, old, new):
        """The harness row of the script's module with one text replaced."""
        result, module = event_script(functions, {100: "p100"})
        self.assertIn(old, module.text)
        catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
        changed = dataclasses.replace(module, text=module.text.replace(old, new))
        with tempfile.TemporaryDirectory() as scratch:
            return transpile._harness_job((result, changed, catalog["kinds"]["event"], range(2), Path(scratch)))

    def test_party_join_passes_its_value_and_the_query_reads_it_back(self):
        # JoinPartyMember joins with the value 1 and answers whether a character is a member through a reference.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (1, 0, [
                ("push", 1078), ("push", 2), ("push", 1), ("EXT", 3),
                ("push", 1078), ("push", 2), ("LOAD_ADDR", 0, LOCAL), ("EXT", 3),
                ("LOAD", 0, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
        }
        _, module = event_script(functions, {100: "p100"})
        self.assertIn('event.ExtTyped(1078, "ii", 2, 1)', module.text)
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)
        # Calling the query form instead of the join fails the harness.
        row = self.mutated(functions, 'event.ExtTyped(1078, "ii", 2, 1)', "event.JoinPartyMember(2)")
        self.assertGreater(row.failed, 0)

    def test_fish_record_returns_the_float_size_after_the_value_it_reads(self):
        # GetMenuEtc(2, fish, &size) reads the fish's number and writes its size, a float; GetMenuEtc(7, step, &result)
        # reads the step and writes an integer. The call returns only what the handler writes.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (2, 0, [
                ("push", 564), ("push", 2), ("push", 322), ("LOAD_ADDR", 0, LOCAL), ("EXT", 4),
                ("LOAD", 0, AddrMode.LOCAL_FLOAT), ("PRINT", 1),
                ("push", 564), ("push", 7), ("push", 3), ("LOAD_ADDR", 1, LOCAL), ("EXT", 4),
                ("LOAD", 1, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
        }
        _, module = event_script(functions, {100: "p100"})
        self.assertIn('event.ExtTyped(564, "iiF", 2, 322)', module.text)
        self.assertIn('event.ExtTyped(564, "iiI", 7, 3)', module.text)
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)
        row = self.mutated(functions, 'event.ExtTyped(564, "iiF", 2, 322)', 'event.ExtTyped(564, "iiI", 2, 322)')
        self.assertGreater(row.failed, 0)

    def test_integer_range_takes_the_integer_branch_of_get_rand(self):
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (1, 0, [
                ("push", 1013), ("push", 100), ("LOAD_ADDR", 0, LOCAL), ("EXT", 3),
                ("LOAD", 0, LOCAL), ("push", 2), ("MOD",), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
        }
        _, module = event_script(functions, {100: "p100"})
        self.assertIn("event.GetRandInt(100)", module.text)
        self.assertNotIn("float_bits", module.text)
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)
        row = self.mutated(functions, "event.GetRandInt(100)", "vm.float_bits(event.GetRandFloat(100))")
        self.assertGreater(row.failed, 0)

    def test_a_float_where_map_jump_switches_on_the_tag_fails(self):
        # MapJump takes a map's number or name by the tag; a float, which the runtime passes as a FLOAT, it rejects.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (0, 0, [("push", 20), ("push", 0), ("push", 1), ("EXT", 3), ("push", 0), ("RET",)]),
        }
        row = self.mutated(functions, "event.MapJump(0, 1)", "event.MapJump(0, 1 + 2 ^ -40)")
        self.assertGreater(row.failed, 0)

    def test_a_call_that_prints_runs_before_a_later_push_overflows(self):
        # Skipped at the wait, the branch leaves its condition: with 125 locals, h prints 77 from the last slots, and the
        # push of 9 after it overflows, so retail prints before it exits. With 124 locals everything fits.
        printer = (0, 0, [("push", 77), ("PRINT", 1), ("push", 1), ("RET",)])
        for local in (124, 125):
            body = [
                ("WAIT",), ("push", 1), ("JMP_FALSE", "next"), ("label", "next"),
                ("push", SET_RAIN), ("CALL", "h"), ("push", 9), ("ADD",), ("EXT", 2), ("push", 0), ("RET",),
            ]
            functions = {"main": (0, 0, [("push", 0), ("RET",)]), "p100": (local, 0, body), "h": printer}
            row = event_differential(functions, {100: "p100"})
            self.assertEqual(row.failed, 0, (local, row.lines))

    def test_a_call_that_prints_runs_before_a_later_division(self):
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (0, 0, [
                ("WAIT",), ("push", SET_RAIN), ("CALL", "h"), ("push", 1), ("push", 0), ("DIV",), ("ADD",), ("EXT", 2),
                ("push", 0), ("RET",),
            ]),
            "h": (0, 0, [("push", 77), ("PRINT", 1), ("push", 1), ("RET",)]),
        }
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)

    def test_the_index_of_a_store_nothing_reads_still_divides(self):
        # Skip mode reaches a[1 / 0] = 9, which retail evaluates and exits on; with a divisor of 1 it stores and goes on.
        for divisor, local in ((0, 1), (1, 2)):
            body = [
                ("WAIT",), ("push", 1), ("JMP_FALSE", "bad"), ("JMP", "done"), ("label", "bad"),
                ("push", 1), ("push", divisor), ("DIV",), ("LOAD_ADDR", 0, AddrMode.LOCAL_INDEX), ("push", 9), ("STORE",),
                ("POP",), ("label", "done"), ("push", 0), ("RET",),
            ]
            functions = {"main": (0, 0, [("push", 0), ("RET",)]), "p100": (local, 0, body)}
            row = event_differential(functions, {100: "p100"})
            self.assertEqual(row.failed, 0, (divisor, row.lines))

    def test_an_expression_of_a_stored_element_uses_the_stored_value(self):
        # local0 = 0; then a[local0] = 9 stores into local0 itself, and NEG or ADD takes the value the store pushed.
        # Reading the element back would index it by 9, outside the frame; retail goes on and prints 42.
        for value in (9, 0):
            for tail in ([], [("NEG",)], [("push", 1), ("ADD",)]):
                body = [
                    ("LOAD_ADDR", 0, LOCAL), ("push", 0), ("STORE",), ("POP",), ("WAIT",),
                    ("LOAD", 0, LOCAL), ("LOAD_ADDR", 0, AddrMode.LOCAL_INDEX), ("push", value), ("STORE",), *tail, ("POP",),
                    ("push", 42), ("PRINT", 1), ("push", 0), ("RET",),
                ]
                functions = {"main": (0, 0, [("push", 0), ("RET",)]), "p100": (1, 0, body)}
                row = event_differential(functions, {100: "p100"})
                self.assertEqual(row.failed, 0, (value, tail, row.lines))

    def test_a_popped_division_still_divides(self):
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (0, 0, [("WAIT",), ("push", 1), ("push", 0), ("DIV",), ("POP",), ("push", 0), ("RET",)]),
        }
        row = event_differential(functions, {100: "p100"})
        self.assertEqual(row.failed, 0, row.lines)

    def test_a_division_passed_for_an_output_is_refused(self):
        # GetFlag(0, 1 / 0): retail divides before the call, where the handler writes through a value it ignores.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p100": (0, 0, [("push", 14), ("push", 0), ("push", 1), ("push", 0), ("DIV",), ("EXT", 3), ("push", 0), ("RET",)]),
        }
        _, module = event_script(functions, {100: "p100"})
        self.assertIsInstance(module, str)
        self.assertIn("a value passed where the handler writes an output, may raise", module)

    def test_action_scripts_have_no_skip_mode(self):
        result, module = transpile.transpile(SCRIPT, assemble({"main": (0, 0, [("WAIT",), ("push", 0), ("RET",)])}, "main"))
        self.assertIsNotNone(module)
        catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
        text = transpile.emit_corpus([(result, module)], catalog).modules[SCRIPT].text
        self.assertIn("vm.wait()", text)
        self.assertNotIn("skip", text)


class MainTest(unittest.TestCase):
    def test_check_with_harness_runs_the_harness(self):
        functions = {"main": (0, 0, [("push", 0), ("RET",)]), "p100": (0, 0, [("push", 0), ("RET",)])}
        with tempfile.TemporaryDirectory() as scratch:
            data = Path(scratch) / "data"
            script = data / "dungeon" / "act_script" / "t01.stb"
            script.parent.mkdir(parents=True)
            script.write_bytes(assemble(functions, "main", {100: "p100"}))
            out = Path(scratch) / "out"
            out.mkdir()
            harness_runs = []

            def rows(lifted, good, catalog, seeds, jobs, root):
                harness_runs.append([result.path for result in good])
                return []

            with contextlib.ExitStack() as stack:
                stack.enter_context(mock.patch.object(transpile, "CHECK", Path(__file__)))
                stack.enter_context(mock.patch.object(transpile.harness, "HOST", Path(__file__)))
                stack.enter_context(mock.patch.object(transpile, "format", _write_texts))
                stack.enter_context(mock.patch.object(transpile, "check", lambda paths, root: []))
                stack.enter_context(mock.patch.object(transpile, "_harness_rows", rows))
                stack.enter_context(contextlib.redirect_stdout(io.TextIOWrapper(io.BytesIO())))
                status = transpile.main(["--data", str(data), "--out", str(out), "--check", "--harness", "--jobs", "1"])
            # The empty output is out of date, and the harness still ran on the script.
            self.assertEqual(status, 1)
            self.assertEqual(harness_runs, [["dungeon/act_script/t01.stb"]])
            self.assertEqual(list(out.iterdir()), [])


if __name__ == "__main__":
    unittest.main()
