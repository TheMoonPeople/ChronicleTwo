"""Guard the distinction between function symbols and exported switch labels."""

import unittest
import struct
from types import SimpleNamespace
from unittest.mock import Mock

from prepare_objdiff_target import switch_labels, set_function_sizes, reference_immediate, restore_absolute_immediates


class SwitchLabelTests(unittest.TestCase):
    def test_only_explicit_switch_labels_are_localized(self):
        source = """
glabel SetUp__7CSphidaFi
  jlabel .L002EEA54
glabel .L002EEB18
.L002EEC20:
glabel named_function
jlabel named_function
.word .L002EEA54
"""
        self.assertEqual(switch_labels(source), [".L002EEA54"])

    def test_comments_and_near_matches_are_not_symbols(self):
        source = """
# jlabel .L002EEA54
// jlabel .L002EEB18
jlabel .L002EEA54_suffix
jlabel .L002EEA5
jlabel .L002EEA540
"""
        self.assertEqual(switch_labels(source), [])

    def test_repeated_labels_have_one_metadata_adjustment(self):
        self.assertEqual(switch_labels(
            "  jlabel .L002EEB18\n\tjlabel .L002EEA54\njlabel .L002EEB18\n"),
            [".L002EEA54", ".L002EEB18"])


class FunctionExtentTests(unittest.TestCase):
    def object(self):
        data = bytearray(320)
        data[:6] = b'\x7fELF\x01\x01'
        struct.pack_into('<I', data, 32, 160)
        struct.pack_into('<HH', data, 46, 40, 4)
        data[64:96] = bytes(range(32))
        data[96:102] = b'\0func\0'
        struct.pack_into('<IIIBBH', data, 144, 1, 8, 0, 16, 0, 1)
        struct.pack_into('<10I', data, 200, 0, 1, 6, 0, 64, 32, 0, 0, 16, 0)
        struct.pack_into('<10I', data, 240, 0, 3, 0, 0, 96, 6, 0, 0, 1, 0)
        struct.pack_into('<10I', data, 280, 0, 2, 0, 0, 128, 32, 2, 0, 4, 16)
        return data

    def test_declared_extent_changes_only_function_metadata(self):
        data = self.object()
        expected = data[:]
        struct.pack_into('<I', expected, 152, 12)
        expected[156] = 18
        set_function_sizes(data, {'func': 12})
        self.assertEqual(data, expected)
        set_function_sizes(data, {'func': 12})
        self.assertEqual(data, expected)

    def test_unknown_labels_are_untouched(self):
        data = self.object()
        expected = data[:]
        set_function_sizes(data, {'other': 12})
        self.assertEqual(data, expected)

    def test_out_of_section_extent_is_rejected(self):
        with self.assertRaises(ValueError):
            set_function_sizes(self.object(), {'func': 25})

    def test_unrelocated_numeric_offsets_match_retail(self):
        cases = [
            (0x3c050000, 0x3c050001, 5, 'D_12000'),
            (0x25430000, 0x25432000, 6, 'D_12000'),
            (0x25430000, 0x25434000, 6, 'D_14000'),
            (0x25430000, 0x25436000, 6, 'D_16000'),
            (0x3c050000, 0x3c050002, 5, 'D_1FFFF'),
            (0x25430000, 0x2543ffff, 6, 'D_1FFFF'),
            (0x34430000, 0x34438000, 6, 'D_18000'),
        ]
        for word, reference, kind, symbol in cases:
            self.assertEqual(reference_immediate(word, reference, kind, symbol, False), reference)

    def test_real_relocations_and_named_symbols_are_preserved(self):
        self.assertIsNone(reference_immediate(0x3c050000, 0x3c050001, 5, 'D_12000', True))
        self.assertIsNone(reference_immediate(0x3c050000, 0x3c050001, 5, 'buffer', False))
        self.assertIsNone(reference_immediate(0x3c050000, 0x3c050001, 5, 'D_12000_suffix', False))
        self.assertIsNone(reference_immediate(0x08000000, 0x08004800, 4, 'D_12000', False))
        self.assertIsNone(reference_immediate(0x8c430000, 0x8c432000, 6, 'D_12000', False))

    def test_incorrect_reference_instructions_are_rejected(self):
        for word, reference in [(0x3c050001, 0x3c050001),
                                (0x3c050000, 0x3c060001),
                                (0x3c050000, 0x3c050002)]:
            with self.assertRaises(ValueError):
                reference_immediate(word, reference, 5, 'D_12000', False)

    def test_text_section_name_comes_from_the_string_table(self):
        section = SimpleNamespace(name='', sh_name=31, data=struct.pack('<II', 0x3c050000, 0x25430000))
        entries = [SimpleNamespace(r_offset=0, symbol_index=0, reloc_type=5),
                   SimpleNamespace(r_offset=4, symbol_index=0, reloc_type=6)]
        record = SimpleNamespace(sh_info=0, relocations=entries[:])
        elf = SimpleNamespace(
            sections=[section], relocations=[record],
            shstrtab=SimpleNamespace(get_symbol_by_index=Mock(return_value='.text')),
            symtab=SimpleNamespace(symbols=[SimpleNamespace(st_shndx=0, st_value=0, name='D_12000')]))
        retail = SimpleNamespace(relocations={0x1004: 6}, word=Mock(side_effect=[0x3c050001, 0x25432000]))
        restore_absolute_immediates(elf, [('.text', 0x1000, 0x1008)], retail)
        self.assertEqual(section.data, struct.pack('<II', 0x3c050001, 0x25430000))
        self.assertEqual(record.relocations, [entries[1]])
        elf.shstrtab.get_symbol_by_index.assert_called_once_with(31)


if __name__ == "__main__":
    unittest.main()
