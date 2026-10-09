"""Local consumer suffixes require complete code before identifying native BSS."""

import struct
from types import SimpleNamespace as NS
import unittest

import postprocess_object as p
import test_initialized_locals as fixtures
from test_literal_data import relocation, symbol


class LocalBssConsumerTests(unittest.TestCase):
    def fixture(self):
        compiled, kwargs = fixtures.InitializedLocalTests().fixture()
        compiled.sections[1] = NS(name='.bss', sh_type=p.SHT_NOBITS,
                                  sh_flags=p.SHF_ALLOC, sh_size=8, data=b'')
        compiled.symtab.symbols[0].name = 'at_999'
        run = [('.text', [('caller__2', 0x1000, 0x1010)]),
               ('.bss', [('at_1__2', 0x3000, 0x3010)])]
        kwargs['pieces'].unit = lambda unit: run
        kwargs['rows'][0] = (0x1000, 'caller__2', 16, True)
        kwargs['rows'][1] = (0x3000, 'at_1__2', 8, False)
        kwargs['rows'].append((0x6000, 'caller', 4, True))
        kwargs['addresses'] = {name: start for start, name, _size, _function in kwargs['rows']}
        return compiled, kwargs

    def apply(self, fixture):
        compiled, kwargs = fixture
        return p.bss_data_names(compiled, 'unit', set(), **kwargs)

    def test_unique_local_suffix_and_complete_code_identify_bss(self):
        compiled, kwargs = self.fixture()
        before = (compiled.sections[2].data,
                  [(entry.r_offset, entry.reloc_type, entry.symbol_index)
                   for entry in compiled.relocations[0].relocations])
        self.assertEqual(self.apply((compiled, kwargs)), {id(compiled.symtab.symbols[0]): 'at_1__2'})
        self.assertEqual((compiled.sections[2].data,
                          [(entry.r_offset, entry.reloc_type, entry.symbol_index)
                           for entry in compiled.relocations[0].relocations]), before)

    def test_consumer_identity_rejects_incomplete_or_ambiguous_evidence(self):
        for invalid in ('body', 'call', 'extent', 'global', 'alias', 'duplicate_name',
                        'suffix', 'row', 'kind', 'unknown_target', 'storage', 'extra_consumer', 'named'):
            with self.subTest(invalid=invalid):
                compiled, kwargs = self.fixture()
                if invalid == 'body': compiled.sections[2].data = compiled.sections[2].data[:-4] + b'FAIL'
                elif invalid == 'call':
                    compiled.sections[2].data = compiled.sections[2].data[:8] + struct.pack('<II', 0x0c000001, 0)
                elif invalid == 'extent': compiled.symtab.symbols[1].st_size = 12
                elif invalid == 'global': compiled.symtab.symbols[1].bind = 1
                elif invalid == 'alias': compiled.symtab.symbols.append(symbol('alias', 2, 16, kind=p.STT_FUNC))
                elif invalid == 'duplicate_name':
                    compiled.symtab.symbols.append(symbol('caller', 0, kind=p.STT_FUNC))
                elif invalid == 'suffix':
                    previous = kwargs['pieces'].unit
                    kwargs['pieces'].unit = lambda unit: previous(unit) + [('.text', [('caller__3', 0x2000, 0x2010)])]
                elif invalid == 'row': kwargs['rows'].append(kwargs['rows'][0])
                elif invalid == 'kind': kwargs['rows'][0] = (0x1000, 'caller__2', 16, False)
                elif invalid == 'unknown_target': compiled.symtab.symbols[2].name = 'unknown'
                elif invalid == 'storage': compiled.symtab.symbols[0].st_size = 4
                elif invalid == 'named': compiled.symtab.symbols[0].name = 'named_999'
                else:
                    compiled.sections.append(NS(name='.text', sh_flags=6, data=struct.pack('<I', 0)))
                    compiled.relocations.append(NS(sh_info=3, relocations=[relocation(0, p.R_MIPS_GPREL16, 0)]))
                self.assertEqual(self.apply((compiled, kwargs)), {})

    def test_late_literal_identity_precedes_complete_bss_consumer_proof(self):
        for valid in (False, True):
            with self.subTest(valid=valid):
                compiled, kwargs = self.fixture()
                payload = struct.pack('<f', 2.0)
                compiled.sections.append(NS(name='.rodata', sh_type=1, sh_flags=2,
                                            data=payload if valid else b'FAIL'))
                compiled.symtab.symbols.append(symbol('at_888', 3, 4))
                compiled.sections[2].data += struct.pack('<II', 0x3c030000, 0x24630000)
                compiled.symtab.symbols[1].st_size = 24
                compiled.relocations[0].relocations.extend([relocation(16, 5, 3), relocation(20, 6, 3)])
                expected = kwargs['retail'].bytes(0x1000, 0x1010) + struct.pack('<II', 0x3c030000, 0x24634000)
                spans = [(0x1000, expected), (0x4000, payload + bytes(4))]
                kwargs['retail'].bytes = lambda lo, hi: next((data[lo - start:hi - start]
                    for start, data in spans if start <= lo <= hi <= start + len(data)), b'')
                kwargs['retail'].word = lambda address: int.from_bytes(kwargs['retail'].bytes(address, address + 4), 'little')
                kwargs['retail'].relocations.update({0x1010: 5, 0x1014: 6})
                kwargs['rows'][0] = (0x1000, 'caller__2', 24, True)
                kwargs['rows'].append((0x4000, 'at_10', 4, False))
                kwargs['addresses']['at_10'] = 0x4000
                previous = kwargs['pieces'].unit
                kwargs['pieces'].unit = lambda unit: previous(unit) + [('.rodata', [('at_10', 0x4000, 0x4008)])]
                kwargs['pieces'].layout.sections = lambda unit: [('.rodata', 0x4000, 0x4008)]
                self.assertEqual(self.apply((compiled, kwargs)), {})
                p.name_literal_data(compiled, 'unit', set(), **kwargs)
                self.assertEqual(compiled.symtab.symbols[0].name, 'at_1__2' if valid else 'at_999')


if __name__ == '__main__':
    unittest.main()
