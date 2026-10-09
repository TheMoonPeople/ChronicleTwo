"""Data comparison must honor retail relocations and exclude fallback storage."""

import struct
from pathlib import Path
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import objdiff_data as d
from mwccgap.elf import Relocation, RelocationRecord, Symbol


def symbol(name, index=0, size=0, value=0, info=0x10):
    entry = Symbol(0, value, size, info, 0, index)
    entry.name = name
    return entry


def elf(sections, symbols, records=()):
    table = NS(symbols=symbols)
    table.get_symbol_by_name = lambda name: next(
        ((index, entry) for index, entry in enumerate(symbols) if entry.name == name), (None, None))
    result = NS(sections=sections, symtab=table, relocations=list(records), symtab_index=0,
                strtab=NS(add_symbol=lambda name: len(name)), add_sh_symbol=lambda name: len(name))

    def add_symbol(entry):
        index, _existing = table.get_symbol_by_name(entry.name)
        if index is None:
            index = len(symbols)
            symbols.append(entry)
        return index

    def add_section(section):
        sections.append(section)
        if isinstance(section, RelocationRecord):
            result.relocations.append(section)
        return len(sections) - 1

    result.add_symbol, result.add_section = add_symbol, add_section
    return result


def record(index, entries):
    result = RelocationRecord(0, 9, 0, 0, 0, 0, 0, index, 4, 8, b'')
    result.relocations = [Relocation(offset, (target << 8) | kind) for offset, kind, target in entries]
    return result


class ReferenceDataTests(unittest.TestCase):
    def fixture(self):
        symbols = [symbol('packed_short_guess'), symbol('real_pointer')]
        record = RelocationRecord(0, 9, 0, 0, 0, 0, 4, 1, 4, 8, b'')
        record.relocations = [Relocation(0, 2), Relocation(4, (1 << 8) | 2)]
        words = {0x3000: 0x00080000, 0x3004: 0x4004, 0x3008: 0x12345678}
        contents = b''.join(struct.pack('<I', words[addr]) for addr in sorted(words)) + bytes(4)
        section = NS(name='.data', sh_type=1, sh_flags=2, data=bytes(16), sh_size=16)
        table = NS(symbols=symbols, get_symbol_by_name=lambda name: next(
            ((i, s) for i, s in enumerate(symbols) if s.name == name), (None, None)))
        elf = NS(sections=[NS(name='', sh_flags=0), section], relocations=[record],
                 symtab=table, symtab_index=4, add_sh_symbol=lambda name: 1)

        def add_symbol(entry):
            found = table.get_symbol_by_name(entry.name)[0]
            if found is not None:
                return found
            symbols.append(entry)
            return len(symbols) - 1

        elf.add_symbol = add_symbol
        ctx = NS(ranges=lambda unit: {'.data': (0x3000, 0x300c, 0x3010)},
                 layout=NS(sections=lambda unit: [('.data', 0x3000, 0x3010)]),
                 pieces=NS(unit=lambda unit: []),
                 addresses={'packed_short_guess': 0x80000, 'real_pointer': 0x4000}, rows=[],
                 resolve=NS(addresses=[0x4000], names=['real_pointer']),
                 retail=NS(bytes=lambda lo, hi: contents[lo - 0x3000:hi - 0x3000],
                           word=words.__getitem__, relocations={0x3004: 2}))
        return elf, ctx

    def test_packed_shorts_do_not_fabricate_pointer_relocations(self):
        elf, ctx = self.fixture()
        d.restore_reference_data(elf, 'unit', ctx)
        self.assertEqual([(r.r_offset, r.reloc_type) for r in elf.relocations[0].relocations], [(4, 2)])
        self.assertEqual(elf.sections[1].data,
                         struct.pack('<III', 0x00080000, 4, 0x12345678))

    def test_missing_real_relocation_is_restored_from_metadata(self):
        elf, ctx = self.fixture()
        elf.relocations[0].relocations.pop()
        d.restore_reference_data(elf, 'unit', ctx)
        self.assertEqual([(r.r_offset, r.symbol_index) for r in elf.relocations[0].relocations], [(4, 1)])

    def test_nonzero_linker_tail_cannot_be_ignored(self):
        elf, ctx = self.fixture()
        ctx.retail.bytes = lambda lo, hi: b'\1' * (hi - lo)
        with self.assertRaisesRegex(ValueError, 'non-padding'):
            d.restore_reference_data(elf, 'unit', ctx)

    def test_relocated_linker_tail_cannot_be_ignored(self):
        elf, ctx = self.fixture()
        ctx.retail.relocations[0x300c] = 2
        with self.assertRaisesRegex(ValueError, 'non-padding'):
            d.restore_reference_data(elf, 'unit', ctx)

    def test_unexpected_reference_extent_is_rejected(self):
        elf, ctx = self.fixture()
        elf.sections[1].data = bytes(15)
        with self.assertRaisesRegex(ValueError, 'extent'):
            d.restore_reference_data(elf, 'unit', ctx)

    def test_unknown_real_pointer_target_is_rejected(self):
        elf, ctx = self.fixture()
        ctx.addresses.pop('real_pointer')
        with self.assertRaisesRegex(ValueError, 'unknown'):
            d.restore_reference_data(elf, 'unit', ctx)

    def test_only_true_switch_relocation_uses_function_and_addend(self):
        elf, ctx = self.fixture()
        elf.symtab.symbols.append(symbol('function', 0, 32))
        ctx.rows = [(0x4000, 'function', 32, True)]
        ctx.addresses['function'] = 0x4000
        d.restore_reference_data(elf, 'unit', ctx)
        self.assertEqual(elf.relocations[0].relocations[0].symbol_index, 2)
        self.assertEqual(struct.unpack_from('<I', elf.sections[1].data, 4)[0], 4)

    def test_inferred_padding_label_is_not_a_data_object(self):
        elf, ctx = self.fixture()
        elf.symtab.symbols.append(symbol('object', 1, value=0))
        elf.symtab.symbols.append(symbol('D_00003008', 1, value=8))
        ctx.pieces.unit = lambda unit: [('.data', [('object', 0x3000, 0x3010)])]
        d.set_reference_data_symbols(elf, 'unit', ctx)
        self.assertEqual(elf.symtab.symbols[2].st_size, 12)
        self.assertEqual(elf.symtab.symbols[3].st_shndx, 0)

    def test_real_referenced_interior_boundary_is_preserved(self):
        elf, ctx = self.fixture()
        elf.symtab.symbols.append(symbol('object', 1, value=0))
        elf.symtab.symbols.append(symbol('D_00003008', 1, value=8))
        ctx.pieces.unit = lambda unit: [('.data', [('object', 0x3000, 0x3008),
                                                  ('D_00003008', 0x3008, 0x3010)])]
        d.set_reference_data_symbols(elf, 'unit', ctx)
        self.assertEqual(elf.symtab.symbols[2].st_size, 8)
        self.assertEqual(elf.symtab.symbols[3].st_size, 4)
        self.assertEqual(elf.symtab.symbols[3].st_shndx, 1)


class NativeStorageTests(unittest.TestCase):
    def test_compiler_constructor_record_gets_its_verified_identity(self):
        sections = [NS(name='', sh_flags=0, sh_link=0),
                    NS(name='.ctor', sh_flags=2, sh_link=0, sh_type=1, data=bytes(4)),
                    NS(name='.init', sh_flags=6, sh_link=0, sh_type=1, data=bytes(8)),
                    NS(name='', sh_flags=0, sh_link=0)]
        syms = [symbol('.p__sinit_test.cpp', 1, 4, info=1),
                symbol('__sinit_test.cpp', 2, 8, info=0x12)]
        record = RelocationRecord(0, 9, 0, 0, 0, 0, 3, 1, 4, 8, b'')
        record.relocations = [Relocation(0, (1 << 8) | 2)]
        record.name = '.rel.ctor'
        sections.append(record)
        elf = NS(sections=sections, symtab=NS(symbols=syms), relocations=[record],
                 e_shstrndx=3, symtab_index=3, strtab=NS(add_symbol=lambda name: 1),
                 add_sh_symbol=lambda name: 1)
        runs = [('.init', [('__sinit_test_cpp', 0x1000, 0x1008)]),
                ('.ctor', [('D_00003000', 0x3000, 0x3004)])]
        addresses = {'__sinit_test_cpp': 0x1000, 'D_00003000': 0x3000}
        rows = [(0x1000, '__sinit_test_cpp', 8, True)]
        ranges = [('.init', 0x1000, 0x1008), ('.ctor', 0x3000, 0x3004)]
        lay = NS(kinds={'unit': 'cpp'}, sections=lambda unit: ranges)
        pieces = NS(layout=lay, unit=lambda unit: runs)
        retail = NS(relocations={0x3000: 2},
                    bytes=lambda lo, hi: struct.pack('<I', 0x1000)[:hi - lo])
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / 'unit.cpp'
            source.write_text('')
            lay.source = lambda unit: source
            ctx = NS(layout=lay, addresses=addresses, rows=rows, retail=retail,
                     pieces=pieces, literal_pieces=pieces,
                     ranges=lambda unit: {'.ctor': (0x3000, 0x3004, 0x3004)})
            with patch.object(d.p.layout, 'Retail', return_value=retail), \
                 patch.object(d.p.layout, 'Layout', return_value=lay), \
                 patch.object(d.p.layout, 'read_symbols', return_value=rows), \
                 patch.object(d.p.layout, 'section_of', side_effect=lambda address:
                              '.init' if address < 0x3000 else '.ctor'), \
                 patch.object(d.p.disassemble, 'Pieces', return_value=pieces), \
                 patch.object(d.p, 'retail_addresses', return_value=addresses):
                d.prepare_native_data(elf, 'unit', ctx)
        self.assertEqual(syms[0].name, 'D_00003000')
        self.assertEqual(sections[1].name, '.ctor')

    def test_data_markers_exclude_retained_payloads_only(self):
        source = '''
INCLUDE_BSS(buffer, 0x20);
INCLUDE_RODATA("dir", at_17__2__DATA);
INCLUDE_ASM("dir", function);
// INCLUDE_BSS(ignored, 4);
/* INCLUDE_RODATA("dir", other__DATA); */
'''
        self.assertEqual(d.fallback_data_names(source), {'buffer', 'at_17__2'})

    def test_literal_comment_delimiter_does_not_hide_real_markers(self):
        self.assertEqual(d.fallback_data_names('print("//"); INCLUDE_BSS(buffer, 4);'), {'buffer'})

    def test_marker_identifiers_inside_literals_are_ignored(self):
        source = r'''print("INCLUDE_BSS(fake, 4);");
print("escaped \" INCLUDE_BSS(escaped, 4); ");
'INCLUDE_BSS(character, 4);';
L"INCLUDE_BSS(wide, 4);";
R"tag(INCLUDE_BSS(raw, 4); "quote")tag";
INCLUDE_BSS(real, 4); INCLUDE_RODATA("dir", real_literal__DATA);
'''
        self.assertEqual(d.fallback_data_names(source), {'real', 'real_literal'})

    def test_comments_and_filename_literals_preserve_real_marker_tokens(self):
        source = r'''INCLUDE_BSS /* note */ (buffer, 4);
INCLUDE_RODATA("dir/INCLUDE_BSS(fake, 4);", value__DATA);
INCLUDE_RODATA /* note */ ("dir\"quoted", other__DATA);
INCLUDE /* separated identifier */ _BSS(ignored, 4);
// INCLUDE_BSS(comment, 4);
/* INCLUDE_RODATA("dir", comment_literal__DATA); */
'''
        self.assertEqual(d.fallback_data_names(source), {'buffer', 'value', 'other'})

    def test_reservation_section_is_removed_and_reference_stays_undefined(self):
        data = NS(sh_flags=2, sh_link=0)
        code = NS(sh_flags=6, sh_link=0, data=bytes(8))
        section = NS(sh_flags=0, sh_link=0)
        sym = symbol('reservation__DATA', 1, 8, info=0x11)
        elf = NS(sections=[section, data, code, section, section],
                 symtab=NS(symbols=[sym]), relocations=[], e_shstrndx=4, symtab_index=3)
        d.drop_sections(elf, {1})
        self.assertEqual(len(elf.sections), 4)
        self.assertEqual((sym.st_shndx, sym.st_value, sym.st_size), (0, 0, 0))
        self.assertIs(elf.sections[1], code)
        self.assertEqual(code.data, bytes(8))

    def test_code_cannot_be_removed_as_placeholder_data(self):
        elf = NS(sections=[NS(sh_flags=6)])
        with self.assertRaisesRegex(ValueError, 'executable'):
            d.drop_sections(elf, {0})

    def test_bss_padding_is_visible_only_for_exact_declared_object(self):
        for declared, native, extent, expected in ((20, 20, 32, 32), (20, 19, 32, 19),
                                                    (20, 20, 36, 20), (20, 20, 19, 20), (4, 4, 52, 52)):
            with self.subTest(native=native, extent=extent):
                sym = symbol('object', 1, native, info=1)
                elf = NS(sections=[None, NS(sh_type=d.p.SHT_NOBITS, sh_size=extent)],
                         symtab=NS(symbols=[sym]))
                piece_size = 52 if declared == 4 else 32
                ctx = NS(rows=[(0x3000, 'object', declared, False)],
                         pieces=NS(unit=lambda unit: [('.sbss', [('object', 0x3000,
                                                                 0x3000 + piece_size)])]))
                d.set_data_symbol_extents(elf, 'unit', ctx)
                self.assertEqual(sym.st_size, expected)


if __name__ == '__main__':
    unittest.main()
