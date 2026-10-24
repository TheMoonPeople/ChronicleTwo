import json
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode  # noqa: E402
from stb.program import decode  # noqa: E402
from stb2luau import skip, transpile  # noqa: E402

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

    def test_linear_run_ending_at_skip_end_is_an_error(self):
        functions = {
            "main": (0, 0, [("WAIT",), ("CALL", "callee"), ("POP",), ("SKIP_END",), ("push", 0), ("RET",)]),
            "callee": (0, 0, [("push", 0), ("SKIP_END",), ("push", 0), ("RET",)]),
        }
        program = decode(assemble(functions, "main"))
        plan = skip.plan(program, {})
        self.assertIn(program.main, plan.errors)
        self.assertIn("linear run ends at SKIP_END", plan.errors[program.main])


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
        # GetMenuEtc(in, out, out): the constant in the first output is discarded, and the local in the second is kept.
        body = [
            ("push", 564), ("push", 6), ("push", 0), ("LOAD_ADDR", 0, LOCAL), ("EXT", 4),
            *SINK, ("LOAD", 0, LOCAL), ("EXT", 2), ("push", 0), ("RET",),
        ]
        text = emit_event({"main": (1, 0, body)})
        self.assertIn("local _, out", text)

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


if __name__ == "__main__":
    unittest.main()
