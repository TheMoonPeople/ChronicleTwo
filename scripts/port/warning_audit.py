"""Audit port and explicitly owned dependency units with all Clang diagnostics enabled; fail on diagnostics."""

from __future__ import annotations

import argparse
import concurrent.futures
import csv
import json
import re
import shlex
import subprocess
from collections import Counter
from pathlib import Path


DIAGNOSTIC = re.compile(r"^(.*?):(\d+):(\d+): (warning|error|fatal error): (.*?)(?: \[(-W[^]]+)\])?$")
DRIVER_DIAGNOSTIC = re.compile(r"^(?:.*?: )?(warning|error|fatal error): (.*?)(?: \[(-W[^]]+)\])?$")


def source_path(entry: dict) -> Path:
    """Resolve compilation database paths against their recorded working directory."""
    path = Path(entry["file"])
    return (path if path.is_absolute() else Path(entry["directory"]) / path).resolve()


def commands(build: Path, root: Path, owned_prefixes: tuple[Path, ...] = ()) -> list[dict]:
    entries = json.loads((build / "compile_commands.json").read_text())
    port_root = (root / "port").resolve()
    prefixes = []
    for prefix in owned_prefixes:
        path = (root / prefix).resolve()
        if not path.is_relative_to(root.resolve()):
            raise ValueError(f"owned warning prefix lies outside the project: {path}")
        if not path.exists():
            raise ValueError(f"owned warning prefix does not exist: {path}")
        prefixes.append(path)
    selected = [entry for entry in entries if source_path(entry).is_relative_to(port_root)
                or any(source_path(entry).is_relative_to(prefix) for prefix in prefixes)]
    files = [str(source_path(entry)) for entry in selected]
    if not selected or len(files) != len(set(files)):
        raise RuntimeError("expected one compile command per owned translation unit")
    return sorted(selected, key=lambda entry: entry["file"])


def diagnostics(entry: dict, output: str, root: Path) -> list[tuple]:
    """Keep source and driver diagnostics, including paths relative to the compiler cwd."""
    tu = str(source_path(entry).relative_to(root))
    rows = []
    for line in output.splitlines():
        match = DIAGNOSTIC.match(line)
        if match:
            file, number, column, level, message, option = match.groups()
            path = Path(file)
            if not path.is_absolute():
                path = Path(entry["directory"]) / path
            path = path.resolve()
            file = str(path.relative_to(root)) if path.is_relative_to(root) else str(path)
            rows.append((tu, file, number, column, level, option or "", message))
        elif match := DRIVER_DIAGNOSTIC.match(line):
            level, message, option = match.groups()
            rows.append((tu, "", "", "", level, option or "", message))
    return rows


def diagnostic_command(entry: dict) -> list[str]:
    args = list(entry["arguments"]) if "arguments" in entry else shlex.split(entry["command"])
    result = []
    skip_next = False
    for arg in args:
        if skip_next:
            skip_next = False
        elif arg == "-o":
            skip_next = True
        elif arg != "-c" and arg != "-w" and not arg.startswith("-Wno-"):
            result.append(arg)
    return result + ["-fsyntax-only", "-Weverything", "-fno-color-diagnostics", "-fdiagnostics-show-option"]



def summary(rows: list[tuple], entries: list[dict], failures: list[tuple]) -> dict:
    unique_port_rows = {row[1:] for row in rows if Path(row[1]).parts[:1] == ("port",)}
    return {
        "units": len(entries),
        "translation_units": sorted(str(source_path(entry)) for entry in entries if "file" in entry),
        "diagnostics": len(rows),
        "failed_units": failures,
        "by_option": Counter(row[5] or row[4] for row in rows).most_common(),
        "unique_port_diagnostics": len(unique_port_rows),
        "unique_port_by_option": Counter(row[4] or row[3] for row in unique_port_rows).most_common(),
    }


def run_one(entry: dict) -> tuple[dict, int, str]:
    result = subprocess.run(diagnostic_command(entry), cwd=entry["directory"], capture_output=True, text=True)
    return entry, result.returncode, result.stderr


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build", type=Path, required=True)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--jobs", type=int, default=8)
    parser.add_argument("--owned-prefix", type=Path, action="append", default=[],
                        help="Additional owned source file or directory inside the project")
    options = parser.parse_args()
    if options.jobs < 1:
        parser.error("--jobs must be positive")
    root = options.root.resolve()
    entries = commands(options.build.resolve(), root, tuple(options.owned_prefix))
    rows = []
    failures = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=options.jobs) as executor:
        for entry, status, output in executor.map(run_one, entries):
            tu = str(source_path(entry).relative_to(root))
            if status:
                failures.append((tu, status))
            rows.extend(diagnostics(entry, output, root))
    rows.sort()
    options.out.parent.mkdir(parents=True, exist_ok=True)
    temporary = options.out.with_suffix(options.out.suffix + ".tmp")
    with temporary.open("w", newline="") as output:
        writer = csv.writer(output, delimiter="\t")
        writer.writerow(("translation_unit", "file", "line", "column", "level", "option", "message"))
        writer.writerows(rows)
    temporary.replace(options.out)
    print(json.dumps(summary(rows, entries, failures), indent=2))
    return 1 if rows or failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
