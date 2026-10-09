"""VU instructions must not acquire relocations from address-shaped bit patterns."""

from types import SimpleNamespace
import unittest
from unittest.mock import patch

import disassemble as d


class VuWordTests(unittest.TestCase):
    def setUp(self):
        self.word = 0x01f458bd
        self.retail = SimpleNamespace(relocations={}, word=lambda address: self.word,
                                      bytes=lambda lo, hi: self.word.to_bytes(4, 'little'))
        self.text = ('.section .vutext, "wa"\nglabel Vu_program\n'
                     '    /* 225D00 00325C80 BD58F401 */ .word AnyLocal + 0x2FD\n')
        self.expected = self.text.replace('AnyLocal + 0x2FD', '0x01F458BD')

    def test_unrelocated_symbol_expression_becomes_retail_word(self):
        self.assertEqual(d.raw_unrelocated_vu_words(self.text, self.retail), self.expected)

    def test_true_retail_relocation_is_preserved(self):
        self.retail.relocations[0x325c80] = 2
        self.assertEqual(d.raw_unrelocated_vu_words(self.text, self.retail), self.text)

    def test_numeric_words_are_preserved_and_idempotent(self):
        for value in ('0x01F458BD', '32790717', '+32790717', '-1'):
            text = self.text.replace('AnyLocal + 0x2FD', value)
            self.assertEqual(d.raw_unrelocated_vu_words(text, self.retail), text)

    def test_other_sections_are_untouched(self):
        for name in ('.data', '.vudata', '.text', '.rodata'):
            text = self.text.replace('.vutext', name)
            self.assertEqual(d.raw_unrelocated_vu_words(text, self.retail), text)

    def test_wrong_bytes_are_rejected(self):
        with self.assertRaisesRegex(ValueError, 'retail bytes'):
            d.raw_unrelocated_vu_words(self.text.replace('BD58F401', '00000000'), self.retail)

    def test_address_outside_vu_is_rejected(self):
        with self.assertRaisesRegex(ValueError, 'outside'):
            d.raw_unrelocated_vu_words(self.text.replace('00325C80', '0032A320'), self.retail)

    def test_unaligned_address_is_rejected(self):
        with self.assertRaisesRegex(ValueError, 'unaligned'):
            d.raw_unrelocated_vu_words(self.text.replace('00325C80', '00325C81'), self.retail)

    def test_newline_styles_are_preserved(self):
        for newline in ('\n', '\r\n'):
            self.assertEqual(d.raw_unrelocated_vu_words(self.text.replace('\n', newline), self.retail),
                             self.expected.replace('\n', newline))
        self.assertEqual(d.raw_unrelocated_vu_words(self.text.rstrip('\n'), self.retail),
                         self.expected.rstrip('\n'))

    def test_restoration_precedes_piece_boundary_discovery(self):
        events = []
        pieces = SimpleNamespace(defined=lambda: [], unit=lambda unit: [])
        with patch.object(d, 'run_splat'), patch.object(d, 'twin_split_files'), \
             patch.object(d.layout, 'Layout', return_value=SimpleNamespace(units=lambda kind: [])), \
             patch.object(d.layout, 'Retail', return_value=self.retail), \
             patch.object(d, 'restore_raw_vu_words', side_effect=lambda *args: events.append('restore')), \
             patch.object(d, 'Pieces', side_effect=lambda *args: events.append('pieces') or pieces), \
             patch('sys.argv', ['disassemble.py']):
            d.main()
        self.assertEqual(events, ['restore', 'pieces'])

    def test_explicit_source_identifiers_keep_their_boundaries(self):
        self.assertEqual(d.source_addresses('u8 D_01F628BC[4];\nuse(D_0034ABCD);'),
                         {0x1f628bc, 0x34abcd})

    def test_comments_and_strings_do_not_create_source_boundaries(self):
        self.assertEqual(d.source_addresses('/* D_01F628BC */ // D_0034ABCD\n'
                                            'print("D_00345678"); char c = \'x\';'), set())


if __name__ == '__main__':
    unittest.main()
