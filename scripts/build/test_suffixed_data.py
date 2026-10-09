"""Local suffix binding must preserve bytes and reject competing unit identities."""

from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import postprocess_object as p
from test_literal_data import symbol, relocation


class SuffixedDataTests(unittest.TestCase):
    def fixture(self):
        compiled = NS(sections=[NS(name=''), NS(name='.data', data=b'DATA')],
                      symtab=NS(symbols=[symbol('table', 1, 4), symbol('table__2', 0)]),
                      relocations=[NS(sh_info=1, relocations=[relocation(0, p.R_MIPS_32, 1)])],
                      strtab=NS(add_symbol=lambda name: len(name)))
        rows = [(0x3000, 'table__2', 4, False)]
        lay = NS(kinds={'unit': 'cpp'}, sections=lambda unit: [('.data', 0x3000, 0x3010)])
        return compiled, rows, lay

    def apply(self, compiled, rows, lay):
        with patch.object(p.layout, 'Layout', return_value=lay), \
             patch.object(p.layout, 'read_symbols', return_value=rows):
            p.bind_suffixed_references(compiled, 'unit')

    def test_unique_unit_suffix_repoints_references_without_changing_bytes(self):
        compiled, rows, lay = self.fixture()
        self.apply(compiled, rows, lay)
        self.assertEqual(compiled.symtab.symbols[0].name, 'table__2')
        self.assertEqual(compiled.relocations[0].relocations[0].symbol_index, 0)
        self.assertEqual(compiled.sections[1].data, b'DATA')

    def test_ambiguous_external_and_competing_names_stay_unbound(self):
        for invalid in ('ambiguous', 'external', 'competing'):
            with self.subTest(invalid=invalid):
                compiled, rows, lay = self.fixture()
                if invalid == 'ambiguous':
                    rows.append((0x3004, 'table__3', 4, False))
                elif invalid == 'external':
                    rows[0] = (0x4000, 'table__2', 4, False)
                else:
                    compiled.symtab.symbols[1].st_shndx = 1
                self.apply(compiled, rows, lay)
                self.assertEqual(compiled.symtab.symbols[0].name, 'table')
                self.assertEqual(compiled.relocations[0].relocations[0].symbol_index, 1)
                self.assertEqual(compiled.sections[1].data, b'DATA')


if __name__ == '__main__':
    unittest.main()
