#!/usr/bin/env python3
"""Report C++ match and draft coverage for every game translation unit.

The build's progress report supplies exact function matches. Source guards
distinguish assembly functions with C++ drafts from assembly-only functions.
Run after ``./build.sh`` so progress/report.json reflects the current source.
"""

import argparse
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
REPORT = ROOT / "progress/report.json"
SOURCES = ROOT / "ps2/src"
MATCHINGS = ROOT / "ps2/asm/pal/matchings"
ASM = re.compile(r"\bINCLUDE_ASM\([^,]+,\s*([A-Za-z_][A-Za-z_0-9]*)\s*\)")


def guarded_symbols(source: str) -> set[str]:
    guards: list[dict[str, bool]] = []
    symbols: set[str] = set()
    for line in source.splitlines():
        directive = line.strip()
        if directive == "#ifdef NONMATCHING":
            guards.append({"nonmatching": True, "fallback": False})
        elif directive.startswith(("#if ", "#ifdef ", "#ifndef ")):
            guards.append({"nonmatching": False, "fallback": False})
        elif directive == "#else" and guards:
            guards[-1]["fallback"] = not guards[-1]["fallback"]
        elif directive == "#endif" and guards:
            guards.pop()
        match = ASM.search(line)
        if match and any(guard["nonmatching"] and guard["fallback"] for guard in guards):
            symbols.add(match.group(1))
    return symbols


def rows(report: dict) -> list[tuple[str, str, str]]:
    result: list[tuple[str, str, str]] = []
    for unit in report["units"]:
        name = unit["name"]
        source = SOURCES / f"{name}.cpp"
        source_text = source.read_text() if source.exists() else ""
        guarded = guarded_symbols(source_text)
        for function in unit["functions"]:
            symbol = function["name"]
            # Progress also lists internal branch targets emitted as local labels.
            # They are part of their containing function, not separate work items.
            if symbol.startswith(".L"):
                continue
            match = function.get("fuzzy_match_percent")
            # A switch jump table can split a matching function into local
            # label rows, leaving the function's report row without a score.
            if match == 100.0 or (MATCHINGS / name / f"{symbol}.s").is_file():
                status = "matched"
            elif symbol.startswith("__sinit_") and re.search(
                rf'extern\s+"C"\s+void\s+{re.escape(symbol)}\s*\(', source_text
            ):
                status = "matched"
            elif match is not None:
                status = "fuzzy"
            elif symbol.startswith("__sinit_") and re.search(
                rf'#ifndef\s+NONMATCHING\s+INCLUDE_ASM\([^\n]*\b{re.escape(symbol)}\b',
                source_text,
            ):
                status = "guarded_draft"
            elif symbol in guarded:
                status = "guarded_draft"
            else:
                status = "asm_only"
            result.append((name, symbol, status))
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--functions", action="store_true", help="list every function")
    arguments = parser.parse_args()
    if not REPORT.is_file():
        parser.error("progress/report.json is missing; run ./build.sh first")
    functions = rows(json.loads(REPORT.read_text()))
    if arguments.functions:
        print("unit\tsymbol\tstatus")
        for row in functions:
            print("\t".join(row))
    else:
        totals = Counter(status for _, _, status in functions)
        print("game functions:", len(functions))
        for status in ("matched", "guarded_draft", "asm_only", "fuzzy"):
            print(f"{status}: {totals[status]}")
        print("\nunit\tmatched\tguarded_draft\tasm_only\tfuzzy")
        for unit in sorted({name for name, _, _ in functions}):
            counts = Counter(status for name, _, status in functions if name == unit)
            print("\t".join([unit, *(str(counts[status]) for status in
                                   ("matched", "guarded_draft", "asm_only", "fuzzy"))]))


if __name__ == "__main__":
    main()
