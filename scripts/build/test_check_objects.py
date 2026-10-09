import unittest

from types import SimpleNamespace

from check_objects import is_retail_tail_padding


class Retail:
    def __init__(self, padding, relocations=None):
        self.padding = padding
        self.relocations = relocations or {}

    def bytes(self, start, end):
        return self.padding[:end - start]


def context(padding, declared_size=4, relocations=None):
    return SimpleNamespace(
        pieces=SimpleNamespace(symbols=SimpleNamespace(
            by_name={"datum": (0x1000, "datum", declared_size, False)})),
        retail=Retail(padding, relocations))


def test_final_datum_padding():
    assert is_retail_tail_padding(context(bytes(4)), "datum", ".sdata", 0x1000, 0x1008, 4, 0x1004)
    assert is_retail_tail_padding(context(b""), "datum", ".bss", 0x1000, 0x1008, 4, 0x1004)

    assert not is_retail_tail_padding(context(b"\0\1\0\0"), "datum", ".sdata", 0x1000, 0x1008, 4, 0x1004)
    assert not is_retail_tail_padding(context(bytes(4), declared_size=8), "datum", ".sdata", 0x1000, 0x1008, 4, 0x1004)
    assert not is_retail_tail_padding(context(bytes(4), relocations={0x1006: 2}),
                                      "datum", ".sdata", 0x1000, 0x1008, 4, 0x1004)
    assert not is_retail_tail_padding(context(bytes(16)), "datum", ".sdata", 0x1000, 0x1014, 4, 0x1004)


def test_script_supplies_large_final_tail():
    assert is_retail_tail_padding(context(b"", declared_size=0x100), "datum", ".bss",
                                  0x3ec290, 0x3ec3c0, 0x100, 0x3ec390)
    assert not is_retail_tail_padding(context(b"", declared_size=0x100), "datum", ".bss",
                                      0x3ec290, 0x3ec3c0, 0x100, 0x3ec3a0)
    assert not is_retail_tail_padding(context(b"", declared_size=0x100), "datum", ".bss",
                                      0x3ec290, 0x3ec390, 0x100, 0x3ec390)
    assert not is_retail_tail_padding(context(b"", declared_size=0x100), "datum", ".bss",
                                      0x3ec290, 0x3ec3c0, 0xf0, 0x3ec380)
    assert not is_retail_tail_padding(
        context(b"", declared_size=0x100, relocations={0x3ec3a0: 2}), "datum", ".bss",
        0x3ec290, 0x3ec3c0, 0x100, 0x3ec390)
    assert is_retail_tail_padding(context(bytes(0x30), declared_size=0x100), "datum", ".data",
                                  0x3ec290, 0x3ec3c0, 0x100, 0x3ec390)
    assert not is_retail_tail_padding(context(bytes(0x2f), declared_size=0x100), "datum", ".data",
                                      0x3ec290, 0x3ec3c0, 0x100, 0x3ec390)
    assert not is_retail_tail_padding(context(bytes(0x2f) + b"\1", declared_size=0x100), "datum", ".data",
                                      0x3ec290, 0x3ec3c0, 0x100, 0x3ec390)


class TailPaddingTests(unittest.TestCase):
    def test_final_datum_padding(self):
        test_final_datum_padding()

    def test_script_supplies_large_final_tail(self):
        test_script_supplies_large_final_tail()


if __name__ == "__main__":
    test_final_datum_padding()
    test_script_supplies_large_final_tail()
    print("check_objects tail padding checks passed")
