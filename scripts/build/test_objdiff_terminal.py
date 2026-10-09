"""Comparison tails need the original native extent, not merely zero bytes."""

import unittest

import objdiff_data as d
import test_data_padding as fixtures


class TerminalComparisonTests(unittest.TestCase):
    def test_oversized_terminal_object_is_not_trimmed_into_a_match(self):
        for nobits in (False, True):
            with self.subTest(nobits=nobits):
                helper = fixtures.AlignmentFragmentTests()
                compiled, ctx = helper.fixture(nobits)
                section = compiled.sections[3]
                if nobits:
                    section.sh_size = 16
                else:
                    section.data = bytes(16)
                compiled.symtab.symbols[2].st_size = 16
                before = d.code_snapshot(compiled)
                helper.prepare(compiled, ctx)
                symbol = compiled.symtab.symbols[2]
                self.assertEqual(d.p.section_size(compiled.sections[symbol.st_shndx]), 16)
                self.assertEqual(symbol.st_size, 16)
                self.assertEqual(d.code_snapshot(compiled), before)

    def test_exact_original_object_can_trim_a_verified_zero_tail(self):
        for nobits in (False, True):
            with self.subTest(nobits=nobits):
                helper = fixtures.AlignmentFragmentTests()
                compiled, ctx = helper.fixture(nobits)
                def extend(*args, **kwargs):
                    section = compiled.sections[3]
                    if nobits:
                        section.sh_size = 16
                    else:
                        section.data += bytes(4)
                    compiled.symtab.symbols[2].st_size = 16
                helper.prepare(compiled, ctx, literal_padding=extend)
                symbol = compiled.symtab.symbols[2]
                self.assertEqual(d.p.section_size(compiled.sections[symbol.st_shndx]), 12)
                self.assertEqual(symbol.st_size, 12)

    def test_nonzero_tail_is_not_discarded(self):
        helper = fixtures.AlignmentFragmentTests()
        compiled, ctx = helper.fixture()
        def extend(*args, **kwargs):
            compiled.sections[3].data += b'FAIL'
            compiled.symtab.symbols[2].st_size = 16
        helper.prepare(compiled, ctx, literal_padding=extend)
        symbol = compiled.symtab.symbols[2]
        self.assertEqual(d.p.section_size(compiled.sections[symbol.st_shndx]), 16)

    def test_relocated_tail_is_not_discarded(self):
        helper = fixtures.AlignmentFragmentTests()
        compiled, ctx = helper.fixture()
        def extend(*args, **kwargs):
            compiled.sections[3].data += bytes(4)
            compiled.symtab.symbols[2].st_size = 16
            compiled.symtab.symbols.append(fixtures.symbol('target'))
            record = fixtures.record(3, [(12, d.p.R_MIPS_32, len(compiled.symtab.symbols)-1)])
            record.name = '.rel.data'
            compiled.sections.append(record)
            compiled.relocations.append(record)
        helper.prepare(compiled, ctx, literal_padding=extend)
        sym = compiled.symtab.symbols[2]
        self.assertEqual(d.p.section_size(compiled.sections[sym.st_shndx]), 16)
        self.assertTrue(any(entry.r_offset == 12 for record in compiled.relocations
                            if record.sh_info == sym.st_shndx for entry in record.relocations))

    def test_marker_held_coincidental_native_payload_receives_no_credit(self):
        helper = fixtures.AlignmentFragmentTests()
        compiled, ctx = helper.fixture()
        before = d.code_snapshot(compiled)
        helper.prepare(compiled, ctx, 'INCLUDE_RODATA("dir", first__DATA);')
        self.assertEqual(compiled.symtab.symbols[1].st_shndx, 0)
        self.assertEqual(d.code_snapshot(compiled), before)


if __name__ == '__main__':
    unittest.main()
