"""Raw compiler counters and explicit source identities must remain distinct."""

from pathlib import Path
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import postprocess_object as p
import objdiff_data as d
from test_objdiff_data import symbol


class NativeProvenanceTests(unittest.TestCase):
    def test_counter_collision_does_not_adopt_an_explicit_retail_identity(self):
        sections = [NS(name='', sh_flags=0),
                    NS(name='.data', sh_flags=3, sh_type=1, sh_size=4, sh_addralign=4,
                       sh_name=0, data=b'RAW!'),
                    NS(name='.data', sh_flags=3, sh_type=1, sh_size=4, sh_addralign=4,
                       sh_name=0, data=b'REAL')]
        syms = [symbol('@7', 1, 4, info=1), symbol('at_7', 2, 4, info=1)]
        compiled = NS(sections=sections, symtab=NS(symbols=syms), relocations=[],
                      strtab=NS(add_symbol=lambda name: len(name)),
                      add_sh_symbol=lambda name: len(name), pack=lambda: b'packed')
        with tempfile.TemporaryDirectory() as directory:
            object_path = Path(directory) / 'native.o'
            object_path.write_bytes(b'raw')
            with patch('sys.argv', ['postprocess_object.py', str(object_path)]), \
                 patch.object(p, 'Elf', return_value=compiled), patch.object(p, 'name_sections'), \
                 patch.object(p, 'order_sections'), patch.object(p, 'retail_addresses', return_value={'at_7': 0x3000}), \
                 patch.object(p.layout, 'section_of', return_value='.sdata'):
                self.assertEqual(p.main(), 0)
        self.assertNotEqual(syms[0].name, 'at_7')
        self.assertEqual(sections[1].name, '.data')
        self.assertEqual(syms[1].name, 'at_7')
        self.assertEqual(sections[2].name, '.sdata')
        self.assertEqual(sections[1].data, b'RAW!')

    def test_discarded_counters_leave_no_transient_serialized_strings(self):
        sections = [NS(name='', sh_flags=0),
                    NS(name='.rodata', sh_flags=p.SHF_ALLOC, sh_type=p.SHT_PROGBITS,
                       sh_size=4, sh_addralign=4, sh_name=0, data=b'DATA')]
        names = []
        def add_symbol(name):
            names.append(name)
            return len(names)
        compiled = NS(sections=sections, symtab=NS(symbols=[symbol('@7', 1, 4, info=1)]),
                      relocations=[], strtab=NS(add_symbol=add_symbol),
                      add_sh_symbol=lambda name: len(name), pack=lambda: b'packed')
        with tempfile.TemporaryDirectory() as directory:
            object_path = Path(directory) / 'native.o'
            object_path.write_bytes(b'raw')
            with patch('sys.argv', ['postprocess_object.py', str(object_path)]), \
                 patch.object(p, 'Elf', return_value=compiled), patch.object(p, 'name_sections'), \
                 patch.object(p, 'order_sections'), patch.object(p, 'retail_addresses', return_value={}):
                self.assertEqual(p.main(), 0)
        self.assertEqual(sections[1].name, p.DEAD)
        self.assertEqual(names, ['at_7'])

    def fixture(self, name):
        sections = [NS(name='', sh_flags=0, sh_link=0),
                    NS(name='.rodata', sh_flags=2, sh_link=0, sh_type=1,
                       sh_size=4, sh_addralign=4, sh_name=0, data=bytes(4))]
        syms = [symbol(name, 1, 4, info=1)]
        compiled = NS(sections=sections, symtab=NS(symbols=syms), relocations=[],
                      e_shstrndx=0, symtab_index=0, strtab=NS(add_symbol=lambda name: len(name)),
                      add_sh_symbol=lambda name: len(name))
        runs = [('.rodata', [('at_7', 0x3000, 0x3008), ('at_8', 0x3008, 0x3010)])]
        rows = [(0x3000, 'at_7', 4, False), (0x3008, 'at_8', 4, False)]
        lay = NS(kinds={'unit': 'cpp'}, sections=lambda unit: [('.rodata', 0x3000, 0x3010)])
        pieces = NS(layout=lay, unit=lambda unit: runs)
        ctx = NS(layout=lay, pieces=pieces, literal_pieces=pieces, rows=rows,
                 addresses={name: address for address, name, _size, _function in rows},
                 ranges=lambda unit: {'.rodata': (0x3000, 0x3010, 0x3010)},
                 retail=NS(relocations={}, bytes=lambda lo, hi: bytes(hi-lo)))
        return compiled, ctx

    def prepare(self, compiled, ctx):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / 'unit.cpp'
            source.write_text('static const unsigned at_7 = 0;')
            ctx.layout.source = lambda unit: source
            with patch.object(p.layout, 'Layout', return_value=ctx.layout), \
                 patch.object(p.layout, 'read_symbols', return_value=ctx.rows), \
                 patch.object(p, 'retail_addresses', return_value=ctx.addresses), \
                 patch.object(p.layout, 'section_of', return_value='.rodata'):
                d.prepare_native_data(compiled, 'unit', ctx)

    def test_explicit_source_name_survives_ambiguous_literal_bytes(self):
        compiled, ctx = self.fixture('at_7')
        self.prepare(compiled, ctx)
        sym = compiled.symtab.symbols[0]
        self.assertEqual(sym.name, 'at_7')
        self.assertEqual(compiled.sections[sym.st_shndx].name, '.rodata')

    def test_raw_counter_with_ambiguous_bytes_receives_no_identity(self):
        compiled, ctx = self.fixture('@7')
        self.prepare(compiled, ctx)
        sym = compiled.symtab.symbols[0]
        self.assertNotIn(sym.name, ctx.addresses)
        self.assertTrue(compiled.sections[sym.st_shndx].name.startswith('.unmapped_data_'))


if __name__ == '__main__':
    unittest.main()
