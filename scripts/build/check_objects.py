#!/usr/bin/env python3
"""Check, without linking, that each game unit's object holds exactly retail's sections.

    check_objects.py [unit...] [--obj-dir build/pal/obj] [-v]

For every `cpp` unit (or those named), `build/<region>/obj/<unit>.cpp.o` is
read and, for each section run main.yaml gives the unit:

a. its pieces -- the object's sections of that name, in object order -- are
   the symbols scripts/build/disassemble.py cuts the run into, in address
   order, and their sizes add up to exactly the run. A function's section
   may stop short of the next function by the padding its 16-byte alignment
   adds; a datum's may not stop short at all.
b. each piece's bytes equal retail's at its address, once the fields its
   relocations fill in are masked: the low 26 bits for R_MIPS_26, the low 16
   for R_MIPS_HI16, R_MIPS_LO16 and R_MIPS_GPREL16, the whole word for
   R_MIPS_32.
c. each relocation resolves to what retail encodes there: the symbol's
   address (from this object, main.symbols.txt or an invented name's
   spelling) plus the addend in place gives retail's word for R_MIPS_32, its
   jump target for R_MIPS_26, its offset from `_gp` for R_MIPS_GPREL16, and,
   for a R_MIPS_HI16 paired with the R_MIPS_LO16 after it, retail's two
   halves. An unpaired R_MIPS_HI16 is not checked.

A section of the object that belongs to none of the unit's runs is an error.
Prints one line per unit and exits non-zero if any check fails.
"""

import argparse
import re
import struct
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "mwccgap"))
sys.path.insert(0, str(Path(__file__).resolve().parent))

from mwccgap.elf import Elf, SHT_NOBITS  # noqa: E402

import disassemble  # noqa: E402
import layout  # noqa: E402

SHF_ALLOC = 0x2
STT_SECTION = 3

R_MIPS_32 = 2
R_MIPS_26 = 4
R_MIPS_HI16 = 5
R_MIPS_LO16 = 6
R_MIPS_GPREL16 = 7

MASKS = {R_MIPS_32: 0xFFFFFFFF, R_MIPS_26: 0x03FFFFFF, R_MIPS_HI16: 0xFFFF,
         R_MIPS_LO16: 0xFFFF, R_MIPS_GPREL16: 0xFFFF}

FUNCTION_ALIGNMENT = 16
NAMED_ADDRESS = re.compile(r"(?:D_|\.L)([0-9A-F]{8})")


def name_sections(elf):
    """Name every section; mwccgap's reader leaves its `.text` sections unnamed."""
    for section in elf.sections:
        section.name = elf.shstrtab.get_symbol_by_index(section.sh_name)


def sext16(value):
    value &= 0xFFFF
    return value - 0x10000 if value & 0x8000 else value


class Context:
    def __init__(self, obj_dir):
        self.obj_dir = Path(obj_dir)
        self.layout = layout.Layout()
        self.pieces = disassemble.Pieces(self.layout)
        self.retail = layout.Retail()
        self.addresses = {n: a for a, n, _s, _f in self.pieces.symbols.rows}
        self.gp = self.addresses["_gp"]
        # Names splat made up for values it took for addresses; the linker
        # script defines them.
        undefined = self.obj_dir.parent / "splat" / "main.undefined_syms.txt"
        if not undefined.is_file():
            undefined = ROOT / layout.BUILD / "splat" / "main.undefined_syms.txt"
        if undefined.is_file():
            for line in undefined.read_text().splitlines():
                name, _, value = line.split("//")[0].strip().rstrip(";").partition("=")
                if value:
                    self.addresses.setdefault(name.strip(), int(value, 0))

    def address_of(self, name):
        address = self.addresses.get(name)
        if address is None:
            m = NAMED_ADDRESS.fullmatch(name)
            if m:
                address = int(m.group(1), 16)
        return address


def word(data, offset):
    return struct.unpack_from("<I", data, offset)[0]


def check_unit(ctx, unit, verbose):
    path = ctx.obj_dir / f"{unit}.cpp.o"
    errors = []
    if not path.is_file():
        return [f"no object {path}"], 0, 0
    elf = Elf(path.read_bytes())
    name_sections(elf)
    symbols = elf.symtab.symbols

    # The symbol each allocated section starts with, and so its address.
    starts = {}
    runs = ctx.layout.sections(unit)
    for symbol in symbols:
        index = symbol.st_shndx
        if (symbol.name and symbol.type != STT_SECTION and symbol.st_value == 0
                and 0 < index < len(elf.sections)
                and elf.sections[index].sh_flags & SHF_ALLOC
                and ctx.address_of(symbol.name) is not None
                and any(lo <= ctx.address_of(symbol.name) < hi for name, lo, hi in runs)):
            starts.setdefault(index, symbol.name)

    by_name = defaultdict(list)
    for index, section in enumerate(elf.sections):
        if not section.sh_flags & SHF_ALLOC:
            continue
        by_name[section.name].append(index)

    section_address = {}
    function_alignment = FUNCTION_ALIGNMENT
    gcc_config = ROOT / layout.CONFIG / 'gcc_units.txt'
    if gcc_config.exists():
        for row in gcc_config.read_text().splitlines():
            if row.split() and row.split()[0] == unit:
                function_alignment = 8
    expected_names = {s for s, _lo, _hi in runs}
    for name, indices in by_name.items():
        if name not in expected_names:
            errors.append(f"{len(indices)} section(s) named {name}, which the unit has no run of")

    for section_name, lo, hi in runs:
        indices = by_name.get(section_name, [])
        expected = ctx.pieces.of(unit, section_name, lo, hi)
        got = [starts.get(i) for i in indices]
        if got != [n for n, _s, _e in expected]:
            missing = [n for n, _s, _e in expected if n not in got]
            extra = [n for n in got if n not in {e[0] for e in expected}]
            errors.append(f"{section_name}: pieces differ (missing {missing[:5]}, "
                          f"unexpected {extra[:5]}, {len(got)} vs {len(expected)})")
            continue
        cursor = lo
        for index, (name, start, end) in zip(indices, expected):
            section = elf.sections[index]
            size = section.sh_size if section.sh_type == SHT_NOBITS else len(section.data)
            section_address[index] = start
            if start != cursor:
                errors.append(f"{section_name}: {name} starts at 0x{start:08X}, previous ends 0x{cursor:08X}")
            if section_name in disassemble.CODE_SECTIONS:
                if section.sh_addralign != function_alignment or start % function_alignment:
                    errors.append(f"{name}: alignment {section.sh_addralign} at 0x{start:08X}")
                reach = start + -(-size // function_alignment) * function_alignment
                if not (start + size <= end <= reach):
                    errors.append(f"{name}: size 0x{size:X} does not reach 0x{end:08X}")
            else:
                if section.sh_addralign > 1:
                    errors.append(f"{name}: alignment {section.sh_addralign}")
                if size != end - start:
                    errors.append(f"{name}: size 0x{size:X}, retail 0x{end - start:X}")
            want_nobits = section_name in layout.NOBITS
            if want_nobits != (section.sh_type == SHT_NOBITS):
                errors.append(f"{name}: section type {section.sh_type}")
            cursor = start + size if section_name not in disassemble.CODE_SECTIONS else end
        run_end = expected[-1][2] if expected else hi
        if cursor != run_end:
            errors.append(f"{section_name}: run ends 0x{cursor:08X}, retail 0x{run_end:08X}")

    # Bytes and relocations.
    relocs = defaultdict(list)
    for record in elf.relocations:
        if record.sh_info in section_address:
            relocs[record.sh_info].extend(record.relocations)
    checked_relocs = 0
    checked_bytes = 0

    def symbol_address(symbol):
        if 0 < symbol.st_shndx < len(elf.sections) and symbol.st_shndx != 0xFFF1:
            base = section_address.get(symbol.st_shndx)
            return None if base is None else base + symbol.st_value
        return ctx.address_of(symbol.name)

    for index, start in section_address.items():
        section = elf.sections[index]
        if section.sh_type == SHT_NOBITS:
            continue
        data = bytearray(section.data)
        retail = bytearray(ctx.retail.bytes(start, start + len(data)))
        ours = bytes(data)
        # The assembler puts each R_MIPS_HI16 just before the R_MIPS_LO16 it
        # pairs with, so the records stay in the order it wrote them.
        relocations = relocs.get(index, [])
        for relocation in relocations:
            mask = MASKS.get(relocation.reloc_type)
            if mask is None:
                errors.append(f"{section.name}+0x{relocation.r_offset:X}: relocation type {relocation.reloc_type}")
                continue
            offset = relocation.r_offset
            value = word(data, offset) & ~mask
            struct.pack_into("<I", data, offset, value)
            struct.pack_into("<I", retail, offset, word(retail, offset) & ~mask)
        if data != retail:
            first = next(i for i in range(len(data)) if data[i] != retail[i])
            name = starts.get(index)
            errors.append(f"{name}: bytes differ at 0x{start + first:08X}")
        checked_bytes += len(data)

        # Relocation targets.
        for k, relocation in enumerate(relocations):
            kind = relocation.reloc_type
            offset = relocation.r_offset
            place = start + offset
            symbol = symbols[relocation.symbol_index]
            target = symbol_address(symbol)
            label = f"{starts.get(index)}+0x{offset:X} ({symbol.name or 'section'})"
            if target is None:
                errors.append(f"{label}: target symbol unresolved")
                continue
            mine = word(ours, offset)
            theirs = ctx.retail.word(place)
            if kind == R_MIPS_32:
                ok = (target + mine) & 0xFFFFFFFF == theirs
            elif kind == R_MIPS_26:
                value = ((place & 0xF0000000) | ((mine & 0x03FFFFFF) << 2)) + target
                ok = (value >> 2) & 0x03FFFFFF == theirs & 0x03FFFFFF
            elif kind == R_MIPS_GPREL16:
                ok = (target + sext16(mine) - ctx.gp) & 0xFFFF == theirs & 0xFFFF
            elif kind == R_MIPS_LO16:
                # The high half of the addend comes from the paired HI16.
                ok = (target + sext16(mine)) & 0xFFFF == theirs & 0xFFFF
            elif kind == R_MIPS_HI16:
                lo = next((r for r in relocations[k + 1:]
                           if r.reloc_type == R_MIPS_LO16 and r.symbol_index == relocation.symbol_index), None)
                if lo is None:
                    continue
                addend = ((mine & 0xFFFF) << 16) + sext16(word(ours, lo.r_offset))
                value = target + addend
                ok = ((value + 0x8000) >> 16) & 0xFFFF == theirs & 0xFFFF
            else:
                continue
            checked_relocs += 1
            if not ok:
                errors.append(f"{label}: type {kind} resolves differently from retail")
    return errors, checked_bytes, checked_relocs


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("units", nargs="*")
    ap.add_argument("--obj-dir", default=str(layout.BUILD / "obj"))
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    import os
    os.chdir(ROOT)
    ctx = Context(args.obj_dir)
    units = args.units or ctx.layout.units("cpp")
    failed = 0
    for unit in units:
        errors, nbytes, nrelocs = check_unit(ctx, unit, args.verbose)
        status = "ok  " if not errors else "FAIL"
        print(f"{status} {unit}: 0x{nbytes:X} bytes, {nrelocs} relocations"
              + (f", {len(errors)} problem(s)" if errors else ""))
        if errors:
            failed += 1
            for line in errors[:None if args.verbose else 10]:
                print(f"     {line}")
    print(f"{len(units) - failed}/{len(units)} units pass")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
