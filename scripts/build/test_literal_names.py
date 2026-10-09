"""A literal must not displace another live definition of its retail name."""

from types import SimpleNamespace as NS
import unittest

import postprocess_object as p
import test_literal_data as fixtures


class LiteralNameTests(unittest.TestCase):
    def test_competing_live_name_blocks_naming_and_padding(self):
        elf, pieces, retail, rows = fixtures.LiteralPointerTests().fixture()
        elf.sections.append(NS(name='.rodata', sh_type=p.SHT_PROGBITS,
                               sh_flags=p.SHF_ALLOC, data=b'X'))
        elf.symtab.symbols.append(fixtures.symbol('at_2', 3, 1))
        before = elf.sections[1].data
        p.name_literal_data(elf, 'unit', set(), retail=retail, pieces=pieces,
                            addresses={'table': 0x4000}, rows=rows)
        self.assertEqual(elf.symtab.symbols[0].name, 'at_999')
        self.assertEqual(elf.sections[1].data, before)
        self.assertEqual(elf.symtab.symbols[-1].name, 'at_2')

    def test_dead_and_undefined_names_do_not_compete(self):
        for index in (0, 3):
            with self.subTest(index=index):
                elf, pieces, retail, rows = fixtures.LiteralPointerTests().fixture()
                elf.sections.append(NS(name=p.DEAD, sh_type=p.SHT_PROGBITS,
                                       sh_flags=p.SHF_ALLOC, data=b'X'))
                elf.symtab.symbols.append(fixtures.symbol('at_2', index, 1))
                p.name_literal_data(elf, 'unit', set(), retail=retail, pieces=pieces,
                                    addresses={'table': 0x4000}, rows=rows)
                self.assertEqual(elf.symtab.symbols[0].name, 'at_2')


if __name__ == '__main__':
    unittest.main()
