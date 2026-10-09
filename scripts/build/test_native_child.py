"""A discarded assembly-backed parent cannot discard a migrated native child."""

import struct
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import postprocess_object as p
from test_literal_data import symbol, relocation


class NativeChildTests(unittest.TestCase):
    def fixture(self, retained_child=False):
        sections = [NS(name='', sh_flags=0),
                    NS(name='.text', sh_flags=6, sh_name=0, sh_type=1,
                       data=struct.pack('<I', 0x27820000)),
                    NS(name='.data', sh_flags=2, sh_name=0, sh_type=1, data=bytes(4)),
                    NS(name='.rodata', sh_flags=2, sh_name=0, sh_type=1, data=b'X\0'),
                    NS(name='.data', sh_flags=2, sh_name=0, sh_type=1, data=bytes(4))]
        syms = [symbol('caller', 1, 4, bind=1, kind=p.STT_FUNC), symbol('at_99', 2, 4),
                symbol('at_98', 3, 2), symbol('table', 4, 4, bind=1)]
        held = {4}
        if retained_child:
            sections.append(NS(name='.rodata', sh_flags=2, sh_name=0, sh_type=1, data=b'X\0' + bytes(6)))
            syms.append(symbol('literal', 5, 8, bind=1))
            held.add(5)
        code_ref = relocation(0, p.R_MIPS_GPREL16, 1)
        elf = NS(sections=sections, symtab=NS(symbols=syms), add_sh_symbol=lambda name: len(name),
                 relocations=[NS(sh_info=1, sh_name=0, name='.rel.text', relocations=[code_ref]),
                              NS(sh_info=2, sh_name=0, name='.rel.data',
                                 relocations=[relocation(0, p.R_MIPS_32, 2)])])
        lay = NS(kinds={'unit': 'cpp'}, sections=lambda unit: [('.text', 0x1000, 0x1004),
                  ('.data', 0x3000, 0x3004), ('.rodata', 0x4000, 0x4008)])
        rows = [(0x2000, '_gp', 0, False), (0x1000, 'caller', 4, True),
                (0x3000, 'table', 4, False), (0x4000, 'literal', 2, False)]
        retail = NS(word={0x1000: 0x27821000, 0x3000: 0x4000}.__getitem__,
                    bytes=lambda lo, hi: (struct.pack('<I', 0x4000)[lo - 0x3000:hi - 0x3000]
                                         if lo < 0x4000 else (b'X\0' + bytes(6))[lo - 0x4000:hi - 0x4000]))
        return elf, held, lay, rows, retail

    def apply(self, fixture):
        elf, held, lay, rows, retail = fixture
        retail.relocations = {0x1000 + entry.r_offset: entry.reloc_type
                              for record in elf.relocations if record.sh_info == 1
                              for entry in record.relocations}
        retail.relocations.update({0x3000 + entry.r_offset: entry.reloc_type
                                   for record in elf.relocations if record.sh_info == 2
                                   for entry in record.relocations})
        with patch.object(p.layout, 'Layout', return_value=lay), \
             patch.object(p.layout, 'read_symbols', return_value=rows), \
             patch.object(p.layout, 'Retail', return_value=retail), \
             patch.object(p, 'rename_shared_names'):
            return p.bind_local_data(elf, 'unit', held)

    def test_signed_low_half_preserves_the_original_pair_and_exact_placeholder(self):
        fixture = self.fixture()
        elf, held, lay, rows, retail = fixture
        elf.sections[2].sh_type = p.SHT_NOBITS
        elf.sections[2].sh_size = 0xabf0
        elf.sections[2].data = b''
        elf.symtab.symbols[1].st_size = 0xabf0
        elf.sections.append(NS(name='.bss', sh_flags=2, sh_name=0,
                               sh_type=p.SHT_NOBITS, sh_size=0xabf0, data=b''))
        elf.symtab.symbols.append(symbol('array', 5, 0xabf0, bind=1))
        held.add(5)
        rows[2] = (0xebf0, 'table', 4, False)
        rows.append((0x4000, 'array', 0xabf0, False))
        lay.sections = lambda unit: [('.text', 0x1000, 0x1008), ('.bss', 0x4000, 0xebf4)]
        elf.sections[1].data = struct.pack('<II', 0x3c020001, 0x2442abf0)
        elf.relocations = [NS(sh_info=1, sh_name=0, name='.rel.text', relocations=[
            relocation(0, p.R_MIPS_HI16, 1), relocation(4, p.R_MIPS_LO16, 1)])]
        retail.word = {0x1000: 0x3c020001, 0x1004: 0x2442ebf0}.__getitem__
        self.assertEqual(self.apply(fixture), ['at_99'])
        self.assertEqual(elf.sections[1].data, struct.pack('<II', 0x3c020001, 0x2442abf0))
        self.assertEqual([ref.symbol_index for ref in elf.relocations[0].relocations], [4, 4])

    def test_negative_addend_can_bind_to_the_tables_own_placeholder(self):
        for kind in ('gp', 'hi_lo'):
            with self.subTest(kind=kind):
                fixture = self.fixture()
                elf, held, lay, rows, retail = fixture
                elf.sections[2].data = bytes(20)
                elf.symtab.symbols[1].st_size = 20
                elf.symtab.symbols[1].name = 'offset_99'
                elf.sections.append(NS(name='.data', sh_flags=2, sh_name=0,
                                       sh_type=1, data=bytes(20)))
                elf.symtab.symbols.append(symbol('offset', 5, 20, bind=1))
                held.add(5)
                rows.append((0x3004, 'offset', 20, False))
                lay.sections = lambda unit: [('.text', 0x1000, 0x1008), ('.data', 0x3000, 0x3018)]
                if kind == 'gp':
                    code = struct.pack('<I', 0x2782fffc)
                    refs = [relocation(0, p.R_MIPS_GPREL16, 1)]
                    retail.word = lambda address: 0x27821000
                else:
                    code = struct.pack('<II', 0x3c020000, 0x2442fffc)
                    refs = [relocation(0, p.R_MIPS_HI16, 1), relocation(4, p.R_MIPS_LO16, 1)]
                    retail.word = {0x1000: 0x3c020000, 0x1004: 0x24423000}.__getitem__
                elf.sections[1].data = code
                elf.relocations = [NS(sh_info=1, sh_name=0, name='.rel.text', relocations=refs)]
                retail.bytes = lambda lo, hi: bytes(hi - lo)
                self.assertEqual(self.apply(fixture), ['offset_99'])
                self.assertEqual(elf.sections[1].data, code)
                self.assertTrue(all(ref.symbol_index == 4 for ref in refs))

    def test_negative_addend_does_not_bind_table_to_preceding_placeholder(self):
        for kind in ('gp', 'hi_lo'):
            with self.subTest(kind=kind):
                fixture = self.fixture()
                elf, held, _lay, _rows, retail = fixture
                elf.sections[2].data = bytes(20)
                elf.symtab.symbols[1].st_size = 20
                elf.symtab.symbols[1].name = 'offset_99'
                elf.relocations = elf.relocations[:1]
                if kind == 'gp':
                    code = struct.pack('<I', 0x2782fffc)
                    retail.word = lambda address: 0x27821000
                else:
                    code = struct.pack('<II', 0x3c020000, 0x2442fffc)
                    elf.relocations[0].relocations = [relocation(0, p.R_MIPS_HI16, 1),
                                                     relocation(4, p.R_MIPS_LO16, 1)]
                    retail.word = {0x1000: 0x3c020000, 0x1004: 0x24423000}.__getitem__
                elf.sections[1].data = code
                retail.bytes = lambda lo, hi: bytes(hi - lo)
                self.assertEqual(self.apply(fixture), [])
                self.assertEqual(elf.sections[2].name, '.data')
                self.assertEqual(elf.sections[1].data, code)
                self.assertTrue(all(ref.symbol_index == 1 for ref in elf.relocations[0].relocations))

    def test_bad_child_payload_prevents_discarding_the_parent(self):
        fixture = self.fixture(retained_child=True)
        fixture[0].sections[3].data = b'Y\0'
        code = fixture[0].sections[1].data
        self.assertEqual(self.apply(fixture), [])
        self.assertEqual(fixture[0].sections[1].data, code)
        self.assertEqual(fixture[0].sections[2].name, '.data')
        self.assertEqual(fixture[0].sections[3].name, '.rodata')

    def test_native_child_without_marker_survives_discarded_parent(self):
        fixture = self.fixture()
        self.assertEqual(self.apply(fixture), ['at_99'])
        self.assertEqual(fixture[0].sections[2].name, p.DEAD)
        self.assertEqual(fixture[0].sections[3].name, '.rodata')
        self.assertEqual(fixture[0].sections[3].data, b'X\0')

    def test_child_with_retained_placeholder_still_discards_compiler_copy(self):
        fixture = self.fixture(retained_child=True)
        self.assertEqual(self.apply(fixture), ['at_99', 'at_98'])
        self.assertEqual(fixture[0].sections[3].name, p.DEAD)


if __name__ == '__main__':
    unittest.main()
