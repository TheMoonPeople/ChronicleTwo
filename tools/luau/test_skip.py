import dataclasses
import json
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode  # noqa: E402
from stb.program import decode  # noqa: E402
from stb2luau import harness, skip, transpile  # noqa: E402

LOCAL, POINTER_INDEX = AddrMode.LOCAL, AddrMode.POINTER_INDEX


def store_local(value):
    return [("LOAD_ADDR", 0, LOCAL), ("push", value), ("STORE",), ("POP",)]


def other(program, main):
    return next(block for block in program.functions if block != main)


class SkipTest(unittest.TestCase):
    def test_store_after_wait_needs_code(self):
        body = [*store_local(1), ("WAIT",), *store_local(2), ("SKIP_END",), ("push", 0), ("RET",)]
        program = decode(assemble({"main": (1, 0, body)}, "main"))
        plan = skip.plan(program, {})
        found = plan.functions[program.main]
        run = found.runs[0]
        self.assertEqual(run.terminal, "skip_end")
        self.assertEqual(len(run.resumes), 1)
        self.assertFalse(run.resumes[0].is_call)
        self.assertTrue(run.needs_code)
        self.assertTrue(plan.synthetic)

    def test_wait_then_skip_end_needs_no_code(self):
        body = [("WAIT",), ("SKIP_END",), ("push", 0), ("RET",)]
        program = decode(assemble({"main": (0, 0, body)}, "main"))
        plan = skip.plan(program, {})
        run = plan.functions[program.main].runs[0]
        self.assertEqual(run.terminal, "skip_end")
        self.assertFalse(run.needs_code)
        self.assertIsNone(run.stream)
        self.assertFalse(plan.synthetic)

    def test_callee_that_returns_while_skipping_is_a_live_resume(self):
        functions = {
            "main": (0, 0, [("CALL", "callee"), ("POP",), ("SKIP_END",), ("push", 0), ("RET",)]),
            "callee": (0, 0, [("WAIT",), ("push", 0), ("RET",)]),
        }
        program = decode(assemble(functions, "main"))
        plan = skip.plan(program, {})
        found = plan.functions[program.main]
        self.assertEqual(len(found.resumes), 1)
        self.assertTrue(found.resumes[0].is_call)
        callee = plan.functions[other(program, program.main)]
        self.assertIn("return", [run.terminal for run in callee.runs])

    def test_callee_that_reaches_skip_end_is_not_a_live_resume(self):
        functions = {
            "main": (0, 0, [("CALL", "callee"), ("POP",), ("SKIP_END",), ("push", 0), ("RET",)]),
            "callee": (0, 0, [("WAIT",), ("SKIP_END",), ("push", 0), ("RET",)]),
        }
        program = decode(assemble(functions, "main"))
        plan = skip.plan(program, {})
        self.assertNotIn(program.main, plan.functions)

    def test_store_through_reference_parameter_is_guarded(self):
        functions = {
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("CALL", "callee"), ("POP",), ("push", 0), ("RET",)]),
            "callee": (1, 1, [("WAIT",), ("push", 0), ("LOAD_ADDR", 0, POINTER_INDEX), ("push", 7), ("STORE",), ("POP",), ("push", 0), ("RET",)]),
        }
        program = decode(assemble(functions, "main"))
        callee = other(program, program.main)
        plan = skip.plan(program, {callee: (0,)})
        self.assertTrue(plan.functions[callee].guarded)

    def test_callee_whose_linear_run_reaches_skip_end_is_entered(self):
        functions = {
            "main": (0, 0, [("WAIT",), ("CALL", "callee"), ("POP",), ("SKIP_END",), ("push", 0), ("RET",)]),
            "callee": (0, 0, [("push", 0), ("SKIP_END",), ("push", 0), ("RET",)]),
        }
        program = decode(assemble(functions, "main"))
        plan = skip.plan(program, {})
        callee = other(program, program.main)
        self.assertEqual(plan.errors, {})
        self.assertIn(callee, plan.entered)
        # The callee is entered at its start and can be skipped again after its skip end.
        self.assertEqual(sorted(plan.functions[callee].entries), [0, 1])


EVENT_PATH = "map/test/t01.stb"
# SET_MARKER does nothing and takes one integer argument, so it reads a local without any other effect.
SINK = [("push", 23)]


def emit_event(functions, programs=None):
    """Transpiles and emits one assembled event script, asserting that it lifts and emits; returns its Luau text."""
    result, module = transpile.transpile(EVENT_PATH, assemble(functions, "main", programs))
    if module is None:
        raise AssertionError(result.error)
    return emit_event_module(module, result)


def emit_event_module(module, result=None):
    """Emits one lifted event script module as Luau text."""
    catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
    corpus = transpile.emit_corpus([(result, module)], catalog)
    if EVENT_PATH in corpus.errors:
        raise AssertionError(corpus.errors[EVENT_PATH])
    return corpus.modules[EVENT_PATH].text


class EventSkipTextTest(unittest.TestCase):
    def test_store_after_wait_emits_section_and_skip_function(self):
        body = [
            *store_local(1), ("WAIT",), *store_local(2),
            ("SKIP_END",), *SINK, ("LOAD", 0, LOCAL), ("EXT", 2), ("push", 0), ("RET",),
        ]
        text = emit_event({"main": (1, 0, body)})
        self.assertIn("vm.section(function()", text)
        self.assertIn("vm.wait(1)", text)
        self.assertIn("at = 1", text)
        self.assertIn("function(received: { any }): boolean", text)
        self.assertIn("if at <= 1 then", text)

    def test_wait_then_skip_end_emits_section_without_skip_function(self):
        body = [("WAIT",), ("SKIP_END",), ("push", 0), ("RET",)]
        text = emit_event({"main": (0, 0, body)})
        self.assertIn("vm.section(function()", text)
        self.assertIn("vm.wait(1)", text)
        self.assertNotIn("function(received", text)

    def test_reference_parameter_store_in_waiting_helper_is_guarded(self):
        functions = {
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("CALL", "helper"), ("POP",), ("push", 0), ("RET",)]),
            "helper": (1, 1, [
                ("WAIT",), ("push", 0), ("LOAD_ADDR", 0, POINTER_INDEX), ("push", 7), ("STORE",), ("POP",), ("push", 0), ("RET",),
            ]),
        }
        text = emit_event(functions)
        self.assertIn("vm.guard(function()", text)
        self.assertIn("return vm.guard", text)

    def test_script_without_wait_or_skip_end_has_no_skip_machinery(self):
        body = [*store_local(1), *SINK, ("LOAD", 0, LOCAL), ("EXT", 2), ("push", 0), ("RET",)]
        text = emit_event({"main": (1, 0, body)})
        self.assertNotIn("vm.section", text)
        self.assertNotIn("vm.guard", text)
        self.assertNotIn("local at", text)

    def test_skip_end_without_wait_emits_skip_end_only(self):
        body = [("SKIP_END",), ("push", 0), ("RET",)]
        text = emit_event({"main": (0, 0, body)})
        self.assertIn("vm.skip_end()", text)
        self.assertNotIn("vm.section", text)

    def test_discarded_output_keeps_its_return_slot(self):
        # get_menu_value(in, out, out): no site passes a value as the second output, so the constant there is discarded and
        # the local in the first output is kept.
        body = [
            ("push", 564), ("push", 6), ("LOAD_ADDR", 0, LOCAL), ("push", 0), ("EXT", 4),
            *SINK, ("LOAD", 0, LOCAL), ("EXT", 2), ("push", 0), ("RET",),
        ]
        text = emit_event({"main": (1, 0, body)})
        self.assertIn("local out1, _ = event.get_menu_value_3(6)", text)

    def test_value_passed_as_an_output_reaches_the_handler(self):
        # get_menu_value(2, 322, &size) reads the fish number where other sub-commands write an output, and
        # set_party_member(1, 1) adds the member where a reference would ask whether it is one: both get the value.
        body = [
            ("push", 564), ("push", 2), ("push", 322), ("LOAD_ADDR", 0, LOCAL), ("EXT", 4),
            *SINK, ("LOAD", 0, LOCAL), ("EXT", 2),
            ("push", 1078), ("push", 1), ("push", 1), ("EXT", 3),
            ("push", 0), ("RET",),
        ]
        functions = {"main": (1, 0, body)}
        text = emit_event(functions)
        self.assertIn("event.get_menu_value(2, 322)", text)
        self.assertIn("event.set_party_member(1, 1)", text)
        self.assertNotIn("discarded", text)
        if harness.HOST.exists():
            row = event_differential(functions)
            self.assertEqual((row.failed, row.lines), (0, []))
            self.assertGreater(row.passed, 0)

    def test_item_written_after_the_call_is_read_after_the_wait(self):
        # open_use_item_menu keeps the reference; the use item menu writes the chosen item when it exits, while the script waits.
        body = [
            ("push", 31), ("LOAD_ADDR", 0, LOCAL), ("push", 353), ("EXT", 3), ("WAIT",),
            *SINK, ("LOAD", 0, LOCAL), ("EXT", 2), ("push", 0), ("RET",),
        ]
        functions = {"main": (1, 0, body)}
        text = emit_event(functions)
        self.assertIn("\tevent.open_use_item_menu(353)\n\tvm.wait(1)\n\titem = vmhost.used_item() or item\n", text)
        if harness.HOST.exists():
            row = event_differential(functions)
            self.assertEqual((row.failed, row.lines), (0, []))
            self.assertGreater(row.passed, 0)

    @unittest.skipUnless(harness.HOST.exists(), "luau-harness is not built")
    def test_integral_float_prints_as_a_float(self):
        # Retail prints a float-tagged 300.0 as "300.000000", where a bare Luau number would print "300".
        functions = {"main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("pushf", 300.0), ("STORE",), ("POP",), ("LOAD", 0, LOCAL), ("PRINT", 1), ("push", 0), ("RET",)])}
        self.assertIn("print(vm.float(", emit_event(functions))
        row = event_differential(functions)
        self.assertEqual((row.failed, row.lines), (0, []))
        self.assertGreater(row.passed, 0)

    def test_numeric_and_bare_returns_in_entry_program(self):
        # Program 150 returns 1 on one path and 0 on the other; neither path may fall back to a bare return.
        functions = {
            "main": (0, 0, [("push", 0), ("RET",)]),
            "p150": (1, 0, [
                *store_local(1), ("LOAD", 0, LOCAL), ("JMP_FALSE", "zero"),
                ("push", 1), ("RET",),
                ("label", "zero"), ("push", 0), ("RET",),
            ]),
        }
        text = emit_event(functions, {150: "p150"})
        self.assertIn("\treturn 0", text)
        self.assertNotIn("\treturn", text.splitlines())



def event_differential(functions, programs=None, seeds=2):
    """Transpiles one assembled event script and runs the differential harness on it; returns its harness row."""
    result, module = transpile.transpile(EVENT_PATH, assemble(functions, "main", programs))
    if module is None:
        raise AssertionError(result.error)
    catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
    exposed = transpile.emit_corpus([(result, dataclasses.replace(module, expose_globals=True, probe_refs=True))], catalog)
    if EVENT_PATH in exposed.errors:
        raise AssertionError(exposed.errors[EVENT_PATH])
    with tempfile.TemporaryDirectory() as scratch:
        job = (result, exposed.modules[EVENT_PATH], catalog["kinds"]["event"], range(seeds), Path(scratch))
        return transpile._harness_job(job)


class RepeatSkipTest(unittest.TestCase):
    # A skip requested again at the helper's skip end runs it on to its return and the caller on in layout order, past
    # the branch and into the function whose skip end the script then suspends at.
    FUNCTIONS = {
        "main": (1, 0, [
            *store_local(0), ("CALL", "helper"), ("POP",),
            ("LOAD", 0, LOCAL), ("JMP_FALSE", "done"), ("CALL", "later"), ("POP",),
            ("label", "done"), ("push", 0), ("RET",),
        ]),
        "helper": (0, 0, [("WAIT",), ("push", 1), ("PRINT", 1), ("SKIP_END",), ("push", 2), ("PRINT", 1), ("push", 0), ("RET",)]),
        "later": (0, 0, [("push", 3), ("PRINT", 1), ("WAIT",), ("SKIP_END",), ("push", 4), ("PRINT", 1), ("push", 0), ("RET",)]),
    }

    def test_skip_end_followed_by_a_return_into_suspending_code_is_an_entry(self):
        text = emit_event(self.FUNCTIONS)
        self.assertIn("vm.entry(", text)

    @unittest.skipUnless(harness.HOST.exists(), "luau-harness is not built")
    def test_repeated_skip_matches_the_reference(self):
        row = event_differential(self.FUNCTIONS)
        self.assertEqual((row.failed, row.lines), (0, []))
        self.assertGreater(row.passed, 0)

    # A skip requested again at the helper's skip end runs the caller on past its branch, printing where the structured
    # body would not, though nothing after the skip end suspends.
    PRINTING = {
        "main": (1, 0, [
            *store_local(0), ("CALL", "helper"), ("POP",),
            ("LOAD", 0, LOCAL), ("JMP_FALSE", "done"), ("push", 5), ("PRINT", 1),
            ("label", "done"), ("push", 0), ("RET",),
        ]),
        "helper": (0, 0, [("WAIT",), ("SKIP_END",), ("push", 0), ("RET",)]),
    }

    @unittest.skipUnless(harness.HOST.exists(), "luau-harness is not built")
    def test_repeated_skip_into_a_printing_caller_matches_the_reference(self):
        row = event_differential(self.PRINTING)
        self.assertEqual((row.failed, row.lines), (0, []))
        self.assertGreater(row.passed, 0)


class SkipShapesTest(unittest.TestCase):
    # Skipping from the wait enters check, which suspends at its skip end; resumed normally there, check returns and
    # main tests what it returned.
    @staticmethod
    def conditional(returned):
        return {
            "main": (1, 0, [
                ("WAIT",), ("push", 1), ("PRINT", 1), ("CALL", "check"), ("JMP_FALSE", "no"),
                ("push", 2), ("PRINT", 1), ("label", "no"), ("push", 3), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
            "check": (0, 0, [("push", 7), ("PRINT", 1), ("WAIT",), ("SKIP_END",), ("push", returned), ("RET",)]),
        }

    def test_call_deciding_a_condition_continues_on_its_result(self):
        self.assertIn("if t0 ~= 0 then", emit_event(self.conditional(1)))

    @unittest.skipUnless(harness.HOST.exists(), "luau-harness is not built")
    def test_call_deciding_a_condition_matches_the_reference(self):
        for returned in (0, 1):
            row = event_differential(self.conditional(returned))
            self.assertEqual((row.failed, row.lines), (0, []))
            self.assertGreater(row.passed, 0)

    # In skip mode the jump leaves its operand on the stack, so the store pops the call's result as its value and the
    # zero local 2 starts with as its target: retail writes through the address 0.
    NULL_STORE = {
        "main": (1, 0, [("WAIT",), ("CALL", "setter"), ("POP",), ("push", 5), ("PRINT", 1), ("push", 0), ("RET",)]),
        "setter": (3, 0, [
            ("LOAD_ADDR", 1, LOCAL), ("LOAD", 2, LOCAL), ("JMP_FALSE", "l", 1), ("CALL", "one"), ("label", "l"),
            ("STORE",), ("POP",), ("LOAD", 1, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
        ]),
        "one": (0, 0, [("push", 1), ("RET",)]),
    }

    def test_store_through_a_starting_zero_is_planned(self):
        program = decode(assemble(self.NULL_STORE, "main"))
        found = skip.plan(program, {})
        self.assertEqual(found.errors, {})
        self.assertIsNotNone(found.discard)

    @unittest.skipUnless(harness.HOST.exists(), "luau-harness is not built")
    def test_store_through_a_starting_zero_matches_the_reference(self):
        row = event_differential(self.NULL_STORE)
        self.assertEqual((row.failed, row.lines), (0, []))
        self.assertGreater(row.passed, 0)

    # A skipped stream that indexes an array shares its function's frame table.
    ARRAY = {
        "main": (4, 0, [
            ("LOAD", 3, LOCAL), ("LOAD_ADDR", 0, AddrMode.LOCAL_INDEX), ("push", 9), ("STORE",), ("POP",),
            ("WAIT",),
            ("LOAD", 3, LOCAL), ("push", 1), ("ADD",), ("LOAD_ADDR", 0, AddrMode.LOCAL_INDEX), ("push", 4), ("STORE",), ("POP",),
            ("LOAD", 3, LOCAL), ("LOAD", 0, AddrMode.LOCAL_INDEX), ("PRINT", 1), ("SKIP_END",), ("push", 0), ("RET",),
        ]),
    }

    @unittest.skipUnless(harness.HOST.exists(), "luau-harness is not built")
    def test_stream_indexing_an_array_matches_the_reference(self):
        row = event_differential(self.ARRAY)
        self.assertEqual((row.failed, row.lines), (0, []))
        self.assertGreater(row.passed, 0)


if __name__ == "__main__":
    unittest.main()
