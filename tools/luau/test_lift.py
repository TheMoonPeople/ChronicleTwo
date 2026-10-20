import dataclasses
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.analysis import Analysis  # noqa: E402
from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode, Compare, Op  # noqa: E402
from stb.program import decode  # noqa: E402
from stb2luau import ir  # noqa: E402
from stb2luau.ir import FLOAT, INT, STR  # noqa: E402
from stb2luau.lift import LiftError, lift  # noqa: E402

LOCAL, LOCAL_INDEX, POINTER_INDEX = AddrMode.LOCAL, AddrMode.LOCAL_INDEX, AddrMode.POINTER_INDEX
LOCAL_FLOAT, POINTER_INDEX_FLOAT = AddrMode.LOCAL_FLOAT, AddrMode.POINTER_INDEX_FLOAT
GLOBAL = AddrMode.GLOBAL


def plain(statements):
    """Statements with their instruction offsets cleared, for comparison against expected trees."""
    return [dataclasses.replace(s, offset=-1) if hasattr(s, "offset") else s for s in statements]


def local(n, type_=INT):
    return ir.Var(("local", n), type_)


def const(value, type_=INT):
    return ir.Const(value, type_)


def lift_named(functions, name, main="main"):
    """Lift the named function of an assembled program, whose functions are laid out in the order they are given."""
    program = decode(assemble(functions, main))
    block = sorted(program.functions)[list(functions).index(name)]
    return program, lift(program, program.functions[block], Analysis(program))


# A loop that stores i into arr[i] for i = 0, 1, 2, with arr at locals 1-3 and i at local 0, then prints arr[1].
ARRAY_LOOP = [
    ("LOAD_ADDR", 0, LOCAL), ("push", 0), ("STORE",), ("POP",),
    ("label", "top"),
    ("LOAD", 0, LOCAL), ("push", 3), ("CMP", Compare.LT), ("JMP_FALSE", "end"),
    ("LOAD", 0, LOCAL), ("LOAD_ADDR", 1, LOCAL_INDEX), ("LOAD", 0, LOCAL), ("STORE",), ("POP",),
    ("LOAD_ADDR", 0, LOCAL), ("LOAD", 0, LOCAL), ("push", 1), ("ADD",), ("STORE",), ("POP",),
    ("JMP", "top"),
    ("label", "end"),
    ("push", 1), ("LOAD", 1, LOCAL_INDEX), ("PRINT", 1),
    ("END",),
]


class LiftTest(unittest.TestCase):
    def lift_main(self, functions):
        program = decode(assemble(functions, "main"))
        return program, lift(program, program.functions[program.main], Analysis(program))

    def test_sum_that_may_overflow_wraps(self):
        # x = 2147483647; x = x + 1 wraps to -2147483648 on the PS2.
        body = [
            ("LOAD_ADDR", 0, LOCAL), ("push", 2147483647), ("STORE",), ("POP",),
            ("LOAD_ADDR", 0, LOCAL), ("LOAD", 0, LOCAL), ("push", 1), ("ADD",), ("STORE",), ("POP",),
            ("LOAD", 0, LOCAL), ("PRINT", 1), ("END",),
        ]
        _, lifted = self.lift_main({"main": (1, 0, body)})
        statements = plain(lifted.blocks[lifted.entry].statements)
        self.assertEqual(statements[1], ir.Assign(("local", 0), ir.Binary("add", local(0), const(1), INT, wrap=True)))

    def test_sum_that_stays_in_range_does_not_wrap(self):
        _, lifted = self.lift_main({"main": (4, 0, ARRAY_LOOP)})
        increments = [
            statement.value
            for block in lifted.blocks.values()
            for statement in block.statements
            if isinstance(statement, ir.Assign) and statement.target == ("local", 0)
            and isinstance(statement.value, ir.Binary)
        ]
        self.assertEqual(increments, [ir.Binary("add", local(0), const(1), INT)])

    def test_guarded_decrement_of_a_global_does_not_wrap(self):
        # if g > 0 then g = g - 1 end, with g a global the function knows nothing else about.
        body = [
            ("LOAD", 0, GLOBAL), ("push", 0), ("CMP", Compare.GT), ("JMP_FALSE", "done"),
            ("LOAD_ADDR", 0, GLOBAL), ("LOAD", 0, GLOBAL), ("push", 1), ("SUB",), ("STORE",), ("POP",),
            ("label", "done"), ("END",),
        ]
        program = decode(assemble({"main": (0, 0, body)}, "main", magic="SB2", global_num=1))
        lifted = lift(program, program.functions[program.main], Analysis(program))
        values = [s.value for b in lifted.blocks.values() for s in b.statements if isinstance(s, ir.Assign)]
        self.assertEqual(values, [ir.Binary("sub", ir.Var(("global", 0), INT), const(1), INT)])

    def test_negation_and_product_of_an_unknown_integer_wrap(self):
        functions = {
            "main": (0, 0, [("END",)]),
            "f": (1, 1, [("LOAD", 0, LOCAL), ("NEG",), ("LOAD", 0, LOCAL), ("push", 2), ("MUL",), ("ADD",), ("RET",)]),
        }
        _, lifted = lift_named(functions, "f")
        value = plain(lifted.blocks[lifted.entry].statements)[0].value
        negation = ir.Unary("neg", local(0), INT, wrap=True)
        product = ir.Binary("mul", local(0), const(2), INT, wrap=True)
        self.assertEqual(value, ir.Binary("add", negation, product, INT, wrap=True))

    def test_constant_folding(self):
        _, lifted = self.lift_main({
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("push", 60), ("push", 15), ("ADD",), ("STORE",), ("POP",), ("END",)]),
        })
        block = lifted.blocks[lifted.entry]
        self.assertEqual(plain(block.statements), [ir.Assign(("local", 0), const(75)), ir.End()])
        self.assertIsInstance(block.exit, ir.Stop)

    def test_store_then_pop_is_one_assign(self):
        _, lifted = self.lift_main({
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("push", 5), ("STORE",), ("POP",), ("END",)]),
        })
        statements = lifted.blocks[lifted.entry].statements
        self.assertEqual(plain(statements), [ir.Assign(("local", 0), const(5)), ir.End()])
        self.assertEqual(lifted.slot_types[("local", 0)], INT)
        self.assertEqual(lifted.temps, [])

    def test_assignment_chain(self):
        _, lifted = self.lift_main({
            "main": (2, 0, [("LOAD_ADDR", 0, LOCAL), ("LOAD_ADDR", 1, LOCAL), ("push", 5), ("STORE",), ("STORE",), ("POP",), ("END",)]),
        })
        statements = lifted.blocks[lifted.entry].statements
        self.assertEqual(plain(statements), [
            ir.Assign(("local", 1), const(5)),
            ir.Assign(("local", 0), local(1)),
            ir.End(),
        ])

    def test_while_loop_blocks_and_branches(self):
        _, lifted = self.lift_main({
            "main": (1, 0, [
                ("LOAD_ADDR", 0, LOCAL), ("push", 0), ("STORE",), ("POP",),
                ("label", "top"),
                ("LOAD", 0, LOCAL), ("push", 3), ("CMP", Compare.LT), ("JMP_FALSE", "end"),
                ("LOAD_ADDR", 0, LOCAL), ("LOAD", 0, LOCAL), ("push", 1), ("ADD",), ("STORE",), ("POP",),
                ("JMP", "top"),
                ("label", "end"), ("END",),
            ]),
        })
        entry, top, body, end = sorted(lifted.blocks)
        self.assertEqual(lifted.blocks[entry].exit, ir.Jump(top))
        self.assertEqual(plain(lifted.blocks[top].statements), [])
        self.assertEqual(lifted.blocks[top].exit, ir.Branch(ir.Compare(Compare.LT, local(0), const(3)), body, end))
        self.assertEqual(plain(lifted.blocks[body].statements), [ir.Assign(("local", 0), ir.Binary("add", local(0), const(1), INT))])
        self.assertEqual(lifted.blocks[body].exit, ir.Jump(top))
        self.assertEqual(plain(lifted.blocks[end].statements), [ir.End()])

    def test_jump_orientation(self):
        _, false_lifted = self.lift_main({
            "main": (0, 0, [("push", 1), ("JMP_FALSE", "end"), ("push", 2), ("POP",), ("label", "end"), ("END",)]),
        })
        entry, fall, end = sorted(false_lifted.blocks)
        self.assertEqual(false_lifted.blocks[entry].exit, ir.Branch(const(1), fall, end))
        self.assertEqual(false_lifted.blocks[fall].exit, ir.Jump(end))

        _, true_lifted = self.lift_main({
            "main": (0, 0, [("push", 1), ("JMP_TRUE", "end"), ("push", 2), ("POP",), ("label", "end"), ("END",)]),
        })
        entry, fall, end = sorted(true_lifted.blocks)
        self.assertEqual(true_lifted.blocks[entry].exit, ir.Branch(const(1), end, fall))

    def test_logical_and_or(self):
        _, lifted = self.lift_main({
            "main": (2, 0, [
                ("LOAD", 0, LOCAL), ("JMP_FALSE", "l", 1), ("LOAD", 1, LOCAL), ("label", "l"),
                ("JMP_FALSE", "out"), ("END",), ("label", "out"), ("END",),
            ]),
        })
        entry, fall, out = sorted(lifted.blocks)
        conditional = ir.Logical("and", local(0), local(1), INT)
        self.assertEqual(lifted.blocks[entry].exit, ir.Branch(conditional, fall, out))

        _, lifted = self.lift_main({
            "main": (2, 0, [
                ("LOAD", 0, LOCAL), ("JMP_TRUE", "l", 1), ("LOAD", 1, LOCAL), ("label", "l"),
                ("JMP_FALSE", "out"), ("END",), ("label", "out"), ("END",),
            ]),
        })
        entry, fall, out = sorted(lifted.blocks)
        self.assertEqual(lifted.blocks[entry].exit, ir.Branch(ir.Logical("or", local(0), local(1), INT), fall, out))

    def test_nested_short_circuit(self):
        _, lifted = self.lift_main({
            "main": (3, 0, [
                ("LOAD", 0, LOCAL), ("JMP_FALSE", "l1", 1), ("LOAD", 1, LOCAL), ("JMP_TRUE", "l2", 1),
                ("LOAD", 2, LOCAL), ("label", "l2"), ("label", "l1"),
                ("JMP_FALSE", "out"), ("END",), ("label", "out"), ("END",),
            ]),
        })
        entry, fall, out = sorted(lifted.blocks)
        condition = ir.Logical("and", local(0), ir.Logical("or", local(1), local(2), INT), INT)
        self.assertEqual(lifted.blocks[entry].exit, ir.Branch(condition, fall, out))
        self.assertEqual(lifted.blocks[entry].statements, [])

    def test_short_circuit_value_stored(self):
        _, lifted = self.lift_main({
            "main": (3, 0, [
                ("LOAD_ADDR", 0, LOCAL), ("LOAD", 1, LOCAL), ("JMP_FALSE", "l", 1), ("LOAD", 2, LOCAL),
                ("label", "l"), ("STORE",), ("POP",), ("END",),
            ]),
        })
        statements = lifted.blocks[lifted.entry].statements
        self.assertEqual(plain(statements), [
            ir.Assign(("local", 0), ir.Logical("and", local(1), local(2), INT)),
            ir.End(),
        ])
        self.assertEqual(len(lifted.blocks), 1)

    def test_external_call_with_address_argument(self):
        _, lifted = self.lift_main({
            "main": (2, 0, [("push", 9), ("LOAD_ADDR", 0, LOCAL), ("push", 7), ("EXT", 3), ("END",)]),
        })
        self.assertEqual(plain(lifted.blocks[lifted.entry].statements), [
            ir.ExtCall(9, (ir.Addr(("local", 0), INT), const(7))),
            ir.End(),
        ])

    def test_spill_before_external_write(self):
        _, lifted = self.lift_main({
            "main": (2, 0, [
                ("LOAD_ADDR", 1, LOCAL), ("LOAD", 0, LOCAL), ("push", 9), ("LOAD_ADDR", 0, LOCAL),
                ("EXT", 2), ("STORE",), ("POP",), ("END",),
            ]),
        })
        self.assertEqual(plain(lifted.blocks[lifted.entry].statements), [
            ir.Assign(ir.Temp(0, INT), local(0)),
            ir.ExtCall(9, (ir.Addr(("local", 0), INT),)),
            ir.Assign(("local", 1), ir.Temp(0, INT)),
            ir.End(),
        ])
        self.assertEqual(lifted.temps, [INT])

    def test_call_statement_and_expression(self):
        program, lifted = self.lift_main({
            "f": (1, 1, [("LOAD", 0, LOCAL), ("RET",)]),
            "main": (1, 0, [
                ("push", 4), ("CALL", "f"), ("POP",),
                ("LOAD_ADDR", 0, LOCAL), ("push", 1), ("CALL", "f"), ("STORE",), ("POP",), ("END",),
            ]),
        })
        callee = min(block for block in program.functions if block != program.main)
        self.assertEqual(plain(lifted.blocks[lifted.entry].statements), [
            ir.CallStmt(ir.Call(callee, (const(4),), INT)),
            ir.Assign(("local", 0), ir.Call(callee, (const(1),), INT)),
            ir.End(),
        ])

    def test_return_and_end_exits(self):
        program, lifted = self.lift_main({
            "f": (1, 1, [("LOAD", 0, LOCAL), ("RET",)]),
            "main": (0, 0, [("push", 0), ("CALL", "f"), ("POP",), ("END",)]),
        })
        callee = min(block for block in program.functions if block != program.main)
        self.assertEqual(plain(lifted.blocks[lifted.entry].statements), [ir.CallStmt(ir.Call(callee, (const(0),), INT)), ir.End()])
        self.assertIsInstance(lifted.blocks[lifted.entry].exit, ir.Stop)
        callee_lifted = lift(program, program.functions[callee], Analysis(program))
        block = callee_lifted.blocks[callee_lifted.entry]
        self.assertEqual(plain(block.statements), [ir.Return(local(0))])
        self.assertIsInstance(block.exit, ir.Stop)

    def test_computed_index_in_bounds_makes_an_array_table(self):
        _, lifted = self.lift_main({"main": (4, 0, ARRAY_LOOP)})
        self.assertEqual(lifted.arrays, {("array", 1): 3})
        body = next(block for block in lifted.blocks.values() if any(isinstance(s, ir.Assign) and isinstance(s.target, ir.Elem) for s in block.statements))
        element = ir.Elem(("array", 1), local(0), INT)
        self.assertEqual(plain(body.statements)[0], ir.Assign(element, local(0)))
        end = lifted.blocks[max(lifted.blocks)]
        self.assertEqual(plain(end.statements)[0], ir.Print((ir.Elem(("array", 1), const(1), INT),)))

    def test_array_runs_to_the_next_named_slot(self):
        # arr at local 1 is followed by an unnamed slot 2 and the variable at local 3.
        body = [
            ("LOAD", 0, LOCAL), ("LOAD", 1, LOCAL_INDEX), ("LOAD", 3, LOCAL), ("ADD",), ("PRINT", 1), ("END",),
        ]
        _, lifted = self.lift_main({"main": (5, 0, body)})
        self.assertEqual(lifted.arrays, {("array", 1): 2})

    def test_unbounded_index_makes_the_frame_one_table(self):
        # The index comes from a native output, so it may reach the neighbouring variables.
        body = [
            ("push", 2), ("LOAD_ADDR", 0, LOCAL), ("EXT", 2),
            ("LOAD", 0, LOCAL), ("LOAD_ADDR", 1, LOCAL_INDEX), ("push", 7), ("STORE",), ("POP",),
            ("LOAD", 3, LOCAL), ("PRINT", 1), ("END",),
        ]
        _, lifted = self.lift_main({"main": (4, 0, body)})
        self.assertEqual(lifted.arrays, {("frame", 0): 4})
        statements = plain(lifted.blocks[lifted.entry].statements)
        frame = ("frame", 0)
        self.assertEqual(statements[0], ir.ExtCall(2, (ir.Addr(frame, INT, const(0)),)))
        # A native output may be any 32-bit value, so the slot address it gives may wrap.
        index = ir.Binary("add", ir.Elem(frame, const(0), INT), const(1), INT, wrap=True)
        self.assertEqual(statements[1], ir.Assign(ir.Elem(frame, index, INT), const(7)))
        self.assertEqual(statements[2], ir.Print((ir.Elem(frame, const(3), INT),)))

    def test_loop_bound_by_a_guarded_counter_stays_in_bounds(self):
        # count rises by one only while it is below 3, and i runs while i < count, so arr[i] stays in its 3 slots.
        body = [
            ("label", "outer"),
            ("push", 1), ("JMP_FALSE", "done"),
            ("LOAD", 4, LOCAL), ("push", 3), ("CMP", Compare.LT), ("JMP_FALSE", "skip"),
            ("LOAD_ADDR", 4, LOCAL), ("LOAD", 4, LOCAL), ("push", 1), ("ADD",), ("STORE",), ("POP",),
            ("label", "skip"),
            ("LOAD_ADDR", 0, LOCAL), ("push", 0), ("STORE",), ("POP",),
            ("label", "inner"),
            ("LOAD", 0, LOCAL), ("LOAD", 4, LOCAL), ("CMP", Compare.LT), ("JMP_FALSE", "next"),
            ("LOAD", 0, LOCAL), ("LOAD", 1, LOCAL_INDEX), ("PRINT", 1),
            ("LOAD_ADDR", 0, LOCAL), ("LOAD", 0, LOCAL), ("push", 1), ("ADD",), ("STORE",), ("POP",),
            ("JMP", "inner"),
            ("label", "next"),
            ("WAIT",),
            ("JMP", "outer"),
            ("label", "done"),
            ("END",),
        ]
        _, lifted = self.lift_main({"main": (5, 0, body)})
        self.assertEqual(lifted.arrays, {("array", 1): 3})

    def test_constant_index_past_the_frame_is_an_operand_stack_address(self):
        _, lifted = self.lift_main({
            "main": (2, 0, [("push", 2), ("push", 2), ("LOAD_ADDR", 0, LOCAL_INDEX), ("EXT", 2), ("END",)]),
        })
        statements = plain(lifted.blocks[lifted.entry].statements)
        self.assertEqual(statements[0], ir.ExtCall(2, (ir.Addr(("stack", 2), INT),)))

    def test_native_output_over_a_live_operand_raises(self):
        # 99 waits on the stack for the PRINT while the call's output, slot 0 of a frame with no locals, overwrites it.
        with self.assertRaisesRegex(LiftError, "overwrites an operand"):
            self.lift_main({
                "main": (0, 0, [
                    ("push", 99), ("push", 2), ("push", 0), ("LOAD_ADDR", 0, LOCAL_INDEX), ("EXT", 2), ("PRINT", 1),
                    ("END",),
                ]),
            })

    def test_native_output_over_an_argument_of_its_own_call_raises(self):
        with self.assertRaisesRegex(LiftError, "argument of its own call"):
            self.lift_main({
                "main": (0, 0, [
                    ("push", 5), ("push", 7), ("push", 1), ("LOAD_ADDR", 0, LOCAL_INDEX), ("EXT", 3), ("END",),
                ]),
            })

    def test_native_output_above_the_arguments_is_dead(self):
        _, lifted = self.lift_main({
            "main": (0, 0, [("push", 2), ("push", 3), ("LOAD_ADDR", 0, LOCAL_INDEX), ("EXT", 2), ("END",)]),
        })
        statements = plain(lifted.blocks[lifted.entry].statements)
        self.assertEqual(statements[0], ir.ExtCall(2, (ir.Addr(("stack", 3), INT),)))

    def test_constant_index_reading_past_the_frame_raises(self):
        with self.assertRaisesRegex(LiftError, "reads past the frame"):
            self.lift_main({"main": (2, 0, [("push", 2), ("LOAD", 0, LOCAL_INDEX), ("PRINT", 1), ("END",)])})

    def test_constant_index_below_the_frame_raises(self):
        with self.assertRaisesRegex(LiftError, "below the frame"):
            self.lift_main({"main": (2, 0, [("push", -2), ("LOAD", 1, LOCAL_INDEX), ("PRINT", 1), ("END",)])})

    def test_constant_index_is_element_slot(self):
        _, lifted = self.lift_main({
            "main": (2, 0, [("push", 1), ("LOAD", 0, LOCAL_INDEX), ("POP",), ("END",)]),
        })
        self.assertIn(("local", 1), lifted.slot_types)
        self.assertEqual(plain(lifted.blocks[lifted.entry].statements), [ir.End()])

    def test_pointer_index_through_a_parameter_is_a_reference(self):
        functions = {
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("CALL", "bump"), ("POP",), ("END",)]),
            # *p = *p + 1
            "bump": (1, 1, [
                ("push", 0), ("LOAD_ADDR", 0, POINTER_INDEX), ("push", 0), ("LOAD", 0, POINTER_INDEX),
                ("push", 1), ("ADD",), ("STORE",), ("POP",), ("push", 0), ("RET",),
            ]),
        }
        program, callee = lift_named(functions, "bump")
        self.assertEqual(callee.refs, (0,))
        self.assertEqual(callee.slot_types[("local", 0)], INT)
        self.assertEqual(
            plain(callee.blocks[callee.entry].statements)[0],
            ir.Assign(("local", 0), ir.Binary("add", local(0), const(1), INT, wrap=True)),
        )
        caller = lift(program, program.functions[program.main], Analysis(program))
        self.assertEqual(
            plain(caller.blocks[caller.entry].statements)[0],
            ir.CallStmt(ir.Call(callee.block, (ir.Addr(("local", 0), INT),), INT)),
        )

    def test_float_pointer_index_types_the_reference_as_float(self):
        functions = {
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL_FLOAT), ("CALL", "read"), ("POP",), ("END",)]),
            "read": (1, 1, [("push", 0), ("LOAD", 0, POINTER_INDEX_FLOAT), ("PRINT", 1), ("push", 0), ("RET",)]),
        }
        _, callee = lift_named(functions, "read")
        self.assertEqual(callee.slot_types[("local", 0)], FLOAT)

    def test_integer_passed_to_a_float_reading_reference_raises(self):
        # The callee's float load would read the bits of 1065353216 as 1.0, where a copied-in value stays an integer.
        with self.assertRaisesRegex(LiftError, "loads as a float"):
            self.lift_main({
                "main": (1, 0, [
                    ("LOAD_ADDR", 0, LOCAL), ("push", 1065353216), ("STORE",), ("POP",),
                    ("LOAD_ADDR", 0, LOCAL), ("CALL", "read"), ("POP",), ("END",),
                ]),
                "read": (1, 1, [("push", 0), ("LOAD", 0, POINTER_INDEX_FLOAT), ("PRINT", 1), ("push", 0), ("RET",)]),
            })

    def test_reference_call_whose_result_is_used_runs_first(self):
        functions = {
            "main": (2, 0, [
                ("LOAD_ADDR", 1, LOCAL), ("LOAD", 0, LOCAL), ("LOAD_ADDR", 0, LOCAL), ("CALL", "bump"), ("ADD",),
                ("STORE",), ("POP",), ("END",),
            ]),
            "bump": (1, 1, [
                ("push", 0), ("LOAD_ADDR", 0, POINTER_INDEX), ("push", 5), ("STORE",), ("POP",), ("push", 1), ("RET",),
            ]),
        }
        program = decode(assemble(functions, "main"))
        lifted = lift(program, program.functions[program.main], Analysis(program))
        statements = plain(lifted.blocks[lifted.entry].statements)
        callee = max(program.functions)
        # local 0 is read before the call writes it, so its old value is spilled first.
        self.assertEqual(statements[0], ir.Assign(ir.Temp(1, INT), local(0)))
        self.assertEqual(statements[1], ir.Assign(ir.Temp(0, INT), ir.Call(callee, (ir.Addr(("local", 0), INT),), INT)))
        self.assertEqual(statements[2], ir.Assign(("local", 1), ir.Binary("add", ir.Temp(1, INT), ir.Temp(0, INT), INT)))

    def test_pointer_index_past_the_variable_raises(self):
        with self.assertRaisesRegex(LiftError, "reaches past the variable"):
            lift_named({
                "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("CALL", "f"), ("POP",), ("END",)]),
                "f": (1, 1, [("push", 1), ("LOAD", 0, POINTER_INDEX), ("RET",)]),
            }, "f")

    def test_pointer_index_through_a_local_raises(self):
        with self.assertRaisesRegex(LiftError, "not a parameter"):
            self.lift_main({"main": (1, 0, [("push", 0), ("LOAD", 0, POINTER_INDEX), ("POP",), ("END",)])})

    def test_value_for_a_reference_parameter_raises(self):
        with self.assertRaisesRegex(LiftError, "value passed for reference parameter"):
            self.lift_main({
                "main": (1, 0, [("push", 3), ("CALL", "f"), ("POP",), ("END",)]),
                "f": (1, 1, [("push", 0), ("LOAD", 0, POINTER_INDEX), ("RET",)]),
            })

    def test_two_references_to_one_variable_raise(self):
        with self.assertRaisesRegex(LiftError, "two references"):
            self.lift_main({
                "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("LOAD_ADDR", 0, LOCAL), ("CALL", "f"), ("POP",), ("END",)]),
                "f": (2, 2, [("push", 0), ("LOAD", 0, POINTER_INDEX), ("push", 0), ("LOAD", 1, POINTER_INDEX), ("ADD",), ("RET",)]),
            })

    def test_reference_used_as_a_value_raises(self):
        with self.assertRaisesRegex(LiftError, "used as a value"):
            lift_named({
                "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("CALL", "f"), ("POP",), ("END",)]),
                "f": (1, 1, [("push", 0), ("LOAD", 0, POINTER_INDEX), ("LOAD", 0, LOCAL), ("ADD",), ("RET",)]),
            }, "f")

    def test_float_constant_folding(self):
        program, lifted = self.lift_main({
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("pushf", 2.0), ("pushf", 20.0), ("MUL",), ("STORE",), ("POP",), ("END",)]),
        })
        self.assertEqual(plain(lifted.blocks[lifted.entry].statements), [ir.Assign(("local", 0), const(40.0, FLOAT)), ir.End()])
        multiply = next(i for i in program.functions[program.main].instructions if i.op == Op.MUL)
        self.assertEqual(lifted.folded, frozenset({multiply.offset}))

    def test_mixed_int_float_folding_rounds_to_float32(self):
        _, lifted = self.lift_main({
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("push", 16777217), ("pushf", 1.0), ("ADD",), ("STORE",), ("POP",), ("END",)]),
        })
        self.assertEqual(plain(lifted.blocks[lifted.entry].statements), [ir.Assign(("local", 0), const(16777216.0, FLOAT)), ir.End()])

    def test_float_division_by_zero_is_not_folded(self):
        _, lifted = self.lift_main({
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("pushf", 1.0), ("pushf", 0.0), ("DIV",), ("STORE",), ("POP",), ("END",)]),
        })
        statements = plain(lifted.blocks[lifted.entry].statements)
        self.assertEqual(statements[0], ir.Assign(("local", 0), ir.Binary("div", const(1.0, FLOAT), const(0.0, FLOAT), FLOAT)))

    def test_float_overflow_is_not_folded(self):
        _, lifted = self.lift_main({
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("pushf", 3.0e38), ("pushf", 3.0e38), ("MUL",), ("STORE",), ("POP",), ("END",)]),
        })
        statements = plain(lifted.blocks[lifted.entry].statements)
        self.assertIsInstance(statements[0].value, ir.Binary)

    def test_string_constant(self):
        _, lifted = self.lift_main({
            "main": (1, 0, [("LOAD_ADDR", 0, LOCAL), ("pushs", b"abc"), ("STORE",), ("POP",), ("END",)]),
        })
        self.assertEqual(plain(lifted.blocks[lifted.entry].statements), [ir.Assign(("local", 0), const(b"abc", STR)), ir.End()])


if __name__ == "__main__":
    unittest.main()
