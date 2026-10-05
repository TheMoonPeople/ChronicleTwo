#!/usr/bin/env python3
"""Compile a game unit's drafts and say which already match retail.

    draft_check.py <unit>             compile with UNMATCHING and NONMATCHING and compare
    draft_check.py <unit> --promote   also build the unit as the game build
                                      does and check that object against retail
    draft_check.py <unit> --diff <symbol>
                                      print one function's instructions beside
                                      retail's, differing ones marked
    draft_check.py <unit> --promote-one <symbol>
                                      test one draft alone and promote only if
                                      its linked image matches retail
    draft_check.py <unit> --promote-all
                                      make one isolated attempt per draft
    draft_check.py --header ps2/include/<file>
                                      compile one header on its own

A draft is the C++ a source gives for a function inside `#ifdef UNMATCHING`
or `#ifdef NONMATCHING`, with the function's INCLUDE_ASM marker in the `#else`.
The first form compiles the unit with both macros defined, so every draft is compiled, and
compares each function with retail's bytes, relocated fields masked:

    MATCH     the same bytes; a candidate for promotion
    DIFF      compiles, differs
    NO DRAFT  the source defines no such function

`--promote` is the test a promoted function has to pass: the unit is built
without UNMATCHING through tools/mwccgap, exactly as the build does, its
object is linked in place of the build's own among the objects of the last
full build, and the image is compared with retail's. A function whose bytes
match can still fail it, when promoting it brings data of its own into the
object that does not land where retail has it.

Runs in the dev container (scripts/re/draft.sh starts one). Objects go to
build/re/draft and build/re/check, never to the build's own directory.

`--promote-one SYMBOL` and `--promote-all` try a draft exactly once with all
other drafts behind INCLUDE_ASM. A successful whole-image comparison removes
that draft's guard and marker from its source file. A failed attempt leaves
the guarded draft and retail assembly in place. Attempt reservations are kept
in scripts/re/promotion_attempts.tsv, one tab-separated unit, mangled symbol,
and provenance per line. A reservation is written before compilation, so a
failed compile or interrupted attempt is still counted. Lines beginning with
`#` document the ledger format. Existing build/re/*.promote.log attempts and
documented manual attempts seed the tracked ledger.
"""

import argparse
import fcntl
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "mwccgap"))
sys.path.insert(0, str(ROOT / "scripts" / "build"))

import mwccgap.elf  # noqa: E402
from mwccgap.elf import Elf  # noqa: E402

import check_objects  # noqa: E402
import layout  # noqa: E402

MW_DIR = "tools/compilers/mw/3.0-011126"
LIB_INCLUDE_DIRS = "ps2/include/std;ps2/include/sce"
CC_FLAGS = ["-O3,p", "-strings", "readonly", "-c", "-Cpp_exceptions", "off", "-RTTI", "off", "-i", "ps2/include"]
DRAFT_DIR = Path("build/re/draft")
CHECK_DIR = Path("build/re/check")
ATTEMPT_LEDGER = ROOT / "scripts/re/promotion_attempts.tsv"
STT_FUNC = 2

# A draft that instantiates a member of a class template emits it as a weak
# function; the object reader has to count those among the functions too.
STB_WEAK_FUNC = 0x22
if STB_WEAK_FUNC not in mwccgap.elf.FUNCTION_ST_INFOS:
    mwccgap.elf.FUNCTION_ST_INFOS = mwccgap.elf.FUNCTION_ST_INFOS + (STB_WEAK_FUNC,)


def project_name(name):
    """A compiler's symbol name as main.symbols.txt spells it."""
    name = re.sub(r"[,<>.$]", "_", name)
    return "at_" + name[1:] if name.startswith("@") else name


def manifest(unit):
    """{symbol: (address, size)} for the unit's functions."""
    out = {}
    for line in Path("build/re/manifest.tsv").read_text().splitlines():
        row_unit, symbol, address, size, _section, _assembly = line.split("\t")
        if row_unit == unit:
            out[symbol] = (int(address, 16), int(size, 16))
    return out


def compile_drafts(unit):
    obj = DRAFT_DIR / f"{unit}.o"
    obj.parent.mkdir(parents=True, exist_ok=True)
    obj.unlink(missing_ok=True)
    command = ["wibo", f"{MW_DIR}/mwccps2.exe", *CC_FLAGS, "-lang", "c++", "-DUNMATCHING", "-DNONMATCHING",
               "-o", str(obj), f"ps2/src/{unit}.cpp"]
    result = subprocess.run(command, env={**os.environ, "MWCIncludes": LIB_INCLUDE_DIRS},
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    output = result.stdout.replace("\r", "").strip()
    if result.returncode != 0 or not obj.is_file():
        print(output)
        print(f"\n{unit}: does not compile with UNMATCHING defined")
        return None
    if output:
        print(output)
    return obj


def compare(unit, obj):
    retail = layout.Retail()
    functions = manifest(unit)
    elf = Elf(obj.read_bytes())
    relocations = {}
    for record in elf.relocations:
        relocations.setdefault(record.sh_info, []).extend(record.relocations)

    status = {}
    for symbol in elf.symtab.symbols:
        index = symbol.st_shndx
        if symbol.type != STT_FUNC or not (0 < index < len(elf.sections)):
            continue
        name = project_name(symbol.name)
        if name not in functions:
            # main.symbols.txt tells same-named locals apart with `__<n>`.
            twins = [f for f in functions if re.fullmatch(re.escape(name) + r"__\d+", f)]
            if len(twins) != 1:
                continue
            name = twins[0]
        address, extent = functions[name]
        data = bytearray(elf.sections[index].data)
        size = len(data)
        if size > extent:
            status[name] = f"DIFF      0x{size:X} bytes, retail 0x{extent:X}"
            continue
        theirs = bytearray(retail.bytes(address, address + extent))
        ours = data + bytearray(extent - size)
        mine = {}
        for relocation in relocations.get(index, []):
            mine[relocation.r_offset] = relocation.reloc_type
        wanted = {a - address: kind for a, kind in retail.relocations.items()
                  if address <= a < address + extent}
        for offset, kind in mine.items():
            mask = check_objects.MASKS.get(kind, 0xFFFFFFFF)
            for buffer in (ours, theirs):
                value = int.from_bytes(buffer[offset:offset + 4], "little") & ~mask
                buffer[offset:offset + 4] = value.to_bytes(4, "little")
        differing = sum(ours[i:i + 4] != theirs[i:i + 4] for i in range(0, extent, 4))
        if differing == 0 and mine == wanted:
            status[name] = "MATCH"
        elif differing == 0:
            status[name] = "DIFF      same instructions, different relocations"
        else:
            note = "" if size == extent else f", 0x{size:X} bytes against retail's 0x{extent:X}"
            status[name] = f"DIFF      {differing} of {extent // 4} words differ{note}"

    counts = {"MATCH": 0, "DIFF": 0, "NO DRAFT": 0}
    for name in functions:
        line = status.get(name, "NO DRAFT")
        counts[line.split("  ")[0].strip() if line != "NO DRAFT" else "NO DRAFT"] += 1
        print(f"  {line.split()[0] if line != 'NO DRAFT' else 'NO DRAFT':<9} {name}"
              + (f"  ({line.split(None, 1)[1]})" if line.startswith("DIFF") else ""))
    print(f"{unit}: {len(functions)} functions: {counts['MATCH']} match, "
          f"{counts['DIFF']} differ, {counts['NO DRAFT']} without a draft")
    return counts


def objdump(arguments):
    result = subprocess.run(["mips-ps2-decompals-objdump", *arguments],
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    return result.stdout.splitlines()


INSTRUCTION = re.compile(r"^\s*([0-9a-f]+):\t([0-9a-f]{8}) \t(.*)$")


def show_diff(unit, obj, wanted):
    """Print retail's and the draft's instructions for one function, side by side."""
    functions = manifest(unit)
    if wanted not in functions:
        sys.exit(f"{wanted} is not a function of {unit}")
    address, extent = functions[wanted]

    retail = []
    for line in objdump(["-d", "-j", "main", f"--start-address={address:#x}",
                         f"--stop-address={address + extent:#x}", str(layout.ELF_PATH)]):
        m = INSTRUCTION.match(line)
        if m:
            retail.append((int(m.group(2), 16), m.group(3).replace("\t", " ")))

    draft = []
    relocation = {}
    inside = False
    for line in objdump(["-d", "-r", str(obj)]):
        header = re.match(r"^[0-9a-f]+ <(.+)>:$", line)
        if header:
            name = project_name(header.group(1))
            inside = name == wanted or re.fullmatch(re.escape(name) + r"__\d+", wanted) is not None
            continue
        if not inside:
            continue
        m = INSTRUCTION.match(line)
        if m:
            draft.append((int(m.group(2), 16), m.group(3).replace("\t", " ")))
        else:
            m = re.match(r"^\s*[0-9a-f]+: (R_MIPS_\w+)\s+(\S+)", line)
            if m and draft:
                relocation[len(draft) - 1] = f"{m.group(1)[7:]} {m.group(2)}"
    if not draft:
        print(f"{wanted}: NO DRAFT")
        return

    # Fields a relocation fills are left out of the comparison.
    masks = {"26": 0x03FFFFFF, "HI16": 0xFFFF, "LO16": 0xFFFF, "GPREL16": 0xFFFF, "32": 0xFFFFFFFF}
    print(f"{'':2}{'offset':>6}  {'retail':<44}  draft")
    differing = 0
    for i in range(max(len(retail), len(draft))):
        theirs = retail[i] if i < len(retail) else None
        ours = draft[i] if i < len(draft) else None
        mask = masks.get(relocation.get(i, "").split(" ")[0], 0)
        same = (theirs is not None and ours is not None
                and theirs[0] & ~mask == ours[0] & ~mask)
        if theirs is None and ours is not None:
            same = False
        if ours is None and theirs is not None:
            same = theirs[0] == 0
        differing += not same
        note = f"  [{relocation[i]}]" if i in relocation else ""
        print(f"{' ' if same else '|':2}{i * 4:>6x}  {(theirs[1] if theirs else ''):<44}  "
              f"{(ours[1] if ours else '')}{note}")
    print(f"{wanted}: {differing} of {max(len(retail), len(draft))} instructions differ "
          f"(retail's operands show resolved addresses; the draft's show its relocations)")


def header_check(header):
    """Compile a header on its own, after common.h."""
    DRAFT_DIR.mkdir(parents=True, exist_ok=True)
    stem = re.sub(r"\W", "_", header)
    source = DRAFT_DIR / f"header_{stem}.cpp"
    obj = DRAFT_DIR / f"header_{stem}.o"
    relative = os.path.relpath(header, "ps2/include")
    source.write_text(f'#include "common.h"\n#include "{relative}"\n')
    command = ["wibo", f"{MW_DIR}/mwccps2.exe", *CC_FLAGS, "-lang", "c++", "-DUNMATCHING", "-DNONMATCHING",
               "-o", str(obj), str(source)]
    result = subprocess.run(command, env={**os.environ, "MWCIncludes": LIB_INCLUDE_DIRS},
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    output = result.stdout.replace("\r", "").strip()
    if output:
        print(output)
    ok = result.returncode == 0 and obj.is_file()
    print(f"{header}: {'compiles' if ok else 'DOES NOT COMPILE'}")
    return ok


MW_LD = "tools/compilers/mw/2.4-001213/mwldps2.exe"
LD_FLAGS = ["-map", "-nostdlib", "-m", "ENTRYPOINT", "-nodead", "-g"]


def promote_check(unit, source=None):
    """Build the unit as the game build does and link it into the image.

    Every other object is the one the last full build left in build/pal/obj,
    so only this unit's source is under test: its object replaces the build's
    in the link order, and the linked image is compared with retail's.
    """
    work = CHECK_DIR / unit
    obj = work / f"{unit}.cpp.o"
    work.mkdir(parents=True, exist_ok=True)
    obj.unlink(missing_ok=True)
    build = subprocess.run(
        ["sh", "scripts/build/mwccgap.sh", str(obj), str(obj) + ".d",
         str(source or f"ps2/src/{unit}.cpp"), *CC_FLAGS, "-i", "ps2/src"],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    if build.returncode == 0:
        build = subprocess.run(["sh", "scripts/build/fixup_sections.sh", str(obj)],
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    if build.returncode != 0 or not obj.is_file():
        print(build.stdout.replace("\r", "").strip())
        print(f"\n{unit}: PROMOTE FAILED - the game build of the unit does not compile")
        return False

    listing = layout.BUILD / "main_o_files"
    own = f"{layout.BUILD}/obj/{unit}.cpp.o"
    objects = listing.read_text().split()
    if own not in objects or not all(Path(o).is_file() for o in objects):
        print(f"{unit}: PROMOTE FAILED - {layout.BUILD} holds no complete build to link against")
        return False
    order = work / "main_o_files"
    order.write_text("\n".join(str(obj) if o == own else o for o in objects) + "\n")
    image = work / layout.BASENAME
    image.unlink(missing_ok=True)
    link = subprocess.run(
        ["wibo", MW_LD, *LD_FLAGS, "-o", str(image),
         str(layout.CONFIG / f"{layout.BASENAME}.lcf"), f"@{order}"],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    if link.returncode != 0 or not image.is_file():
        print(link.stdout.replace("\r", "").strip()[-3000:])
        print(f"\n{unit}: PROMOTE FAILED - the image does not link with this unit's object")
        return False
    verify = subprocess.run(
        [sys.executable, "scripts/build/verify.py", "-c", "--build-dir", str(work)],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    if verify.returncode != 0:
        print(verify.stdout.strip())
        print(f"{unit}: PROMOTE FAILED - the image linked with this unit's object differs "
              "from retail")
        return False
    print(f"{unit}: PROMOTE OK - the image linked with this unit's object matches retail")
    return True


DIRECTIVE = re.compile(r"^\s*#\s*(if|ifdef|ifndef|else|elif|endif)\b")
DRAFT_GUARD = re.compile(r"^\s*#\s*ifdef\s+(?:UNMATCHING|NONMATCHING)\s*$")
ASM_MARKER = re.compile(r'INCLUDE_ASM\("[^"]+",\s*([^\s,)]+)\s*\)')


def draft_blocks(source):
    """Find draft/assembly pairs without confusing nested preprocessor guards."""
    lines = source.splitlines(keepends=True)
    found = []
    for start, line in enumerate(lines):
        if not DRAFT_GUARD.match(line):
            continue
        depth = 0
        other = None
        for end in range(start + 1, len(lines)):
            directive = DIRECTIVE.match(lines[end])
            if not directive:
                continue
            kind = directive.group(1)
            if kind in ("if", "ifdef", "ifndef"):
                depth += 1
            elif kind == "endif":
                if depth:
                    depth -= 1
                else:
                    if other is not None:
                        markers = ASM_MARKER.findall("".join(lines[other + 1:end]))
                        if len(markers) == 1:
                            found.append((markers[0], start, other, end))
                    break
            elif kind == "else" and depth == 0:
                other = end
    return lines, found


def reserve_attempt(unit, symbol):
    """Record an attempt before compiling, under a file lock shared by workers."""
    with ATTEMPT_LEDGER.open("a+") as ledger:
        fcntl.flock(ledger.fileno(), fcntl.LOCK_EX)
        ledger.seek(0)
        for line in ledger:
            if line.startswith("#") or not line.strip():
                continue
            columns = line.rstrip("\n").split("\t")
            if len(columns) < 2:
                raise ValueError(f"invalid promotion ledger row: {line.rstrip()}")
            if columns[:2] == [unit, symbol]:
                return False
        ledger.seek(0, os.SEEK_END)
        ledger.write(f"{unit}\t{symbol}\tchecker\n")
        ledger.flush()
        os.fsync(ledger.fileno())
        return True


def promote_drafts(unit, wanted=None):
    """Test each selected draft in isolation, changing source only on success."""
    path = Path(f"ps2/src/{unit}.cpp")
    source = path.read_text()
    lines, blocks = draft_blocks(source)
    if wanted is not None:
        blocks = [block for block in blocks if block[0] == wanted]
        if len(blocks) != 1:
            print(f"{unit}: expected one guarded draft for {wanted}; found {len(blocks)}")
            return False
    if not blocks:
        print(f"{unit}: no guarded function drafts")
        return wanted is None

    # Work backwards so removing a successful block cannot move later offsets.
    all_ok = True
    expected_source = source
    for symbol, start, other, end in reversed(blocks):
        if path.read_text() != expected_source:
            print(f"{unit}: source changed during promotion; stopping before {symbol}")
            return False
        if not reserve_attempt(unit, symbol):
            print(f"{unit}: already attempted {symbol}; skipping", flush=True)
            if wanted is not None:
                return False
            continue
        trial = lines.copy()
        trial[start] = "#if 1\n"
        candidate = CHECK_DIR / unit / f"{unit}.cpp"
        candidate.parent.mkdir(parents=True, exist_ok=True)
        candidate.write_text("".join(trial))
        print(f"{unit}: trying {symbol}", flush=True)
        if promote_check(unit, candidate):
            if path.read_text() != expected_source:
                print(f"{unit}: source changed during the trial; leaving {symbol} guarded")
                return False
            lines[start:end + 1] = lines[start + 1:other]
            expected_source = "".join(lines)
            path.write_text(expected_source)
            print(f"{unit}: promoted {symbol}", flush=True)
        else:
            all_ok = False
            print(f"{unit}: kept {symbol} behind its draft guard", flush=True)
    return all_ok


def main():
    os.chdir(ROOT)
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("unit", help="a game unit, or with --header a file under ps2/include")
    ap.add_argument("--header", action="store_true",
                    help="compile the named header on its own instead")
    ap.add_argument("--diff", metavar="SYMBOL",
                    help="print retail's and the draft's instructions for one function")
    ap.add_argument("--promote", action="store_true",
                    help="build the unit as the game build does and check it against retail")
    selection = ap.add_mutually_exclusive_group()
    selection.add_argument("--promote-one", metavar="SYMBOL",
                           help="try one guarded draft in isolation and promote it only if exact")
    selection.add_argument("--promote-all", action="store_true",
                           help="try every guarded function draft once and promote exact ones")
    args = ap.parse_args()
    if args.header:
        return 0 if header_check(args.unit) else 1
    if not Path(f"ps2/src/{args.unit}.cpp").is_file():
        sys.exit(f"no source ps2/src/{args.unit}.cpp")
    if args.promote_one or args.promote_all:
        return 0 if promote_drafts(args.unit, args.promote_one) else 1
    obj = compile_drafts(args.unit)
    if obj is None:
        return 1
    if args.diff:
        show_diff(args.unit, obj, args.diff)
        return 0
    compare(args.unit, obj)
    if args.promote and not promote_check(args.unit):
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
