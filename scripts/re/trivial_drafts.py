#!/usr/bin/env python3
"""Draft strictly trivial no-argument functions from both decompilers.

Usage: python3 scripts/re/trivial_drafts.py UNIT [--limit N]

Only a bare INCLUDE_ASM with an exact declaration in the unit header is
eligible. This deliberately leaves functions needing typework to a person.
The game build keeps assembly until draft_check.py promotes a match.
"""

import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MANIFEST = ROOT / "build/re/manifest.tsv"
M2C = ROOT / "build/re/m2c"
GHIDRA = ROOT / "build/re/ghidra"


def candidate(unit, symbol, header):
    free = re.fullmatch(r"([A-Za-z_][A-Za-z_0-9]*)__F.*", symbol)
    member = re.fullmatch(r"([A-Za-z_][A-Za-z_0-9]*__)\d+.*", symbol)
    class_name = None
    if member:
        stem = member.group(1)
        count = re.match(r"\d+", symbol[len(stem):])
        tail = symbol[len(stem) + len(count.group(0)):]
        class_name = tail[:int(count.group(0))]
        if not tail[len(class_name):].startswith("F"):
            member = None
    if free:
        name, scope = free.group(1), ""
    elif member:
        name, scope = member.group(1)[:-2], class_name + "::"
        if not re.search(r"\b(?:class|struct)\s+" + re.escape(class_name) + r"\b", header):
            return None
    else:
        return None
    doc = re.search(r"@mangled\s+" + re.escape(symbol) + r"\s[\s\S]*?\*/\s*", header)
    if not doc:
        return None
    declaration = re.match(r"((?:virtual\s+)?(void|int|float|u8)\s+" + re.escape(name)
                           + r"\([^;\n]*\))\s*;", header[doc.end():])
    if not declaration:
        return None
    prototype, result = declaration.group(1), declaration.group(2)
    params = prototype[prototype.index("(") + 1:-1].strip()
    def count_params(value):
        if not value or value == "void":
            return 0
        depth = 0
        count = 1
        for char in value:
            depth += (char == "(") - (char == ")")
            if char == "," and depth == 0:
                count += 1
        return count
    m2c_path = M2C / unit / (symbol + ".c")
    ghidra_path = GHIDRA / unit / (symbol + ".c")
    if not m2c_path.exists() or not ghidra_path.exists():
        return None
    m2c = re.sub(r"(?m)^/\* Warning:.*\*/\s*", "", m2c_path.read_text())
    ghidra = ghidra_path.read_text()
    m = re.fullmatch(
        r"/\*[^\n]*\*/\s+(void|s32|u32|u8|f32)\s+" + re.escape(symbol)
        + r"\((.*?)\)\s*\{\s*(return\s+(?:-?\d+|0x[0-9A-Fa-f]+|\d+\.\d+f?|this->[A-Za-z_]\w*);)?\s*\}\s*", m2c, re.S)
    if not m:
        return None
    m2c_args = m.group(2).strip()
    if member:
        prefix = re.match(re.escape(class_name) + r"\s*\*this\s*(?:,\s*)?", m2c_args)
        if not prefix:
            return None
        m2c_args = m2c_args[prefix.end():]
    if count_params(params) != count_params(m2c_args):
        return None
    ret = m.group(3)
    if (result == "void") != (ret is None):
        return None
    if ret is None:
        if not re.search(r"\{\s*return;\s*\}\s*$", ghidra):
            return None
    elif ret.startswith("return this->"):
        if member is None or params:
            return None
        field = ret[len("return this->"):-1]
        class_body = header.split("class " + class_name + " {", 1)
        if len(class_body) != 2 or not re.search(r"\b" + re.escape(field) + r"\s*;", class_body[1].split("};", 1)[0]):
            return None
        if not re.search(r"\{\s*return\s+(?:\*\([^;]+\bthis\b[^;]+\)|this\[[^;]+\]);\s*\}\s*$", ghidra):
            return None
    else:
        if result not in ("int", "float"):
            return None
        theirs = re.search(r"\{\s*return\s+(-?(?:\d+|0x[0-9A-Fa-f]+|\d+\.\d+f?));\s*\}\s*$", ghidra)
        if not theirs:
            return None
        mine_value, their_value = ret[7:-1], theirs.group(1)
        if result == "int" and ("." in mine_value or "." in their_value or int(mine_value, 0) != int(their_value, 0)):
            return None
        if result == "float":
            try:
                same_value = float(mine_value.rstrip("f")) == float(their_value.rstrip("f"))
            except ValueError:
                return None
            if not same_value:
                return None
    definition = prototype.removeprefix("virtual ").replace(name + "(", scope + name + "(", 1)
    return definition + " {" + (f" {ret} " if ret else "") + "}"


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("unit")
    parser.add_argument("--limit", type=int, default=8)
    args = parser.parse_args()
    source = ROOT / "ps2/src" / (args.unit + ".cpp")
    header = ROOT / "ps2/include" / (args.unit + ".hpp")
    if not source.exists() or not header.exists():
        parser.error("unit source and header are required")
    text = source.read_text()
    declarations = header.read_text()
    replacements = []
    for row in MANIFEST.read_text().splitlines():
        unit, symbol, *_ = row.split("\t")
        if unit != args.unit or len(replacements) >= args.limit:
            continue
        definition = candidate(unit, symbol, declarations)
        if definition is None:
            continue
        marker = f'INCLUDE_ASM("ps2/asm/pal/nonmatchings/{unit}", {symbol});'
        if text.count(marker) != 1:
            continue
        if re.search(r"#ifdef NONMATCHING\b(?:(?!#endif).)*#else\s*" + re.escape(marker), text, re.S):
            continue
        replacement = f"#ifdef NONMATCHING\n{definition}\n#else\n{marker}\n#endif"
        text = text.replace(marker, replacement)
        replacements.append(symbol)
    if replacements:
        source.write_text(text)
    print(f"{args.unit}: {len(replacements)} drafts")
    for symbol in replacements:
        print(symbol)


if __name__ == "__main__":
    main()
