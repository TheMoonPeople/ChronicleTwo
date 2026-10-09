"""Incomplete aggregate data sections retain native storage but exclude reservations."""

from pathlib import Path
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import objdiff_data as d
from test_objdiff_data import symbol


class MixedNativeReservationTests(unittest.TestCase):
    def test_native_piece_survives_without_completing_its_reserved_section(self):
        sections = [NS(name='', sh_flags=0, sh_link=0),
                    NS(name='.bss', sh_type=d.p.SHT_NOBITS, sh_size=4,
                       sh_flags=2, sh_link=0, data=b''),
                    NS(name='.bss', sh_type=d.p.SHT_NOBITS, sh_size=4,
                       sh_flags=2, sh_link=0, data=b''),
                    NS(name='', sh_flags=0, sh_link=0)]
        syms = [symbol('native', 1, 4, info=1), symbol('held__DATA', 2, 4, info=0x11)]
        elf = NS(sections=sections, symtab=NS(symbols=syms), relocations=[],
                 e_shstrndx=3, symtab_index=3, strtab=NS(add_symbol=lambda name: 1),
                 add_sh_symbol=lambda name: 1)
        ranges = [('.bss', 0x3000, 0x3008)]
        runs = [('.bss', [('native', 0x3000, 0x3004), ('held', 0x3004, 0x3008)])]
        rows = [(0x3000, 'native', 4, False), (0x3004, 'held', 4, False)]
        addresses = {'native': 0x3000, 'held': 0x3004}
        lay = NS(kinds={'unit': 'cpp'}, sections=lambda unit: ranges)
        pieces = NS(layout=lay, unit=lambda unit: runs)
        retail = NS(relocations={}, bytes=lambda lo, hi: bytes(hi - lo))
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / 'unit.cpp'
            source.write_text('static int native; INCLUDE_BSS(held, 4);')
            lay.source = lambda unit: source
            ctx = NS(layout=lay, addresses=addresses, rows=rows, retail=retail,
                     pieces=pieces, literal_pieces=pieces,
                     ranges=lambda unit: {'.bss': (0x3000, 0x3008, 0x3008)})
            with patch.object(d.p.layout, 'Retail', return_value=retail), \
                 patch.object(d.p.layout, 'Layout', return_value=lay), \
                 patch.object(d.p.layout, 'read_symbols', return_value=rows), \
                 patch.object(d.p.layout, 'section_of', return_value='.bss'), \
                 patch.object(d.p.disassemble, 'Pieces', return_value=pieces), \
                 patch.object(d.p, 'retail_addresses', return_value=addresses):
                d.prepare_native_data(elf, 'unit', ctx)
        self.assertEqual(syms[0].name, 'native')
        self.assertEqual((syms[0].st_size, elf.sections[syms[0].st_shndx].sh_size), (4, 4))
        self.assertEqual((syms[1].st_shndx, syms[1].st_size), (0, 0))
        aggregate = sum(d.p.section_size(section) for section in elf.sections
                        if section.name == '.bss' and section.sh_flags & d.p.SHF_ALLOC)
        self.assertEqual(aggregate, 4)
        # Objdiff compares the complete named section with retail's eight bytes.
        # Keeping a correct native piece must not import the missing reservation.
        self.assertNotEqual(aggregate, ranges[0][2] - ranges[0][1])


if __name__ == '__main__':
    unittest.main()
