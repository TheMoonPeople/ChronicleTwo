"""Transpiles the published scripts into Luau modules under port/src/luau, formatted and strictly checked.

Each script of the selected kinds becomes `<out>/<module>.luau`. The module is the data-relative path without its
extension: "dungeon/act_script/f03a.stb" becomes "dungeon/act_script/f03a". The ".stb_" variant drops ".stb_" and
appends "_", so "mainchr/c02.stb_" becomes "mainchr/c02_" and stays distinct from "mainchr/c02".

Transpiling runs in two phases. First each script is decoded and lifted to structured IR. Then, for each kind, helper
bodies that occur in at least two scripts and touch no globals are shared: each becomes `<out>/lib/<kind>/<name>.luau`,
named `helper_<first 8 hex of its canonical key>`, and the scripts call it through `require("@lib/<kind>/<name>")`.

The output also holds `.luaurc` with the `lib` alias and `manifest.json`, which maps each original path to its module
and the SHA-256 of the timing-normalised script bytes, and lists each library with the scripts that use it.

The exit status is 77 when no game data is found or, with --check, when luau-check or luau-harness is not built; 1 when
a script fails to transpile, fails strict checking or fails the differential harness, or with --check when an output
is out of date; and 0 otherwise. A harness scenario that is compared only up to a step budget (prefix) or up to an
access the translation does not model (unsupported) is reported but does not fail the run.
"""

from __future__ import annotations

import argparse
import collections
import concurrent.futures
import dataclasses
import enum
import functools
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
from collections.abc import Iterator
from pathlib import Path, PurePosixPath
from typing import Any

HERE = Path(__file__).resolve().parent
TOOLS = HERE.parent
REPO = HERE.parents[2]
if str(TOOLS) not in sys.path:
    sys.path.insert(0, str(TOOLS))

from stb import corpus as stb_corpus  # noqa: E402
from stb.analysis import Analysis  # noqa: E402
from stb.corpus import Kind, classify  # noqa: E402
from stb.opcodes import FLOAT_MODES, Op  # noqa: E402
from stb.program import DecodeError, Program, decode  # noqa: E402
from stb2luau import harness, ir, tags, timing  # noqa: E402
from stb2luau.emit import (  # noqa: E402
    EmitError,
    FunctionInput,
    Module,
    ModuleInput,
    called_blocks,
    emit,
    emit_library,
    handlers,
    mentioned_slots,
    used_call_blocks,
)
from stb2luau.lift import LiftError, lift, references  # noqa: E402
from stb2luau.structure import StructureError, structure  # noqa: E402
from stb2luau.timing import TimingError  # noqa: E402
from stb2luau.toolchain import executable  # noqa: E402
from survey import resolve_data  # noqa: E402

OUTPUT = REPO / "port/src/luau"
CHECK = REPO / "port/build/luau-harness" / ("luau-check.exe" if os.name == "nt" else "luau-check")
CATALOG = TOOLS / "commands.json"
FALLBACK = TOOLS / "fallback.json"
LUAURC = '{"aliases": {"lib": "./lib"}}\n'
STYLUA_ARGS = ("--indent-type", "Tabs", "--column-width", "120")
BATCH = 100
SKIP = 77
KEY_LENGTH = 8


@dataclasses.dataclass
class Result:
    """The outcome of transpiling one script: its module, the formatted-later text or the error, and diagnostics."""

    path: str
    module: str
    text: str | None
    error: str | None
    diagnostics: list[str]
    program: Program | None
    normalized: bytes | None = None
    folded: frozenset[int] = frozenset()
    float_refs: dict[int, tuple[bool, ...]] = dataclasses.field(default_factory=dict)
    float_globals: frozenset[int] = frozenset()


@dataclasses.dataclass
class Library:
    """A shared helper: its kind and name, the module that defines it, and the scripts that call it."""

    kind: str
    name: str
    module: Module
    users: list[str]


@dataclasses.dataclass
class Corpus:
    """The emitted modules and shared libraries of the lifted scripts, with the scripts that failed to emit."""

    modules: dict[str, Module]
    errors: dict[str, str]
    libraries: list[Library]


@dataclasses.dataclass
class _Shared:
    """A helper body shared by several scripts of one kind, with a representative occurrence to emit from."""

    key: str
    name: str
    users: list[str]
    returns_value: bool
    path: str
    block: int


def module_name(path: str) -> str:
    """Module of a data-relative script path, keeping its directories and dropping its extension.

    ".stb" is dropped. The ".stb_" variant drops ".stb_" and appends "_", so "mainchr/c02.stb_" becomes "mainchr/c02_".
    Other paths drop their last extension.
    """
    lowered = path.lower()
    if lowered.endswith(".stb_"):
        return path[: -len(".stb_")] + "_"
    if lowered.endswith(".stb"):
        return path[: -len(".stb")]
    return PurePosixPath(path).with_suffix("").as_posix()


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _ir_type(analysis_type: str | None) -> str:
    return {ir.INT: ir.INT, ir.FLOAT: ir.FLOAT, ir.STR: ir.STR}.get(analysis_type, ir.ANY)


def _reachable(program: Program) -> list[int]:
    """Blocks of the functions the main function and the programs can call, in address order."""
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
    return sorted(seen)


@functools.cache
def _directions(kind: str) -> dict[tuple[int, int], tuple[str, ...]]:
    """Each parameter's direction, by command and argument count, for the arities a kind's handlers accept."""
    catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
    found: dict[tuple[int, int], tuple[str, ...]] = {}
    for command in catalog["kinds"].get(kind, {}).get("commands", []):
        for signature in command["signatures"]:
            if not signature.get("handler_rejects"):
                found[(command["no"], signature["argc"])] = tuple(param["dir"] for param in signature["params"])
    return found


def _sorted_tags(found: frozenset) -> tuple[str, ...]:
    return tuple(sorted(found))


def _annotate(stmts: list, calls: dict[int, tags.CallFacts]) -> list:
    """The statements with each external call carrying the tag analysis of its arguments."""
    annotated = []
    for stmt in stmts:
        if isinstance(stmt, ir.ExtCall) and stmt.offset in calls:
            facts = calls[stmt.offset]
            entries = []
            for position in range(1, len(stmt.args) + 1):
                if position in facts.destinations:
                    entries.append(
                        ("ref", _sorted_tags(facts.destinations[position]), _sorted_tags(facts.reads.get(position, frozenset())))
                    )
                elif position in facts.values:
                    entries.append(("value", _sorted_tags(facts.values[position])))
                else:
                    entries.append(None)
            stmt = dataclasses.replace(stmt, tags=tuple(entries))
        elif dataclasses.is_dataclass(stmt):
            changes = {
                field.name: _annotate(getattr(stmt, field.name), calls)
                for field in dataclasses.fields(stmt)
                if isinstance(getattr(stmt, field.name), list)
            }
            if changes:
                stmt = dataclasses.replace(stmt, **changes)
        annotated.append(stmt)
    return annotated


def transpile(path: str, data: bytes) -> tuple[Result, ModuleInput | None]:
    """Decodes and lifts one script of the published corpus; the module input is None when it failed."""
    name = module_name(path)
    try:
        normalized = timing.apply(timing.key(path), data)
        program = decode(normalized)
    except (DecodeError, TimingError) as error:
        return Result(path, name, None, str(error), [], None), None

    result = Result(path, name, None, None, [], program, normalized)
    analysis = Analysis(program)
    call_tags = tags.analyse(program, _directions(classify(path).value)).calls
    refs = references(program)
    errors: list[str] = []
    functions: dict[int, FunctionInput] = {}
    folded: set[int] = set()
    for block in _reachable(program):
        try:
            lifted = lift(program, program.functions[block], analysis, refs)
            body = _annotate(structure(lifted), call_tags)
        except (LiftError, StructureError) as error:
            errors.append(f"function {block:#x}: {error}")
            continue
        folded |= lifted.folded
        functions[block] = FunctionInput(
            block=block,
            arg=lifted.arg,
            local=lifted.local,
            slot_types=lifted.slot_types,
            temps=lifted.temps,
            body=body,
            programs=[number for number, target in program.programs if target == block],
            is_main=block == program.main,
            refs=lifted.refs,
            arrays=lifted.arrays,
        )
    if errors:
        result.error = "; ".join(errors)
        return result, None
    result.folded = frozenset(folded)
    result.float_refs = float_references(analysis)
    result.float_globals = float_globals(analysis)

    module = ModuleInput(
        path=path,
        kind=classify(path).value,
        globals={("global", n): _ir_type(analysis.global_types.get(n)) for n in range(program.global_num)},
        functions=functions,
    )
    return result, module


class _Keys:
    """Canonical keys of one script's functions, memoised by header block."""

    def __init__(self, functions: dict[int, FunctionInput]) -> None:
        self.functions = functions
        self.memo: dict[int, str] = {}
        self.active: set[int] = set()

    def key(self, function: FunctionInput) -> str:
        """The SHA-1 of a function's canonical serialization."""
        block = function.block
        if block in self.memo:
            return self.memo[block]
        if block in self.active:
            raise EmitError("recursive script functions are unsupported")
        self.active.add(block)
        parts = [
            f"arg={function.arg}",
            f"local={function.local}",
            f"slots={self.value(sorted(function.slot_types.items()))}",
            f"temps={self.value(function.temps)}",
            f"body={self.value(function.body)}",
        ]
        if function.refs:
            parts.append(f"refs={self.value(function.refs)}")
        if function.arrays:
            parts.append(f"arrays={self.value(sorted(function.arrays.items()))}")
        self.active.discard(block)
        digest = hashlib.sha1("\n".join(parts).encode("utf-8")).hexdigest()
        self.memo[block] = digest
        return digest

    def value(self, value: Any) -> str:
        """The canonical text of an IR value: calls name their callee by key; offsets and defaulted fields are left out."""
        if isinstance(value, ir.Call):
            callee = self.functions.get(value.function)
            if callee is None:
                raise EmitError(f"call to unknown function {value.function:#x}")
            return f"Call(function={self.key(callee)},args={self.value(value.args)},type={self.value(value.type)})"
        if dataclasses.is_dataclass(value) and not isinstance(value, type):
            fields = [
                f"{field.name}={self.value(getattr(value, field.name))}"
                for field in dataclasses.fields(value)
                if field.name != "offset" and getattr(value, field.name) != field.default
            ]
            return f"{type(value).__name__}({','.join(fields)})"
        if isinstance(value, enum.Enum):
            return f"{type(value).__name__}.{value.name}"
        if isinstance(value, (list, tuple)):
            return "[" + ",".join(self.value(item) for item in value) + "]"
        return f"{type(value).__name__}:{value!r}"


def canonical_key(function: FunctionInput, functions: dict[int, FunctionInput]) -> str:
    """The SHA-1 key of a function, in which each call is named by its callee's key rather than its block."""
    return _Keys(functions).key(function)


def shareable_blocks(functions: dict[int, FunctionInput]) -> set[int]:
    """Blocks of the helpers that may be shared: not main or a program, and touching no global in them or below."""
    memo: dict[int, bool] = {}

    def visit(block: int) -> bool:
        if block not in memo:
            # A call cycle is rejected by emission, so an entry is provisionally false while it is visited.
            memo[block] = False
            function = functions[block]
            touches_global = any(slot[0] == "global" for slot in mentioned_slots(function.body) | set(function.slot_types))
            local = not function.is_main and not function.programs and not touches_global
            memo[block] = local and all(visit(callee) for callee in sorted(called_blocks(function.body)))
        return memo[block]

    return {block for block in functions if visit(block)}


def _share(modules: list[ModuleInput]) -> tuple[dict[str, dict[int, str]], list[_Shared]]:
    """Chooses the shared helpers of one kind: returns each script's block-to-library names and the libraries."""
    keys: dict[str, dict[int, str]] = {}
    shareable: dict[str, set[int]] = {}
    occurrences: dict[str, list[tuple[str, int]]] = collections.defaultdict(list)
    for module in modules:
        keyer = _Keys(module.functions)
        keys[module.path] = {block: keyer.key(function) for block, function in module.functions.items()}
        shareable[module.path] = shareable_blocks(module.functions)
        for block in sorted(shareable[module.path]):
            occurrences[keys[module.path][block]].append((module.path, block))

    shared_keys = {
        key: sorted(occurring)
        for key, occurring in occurrences.items()
        if len({path for path, _ in occurring}) >= 2
    }
    names: dict[str, str] = {}
    for key in sorted(shared_keys):
        name = f"helper_{key[:KEY_LENGTH]}"
        if name in names.values():
            raise ValueError(f"shared helper names collide: {name}")
        names[key] = name

    # A library returns its value when any call of its key uses the result, anywhere in the corpus.
    returns: set[str] = set()
    for module in modules:
        for function in module.functions.values():
            for callee in used_call_blocks(function.body):
                key = keys[module.path][callee]
                if key in shared_keys:
                    returns.add(key)

    module_names = {
        module.path: {
            block: names[keys[module.path][block]]
            for block in shareable[module.path]
            if keys[module.path][block] in shared_keys
        }
        for module in modules
    }
    shared = [
        _Shared(
            key=key,
            name=names[key],
            users=sorted({path for path, _ in shared_keys[key]}),
            returns_value=key in returns,
            path=shared_keys[key][0][0],
            block=shared_keys[key][0][1],
        )
        for key in sorted(shared_keys)
    ]
    return module_names, shared


def emit_corpus(lifted: list[tuple[Result, ModuleInput | None]], catalog: dict[str, Any]) -> Corpus:
    """Emits every lifted script, sharing helper bodies across the scripts of each kind."""
    modules = [module for _, module in lifted if module is not None]
    by_path = {module.path: module for module in modules}
    errors: dict[str, str] = {}
    libraries: list[Library] = []
    names: dict[str, dict[int, str]] = {}
    for kind in sorted({module.kind for module in modules}):
        kind_modules = [module for module in modules if module.kind == kind]
        kind_names, shared = _share(kind_modules)
        names.update(kind_names)
        for item in shared:
            source = by_path[item.path]
            try:
                module = emit_library(
                    item.name,
                    kind,
                    source.functions[item.block],
                    source.functions,
                    kind_names[item.path],
                    item.returns_value,
                    len(item.users),
                    catalog,
                )
            except EmitError as error:
                # The scripts that use a library that cannot be emitted fail with it.
                for path in item.users:
                    errors.setdefault(path, f"shared helper {item.name}: {error}")
                continue
            libraries.append(Library(kind, item.name, module, item.users))

    # Libraries with no surviving user are dropped; a library's users are a superset of those of the libraries it calls.
    survivors = {path for path in by_path if path not in errors}
    libraries = [lib for lib in libraries if any(path in survivors for path in lib.users)]

    emitted: dict[str, Module] = {}
    for module in modules:
        if module.path in errors:
            continue
        try:
            emitted[module.path] = emit(dataclasses.replace(module, libraries=names.get(module.path, {})), catalog)
        except EmitError as error:
            errors[module.path] = str(error)
    return Corpus(emitted, errors, libraries)


def _apply(lifted: list[tuple[Result, ModuleInput | None]], corpus: Corpus) -> list[Result]:
    """Copies the emitted text, errors and diagnostics of the corpus onto the results."""
    results = []
    for result, module in lifted:
        if module is not None:
            emitted = corpus.modules.get(module.path)
            result.text = emitted.text if emitted is not None else None
            result.error = corpus.errors.get(module.path)
            result.diagnostics = [str(diagnostic) for diagnostic in emitted.diagnostics] if emitted else []
        results.append(result)
    return results


def format(texts: dict[Path, str]) -> dict[Path, str]:
    """Writes each text to its path, formats those files with the pinned StyLua, and returns them as formatted."""
    tool = executable("stylua", "stylua")
    if tool is None:
        raise RuntimeError("stylua is unavailable: no pinned release for this platform, or the download failed")
    for path, text in texts.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8", newline="\n")
    files = [str(path) for path in texts]
    for start in range(0, len(files), BATCH):
        completed = subprocess.run(
            [str(tool), *STYLUA_ARGS, *files[start : start + BATCH]],
            capture_output=True,
            text=True,
            encoding="utf-8",
            check=False,
        )
        if completed.returncode != 0:
            raise RuntimeError(f"stylua failed: {completed.stderr.strip()}")
    return {path: path.read_text(encoding="utf-8") for path in texts}


def _support(scratch: Path, out: Path) -> None:
    """Fills a scratch scripts root with the declarations, the libraries under out, and vm.luau when out lacks it."""
    shutil.copytree(OUTPUT / "api", scratch / "api")
    if (out / "lib").is_dir():
        shutil.copytree(out / "lib", scratch / "lib")
    else:
        (scratch / "lib").mkdir()
    if not (scratch / "lib" / "vm.luau").is_file():
        shutil.copyfile(OUTPUT / "lib" / "vm.luau", scratch / "lib" / "vm.luau")
    (scratch / ".luaurc").write_text(LUAURC, encoding="utf-8", newline="\n")


def check(paths: list[Path], root: Path = OUTPUT) -> list[str]:
    """Runs luau-check strictly over modules under root and returns its output lines, empty when clean.

    luau-check reads the declarations and the `lib` alias from its scripts root, so the modules are checked in a
    scratch root that also holds the declarations and libraries from root.
    """
    if not CHECK.is_file():
        raise RuntimeError(f"{CHECK} is not built; build the luau-harness target")
    lines: list[str] = []
    with tempfile.TemporaryDirectory() as scratch:
        scripts_root = Path(scratch)
        _support(scripts_root, root)
        for path in paths:
            target = scripts_root / path.relative_to(root)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(path, target)
        relative = [path.relative_to(root).as_posix() for path in paths]
        for start in range(0, len(relative), BATCH):
            completed = subprocess.run(
                [str(CHECK), str(scripts_root), *relative[start : start + BATCH]],
                capture_output=True,
                text=True,
                encoding="utf-8",
                check=False,
            )
            batch = [line for line in completed.stdout.splitlines() if line.strip()]
            if completed.returncode != 0 and not batch:
                batch = [line for line in completed.stderr.splitlines() if line.strip()] or [
                    f"luau-check exited {completed.returncode}"
                ]
            lines.extend(batch)
    return lines


def corpus(source: Path, kinds: set[str]) -> Iterator[tuple[str, bytes]]:
    """Scripts of the given kinds in the published corpus, as (data-relative path, bytes)."""
    for path, data in stb_corpus.scripts(source):
        if classify(path).value in kinds:
            yield path, data


def _map(function: Any, items: list[Any], jobs: int) -> list[Any]:
    """Applies a function to each item, in a process pool when more than one job is asked for."""
    if jobs <= 1 or len(items) <= 1:
        return [function(item) for item in items]
    with concurrent.futures.ProcessPoolExecutor(max_workers=jobs) as pool:
        return list(pool.map(function, items, chunksize=8))


def _transpile_job(job: tuple[str, bytes]) -> tuple[Result, ModuleInput | None]:
    path, data = job
    return transpile(path, data)


@dataclasses.dataclass
class HarnessRow:
    """The differential harness outcome of one script, and the lines to report.

    passed counts the scenarios compared to their end, and prefix those compared only up to the reference run's step
    budget, where nothing the module does from there on is checked. unsupported counts those compared up to an access
    outside a frame, where the translation diverges from retail.
    coverage is the instruction coverage of the reference runs, and compared that of the comparisons that matched.
    """

    path: str
    passed: int
    failed: int
    lines: list[str]
    prefix: int = 0
    unsupported: int = 0
    coverage: float = 0.0
    compared: float = 0.0


def float_globals(analysis: Analysis) -> frozenset[int]:
    """The globals the script loads as floats."""
    found = {n for n, type_ in analysis.global_types.items() if type_ == "float"}
    for facts in analysis.facts.values():
        found |= {n for space, n in facts.float_slots if space == "global"}
    return frozenset(found)


def float_references(analysis: Analysis) -> dict[int, tuple[bool, ...]]:
    """For each external or script call, by offset, whether each argument names a variable the script loads as a float."""
    globals_ = float_globals(analysis)
    found: dict[int, tuple[bool, ...]] = {}
    for facts in analysis.facts.values():

        def is_float(value: Any, facts: Any = facts) -> bool:
            if value.kind != "addr" or value.slot is None:
                return False
            if value.slot[0] == "global":
                return value.slot[1] in globals_
            return value.mode in FLOAT_MODES or value.slot in facts.float_slots

        for site in facts.ext_sites.values():
            found[site.offset] = tuple(is_float(value) for value in site.args)
        for offset, (_callee, args) in facts.call_args.items():
            found[offset] = tuple(is_float(value) for value in args)
    return found


def _harness_job(job: tuple[Result, Module, dict[str, Any], range, Path]) -> HarnessRow:
    """Runs the differential harness for one script whose module was emitted with its globals exposed and probes."""
    result, module, kind, seeds, out = job
    try:
        with tempfile.TemporaryDirectory() as scratch:
            root = Path(scratch)
            _support(root, out)
            target = root / f"{result.module}.luau"
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(module.text, encoding="utf-8", newline="\n")
            names = {no: info.name for no, info in handlers(classify(result.path).value).items()}
            report = harness.run(
                root,
                result.module,
                result.program,
                kind,
                kind["namespace"],
                seeds,
                names,
                frozenset(module.probes),
                harness.FloatViews(result.float_refs, result.float_globals),
                result.folded,
            )
    except Exception as error:  # noqa: BLE001 - a harness crash is reported against its script
        return HarnessRow(result.path, 0, 1, [f"harness error: {error}"])
    lines = list(report["fail"])
    failed = len(lines)
    if report["returncode"] != 0 and not lines:
        # The host exited without reporting a failed scenario, so the run itself failed.
        failed = 1
        lines.append(f"host exited {report['returncode']}: {report['stderr'].strip()[-300:]}")
    # Unsupported scenarios are listed by the access that cut them, with the events compared before it.
    reasons: dict[str, list[harness.Scenario]] = {}
    for scenario in report["unsupported"]:
        reasons.setdefault(scenario.cut, []).append(scenario)
    for reason, found in sorted(reasons.items()):
        compared = sorted(len(scenario.events) - 1 for scenario in found)
        lines.append(
            f"unsupported: {reason}, in {len(found)} scenarios (first {found[0].name}), after {compared[0]} to "
            f"{compared[-1]} compared events"
        )
    return HarnessRow(
        result.path,
        report["pass"],
        failed,
        lines,
        len(report["prefix"]),
        len(report["unsupported"]),
        report["coverage"],
        report["compared"],
    )


def _library_files(libraries: list[Library]) -> set[str]:
    """Relative paths, under the output, of the library files generated by a run."""
    return {f"lib/{lib.kind}/{lib.name}.luau" for lib in libraries}


def _stale_libraries(out: Path, kinds: set[str], generated: set[str]) -> list[str]:
    """Library files under out for the processed kinds that a run does not generate."""
    stale = []
    for kind in sorted(kinds):
        for path in sorted((out / "lib" / kind).glob("*.luau")):
            relative = path.relative_to(out).as_posix()
            if relative not in generated:
                stale.append(relative)
    return stale


def fallback_scripts() -> dict[str, str]:
    """The scripts the interpreter keeps, with the reason, from tools/luau/fallback.json."""
    return json.loads(FALLBACK.read_text(encoding="utf-8"))["scripts"]


def _write_manifest(
    target: Path,
    previous: Path,
    results: list[Result],
    libraries: list[Library],
    kinds: set[str],
) -> None:
    """Merges the results into the previous manifest: successes are added, scripts the interpreter keeps are listed with
    the reason, other failures are removed.

    The libraries of the processed kinds are replaced; those of other kinds are kept.
    """
    manifest = json.loads(previous.read_text(encoding="utf-8")) if previous.is_file() else {}
    shared = manifest.pop("libraries", {})
    fallback = fallback_scripts()
    for result in results:
        if result.error is None and result.normalized is not None:
            manifest[result.path] = {"module": result.module, "sha256": _sha256(result.normalized)}
        elif result.path in fallback:
            manifest[result.path] = {"interpreter": fallback[result.path]}
        else:
            manifest.pop(result.path, None)
    shared = {name: entry for name, entry in shared.items() if name.split("/")[0] not in kinds}
    for lib in libraries:
        shared[f"{lib.kind}/{lib.name}"] = {"users": sorted(lib.users)}
    manifest["libraries"] = dict(sorted(shared.items()))
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(json.dumps(manifest, indent=1, sort_keys=True) + "\n", encoding="utf-8", newline="\n")


def _write_tree(root: Path, results: list[Result], corpus_: Corpus, previous: Path, kinds: set[str]) -> list[Path]:
    """Writes the formatted modules, libraries, `.luaurc` and the manifest under root; previous holds the existing outputs."""
    texts = {root / f"{result.module}.luau": result.text for result in results if result.text is not None}
    for lib in corpus_.libraries:
        texts[root / "lib" / lib.kind / f"{lib.name}.luau"] = lib.module.text
    formatted = format(texts)
    luaurc = root / ".luaurc"
    # Outside the output directory itself the file is always written, so a check compares its exact contents.
    if root != previous or not luaurc.is_file():
        luaurc.write_text(LUAURC, encoding="utf-8", newline="\n")
    _write_manifest(root / "manifest.json", previous / "manifest.json", results, corpus_.libraries, kinds)
    return list(formatted)


def _print_failures(results: list[Result]) -> None:
    for result in results:
        if result.error is not None:
            first, *rest = result.error.splitlines() or [""]
            print(f"FAILED {result.path}: {first}")
            for line in rest:
                print(f"    {line}")


def _out_of_date(generated_root: Path, out: Path) -> list[str]:
    """Files generated under generated_root that are missing under out or differ from it, as relative paths."""
    stale = []
    for path in sorted(path for path in generated_root.rglob("*") if path.is_file()):
        relative = path.relative_to(generated_root)
        target = out / relative
        if not target.is_file() or target.read_bytes() != path.read_bytes():
            stale.append(relative.as_posix())
    return stale


def _harness_rows(
    lifted: list[tuple[Result, ModuleInput | None]],
    good: list[Result],
    catalog: dict[str, Any],
    seeds: int,
    jobs: int,
    out: Path,
) -> list[HarnessRow]:
    """Runs the differential harness for every transpiled script, with the libraries generated under out."""
    rows: list[HarnessRow] = []
    exposed = emit_corpus(
        [
            (result, dataclasses.replace(module, expose_globals=True, probe_refs=True) if module else None)
            for result, module in lifted
        ],
        catalog,
    )
    work = []
    for result in good:
        module = exposed.modules.get(result.path)
        if module is None:
            rows.append(HarnessRow(result.path, 0, 1, [exposed.errors.get(result.path, "emit failed")]))
            continue
        kind = catalog["kinds"][classify(result.path).value]
        work.append((result, module, kind, range(seeds), out))
    return rows + _map(_harness_job, work, jobs)


def main(argv: list[str] | None = None) -> int:
    """Command-line entry point; see the module documentation for the exit status."""
    sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--data", type=Path, help="data root, data.zip, or a directory of extracted scripts")
    parser.add_argument(
        "--kind",
        action="append",
        choices=[kind.value for kind in Kind],
        help="kind to transpile, repeatable (default: action)",
    )
    parser.add_argument("--out", type=Path, default=OUTPUT, help="output directory (default: port/src/luau)")
    parser.add_argument(
        "--only",
        action="append",
        default=[],
        metavar="PATH",
        help="transpile only this data-relative path, repeatable",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="write nothing; exit 1 if the output differs from what would be written",
    )
    parser.add_argument(
        "--harness",
        action="store_true",
        help="run the differential harness for every transpiled script",
    )
    parser.add_argument("--seeds", type=int, default=4, help="harness seeds per script (default: 4)")
    parser.add_argument(
        "--jobs",
        type=int,
        default=os.cpu_count() or 1,
        help="worker processes (default: CPU count)",
    )
    args = parser.parse_args(argv)

    if args.check:
        for tool in (CHECK, harness.HOST):
            if not tool.is_file():
                print(f"skipped: {tool} is not built; build the luau-harness target", file=sys.stderr)
                return SKIP

    source = resolve_data(args.data)
    if source is None:
        print("no game data: set DC2_DATA or pass --data", file=sys.stderr)
        return SKIP

    kinds = set(args.kind or ["action"])
    catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
    only = {timing.key(path) for path in args.only}
    selected = [(path, data) for path, data in corpus(source, kinds) if not only or timing.key(path) in only]
    if not selected:
        print("no scripts selected", file=sys.stderr)
        return 1
    collisions = sorted(
        name for name, count in collections.Counter(module_name(p) for p, _ in selected).items() if count > 1
    )
    if collisions:
        print(f"module names collide: {', '.join(collisions)}", file=sys.stderr)
        return 1

    lifted = _map(_transpile_job, selected, args.jobs)
    corpus_ = emit_corpus(lifted, catalog)
    results = _apply(lifted, corpus_)
    good = [result for result in results if result.error is None]
    fallback = fallback_scripts()
    kept = [result for result in results if result.error is not None and result.path in fallback]
    unneeded = sorted(result.path for result in good if result.path in fallback)

    stale: list[str] = []
    harness_rows: list[HarnessRow] = []
    if args.check:
        # The outputs are generated, checked and tested in a scratch directory and compared with the output.
        with tempfile.TemporaryDirectory() as scratch:
            root = Path(scratch)
            written = _write_tree(root, results, corpus_, previous=args.out, kinds=kinds)
            stale = _out_of_date(root, args.out) + _stale_libraries(args.out, kinds, _library_files(corpus_.libraries))
            stale += [f"{result.module}.luau" for result in kept if (args.out / f"{result.module}.luau").is_file()]
            check_lines = check(written, root=root) if written else []
            if args.harness:
                harness_rows = _harness_rows(lifted, good, catalog, args.seeds, args.jobs, root)
    else:
        args.out.mkdir(parents=True, exist_ok=True)
        written = _write_tree(args.out, results, corpus_, previous=args.out, kinds=kinds)
        for name in _stale_libraries(args.out, kinds, _library_files(corpus_.libraries)):
            (args.out / name).unlink()
        # A script the interpreter keeps has no module, so the runtime falls back to the interpreter.
        for result in kept:
            (args.out / f"{result.module}.luau").unlink(missing_ok=True)
        check_lines = check(written, root=args.out) if written else []
        if args.harness:
            harness_rows = _harness_rows(lifted, good, catalog, args.seeds, args.jobs, args.out)

    for name in stale:
        print(f"out of date: {name}")
    failed = [result for result in results if result.error is not None and result.path not in fallback]
    print(f"transpiled {len(good)} of {len(results)} scripts; {len(kept)} kept on the interpreter; {len(failed)} failed")
    _print_failures(failed)
    for result in kept:
        print(f"interpreter {result.path}: {result.error.splitlines()[0] if result.error else ''}")
    for path in unneeded:
        print(f"stale fallback entry: {path} transpiles; remove it from {FALLBACK.name}")
    print(f"libraries: {len(corpus_.libraries)} shared helpers")
    for lib in corpus_.libraries:
        print(f"    {lib.kind}/{lib.name}: {len(lib.users)} scripts")
    if check_lines:
        print(f"check errors: {len(check_lines)}")
        for line in check_lines:
            print(f"    {line}")
    else:
        print("check errors: 0")

    harness_failed = 0
    if args.harness:
        for row in harness_rows:
            harness_failed += row.failed
            print(
                f"{row.path}: {row.passed} passed, {row.prefix} prefix, {row.unsupported} unsupported, "
                f"{row.failed} failed; coverage {row.coverage * 100:.1f}% reference, {row.compared * 100:.1f}% compared"
            )
            for line in row.lines:
                print(f"    {line}")
        count = len(harness_rows) or 1
        print(
            f"harness: {sum(r.passed for r in harness_rows)} passed, "
            f"{sum(r.prefix for r in harness_rows)} prefix only (step budget, unchecked after the cut), "
            f"{sum(r.unsupported for r in harness_rows)} unsupported, {harness_failed} failed "
            f"over {len(harness_rows)} scripts; mean coverage "
            f"{sum(r.coverage for r in harness_rows) / count * 100:.1f}% reference, "
            f"{sum(r.compared for r in harness_rows) / count * 100:.1f}% compared"
        )

    diagnostics = collections.Counter(d for result in results for d in result.diagnostics)
    diagnostics.update(d for lib in corpus_.libraries for d in lib.module.diagnostics)
    if diagnostics:
        print("diagnostics:")
        for message, count in sorted(diagnostics.items(), key=lambda item: (-item[1], item[0])):
            print(f"    {count:6d}  {message}")

    return 1 if stale or failed or unneeded or check_lines or harness_failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
