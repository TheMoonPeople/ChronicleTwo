"""Structures a lifted function's basic blocks into nested if, loop and break statements."""

from __future__ import annotations

from stb.opcodes import Compare as CompareOp

from . import ir
from .ir import BOOL, INT

_ADD_COMPARES = frozenset((CompareOp.LT, CompareOp.LE))
_SUB_COMPARES = frozenset((CompareOp.GT, CompareOp.GE))
_TRUE = ir.Const(1, BOOL)


class StructureError(ValueError):
    """Control flow that cannot be expressed as nested structured statements."""


def structure(function: ir.LiftedFunction) -> list:
    """The structured statements that form a function's body."""
    count = len(function.blocks)
    try:
        body = _Structurer(function, relaxed=False)._range(0, count, count, [])
    except StructureError:
        # Relaxed decisions change earlier branch choices, so the whole function is restructured under them.
        body = _Structurer(function, relaxed=True)._range(0, count, count, [])
    body = _simplify(body)
    return _numeric_fors(body, body)


def _targets(exit_: ir.Jump | ir.Branch | ir.Stop | None) -> tuple[int, ...]:
    if isinstance(exit_, ir.Jump):
        return (exit_.target,)
    if isinstance(exit_, ir.Branch):
        return (exit_.true_target, exit_.false_target)
    return ()


def _negate(cond: ir.Expr) -> ir.Expr:
    if isinstance(cond, ir.Unary) and cond.op == "not":
        return cond.operand
    return ir.Unary("not", cond, BOOL)


class _Structurer:
    """Turns layout-ordered blocks into statements, one range of blocks at a time."""

    def __init__(self, function: ir.LiftedFunction, relaxed: bool) -> None:
        self.relaxed = relaxed
        self.starts = sorted(function.blocks)
        self.blocks = [function.blocks[start] for start in self.starts]
        self.index = {start: i for i, start in enumerate(self.starts)}
        # Index of the last block with a back edge to each loop header.
        self.latch: dict[int, int] = {}
        for i, block in enumerate(self.blocks):
            for target in _targets(block.exit):
                t = self._index_of(target, block.start)
                if t <= i:
                    self.latch[t] = max(self.latch.get(t, i), i)

    def _index_of(self, target: int, source: int) -> int:
        if target not in self.index:
            raise StructureError(f"jump to unknown block at {source:#x}")
        return self.index[target]

    def _resolve(self, i: int) -> int:
        while True:
            block = self.blocks[i]
            if block.statements or not isinstance(block.exit, ir.Jump):
                return i
            target = self.index[block.exit.target]
            if target <= i:
                return i
            i = target

    def _next(self, i: int) -> int:
        return self._resolve(i + 1) if i + 1 < len(self.blocks) else len(self.blocks)

    def _join(self, i: int) -> int | None:
        exit_ = self.blocks[i].exit
        if isinstance(exit_, ir.Jump):
            return self._resolve(self.index[exit_.target])
        return None

    def _opens_loop(self, i: int, lo: int, loops: list) -> bool:
        if i not in self.latch:
            return False
        # The first block of a loop's own body is already inside that loop.
        return not (i == lo and loops and loops[-1][0] == i)

    def _ends_with_back_jump(self, latch: int, header: int) -> bool:
        exit_ = self.blocks[latch].exit
        return isinstance(exit_, ir.Jump) and self.index[exit_.target] == header

    def _terminates(self, i: int) -> bool:
        statements = self.blocks[i].statements
        return bool(statements) and isinstance(statements[-1], (ir.Return, ir.End))

    def _range(self, lo: int, hi: int, follow: int, loops: list) -> list:
        out: list = []
        i = lo
        while i < hi:
            if self._opens_loop(i, lo, loops):
                latch = self.latch[i]
                if latch >= hi:
                    raise StructureError(f"unstructured loop at {self.starts[i]:#x}")
                count = len(self.blocks)
                loop_follow = self._resolve(latch + 1) if latch + 1 < count else count
                body = self._range(i, latch + 1, i, [*loops, (i, loop_follow)])
                # Falling out of the latch leaves the loop.
                if not self._ends_with_back_jump(latch, i) and not self._terminates(latch):
                    body.append(ir.Break())
                out.append(ir.While(_TRUE, body))
                i = latch + 1
            else:
                i = self._block(i, hi, follow, loops, out)
        return out

    def _block(self, i: int, hi: int, follow: int, loops: list, out: list) -> int:
        block = self.blocks[i]
        out.extend(block.statements)
        exit_ = block.exit
        if isinstance(exit_, ir.Stop):
            return i + 1
        if isinstance(exit_, ir.Jump):
            out.extend(self._jump(i, hi, follow, loops, self.index[exit_.target]))
            return i + 1
        if isinstance(exit_, ir.Branch):
            stmts, nxt = self._branch(i, hi, follow, loops, exit_)
            out.extend(stmts)
            return nxt
        raise StructureError(f"block without exit at {block.start:#x}")

    def _jump(self, i: int, hi: int, follow: int, loops: list, raw: int) -> list:
        r = self._resolve(raw)
        if loops and r == loops[-1][0]:
            return [] if i == hi - 1 and follow == r else [ir.Continue()]
        if loops and r == loops[-1][1]:
            return [ir.Break()]
        # A jump to the next block is a fall-through, including when that block is an empty forwarder that leads to the same place.
        if raw == i + 1 or r == i + 1 or r == self._next(i) or (i == hi - 1 and r == follow):
            return []
        self._check_multi_level(r, loops, i)
        raise StructureError(f"unstructured jump at {self.starts[i]:#x}")

    def _check_multi_level(self, r: int, loops: list, i: int) -> None:
        """Raises the distinct error for a jump to an enclosing loop's header or follow, which needs a multi-level exit."""
        if any(r == header or r == follow for header, follow in loops[:-1]):
            kind = "break" if any(r == follow for _, follow in loops[:-1]) else "continue"
            raise StructureError(f"multi-level {kind} at {self.starts[i]:#x}")

    def _branch(self, i: int, hi: int, follow: int, loops: list, exit_: ir.Branch) -> tuple[list, int]:
        raw_true = self.index[exit_.true_target]
        if raw_true == self.index[exit_.false_target]:
            # Both outcomes reach the same block, so the condition only matters if it could run a call.
            if ir.has_call(exit_.cond):
                raise StructureError(f"unstructured branch at {self.starts[i]:#x}")
            return self._jump(i, hi, follow, loops, raw_true), i + 1
        true_falls = raw_true == i + 1
        false_falls = self.index[exit_.false_target] == i + 1
        if true_falls == false_falls:
            raise StructureError(f"unstructured branch at {self.starts[i]:#x}")
        if true_falls:
            then_cond, target = exit_.cond, exit_.false_target
        else:
            then_cond, target = ir.Unary("not", exit_.cond, BOOL), exit_.true_target
        r = self._resolve(self.index[target])
        if self.relaxed:
            return self._branch_relaxed(i, hi, follow, loops, then_cond, target, r)

        if loops and r == loops[-1][0]:
            return [ir.If(_negate(then_cond), [ir.Continue()], [])], i + 1
        if loops and r == loops[-1][1]:
            return [ir.If(_negate(then_cond), [ir.Break()], [])], i + 1
        if not (i + 1 < r <= hi or r == follow):
            self._check_multi_level(r, loops, i)
            raise StructureError(f"unstructured branch at {self.starts[i]:#x}")

        t = min(r, hi)
        last = t - 1
        join = self._join(last) if last > i else None
        if join is not None and last < join and (t < join <= hi or join == follow):
            then = self._range(i + 1, t, join, loops)
            orelse = self._range(t, min(join, hi), follow if join >= hi else join, loops)
            return [ir.If(then_cond, then, orelse)], min(join, hi)
        then = self._range(i + 1, t, r if r < hi else follow, loops)
        return [ir.If(then_cond, then, [])], t

    def _branch_relaxed(self, i: int, hi: int, follow: int, loops: list, then_cond: ir.Expr, target: int, r: int) -> tuple[list, int]:
        # The else-part starts at the raw target, even when that block is an empty forwarder, so a dead block
        # between the branch and its join stays out of the then-part.
        raw = self.index[target]
        t = min(raw if raw > i + 1 else r, hi)
        last = t - 1
        join = self._join(last) if last > i else None
        # A then-part that leaves to the loop follow is a break, not the start of an else-part.
        leaves_loop = bool(loops) and join == loops[-1][1]
        if join is not None and last < join and (t < join <= hi or join == follow) and not leaves_loop:
            then = self._range(i + 1, t, join, loops)
            orelse = self._range(t, min(join, hi), follow if join >= hi else join, loops)
            return [ir.If(then_cond, then, orelse)], min(join, hi)

        if loops and r == loops[-1][0]:
            return [ir.If(_negate(then_cond), [ir.Continue()], [])], i + 1
        if loops and r == loops[-1][1]:
            return [ir.If(_negate(then_cond), [ir.Break()], [])], i + 1
        if not (i + 1 < r <= hi or r == follow):
            self._check_multi_level(r, loops, i)
            raise StructureError(f"unstructured branch at {self.starts[i]:#x}")
        then = self._range(i + 1, t, r if r < hi else follow, loops)
        return [ir.If(then_cond, then, [])], t


def _simplify(stmts: list) -> list:
    return [_simplify_stmt(stmt) for stmt in stmts]


def _simplify_stmt(stmt: object) -> object:
    if isinstance(stmt, ir.If):
        return ir.If(stmt.cond, _simplify(stmt.then), _simplify(stmt.orelse))
    if isinstance(stmt, ir.Repeat):
        return ir.Repeat(_simplify(stmt.body), stmt.cond)
    if isinstance(stmt, ir.While):
        body = _simplify(stmt.body)
        if stmt.cond == _TRUE:
            if body and _is_break_if(body[0]):
                return ir.While(_negate(body[0].cond), body[1:])
            if len(body) >= 2 and _is_continue_tail(body) and not _has_continue(body[:-2]):
                return ir.Repeat(body[:-2], _negate(body[-2].cond))
        return ir.While(stmt.cond, body)
    return stmt


def _is_break_if(stmt: object) -> bool:
    return isinstance(stmt, ir.If) and not stmt.orelse and len(stmt.then) == 1 and isinstance(stmt.then[0], ir.Break)


def _is_continue_tail(body: list) -> bool:
    return isinstance(body[-1], ir.Break) and _is_continue_if(body[-2])


def _is_continue_if(stmt: object) -> bool:
    return isinstance(stmt, ir.If) and not stmt.orelse and len(stmt.then) == 1 and isinstance(stmt.then[0], ir.Continue)


def _has_continue(stmts: list) -> bool:
    # Continues inside nested loops belong to those loops, so they are not searched.
    for stmt in stmts:
        if isinstance(stmt, ir.Continue):
            return True
        if isinstance(stmt, ir.If) and (_has_continue(stmt.then) or _has_continue(stmt.orelse)):
            return True
    return False


def _bodies(stmt: object) -> tuple[list, ...]:
    if isinstance(stmt, ir.If):
        return (stmt.then, stmt.orelse)
    if isinstance(stmt, (ir.While, ir.Repeat, ir.NumericFor)):
        return (stmt.body,)
    return ()


def _statement_exprs(stmt: object) -> tuple[ir.Expr, ...]:
    if isinstance(stmt, ir.Assign):
        return (stmt.value,)
    if isinstance(stmt, (ir.ExtCall, ir.Print)):
        return stmt.args
    if isinstance(stmt, ir.CallStmt):
        return (stmt.call,)
    if isinstance(stmt, ir.Return):
        return (stmt.value,)
    if isinstance(stmt, (ir.If, ir.While, ir.Repeat)):
        return (stmt.cond,)
    if isinstance(stmt, ir.NumericFor):
        return (stmt.start, stmt.limit, stmt.step)
    return ()


def _exprs(stmts: list, skip: object) -> list[ir.Expr]:
    # `skip` is matched by identity, so only that exact statement is left out.
    found: list[ir.Expr] = []
    for stmt in stmts:
        if stmt is skip:
            continue
        found.extend(_statement_exprs(stmt))
        for body in _bodies(stmt):
            found.extend(_exprs(body, skip))
    return found


def _writes(stmts: list, slot: ir.Slot) -> bool:
    for stmt in stmts:
        if isinstance(stmt, ir.Assign) and stmt.target == slot:
            return True
        if isinstance(stmt, ir.NumericFor) and stmt.var == slot:
            return True
        if any(_writes(body, slot) for body in _bodies(stmt)):
            return True
    return False


def _takes_address(stmts: list, slot: ir.Slot) -> bool:
    return any(isinstance(sub, ir.Addr) and sub.slot == slot for expr in _exprs(stmts, None) for sub in ir.walk(expr))


def _is_positive_int(value: object) -> bool:
    return isinstance(value, int) and not isinstance(value, bool) and value > 0


def _numeric_fors(stmts: list, root: list) -> list:
    # root is the whole body, used to check whether a loop variable is read elsewhere.
    out: list = []
    i = 0
    while i < len(stmts):
        loop = _numeric_for(stmts[i], stmts[i + 1], root) if i + 1 < len(stmts) else None
        if loop is not None:
            out.append(_numeric_for_children(loop, root))
            i += 2
        else:
            out.append(_numeric_for_children(stmts[i], root))
            i += 1
    return out


def _numeric_for_children(stmt: object, root: list) -> object:
    if isinstance(stmt, ir.If):
        return ir.If(stmt.cond, _numeric_fors(stmt.then, root), _numeric_fors(stmt.orelse, root))
    if isinstance(stmt, ir.While):
        return ir.While(stmt.cond, _numeric_fors(stmt.body, root))
    if isinstance(stmt, ir.Repeat):
        return ir.Repeat(_numeric_fors(stmt.body, root), stmt.cond)
    if isinstance(stmt, ir.NumericFor):
        return ir.NumericFor(stmt.var, stmt.start, stmt.limit, stmt.step, _numeric_fors(stmt.body, root))
    return stmt


def _numeric_for(first: object, second: object, root: list) -> ir.NumericFor | None:
    if not isinstance(first, ir.Assign) or not isinstance(second, ir.While):
        return None
    var = first.target
    if not isinstance(var, tuple) or var[0] != "local":
        return None
    cond = second.cond
    if not isinstance(cond, ir.Compare) or not isinstance(cond.lhs, ir.Var) or cond.lhs.slot != var:
        return None
    body = second.body
    if not body or not isinstance(body[-1], ir.Assign):
        return None
    increment = body[-1]
    step_expr = increment.value
    if (
        increment.target != var
        or not isinstance(step_expr, ir.Binary)
        or step_expr.op not in ("add", "sub")
        or not isinstance(step_expr.lhs, ir.Var)
        or step_expr.lhs.slot != var
        or not isinstance(step_expr.rhs, ir.Const)
        or not _is_positive_int(step_expr.rhs.value)
        # A step the lifter could not keep inside 32 bits wraps on the PS2, where a numeric for would run past it.
        or step_expr.wrap
    ):
        return None
    # A numeric for stands for the while loop only over an integral sequence: from a fractional start, i < 3 runs
    # 0.5, 1.5, 2.5, but the inclusive limit 3 - 1 would stop at 1.5.
    if first.value.type != INT or cond.lhs.type != INT:
        return None
    counting_up = step_expr.op == "add"
    if cond.op not in (_ADD_COMPARES if counting_up else _SUB_COMPARES):
        return None

    limit = cond.rhs
    inner = body[:-1]
    if isinstance(limit, ir.Var):
        if limit.slot[0] != "local" or limit.slot == var or _writes(inner, limit.slot):
            return None
    elif not isinstance(limit, ir.Const):
        return None
    if _writes(inner, var) or _takes_address(inner, var) or _has_continue(inner):
        return None
    if any(var in ir.reads(expr) for expr in _exprs(root, second)):
        return None

    # The while loop's limit is exclusive when counting up and the numeric for's is inclusive.
    if cond.op in (CompareOp.LT, CompareOp.GT):
        # Moving an exclusive limit by one is only exact for an integer limit: i < 10.8 runs to 10, i <= 9.8 to 9.
        if limit.type != INT:
            return None
        delta = -1 if cond.op == CompareOp.LT else 1
        if isinstance(limit, ir.Const) and limit.type == INT:
            limit = ir.Const(limit.value + delta, INT)
        else:
            limit = ir.Binary("sub" if delta < 0 else "add", limit, ir.Const(1, INT), INT)
    step = step_expr.rhs.value if counting_up else -step_expr.rhs.value
    return ir.NumericFor(var, first.value, limit, ir.Const(step, INT), inner)
