"""Anchored data consumers need complete R_MIPS_32 evidence and consistent addends."""

import struct
from types import SimpleNamespace as NS
import unittest

import postprocess_object as p
from test_literal_data import symbol, relocation


class DataConsumerTests(unittest.TestCase):
    def fixture(self):
        compiled = NS(sections=[NS(name=''), NS(name='.rodata', data=bytes(8)),
                                NS(name='.data', data=struct.pack('<I', 4))],
                      symtab=NS(symbols=[symbol('copy', 1, 8, value=2)]),
                      relocations=[NS(sh_info=2, relocations=[relocation(0, p.R_MIPS_32, 0)])])
        words = {0x3000: 0x4006}
        retail = NS(relocations={0x3000: p.R_MIPS_32}, word=words.__getitem__)
        return compiled, retail, words

    def apply(self, compiled, retail, **kwargs):
        return p.referenced_data_starts(compiled, 1, retail, {}, {}, data_starts={2: 0x3000}, **kwargs)

    def test_anchored_data_subtracts_native_addend_and_symbol_offset(self):
        compiled, retail, _words = self.fixture()
        before = compiled.sections[2].data
        self.assertEqual(self.apply(compiled, retail, size=8), {0x4000})
        self.assertEqual(compiled.sections[2].data, before)
        self.assertEqual(compiled.relocations[0].relocations[0].symbol_index, 0)

    def test_every_reference_must_agree_on_the_copy_base(self):
        compiled, retail, words = self.fixture()
        compiled.sections[2].data += struct.pack('<I', 0)
        compiled.relocations[0].relocations.append(relocation(4, p.R_MIPS_32, 0))
        retail.relocations[0x3004] = p.R_MIPS_32
        words[0x3004] = 0x4002
        self.assertEqual(self.apply(compiled, retail), {0x4000})
        words[0x3004] = 0x4006
        self.assertEqual(self.apply(compiled, retail), {0x4000, 0x4004})

    def test_incomplete_data_evidence_is_rejected(self):
        for invalid in ('kind', 'missing', 'duplicate', 'unaligned', 'truncated', 'bounds', 'unknown'):
            with self.subTest(invalid=invalid):
                compiled, retail, _words = self.fixture()
                entry = compiled.relocations[0].relocations[0]
                if invalid == 'kind':
                    entry.reloc_type = p.R_MIPS_LO16
                    retail.relocations[0x3000] = p.R_MIPS_LO16
                elif invalid == 'missing':
                    retail.relocations.clear()
                elif invalid == 'duplicate':
                    compiled.relocations[0].relocations.append(relocation(0, p.R_MIPS_32, 0))
                elif invalid == 'unaligned':
                    entry.r_offset = 1
                elif invalid == 'truncated':
                    compiled.sections[2].data = bytes(3)
                elif invalid == 'bounds':
                    compiled.sections[2].data = struct.pack('<I', 8)
                else:
                    compiled.sections.append(NS(name='.data', data=bytes(4)))
                    compiled.relocations.append(NS(sh_info=3, relocations=[relocation(0, p.R_MIPS_32, 0)]))
                self.assertIsNone(self.apply(compiled, retail, size=8))


if __name__ == '__main__':
    unittest.main()
