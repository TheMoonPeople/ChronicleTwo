"""Mutation sweep of the differential harness: changes each native call argument of sample modules and checks that the
harness rejects every change the handler would see.

For each argument of each native call in a module, each mutation that can change what its handler reads is tried:
  ulp+ / ulp-  the neighbouring float32 (an integer becomes a float next to it);
  zero         a float zero of the other sign;
  fraction     an integer plus a tiny fraction, the same float32 but a FLOAT slot where the runtime made an INT;
  inc          the number plus one;
  variant      the call's other Int or Float variant, for the argument a tagged handler branches on;
  payload      a NaN with another payload;
  nansign      a NaN with the other sign.
The mutated argument is wrapped in __mutate(op, read, argument). Each mutation runs twice against the recorded traces:
first as a probe, which raises an error wherever the mutation would change the argument, so a failing probe shows the
mutation is reached in a compared scenario and changes what the handler reads; then as the mutant, which must fail.
A reached mutation whose mutant passes is a survivor. Which mutations apply and what each changes follow the runtime's
MarshalValue and the retail GetStackInt and GetStackFloat (see harness.same_inputs), so every reached mutation changes
the slot the handler reads, as the handler reads it.

Run: python tools/luau/stb2luau/mutate.py [--data DATA] [--only PATH ...] [--seeds N] [--jobs N]
The exit status is 1 when a mutation survives and 77 when no game data is available.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import dataclasses
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
TOOLS = HERE.parent
if str(TOOLS) not in sys.path:
    sys.path.insert(0, str(TOOLS))

from stb.corpus import classify  # noqa: E402
from stb2luau import api, harness, transpile  # noqa: E402
from stb2luau.emit import handlers  # noqa: E402
from survey import resolve_data  # noqa: E402

SKIP = 77
# Shipped scripts of every kind the runtime runs, with tagged, in-out, float and integer parameters among them.
SAMPLE = (
    "dungeon/monster/b07a_atora_red.stb",
    "dungeon/monster/b08a.stb",
    "dungeon/monster/polhana.stb",
    "dungeon/act_script/c01a.stb",
    "dungeon/eff_script/m_fballf_l.stb",
    "dungeon/eff_script/m_smoke.stb",
    "event/tbox/bomb.pack/tbox_exp.stb",
    "dungeon/sphida/mizu_eff.assets/foot_splatter.stb",
)
# The mutations that can change what a handler reads, by how it reads the input (harness._read) and whether the
# runtime marshals it as an integer type: a float zero's sign survives only a float slot, a fraction changes only an
# integer slot's tag, and GetStackInt truncates a neighbouring float back to the same integer. Unread inputs ("x") are
# left alone.
NAN_OPS = ("payload", "nansign")
OPS = {
    ("f", "0"): ("ulp+", "ulp-", "zero", "inc", *NAN_OPS),
    ("i", "1"): ("inc",),
    ("t", "0"): ("ulp+", "ulp-", "zero", "inc", *NAN_OPS),
    ("t", "1"): ("ulp+", "ulp-", "fraction", "inc", *NAN_OPS),
    ("r", "0"): ("ulp+", "ulp-", "zero", "inc", *NAN_OPS),
    ("r", "1"): ("ulp+", "ulp-", "fraction", "inc", *NAN_OPS),
}
PROBE = "__mutation_probe"
PRELUDE = """__mutate = function(op, read, x)
    if type(x) ~= "number" then
        return x
    end
    local y
    if op == "payload" or op == "nansign" then
        -- Another NaN, as the float32 a handler receives: a payload bit or the sign bit flipped.
        if x == x then
            return x
        end
        local bits = (string.unpack("<I4", string.pack("<f", x)))
        local flip = 0x80000000
        if op == "payload" then
            flip = bit32.band(bits, 0x7ffffe) ~= 0 and 1 or 2
        end
        y = (string.unpack("<f", string.pack("<I4", bit32.bxor(bits, flip))))
    elseif x ~= x or math.abs(x) == math.huge then
        return x
    elseif op == "ulp+" or op == "ulp-" then
        local f = (string.unpack("<f", string.pack("<f", x)))
        local bits = (string.unpack("<i4", string.pack("<f", f)))
        local up = op == "ulp+"
        if f == 0 then
            bits = up and 1 or -2147483647
        elseif (f > 0) == up then
            bits += 1
        else
            bits -= 1
        end
        y = (string.unpack("<f", string.pack("<i4", bits)))
    elseif op == "zero" then
        if x ~= 0 then
            return x
        end
        y = 1 / x > 0 and -0.0 or 0.0
    elseif op == "fraction" then
        if math.floor(x) ~= x or math.abs(x) >= 2 ^ 20 then
            return x
        end
        y = x + (math.abs(x) + 1) * 2 ^ -40
    elseif op == "inc" then
        if math.abs(x) >= 2 ^ 24 or (read == "i" and x < 0 and math.floor(x) ~= x) then
            return x
        end
        y = x + 1
    elseif op == "variant" then
        -- The other variant marshals a number that fits an integer with the other tag.
        if not (math.floor(x) == x and x >= -2147483648 and x < 4294967296) then
            return x
        end
        y = x
    end
    if __MODE == "probe" then
        error("__mutation_probe", 0)
    end
    return y
end
"""


@dataclasses.dataclass
class Call:
    """A native call in a module's text: its name, the span of each argument, and how each input is read and marshalled."""

    name: str
    start: int
    name_end: int
    args: list[tuple[int, int]]
    reads: str
    integers: str
    tagged: int | None
    variant: str | None


@dataclasses.dataclass
class Mutant:
    """One mutation of one argument."""

    call: Call
    position: int
    op: str


@dataclasses.dataclass
class Report:
    path: str
    reached: int = 0
    killed: int = 0
    survivors: list[str] = dataclasses.field(default_factory=list)
    unreached: int = 0
    error: str | None = None


def _skip_string(text: str, at: int) -> int:
    """The index after the string literal starting at text[at]."""
    quote = text[at]
    if quote == "[":
        level = re.match(r"\[=*\[", text[at:]).group(0)
        close = "]" + "=" * (len(level) - 2) + "]"
        return text.index(close, at) + len(close)
    at += 1
    while text[at] != quote:
        at += 2 if text[at] == "\\" else 1
    return at + 1


def _skip_comment(text: str, at: int) -> int:
    """The index after the comment starting at text[at] ("--")."""
    long = re.match(r"--\[=*\[", text[at:])
    if long:
        return _skip_string(text, at + 2)
    end = text.find("\n", at)
    return len(text) if end < 0 else end


def calls(text: str, namespace: str, kind_catalog: dict) -> list[Call]:
    """The native calls of a module's code, outside strings and comments, with their argument spans."""
    found = []
    pattern = re.compile(r"\b" + re.escape(namespace) + r"\.(\w+)\(")
    at = 0
    while at < len(text):
        char = text[at]
        if text.startswith("--", at):
            at = _skip_comment(text, at)
            continue
        if char in "\"'" or re.match(r"\[=*\[", text[at:at + 8] or ""):
            at = _skip_string(text, at)
            continue
        match = pattern.match(text, at) if (at == 0 or not (text[at - 1].isalnum() or text[at - 1] in "_.")) else None
        if match is None:
            at += 1
            continue
        args, _ = _arguments(text, match.end())
        name_end = match.start() + len(namespace) + 1 + len(match.group(1))
        call = _resolve(text, match.group(1), match.start(), name_end, args, kind_catalog)
        if call is not None:
            found.append(call)
        at = match.end()
    return found


def _arguments(text: str, at: int) -> tuple[list[tuple[int, int]], int]:
    """The spans of the top-level arguments of a call whose "(" ends at at, and the index after its ")"."""
    spans = []
    depth = 0
    start = at
    while True:
        char = text[at]
        if text.startswith("--", at):
            at = _skip_comment(text, at)
            continue
        if char in "\"'" or (char == "[" and re.match(r"\[=*\[", text[at:])):
            at = _skip_string(text, at)
            continue
        if char in "([{":
            depth += 1
        elif char in ")]}":
            if depth == 0:
                if text[start:at].strip():
                    spans.append(_trim(text, start, at))
                return spans, at + 1
            depth -= 1
        elif char == "," and depth == 0:
            spans.append(_trim(text, start, at))
            start = at + 1
        at += 1


def _trim(text: str, start: int, end: int) -> tuple[int, int]:
    while text[start].isspace():
        start += 1
    while text[end - 1].isspace():
        end -= 1
    return start, end


def _resolve(
    text: str, name: str, start: int, name_end: int, args: list[tuple[int, int]], kind_catalog: dict
) -> Call | None:
    """The call's signature, as the runtime picks it, and how each input is read; None for a command not catalogued."""
    if name == "Ext":
        # The command number is not mutated; the others are marshalled as an unknown type and read as the handler of an
        # accepted arity reads them, or not at all.
        number = text[args[0][0] : args[0][1]] if args else ""
        no = int(number) if number.isdigit() else None
        reads = harness._ext_reads(kind_catalog).get(no, {}).get(len(args) - 1, "x" * (len(args) - 1))
        return Call(name, start, name_end, args, "x" + reads, "1" * len(args), None, None)
    match = re.fullmatch(r"(\w+?)(Int|Float)?(?:_(\d+))?", name)
    base, suffix, argc = match.group(1), match.group(2), match.group(3)
    command = next((entry for entry in kind_catalog["commands"] if entry["luau"] == base), None)
    if command is None:
        command = next((entry for entry in kind_catalog["commands"] if entry["luau"] == name), None)
        base, suffix, argc = name, None, None
    if command is None:
        return None
    signatures = command.get("signatures", [])
    if suffix is not None:
        type_name = next(key for key, value in api.VARIANTS.items() if value == suffix)
        signatures = [api.variant(signature, type_name) for signature in signatures if api.tagged(signature)]
    inputs = len(args)
    if argc is not None:
        chosen = [signature for signature in signatures if signature["argc"] == int(argc)]
    else:
        chosen = [s for s in signatures if sum(p["dir"] in api.INPUTS for p in s["params"]) == inputs]
        chosen.sort(key=lambda s: (-sum(p["dir"] in api.OUTPUTS for p in s["params"]), s["argc"]))
    if not chosen:
        return None
    params = [param for param in chosen[0]["params"] if param["dir"] in api.INPUTS]
    reads = "".join(harness._read(param) for param in params)
    integers = "".join(harness._integer(param) for param in params)
    tagged = next((i for i, param in enumerate(params) if param.get("tagged") and param["dir"] == "in"), None)
    variant = None
    # The unsuffixed name marshals the catalogued type, which the other variant replaces.
    current = suffix or (api.VARIANTS.get(params[tagged]["type"]) if tagged is not None else None)
    if current is not None:
        variant = base + ("Float" if current == "Int" else "Int") + (f"_{argc}" if argc is not None else "")
    return Call(name, start, name_end, args, reads, integers, tagged, variant)



def mutants(found: list[Call]) -> list[Mutant]:
    """Every mutation that applies to an argument's kind, plus the variant swap of a tagged handler's input."""
    result = []
    for call in found:
        for position in range(min(len(call.args), len(call.reads))):
            for op in OPS.get((call.reads[position], call.integers[position]), ()):
                result.append(Mutant(call, position, op))
        if call.variant is not None and call.tagged is not None and call.tagged < len(call.args):
            result.append(Mutant(call, call.tagged, "variant"))
    return result


def mutated(text: str, mutant: Mutant, mode: str) -> str:
    """The module text with one argument wrapped in __mutate, and for a variant swap in mutant mode, the call renamed."""
    call = mutant.call
    start, end = call.args[mutant.position]
    read = call.reads[mutant.position]
    body = text[:start] + f'__mutate("{mutant.op}", "{read}", {text[start:end]})' + text[end:]
    if mutant.op == "variant" and mode == "mutant":
        body = body[: call.start] + body[call.start : call.name_end].replace(call.name, call.variant) + body[call.name_end :]
    return f'__MODE = "{mode}"\n' + PRELUDE + body


def _line(text: str, at: int) -> int:
    return text.count("\n", 0, at) + 1


def sweep(path: str, data: bytes, catalog: dict, seeds: range, jobs: int) -> Report:
    """Runs every mutation of one script's module against its recorded traces."""
    report = Report(path)
    result, module = transpile.transpile(path, data)
    if module is None:
        report.error = f"not transpiled: {result.error}"
        return report
    module = dataclasses.replace(module, expose_globals=True, probe_refs=True)
    emitted = transpile.emit_corpus([(result, module)], catalog).modules.get(path)
    if emitted is None:
        report.error = "not emitted"
        return report
    kind = catalog["kinds"][classify(path).value]
    names = {no: info.name for no, info in handlers(classify(path).value).items()}
    recorded = harness.scenarios(
        result.program, kind, seeds, frozenset(emitted.probes), harness.FloatViews(result.float_refs, result.float_globals),
        result.folded,
    )
    source = harness.driver(result.module, kind["namespace"], kind, recorded, names)
    found = calls(emitted.text, kind["namespace"], kind)
    todo = mutants(found)
    with tempfile.TemporaryDirectory() as scratch:
        roots = []
        for index in range(max(1, jobs)):
            root = Path(scratch) / f"root{index}"
            root.mkdir()
            transpile._support(root, transpile.OUTPUT)
            (root / f"{result.module}.luau").parent.mkdir(parents=True, exist_ok=True)
            roots.append(root)
        driver_path = Path(scratch) / "driver.luau"
        driver_path.write_text(source, encoding="utf-8")

        def failures(root: Path, text: str) -> list[str]:
            (root / f"{result.module}.luau").write_text(text, encoding="utf-8", newline="\n")
            completed = subprocess.run(
                [str(harness.HOST), str(root), str(driver_path)], capture_output=True, text=True, encoding="utf-8",
                errors="replace", timeout=600, check=False,
            )
            lines = [line for line in completed.stdout.splitlines() if line.startswith("FAIL ")]
            if completed.returncode != 0 and not lines:
                lines.append(f"FAIL host exited {completed.returncode}: {completed.stderr.strip()[-200:]}")
            return lines

        baseline = failures(roots[0], emitted.text)
        if baseline:
            report.error = f"the unmutated module fails: {baseline[0]}"
            return report

        def worker(index: int) -> list[tuple[Mutant, str]]:
            outcomes = []
            for mutant in todo[index :: len(roots)]:
                probe = failures(roots[index], mutated(emitted.text, mutant, "probe"))
                if not any(PROBE in line for line in probe):
                    outcomes.append((mutant, "unreached"))
                    continue
                outcomes.append((mutant, "killed" if failures(roots[index], mutated(emitted.text, mutant, "mutant")) else "survived"))
            return outcomes

        with concurrent.futures.ThreadPoolExecutor(max_workers=len(roots)) as pool:
            outcomes = [outcome for chunk in pool.map(worker, range(len(roots))) for outcome in chunk]
    for mutant, outcome in outcomes:
        if outcome == "unreached":
            report.unreached += 1
            continue
        report.reached += 1
        if outcome == "killed":
            report.killed += 1
        else:
            start, end = mutant.call.args[mutant.position]
            report.survivors.append(
                f"line {_line(emitted.text, mutant.call.start)}: {mutant.call.name} argument {mutant.position + 1} "
                f"({emitted.text[start:end]}, read {mutant.call.reads[mutant.position]}): {mutant.op}"
            )
    return report


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--data", type=Path, help="data root, data.zip, or a directory of extracted scripts")
    parser.add_argument("--only", action="append", default=[], help="sweep only this data-relative path, repeatable")
    parser.add_argument("--seeds", type=int, default=4, help="harness seeds per script (default: 4)")
    parser.add_argument("--jobs", type=int, default=4, help="concurrent harness hosts (default: 4)")
    args = parser.parse_args(argv)
    source = resolve_data(args.data)
    if source is None:
        print("no game data: set DC2_DATA or pass --data", file=sys.stderr)
        return SKIP
    if not harness.HOST.exists():
        print(f"luau-harness is not built: {harness.HOST}", file=sys.stderr)
        return SKIP
    wanted = set(args.only or SAMPLE)
    catalog = json.loads(transpile.CATALOG.read_text(encoding="utf-8"))
    kinds = {classify(path).value for path in wanted}
    selected = [(path, data) for path, data in transpile.corpus(source, kinds) if path in wanted]
    missing = wanted - {path for path, _ in selected}
    if missing:
        print(f"not in the corpus: {', '.join(sorted(missing))}", file=sys.stderr)
        return 1
    status = 0
    reached = killed = 0
    for path, data in sorted(selected):
        report = sweep(path, data, catalog, range(args.seeds), args.jobs)
        if report.error is not None:
            print(f"{path}: {report.error}")
            status = 1
            continue
        reached += report.reached
        killed += report.killed
        print(f"{path}: {report.killed} of {report.reached} reached mutations killed, {report.unreached} unreached")
        for survivor in report.survivors:
            print(f"  survived: {survivor}")
        if report.survivors:
            status = 1
    rate = 100.0 * killed / reached if reached else 100.0
    print(f"mutation sweep: {killed} of {reached} reached mutations killed ({rate:.1f}%)")
    return status


if __name__ == "__main__":
    sys.exit(main())
