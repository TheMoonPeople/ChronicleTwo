#!/usr/bin/env python3
"""Write objdiff's configuration: one unit per game translation unit.

    objdiff_config.py [--build-dir build/pal] [-o objdiff.json]

A unit's target is its retail reference assembled whole and its base is its
source compiled through Satan's Fiddle without tools/mwccgap;
ps2/cmake/Objdiff.cmake builds both.
"""

import argparse
import json
import os
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import layout  # noqa: E402
import objdiff_data  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]


def project_name(name):
    """Use the same punctuation normalization as the split/postprocessor."""
    name = re.sub(r"[,<>.$]", "_", name)
    return "at_" + name[1:] if name.startswith("@") else name


def compiler_mappings(retail_names, compiler_names):
    """Resolve sanitized retail identities to symbols actually present in C++."""
    actual = {}
    for name in compiler_names:
        if re.fullmatch(r'@\d+', name):
            continue  # Anonymous numbers are not source/retail identities.
        actual.setdefault(project_name(name), []).append(name)
    result = {}
    for retail_name in retail_names:
        identity = re.sub(r"__\d+$", "", retail_name)
        candidates = actual.get(retail_name, actual.get(identity, []))
        if len(candidates) > 1:
            raise ValueError(f"ambiguous compiler symbols for {retail_name}: {candidates}")
        if candidates and (candidates[0] != retail_name or identity != retail_name):
            result[retail_name] = candidates[0]
    return result


def defined_symbols(object_path):
    """Read ELF32 symbol names independently of function-section ordering."""
    data = object_path.read_bytes()
    if len(data) < 52 or data[:6] != b"\x7fELF\x01\x01":
        raise ValueError(f"{object_path}: expected a little-endian ELF32 object")
    section_offset = struct.unpack_from("<I", data, 0x20)[0]
    section_size, section_count = struct.unpack_from("<HH", data, 0x2E)
    if section_size < 40 or not section_count:
        raise ValueError(f"{object_path}: unsupported ELF section table")
    if section_offset + section_size * section_count > len(data):
        raise ValueError(f"{object_path}: truncated ELF section table")
    sections = [struct.unpack_from("<10I", data, section_offset + index * section_size)
                for index in range(section_count)]

    def contents(section):
        offset, size = section[4:6]
        if offset + size > len(data):
            raise ValueError(f"{object_path}: truncated ELF symbol data")
        return data[offset:offset + size]

    names = set()
    for section in sections:
        if section[1] != 2:  # SHT_SYMTAB
            continue
        string_index, entry_size = section[6], section[9]
        if not 0 < string_index < section_count or sections[string_index][1] != 3:
            raise ValueError(f"{object_path}: invalid symbol string-table link")
        symbols, strings = contents(section), contents(sections[string_index])
        if entry_size < 16 or len(symbols) % entry_size:
            raise ValueError(f"{object_path}: invalid ELF symbol-table entry size")
        for offset in range(0, len(symbols), entry_size):
            name_offset, _value, _size, _info, _other, section_index = struct.unpack_from(
                "<IIIBBH", symbols, offset)
            if not name_offset or not 0 < section_index < section_count:
                continue
            if name_offset >= len(strings):
                raise ValueError(f"{object_path}: invalid ELF symbol name offset")
            end = strings.find(b"\0", name_offset)
            if end < 0:
                raise ValueError(f"{object_path}: unterminated ELF symbol name")
            names.add(strings[name_offset:end].decode("utf-8"))
    return names


def object_mappings(lay, unit, rows, object_path):
    if not object_path.is_file():
        return {}
    ranges = [(lo, hi) for _section, lo, hi in lay.sections(unit)]
    retail_names = [name for address, name, _size, _function in rows
                    if any(lo <= address < hi for lo, hi in ranges)]
    return compiler_mappings(retail_names, defined_symbols(object_path))


def config(build_dir):
    lay = layout.Layout()
    rows = layout.read_symbols(layout.SYMBOLS)
    units = []
    game_units = list(lay.units("cpp"))
    # Preflight every input before preparing any comparison. A missing target
    # must never expose reservation-bearing raw objects or an older copy.
    for unit in game_units:
        for kind, suffix in (("base", "cpp.o"), ("target", "s.o")):
            path = ROOT / f"{build_dir}/objdiff/{kind}/{unit}.{suffix}"
            if not path.is_file():
                raise FileNotFoundError(f"{unit}: missing objdiff input {path}")
    context = objdiff_data.Context()
    for unit in game_units:
        base_path = f"{build_dir}/objdiff/base/{unit}.cpp.o"
        target_path = f"{build_dir}/objdiff/target/{unit}.s.o"
        prepared_base = f"{build_dir}/objdiff/compare/base/{unit}.cpp.o"
        prepared_target = f"{build_dir}/objdiff/compare/target/{unit}.s.o"
        objdiff_data.comparison_copy(ROOT / base_path, ROOT / prepared_base, unit, context, True)
        objdiff_data.comparison_copy(ROOT / target_path, ROOT / prepared_target, unit, context, False)
        base_path, target_path = prepared_base, prepared_target
        units.append({
            "name": unit,
            "target_path": target_path,
            "base_path": base_path,
            "symbol_mappings": object_mappings(lay, unit, rows, ROOT / base_path),
            "metadata": {
                "source_path": lay.source(unit),
            },
        })
    return {
        "min_version": "3.7.3",
        "custom_make": "sh",
        "custom_args": ["-c", "exec scripts/build/build_objdiff.sh"],
        "build_target": False,
        "build_base": True,
        "watch_patterns": [
            "ps2/src/**/*.{c,cpp,h,hpp,s,inc,lcf}",
            "ps2/include/**/*.{h,hpp,s,inc,lcf}",
            "ps2/asm/**/*.s",
            "ps2/config/*/*.{yaml,txt}",
            "scripts/build/*.{py,sh,json}",
            "ps2/cmake/*.cmake",
        ],
        "options": {"demangler": "codewarrior", "functionRelocDiffs": "none",
                    "combineDataSections": True},
        "name": "chronicletwo",
        "units": units,
    }


def main():
    os.chdir(os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir, os.pardir)))
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--build-dir", default=os.environ.get("BUILD_DIR", str(layout.BUILD)))
    ap.add_argument("-o", "--output", default="objdiff.json")
    args = ap.parse_args()
    output = Path(args.output)
    try:
        output.write_text(json.dumps(config(args.build_dir), indent=2) + "\n")
    except Exception:
        output.unlink(missing_ok=True)
        raise
    return 0


if __name__ == "__main__":
    sys.exit(main())
