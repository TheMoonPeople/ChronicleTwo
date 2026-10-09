"""Literal padding cannot manufacture a missing declared object payload."""

from pathlib import Path
import struct
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import check_objects as c
import postprocess_object as p
import test_literal_data as fixtures


class LiteralExtentTests(unittest.TestCase):
    def fixture(self, native=1, declared=1, gap=7, terminal=False):
        elf, pieces, retail, rows = fixtures.LiteralPointerTests().fixture()
        start = 0x3020
        end = start + max(native, declared) + gap
        runs = [('.rodata', [('at_1', 0x3000, start), ('at_2', start, end)]),
                ('.data', [('table', 0x4000, 0x4004)])]
        if not terminal:
            runs[0][1].append(('at_3', end, end + 8))
        pieces.unit = lambda unit: runs
        pieces.layout.sections = lambda unit: [('.rodata', 0x3000, end + (0 if terminal else 8))]
        elf.sections[1].data = bytes(native)
        elf.symtab.symbols[0].st_size = native
        rows[:] = [(0x3000, 'at_1', declared, False), (start, 'at_2', declared, False),
                   (0x4000, 'table', 4, False)]
        retail.word = lambda address: start
        return elf, pieces, retail, rows

    def apply(self, fixture):
        elf, pieces, retail, rows = fixture
        p.name_literal_data(elf, 'unit', set(), retail=retail, pieces=pieces,
                            addresses={'table': 0x4000}, rows=rows)
        return elf.symtab.symbols[0].name

    def test_reference_boundary_limits_padding_without_changing_identity(self):
        fixture = self.fixture(native=8, declared=8, gap=8)
        elf, pieces, retail, rows = fixture
        start = 0x3020
        canonical = NS(unit=lambda unit: [('.rodata', [
            ('at_1', 0x3000, start), ('at_2', start, start + 12),
            ('D_0000302C', start + 12, start + 16)])])
        p.name_literal_data(elf, 'unit', set(), retail=retail, pieces=pieces,
                            padding_pieces=canonical, addresses={'table': 0x4000}, rows=rows)
        self.assertEqual(elf.symtab.symbols[0].name, 'at_2')
        self.assertEqual(len(elf.sections[1].data), 12)
        self.assertEqual(elf.symtab.symbols[0].st_size, 12)

    def test_boundary_inside_declared_payload_rejects_literal(self):
        fixture = self.fixture(native=8, declared=8, gap=8)
        elf, pieces, retail, rows = fixture
        canonical = NS(unit=lambda unit: [('.rodata', [('at_2', 0x3020, 0x3024)])])
        p.name_literal_data(elf, 'unit', set(), retail=retail, pieces=pieces,
                            padding_pieces=canonical, addresses={'table': 0x4000}, rows=rows)
        self.assertEqual(elf.symtab.symbols[0].name, 'at_999')
        self.assertEqual(len(elf.sections[1].data), 8)

    def test_exact_declared_empty_string_owns_internal_eight_byte_piece(self):
        fixture = self.fixture()
        self.assertEqual(self.apply(fixture), 'at_2')
        self.assertEqual(fixture[0].sections[1].data, bytes(8))

    def test_under_and_oversized_payloads_are_not_named_or_padded(self):
        for native, declared in ((1, 32), (2, 1), (31, 32), (33, 32)):
            with self.subTest(native=native, declared=declared):
                fixture = self.fixture(native, declared)
                self.assertEqual(self.apply(fixture), 'at_999')
                self.assertEqual(fixture[0].sections[1].data, bytes(native))
                self.assertEqual(fixture[0].symtab.symbols[0].st_size, native)

    def test_symbol_extent_must_describe_the_original_payload(self):
        fixture = self.fixture()
        fixture[0].symtab.symbols[0].st_size = 2
        self.assertEqual(self.apply(fixture), 'at_999')

    def test_alignment_cannot_contain_a_retail_relocation(self):
        fixture = self.fixture()
        fixture[2].relocations[0x3024] = p.R_MIPS_32
        self.assertEqual(self.apply(fixture), 'at_999')
        self.assertEqual(fixture[0].sections[1].data, bytes(1))

    def test_large_internal_zero_gap_is_not_alignment(self):
        fixture = self.fixture(gap=31)
        self.assertEqual(self.apply(fixture), 'at_999')

    def test_terminal_zero_tail_beyond_the_run_bound_stays_unnamed(self):
        fixture = self.fixture(gap=1023, terminal=True)
        self.assertEqual(self.apply(fixture), 'at_999')
        self.assertEqual(fixture[0].sections[1].data, bytes(1))
        self.assertEqual(fixture[0].symtab.symbols[0].st_size, 1)

    def test_terminal_padding_is_bounded_by_the_following_address_and_cap(self):
        for native, gap, accepted in ((1, 7, True), (97, 127, True),
                                      (96, 128, False), (1, 39, False)):
            with self.subTest(native=native, gap=gap):
                fixture = self.fixture(native=native, declared=native, gap=gap, terminal=True)
                self.assertEqual(self.apply(fixture), 'at_2' if accepted else 'at_999')
                self.assertEqual(len(fixture[0].sections[1].data),
                                 native + gap if accepted else native)

    def test_terminal_tail_stops_at_a_real_reference_only_cut(self):
        fixture = self.fixture(native=8, declared=8, gap=1024, terminal=True)
        elf, pieces, retail, rows = fixture
        symbols = NS(rows=rows, within=lambda lo, hi: [row for row in rows if lo <= row[0] < hi])
        canonical = p.disassemble.Pieces(lay=pieces.layout, symbols=symbols, references=[0x302c])
        p.name_literal_data(elf, 'unit', set(), retail=retail, pieces=pieces,
                            padding_pieces=canonical, addresses={'table': 0x4000}, rows=rows)
        self.assertEqual(elf.symtab.symbols[0].name, 'at_2')
        self.assertEqual(len(elf.sections[1].data), 12)
        self.assertEqual(canonical.unit('unit')[0][1][-1][0], 'D_0000302C')

    def test_terminal_tail_with_relocation_is_not_synthesized(self):
        fixture = self.fixture(gap=1023, terminal=True)
        fixture[2].relocations[0x3024] = p.R_MIPS_32
        self.assertEqual(self.apply(fixture), 'at_999')
        self.assertEqual(fixture[0].sections[1].data, bytes(1))

    def test_undersized_zero_literal_cannot_pass_complete_object_check(self):
        fixture = self.fixture(native=1, declared=32, gap=0, terminal=True)
        elf, pieces, retail, _rows = fixture
        self.apply(fixture)
        original = elf.sections[1]
        elf.sections[1] = NS(name='.rodata', sh_type=1, data=bytes(32))
        elf.sections.append(original)
        elf.symtab.symbols[0].st_shndx = 3
        elf.symtab.symbols.append(fixtures.symbol('at_1', 1, 32))
        elf.sections[0] = NS(name='', sh_type=0, sh_flags=0, sh_addralign=0, data=b'')
        for section in elf.sections[1:]:
            section.sh_flags = c.SHF_ALLOC
            section.sh_addralign = 1
        retail.bytes = lambda lo, hi: struct.pack('<I', 0x3020) if lo == 0x4000 else bytes(hi - lo)
        runs = dict(pieces.unit('unit'))
        ctx = NS(obj_dir=Path('/unused'), linker=NS(contents_end=lambda unit, lo, hi: hi),
                 layout=NS(sections=lambda unit: [('.rodata', 0x3000, 0x3040),
                                                   ('.data', 0x4000, 0x4004)]),
                 pieces=NS(of=lambda unit, kind, lo, hi: runs[kind],
                           symbols=NS(by_name={})), retail=retail,
                 address_of={'at_1': 0x3000, 'at_2': 0x3020, 'table': 0x4000}.get)
        with patch.object(c.Path, 'is_file', return_value=True), \
             patch.object(c.Path, 'read_bytes', return_value=b''), \
             patch.object(c, 'Elf', return_value=elf), patch.object(c, 'name_sections'):
            errors, _bytes, _relocations = c.check_unit(ctx, 'unit', False)
        self.assertTrue(errors, 'Undersized native storage must not become a complete retail object')


if __name__ == '__main__':
    unittest.main()
