"""Named initialized locals require exact storage and complete retail consumers."""

import copy
import struct
from types import SimpleNamespace as NS
import unittest

import postprocess_object as p
from test_literal_data import relocation, symbol


class InitializedLocalTests(unittest.TestCase):
    def fixture(self):
        payload = struct.pack('<II', 1, 2)
        code = struct.pack('<IIII', 0x3c020000, 0x24420000, 0x0c000000, 0)
        expected = struct.pack('<IIII', 0x3c020000, 0x24423000, 0x0c001400, 0)
        symbols = [symbol('bits_999', 1, 8), symbol('caller', 2, 16, kind=p.STT_FUNC),
                   symbol('callee', 0, kind=p.STT_FUNC)]
        sections = [NS(name='', sh_flags=0),
                    NS(name='.data', sh_type=p.SHT_PROGBITS, sh_flags=p.SHF_ALLOC,
                       data=payload),
                    NS(name='.text', sh_type=p.SHT_PROGBITS,
                       sh_flags=p.SHF_ALLOC | p.SHF_EXECINSTR, data=code)]
        refs = [relocation(0, p.R_MIPS_HI16, 0), relocation(4, p.R_MIPS_LO16, 0),
                relocation(8, 4, 2)]
        elf = NS(sections=sections, symtab=NS(symbols=symbols),
                 relocations=[NS(sh_info=2, relocations=refs)],
                 strtab=NS(add_symbol=lambda name: len(name)))
        spans = [(0x1000, expected), (0x3000, payload + bytes(8))]
        retail = NS(relocations={0x1000: 5, 0x1004: 6, 0x1008: 4},
                    bytes=lambda lo, hi: next((data[lo - start:hi - start]
                                              for start, data in spans
                                              if start <= lo <= hi <= start + len(data)), b''))
        retail.word = lambda address: int.from_bytes(retail.bytes(address, address + 4), 'little')
        runs = [('.text', [('caller', 0x1000, 0x1010)]),
                ('.data', [('bits_12', 0x3000, 0x3010)])]
        pieces = NS(layout=NS(sections=lambda unit: [('.data', 0x3000, 0x3010)]),
                    unit=lambda unit: runs)
        rows = [(0x1000, 'caller', 16, True), (0x3000, 'bits_12', 8, False),
                (0x5000, 'callee', 4, True)]
        return elf, dict(retail=retail, pieces=pieces,
                        addresses={name: start for start, name, _size, _function in rows}, rows=rows)

    def apply(self, fixture, placeholders=()):
        elf, kwargs = fixture
        p.name_literal_data(elf, 'unit', set(placeholders), **kwargs)
        return elf.symtab.symbols[0].name

    def paired_fixture(self):
        elf, kwargs = self.fixture()
        elf.sections.append(copy.deepcopy(elf.sections[1]))
        elf.symtab.symbols.append(symbol('more_888', 3, 8))
        elf.sections[2].data += struct.pack('<II', 0x3c030000, 0x24630000)
        elf.symtab.symbols[1].st_size = 24
        elf.relocations[0].relocations.extend([relocation(16, 5, 3), relocation(20, 6, 3)])
        expected = kwargs['retail'].bytes(0x1000, 0x1010) + struct.pack('<II', 0x3c030000, 0x24633010)
        old_bytes = kwargs['retail'].bytes
        payload = bytes(elf.sections[3].data)
        kwargs['retail'].bytes = lambda lo, hi: expected[lo - 0x1000:hi - 0x1000] \
            if 0x1000 <= lo <= hi <= 0x1018 else payload[lo - 0x3010:hi - 0x3010] \
            if 0x3010 <= lo <= hi <= 0x3018 else old_bytes(lo, hi)
        kwargs['retail'].relocations.update({0x1010: 5, 0x1014: 6})
        kwargs['rows'][0] = (0x1000, 'caller', 24, True)
        kwargs['rows'].append((0x3010, 'more_7', 8, False))
        kwargs['addresses']['more_7'] = 0x3010
        previous = kwargs['pieces'].unit
        kwargs['pieces'].unit = lambda unit: previous(unit) + [('.data', [('more_7', 0x3010, 0x3018)])]
        return elf, kwargs

    def test_local_pair_sharing_a_consumer_is_verified_collectively(self):
        fixture = self.paired_fixture()
        self.assertEqual(self.apply(fixture), 'bits_12')
        self.assertEqual(fixture[0].symtab.symbols[3].name, 'more_7')

    def test_invalid_peer_rejects_both_shared_consumer_claims(self):
        fixture = self.paired_fixture()
        fixture[0].sections[3].data = bytes(8)
        self.assertEqual(self.apply(fixture), 'bits_999')
        self.assertEqual(fixture[0].symtab.symbols[3].name, 'more_888')

    def test_exact_named_local_is_named_without_rewriting_bytes_or_relocations(self):
        fixture = self.fixture()
        elf, _kwargs = fixture
        before = ([section.data for section in elf.sections[1:]],
                  copy.deepcopy(elf.relocations))
        self.assertEqual(self.apply(fixture), 'bits_12')
        self.assertEqual([section.data for section in elf.sections[1:]], before[0])
        self.assertEqual(elf.relocations, before[1])
        self.assertEqual(elf.symtab.symbols[0].st_size, 8)

    def test_compiler_counter_changes_do_not_change_source_identity(self):
        fixture = self.fixture()
        fixture[0].symtab.symbols[0].name = 'bits_7'
        self.assertEqual(self.apply(fixture), 'bits_12')

    def test_retail_duplicate_suffix_does_not_change_source_base(self):
        fixture = self.fixture()
        _elf, kwargs = fixture
        kwargs['rows'][1] = (0x3000, 'bits_12__2', 8, False)
        kwargs['addresses']['bits_12__2'] = kwargs['addresses'].pop('bits_12')
        previous = kwargs['pieces'].unit
        kwargs['pieces'].unit = lambda unit: [
            (kind, [(name + '__2' if name == 'bits_12' else name, lo, hi)
                    for name, lo, hi in run]) for kind, run in previous(unit)]
        self.assertEqual(self.apply(fixture), 'bits_12__2')

    def test_gp_relative_consumer_requires_the_known_gp(self):
        for available in (True, False):
            with self.subTest(available=available):
                fixture = self.fixture()
                elf, kwargs = fixture
                elf.sections[2].data = struct.pack('<IIII', 0x27820000, 0, 0x0c000000, 0)
                elf.relocations[0].relocations[:2] = [relocation(0, p.R_MIPS_GPREL16, 0)]
                kwargs['retail'].relocations = {0x1000: 7, 0x1008: 4}
                expected = struct.pack('<IIII', 0x27821000, 0, 0x0c001400, 0)
                old_bytes = kwargs['retail'].bytes
                kwargs['retail'].bytes = lambda lo, hi: expected[lo - 0x1000:hi - 0x1000] \
                    if 0x1000 <= lo <= hi <= 0x1010 else old_bytes(lo, hi)
                if available:
                    kwargs['addresses']['_gp'] = 0x2000
                self.assertEqual(self.apply(fixture), 'bits_12' if available else 'bits_999')

    def test_storage_metadata_bytes_and_source_base_must_agree(self):
        for invalid in ('base', 'binding', 'section', 'declared', 'symbol', 'payload', 'alias',
                        'object', 'outgoing', 'no_reference', 'placeholder', 'competing'):
            with self.subTest(invalid=invalid):
                fixture = self.fixture()
                elf, kwargs = fixture
                if invalid == 'base':
                    elf.symtab.symbols[0].name = 'other_999'
                elif invalid == 'binding':
                    elf.symtab.symbols[0].bind = 1
                elif invalid == 'section':
                    elf.sections[1].name = '.rodata'
                elif invalid == 'declared':
                    kwargs['rows'][1] = (0x3000, 'bits_12', 4, False)
                elif invalid == 'symbol':
                    elf.symtab.symbols[0].st_size = 4
                elif invalid == 'payload':
                    elf.sections[1].data = bytes(8)
                elif invalid == 'alias':
                    elf.symtab.symbols.append(symbol('interior', 1, value=4))
                elif invalid == 'object':
                    elf.symtab.symbols.append(symbol('alias', 1, 8))
                elif invalid == 'outgoing':
                    elf.relocations.append(NS(sh_info=1, relocations=[relocation(0, 2, 2)]))
                elif invalid == 'no_reference':
                    elf.relocations = []
                elif invalid == 'competing':
                    elf.sections.append(copy.deepcopy(elf.sections[1]))
                    elf.symtab.symbols.append(symbol('bits_12', 3, 8))
                self.assertEqual(self.apply(fixture, [1] if invalid == 'placeholder' else []),
                                 'other_999' if invalid == 'base' else 'bits_999')

    def test_complete_consumer_body_extent_and_call_target_are_required(self):
        for invalid in ('instruction', 'truncated', 'size', 'call', 'unknown', 'noncode',
                        'duplicate', 'orphan_low', 'missing_low', 'relocation_kind'):
            with self.subTest(invalid=invalid):
                fixture = self.fixture()
                elf, kwargs = fixture
                if invalid == 'instruction':
                    elf.sections[2].data = elf.sections[2].data[:-4] + struct.pack('<I', 0x24020001)
                elif invalid == 'truncated':
                    elf.sections[2].data = elf.sections[2].data[:-4]
                elif invalid == 'size':
                    elf.symtab.symbols[1].st_size = 12
                elif invalid == 'call':
                    kwargs['addresses']['callee'] = 0x5004
                elif invalid in ('unknown', 'noncode'):
                    elf.sections.append(NS(name='.data' if invalid == 'noncode' else '.text',
                                           sh_flags=p.SHF_ALLOC, data=bytes(4)))
                    elf.relocations.append(NS(sh_info=3, relocations=[relocation(0, 2, 0)]))
                elif invalid == 'duplicate':
                    elf.relocations[0].relocations.append(relocation(0, 5, 0))
                elif invalid == 'orphan_low':
                    elf.relocations[0].relocations.pop(0)
                elif invalid == 'missing_low':
                    elf.relocations[0].relocations.pop(1)
                else:
                    kwargs['retail'].relocations[0x1008] = 2
                self.assertEqual(self.apply(fixture), 'bits_999')

    def test_unsuffixed_same_unit_call_target_resolves_before_suffix_binding(self):
        fixture = self.fixture()
        elf, kwargs = fixture
        kwargs['addresses'].pop('callee')
        kwargs['addresses']['callee__2'] = 0x5000
        kwargs['rows'][2] = (0x5000, 'callee__2', 4, True)
        previous = kwargs['pieces'].unit
        kwargs['pieces'].unit = lambda unit: previous(unit) + [('.text', [('callee__2', 0x5000, 0x5004)])]
        self.assertEqual(self.apply(fixture), 'bits_12')


if __name__ == '__main__':
    unittest.main()
