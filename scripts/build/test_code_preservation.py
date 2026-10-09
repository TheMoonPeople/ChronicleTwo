"""Data comparison preparation must preserve every serialized code relocation."""

from pathlib import Path
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import objdiff_data as d
from mwccgap.elf import Relocation
from test_objdiff_data import symbol


class CodePreservationTests(unittest.TestCase):
    def fixture(self):
        entry = Relocation(0, (1 << 8) | d.p.R_MIPS_HI16)
        elf = NS(sections=[NS(sh_flags=0), NS(sh_flags=6, data=bytes(4))],
                 symtab=NS(symbols=[symbol('caller', 1, 4, info=0x12),
                                   symbol('first_target'), symbol('second_target')]),
                 relocations=[NS(sh_info=1, relocations=[entry])])
        return elf, entry

    def test_changing_only_the_target_index_changes_the_snapshot(self):
        elf, entry = self.fixture()
        before = d.code_snapshot(elf)
        original = entry.pack()
        entry.symbol_index = 2
        self.assertNotEqual(original, entry.pack())
        self.assertNotEqual(before, d.code_snapshot(elf))

    def test_comparison_rejects_target_only_rewrite_before_publication(self):
        elf, entry = self.fixture()
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source, cpp, output = root / 'input.o', root / 'unit.cpp', root / 'output.o'
            source.write_bytes(b'raw')
            cpp.write_text('')
            ctx = NS(fingerprint='fixture', layout=NS(source=lambda unit: cpp))
            def redirect(_elf, _unit, _ctx):
                entry.symbol_index = 2
            with patch.object(d.p, 'Elf', return_value=elf), \
                 patch.object(d.p, 'name_sections'), \
                 patch.object(d, 'prepare_native_data', side_effect=redirect):
                with self.assertRaisesRegex(ValueError, 'changed code'):
                    d.comparison_copy(source, output, 'unit', ctx, True)
            self.assertFalse(output.exists())
            self.assertEqual(source.read_bytes(), b'raw')


if __name__ == '__main__':
    unittest.main()
