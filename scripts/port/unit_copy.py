#!/usr/bin/env python3
"""Write one ps2/src unit's native build copy: strip overridden definitions, append
preserved retail bridges, then apply unit fixups and long64 in a single process.

RETAIL_BRIDGES preserves selected overridden retail routines under new definition
names in the generated build copy. Their bodies come from unstripped ps2/src;
existing calls keep the public name and reach the native PORT_OVERRIDE seam.
Use a bridge when a native seam must add behavior around the preserved routine
rather than replace its implementation. Register its unit, signature, original
name and bridge name in RETAIL_BRIDGES, declare the bridge's asm link name in the
unit's stub header and native caller, and delegate from the native override.
The appended body receives the same unit fixups and long64 rewrites, with a #line
marker at its retail definition for diagnostics and debugging. ps2/ is unchanged.

    unit_copy.py --port-override <port_override.py> --overrides <file> [--stubs <hpp>]
                 [--define=NAME ...] [--long-is-64] SRC OUT

The output is written only when its bytes change, so an unchanged copy keeps its timestamp.
"""

import argparse
import importlib.util
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import header_fixups  # noqa: E402
import long64  # noqa: E402


def load_port_override(path: Path):
    spec = importlib.util.spec_from_file_location("port_override", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


# Preserve these retail routines under native link-name bridges. Only their names
# change; all calls in the original unit still reach the native public seam.
RETAIL_BRIDGES = {
    "editctrl.cpp": [("ResetViewMode(CScene*)", "ResetViewMode", "PortRetailResetViewMode")],
    "dng_main.cpp": [("ResetEyeView(CActionChara*)", "ResetEyeView", "PortRetailResetEyeView")],
}


def retail_bridges(port_override, source: Path, long_is_64: bool) -> str:
    entries = RETAIL_BRIDGES.get(source.name, [])
    if not entries:
        return ""
    original = port_override.read(source)
    bodies = []
    for signature, name, bridge in entries:
        matches = list(port_override.definitions(original, {signature}, long_is_64=long_is_64))
        if len(matches) != 1:
            raise port_override.Error(f"{source}: expected one retail bridge body for {signature}")
        start, definition = matches[0]
        body = original[start:start + definition.length]
        line = original.count("\n", 0, start) + 1
        marker = f'#line {line} "{source.resolve().as_posix()}"\n'
        bodies.append(marker + body.replace(name + "(", bridge + "(", 1))
    return "\n".join(bodies)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--port-override", required=True, type=Path)
    parser.add_argument("--overrides", required=True, type=Path)
    parser.add_argument("--stubs", type=Path)
    parser.add_argument("--define", action="append", default=[])
    parser.add_argument("--long-is-64", action="store_true")
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    port_override = load_port_override(args.port_override)
    overrides = port_override.override_entries(port_override.read(args.overrides))
    try:
        text = port_override.strip_unit(args.source, overrides, port_override.renames(args.stubs), args.define,
                                        args.long_is_64)
    except port_override.Error as error:
        sys.exit(str(error))

    text += "\n" + retail_bridges(port_override, args.source, args.long_is_64)
    fixed = header_fixups.fixup_unit_text(args.output.name, text.encode("utf-8", errors="surrogateescape")
                                          .decode("latin-1"))
    final = long64.rewrite(fixed).encode("latin-1")
    if args.output.is_file() and args.output.read_bytes() == final:
        return
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(final)


if __name__ == "__main__":
    main()
