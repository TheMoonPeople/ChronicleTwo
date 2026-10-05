#!/usr/bin/env python3
"""Write objdiff's configuration: one unit per game translation unit.

    objdiff_config.py [--build-dir build/pal] [-o objdiff.json]

A unit's target is its retail reference assembled whole and its base is its
source compiled without tools/mwccgap; ps2/cmake/Objdiff.cmake builds both.
"""

import argparse
import json
import os
import re
import sys
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import layout  # noqa: E402


def suffixed_names(lay, unit, rows):
    ranges = [(lo, hi) for _s, lo, hi in lay.sections(unit)]
    return {name: re.sub(r"__\d+$", "", name) for address, name, _size, _func in rows
            if re.fullmatch(r".+__\d+", name) and any(lo <= address < hi for lo, hi in ranges)}


def config(build_dir):
    lay = layout.Layout()
    rows = layout.read_symbols(layout.SYMBOLS)
    units = []
    for unit in lay.units("cpp"):
        units.append({
            "name": unit,
            "target_path": f"{build_dir}/objdiff/target/{unit}.s.o",
            "base_path": f"{build_dir}/objdiff/base/{unit}.cpp.o",
            "symbol_mappings": {f"__sinit_{unit}_cpp": f"__sinit_{unit}.cpp",
                                **suffixed_names(lay, unit, rows)},
            "metadata": {
                "source_path": lay.source(unit),
            },
        })
    return {
        "min_version": "2.0.0-beta.5",
        "custom_make": "sh",
        "custom_args": ["-c", "exec scripts/build/build_objdiff.sh"],
        "build_target": False,
        "build_base": True,
        "watch_patterns": [
            "ps2/src/**/*.{c,cpp,h,hpp,s,inc,lcf}",
            "ps2/include/**/*.{h,hpp,s,inc,lcf}",
            "ps2/asm/**/*.s",
            "ps2/config/*/*.{yaml,txt}",
        ],
        "options": {"demangler": "codewarrior", "functionRelocDiffs": "none"},
        "name": "chronicletwo",
        "units": units,
    }


def main():
    os.chdir(os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir, os.pardir)))
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--build-dir", default=os.environ.get("BUILD_DIR", str(layout.BUILD)))
    ap.add_argument("-o", "--output", default="objdiff.json")
    args = ap.parse_args()
    Path(args.output).write_text(json.dumps(config(args.build_dir), indent=2) + "\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
