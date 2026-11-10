"""Surveys the published script corpus: writes the external-command catalog and the corpus report.

The data source is --data (a data root holding data.zip, a data.zip, or a directory of scripts such as
`dc2data export-scripts` writes), else
DC2_DATA, else port/run, else the per-user data directory. With --check, nothing is written: the exit status is 1
when the checked-in catalog or report differs from what the corpus produces. The exit status is 77 when no game
data is available, so CTest can skip the check. With --dc2data, a data.zip is read by exporting its scripts to a
temporary directory through `dc2data export-scripts`.
"""

from __future__ import annotations

import argparse
import contextlib
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
sys.path.insert(0, str(HERE))

from stb import catalog, report  # noqa: E402
from stb.scan import scan  # noqa: E402

SKIP = 77


def resolve_data(argument: Path | None) -> Path | None:
    """Script source following the port's data-root order."""
    candidates = [argument] if argument else []
    if os.environ.get("DC2_DATA"):
        candidates.append(Path(os.environ["DC2_DATA"]))
    candidates.append(REPO / "port" / "run")
    if os.environ.get("LOCALAPPDATA"):
        candidates.append(Path(os.environ["LOCALAPPDATA"]) / "chronicletwo" / "data")
    candidates.append(Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local" / "share")) / "chronicletwo" / "data")
    for candidate in candidates:
        if candidate.is_file():
            return candidate
        if (candidate / "data.zip").is_file():
            return candidate / "data.zip"
        if candidate.is_dir() and argument is not None and candidate == argument:
            return candidate
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--data", type=Path)
    parser.add_argument("--catalog", type=Path, default=HERE / "commands.json")
    parser.add_argument("--curation", type=Path, default=HERE / "curation.json")
    parser.add_argument("--report", type=Path, default=HERE / "REPORT.md")
    parser.add_argument("--jobs", type=int)
    parser.add_argument(
        "--dc2data",
        type=Path,
        help="dc2data executable; a data.zip source is read through its export-scripts command",
    )
    parser.add_argument("--check", action="store_true", help="compare with the checked-in outputs instead of writing them")
    args = parser.parse_args()

    source = resolve_data(args.data)
    if source is None:
        print("no game data: set DC2_DATA or pass --data", file=sys.stderr)
        return SKIP
    with contextlib.ExitStack() as stack:
        scan_source = source
        if args.dc2data and source.is_file():
            exported = stack.enter_context(tempfile.TemporaryDirectory())
            subprocess.run(
                [str(args.dc2data), "export-scripts", str(source), exported],
                check=True,
                stdout=subprocess.DEVNULL,
            )
            scan_source = Path(exported)
        facts = scan(scan_source, args.jobs)
    if not facts:
        print(f"no scripts found in {source}", file=sys.stderr)
        return SKIP
    curation = json.loads(args.curation.read_text(encoding="utf-8")) if args.curation.is_file() else {}
    curation.pop("$comment", None)
    document, findings = catalog.build(REPO, facts, curation)
    catalog_text = json.dumps(document, indent=1, ensure_ascii=False) + "\n"
    # A data.zip and a directory exported from it by `dc2data export-scripts` hold the same corpus.
    report_text = report.render(facts, document, findings, "the published scripts")

    problems = catalog.names_are_identifiers(document)
    problems += [f"{f.path}: {f.error}" for f in facts if f.error]
    problems += [f"{f.path}: {e}" for f in facts for e in f.stack_errors]

    if args.check:
        for path, text in ((args.catalog, catalog_text), (args.report, report_text)):
            if not path.is_file() or path.read_text(encoding="utf-8") != text:
                problems.append(f"{path.relative_to(REPO).as_posix()} is out of date; run tools/luau/survey.py")
    else:
        args.catalog.write_text(catalog_text, encoding="utf-8", newline="\n")
        args.report.write_text(report_text, encoding="utf-8", newline="\n")
    for problem in problems:
        print(problem, file=sys.stderr)
    print(json.dumps({"scripts": len(facts), "commands": sum(len(k["commands"]) for k in document["kinds"].values()), "problems": len(problems)}))
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main())
