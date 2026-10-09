"""Non-owning weak bodies must expose failed byte, extent and call-target proofs."""

from contextlib import redirect_stderr
from io import StringIO
import struct
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch
import postprocess_object as p
from test_literal_data import symbol, relocation


class ExternalFunctionTests(unittest.TestCase):
    def fixture(self, native=0x24020001, relocated=False):
        section = NS(name='.text', sh_type=1, sh_flags=6, sh_name=0,
                     data=struct.pack('<I', native))
        syms = [symbol('external__Fv', 1, 4, kind=p.STT_FUNC, bind=p.STB_WEAK)]
        elf = NS(sections=[NS(name='', sh_flags=0), section], symtab=NS(symbols=syms),
                 relocations=[], add_sh_symbol=lambda name: len(name))
        rows = [(0x2000, 'external__Fv', 4, True), (0x4000, 'callee__Fv', 4, True),
                (0x4004, 'wrong__Fv', 4, True)]
        image = struct.pack('<I', 0x24020001)
        kinds = {}
        if relocated:
            section.data = struct.pack('<I', 0x0c000000)
            image = struct.pack('<I', 0x0c001000)
            syms.append(symbol('callee__Fv', 0, kind=p.STT_FUNC, bind=1))
            elf.relocations.append(NS(sh_info=1, sh_name=0, name='.rel.text',
                                      relocations=[relocation(0, p.R_MIPS_26, 1)]))
            kinds[0x2000] = p.R_MIPS_26
        retail = NS(bytes=lambda lo, hi: image[:hi-lo], relocations=kinds,
                    word=lambda address: struct.unpack('<I', image)[0])
        lay = NS(sections=lambda unit: [('.text', 0x1000, 0x1100)])
        return elf, rows, retail, lay

    def apply(self, fx):
        elf, rows, retail, lay = fx
        output = StringIO()
        with patch.object(p.layout, 'Layout', return_value=lay), \
             patch.object(p.layout, 'read_symbols', return_value=rows), \
             patch.object(p, 'retail_addresses', return_value={row[1]:row[0] for row in rows}), \
             patch.object(p.layout, 'Retail', return_value=retail), redirect_stderr(output):
            p.discard_external_functions(elf, 'unit')
        return output.getvalue()

    def test_exact_external_body_and_calls_are_quiet(self):
        for relocated in (False, True):
            with self.subTest(relocated=relocated):
                fx = self.fixture(relocated=relocated)
                self.assertEqual(self.apply(fx), '')
                self.assertEqual(fx[0].sections[1].name, p.DEAD)
                self.assertEqual(fx[0].symtab.symbols[0].st_shndx, 0)

    def test_changed_body_is_reported_before_ownership_discard(self):
        fx = self.fixture(native=0x24020002)
        before = fx[0].sections[1].data
        self.assertIn('native body not verified against retail', self.apply(fx))
        self.assertEqual(fx[0].sections[1].data, before)
        self.assertEqual(fx[0].sections[1].name, p.DEAD)

    def test_wrong_call_target_and_relocation_shape_are_reported(self):
        for invalid in ('target', 'missing', 'duplicate'):
            with self.subTest(invalid=invalid):
                fx = self.fixture(relocated=True)
                if invalid == 'target': fx[0].symtab.symbols[1].name = 'wrong__Fv'
                elif invalid == 'missing': fx[2].relocations.clear()
                else: fx[0].relocations[0].relocations.append(relocation(0, p.R_MIPS_26, 1))
                self.assertIn('native body not verified against retail', self.apply(fx))

    def test_short_or_unknown_extent_is_reported(self):
        for extent in (0, 8):
            with self.subTest(extent=extent):
                fx = self.fixture()
                fx[1][0] = (0x2000, 'external__Fv', extent, True)
                self.assertIn('native body not verified against retail', self.apply(fx))

    def test_in_unit_weak_body_remains_live(self):
        fx = self.fixture(native=0x24020002)
        fx[3].sections = lambda unit: [('.text', 0x2000, 0x2100)]
        self.assertEqual(self.apply(fx), '')
        self.assertEqual(fx[0].sections[1].name, '.text')
