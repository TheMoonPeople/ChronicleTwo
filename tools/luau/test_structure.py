import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.opcodes import Compare  # noqa: E402
from stb2luau import ir  # noqa: E402
from stb2luau.structure import StructureError, structure  # noqa: E402


def o(n):
    """Block start offset for layout position n."""
    return 0x100 + 0xC * n


def block(n, statements, exit_):
    return ir.LiftedBlock(start=o(n), statements=statements, exit=exit_)


def function(*blocks):
    return ir.LiftedFunction(
        block=0,
        arg=0,
        local=0,
        entry=blocks[0].start,
        blocks={b.start: b for b in blocks},
        slot_types={},
        temps=[],
    )


def jump(n):
    return ir.Jump(o(n))


def branch(cond, true_n, false_n):
    return ir.Branch(cond, o(true_n), o(false_n))


STOP = ir.Stop()


def mark(command):
    """An external call used as an observable marker for a block's work."""
    return ir.ExtCall(command, ())


def local(n):
    return ("local", n)


def flag(n):
    return ir.Var(local(n), ir.BOOL)


def num(n):
    return ir.Var(local(n), ir.INT)


def const(value):
    return ir.Const(value, ir.INT)


TRUE = ir.Const(1, ir.BOOL)
C0, C1, C2, D0 = flag(0), flag(1), flag(2), flag(3)


class StructureTest(unittest.TestCase):
    def test_straight_line_with_return(self):
        f = function(
            block(0, [mark(1)], STOP),
            block(1, [ir.Return(const(1))], STOP),
        )
        self.assertEqual(structure(f), [mark(1), ir.Return(const(1))])

    def test_if_then(self):
        f = function(
            block(0, [mark(1)], branch(C0, 1, 2)),
            block(1, [mark(2)], jump(2)),
            block(2, [mark(4)], STOP),
        )
        self.assertEqual(structure(f), [mark(1), ir.If(C0, [mark(2)], []), mark(4)])

    def test_if_then_else(self):
        f = function(
            block(0, [mark(1)], branch(C0, 1, 2)),
            block(1, [mark(2)], jump(3)),
            block(2, [mark(3)], STOP),
            block(3, [mark(4)], STOP),
        )
        self.assertEqual(structure(f), [mark(1), ir.If(C0, [mark(2)], [mark(3)]), mark(4)])

    def test_if_elseif_else_chain(self):
        f = function(
            block(0, [mark(1)], branch(C0, 1, 2)),
            block(1, [mark(2)], jump(5)),
            block(2, [], branch(C1, 3, 4)),
            block(3, [mark(3)], jump(5)),
            block(4, [mark(4)], STOP),
            block(5, [mark(5)], STOP),
        )
        expected = [
            mark(1),
            ir.If(C0, [mark(2)], [ir.If(C1, [mark(3)], [mark(4)])]),
            mark(5),
        ]
        self.assertEqual(structure(f), expected)

    def test_while_loop(self):
        f = function(
            block(0, [], branch(C0, 1, 2)),
            block(1, [mark(2)], jump(0)),
            block(2, [mark(4)], STOP),
        )
        self.assertEqual(structure(f), [ir.While(C0, [mark(2)]), mark(4)])

    def test_while_true_with_inner_break_and_continue(self):
        # while true do a; if c0 then break end; if c1 then continue end; b end; d
        f = function(
            block(0, [mark(1)], branch(C0, 3, 1)),
            block(1, [], branch(C1, 0, 2)),
            block(2, [mark(2)], jump(0)),
            block(3, [mark(4)], STOP),
        )
        expected = [
            ir.While(
                TRUE,
                [
                    mark(1),
                    ir.If(C0, [ir.Break()], []),
                    ir.If(C1, [ir.Continue()], []),
                    mark(2),
                ],
            ),
            mark(4),
        ]
        self.assertEqual(structure(f), expected)

    def test_nested_loops_with_inner_break(self):
        # while c0 do while c1 do if c2 then break end; b end; d end; e
        f = function(
            block(0, [], branch(C0, 1, 5)),
            block(1, [], branch(C1, 2, 4)),
            block(2, [], branch(C2, 4, 3)),
            block(3, [mark(2)], jump(1)),
            block(4, [mark(4)], jump(0)),
            block(5, [mark(5)], STOP),
        )
        expected = [
            ir.While(
                C0,
                [
                    ir.While(C1, [ir.If(C2, [ir.Break()], []), mark(2)]),
                    mark(4),
                ],
            ),
            mark(5),
        ]
        self.assertEqual(structure(f), expected)

    def test_loop_body_with_early_return(self):
        # while c0 do a; if d0 then return 1 end; b end; e
        f = function(
            block(0, [], branch(C0, 1, 4)),
            block(1, [mark(1)], branch(D0, 3, 2)),
            block(2, [ir.Return(const(1))], STOP),
            block(3, [mark(3)], jump(0)),
            block(4, [mark(4)], STOP),
        )
        expected = [
            ir.While(
                C0,
                [
                    mark(1),
                    ir.If(ir.Unary("not", D0, ir.BOOL), [ir.Return(const(1))], []),
                    mark(3),
                ],
            ),
            mark(4),
        ]
        self.assertEqual(structure(f), expected)

    def test_repeat_until(self):
        # repeat a; b until not c0
        f = function(
            block(0, [mark(1)], STOP),
            block(1, [mark(2)], branch(C0, 0, 2)),
            block(2, [mark(4)], STOP),
        )
        expected = [ir.Repeat([mark(1), mark(2)], ir.Unary("not", C0, ir.BOOL)), mark(4)]
        self.assertEqual(structure(f), expected)

    def test_numeric_for(self):
        # i = 0; while i < 10 do a; i = i + 1 end; d
        i = local(0)
        f = function(
            block(0, [ir.Assign(i, const(0))], STOP),
            block(1, [], branch(ir.Compare(Compare.LT, num(0), const(10)), 2, 3)),
            block(2, [mark(1), ir.Assign(i, ir.Binary("add", num(0), const(1), ir.INT))], jump(1)),
            block(3, [mark(4)], STOP),
        )
        expected = [
            ir.NumericFor(i, const(0), const(9), const(1), [mark(1)]),
            mark(4),
        ]
        self.assertEqual(structure(f), expected)

    def test_numeric_for_rejected_when_variable_read_after_loop(self):
        i = local(0)
        f = function(
            block(0, [ir.Assign(i, const(0))], STOP),
            block(1, [], branch(ir.Compare(Compare.LT, num(0), const(10)), 2, 3)),
            block(2, [mark(1), ir.Assign(i, ir.Binary("add", num(0), const(1), ir.INT))], jump(1)),
            block(3, [ir.Print((num(0),))], STOP),
        )
        expected = [
            ir.Assign(i, const(0)),
            ir.While(
                ir.Compare(Compare.LT, num(0), const(10)),
                [mark(1), ir.Assign(i, ir.Binary("add", num(0), const(1), ir.INT))],
            ),
            ir.Print((num(0),)),
        ]
        self.assertEqual(structure(f), expected)

    def test_numeric_for_rejected_for_an_exclusive_limit_that_may_be_a_float(self):
        # i < n runs to 10 when n is 10.8, but a numeric for to n - 1 would stop at 9.
        i = local(0)
        limit = ir.Var(local(1), ir.ANY)
        cond = ir.Compare(Compare.LT, num(0), limit)
        increment = ir.Assign(i, ir.Binary("add", num(0), const(1), ir.INT))
        f = function(
            block(0, [ir.Assign(i, const(0))], STOP),
            block(1, [], branch(cond, 2, 3)),
            block(2, [mark(1), increment], jump(1)),
            block(3, [mark(4)], STOP),
        )
        expected = [ir.Assign(i, const(0)), ir.While(cond, [mark(1), increment]), mark(4)]
        self.assertEqual(structure(f), expected)

    def test_numeric_for_rejected_when_the_step_may_overflow(self):
        # i = 2147483647; while i <= 2147483647: the step wraps on the PS2, so the loop never ends there.
        i = local(0)
        cond = ir.Compare(Compare.LE, num(0), const(2147483647))
        increment = ir.Assign(i, ir.Binary("add", num(0), const(1), ir.INT, wrap=True))
        f = function(
            block(0, [ir.Assign(i, const(2147483647))], STOP),
            block(1, [], branch(cond, 2, 3)),
            block(2, [mark(1), increment], jump(1)),
            block(3, [mark(4)], STOP),
        )
        expected = [ir.Assign(i, const(2147483647)), ir.While(cond, [mark(1), increment]), mark(4)]
        self.assertEqual(structure(f), expected)

    def test_numeric_for_rejected_for_a_fractional_start(self):
        # i = 0.5; while i < 3 runs 0.5, 1.5, 2.5, but for i = 0.5, 2 would stop at 1.5.
        i = local(0)
        var = ir.Var(i, ir.FLOAT)
        cond = ir.Compare(Compare.LT, var, const(3))
        increment = ir.Assign(i, ir.Binary("add", var, const(1), ir.FLOAT))
        f = function(
            block(0, [ir.Assign(i, ir.Const(0.5, ir.FLOAT))], STOP),
            block(1, [], branch(cond, 2, 3)),
            block(2, [mark(1), increment], jump(1)),
            block(3, [mark(4)], STOP),
        )
        expected = [ir.Assign(i, ir.Const(0.5, ir.FLOAT)), ir.While(cond, [mark(1), increment]), mark(4)]
        self.assertEqual(structure(f), expected)

    def test_numeric_for_rejected_for_a_start_that_may_be_a_float(self):
        i = local(0)
        cond = ir.Compare(Compare.LE, num(0), const(3))
        increment = ir.Assign(i, ir.Binary("add", num(0), const(1), ir.INT))
        start = ir.Var(local(1), ir.ANY)
        f = function(
            block(0, [ir.Assign(i, start)], STOP),
            block(1, [], branch(cond, 2, 3)),
            block(2, [mark(1), increment], jump(1)),
            block(3, [mark(4)], STOP),
        )
        expected = [ir.Assign(i, start), ir.While(cond, [mark(1), increment]), mark(4)]
        self.assertEqual(structure(f), expected)

    def test_empty_forwarder_chain(self):
        # if c0 then b end, where the then-part reaches the join through empty blocks
        f = function(
            block(0, [mark(1)], branch(C0, 1, 4)),
            block(1, [mark(2)], jump(2)),
            block(2, [], jump(3)),
            block(3, [], jump(4)),
            block(4, [mark(4)], STOP),
        )
        self.assertEqual(structure(f), [mark(1), ir.If(C0, [mark(2)], []), mark(4)])

    def test_if_with_empty_else_forwarder_after_then_jump(self):
        # if c0 then b else (empty forwarder to the join) end, where the then-part jumps straight to the join
        f = function(
            block(0, [mark(1)], branch(C0, 1, 2)),
            block(1, [mark(2)], jump(3)),
            block(2, [], jump(3)),
            block(3, [mark(4)], STOP),
        )
        self.assertEqual(structure(f), [mark(1), ir.If(C0, [mark(2)], []), mark(4)])

    def test_branch_with_identical_targets_is_a_jump(self):
        f = function(
            block(0, [mark(1)], branch(C0, 1, 1)),
            block(1, [mark(2)], STOP),
        )
        self.assertEqual(structure(f), [mark(1), mark(2)])

    def test_loop_body_whose_then_part_breaks_is_an_if_else(self):
        # while true do a; if c0 then b; break else c end; d end; e
        f = function(
            block(0, [mark(1)], branch(C0, 1, 2)),
            block(1, [mark(2)], jump(3)),
            block(2, [mark(3)], jump(0)),
            block(3, [mark(4)], STOP),
        )
        expected = [
            ir.While(TRUE, [mark(1), ir.If(C0, [mark(2), ir.Break()], [mark(3)])]),
            mark(4),
        ]
        self.assertEqual(structure(f), expected)

    def test_if_else_with_empty_forwarder_else_keeps_raw_boundary(self):
        # if c0 then b else c end; d, where the else starts at an empty forwarder into the join
        f = function(
            block(0, [mark(1)], branch(C0, 1, 2)),
            block(1, [mark(2)], jump(4)),
            block(2, [], jump(3)),
            block(3, [mark(3)], jump(4)),
            block(4, [mark(4)], STOP),
        )
        self.assertEqual(structure(f), [mark(1), ir.If(C0, [mark(2)], [mark(3)]), mark(4)])

    def test_break_in_else_with_dead_forwarder_before_join(self):
        # while true do a; if c0 then b else break end; c end; d, with the break forwarder laid out before the join
        f = function(
            block(0, [mark(1)], branch(C0, 1, 3)),
            block(1, [mark(2)], jump(2)),
            block(2, [], jump(4)),
            block(3, [], jump(5)),
            block(4, [mark(3)], jump(0)),
            block(5, [mark(4)], STOP),
        )
        expected = [
            ir.While(TRUE, [mark(1), ir.If(C0, [mark(2)], [ir.Break()]), mark(3)]),
            mark(4),
        ]
        self.assertEqual(structure(f), expected)

    def test_relaxed_if_else_skips_dead_forwarder_before_join(self):
        # while true do a; if c0 then b else break end; d end; e, where the break forwarder sits before the join
        f = function(
            block(0, [mark(1)], branch(C0, 1, 2)),
            block(1, [mark(2)], jump(4)),
            block(2, [], jump(5)),
            block(3, [], jump(4)),
            block(4, [mark(3)], jump(0)),
            block(5, [mark(4)], STOP),
        )
        expected = [
            ir.While(TRUE, [mark(1), ir.If(C0, [mark(2)], [ir.Break()]), mark(3)]),
            mark(4),
        ]
        self.assertEqual(structure(f), expected)

    def test_multi_level_break_is_reported_distinctly(self):
        # while c0 do while c1 do if c2 then goto outer follow end; b end; d end
        f = function(
            block(0, [], branch(C0, 1, 5)),
            block(1, [], branch(C1, 2, 4)),
            block(2, [], branch(C2, 5, 3)),
            block(3, [mark(3)], jump(1)),
            block(4, [mark(4)], jump(0)),
            block(5, [mark(5)], STOP),
        )
        with self.assertRaisesRegex(StructureError, "multi-level break at 0x118"):
            structure(f)

    def test_unstructured_jump_raises(self):
        f = function(
            block(0, [mark(1)], jump(2)),
            block(1, [mark(2)], STOP),
            block(2, [mark(3)], STOP),
        )
        with self.assertRaisesRegex(StructureError, "unstructured jump at 0x100"):
            structure(f)

    def test_branch_without_fall_through_raises(self):
        f = function(
            block(0, [], branch(C0, 2, 3)),
            block(1, [mark(1)], STOP),
            block(2, [], STOP),
            block(3, [], STOP),
        )
        with self.assertRaisesRegex(StructureError, "unstructured branch at 0x100"):
            structure(f)


if __name__ == "__main__":
    unittest.main()
