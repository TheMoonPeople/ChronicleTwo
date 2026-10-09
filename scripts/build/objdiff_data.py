"""Prepare source-only data comparisons without importing assembly fallbacks.

The raw objdiff objects remain compiler/assembler output. Comparison copies use
the linker's data extents, actual retail relocations, and verified native data
identities. Code bytes, extents and relocation fields retain their raw form;
function names use the existing template/initializer name projection.
"""

import bisect
import hashlib
import json
from pathlib import Path
import re
import struct

import disassemble
import layout
import lcf
import postprocess_object as p
from mwccgap import elf as mwccgap_elf
from mwccgap.elf import Relocation, RelocationRecord, Symbol


class Context:
    """Share immutable retail inputs across all comparison objects."""

    def __init__(self):
        self.layout = layout.Layout()
        self.rows = layout.read_symbols()
        self.addresses = {name: address for address, name, _size, _function in self.rows}
        self.retail = layout.Retail()
        self.pieces = disassemble.Pieces(self.layout)
        self.literal_pieces = disassemble.Pieces(self.layout, references=[])
        defined = self.pieces.defined()
        self.addresses.update((name, address) for address, name in defined)
        self.resolve = disassemble.Resolver(defined)
        self.linker = lcf.Generator()
        inputs = [Path(__file__), Path(p.__file__), Path(disassemble.__file__),
                  Path(layout.__file__), Path(lcf.__file__), layout.YAML,
                  layout.SYMBOLS, layout.ELF_PATH, Path(mwccgap_elf.__file__)]
        digest = hashlib.sha256()
        for path in inputs:
            contents = path.read_bytes()
            digest.update(len(contents).to_bytes(8, 'big'))
            digest.update(contents)
        digest.update(json.dumps(defined).encode())
        self.fingerprint = digest.hexdigest()

    def ranges(self, unit):
        return {name: (lo, self.linker.contents_end(unit, lo, hi), hi)
                for name, lo, hi in self.layout.sections(unit) if name not in p.CODE}


def drop_sections(elf, removed):
    """Remove data sections and make their references undefined, never code."""
    if any(elf.sections[index].sh_flags & p.SHF_EXECINSTR for index in removed):
        raise ValueError('Cannot remove executable comparison sections')
    removed = set(removed) | {index for index, section in enumerate(elf.sections)
                             if isinstance(section, RelocationRecord) and section.sh_info in removed}
    keep = [index for index in range(len(elf.sections)) if index not in removed]
    remap = {old: new for new, old in enumerate(keep)}
    elf.sections = [elf.sections[index] for index in keep]
    elf.relocations = [record for record in elf.relocations if record in elf.sections]
    elf.e_shstrndx = remap[elf.e_shstrndx]
    elf.symtab_index = remap[elf.symtab_index]
    for symbol in elf.symtab.symbols:
        if symbol.st_shndx in removed:
            symbol.st_shndx = symbol.st_value = symbol.st_size = 0
        elif symbol.st_shndx in remap:
            symbol.st_shndx = remap[symbol.st_shndx]
    for section in elf.sections:
        if section.sh_link in remap:
            section.sh_link = remap[section.sh_link]
    for record in elf.relocations:
        record.sh_info = remap[record.sh_info]


def code_snapshot(elf):
    """Capture bytes, function metadata and serialized code relocation fields."""
    code = {index for index, section in enumerate(elf.sections)
            if section.sh_flags & p.SHF_EXECINSTR}
    return [(bytes(elf.sections[index].data),
             sorted((p.project_name(symbol.name), symbol.st_value, symbol.st_size, symbol.bind, symbol.type)
                    for symbol in elf.symtab.symbols if symbol.st_shndx == index),
             [entry.pack() for record in elf.relocations
              if record.sh_info == index for entry in record.relocations])
            for index in sorted(code)]


def restore_reference_data(elf, unit, ctx):
    """Use retail bytes and real relocations, removing splat's pointer guesses."""
    ranges = ctx.ranges(unit)
    section_bases = {index: lo for index, section in enumerate(elf.sections)
                     for name, lo, _hi in ctx.layout.sections(unit) if section.name == name}

    def target_address(symbol):
        if symbol.st_shndx in section_bases:
            return section_bases[symbol.st_shndx] + symbol.st_value
        address = ctx.addresses.get(symbol.name)
        if address is not None:
            return address
        match = re.fullmatch(r'(?:D_|\.L)([0-9A-Fa-f]{8})', symbol.name)
        return int(match.group(1), 16) if match else None

    for index, section in enumerate(elf.sections[:]):
        if section.name not in ranges or not section.sh_flags & p.SHF_ALLOC:
            continue
        lo, end, hi = ranges[section.name]
        size = p.section_size(section)
        if size != hi - lo:
            # Empty sections are emitted even when the unit has no such run.
            raise ValueError(f'{unit}: unexpected reference {section.name} extent {size:#x}')
        if section.sh_type == p.SHT_NOBITS:
            section.sh_size = end - lo
            continue
        tail = ctx.retail.bytes(end, hi)
        if any(tail) or any(end <= addr < hi for addr in ctx.retail.relocations):
            raise ValueError(f'{unit}: non-padding reference tail in {section.name}')
        data = bytearray(ctx.retail.bytes(lo, end))
        expected = {address - lo: kind for address, kind in ctx.retail.relocations.items()
                    if lo <= address < end}
        if any(kind != p.R_MIPS_32 for kind in expected.values()):
            raise ValueError(f'{unit}: unsupported retail data relocation')
        records = [record for record in elf.relocations if record.sh_info == index]
        if len(records) > 1:
            raise ValueError(f'{unit}: duplicate reference relocation records')
        record = records[0] if records else None
        entries = []
        for offset, kind in sorted(expected.items()):
            if offset % 4 or offset + 4 > len(data):
                raise ValueError(f'{unit}: unaligned or truncated data relocation')
            destination = ctx.retail.word(lo + offset)
            position = bisect.bisect_right(ctx.resolve.addresses, destination) - 1
            if position < 0:
                raise ValueError(f'{unit}: no symbol for real data relocation')
            name = ctx.resolve.names[position]
            # A switch table addresses labels inside one function. Express its
            # true relocation against that function with an interior addend,
            # as MWCC does, without changing any labels or code bytes.
            owner = next((name for start, name, size, function in ctx.rows
                          if function and start <= destination < start + size), None)
            if owner is not None:
                name = owner
            symbol = Symbol(0, 0, 0, 0x10, 0, 0)
            symbol.name = name
            symbol_index = elf.add_symbol(symbol)
            address = target_address(elf.symtab.symbols[symbol_index])
            if address is None:
                raise ValueError(f'{unit}: unknown real reference relocation target')
            entry = Relocation(offset, (symbol_index << 8) | kind)
            struct.pack_into('<I', data, offset, (ctx.retail.word(lo + offset) - address) & 0xffffffff)
            entries.append(entry)
        if record:
            record.relocations = entries
        elif entries:
            record = RelocationRecord(elf.add_sh_symbol('.rel' + section.name), 9, 0, 0, 0, 0,
                                      elf.symtab_index, index, 4, 8, b'')
            record.name = '.rel' + section.name
            record.relocations = entries
            elf.add_section(record)
        section.data = bytes(data)
        # Splat labels do not declare object extents; retain only the section's
        # own bytes when the following tail belongs to linker alignment.
        for symbol in elf.symtab.symbols:
            if symbol.st_shndx == index and symbol.st_value + symbol.st_size > len(data):
                if symbol.st_value > len(data):
                    symbol.st_shndx = symbol.st_value = symbol.st_size = 0
                else:
                    symbol.st_size = len(data) - symbol.st_value
    set_reference_data_symbols(elf, unit, ctx)


def set_reference_data_symbols(elf, unit, ctx):
    """Use canonical piece boundaries, not splat's inferred data labels."""
    ranges = ctx.ranges(unit)
    runs = {name: run for name, run in ctx.pieces.unit(unit) if name in ranges}
    for index, section in enumerate(elf.sections):
        if section.name not in ranges or not section.sh_flags & p.SHF_ALLOC:
            continue
        lo, end, _hi = ranges[section.name]
        expected = {name: (start - lo, min(stop, end) - start)
                    for name, start, stop in runs.get(section.name, ()) if start < end}
        for symbol in elf.symtab.symbols:
            if symbol.st_shndx != index or symbol.type == p.STT_SECTION:
                continue
            extent = expected.get(symbol.name)
            if extent is None or symbol.st_value != extent[0]:
                symbol.st_shndx = symbol.st_value = symbol.st_size = 0
            else:
                symbol.type = p.STT_OBJECT
                symbol.st_size = extent[1]
        for name, (value, size) in expected.items():
            existing = next((symbol for symbol in elf.symtab.symbols
                             if symbol.name == name and symbol.st_shndx == index), None)
            if existing is None:
                symbol = Symbol(0, value, size, 0x11, 0, index)
                symbol.name = name
                symbol_index = elf.add_symbol(symbol)
                existing = elf.symtab.symbols[symbol_index]
                existing.st_shndx, existing.st_value, existing.st_size = index, value, size
                existing.type = p.STT_OBJECT


def normalize_data_callbacks(elf, unit, ctx, function_identities, held, native_extents):
    """Keep fully verified local callback identities in data, preserving raw code."""
    ranges = [(lo, hi) for name, lo, hi in ctx.layout.sections(unit) if name in p.CODE]
    rows = {}
    for address, name, size, function in ctx.rows:
        rows.setdefault(name, []).append((address, size, function))
    code_rows = {name: values[0] for name, values in rows.items() if len(values) == 1}
    extents = {id(symbol): size for symbol, size, _align, _type, _name in native_extents.values()}
    identities = {}
    for symbol in elf.symtab.symbols:
        canonical = function_identities.get(id(symbol), symbol.name)
        values = rows.get(canonical, [])
        if (symbol.type != p.STT_FUNC or symbol.bind != p.STB_LOCAL
                or canonical == symbol.name
                or re.fullmatch(re.escape(symbol.name) + r'__\d+', canonical) is None
                or sum(other.type == p.STT_FUNC and other.name == symbol.name
                       for other in elf.symtab.symbols) != 1
                or len(values) != 1 or not values[0][2]
                or ctx.addresses.get(canonical) != values[0][0]
                or not any(lo <= values[0][0] < values[0][0] + values[0][1] <= hi
                           for lo, hi in ranges)):
            continue
        identities[id(symbol)] = canonical
        code_rows[symbol.name] = values[0]

    def address_of_symbol(symbol):
        return ctx.addresses.get(identities.get(id(symbol), symbol.name))

    verified = {id(symbol): identities[id(symbol)] for symbol in elf.symtab.symbols
                if id(symbol) in identities and 0 < symbol.st_shndx < len(elf.sections)
                and p.complete_code_consumer(elf, symbol.st_shndx, retail=ctx.retail,
                                              rows=code_rows, address_of_symbol=address_of_symbol,
                                              gp=ctx.addresses.get('_gp'))}
    pending = {}
    for record in elf.relocations:
        index = record.sh_info
        section = elf.sections[index]
        if (section.name not in ('.data', '.sdata', '.rodata')
                or section.sh_type != p.SHT_PROGBITS
                or not section.sh_flags & p.SHF_ALLOC or section.sh_flags & p.SHF_EXECINSTR):
            continue
        owners = [symbol for symbol in elf.symtab.symbols
                  if symbol.st_shndx == index and symbol.type != p.STT_SECTION]
        if len(owners) != 1:
            continue
        owner = owners[0]
        values = rows.get(owner.name, [])
        if (owner.type != p.STT_OBJECT or owner.st_value or owner.name in held
                or len(values) != 1 or values[0][2] or not values[0][1]
                or extents.get(id(owner)) != values[0][1]
                or not values[0][1] <= len(section.data)
                or owner.st_size != len(section.data)
                or ctx.addresses.get(owner.name) != values[0][0]):
            continue
        start, size, _function = values[0]
        entries = [entry for other in elf.relocations if other.sh_info == index
                   for entry in other.relocations]
        if len({entry.r_offset for entry in entries}) != len(entries):
            continue
        for entry in entries:
            target = elf.symtab.symbols[entry.symbol_index]
            canonical = verified.get(id(target))
            if (canonical is None or entry.reloc_type != p.R_MIPS_32 or entry.r_offset % 4
                    or not 0 <= entry.r_offset <= size - 4
                    or ctx.retail.relocations.get(start + entry.r_offset) != p.R_MIPS_32
                    or struct.unpack_from('<I', section.data, entry.r_offset)[0] != 0
                    or ctx.retail.word(start + entry.r_offset) != ctx.addresses[canonical]):
                continue
            pending.setdefault(canonical, []).append(entry)
    for name, entries in pending.items():
        existing = [(index, symbol) for index, symbol in enumerate(elf.symtab.symbols)
                    if symbol.name == name]
        if (len(existing) > 1 or any(symbol.st_shndx or symbol.st_value or symbol.st_size
                                     or symbol.type not in (0, p.STT_FUNC)
                                     for _index, symbol in existing)):
            continue
        if existing:
            index = existing[0][0]
        else:
            alias = Symbol(0, 0, 0, 0x12, 0, 0)
            alias.name = name
            index = elf.add_symbol(alias)
        for entry in entries:
            entry.symbol_index = index


def prepare_native_data(elf, unit, ctx):
    """Normalize only compiler-emitted data; reservation arrays supply no credit."""
    before = code_snapshot(elf)
    placeholders = {symbol.st_shndx for symbol in elf.symtab.symbols
                    if symbol.name.endswith(layout.PLACEHOLDER_SUFFIX)
                    and 0 < symbol.st_shndx < len(elf.sections)}
    drop_sections(elf, placeholders)
    native_extents = p.native_data_extents(elf, set())
    source = Path(ctx.layout.source(unit)).read_text()
    held = fallback_data_names(source)
    function_names = [(symbol, symbol.name) for symbol in elf.symtab.symbols
                      if 0 < symbol.st_shndx < len(elf.sections)
                      and elf.sections[symbol.st_shndx].sh_flags & p.SHF_EXECINSTR]
    anonymous = p.project_native_names(elf)
    p.name_literal_data(elf, unit, set(), retail=ctx.retail, pieces=ctx.literal_pieces,
                        addresses=ctx.addresses, rows=ctx.rows, padding_pieces=ctx.pieces)
    p.materialize_alignment_fragments(elf, unit, set(), native_extents, held=held,
                                     retail=ctx.retail, pieces=ctx.pieces, rows=ctx.rows)
    for symbol in anonymous:
        if symbol.name.startswith('at_') and int(symbol.name.split('__')[0][3:]) >= 1 << 64:
            symbol.name = '.unmapped_' + symbol.name
            symbol.st_name = elf.strtab.add_symbol(symbol.name)
    p.pad_data(elf, unit, set(), retail=ctx.retail, pieces=ctx.pieces, rows=ctx.rows,
               native_extents=native_extents, held=held)
    p.bind_suffixed_references(elf, unit)
    p.pad_data(elf, unit, set(), retail=ctx.retail, pieces=ctx.pieces, rows=ctx.rows,
               native_extents=native_extents, held=held)
    renamed = p.retail_sections(elf, ctx.addresses, unit)
    own = [(lo, hi) for _name, lo, hi in ctx.layout.sections(unit)]
    for index, section in enumerate(elf.sections):
        if not section.sh_flags & p.SHF_ALLOC or section.sh_flags & p.SHF_EXECINSTR:
            continue
        named = any(symbol.st_shndx == index and symbol.type != p.STT_SECTION
                    and symbol.name in ctx.addresses
                    and any(lo <= ctx.addresses[symbol.name] < hi for lo, hi in own)
                    for symbol in elf.symtab.symbols)
        if index not in renamed or not named:
            section.name = f'.unmapped_data_{index}'
            section.sh_name = elf.add_sh_symbol(section.name)
            renamed.pop(index, None)
    for index, name in renamed.items():
        section = elf.sections[index]
        if section.sh_flags & p.SHF_EXECINSTR:
            continue
        if (name in layout.NOBITS) != (section.sh_type == p.SHT_NOBITS):
            continue
        section.name = name
        section.sh_name = elf.add_sh_symbol(name)
        section.sh_flags = p.FLAGS[name]
        section.sh_addralign = 1
    for record in elf.relocations:
        if not elf.sections[record.sh_info].sh_flags & p.SHF_EXECINSTR:
            record.name = '.rel' + elf.sections[record.sh_info].name
            record.sh_name = elf.add_sh_symbol(record.name)
    ranges = ctx.ranges(unit)
    declared = {name: size for _address, name, size, function in ctx.rows if not function and size}
    original_sizes = {id(symbol): size for symbol, size, _align, _type, _name in native_extents.values()}
    for symbol in elf.symtab.symbols:
        index = symbol.st_shndx
        if symbol.type != p.STT_OBJECT or not 0 < index < len(elf.sections):
            continue
        section = elf.sections[index]
        address = ctx.addresses.get(symbol.name)
        if (section.name not in ranges or address is None
                or original_sizes.get(id(symbol)) != declared.get(symbol.name)
                or id(symbol) not in original_sizes):
            continue
        lo, end, hi = ranges[section.name]
        if not lo <= address < end < address + p.section_size(section) <= hi:
            continue
        size = end - address
        if section.sh_type == p.SHT_NOBITS:
            section.sh_size = size
        elif not any(section.data[size:]) and not any(
                entry.r_offset >= size for record in elf.relocations if record.sh_info == index
                for entry in record.relocations):
            section.data = section.data[:size]
        else:
            continue
        symbol.st_size = min(symbol.st_size, size)
    # Order data only and retain each function's identity under the same name
    # projection objdiff already uses for template and initializer mappings.
    set_data_symbol_extents(elf, unit, ctx)
    order_data_sections(elf, ctx.addresses)
    function_identities = {id(symbol): symbol.name for symbol, _name in function_names}
    for symbol, name in function_names:
        symbol.name = p.project_name(name)
        symbol.st_name = elf.strtab.add_symbol(symbol.name)
    normalize_data_callbacks(elf, unit, ctx, function_identities, held, native_extents)
    # A retained data marker explicitly keeps that piece assembly-supplied,
    # even when the compiler happens to emit an otherwise identical copy.
    drop_sections(elf, {symbol.st_shndx for symbol in elf.symtab.symbols
                        if symbol.name in held and 0 < symbol.st_shndx < len(elf.sections)})
    if code_snapshot(elf) != before:
        raise ValueError(f'{unit}: data preparation changed code')


def fallback_data_names(source):
    """Recognize marker tokens outside comments and quoted literal contents."""
    pattern = re.compile(
        r'(?P<comment>/\*.*?\*/|//[^\n]*)|'
        r'(?P<string>(?:u8|u|U|L)?R"(?P<delimiter>[^ ()\\\t\r\n]{0,16})'
        r'\(.*?\)(?P=delimiter)"|(?:u8|u|U|L)?"(?:\\.|[^"\\])*")|'
        r"(?P<char>(?:u8|u|U|L)?'(?:\\.|[^'\\])*')|"
        r'(?P<identifier>[A-Za-z_]\w*)|(?P<punctuation>[^\s])', re.DOTALL)
    tokens = [(match.lastgroup, match.group()) for match in pattern.finditer(source)
              if match.lastgroup != 'comment']
    names = set()
    for index, (kind, token) in enumerate(tokens):
        if kind != 'identifier':
            continue
        arguments = tokens[index + 1:index + 6]
        if token == 'INCLUDE_BSS' and len(arguments) >= 3:
            if arguments[0][1] == '(' and arguments[1][0] == 'identifier' and arguments[2][1] == ',':
                names.add(arguments[1][1])
        elif token == 'INCLUDE_RODATA' and len(arguments) == 5:
            if (arguments[0][1] == '(' and arguments[1][0] == 'string'
                    and arguments[2][1] == ',' and arguments[3][0] == 'identifier'
                    and arguments[4][1] == ')' and arguments[3][1].endswith('__DATA')):
                name = arguments[3][1][:-len('__DATA')]
                if name:
                    names.add(name)
    return names


def set_data_symbol_extents(elf, unit, ctx):
    """Expose only exact native BSS objects and their canonical piece tails."""
    pieces = {name: end - start for section, run in ctx.pieces.unit(unit)
              if section in layout.NOBITS for name, start, end in run}
    declared = {name: size for _address, name, size, function in ctx.rows if not function and size}
    for symbol in elf.symtab.symbols:
        index = symbol.st_shndx
        size = declared.get(symbol.name)
        if (symbol.type != p.STT_OBJECT or symbol.st_value or size is None
                or not 0 < index < len(elf.sections)):
            continue
        section = elf.sections[index]
        extent = p.section_size(section)
        if (section.sh_type == p.SHT_NOBITS and symbol.st_size == size
                and extent >= size and extent in (size, pieces.get(symbol.name))):
            symbol.st_size = extent


def order_data_sections(elf, addresses):
    """Sort native data pieces by established identity, retaining code order."""
    starts = {symbol.st_shndx: addresses[symbol.name] - symbol.st_value
              for symbol in elf.symtab.symbols if symbol.name in addresses
              and symbol.type != p.STT_SECTION and 0 < symbol.st_shndx < len(elf.sections)}
    order = list(range(len(elf.sections)))
    for name in p.FLAGS.keys() - p.CODE:
        indices = [index for index, section in enumerate(elf.sections)
                   if section.name == name and index in starts]
        ordered = sorted(indices, key=lambda index: starts[index])
        for position, index in zip(indices, ordered):
            order[position] = index
    remap = {old: new for new, old in enumerate(order)}
    elf.sections = [elf.sections[index] for index in order]
    elf.e_shstrndx = remap[elf.e_shstrndx]
    elf.symtab_index = remap[elf.symtab_index]
    for symbol in elf.symtab.symbols:
        if symbol.st_shndx in remap:
            symbol.st_shndx = remap[symbol.st_shndx]
    for section in elf.sections:
        if section.sh_link in remap:
            section.sh_link = remap[section.sh_link]
    for record in elf.relocations:
        record.sh_info = remap[record.sh_info]


def comparison_copy(source, output, unit, ctx, native):
    """Write a separately prepared comparison without changing a raw object."""
    source = Path(source)
    output = Path(output)
    raw = source.read_bytes()
    cpp = Path(ctx.layout.source(unit)).read_bytes()
    digest = hashlib.sha256()
    for contents in (raw, ctx.fingerprint.encode(), cpp, unit.encode(), str(native).encode()):
        digest.update(len(contents).to_bytes(8, 'big'))
        digest.update(contents)
    fingerprint = digest.hexdigest()
    receipt = output.with_suffix(output.suffix + '.json')
    if output.is_file() and receipt.is_file():
        try:
            saved = json.loads(receipt.read_text())
        except (OSError, ValueError):
            saved = None
        if (isinstance(saved, dict) and saved.get('input') == fingerprint
                and saved.get('output') == hashlib.sha256(output.read_bytes()).hexdigest()):
            return
    elf = p.Elf(raw)
    p.name_sections(elf)
    before = code_snapshot(elf)
    if native:
        prepare_native_data(elf, unit, ctx)
    else:
        restore_reference_data(elf, unit, ctx)
    if code_snapshot(elf) != before:
        raise ValueError(f'{unit}: comparison preparation changed code')
    output.parent.mkdir(parents=True, exist_ok=True)
    data = elf.pack()
    if not output.is_file() or output.read_bytes() != data:
        output.write_bytes(data)
    receipt.write_text(json.dumps({'input': fingerprint, 'output': hashlib.sha256(data).hexdigest()},
                                  indent=2) + '\n')
