"""Vtable copies must supply the entire declared retail object before discarding."""

import struct
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch
import postprocess_object as p
from test_literal_data import symbol, relocation


class VtableExtentTests(unittest.TestCase):
    def fixture(self, size=16, held=False):
        name = '__vt__5Thing'
        native = NS(name='.vtables', sh_type=1, sh_flags=3, sh_name=0, data=bytes(size))
        held_section = NS(name='.data', sh_type=1, sh_flags=3, sh_name=0, data=bytes(16))
        syms = [symbol(name, 1, size)]
        sections = [NS(name='', sh_flags=0), native]
        if held:
            sections.append(held_section)
            syms.append(symbol(name, 2, 16))
        elf = NS(sections=sections, symtab=NS(symbols=syms), relocations=[],
                 add_sh_symbol=lambda name: len(name))
        rows = [(0x3000, name, 16, False)]
        lay = NS(sections=lambda unit: [('.text', 0x1000, 0x1100)])
        retail = NS(bytes=lambda lo, hi: bytes(hi-lo), relocations={})
        return elf, rows, lay, retail

    def apply(self, fx, held=False, native_sizes=None):
        elf, rows, lay, retail = fx
        with patch.object(p.layout, 'Layout', return_value=lay), \
             patch.object(p.layout, 'read_symbols', return_value=rows), \
             patch.object(p, 'retail_addresses', return_value={row[1]:row[0] for row in rows}), \
             patch.object(p.layout, 'Retail', return_value=retail):
            if held:
                if native_sizes is None:
                    p.discard_shadow_vtables(elf, {2})
                else:
                    p.discard_shadow_vtables(elf, {2}, native_sizes=native_sizes)
            else:
                p.discard_external_vtables(elf, 'unit', set())

    def test_short_external_vtable_is_rejected_even_with_zero_retail_suffix(self):
        fx = self.fixture(size=12)
        with self.assertRaisesRegex(ValueError, 'extent'):
            self.apply(fx)
        self.assertNotEqual(fx[0].sections[1].name, p.DEAD)
        self.assertEqual(fx[0].symtab.symbols[0].st_shndx, 1)

    def test_short_shadow_vtable_is_rejected_even_with_zero_retail_suffix(self):
        fx = self.fixture(size=12, held=True)
        with self.assertRaisesRegex(ValueError, 'extent'):
            self.apply(fx, held=True)
        self.assertNotEqual(fx[0].sections[1].name, p.DEAD)

    def test_exact_declared_external_and_shadow_vtables_are_discarded(self):
        for held in (False, True):
            with self.subTest(held=held):
                fx = self.fixture(held=held)
                self.apply(fx, held=held)
                self.assertEqual(fx[0].sections[1].name, p.DEAD)

    def test_missing_declared_vtable_extent_is_rejected(self):
        for held in (False, True):
            with self.subTest(held=held):
                fx = self.fixture(held=held)
                fx[1][0] = (0x3000, '__vt__5Thing', 0, False)
                with self.assertRaisesRegex(ValueError, 'extent'):
                    self.apply(fx, held=held)

    def test_padding_cannot_repair_an_originally_short_shadow_vtable(self):
        fx = self.fixture(held=True)
        native_sizes = {id(fx[0].symtab.symbols[0]):12}
        with self.assertRaisesRegex(ValueError, 'extent'):
            self.apply(fx, held=True, native_sizes=native_sizes)

    def test_exact_original_shadow_vtable_may_retain_verified_piece_padding(self):
        fx = self.fixture(held=True)
        owner = fx[0].symtab.symbols[0]
        owner.st_size = 24
        fx[0].sections[1].data = fx[0].sections[2].data = bytes(24)
        self.apply(fx, held=True, native_sizes={id(owner):16})
        self.assertEqual(fx[0].sections[1].name, p.DEAD)

    def relocated_fixture(self, held=False):
        fx = self.fixture(held=held)
        elf, rows, _lay, retail = fx
        method = len(elf.symtab.symbols)
        elf.symtab.symbols.append(symbol('method', 0, bind=1, kind=p.STT_FUNC))
        rows.append((0x4000, 'method', 4, True))
        image = struct.pack('<I', 0x4000) + bytes(12)
        retail.bytes = lambda lo, hi: image[lo - 0x3000:hi - 0x3000]
        retail.relocations[0x3000] = p.R_MIPS_32
        elf.relocations = [NS(sh_info=index, sh_name=0, name='.rel.vtables',
                             relocations=[relocation(0, p.R_MIPS_32, method)])
                           for index in ((1, 2) if held else (1,))]
        return fx

    def test_complete_relocated_external_vtable_is_discarded(self):
        fx = self.relocated_fixture()
        self.apply(fx)
        self.assertEqual(fx[0].sections[1].name, p.DEAD)

    def test_external_relocation_shape_must_match_retail(self):
        for invalid in ('missing_native', 'missing_retail', 'kind', 'duplicate'):
            with self.subTest(invalid=invalid):
                fx = self.relocated_fixture()
                elf, _rows, _lay, retail = fx
                if invalid == 'missing_native':
                    elf.sections[1].data = struct.pack('<I', 0x4000) + bytes(12)
                    elf.relocations.clear()
                elif invalid == 'missing_retail':
                    retail.relocations.clear()
                elif invalid == 'kind':
                    retail.relocations[0x3000] = p.R_MIPS_26
                else:
                    # Applying both native entries yields the retail word, so
                    # a byte-only verifier misses this extra relocation site.
                    elf.sections[1].data = struct.pack('<I', 0xFFFFC000) + bytes(12)
                    elf.relocations[0].relocations.append(relocation(0, p.R_MIPS_32, 1))
                with self.assertRaisesRegex(ValueError, 'relocation shape'):
                    self.apply(fx)
                self.assertNotEqual(elf.sections[1].name, p.DEAD)

    def test_shadow_relocation_sites_must_be_unique_on_both_sides(self):
        for record_index in (0, 1):
            with self.subTest(record_index=record_index):
                fx = self.relocated_fixture(held=True)
                fx[0].relocations[record_index].relocations.append(relocation(0, p.R_MIPS_32, 2))
                with self.assertRaisesRegex(ValueError, 'duplicate vtable relocation'):
                    self.apply(fx, held=True)
                self.assertNotEqual(fx[0].sections[1].name, p.DEAD)

    def test_shadow_relocation_cannot_occupy_verified_piece_padding(self):
        fx = self.relocated_fixture(held=True)
        elf = fx[0]
        owner = elf.symtab.symbols[0]
        owner.st_size = 24
        elf.sections[1].data = elf.sections[2].data = bytes(24)
        for record in elf.relocations:
            record.relocations[0].r_offset = 20
        with self.assertRaisesRegex(ValueError, 'vtable relocation site'):
            self.apply(fx, held=True, native_sizes={id(owner): 16})
        self.assertNotEqual(elf.sections[1].name, p.DEAD)
