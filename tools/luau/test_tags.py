import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode, Op  # noqa: E402
from stb.program import decode  # noqa: E402
from stb2luau import tags  # noqa: E402

LOCAL, LOCAL_FLOAT, POINTER_INDEX_FLOAT = AddrMode.LOCAL, AddrMode.LOCAL_FLOAT, AddrMode.POINTER_INDEX_FLOAT
# Command 2 writes its one argument.
DIRECTIONS = {(2, 1): ("out",)}


def analyse(body):
    program = decode(assemble({"main": (0, 0, [("END",)]), "p100": (2, 0, body)}, "main", {100: "p100"}))
    function = program.functions[max(program.functions)]
    ext = [i.offset for i in function.instructions if i.op == Op.EXT]
    return tags.analyse(program, DIRECTIONS).calls, ext


class TagsTest(unittest.TestCase):
    def test_output_into_a_fresh_local_read_as_a_float(self):
        calls, ext = analyse([
            ("push", 2), ("LOAD_ADDR", 0, LOCAL), ("EXT", 2),
            ("LOAD", 0, LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",),
        ])
        self.assertEqual(calls[ext[0]].destinations[1], frozenset({"int"}))
        self.assertEqual(calls[ext[0]].reads[1], frozenset({"float"}))

    def test_float_load_in_a_loop_retags_for_the_next_pass(self):
        # The first pass writes into a zeroed integer slot; the float load retags it for every later pass.
        calls, ext = analyse([
            ("label", "top"), ("push", 2), ("LOAD_ADDR", 0, LOCAL), ("EXT", 2),
            ("LOAD", 0, LOCAL_FLOAT), ("PRINT", 1), ("WAIT",), ("JMP", "top"), ("END",),
        ])
        self.assertEqual(calls[ext[0]].destinations[1], frozenset({"int", "float"}))

    def test_store_ends_what_an_output_reaches(self):
        calls, ext = analyse([
            ("push", 2), ("LOAD_ADDR", 0, LOCAL), ("EXT", 2),
            ("LOAD_ADDR", 0, LOCAL), ("push", 1), ("STORE",), ("POP",),
            ("LOAD", 0, LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",),
        ])
        self.assertEqual(calls[ext[0]].reads[1], frozenset())

    def test_float_load_through_a_reference_retags_the_callers_variable(self):
        # retag(&x) loads *x as a float, which retags the caller's zeroed local before the native call writes it.
        program = decode(assemble({
            "main": (0, 0, [("END",)]),
            "p100": (1, 0, [
                ("LOAD_ADDR", 0, LOCAL), ("CALL", "retag"), ("POP",),
                ("push", 2), ("LOAD_ADDR", 0, LOCAL), ("EXT", 2),
                ("LOAD", 0, LOCAL_FLOAT), ("PRINT", 1), ("push", 0), ("RET",),
            ]),
            "retag": (1, 1, [("push", 0), ("LOAD", 0, POINTER_INDEX_FLOAT), ("POP",), ("push", 0), ("RET",)]),
        }, "main", {100: "p100"}))
        calls = tags.analyse(program, DIRECTIONS).calls
        ext = next(offset for offset, facts in calls.items() if 1 in facts.destinations)
        self.assertEqual(calls[ext].destinations[1], frozenset({"int", "float"}))

    def test_unknown_float_index_reads_native_output_in_neighbouring_local(self):
        for base, target in ((0, 1), (1, 0)):
            with self.subTest(base=base, target=target):
                calls, ext = analyse([
                    ("push", 2), ("LOAD_ADDR", target, LOCAL), ("EXT", 2),
                    ("push", 2), ("LOAD_ADDR", 1 - target, LOCAL), ("EXT", 2),
                    ("LOAD", 1 - target, LOCAL), ("LOAD", base, AddrMode.LOCAL_INDEX_FLOAT), ("PRINT", 1),
                    ("LOAD", target, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
                ])
                self.assertEqual(calls[ext[0]].reads[1], frozenset({"int", "float"}))

    def test_command_number_sums_are_folded(self):
        calls, ext = analyse([
            ("push", 1), ("push", 1), ("ADD",), ("LOAD_ADDR", 0, LOCAL), ("EXT", 2),
            ("LOAD", 0, LOCAL), ("PRINT", 1), ("push", 0), ("RET",),
        ])
        self.assertEqual(calls[ext[0]].reads[1], frozenset({"int"}))


if __name__ == "__main__":
    unittest.main()
