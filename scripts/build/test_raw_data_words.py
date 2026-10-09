"""Split data must use retail relocation metadata instead of address guesses."""

import unittest
from types import SimpleNamespace as NS
from unittest.mock import patch

import disassemble as d


class RawDataWordTests(unittest.TestCase):
    def fixture(self, section='.data', operand='header_buff + 0x2FD', newline='\n'):
        word = 0x01f458bd
        text = (f'.section {section}, "wa"{newline}'
                f'    /* 225D00 0032A320 BD58F401 */ .word {operand}{newline}')
        retail = NS(relocations={}, word=lambda address: word,
                    bytes=lambda lo, hi: word.to_bytes(4, 'little'))
        return text, retail

    def test_unrelocated_words_in_every_initialized_section_stay_numeric(self):
        for section in ('.data', '.rodata', '.sdata', '.rdata', '.vudata', '.ctor', '.vtables'):
            with self.subTest(section=section), patch.object(d.layout, 'section_of', return_value=section):
                text, retail = self.fixture(section)
                self.assertEqual(d.raw_unrelocated_data_words(text, retail),
                                 text.replace('header_buff + 0x2FD', '0x01F458BD'))

    def test_retail_relocations_and_numeric_operands_are_preserved(self):
        with patch.object(d.layout, 'section_of', return_value='.data'):
            text, retail = self.fixture()
            retail.relocations[0x32a320] = 2
            self.assertEqual(d.raw_unrelocated_data_words(text, retail), text)
            retail.relocations.clear()
            for operand in ('0x01F458BD', '32790717', '+32790717', '-1'):
                text, _ = self.fixture(operand=operand)
                self.assertEqual(d.raw_unrelocated_data_words(text, retail), text)

    def test_only_verified_aligned_complete_retail_bytes_are_restored(self):
        for invalid in ('section', 'alignment', 'bytes', 'truncated'):
            with self.subTest(invalid=invalid), patch.object(d.layout, 'section_of', return_value='.data'):
                text, retail = self.fixture()
                if invalid == 'section':
                    text = text.replace('.data', '.rodata')
                elif invalid == 'alignment':
                    text = text.replace('0032A320', '0032A321')
                elif invalid == 'bytes':
                    text = text.replace('BD58F401', '00000000')
                else:
                    retail.bytes = lambda lo, hi: bytes(3)
                with self.assertRaises(ValueError):
                    d.raw_unrelocated_data_words(text, retail)

    def test_code_and_nobits_sections_are_untouched(self):
        for section in ('.text', '.vutext', '.bss', '.sbss', '.dead'):
            text, retail = self.fixture(section)
            self.assertEqual(d.raw_unrelocated_data_words(text, retail), text)

    def test_newlines_and_idempotence(self):
        with patch.object(d.layout, 'section_of', return_value='.data'):
            for newline in ('\n', '\r\n', ''):
                text, retail = self.fixture(newline=newline or '\n')
                if not newline:
                    text = text.rstrip('\n')
                restored = d.raw_unrelocated_data_words(text, retail)
                self.assertEqual(restored, text.replace('header_buff + 0x2FD', '0x01F458BD'))
                self.assertEqual(d.raw_unrelocated_data_words(restored, retail), restored)


if __name__ == '__main__':
    unittest.main()
