"""Declared extents disambiguate literal bytes without overruling real references."""

import unittest

import postprocess_object as p
import test_literal_data as fixtures


class LiteralIdentityTests(unittest.TestCase):
    def fixture(self):
        elf, pieces, retail, rows = fixtures.LiteralPointerTests().fixture()
        elf.sections[1].data = b' \0'
        elf.symtab.symbols[0].st_size = 2
        elf.relocations = []
        rows[:] = [(0x3000, 'at_1', 8, False), (0x3008, 'at_2', 2, False),
                   (0x3010, 'at_3', 1, False)]
        contents = b' \0\0\0@\0\0\0' + b' \0' + bytes(14)
        retail.bytes = lambda lo, hi: contents[lo - 0x3000:hi - 0x3000]
        return elf, pieces, retail, rows

    def apply(self, fixture):
        elf, pieces, retail, rows = fixture
        p.name_literal_data(elf, 'unit', set(), retail=retail, pieces=pieces,
                            addresses={'table': 0x4000}, rows=rows)
        return elf.symtab.symbols[0].name

    def test_space_string_is_not_a_prefix_identity_for_packed_button_pair(self):
        fixture = self.fixture()
        self.assertEqual(self.apply(fixture), 'at_2')
        self.assertEqual(fixture[0].sections[1].data, b' \0' + bytes(6))

    def test_two_equal_declared_candidates_stay_ambiguous(self):
        fixture = self.fixture()
        fixture[3][0] = (0x3000, 'at_1', 2, False)
        self.assertEqual(self.apply(fixture), 'at_999')

    def test_pointer_evidence_cannot_be_overruled_by_a_different_sized_candidate(self):
        fixture = self.fixture()
        fixture[0].relocations = fixtures.LiteralPointerTests().fixture()[0].relocations
        fixture[2].word = lambda address: 0x3000
        self.assertEqual(self.apply(fixture), 'at_999')


if __name__ == '__main__':
    unittest.main()
