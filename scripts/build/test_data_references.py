"""Only real retail pointers may introduce data boundaries from assembly data."""

from pathlib import Path
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import disassemble as d


class DataReferenceTests(unittest.TestCase):
    def references(self, line, *, section='.data', relocation=None, source='', code_only=False,
                   retail_word=b'\x6c\x3f\x3f\0'):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            asm = root / 'asm'
            (asm / 'data').mkdir(parents=True)
            path = asm / ('unit.s' if code_only else 'data/unit.data.s')
            path.write_text(f'.section {section}\n' + line)
            cpp = root / 'unit.cpp'
            cpp.write_text(source)
            lay = NS(units=lambda *args: ['unit'] if code_only else [],
                     kinds={'unit': 'cpp'}, reference=lambda unit: 'asm/unit.s',
                     source=lambda unit: 'unit.cpp')
            retail = NS(relocations={} if relocation is None else {0x361600: relocation},
                        bytes=lambda lo, hi: retail_word)
            with patch.object(d, 'ROOT', root), patch.object(d.layout, 'ASM', Path('asm')), \
                 patch.object(d.layout, 'Retail', return_value=retail), \
                 patch.object(d.layout, 'section_of', return_value=section):
                return d.referenced_addresses(lay)

    def test_numeric_words_do_not_create_phantom_padding_boundaries(self):
        line = '/* 261680 00361600 6C3F3F00 */ .word D_003F3F6C\n'
        self.assertEqual(self.references(line), set())
        self.assertEqual(self.references(line, section='.rodata'), set())

    def test_real_pointer_relocation_preserves_the_required_symbol_base(self):
        line = '/* 261680 00361600 6C3F3F00 */ .word D_003F3F68 + 0x4\n'
        self.assertEqual(self.references(line, relocation=2), {0x3f3f68})

    def test_relocated_data_requires_complete_verified_byte_comments(self):
        line = '/* 261680 00361600 6C3F3F00 */ .word D_003F3F6C\n'
        with self.assertRaises(ValueError): self.references(line, relocation=2, retail_word=bytes(4))
        with self.assertRaises(ValueError): self.references(line, relocation=5)

    def test_unknown_data_pointer_expression_fails_closed(self):
        with self.assertRaises(ValueError): self.references('.word D_003F3F6C\n')

    def test_code_and_explicit_source_identities_still_own_boundaries(self):
        line = '/* 261680 00361600 6C3F3F00 */ addiu $2, $2, %lo(D_003F3F6C)\n'
        self.assertEqual(self.references(line, section='.text', code_only=True), {0x3f3f6c})
        self.assertEqual(self.references('', code_only=True,
                                         source='INCLUDE_BSS(D_003F3F6C, 4);'), {0x3f3f6c})


if __name__ == '__main__':
    unittest.main()
