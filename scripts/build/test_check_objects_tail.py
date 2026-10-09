"""A unit run's terminal zero tail may not hide a missing or under-sized datum."""

import unittest

from check_objects import is_retail_tail_padding
from test_check_objects import context


class TailBoundTests(unittest.TestCase):
    def accepts(self, section, start, end, size):
        return is_retail_tail_padding(context(bytes(end - start - size), declared_size=size),
                                      "datum", section, start, end, size, start + size)

    def test_alignment_padding_before_next_run(self):
        for section in (".rodata", ".bss"):
            with self.subTest(section=section):
                self.assertTrue(self.accepts(section, 0x3EC290, 0x3EC3C0, 0x100))
                self.assertTrue(self.accepts(section, 0x379600, 0x379680, 0x1B))
        self.assertTrue(self.accepts(".sdata", 0x1000, 0x1008, 4))

    def test_omitted_trailing_zero_object(self):
        # A 0x100-byte zero object after the last declared datum is longer
        # than any run alignment.
        for section in (".data", ".bss"):
            with self.subTest(section=section):
                self.assertFalse(self.accepts(section, 0x3EC290, 0x3EC500, 0x100))

    def test_under_sized_trailing_object(self):
        # Declared 0x40 bytes short of retail's object, which ends where a
        # 32-byte aligned run starts.
        for section in (".data", ".bss"):
            with self.subTest(section=section):
                self.assertFalse(self.accepts(section, 0x1000, 0x1060, 0x20))

    def test_gap_beyond_next_run_address_alignment(self):
        # The next run starts on an 8-byte boundary, so the linker pads at
        # most 7 bytes; 0x10 zero bytes are storage, not padding.
        for section in (".sdata", ".sbss"):
            with self.subTest(section=section):
                self.assertFalse(self.accepts(section, 0x1000, 0x1018, 8))


if __name__ == "__main__":
    unittest.main()
