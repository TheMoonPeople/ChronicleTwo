"""Placeholder binding must prove copies without repairing compiler output."""

import struct
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import postprocess_object as p
from test_literal_data import symbol, relocation


class LocalDataTests(unittest.TestCase):
    def fixture(self, *, nobits=False, pair=False):
        code = struct.pack('<II', 0x3c020000, 0x24420000) if pair else struct.pack('<I', 0x27820000)
        refs = ([relocation(0, p.R_MIPS_HI16, 1), relocation(4, p.R_MIPS_LO16, 1)]
                if pair else [relocation(0, p.R_MIPS_GPREL16, 1)])
        native = NS(name='.bss' if nobits else '.data', sh_type=8 if nobits else 1,
                    sh_flags=3, sh_name=0, sh_size=16, data=b'' if nobits else bytes(16))
        held = NS(name='.rodata', sh_type=1, sh_flags=2, sh_name=0, sh_size=16, data=bytes(16))
        syms = [symbol('caller', 1, len(code), bind=1, kind=p.STT_FUNC),
                symbol('copy_99', 2, 16), symbol('datum', 3, 16, bind=1)]
        elf = NS(sections=[NS(name='', sh_flags=0),
                          NS(name='.text', sh_type=1, sh_flags=6, sh_name=0, data=code), native, held],
                 symtab=NS(symbols=syms), add_sh_symbol=lambda name: len(name),
                 strtab=NS(add_symbol=lambda name: len(name)),
                 relocations=[NS(sh_info=1, sh_name=0, name='.rel.text', relocations=refs)])
        rows = [(0x2000, '_gp', 0, False), (0x1000, 'caller', len(code), True),
                (0x3000, 'datum', 16, False)]
        words = {0x1000: 0x3c020000, 0x1004: 0x24423000} if pair else {0x1000: 0x27821000}
        retail = NS(word=words.__getitem__, relocations={0x1000 + r.r_offset: r.reloc_type for r in refs},
                    bytes=lambda lo, hi: bytes(hi - lo))
        lay = NS(kinds={'unit': 'cpp'}, sections=lambda unit: [('.text', 0x1000, 0x1100),
                  ('.bss' if nobits else '.data', 0x3000, 0x3010)])
        return elf, rows, words, retail, lay

    def apply(self, fixture, placeholders=None):
        elf, rows, _words, retail, lay = fixture
        with patch.object(p.layout, 'Layout', return_value=lay), \
             patch.object(p.layout, 'read_symbols', return_value=rows), \
             patch.object(p.layout, 'Retail', return_value=retail), \
             patch.object(p, 'rename_shared_names'):
            return p.bind_local_data(elf, 'unit', {3} if placeholders is None else placeholders)

    def test_negative_addend_preserves_the_named_table_identity(self):
        for destination, dropped, target in ((0x2ffc, ['A'], 2), (0x300c, [], 1)):
            with self.subTest(destination=destination):
                fixture = self.fixture(nobits=True, pair=True)
                elf, rows, words, _retail, lay = fixture
                elf.symtab.symbols[1].name = elf.symtab.symbols[2].name = 'A'
                rows[-1] = (0x3000, 'A', 16, False)
                rows.append((0x3010, 'B', 16, False))
                elf.sections[3].name = '.bss'
                elf.sections[3].sh_type = p.SHT_NOBITS
                elf.sections[3].data = b''
                elf.sections.append(NS(name='.bss', sh_type=p.SHT_NOBITS,
                                       sh_flags=3, sh_name=0, sh_size=16, data=b''))
                elf.symtab.symbols.append(symbol('B', 4, 16, bind=1))
                lay.sections = lambda unit: [('.text', 0x1000, 0x1100),
                                              ('.bss', 0x3000, 0x3020)]
                code = struct.pack('<II', 0x3c020000, 0x2442fffc)
                elf.sections[1].data = code
                words[0x1004] = 0x24420000 | destination
                self.assertEqual(self.apply(fixture, {3, 4}), dropped)
                self.assertEqual(elf.sections[1].data, code)
                self.assertEqual(elf.sections[2].name == p.DEAD, bool(dropped))
                self.assertTrue(all(entry.symbol_index == target
                                    for entry in elf.relocations[0].relocations))

    def reject(self, fixture):
        elf = fixture[0]
        code = elf.sections[1].data
        refs = [r.symbol_index for r in elf.relocations[0].relocations]
        self.assertEqual(self.apply(fixture), [])
        self.assertNotEqual(elf.sections[2].name, p.DEAD)
        self.assertEqual(elf.sections[1].data, code)
        self.assertEqual([r.symbol_index for r in elf.relocations[0].relocations], refs)

    def test_valid_binding_preserves_all_instruction_bytes(self):
        for nobits in (False, True):
            for pair in (False, True):
                fixture = self.fixture(nobits=nobits, pair=pair)
                before = fixture[0].sections[1].data
                self.assertEqual(self.apply(fixture), ['copy_99'])
                self.assertEqual(fixture[0].sections[1].data, before)
                self.assertTrue(all(r.symbol_index == 2 for r in fixture[0].relocations[0].relocations))

    def test_wrong_element_addend_is_not_repaired(self):
        for pair in (False, True):
            with self.subTest(pair=pair):
                fixture = self.fixture(nobits=True, pair=pair)
                code = bytearray(fixture[0].sections[1].data)
                struct.pack_into('<I', code, 4 if pair else 0, 0x24420004 if pair else 0x27820004)
                fixture[0].sections[1].data = bytes(code)
                fixture[2][0x1004 if pair else 0x1000] += 8
                self.reject(fixture)

    def test_inconsistent_later_reference_is_not_discarded(self):
        fixture = self.fixture(nobits=True)
        fixture[0].sections[1].data += struct.pack('<I', 0x27830000)
        fixture[0].relocations[0].relocations.append(relocation(4, p.R_MIPS_GPREL16, 1))
        fixture[2][0x1004] = 0x27831004
        fixture[3].relocations[0x1004] = p.R_MIPS_GPREL16
        self.reject(fixture)

    def test_retail_kind_and_nonimmediate_bits_must_match(self):
        for invalid in ('missing', 'kind', 'opcode', 'pair_opcode'):
            with self.subTest(invalid=invalid):
                fixture = self.fixture(nobits=True, pair=invalid == 'pair_opcode')
                if invalid == 'missing':
                    fixture[3].relocations.clear()
                elif invalid == 'kind':
                    fixture[3].relocations[0x1000] = p.R_MIPS_32
                elif invalid == 'opcode':
                    fixture[2][0x1000] ^= 0x10000
                else:
                    fixture[2][0x1004] ^= 0x10000
                self.reject(fixture)

    def test_nobits_copy_requires_exact_retail_extent(self):
        fixture = self.fixture(nobits=True)
        fixture[0].sections[2].sh_size = 20
        fixture[0].symtab.symbols[1].st_size = 20
        self.reject(fixture)

    def test_truncated_initialized_copy_with_relocated_tail_stays_live(self):
        fixture = self.fixture()
        elf, _rows, _words, retail, _lay = fixture
        elf.sections[2].data = bytes(12)
        elf.symtab.symbols[1].st_size = 12
        image = bytes(12) + struct.pack('<I', 0x4000)
        retail.bytes = lambda lo, hi: image[lo - 0x3000:hi - 0x3000]
        retail.relocations[0x300c] = p.R_MIPS_32
        self.reject(fixture)

    def test_truncated_unrelocated_initialized_copy_stays_live(self):
        fixture = self.fixture()
        elf, _rows, _words, retail, _lay = fixture
        elf.sections[2].data = bytes(12)
        elf.symtab.symbols[1].st_size = 12
        image = bytes(12) + struct.pack('<I', 0x100c)
        retail.bytes = lambda lo, hi: image[lo - 0x3000:hi - 0x3000]
        self.reject(fixture)

    def test_zero_suffix_does_not_prove_a_short_declared_copy(self):
        fixture = self.fixture()
        fixture[0].sections[2].data = bytes(12)
        fixture[0].symtab.symbols[1].st_size = 12
        self.reject(fixture)

    def test_missing_initialized_extent_supplies_no_binding_proof(self):
        fixture = self.fixture()
        fixture[1][-1] = (0x3000, 'datum', 0, False)
        self.reject(fixture)

    def test_relocated_payload_and_relocation_shape_must_match(self):
        for invalid in ('payload', 'missing', 'kind', 'duplicate', 'destination'):
            with self.subTest(invalid=invalid):
                fixture = self.fixture()
                elf, _rows, words, retail, _lay = fixture
                elf.symtab.symbols.append(symbol('target', 0, bind=1))
                fixture[1].append((0x4000, 'target', 4, False))
                elf.relocations.append(NS(sh_info=2, sh_name=0, name='.rel.data',
                                          relocations=[relocation(0, p.R_MIPS_32, 3)]))
                words[0x3000] = 0x4000
                retail.relocations[0x3000] = p.R_MIPS_32
                retail.bytes = lambda lo, hi: (struct.pack('<I', words[0x3000]) + bytes(12))[lo-0x3000:hi-0x3000]
                if invalid == 'payload':
                    elf.sections[2].data = bytes(4) + b'X' + bytes(11)
                elif invalid == 'missing':
                    retail.relocations.pop(0x3000)
                elif invalid == 'kind':
                    elf.relocations[-1].relocations[0].reloc_type = p.R_MIPS_26
                elif invalid == 'duplicate':
                    elf.relocations[-1].relocations.append(relocation(0, p.R_MIPS_32, 3))
                else:
                    words[0x3000] = 0x4004
                self.reject(fixture)

    def test_unrelocated_payload_mismatch_stays_live(self):
        fixture = self.fixture()
        fixture[0].sections[2].data = b'X' + bytes(15)
        self.reject(fixture)

    def test_interior_symbol_offset_is_never_folded_into_an_immediate(self):
        fixture = self.fixture(nobits=True)
        fixture[0].symtab.symbols.append(symbol('.bss', 2, value=4, kind=p.STT_SECTION))
        fixture[0].relocations[0].relocations[0].symbol_index = 3
        fixture[2][0x1000] += 4
        self.reject(fixture)

    def test_unpaired_and_duplicate_references_stay_live(self):
        for invalid in ('orphan', 'duplicate'):
            with self.subTest(invalid=invalid):
                fixture = self.fixture(nobits=True, pair=True)
                if invalid == 'orphan':
                    fixture[0].relocations[0].relocations.pop()
                else:
                    fixture[0].relocations[0].relocations.append(relocation(4, p.R_MIPS_LO16, 1))
                self.reject(fixture)

    def test_unknown_consumer_blocks_every_repoint(self):
        fixture = self.fixture(nobits=True)
        fixture[0].sections.append(NS(name='.text', sh_flags=6, data=struct.pack('<I', 0x27820000)))
        fixture[0].relocations.append(NS(sh_info=4, relocations=[relocation(0, p.R_MIPS_GPREL16, 1)]))
        self.reject(fixture)


if __name__ == '__main__':
    unittest.main()
