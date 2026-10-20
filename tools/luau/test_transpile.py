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
        module = emit_library("helper_abcd1234", "action", helper, {0x10: helper}, {}, False, 3, CATALOG)
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
            2,
            CATALOG,
        )
        self.assertIn('local helper_11112222 = require("@lib/action/helper_11112222")\n', module.text)
        self.assertIn("\thelper_11112222(arg0)\n", module.text)
        self.assertIn("\nreturn helper_abcd1234\n", module.text)

    def test_return_value_is_kept_when_used(self):
        helper = function(0x10, [ir.Return(const(7))])
        module = emit_library("helper_abcd1234", "action", helper, {0x10: helper}, {}, True, 2, CATALOG)
        self.assertIn("\treturn 7\n", module.text)

    def test_uncalled_callee_outside_the_libraries_is_rejected(self):
        callee = function(0x30, [ir.Print((const(1),))])
        helper = function(0x10, [ir.CallStmt(call(0x30))])
        from stb2luau.emit import EmitError

        with self.assertRaises(EmitError):
            emit_library("helper_abcd1234", "action", helper, {0x10: helper, 0x30: callee}, {}, False, 2, CATALOG)


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
        # h(0) returns 2147483647 and h(1) returns 1.5, so x is typed any: print(x + 1) prints -2147483648, then 2.5.
        h = (1, 1, [
            ("LOAD", 0, AddrMode.LOCAL), ("JMP_FALSE", "int"), ("pushf", 1.5), ("RET",),
            ("label", "int"), ("push", 2147483647), ("RET",),
        ])
        body = []
        for which in (0, 1):
            body += [
                ("LOAD_ADDR", 0, AddrMode.LOCAL), ("push", which), ("CALL", "h"), ("STORE",), ("POP",),
                ("LOAD", 0, AddrMode.LOCAL), ("push", 1), ("ADD",), ("PRINT", 1),
            ]
        functions = {"main": (1, 0, [*body, ("push", 0), ("RET",)]), "h": h}
        self.assertIn("print(vm.wrap(var0 + 1))", emit_script(functions))
        if transpile.harness.HOST.exists():
            row = differential(functions)
            self.assertEqual((row.failed, row.lines), (0, []))


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
