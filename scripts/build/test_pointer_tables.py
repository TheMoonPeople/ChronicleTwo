"""Native table identity requires code consumers, relocation shape and literal bytes."""

import struct
from types import SimpleNamespace as NS
import unittest

import postprocess_object as p
from test_literal_data import symbol, relocation


class PointerTableTests(unittest.TestCase):
    def fixture(self):
        symbols = [symbol('geo_table_9999', 1, 8), symbol('at_999', 2, 1),
                   symbol('caller', 3, kind=p.STT_FUNC)]
        sections = [None, NS(name='.data', sh_type=1, sh_flags=p.SHF_ALLOC,
                            data=struct.pack('<II', 0, 0x3000)),
                    NS(name='.rodata', sh_type=1, sh_flags=p.SHF_ALLOC, data=b'\0'),
                    NS(name='.text', data=struct.pack('<II', 0x3c020000, 0x24420000))]
        elf = NS(sections=sections, symtab=NS(symbols=symbols),
                 relocations=[NS(sh_info=1, relocations=[relocation(0, p.R_MIPS_32, 1)]),
                              NS(sh_info=3, relocations=[relocation(0, p.R_MIPS_HI16, 0),
                                                         relocation(4, p.R_MIPS_LO16, 0)])],
                 strtab=NS(add_symbol=lambda name: len(name)))
        runs = [('.data', [('geo_table_12', 0x4000, 0x4008)]),
                ('.rodata', [('at_1', 0x3000, 0x3008), ('at_2', 0x3008, 0x3010)]),
                ('.text', [('caller', 0x1000, 0x1008)])]
        pieces = NS(layout=NS(sections=lambda unit: [('.rodata', 0x3000, 0x3010)]),
                    unit=lambda unit: runs)
        words = {0x1000: 0x3c020000, 0x1004: 0x24424000,
                 0x4000: 0x3008, 0x4004: 0x3000}
        retail = NS(relocations={0x1000: 5, 0x1004: 6, 0x4000: 2}, word=words.__getitem__,
                    bytes=lambda lo, hi: bytes(hi - lo) if hi <= 0x3010
                    else struct.pack('<II', 0x3008, 0x3000)[lo - 0x4000:hi - 0x4000])
        kwargs = dict(retail=retail, pieces=pieces,
                      addresses={'_gp': 0x2000, 'geo_table_12': 0x4000},
                      rows=[(0x4000, 'geo_table_12', 8, False)])
        return elf, kwargs

    def apply(self, fixture, placeholders=()):
        elf, kwargs = fixture
        p.name_literal_data(elf, 'unit', set(placeholders), **kwargs)
        return elf.symtab.symbols[0].name

    def test_table_then_empty_literal_use_verified_native_identity(self):
        fixture = self.fixture()
        elf, _kwargs = fixture
        code, data = elf.sections[3].data, elf.sections[1].data
        self.assertEqual(self.apply(fixture), 'geo_table_12')
        self.assertEqual(elf.symtab.symbols[1].name, 'at_2')
        self.assertEqual(elf.sections[3].data, code)
        self.assertEqual(elf.sections[1].data, data)
        self.assertEqual(elf.relocations[0].relocations[0].symbol_index, 1)
        self.assertEqual(elf.symtab.symbols[0].st_size, 8)

    def test_anchor_is_available_before_its_symbol_is_renamed(self):
        fixture = self.fixture()
        elf, _kwargs = fixture
        elf.symtab.symbols[0], elf.symtab.symbols[1] = elf.symtab.symbols[1], elf.symtab.symbols[0]
        elf.relocations[0].relocations[0].symbol_index = 0
        for entry in elf.relocations[1].relocations:
            entry.symbol_index = 1
        names = []
        elf.strtab.add_symbol = lambda name: names.append(name) or len(names)
        self.apply(fixture)
        self.assertEqual(names, ['at_2', 'geo_table_12'])

    def test_counter_spelling_does_not_determine_identity(self):
        fixture = self.fixture()
        fixture[0].symtab.symbols[0].name = 'another_table_7'
        self.assertEqual(self.apply(fixture), 'geo_table_12')

    def test_anonymous_templates_keep_the_existing_literal_matcher(self):
        fixture = self.fixture()
        fixture[0].symtab.symbols[0].name = 'at_9999'
        selected = p.pointer_table_names(fixture[0], 'unit', set(), **fixture[1])
        self.assertEqual(selected, {})

    def test_unknown_consumer_and_opcode_change_reject_table(self):
        for invalid in ('unknown', 'opcode'):
            fixture = self.fixture()
            elf, _kwargs = fixture
            if invalid == 'unknown':
                elf.sections.append(NS(name='.text', data=bytes(4)))
                elf.relocations.append(NS(sh_info=4, relocations=[relocation(0, p.R_MIPS_32, 0)]))
            else:
                elf.sections[3].data = struct.pack('<II', 0x3c030000, 0x24420000)
            self.assertEqual(self.apply(fixture), 'geo_table_9999')

    def test_nonpointer_bytes_are_compared_without_address_guessing(self):
        fixture = self.fixture()
        fixture[0].sections[1].data = struct.pack('<II', 0, 0x3004)
        self.assertEqual(self.apply(fixture), 'geo_table_9999')

    def test_wrong_literal_bytes_or_unknown_target_reject_table(self):
        for invalid in ('bytes', 'undefined', 'outgoing', 'global', 'empty'):
            fixture = self.fixture()
            elf, _kwargs = fixture
            if invalid == 'bytes':
                elf.sections[2].data = b'X'
            elif invalid == 'undefined':
                elf.symtab.symbols[1].st_shndx = 0
            elif invalid == 'outgoing':
                elf.relocations.append(NS(sh_info=2, relocations=[relocation(0, p.R_MIPS_32, 0)]))
            elif invalid == 'global':
                elf.symtab.symbols[1].bind = 1
            else:
                elf.symtab.symbols[1].st_size = 0
                elf.sections[2].data = b''
            self.assertEqual(self.apply(fixture), 'geo_table_9999')

    def test_exact_declared_extent_is_required(self):
        fixture = self.fixture()
        fixture[1]['rows'][0] = (0x4000, 'geo_table_12', 4, False)
        self.assertEqual(self.apply(fixture), 'geo_table_9999')

    def test_pointer_shape_requires_real_retail_relocations(self):
        for invalid in ('missing', 'kind', 'extra'):
            fixture = self.fixture()
            elf, kwargs = fixture
            if invalid == 'missing':
                kwargs['retail'].relocations.pop(0x4000)
            elif invalid == 'kind':
                elf.relocations[0].relocations[0].reloc_type = p.R_MIPS_HI16
            else:
                elf.relocations[0].relocations.append(relocation(4, p.R_MIPS_32, 1))
            self.assertEqual(self.apply(fixture), 'geo_table_9999')

    def test_retained_placeholders_and_live_names_prevent_naming(self):
        for placeholder in (True, False):
            fixture = self.fixture()
            if not placeholder:
                fixture[0].sections.append(NS(name='.data', sh_type=p.SHT_PROGBITS,
                                              sh_flags=p.SHF_ALLOC, data=bytes(8)))
                fixture[0].symtab.symbols.append(symbol('geo_table_12', 4, 8))
            self.assertEqual(self.apply(fixture, [1] if placeholder else []), 'geo_table_9999')

    def test_executable_data_cannot_supply_a_verified_table_anchor(self):
        fixture = self.fixture()
        fixture[0].sections[1].sh_flags |= p.SHF_EXECINSTR
        self.assertEqual(self.apply(fixture), 'geo_table_9999')
        self.assertEqual(fixture[0].symtab.symbols[1].name, 'at_999')

    def test_named_target_must_resolve_the_real_pointer(self):
        for address, expected in ((0x3008, 'geo_table_12'), (0x3000, 'geo_table_9999')):
            fixture = self.fixture()
            fixture[0].symtab.symbols[1].name = 'named_literal'
            fixture[1]['addresses']['named_literal'] = address
            self.assertEqual(self.apply(fixture), expected)


if __name__ == '__main__':
    unittest.main()
