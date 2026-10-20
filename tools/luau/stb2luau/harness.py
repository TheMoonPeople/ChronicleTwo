"""Differential testing of transpiled scripts: records reference VM traces and replays them against Luau modules.

Each program of a script runs on the reference VM under a mock native API with seeded outputs, and the events it
produces (native calls, prints, waits and ends) are recorded. The Luau module is then run under a mock that checks
every call, print and yield against the same trace, and each scenario passes or fails.

A scenario whose reference run cannot be compared to its end is cut: the trace ends with a cut event and only the
events before it are compared. That happens when the reference run exceeds its step budget, and then nothing the
module does from the cut on is checked, so the scenario counts only as a compared prefix. It also happens when the
run loads or stores outside the running function's frame, which retail allows but the translation does not model:
the module must raise vm.index's error there, and the scenario is unsupported, since retail goes on.

A call of a script function that takes references is probed: when it returns, the reference VM records the values
of the variables the references name, and the module, emitted with probes, reports the same values after it copies
them back.
"""

from __future__ import annotations

import dataclasses
import math
import random
import subprocess
import sys
import tempfile
from pathlib import Path

from stb.opcodes import ConstType, Op
from stb.program import Program

from . import api, refvm
from .emit import NUMERIC_TYPES, SETUP, nan_text
from .refvm import Slot, Tag

REPO = Path(__file__).resolve().parents[3]
HOST = REPO / "port" / "build" / "luau-harness" / ("luau-harness.exe" if sys.platform == "win32" else "luau-harness")

MAX_STEPS = 500_000
BUDGET = "step budget exceeded"
# Operand-stack slots and call depth that each kind's Set*Script gives its machine (actscript.cpp SetActionScript,
# effscript.cpp SetEffectScript, runscript_opcodes.cpp SetMonsterScript); other kinds use the action sizes.
STACKS = {"action": (0x80, 0x200), "effect": (0x40, 2), "monster": (128, 512)}
MAX_DEREF = 8
INT_CHOICES = (0, 0, 1, 1, 2, 3, -1, 7)
FLOAT_CHOICES = (0.0, 0.25, 1.0, -1.0, 2.5, 30.0)
STRING_CHOICES = ("", "a")
# Per kind namespace, the commands that store an input in a table of the engine ("set": command -> table, position of
# the key input or None, position of the value input) and the commands whose output reads it back ("get": command ->
# table, position of the key input or None), so a value read back follows the value the script last stored.
STATE = {
    "action": {"set": {1: ("prog", None, 0)}, "get": {2: ("prog", None)}},
    "effect": {"set": {58: ("value", 0, 1)}, "get": {57: ("value", 0)}},
    "monster": {
        "set": {37: ("var", 0, 1), 54: ("flag", 0, 1), 59: ("var2", 0, 1)},
        "get": {38: ("var", 0), 53: ("flag", 0), 60: ("var2", 0)},
    },
}
STATE_CHOICES = 4
ZERO_CHOICES = 2
# Per kind namespace, the random-number commands and the position of their range input: the handler writes a value
# from zero towards the range, so the mock does too.
RANDOM = {"effect": {13: 0}, "monster": {35: 0, 36: 0}}
# Fractions of a random command's range that the mock draws from.
RANDOM_FRACTIONS = (0.0, 0.0, 0.25, 0.5, 0.75, 0.999)


@dataclasses.dataclass
class Scenario:
    """One recorded run: the programs executed in order, the expected event trace and the final globals.

    cut gives the reason a trace ends with a cut event, before the run's end, and unsupported says the reason is an
    access the translation does not model. covered holds the instructions the reference run executed, and compared
    those it executed before its last compared event.
    """

    name: str
    programs: list[int]
    seed: int
    events: list[tuple]
    globals: list | None
    cut: str | None = None
    unsupported: bool = False
    covered: frozenset[int] = frozenset()
    compared: frozenset[int] = frozenset()


@dataclasses.dataclass(frozen=True)
class FloatViews:
    """Which variables the script loads as floats: the arguments of each external or script call, by offset, and globals.

    A float variable's slot may still hold an integer tag with a float's bits, when a native call wrote it before the
    script first loaded it as a float, so the harness reads such variables as the script would.
    """

    calls: dict[int, tuple[bool, ...]]
    globals: frozenset[int]

    def argument(self, call: int, position: int) -> bool:
        """Whether an argument of the call at the given offset names a variable loaded as a float."""
        site = self.calls.get(call, ())
        return position < len(site) and site[position]


@dataclasses.dataclass(frozen=True)
class Pools:
    """Candidate seeded outputs: the base choices followed by the constants a script pushes."""

    ints: tuple[int, ...]
    floats: tuple[float, ...]


def value_pools(program: Program) -> Pools:
    """Output candidates for a program, extended with every integer and finite float constant its functions push."""
    pushed = [
        instruction
        for function in program.functions.values()
        for instruction in function.instructions
        if instruction.op == Op.PUSH_CONST
    ]
    ints = {instruction.a2 for instruction in pushed if instruction.a1 == ConstType.INT}
    floats = {
        instruction.a2_float
        for instruction in pushed
        if instruction.a1 == ConstType.FLOAT and math.isfinite(instruction.a2_float)
    }
    return Pools(
        ints=(*INT_CHOICES, *sorted(ints - set(INT_CHOICES))),
        floats=(*FLOAT_CHOICES, *sorted(floats - set(FLOAT_CHOICES))),
    )


def _value(memory: list[Slot], slot: Slot, depth: int = 0) -> object:
    """Script value of a slot, following pointers and decoding strings as cp932."""
    if slot.tag == Tag.PTR:
        if depth == MAX_DEREF:
            return 0
        return _value(memory, memory[slot.value], depth + 1)
    if slot.tag == Tag.STR:
        return slot.value.decode("cp932", errors="replace")
    return slot.value


def _signature(kind_catalog: dict, command: int, argc: int) -> dict | None:
    """Catalogued signature of a command with the given argument count, if any."""
    for entry in kind_catalog["commands"]:
        if entry["no"] == command:
            for signature in entry.get("signatures", []):
                if signature["argc"] == argc:
                    return signature
    return None


def _kind_mismatch(params: list[dict], args: tuple[Slot, ...]) -> bool:
    """Whether an input holds a number where its parameter reads a string, or a string where it reads a number."""
    for param, slot in zip(params, args):
        if param["dir"] != "in":
            continue
        if param["type"] == "string" and slot.tag in (Tag.INT, Tag.FLOAT):
            return True
        if param["type"] in NUMERIC_TYPES and slot.tag == Tag.STR:
            return True
    return False


def _choose(rng: random.Random, type_name: str, pools: Pools) -> object:
    """Seeded output value for a parameter type, drawn from the program's candidates."""
    if type_name == "f32":
        return rng.choice(pools.floats)
    if type_name == "string":
        return rng.choice(STRING_CHOICES)
    return rng.choice(pools.ints)


def _as_type(value: object, type_name: str) -> object:
    """A value stored in an engine table, read back as an integer or a float, as the table's union reads it."""
    if type_name == "f32" and isinstance(value, int):
        return refvm.bits_to_float(value)
    if type_name != "f32" and isinstance(value, float):
        return refvm.float_bits(value)
    return value


def _as_read(memory: list[Slot], slot: Slot, as_float: bool) -> object:
    """Script value of a slot, read as a float when the script loads its variable as one."""
    if as_float and slot.tag == Tag.INT:
        return refvm.bits_to_float(slot.value)
    return _value(memory, slot)


def _random_draw(rng: random.Random, range_: int | float, type_name: str) -> int | float:
    """A value a random-number handler can return for a range: a fraction of it, truncated for an integer variable."""
    value = range_ * rng.choice(RANDOM_FRACTIONS)
    if type_name == "f32":
        return float(int(value)) if isinstance(range_, int) else value
    return int(value)


def _target_tag(machine: refvm.Machine, slot: Slot) -> Tag | None:
    """The tag of the variable a pointer argument names, or None when the argument is not a pointer."""
    return machine.read_arg(slot.value).tag if slot.tag == Tag.PTR else None


def _tag_read(machine: refvm.Machine, signature: dict, args: tuple[Slot, ...]) -> tuple[str, ...]:
    """The integer or float tag a tagged handler branches on: its first tagged input's, else the tag its first tagged
    output's destination holds (GetMonsterLife writes the life or the fraction by it); nothing for an untagged call.

    The bit-copying outputs (VPop, GetValue, marked "copies") are not checked here: either branch copies the same bits,
    which the trace records raw and the module's variant reads as its type.
    """
    params = signature["params"]
    for i, param in enumerate(params):
        if param.get("tagged") and param["dir"] == "in":
            return ("f32" if args[i].tag == Tag.FLOAT else "s32",)
    for i, param in enumerate(params):
        if param.get("tagged") and param["dir"] in api.OUTPUTS and not param.get("copies"):
            return ("f32" if _target_tag(machine, args[i]) == Tag.FLOAT else "s32",)
    return ()


def _written_type(
    machine: refvm.Machine, params: list[dict], args: tuple[Slot, ...], position: int, views: FloatViews | None
) -> str:
    """The type a handler writes through an output: its catalogued type, or for a tagged output the tag the handler
    branches on, its first tagged input's (GetRand) or else the destination's (VPop, GetValue, GetMonsterLife)."""
    param = params[position]
    if param["type"] == "string":
        return "string"
    if not param.get("tagged"):
        return "f32" if param["type"] == "f32" else "s32"
    for i, other in enumerate(params):
        if other.get("tagged") and other["dir"] == "in":
            return "f32" if args[i].tag == Tag.FLOAT else "s32"
    if param.get("copies") and views is not None:
        # Either branch copies the same bits, which the module's variant reads as the script reads its variable.
        return "f32" if views.argument(machine.pc, position) or _target_tag(machine, args[position]) == Tag.FLOAT else "s32"
    return "f32" if _target_tag(machine, args[position]) == Tag.FLOAT else "s32"


def _inout_value(machine: refvm.Machine, slot: Slot) -> object:
    """The float an in-out handler reads through a reference: the variable's bits as a float; 0 past the frame."""
    if slot.tag != Tag.PTR or machine._past_frame(slot.value):
        return 0
    target = machine.read_arg(slot.value)
    if target.tag == Tag.INT:
        return refvm.bits_to_float(target.value)
    return target.value


def _write(machine: refvm.Machine, slot: Slot, value: object) -> object:
    """Store an output through a pointer argument, keeping the target's tag where it applies.

    A handler writes a float32, so a float output is the float32 nearest the chosen value; it then reads the same
    whether the target keeps its bits under an integer tag or holds a float.
    """
    if value is None or slot.tag != Tag.PTR:
        return None
    target = machine.read_arg(slot.value)
    if isinstance(value, float):
        value = refvm.f32(value)
    if isinstance(value, str):
        stored = Slot(Tag.STR, value.encode("cp932"))
    elif isinstance(value, float):
        stored = Slot(Tag.INT, refvm.float_bits(value)) if target.tag == Tag.INT else Slot(Tag.FLOAT, value)
    else:
        stored = Slot(Tag.FLOAT, refvm.bits_to_float(value)) if target.tag == Tag.FLOAT else Slot(Tag.INT, value)
    machine.write(slot.value, stored)
    return value


class _TracingMachine(refvm.Machine):
    """Reference machine that also appends each PRINT, and the references of each probed call, to the scenario trace."""

    def __init__(
        self,
        program: Program,
        *,
        probes: frozenset[int] = frozenset(),
        folded: frozenset[int] = frozenset(),
        views: FloatViews | None = None,
        **kwargs,
    ) -> None:
        """Create the machine with its trace, the CALL offsets whose references it reports and the folded operations."""
        super().__init__(program, **kwargs)
        self.events: list[tuple] = []
        # The machine's step count when each event was recorded.
        self.event_steps: list[int] = []
        self.probes = probes
        self.folded = folded
        self.views = views or FloatViews({}, frozenset())
        # The first access outside a frame, and the number of events recorded before it.
        self.cut: tuple[str, int] | None = None

    def emit(self, event: tuple) -> None:
        """Append an event to the trace."""
        self.events.append(event)
        self.event_steps.append(self.steps)

    def outside_frame(self, access: str, address: int) -> None:
        """Note the first access outside a frame: the translation raises an error there, while retail goes on."""
        if self.cut is None:
            self.cut = (f"{access} at {self.pc:#x}", len(self.events))

    def _arith(self, op: Op) -> None:
        super()._arith(op)
        self._spell_folded()

    def _divide(self) -> None:
        super()._divide()
        self._spell_folded()

    def _spell_folded(self) -> None:
        # The module folds constant float operations in float32, as this run computes them.
        if self.pc in self.folded:
            slot = self.memory[self.sp - 1]
            if slot.tag == Tag.FLOAT:
                self.memory[self.sp - 1] = Slot(Tag.FLOAT, refvm.f32(slot.value))

    def returned(self, call: int, callee: int, frame: int) -> None:
        """Record the values the references of a probed call name, now that the callee has written them."""
        if call not in self.probes:
            return
        args = self.memory[frame : frame + self.program.functions[callee].arg]
        values = tuple(
            _as_read(self.memory, self.memory[slot.value], self.views.argument(call, position))
            for position, slot in enumerate(args)
            if slot.tag == Tag.PTR
        )
        self.emit(("ref", call, values))

    def _print(self, count: int) -> None:
        """Print as the base machine does, then record the printed values."""
        super()._print(count)
        base = self.sp
        self.emit(("print", tuple(_value(self.memory, self.memory[index]) for index in range(base, base + count))))


def _play(
    program: Program,
    kind_catalog: dict,
    programs: list[int],
    seed: int,
    name: str,
    resumes: int,
    stack_num: int | None,
    pools: Pools,
    namespace: str,
    probes: frozenset[int],
    views: FloatViews | None,
    folded: frozenset[int],
    max_steps: int,
) -> tuple[_TracingMachine, dict[int, int]]:
    """Runs the programs on a fresh reference machine and mock; returns the machine and the step each offset first ran."""
    default_stack, call_num = STACKS.get(namespace, STACKS["action"])
    call_index = 0
    state = STATE.get(namespace, {})
    sets: dict[int, tuple] = state.get("set", {})
    gets: dict[int, tuple] = state.get("get", {})
    randoms: dict[int, int] = RANDOM.get(namespace, {})
    # Values stored by the "set" commands, keyed by table and key; an entry never stored reads as zero.
    held: dict[tuple, object] = {}

    def mock(machine: refvm.Machine, base: int, argc: int) -> None:
        """Answer one native call with seeded outputs and record it."""
        nonlocal call_index
        index = call_index
        call_index += 1
        command = machine.memory[base].value
        count = argc - 1
        args = machine.memory[base + 1 : base + 1 + count]
        values = tuple(
            _as_read(machine.memory, machine.memory[slot.value], views.argument(machine.pc, i))
            if slot.tag == Tag.PTR and views is not None
            else _value(machine.memory, slot)
            for i, slot in enumerate(args)
        )
        signature = _signature(kind_catalog, command, count)
        # Unregistered, handler-rejected and kind-mismatched commands write nothing, so their trace keeps every argument.
        if signature is None or signature.get("handler_rejects") or _kind_mismatch(signature["params"], args):
            machine.emit(("ext", command, count, values, ()))
            return
        if api.ignores_reference(signature, args, lambda slot: slot.tag == Tag.PTR):
            return
        params = signature["params"]
        # An in-out handler reads the float bits its reference names; one past the frame reads an operand-stack slot,
        # which the module passes as 0.
        values = tuple(
            _inout_value(machine, args[i]) if param["dir"] == "inout" else value
            for i, (param, value) in enumerate(zip(params, values))
        )
        ins = tuple(values[i] for i, param in enumerate(params) if param["dir"] in api.INPUTS)
        rng = random.Random(f"{seed}/{name}/{index}")
        typed = _tag_read(machine, signature, args)
        outs = []
        for i, param in enumerate(params):
            if param["dir"] not in api.OUTPUTS:
                continue
            # The handler writes its own type through the reference, without retagging the variable, so the script's
            # loads read the bits as the machine does.
            type_name = _written_type(machine, params, args, i, views)
            inout = param["dir"] == "inout"
            range_ = ins[randoms[command]] if command in randoms and randoms[command] < len(ins) else None
            if type_name != "string" and isinstance(range_, (int, float)):
                value = _random_draw(rng, range_, type_name)
            elif rng.randrange(8) == 0 and not inout:
                value = None
            elif command in gets and type_name != "string" and rng.randrange(STATE_CHOICES) != 0:
                table, key = gets[command]
                value = _as_type(held.get((table, None if key is None else ins[key]), 0), type_name)
            else:
                value = _choose(rng, type_name, pools)
                # Zero keeps most scenarios on the branches a script takes when a flag or count is clear.
                if type_name != "string" and rng.randrange(ZERO_CHOICES) == 0:
                    value = 0.0 if type_name == "f32" else 0
            written = _write(machine, args[i], value)
            if param.get("copies") and isinstance(written, float):
                # A bit copy is recorded as its raw bits; the module's variant reads them as its type.
                written = refvm.float_bits(written)
            outs.append(written)
        if command in sets:
            table, key, position = sets[command]
            if position < len(ins) and isinstance(ins[position], (int, float)):
                held[(table, None if key is None else ins[key])] = ins[position]
        machine.emit(("ext", command, count, ins, tuple(outs), *typed))

    machine = _TracingMachine(
        program,
        probes=probes,
        folded=folded,
        views=views,
        stack_num=default_stack if stack_num is None else stack_num,
        call_num=call_num,
        ext=mock,
        float32=True,
        max_steps=max_steps,
    )
    first_steps: dict[int, int] = {}
    machine.trace = first_steps
    try:
        for number in programs:
            machine.result = 0
            if machine.run(number) < 0:
                machine.emit(("missing", number))
                continue
            resumed = 0
            while not machine.end:
                machine.emit(("wait",))
                if resumed == resumes:
                    machine.emit(("suspended",))
                    break
                resumed += 1
                machine.resume()
            else:
                machine.emit(("end", machine.result))
    except refvm.VMError as exc:
        if str(exc) != BUDGET:
            machine.emit(("error",))
        elif machine.cut is None:
            machine.cut = (BUDGET, len(machine.events))
    return machine, first_steps


def record(
    program: Program,
    kind_catalog: dict,
    programs: list[int],
    seed: int,
    name: str,
    resumes: int = 160,
    stack_num: int | None = None,
    pools: Pools | None = None,
    namespace: str = "",
    probes: frozenset[int] = frozenset(),
    views: FloatViews | None = None,
    folded: frozenset[int] = frozenset(),
) -> Scenario:
    """Run the programs in order on the reference VM with seeded native outputs and record the event trace.

    probes holds the CALL offsets whose references the module reports after the call returns. views says which
    variables the script loads as floats. When it is given, a numeric output takes the type its variable is read as: a
    float when the script loads it as one, otherwise the type its slot holds, and references and globals are reported
    as the script reads them. Handlers differ in the type they write, and the translation receives outputs as numbers, so
    this keeps the comparison on the script's own behaviour. folded holds the offsets of the float operations the
    module folded into constants. The machine has the stack and call depth retail gives the namespace's kind, unless
    stack_num is given.

    A trace cut at an access outside a frame ends with ("cut", "frame"), and one cut at the step budget with
    ("cut", "budget").
    """
    if pools is None:
        pools = value_pools(program)
    options = (program, kind_catalog, programs, seed, name, resumes, stack_num, pools, namespace, probes, views, folded)
    machine, first_steps = _play(*options, MAX_STEPS)
    global_num = machine.global_num
    float_globals = views.globals if views is not None else frozenset()
    globals_ = [_as_read(machine.memory, slot, n in float_globals) for n, slot in enumerate(machine.memory[:global_num])]
    events = machine.events
    compared = frozenset(first_steps)
    cut = None
    if machine.cut is not None:
        cut, kept = machine.cut
        # Only what ran up to the last event the comparison reaches is compared.
        last = machine.event_steps[kept - 1] if kept else 0
        compared = frozenset(offset for offset, step in first_steps.items() if step <= last)
        events = [*events[:kept], ("cut", "budget" if cut == BUDGET else "frame")]
    return Scenario(
        name=name,
        programs=list(programs),
        seed=seed,
        events=events,
        globals=globals_,
        cut=cut,
        unsupported=cut is not None and cut != BUDGET,
        covered=frozenset(first_steps),
        compared=compared,
    )


def scenarios(
    program: Program,
    kind_catalog: dict,
    seeds: range | list[int] = range(4),
    probes: frozenset[int] = frozenset(),
    views: FloatViews | None = None,
    folded: frozenset[int] = frozenset(),
) -> list[Scenario]:
    """Record one scenario per program, one running it twice, one for main and one running main then every program, for each seed."""
    numbers = sorted(number for number, _ in program.programs)
    options = {
        "pools": value_pools(program),
        "namespace": kind_catalog["namespace"],
        "probes": probes,
        "views": views,
        "folded": folded,
    }
    recorded = []
    for seed in seeds:
        for number in numbers:
            recorded.append(record(program, kind_catalog, [number], seed, f"{number}/s{seed}", **options))
            recorded.append(record(program, kind_catalog, [number, number], seed, f"{number}x2/s{seed}", **options))
        recorded.append(record(program, kind_catalog, [-1], seed, f"main/s{seed}", **options))
        recorded.append(record(program, kind_catalog, [-1, *numbers], seed, f"all/s{seed}", **options))
    return recorded


def _reachable(program: Program) -> set[int]:
    """Blocks of the main function, the programs and every function they call, directly or through other calls."""
    seen: set[int] = set()
    todo = [program.main, *(block for _, block in program.programs)]
    while todo:
        block = todo.pop()
        if block in seen:
            continue
        seen.add(block)
        for instruction in program.functions[block].instructions:
            if instruction.op == Op.CALL:
                todo.append(program.callee(instruction).block)
    return seen


def coverage(program: Program, recorded: list[Scenario], compared: bool = False) -> float:
    """Fraction of the instructions of the reachable functions that the recorded scenarios executed.

    With compared, only the instructions the scenarios executed before their last compared event count.
    """
    total = {instruction.offset for block in _reachable(program) for instruction in program.functions[block].instructions}
    executed = set().union(*((scenario.compared if compared else scenario.covered) for scenario in recorded))
    return len(executed & total) / len(total) if total else 0.0


def _string(text: str) -> str:
    """Luau string literal for a Python string."""
    parts = []
    for char in text:
        if char in '"\\':
            parts.append("\\" + char)
        elif 32 <= ord(char) < 127:
            parts.append(char)
        else:
            parts.append("\\u{%x}" % ord(char))
    return '"' + "".join(parts) + '"'


def _lit(value: object) -> str:
    """Luau literal for a recorded value; None becomes nil."""
    if value is None:
        return "nil"
    if isinstance(value, str):
        return _string(value)
    if isinstance(value, float):
        if math.isnan(value):
            # Its sign and payload, which a handler storing the float's bits passes on.
            return nan_text(value)
        if math.isinf(value):
            return "math.huge" if value > 0 else "-math.huge"
        return repr(value)
    return str(value)


def _list(values: tuple | list) -> str:
    """Luau table literal holding a sequence with an explicit count, so nil entries survive.

    Field i marks with "i" the positions that hold integers. Every number compares exactly, and a float's zero by its
    sign. A native call's inputs compare as the runtime marshals them, whatever the marks say (see same_inputs).
    """
    items = "".join(", " + _lit(value) for value in values)
    exact = "".join("i" if isinstance(value, int) and not isinstance(value, bool) else "." for value in values)
    if "i" in exact:
        return '{ n = %d, i = "%s"%s }' % (len(values), exact, items)
    return "{ n = %d%s }" % (len(values), items)


def _event(event: tuple) -> str:
    """Luau table literal for one trace event."""
    tag = event[0]
    if tag in ("wait", "suspended", "error"):
        return '{ "%s" }' % tag
    if tag == "cut":
        return "{ %s }" % ", ".join(_lit(field) for field in event)
    if tag == "print":
        return '{ "print", %s }' % _list(event[1])
    if tag in ("end", "missing"):
        return '{ "%s", %s }' % (tag, _lit(event[1]))
    if tag == "ref":
        return '{ "ref", %d, %s }' % (event[1], _list(event[2]))
    if tag == "ext":
        _, command, count, ins, outs, *typed = event
        tail = "".join(", " + _string(type_name) for type_name in typed)
        return '{ "ext", %d, %d, %s, %s%s }' % (command, count, _list(ins), _list(outs), tail)
    raise ValueError(f"unknown trace event {event!r}")


def _scenario_literal(scenario: Scenario) -> str:
    """Luau table literal for one recorded scenario."""
    fields = [
        "name = %s" % _string(scenario.name),
        "programs = %s" % _list(scenario.programs),
        "globals = %s" % _list(scenario.globals or []),
        "events = { %s }" % ", ".join(_event(event) for event in scenario.events),
    ]
    return "{ %s }" % ", ".join(fields)


# The catalogue types the runtime holds in an integer slot (IsIntegerType), which take a number that fits as an INT.
INTEGER_TYPES = frozenset({"s8", "u8", "s16", "u16", "s32", "u32", "unknown"})


def _read(param: dict) -> str:
    """How a handler reads a parameter, as the letter same_inputs compares it by."""
    if param["dir"] == "inout":
        return "r"
    if param["dir"] != "in":
        # Ext passes a value where the handler expects a reference: SetStack writes nothing, and a read is the slot.
        return "t"
    if param.get("tagged") or param["type"] in ("string", "unknown"):
        return "t"
    if param["type"] == "f32":
        return "f"
    return "i" if param["type"] in INTEGER_TYPES else "t"


def _integer(param: dict) -> str:
    """"1" when the runtime marshals a parameter as an integer type."""
    return "1" if param["type"] in INTEGER_TYPES else "0"


def _ext_reads(kind_catalog: dict) -> dict[int, dict[int, str]]:
    """Per command and argument count the handler accepts, how it reads each argument an Ext call passes."""
    table: dict[int, dict[int, str]] = {}
    for command in kind_catalog["commands"]:
        for signature in command.get("signatures", []):
            if not signature.get("handler_rejects"):
                table.setdefault(command["no"], {})[signature["argc"]] = "".join(_read(p) for p in signature["params"])
    return table


def _dispatch(name: str, namespace: str, command: dict, signatures: list[dict] | None = None) -> list[str]:
    """Luau mock functions for every catalogued arity of a command, plus the unsuffixed dispatcher.

    A mock of a tagged signature checks the type its call gives the parameter the handler branches on against the tag
    the handler read, and reads a bit-copying output's recorded bits as its variant's type. signatures, when given,
    replaces the command's own: the tagged signatures retyped for an Int or Float variant.
    """
    lines = []
    chosen: dict[int, tuple[tuple[int, int], dict]] = {}
    for signature in command.get("signatures", []) if signatures is None else signatures:
        argc = signature["argc"]
        params = signature["params"]
        inputs = sum(1 for param in params if param["dir"] in api.INPUTS)
        outputs = sum(1 for param in params if param["dir"] in api.OUTPUTS)
        typed = next((param["type"] for param in params if param.get("tagged") and param["dir"] == "in"), None)
        if typed is None:
            typed = next(
                (
                    param["type"]
                    for param in params
                    if param.get("tagged") and param["dir"] in api.OUTPUTS and not param.get("copies")
                ),
                None,
            )
        copies = [
            f"[{index}] = {'true' if param['type'] == 'f32' else 'false'}"
            for index, param in enumerate((param for param in params if param["dir"] in api.OUTPUTS), 1)
            if param.get("copies")
        ]
        inputs_ = [param for param in params if param["dir"] in api.INPUTS]
        tag = (
            ", " + (_string(typed) if typed is not None else "nil")
            + ", " + ("{ " + ", ".join(copies) + " }" if copies else "nil")
            + ", " + _string("".join(_read(param) for param in inputs_))
            + ", " + _string("".join(_integer(param) for param in inputs_))
        )
        lines.append(
            f"{namespace}.{name}_{argc} = function(...)\n"
            f"    local outs = ext_call({command['no']}, {argc}, table.pack(...){tag})\n"
            "    return table.unpack(outs, 1, outs.n)\n"
            "end"
        )
        key = (outputs, -argc)
        if inputs not in chosen or key > chosen[inputs][0]:
            chosen[inputs] = (key, signature)
    if not chosen:
        return lines
    lines.append(f"{namespace}.{name} = function(...)")
    lines.append("    local count = select(\"#\", ...)")
    for inputs, (_, signature) in sorted(chosen.items()):
        lines.append(f"    if count == {inputs} then")
        lines.append(f"        return {namespace}.{name}_{signature['argc']}(...)")
        lines.append("    end")
    lines.append(f'    fail("{namespace}.{name}: no arity takes " .. count .. " inputs")')
    lines.append("end")
    return lines


_RUNTIME_HEAD = """local MISMATCH = {}
-- Raised when the script reaches a cut event: the rest of the run is not compared.
local CUT = {}
local events, cursor, failure = {}, 1, nil

-- Renders a trace value for mismatch messages.
local function show(value)
    if type(value) ~= "table" then
        return tostring(value)
    end
    local parts = {}
    for i = 1, value.n or #value do
        parts[i] = show(value[i])
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end

-- Records a mismatch and aborts the running scenario.
local function fail(message)
    failure = message
    error(MISMATCH, 0)
end

-- Compares an expected trace value with the value the script produced. Both sides compute floats in float32, so
-- numbers must be equal: a float one ulp off (a double sine rounded afterwards, say) fails. NaN matches only NaN. With
-- float, the value is a float the script may store or pass on, whose bits a native handler can copy and an integer
-- load read back, so a zero must also have the expected sign. An integer is a double in Luau, where -0 is 0.
local function same(expected, got, float)
    if expected == nil or got == nil then
        return false
    end
    if expected == got then
        return not float or expected ~= 0 or 1 / expected == 1 / got
    end
    if type(expected) == "number" and type(got) == "number" then
        return expected ~= expected and got ~= got
    end
    return false
end

-- The float32 a native handler receives for a Luau number, as the runtime marshals a float argument.
local function f32(value)
    return (string.unpack("<f", string.pack("<f", value)))
end

-- Compares two counted lists element by element.
local function same_list(expected, got)
    if expected.n ~= got.n then
        return false
    end
    local integers = expected.i
    for i = 1, got.n do
        local value = got[i]
        if not same(expected[i], value, type(value) == "number" and not (integers ~= nil and string.sub(integers, i, i) == "i")) then
            return false
        end
    end
    return true
end

-- Whether the runtime passes a number to an integer parameter as an integer (FitsInteger), which drops a zero's sign.
local function fits_integer(value)
    return math.floor(value) == value and value >= -2147483648 and value < 4294967296
end

-- The 32 bits of a float32, as a signed integer.
local function float_bits(value)
    return (string.unpack("<i4", string.pack("<f", value)))
end

-- An integer wrapped into 32 bits, as SetInteger stores it; a negative zero becomes 0.
local function wrap(value)
    value = value % 4294967296
    return value >= 2147483648 and value - 4294967296 or value
end

-- The slot the runtime's MarshalValue makes of a Luau value for a parameter whose type is an integer type or not: its
-- tag and its payload (an integer's value, a float's 32 bits or a string's text).
local function marshal(value, integer)
    local kind = type(value)
    if kind == "number" then
        if integer and fits_integer(value) then
            return "int", wrap(value)
        end
        return "float", float_bits(value)
    elseif kind == "string" then
        return "str", value
    elseif kind == "boolean" then
        return "int", value and 1 or 0
    elseif value == nil then
        return "int", 0
    end
    return kind, tostring(value)
end

-- The slot retail pushed for a recorded input: an integer-marked number is an INT, any other number a FLOAT.
local function pushed(value, integer)
    if type(value) == "number" then
        if integer then
            return "int", wrap(value)
        end
        return "float", float_bits(value)
    elseif type(value) == "string" then
        return "str", value
    end
    return "int", 0
end

-- GetStackFloat: the float bits a handler reads from a slot, converting an integer.
local function read_float(tag, payload)
    return tag == "int" and float_bits(payload) or payload
end

-- GetStackInt: the integer a handler reads from a slot, truncating a float; out of range, as the PC's conversion does.
local function read_int(tag, payload)
    if tag ~= "float" then
        return payload
    end
    local value = (string.unpack("<f", string.pack("<i4", payload)))
    if value ~= value or value >= 2147483648 or value < -2147483648 then
        return -2147483648
    end
    return value >= 0 and math.floor(value) or -math.floor(-value)
end

-- Whether two float payloads are equal: their 32 bits, so a NaN matches only the NaN of the same sign and payload,
-- which a handler that stores the float's bits passes on.
local function same_bits(a, b)
    return a == b
end

-- The number a slot holds, for an input no handler reads.
local function slot_number(tag, payload)
    return tag == "float" and (string.unpack("<f", string.pack("<i4", payload))) or payload
end

-- Compares a native call's inputs as the handler sees them: the slot the runtime marshals from the Luau value against
-- the slot retail pushed, each read the way the handler reads that parameter. reads has one letter per input:
--   "f", "i": the handler reads the parameter with GetStackFloat or GetStackInt, which convert the other tag, so what
--             compares is the float's bits (a zero's sign included) or the integer;
--   "t":      the handler may read the tag and the payload as they are (a tagged parameter, one of unknown type or a
--             string), so both compare;
--   "r":      an in-out parameter, which the handler reads as float bits through the reference;
--   "x":      no handler reads it (an Ext call of a command the kind does not register or of an arity the handler
--             refuses), so the numbers compare, but not their tags.
-- integers has a "1" for each input whose parameter type is an integer type (every input of Ext, which the runtime
-- marshals as an unknown type): the runtime passes a number that fits an integer as an INT, which drops a zero's sign,
-- and any other number as a FLOAT; for a float type it always passes a FLOAT.
local function same_inputs(expected, got, reads, integers)
    if expected.n ~= got.n then
        return false
    end
    local marks = expected.i
    for i = 1, got.n do
        local read = reads ~= nil and string.sub(reads, i, i) or "t"
        local want_tag, want = pushed(expected[i], marks ~= nil and string.sub(marks, i, i) == "i")
        local got_tag, value = marshal(got[i], integers == nil or string.sub(integers, i, i) == "1")
        local ok
        if want_tag == "str" or got_tag == "str" or read == "t" then
            ok = want_tag == got_tag and (want == value or want_tag == "float" and same_bits(want, value))
        elseif read == "f" then
            ok = same_bits(read_float(want_tag, want), read_float(got_tag, value))
        elseif read == "i" then
            ok = read_int(want_tag, want) == read_int(got_tag, value)
        elseif read == "r" then
            ok = same_bits(want, value)
        else
            ok = same(slot_number(want_tag, want), slot_number(got_tag, value), want_tag == "float" and got_tag == "float")
        end
        if not ok then
            return false
        end
    end
    return true
end

-- Whether the script, about to produce an event of the given kind (or to raise an error with the given message),
-- reaches the place where the reference trace was cut.
local function reaches(cut, kind, detail)
    if cut[2] == "frame" then
        -- The reference run left the frame here, where the translation's vm.index raises its error.
        return kind == "error" and string.find(tostring(detail), "is outside the frame", 1, true) ~= nil
    end
    -- At the step budget the comparison only stops: what the script does from here on is not checked, and the
    -- scenario counts as a compared prefix, never as a pass.
    return true
end

-- Takes the next event of the trace, for a script about to produce an event of the given kind; at a cut, ends the
-- comparison when the script reaches the place where the reference was cut, and fails otherwise.
local function next_event(kind, detail)
    local event = events[cursor]
    if event ~= nil and event[1] == "cut" then
        if reaches(event, kind, detail) then
            error(CUT, 0)
        end
        fail(("event %d: the reference was cut at %s, but the script produced %s"):format(
            cursor, show(event), show({ kind, detail })))
    end
    cursor = cursor + 1
    return event
end

-- Consumes the next event, which must carry the given tag and integer field.
local function expect(tag, field)
    local at = cursor
    local event = next_event(tag, field)
    if event == nil or event[1] ~= tag or (field ~= nil and not same(event[2], field)) then
        local got = field == nil and table.pack(tag) or table.pack(tag, field)
        fail(("event %d: expected %s, got %s"):format(at, show(event), show(got)))
    end
end

-- Checks a native call against the next event and returns the recorded outputs; typed is the integer or float
-- type the call gives a tagged handler, checked against the tag the handler read, copies maps the outputs a
-- handler copies as raw bits to whether the call's variant reads them as a float, and reads and integers say how the
-- handler reads each input and whether the runtime marshals it as an integer type (see same_inputs).
local function ext_call(no, argc, args, typed, copies, reads, integers)
    local at = cursor
    local event = next_event("ext", no)
    if event == nil or event[1] ~= "ext" or event[2] ~= no or event[3] ~= argc
        or not same_inputs(event[4], args, reads, integers) then
        fail(("event %d: expected %s, got %s"):format(at, show(event), show({ "ext", no, argc, args })))
    end
    if typed ~= nil and event[6] ~= nil and event[6] ~= typed then
        fail(("event %d: the handler read %s, the call passes %s"):format(at, event[6], typed))
    end
    local outs = event[5]
    if copies ~= nil then
        outs = table.clone(outs)
        for index, as_float in copies do
            if as_float and outs[index] ~= nil then
                outs[index] = string.unpack("<f", string.pack("<i4", outs[index]))
            end
        end
    end
    return outs
end

-- Checks the values a call's references name, after the call copies them back, against the next event.
__ref = function(call, ...)
    local values = table.pack(...)
    local at = cursor
    local event = next_event("ref")
    if event == nil or event[1] ~= "ref" or event[2] ~= call or not same_list(event[3], values) then
        fail(("event %d: expected %s, got %s"):format(at, show(event), show({ "ref", call, values })))
    end
end

-- Checks each printed value against the next event.
print = function(...)
    local values = table.pack(...)
    local at = cursor
    local event = next_event("print")
    if event == nil or event[1] ~= "print" or not same_list(event[2], values) then
        fail(("event %d: expected %s, got %s"):format(at, show(event), show(table.pack("print", values))))
    end
end
"""

_RUNTIME_TAIL = """
-- Runs one program to its end, checking each wait; returns "errored" when the script raised an error.
local function run_program(fn)
    local co = coroutine.create(fn)
    local ok, result = coroutine.resume(co)
    while true do
        if not ok then
            if result == MISMATCH or result == CUT then
                error(result, 0)
            end
            local at = cursor
            local event = next_event("error", result)
            if event == nil or event[1] ~= "error" then
                fail(("event %d: expected %s, got error %s"):format(at, show(event), tostring(result)))
            end
            return "errored"
        end
        if coroutine.status(co) == "dead" then
            if type(result) == "boolean" then
                fail("program returned a boolean")
            end
            if result == nil then
                result = 0
            end
            expect("end", result)
            return "done"
        end
        expect("wait")
        local following = events[cursor]
        if following ~= nil and following[1] == "suspended" then
            cursor = cursor + 1
            return "done"
        end
        ok, result = coroutine.resume(co)
    end
end

-- Runs the scenario's programs in order, then checks the trace is used up and the globals match.
local function execute(scenario, m)
    for i = 1, scenario.programs.n do
        local no = scenario.programs[i]
        local fn = m[HANDLERS[no] or no]
        if fn == nil then
            expect("missing", no)
        elseif run_program(fn) == "errored" then
            break
        end
    end
    if cursor <= #events then
        fail(#events - cursor + 1 .. " events not reached, next is " .. show(events[cursor]))
    end
    if m.__globals ~= nil then
        local got = m.__globals()
        local count = scenario.globals.n
        if (got.n or #got) ~= count then
            fail("expected " .. count .. " globals, got " .. tostring(got.n or #got))
        end
        local integers = scenario.globals.i
        for i = 1, count do
            if not same(scenario.globals[i], got[i], not (integers ~= nil and string.sub(integers, i, i) == "i")) then
                fail("global " .. i .. ": expected " .. show(scenario.globals[i]) .. ", got " .. show(got[i]))
            end
        end
    end
end

-- Runs one scenario against a fresh module instance; returns nil when it matched up to its end or its cut, or the
-- failure message.
local function run_scenario(scenario)
    events, cursor, failure = scenario.events, 1, nil
    resetbudget()
    local ok, err = pcall(function()
        local m = loadmodule(MODULE)
        execute(scenario, m)
    end)
    if ok or err == CUT then
        return nil
    end
    if err == MISMATCH then
        return failure
    end
    return "script error: " .. tostring(err)
end

for _, scenario in ipairs(SCENARIOS) do
    local message = run_scenario(scenario)
    if message == nil then
        real_print("PASS " .. scenario.name)
    else
        real_print("FAIL " .. scenario.name .. " " .. message)
    end
end
"""


def driver(
    module: str, namespace: str, kind_catalog: dict, scenario_list: list[Scenario], names: dict[int, str]
) -> str:
    """Luau source of the host driver that replays the scenarios against a module."""
    handlers = {SETUP: "setup", **names}
    lines = [
        "-- Generated by tools/luau/stb2luau/harness.py: replays recorded reference VM traces.",
        "local real_print = print",
        f"local MODULE = {_string(module)}",
        _RUNTIME_HEAD,
        f"{namespace} = {{}}",
        "local HANDLERS = {",
        *(f"    [{no}] = {_string(name)}," for no, name in sorted(handlers.items())),
        "}",
    ]
    for command in kind_catalog["commands"]:
        lines.extend(_dispatch(command["luau"], namespace, command))
        tagged = [signature for signature in command.get("signatures", []) if api.tagged(signature)]
        for type_name, suffix in api.VARIANTS.items() if tagged else ():
            retyped = [api.variant(signature, type_name) for signature in tagged]
            lines.extend(_dispatch(command["luau"] + suffix, namespace, command, retyped))
    ext_reads = _ext_reads(kind_catalog)
    lines.append("-- How the handler reads each argument of an Ext call it accepts; any other Ext call's arguments go unread.")
    lines.append("local EXT_READS = {")
    for no, arities in sorted(ext_reads.items()):
        lines.append(f"    [{no}] = {{ " + ", ".join(f"[{argc}] = {_string(reads)}" for argc, reads in sorted(arities.items())) + " },")
    lines.append("}")
    lines.append(
        f"{namespace}.Ext = function(no, ...)\n"
        "    local args = table.pack(...)\n"
        "    local reads = EXT_READS[no] and EXT_READS[no][args.n] or string.rep(\"x\", args.n)\n"
        "    local outs = ext_call(no, args.n, args, nil, nil, reads, string.rep(\"1\", args.n))\n"
        "    if outs.n ~= 0 then\n"
        '        fail("ext " .. tostring(no) .. " returns no outputs")\n'
        "    end\n"
        "end"
    )
    lines.append("local SCENARIOS = {")
    lines.extend(f"    {_scenario_literal(scenario)}," for scenario in scenario_list)
    lines.append("}")
    lines.append(_RUNTIME_TAIL)
    return "\n".join(lines)


def run(
    scripts_root: Path,
    module: str,
    program: Program,
    kind_catalog: dict,
    namespace: str,
    seeds: range | list[int] = range(4),
    names: dict[int, str] | None = None,
    probes: frozenset[int] = frozenset(),
    views: FloatViews | None = None,
    folded: frozenset[int] = frozenset(),
) -> dict:
    """Record the scenarios, replay them against the module under luau-harness, and summarise the results.

    The names map program numbers to the handler names the module defines them under; other numbers are read as
    script[number]. probes holds the CALL offsets after which the module reports the values of the call's references,
    views which variables the script loads as floats, and folded the float operations the module folded.

    The summary counts the scenarios that matched to their end ("pass") and lists the scenarios that matched up to a
    cut: "prefix" for a step budget and "unsupported" for an access outside a frame. "coverage" is the instruction
    coverage of the reference runs, and "compared" that of the matching scenarios up to their last compared event.
    """
    recorded = scenarios(program, kind_catalog, seeds, probes, views, folded)
    source = driver(module, namespace, kind_catalog, recorded, names or {})
    with tempfile.TemporaryDirectory() as directory:
        driver_path = Path(directory) / "driver.luau"
        driver_path.write_text(source, encoding="utf-8")
        completed = subprocess.run(
            [str(HOST), str(scripts_root), str(driver_path)],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=600,
            check=False,
        )
    by_name = {scenario.name: scenario for scenario in recorded}
    passed = 0
    failed: list[str] = []
    prefix: list[Scenario] = []
    unsupported: list[Scenario] = []
    matched: list[Scenario] = []
    for line in completed.stdout.splitlines():
        if line.startswith("PASS "):
            scenario = by_name[line[len("PASS ") :]]
            matched.append(scenario)
            if scenario.cut is None:
                passed += 1
            elif scenario.unsupported:
                unsupported.append(scenario)
            else:
                prefix.append(scenario)
        elif line.startswith("FAIL "):
            failed.append(line)
    return {
        "pass": passed,
        "fail": failed,
        "prefix": prefix,
        "unsupported": unsupported,
        "coverage": coverage(program, recorded),
        "compared": coverage(program, matched, compared=True),
        "stderr": completed.stderr,
        "returncode": completed.returncode,
    }
