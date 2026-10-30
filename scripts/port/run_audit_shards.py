"""Run complete owned-source audits with verified per-shard parser coverage."""

from __future__ import annotations

import argparse
import collections
import concurrent.futures
import json
import shlex
import subprocess
import sys
import tempfile
from pathlib import Path
from types import SimpleNamespace

try:
    from .ownership_audit import compile_arguments, owned_file, owned_roots
except ImportError:
    from ownership_audit import compile_arguments, owned_file, owned_roots


AUDIT_SCRIPTS = {
    "ownership": "ownership_audit.py",
    "cstring": "cstring_audit.py",
    "unsafe": "unsafe_api_audit.py",
}


def source_commands(build: Path, root: Path, owned_prefixes: tuple[Path, ...] = ()) -> list[dict]:
    """Select actual production command variants, including explicitly owned dependencies."""
    entries = json.loads((build / "compile_commands.json").read_text())
    source_root = (root / "port/src").resolve()
    extras = owned_roots(root, owned_prefixes)[2:]
    commands = {}
    for entry in entries:
        directory = Path(entry["directory"])
        if not directory.is_absolute():
            directory = build / directory
        directory = directory.resolve()
        source = (directory / entry["file"]).resolve()
        if source.is_relative_to(source_root / "tests") or not (
                source.is_relative_to(source_root) or any(source.is_relative_to(prefix) for prefix in extras)):
            continue
        selected = dict(entry, directory=str(directory), file=str(source))
        arguments = selected.get("arguments")
        if arguments is None:
            arguments = shlex.split(selected["command"])
        command = SimpleNamespace(arguments=arguments, directory=str(directory))
        identity = str(source), tuple(compile_arguments(command, source))
        commands[identity] = selected
    if not commands:
        raise RuntimeError("compile database has no owned production sources")
    return [commands[key] for key in sorted(commands)]


def run_one(script: Path, build: Path, root: Path, owned_prefixes: tuple[Path, ...] = ()) -> tuple:
    """Require machine-readable coverage from each successful parser process."""
    coverage_path = build / "coverage.json"
    command = [sys.executable, str(script), "--build", str(build), "--root", str(root),
               "--coverage", str(coverage_path)]
    for prefix in owned_prefixes:
        command += ["--owned-prefix", str(prefix)]
    result = subprocess.run(command, capture_output=True, text=True)
    coverage = None
    if result.returncode == 0:
        try:
            coverage = json.loads(coverage_path.read_text())
        except (OSError, ValueError) as error:
            return result.stdout, result.stderr + f"\nmissing or invalid audit coverage: {error}", 1, None
    return result.stdout, result.stderr, result.returncode, coverage


def merge_results(audit: str, results: list[tuple], commands: list[dict], root: Path,
                  owned_prefixes: tuple[Path, ...] = ()) -> tuple[str | None, list[str], dict]:
    """Deduplicate included sites only after every selected command is accounted for."""
    findings = {}
    header = None
    parsed = []
    for output, _, status, coverage in results:
        if status or coverage is None:
            raise RuntimeError("cannot merge failed or unverified audit shards")
        units = coverage.get("translation_units")
        if not isinstance(units, list) or coverage.get("parsed_commands") != len(units):
            raise RuntimeError("audit shard reported inconsistent parser coverage")
        parsed.extend(units)
        lines = output.splitlines()
        summary = "legacy call sites: " if audit == "unsafe" else "inventory rows: "
        if not lines or not lines[-1].startswith(summary):
            raise RuntimeError("audit shard produced no complete summary")
        body = lines[:-1]
        if audit != "unsafe":
            if not body:
                raise RuntimeError("audit shard produced no TSV header")
            current_header, body = body[0], body[1:]
            if len(current_header.split("	")) != 8:
                raise RuntimeError("audit inventory header is missing its source column")
            if header is None:
                header = current_header
            elif current_header != header:
                raise RuntimeError("audit shards produced different TSV headers")
        if int(lines[-1][len(summary):]) != len(body):
            raise RuntimeError("audit shard summary does not match its findings")
        for row in body:
            cells = row.split("\t")
            if audit == "unsafe":
                if len(cells) != 3:
                    raise RuntimeError("invalid unsafe audit row")
                path, line, column = cells[0].rsplit(":", 2)
                kind, concrete_type = cells[1:]
            else:
                if len(cells) != 8:
                    raise RuntimeError("audit inventory is missing its source column")
                path, line, column, kind, concrete_type = cells[:5]
            canonical = owned_file(str(root / path), root, owned_prefixes)
            if canonical is None:
                raise RuntimeError(f"audit shard reported an unowned location: {path}")
            key = canonical, int(line), int(column), concrete_type, kind
            if audit == "unsafe":
                normalized = f"{canonical}:{line}:{column}\t{kind}\t{concrete_type}"
            else:
                cells[0] = canonical
                normalized = "\t".join(cells)
            findings[key] = min(findings.get(key, normalized), normalized)
    expected = [Path(command["file"]).relative_to(root).as_posix() for command in commands]
    if collections.Counter(parsed) != collections.Counter(expected):
        raise RuntimeError("audit parser coverage differs from the selected production commands")
    rows = [findings[key] for key in sorted(findings)]
    coverage = {
        "audit": audit,
        "owned_prefixes": [str(prefix) for prefix in owned_prefixes],
        "parsed_commands": len(parsed),
        "unique_sources": len(set(parsed)),
        "translation_units": sorted(parsed),
        "findings": len(rows),
    }
    return header, rows, coverage


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--audit", choices=AUDIT_SCRIPTS, required=True)
    parser.add_argument("--build", type=Path, required=True)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--coverage", type=Path, help="Default: append .coverage.json to --out")
    parser.add_argument("--owned-prefix", type=Path, action="append", default=[])
    parser.add_argument("--jobs", type=int, default=8)
    options = parser.parse_args()
    if options.jobs < 1:
        parser.error("--jobs must be positive")

    root = options.root.resolve()
    prefixes = tuple(options.owned_prefix)
    coverage_path = options.coverage or options.out.with_name(options.out.name + ".coverage.json")
    coverage_path.unlink(missing_ok=True)
    commands = source_commands(options.build.resolve(), root, prefixes)
    script = Path(__file__).resolve().with_name(AUDIT_SCRIPTS[options.audit])
    with tempfile.TemporaryDirectory(prefix="port-audit-shards-") as scratch:
        directories = []
        count = min(options.jobs, len(commands))
        for index in range(count):
            shard = Path(scratch) / str(index)
            shard.mkdir()
            (shard / "compile_commands.json").write_text(json.dumps(commands[index::count]))
            directories.append(shard)
        with concurrent.futures.ThreadPoolExecutor(max_workers=count) as executor:
            results = list(executor.map(lambda directory: run_one(script, directory, root, prefixes), directories))

    errors = [(index, error, status) for index, (_, error, status, _) in enumerate(results) if status]
    if errors:
        for index, error, status in errors:
            print(f"audit shard {index} failed with exit {status}: {error}", file=sys.stderr)
        return 1
    for index, (_, warnings, _, _) in enumerate(results):
        if warnings:
            print(f"audit shard {index}: {warnings}", file=sys.stderr)
    header, rows, coverage = merge_results(options.audit, results, commands, root, prefixes)
    options.out.parent.mkdir(parents=True, exist_ok=True)
    coverage_path.parent.mkdir(parents=True, exist_ok=True)
    temporary = options.out.with_suffix(options.out.suffix + ".tmp")
    temporary.write_text((header + "\n" if header else "") + "\n".join(rows) + "\n")
    proof = coverage_path.with_suffix(coverage_path.suffix + ".tmp")
    proof.write_text(json.dumps(coverage, indent=2) + "\n")
    temporary.replace(options.out)
    proof.replace(coverage_path)
    print(f"{options.audit}: {coverage['parsed_commands']} verified production commands, {len(rows)} unique rows")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
