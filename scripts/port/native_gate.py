#!/usr/bin/env python3
"""Fail when PS2 packet-format or VU1 memory-layout helpers reach the port's runtime code.

The VU1 programs are replaced natively (docs/vu1). Their packed CPU halves (12.4 XYZF2 words, ADC bits,
GIF tags, VU1 memory offsets) survive only as test oracles under port/src/tests. This checks the runtime
sources and, with --binary, the linked executable.
"""

import argparse
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = ROOT / "port" / "src"
TESTS = SRC / "tests"

# Packing and VU1-layout helpers that only the oracles may define or call.
HELPERS = [
    "PackProg0Xyzf", "PackProg0Header", "GsXyzf", "Prog0ClipPacketTag", "Prog0InputOffsets",
    "Prog0HeaderVariant", "Prog0BatchLimit", "Prog0StripParity", "kRejectMask", "Sprite3dTag",
    "Sprite3dExpand", "WaterState", "WaterTransform", "WaterStripTransform", "WaterKicks", "SdwExtrude",
    "SdwPrepare", "SdwKickOrder", "kSdwAlpha",
]
HELPER_RE = re.compile(r"\b(" + "|".join(HELPERS) + r")\b")

# port/src/vu1 is float-domain only: no FTOI4 packing, no ADC or 0x8000 kick bits, no VU memory offsets.
VU1_RE = re.compile(r"\bFtoi4\b|0x8000u|\badc\b|\bvu1_offset\b|Xyzf")

# Symbols of a GIF PACKED register-list decoder in mgCDrawPrim.
DECODER_RE = re.compile(r"mgCDrawPrim::(Kick|NextReg|DecodePacked)\b|mgCDrawPrim::regs\b")


def runtime_sources():
    for path in sorted(SRC.rglob("*")):
        if path.suffix in (".cpp", ".hpp", ".h") and TESTS not in path.parents:
            yield path


def scan_sources():
    failures = []
    for path in runtime_sources():
        text = path.read_text(encoding="utf-8", errors="replace")
        in_vu1 = (SRC / "vu1") in path.parents
        for number, line in enumerate(text.splitlines(), 1):
            if HELPER_RE.search(line) or (in_vu1 and VU1_RE.search(line)):
                failures.append(f"{path.relative_to(ROOT)}:{number}: {line.strip()}")
    return failures


def scan_binary(binary, nm):
    out = subprocess.run([nm, "-C", str(binary)], check=True, capture_output=True, text=True).stdout
    failures = []
    for line in out.splitlines():
        name = line.split(" ", 2)[-1]
        if HELPER_RE.search(name) or DECODER_RE.search(name):
            failures.append(f"{binary.name}: {line.strip()}")
    return failures


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--binary", type=pathlib.Path, help="also check the symbols linked into this executable")
    parser.add_argument("--nm", default="nm")
    args = parser.parse_args()

    failures = scan_sources()
    if args.binary:
        failures += scan_binary(args.binary, args.nm)
    for failure in failures:
        print(failure)
    if failures:
        print(f"native_gate.py: {len(failures)} packing or VU1-layout uses outside port/src/tests", file=sys.stderr)
        return 1
    print("native_gate.py: runtime sources" + (" and binary" if args.binary else "") + " are clean")
    return 0


if __name__ == "__main__":
    sys.exit(main())
