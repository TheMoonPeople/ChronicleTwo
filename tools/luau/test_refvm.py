import math
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode, Compare, Op  # noqa: E402
from stb.program import decode  # noqa: E402
from stb2luau.refvm import Machine, Slot, Tag, VMError, f32, float_bits  # noqa: E402

LOCAL, LOCAL_INDEX, LOCAL_FLOAT, LOCAL_INDEX_FLOAT = AddrMode.LOCAL, AddrMode.LOCAL_INDEX, AddrMode.LOCAL_FLOAT, AddrMode.LOCAL_INDEX_FLOAT
POINTER_INDEX, POINTER_INDEX_FLOAT, GLOBAL, GLOBAL_FLOAT = (
    AddrMode.POINTER_INDEX,
    AddrMode.POINTER_INDEX_FLOAT,
    AddrMode.GLOBAL,
    AddrMode.GLOBAL_FLOAT,
)


def build(functions, *, programs=None, magic="STB", global_num=0, **kwargs) -> Machine:
    return Machine(decode(assemble(functions, "main", programs, magic=magic, global_num=global_num)), **kwargs)


def run_main(body, *, local=0, programs=None, magic="STB", global_num=0, **kwargs) -> Machine:
    machine = build({"main": (local, 0, [*body, ("RET",)])}, programs=programs, magic=magic, global_num=global_num, **kwargs)
    machine.run(-1)
    return machine


def top(machine) -> Slot:
    return machine.memory[machine.sp - 1]


def store(index, value) -> list:
    return [("LOAD_ADDR", index, LOCAL), *value, ("STORE",), ("POP",)]


def pointer_call(op, mode, value) -> Machine:
    machine = build(
        {
            "main": (3, 0, [*store(1, [("push", 10)]), *store(2, [("push", value)]), ("LOAD_ADDR", 1, LOCAL), ("CALL", "readp"), ("RET",)]),
            "readp": (1, 1, [("push", 1), (op, 0, mode), ("RET",)]),
        }
    )
    machine.run(-1)
    return machine


class ArithmeticTest(unittest.TestCase):
    def test_int_operands_wrap_and_truncate(self):
        cases = [
            ("ADD", 0x7FFFFFFF, 1, -0x80000000),
            ("SUB", -0x80000000, 1, 0x7FFFFFFF),
            ("MUL", 0x10000, 0x10000, 0),
            ("DIV", -7, 2, -3),
            ("DIV", 7, -2, -3),
            ("DIV", -0x80000000, -1, -0x80000000),
            ("MOD", -7, 2, -1),
            ("MOD", 7, -2, 1),
        ]
        for op, lhs, rhs, expected in cases:
            with self.subTest(op=op, lhs=lhs, rhs=rhs):
                slot = top(run_main([("push", lhs), ("push", rhs), (op,)]))
                self.assertEqual(slot, Slot(Tag.INT, expected))

    def test_float_and_mixed_operands(self):
        cases = [
            ("ADD", ("pushf", 1.5), ("push", 2), 3.5),
            ("ADD", ("push", 2), ("pushf", 0.5), 2.5),
            ("ADD", ("pushf", 1.5), ("pushf", 0.25), 1.75),
            ("SUB", ("push", 2), ("pushf", 0.5), 1.5),
            ("SUB", ("pushf", 1.5), ("push", 2), -0.5),
            ("SUB", ("pushf", 1.5), ("pushf", 0.25), 1.25),
            ("MUL", ("pushf", 1.5), ("pushf", 0.25), 0.375),
            ("MUL", ("push", 3), ("pushf", 0.5), 1.5),
            ("MUL", ("pushf", 1.5), ("push", 4), 6.0),
            ("DIV", ("pushf", 3.0), ("push", 2), 1.5),
            ("DIV", ("push", 1), ("pushf", 4.0), 0.25),
            ("DIV", ("pushf", 1.0), ("pushf", 4.0), 0.25),
        ]
        for op, lhs, rhs, expected in cases:
            with self.subTest(op=op, lhs=lhs, rhs=rhs):
                slot = top(run_main([lhs, rhs, (op,)]))
                self.assertEqual(slot, Slot(Tag.FLOAT, expected))

    def test_float32_rounds_results_and_double_mode_does_not(self):
        body = [("pushf", 0.1), ("pushf", 0.2), ("ADD",)]
        single = top(run_main(body))
        double = top(run_main(body, float32=False))
        self.assertEqual(single.value, f32(f32(0.1) + f32(0.2)))
        self.assertEqual(double.value, 0.1 + 0.2)
        self.assertNotEqual(single.value, double.value)

    def test_double_mode_retags_integer_bits_as_their_shortest_spelling(self):
        for float32, expected in ((True, f32(0.68)), (False, 0.68)):
            with self.subTest(float32=float32):
                machine = build({"main": (0, 0, [("END",)])}, float32=float32)
                machine.memory[0] = Slot(Tag.INT, float_bits(0.68))
                machine._retag_float(0)
                self.assertEqual(machine.memory[0], Slot(Tag.FLOAT, expected))

    def test_double_mode_pushes_constants_as_their_shortest_spelling(self):
        single = top(run_main([("pushf", 0.1)]))
        double = top(run_main([("pushf", 0.1)], float32=False))
        self.assertEqual(single.value, f32(0.1))
        self.assertEqual(double.value, 0.1)
        self.assertEqual(top(run_main([("pushf", 0.64)], float32=False)).value, 0.64)


class DivisionTest(unittest.TestCase):
    def test_divide_by_integer_zero_raises(self):
        with self.assertRaisesRegex(VMError, "divide by 0"):
            run_main([("push", 1), ("push", 0), ("DIV",)])

    def test_divide_by_positive_zero_raises(self):
        with self.assertRaisesRegex(VMError, "divide by 0"):
            run_main([("push", 1), ("pushf", 0.0), ("DIV",)])

    def test_divide_by_negative_zero_is_infinite(self):
        slot = top(run_main([("push", 1), ("pushf", -0.0), ("DIV",)]))
        self.assertEqual(slot, Slot(Tag.FLOAT, -math.inf))

    def test_zero_over_negative_zero_is_nan(self):
        slot = top(run_main([("pushf", 0.0), ("pushf", -0.0), ("DIV",)]))
        self.assertTrue(math.isnan(slot.value))

    def test_modulo_by_zero_raises(self):
        with self.assertRaisesRegex(VMError, "modulo by 0"):
            run_main([("push", 1), ("push", 0), ("MOD",)])


class OperandTypeTest(unittest.TestCase):
    def test_remainder_and_bitwise_operators_reject_floats(self):
        for op in ("MOD", "AND", "OR"):
            with self.subTest(op=op):
                with self.assertRaisesRegex(VMError, "operand is not integer"):
                    run_main([("pushf", 1.5), ("push", 1), (op,)])

    def test_not_rejects_float(self):
        with self.assertRaisesRegex(VMError, "operand is not integer"):
            run_main([("pushf", 1.0), ("NOT",)])

    def test_compare_rejects_string(self):
        with self.assertRaisesRegex(VMError, "operand is not number at CMP"):
            run_main([("pushs", b"ab"), ("push", 1), ("CMP", Compare.EQ)])


class CompareTest(unittest.TestCase):
    def test_compare_int_and_mixed_operands(self):
        expected_less = {Compare.EQ: 0, Compare.NE: 1, Compare.LT: 1, Compare.LE: 1, Compare.GT: 0, Compare.GE: 0}
        expected_equal = {Compare.EQ: 1, Compare.NE: 0, Compare.LT: 0, Compare.LE: 1, Compare.GT: 0, Compare.GE: 1}
        cases = [
            (("push", 2), ("push", 3), expected_less),
            (("pushf", 2.0), ("push", 3), expected_less),
            (("push", 2), ("pushf", 3.0), expected_less),
            (("pushf", 2.0), ("pushf", 3.0), expected_less),
            (("push", 3), ("push", 3), expected_equal),
            (("pushf", 3.0), ("push", 3), expected_equal),
        ]
        for lhs, rhs, expected in cases:
            for compare, want in expected.items():
                with self.subTest(lhs=lhs, rhs=rhs, compare=compare.name):
                    slot = top(run_main([lhs, rhs, ("CMP", compare)]))
                    self.assertEqual(slot, Slot(Tag.INT, want))


class LoadTest(unittest.TestCase):
    def test_local_and_indexed_loads(self):
        self.assertEqual(top(run_main([*store(0, [("push", 5)]), ("LOAD", 0, LOCAL)], local=4)), Slot(Tag.INT, 5))
        body = [*store(3, [("push", 7)]), ("push", 2), ("LOAD", 1, LOCAL_INDEX)]
        self.assertEqual(top(run_main(body, local=4)), Slot(Tag.INT, 7))

    def test_float_loads_retag_integer_slots(self):
        machine = run_main([*store(0, [("push", 0x3F800000)]), ("LOAD", 0, LOCAL_FLOAT)], local=2)
        self.assertEqual(top(machine), Slot(Tag.FLOAT, 1.0))
        self.assertEqual(machine.memory[0].tag, Tag.FLOAT)
        machine = run_main([*store(2, [("push", 0x40000000)]), ("push", 1), ("LOAD", 1, LOCAL_INDEX_FLOAT)], local=3)
        self.assertEqual(top(machine), Slot(Tag.FLOAT, 2.0))
        self.assertEqual(machine.memory[2].tag, Tag.FLOAT)

    def test_float_retag_rejects_string_slot(self):
        with self.assertRaisesRegex(VMError, "non-integer"):
            run_main([*store(0, [("pushs", b"x")]), ("LOAD", 0, LOCAL_FLOAT)], local=1)

    def test_global_loads(self):
        body = [("LOAD_ADDR", 1, GLOBAL), ("push", 9), ("STORE",), ("POP",), ("LOAD", 1, GLOBAL)]
        self.assertEqual(top(run_main(body, magic="SB2", global_num=2)), Slot(Tag.INT, 9))
        body = [("LOAD_ADDR", 1, GLOBAL), ("push", 0x3F800000), ("STORE",), ("POP",), ("LOAD", 1, GLOBAL_FLOAT)]
        machine = run_main(body, magic="SB2", global_num=2)
        self.assertEqual(top(machine), Slot(Tag.FLOAT, 1.0))
        self.assertEqual(machine.memory[1].tag, Tag.FLOAT)

    def test_global_access_without_globals_raises(self):
        with self.assertRaisesRegex(VMError, "no globals"):
            run_main([("LOAD", 0, GLOBAL)])

    def test_pointer_index_through_call_argument(self):
        self.assertEqual(top(pointer_call("LOAD", POINTER_INDEX, 20)), Slot(Tag.INT, 20))

    def test_pointer_index_float_retags_target(self):
        machine = pointer_call("LOAD", POINTER_INDEX_FLOAT, 0x3F800000)
        self.assertEqual(top(machine), Slot(Tag.FLOAT, 1.0))
        self.assertEqual(machine.memory[2].tag, Tag.FLOAT)

    def test_unknown_address_mode_pushes_nothing(self):
        machine = run_main([("push", 9), ("LOAD", 0, 0x80)])
        self.assertEqual(machine.sp, 1)


class AddressTest(unittest.TestCase):
    def test_local_load_addr_pushes_pointers_without_retagging(self):
        cases = [
            (LOCAL, [], 2),
            (LOCAL_INDEX, [("push", 1)], 3),
            (LOCAL_FLOAT, [], 2),
            (LOCAL_INDEX_FLOAT, [("push", 1)], 3),
        ]
        for mode, index, expected in cases:
            with self.subTest(mode=mode.name):
                body = [*store(2, [("push", 0x3F800000)]), *index, ("LOAD_ADDR", 2, mode)]
                machine = run_main(body, local=4)
                self.assertEqual(top(machine), Slot(Tag.PTR, expected))
                self.assertEqual(machine.memory[2], Slot(Tag.INT, 0x3F800000))

    def test_global_load_addr_pushes_pointers_without_retagging(self):
        for mode in (GLOBAL, GLOBAL_FLOAT):
            with self.subTest(mode=mode.name):
                body = [("push", 0x3F800000), ("LOAD_ADDR", 1, mode)]
                machine = run_main(body, magic="SB2", global_num=2)
                self.assertEqual(top(machine), Slot(Tag.PTR, 1))

    def test_pointer_load_addr_modes(self):
        self.assertEqual(top(pointer_call("LOAD_ADDR", POINTER_INDEX, 20)), Slot(Tag.PTR, 2))
        machine = pointer_call("LOAD_ADDR", POINTER_INDEX_FLOAT, 0x3F800000)
        self.assertEqual(top(machine), Slot(Tag.PTR, 2))
        self.assertEqual(machine.memory[2], Slot(Tag.INT, 0x3F800000))


class StoreTest(unittest.TestCase):
    def test_store_chain_pushes_its_value(self):
        body = [("LOAD_ADDR", 0, LOCAL), ("LOAD_ADDR", 1, LOCAL), ("push", 5), ("STORE",), ("STORE",)]
        machine = run_main(body, local=2)
        self.assertEqual(top(machine), Slot(Tag.INT, 5))
        self.assertEqual(machine.memory[0], Slot(Tag.INT, 5))
        self.assertEqual(machine.memory[1], Slot(Tag.INT, 5))

    def test_store_through_non_pointer_raises(self):
        with self.assertRaisesRegex(VMError, "non-pointer"):
            run_main([("push", 1), ("push", 2), ("STORE",)])

    def test_store_through_a_reference_reaches_the_caller(self):
        functions = {
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("CALL", "set"), ("POP",), ("LOAD", 0, LOCAL), ("RET",)]),
            "set": (1, 1, [("push", 0), ("LOAD_ADDR", 0, POINTER_INDEX), ("push", 9), ("STORE",), ("POP",), ("push", 0), ("RET",)]),
        }
        machine = build(functions)
        machine.run(-1)
        self.assertEqual(machine.result, 9)


class Reporting(Machine):
    """A machine that records each access outside the running function's frame."""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.reports = []

    def outside_frame(self, access, address):
        self.reports.append((access, address))


class FrameTest(unittest.TestCase):
    def test_index_past_an_array_reaches_the_next_local(self):
        body = [*store(2, [("push", 6)]), ("push", 1), ("LOAD", 1, LOCAL_INDEX)]
        self.assertEqual(top(run_main(body, local=3)), Slot(Tag.INT, 6))

    def test_local_index_below_the_frame_reaches_the_callers_frame(self):
        functions = {
            "main": (1, 0, [*store(0, [("push", 42)]), ("CALL", "f"), ("RET",)]),
            "f": (1, 0, [("push", -1), ("LOAD", 0, LOCAL_INDEX), ("RET",)]),
        }
        machine = Reporting(decode(assemble(functions, "main")))
        machine.run(-1)
        self.assertEqual(machine.result, 42)
        self.assertEqual(machine.reports, [("local index below the frame", 0)])

    def test_load_past_the_frame_reads_the_operand_stack(self):
        body = [("push", 7), ("push", 8), ("POP",), ("POP",), ("push", 2), ("LOAD", 1, LOCAL_INDEX)]
        machine = Reporting(decode(assemble({"main": (2, 0, [*body, ("RET",)])}, "main")))
        machine.run(-1)
        self.assertEqual(machine.result, 8)
        self.assertEqual(machine.reports, [("load past the frame", 3)])

    def test_store_past_the_frame_writes_the_operand_stack(self):
        # Retail writes through the pointer, here into a free operand-stack slot above the stored value it pushes.
        body = [("push", 2), ("LOAD_ADDR", 1, LOCAL_INDEX), ("push", 5), ("STORE",), ("POP",), ("push", 0)]
        machine = Reporting(decode(assemble({"main": (2, 0, [*body, ("RET",)])}, "main")))
        machine.run(-1)
        self.assertEqual(machine.memory[3], Slot(Tag.INT, 5))
        self.assertEqual(machine.reports, [("store past the frame", 3)])

    def test_access_inside_the_frame_is_not_reported(self):
        machine = Reporting(decode(assemble({"main": (2, 0, [*store(1, [("push", 3)]), ("push", 1), ("LOAD", 0, LOCAL_INDEX), ("RET",)])}, "main")))
        machine.run(-1)
        self.assertEqual(machine.result, 3)
        self.assertEqual(machine.reports, [])

    def test_address_past_the_frame_is_allowed(self):
        machine = run_main([("push", 2), ("LOAD_ADDR", 1, LOCAL_INDEX)], local=2)
        self.assertEqual(top(machine), Slot(Tag.PTR, 3))

    def test_returned_reports_the_call_and_the_callee_frame(self):
        functions = {
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("CALL", "f"), ("RET",)]),
            "f": (1, 1, [("push", 0), ("RET",)]),
        }
        returns = []

        class Recording(Machine):
            def returned(self, call, callee, frame):
                returns.append((call, callee, frame, self.memory[frame]))

        program = decode(assemble(functions, "main"))
        machine = Recording(program)
        machine.run(-1)
        call = next(i for i in program.functions[program.main].instructions if i.op == Op.CALL)
        self.assertEqual(returns, [(call.offset, program.callee(call).block, 1, Slot(Tag.PTR, 0))])


class ShortCircuitTest(unittest.TestCase):
    def test_jump_false_with_flag_pushes_zero_when_taken(self):
        machine = run_main([("push", 0), ("JMP_FALSE", "end", 1), ("push", 99), ("label", "end")])
        self.assertEqual(top(machine), Slot(Tag.INT, 0))
        self.assertEqual(machine.sp, 1)

    def test_jump_true_with_flag_pushes_one_when_taken(self):
        machine = run_main([("push", 5), ("JMP_TRUE", "end", 1), ("push", 99), ("label", "end")])
        self.assertEqual(top(machine), Slot(Tag.INT, 1))
        self.assertEqual(machine.sp, 1)

    def test_untaken_jumps_only_pop(self):
        machine = run_main([("push", 1), ("JMP_FALSE", "end", 1), ("push", 7), ("label", "end")])
        self.assertEqual(top(machine), Slot(Tag.INT, 7))
        self.assertEqual(machine.sp, 1)
        machine = run_main([("push", 0), ("JMP_TRUE", "end", 1), ("push", 8), ("label", "end")])
        self.assertEqual(top(machine), Slot(Tag.INT, 8))
        self.assertEqual(machine.sp, 1)


class LoopTest(unittest.TestCase):
    def test_while_loop_counts_to_five(self):
        body = [
            *store(0, [("push", 0)]),
            ("label", "top"),
            ("LOAD", 0, LOCAL),
            ("push", 5),
            ("CMP", Compare.LT),
            ("JMP_FALSE", "end", 0),
            *store(0, [("LOAD", 0, LOCAL), ("push", 1), ("ADD",)]),
            ("JMP", "top"),
            ("label", "end"),
            ("LOAD", 0, LOCAL),
        ]
        self.assertEqual(top(run_main(body, local=1)), Slot(Tag.INT, 5))

    def test_do_while_loops_backward_on_true(self):
        body = [
            *store(0, [("push", 0)]),
            ("label", "top"),
            *store(0, [("LOAD", 0, LOCAL), ("push", 1), ("ADD",)]),
            ("LOAD", 0, LOCAL),
            ("push", 3),
            ("CMP", Compare.LT),
            ("JMP_TRUE", "top", 0),
            ("LOAD", 0, LOCAL),
        ]
        self.assertEqual(top(run_main(body, local=1)), Slot(Tag.INT, 3))

    def test_nested_loops_with_break(self):
        body = [
            *store(0, [("push", 0)]),
            *store(2, [("push", 0)]),
            ("label", "outer"),
            ("LOAD", 0, LOCAL),
            ("push", 3),
            ("CMP", Compare.LT),
            ("JMP_FALSE", "done", 0),
            *store(1, [("push", 0)]),
            ("label", "inner"),
            ("LOAD", 1, LOCAL),
            ("push", 5),
            ("CMP", Compare.LT),
            ("JMP_FALSE", "inner_done", 0),
            ("LOAD", 1, LOCAL),
            ("push", 2),
            ("CMP", Compare.EQ),
            ("JMP_TRUE", "inner_done", 0),
            *store(2, [("LOAD", 2, LOCAL), ("push", 1), ("ADD",)]),
            *store(1, [("LOAD", 1, LOCAL), ("push", 1), ("ADD",)]),
            ("JMP", "inner"),
            ("label", "inner_done"),
            *store(0, [("LOAD", 0, LOCAL), ("push", 1), ("ADD",)]),
            ("JMP", "outer"),
            ("label", "done"),
            ("LOAD", 2, LOCAL),
        ]
        self.assertEqual(top(run_main(body, local=3)), Slot(Tag.INT, 6))


class CallTest(unittest.TestCase):
    def test_arguments_are_passed_and_extra_locals_zeroed(self):
        functions = {
            "main": (2, 0, [("push", 99), ("push", 98), ("POP",), ("POP",), ("push", 5), ("CALL", "zero"), ("RET",)]),
            "zero": (2, 1, [("LOAD", 1, LOCAL), ("LOAD", 0, LOCAL), ("ADD",), ("RET",)]),
        }
        machine = build(functions)
        machine.run(-1)
        self.assertEqual(top(machine), Slot(Tag.INT, 5))

    def test_nested_calls_return_values(self):
        functions = {
            "main": (0, 0, [("push", 3), ("CALL", "f"), ("RET",)]),
            "f": (1, 1, [("LOAD", 0, LOCAL), ("CALL", "g"), ("push", 2), ("MUL",), ("RET",)]),
            "g": (1, 1, [("LOAD", 0, LOCAL), ("push", 1), ("ADD",), ("RET",)]),
        }
        machine = build(functions)
        machine.run(-1)
        self.assertEqual(top(machine), Slot(Tag.INT, 8))

    def test_top_level_return_sets_result(self):
        machine = run_main([("push", 42)])
        self.assertEqual(machine.result, 42)
        self.assertEqual(machine.end, 1)
        machine = run_main([("pushf", 1.5)])
        self.assertEqual(machine.result, float_bits(1.5))

    def test_recursion_overflows_call_stack(self):
        functions = {
            "main": (0, 0, [("CALL", "f"), ("RET",)]),
            "f": (0, 0, [("CALL", "f"), ("RET",)]),
        }
        with self.assertRaisesRegex(VMError, "call stack overflow"):
            build(functions, call_num=2).run(-1)


class ExtTest(unittest.TestCase):
    def test_ext_receives_command_and_arguments_and_writes_through_pointer(self):
        calls = []

        def ext(machine, base, argc):
            calls.append((machine.read_arg(base).value, argc))
            destination = machine.read_arg(base + 1)
            total = machine.read_arg(base + 2).value + machine.read_arg(base + 3).value
            machine.write(destination.value, Slot(Tag.INT, total))

        body = [("push", 3), ("LOAD_ADDR", 0, LOCAL), ("push", 4), ("push", 5), ("EXT", 4), ("LOAD", 0, LOCAL)]
        machine = run_main(body, local=1, ext=ext)
        self.assertEqual(calls, [(3, 4)])
        self.assertEqual(top(machine), Slot(Tag.INT, 9))

    def test_default_ext_logs_unknown_command(self):
        machine = run_main([("push", 3), ("push", 4), ("EXT", 2), ("push", 0)])
        self.assertEqual(machine.log, [b"not found ext 3\n"])
        self.assertEqual(machine.sp, 1)


class SuspendTest(unittest.TestCase):
    def test_wait_suspends_and_resume_continues(self):
        machine = build({"main": (0, 0, [("push", 1), ("WAIT",), ("push", 2), ("ADD",), ("RET",)])})
        self.assertEqual(machine.run(-1), 1)
        self.assertEqual(machine.end, 0)
        self.assertEqual(machine.waits, 1)
        machine.resume()
        self.assertEqual(machine.end, 1)
        self.assertEqual(top(machine), Slot(Tag.INT, 3))

    def test_skip_runs_through_waits_to_skip_end(self):
        calls = []
        body = [
            ("push", 10),
            ("WAIT",),
            ("push", 0),
            ("JMP_FALSE", "skip", 0),
            ("push", 7),
            ("push", 1),
            ("EXT", 2),
            ("label", "skip"),
            ("SKIP_END",),
            ("push", 3),
        ]
        machine = build({"main": (0, 0, [*body, ("RET",)])}, ext=lambda m, b, c: calls.append(c))
        self.assertEqual(machine.run(-1), 1)
        machine.skip()
        self.assertEqual(machine.end, 0)
        self.assertEqual(machine.skip_end_count, 1)
        self.assertEqual(machine.skip_wait, 0)
        self.assertEqual(machine.waits, 1)
        self.assertEqual(calls, [])
        self.assertEqual(machine.sp, 2)
        self.assertEqual(machine.memory[1], Slot(Tag.INT, 0))
        machine.resume()
        self.assertEqual(machine.end, 1)
        self.assertEqual(top(machine), Slot(Tag.INT, 3))


class PrintTest(unittest.TestCase):
    def test_print_formats_int_string_and_float(self):
        machine = run_main([("push", -4), ("pushs", b"ab"), ("pushf", 1.5), ("PRINT", 3), ("push", 0)])
        self.assertEqual(bytes(machine.output), b"-4ab1.500000")

    def test_print_of_pointer_writes_nothing(self):
        machine = run_main([("LOAD_ADDR", 0, LOCAL), ("PRINT", 1)], local=1)
        self.assertEqual(bytes(machine.output), b"")


class ProgramTest(unittest.TestCase):
    def test_programs_are_selected_by_number(self):
        machine = build(
            {"main": (0, 0, [("push", 0), ("RET",)]), "event": (0, 0, [("WAIT",), ("END",)])},
            programs={100: "event"},
        )
        self.assertEqual(machine.run(5), -1)
        self.assertEqual(machine.log, [b"not found program 5\n"])
        self.assertTrue(machine.check_program(100))
        self.assertFalse(machine.check_program(5))
        self.assertEqual(machine.run(-1), 0)
        self.assertEqual(machine.run(100), 1)
        machine.resume()
        self.assertEqual(machine.end, 1)


class LimitTest(unittest.TestCase):
    def test_frame_larger_than_stack_overflows(self):
        with self.assertRaisesRegex(VMError, "stack overflow"):
            build({"main": (5, 0, [("RET",)])}, stack_num=4).run(-1)

    def test_push_past_stack_end_overflows(self):
        body = [("push", 1), ("push", 2), ("push", 3), ("push", 4), ("RET",)]
        with self.assertRaisesRegex(VMError, "stack overflow"):
            build({"main": (0, 0, body)}, stack_num=3).run(-1)

    def test_step_budget_stops_endless_loop(self):
        body = [("label", "top"), ("JMP", "top"), ("RET",)]
        with self.assertRaisesRegex(VMError, "step budget exceeded"):
            build({"main": (0, 0, body)}, max_steps=10).run(-1)


if __name__ == "__main__":
    unittest.main()
