"""Serialized MIPS objects must not hide invalid relocation sites or high halves."""

from pathlib import Path
import struct
import tempfile
from types import SimpleNamespace as NS
import unittest

import check_objects as c


def object_bytes(contents, records, text=False):
    """Build an ELF32/MIPS fixture with real symbol and relocation tables."""
    name = '.text' if text else '.sdata'
    strings = b'\0datum\0target\0'
    symbols = bytes(16) + struct.pack('<IIIBBH', 1, 0, len(contents),
                                      0x12 if text else 0x11, 0, 1)
    symbols += struct.pack('<IIIBBH', 7, 0, 0, 0x10, 0, 0)
    sections = [('', 0, 0, b'', 0, 0, 0, 0),
                (name, 1, 6 if text else 3, contents, 0, 0, 16 if text else 1, 0),
                ('.symtab', 2, 0, symbols, 3, 1, 4, 16),
                ('.strtab', 3, 0, strings, 0, 0, 1, 0)]
    for entries in records:
        payload = b''.join(struct.pack('<II', offset, (2 << 8) | kind)
                           for offset, kind in entries)
        sections.append(('.rel' + name, 9, 0, payload, 2, 1, 4, 8))
    shstrndx = len(sections)
    sections.append(('.shstrtab', 3, 0, b'', 0, 0, 1, 0))
    names = bytearray(b'\0')
    name_offsets = []
    for section_name, *_rest in sections:
        name_offsets.append(len(names))
        names.extend(section_name.encode() + b'\0')
    sections[-1] = ('.shstrtab', 3, 0, bytes(names), 0, 0, 1, 0)
    image = bytearray(52)
    headers = []
    for name_offset, (_name, kind, flags, payload, link, info, alignment, entsize) in zip(name_offsets, sections):
        if kind == 0:
            headers.append(bytes(40))
            continue
        image.extend(bytes(-len(image) % max(alignment, 1)))
        offset = len(image)
        image.extend(payload)
        headers.append(struct.pack('<10I', name_offset, kind, flags, 0, offset,
                                   len(payload), link, info, alignment, entsize))
    image.extend(bytes(-len(image) % 4))
    shoff = len(image)
    image.extend(b''.join(headers))
    image[:52] = struct.pack('<16sHHIIIIIHHHHHH', b'\x7fELF\x01\x01\x01' + bytes(9),
                            1, 8, 1, 0, 0, shoff, 0, 52, 0, 0, 40, len(sections), shstrndx)
    return bytes(image)


class SerializedRelocationTests(unittest.TestCase):
    def check(self, contents, expected, records, text=False):
        kind = '.text' if text else '.sdata'
        start = 0x3000
        row = (start, 'datum', len(contents), text)
        run = [('datum', start, start + len(contents))]
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'unit.cpp.o').write_bytes(object_bytes(contents, records, text))
            context = NS(
                obj_dir=root,
                layout=NS(sections=lambda unit: [(kind, start, start + len(contents))]),
                pieces=NS(of=lambda *args: run, symbols=NS(by_name={'datum': row})),
                linker=NS(contents_end=lambda *args: start + len(contents)),
                address_of={'datum': start, 'target': 0x4000}.get, gp=0,
                retail=NS(bytes=lambda lo, hi: expected[lo-start:hi-start],
                          word=lambda address: struct.unpack_from('<I', expected, address-start)[0],
                          relocations={}))
            return c.check_unit(context, 'unit', False)

    def test_duplicate_sites_in_one_or_multiple_records_are_rejected(self):
        for records in ([[(0, c.R_MIPS_32), (0, c.R_MIPS_32)]],
                        [[(0, c.R_MIPS_32)], [(0, c.R_MIPS_32)]]):
            with self.subTest(records=records):
                errors, _bytes, _relocs = self.check(bytes(4), struct.pack('<I', 0x4000), records)
                self.assertTrue(any('duplicate relocation site' in error for error in errors), errors)

    def test_misaligned_and_out_of_piece_sites_are_errors_instead_of_crashes(self):
        for offset in (1, 3, 5, 8, 0xFFFFFFFF):
            with self.subTest(offset=offset):
                errors, _bytes, _relocs = self.check(bytes(8), bytes(8), [[(offset, c.R_MIPS_32)]])
                self.assertTrue(any('relocation site' in error for error in errors), errors)

    def test_unpaired_high_half_cannot_mask_a_different_retail_immediate(self):
        errors, _bytes, _relocs = self.check(struct.pack('<I', 0x3C080000),
                                            struct.pack('<I', 0x3C081234),
                                            [[(0, c.R_MIPS_HI16)]], text=True)
        self.assertTrue(any('unpaired HI16' in error for error in errors), errors)

    def test_multiple_high_halves_can_share_one_low_half(self):
        contents = struct.pack('<III', 0x3C080000, 0x3C090000, 0x25080000)
        expected = struct.pack('<III', 0x3C080000, 0x3C090000, 0x25084000)
        result = self.check(contents, expected,
                            [[(0, c.R_MIPS_HI16), (4, c.R_MIPS_HI16), (8, c.R_MIPS_LO16)]], text=True)
        self.assertEqual(result, ([], 12, 3))

    def test_standalone_low_half_remains_valid(self):
        result = self.check(struct.pack('<I', 0x25080000), struct.pack('<I', 0x25084000),
                            [[(0, c.R_MIPS_LO16)]], text=True)
        self.assertEqual(result, ([], 4, 1))

    def test_resolved_absolute_fields_and_equivalent_kinds_remain_valid(self):
        expected = struct.pack('<I', 0x4000)
        self.assertEqual(self.check(expected, expected, []), ([], 4, 0))
        self.assertEqual(self.check(bytes(4), expected, [[(0, c.R_MIPS_GPREL16)]]), ([], 4, 1))
        self.assertEqual(self.check(bytes(4), expected, [[(0, c.R_MIPS_32)]]), ([], 4, 1))


if __name__ == '__main__':
    unittest.main()
