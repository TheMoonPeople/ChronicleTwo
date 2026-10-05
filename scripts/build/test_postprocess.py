import argparse
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/mwccgap'))

from mwccgap.elf import Elf
from postprocess_object import discard_unused_literals, name_sections, project_name


def literal_object(data):
    elf = Elf(data)
    name_sections(elf)
    for index, symbol in enumerate(elf.symtab.symbols):
        symbol.name = project_name(symbol.name)
        if (symbol.name.startswith('at_') and symbol.name[3:].isdigit()
                and symbol.bind == 0 and elf.sections[symbol.st_shndx].name == '.sbss'):
            return elf, index
    raise AssertionError('mapselect compiler literal is missing')


def test_unused_literal(data):
    elf, index = literal_object(data)
    section_index = elf.symtab.symbols[index].st_shndx
    names = [section.name for section in elf.sections]
    discard_unused_literals(elf)
    names[section_index] = '.dead'
    assert [section.name for section in elf.sections] == names


def test_referenced_literal(data):
    elf, index = literal_object(data)
    elf.relocations[0].relocations[0].symbol_index = index
    section = elf.sections[elf.symtab.symbols[index].st_shndx]
    discard_unused_literals(elf)
    assert section.name == '.sbss'


def test_public_literal(data):
    elf, index = literal_object(data)
    elf.symtab.symbols[index].bind = 1
    section = elf.sections[elf.symtab.symbols[index].st_shndx]
    discard_unused_literals(elf)
    assert section.name == '.sbss'


def test_named_variable(data):
    elf, index = literal_object(data)
    elf.symtab.symbols[index].name = 'select_1009'
    section = elf.sections[elf.symtab.symbols[index].st_shndx]
    discard_unused_literals(elf)
    assert section.name == '.sbss'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--object', type=Path, default=ROOT / 'build/pal/objdiff/base/mapselect.cpp.o')
    args = parser.parse_args()
    data = args.object.read_bytes()
    test_unused_literal(data)
    test_referenced_literal(data)
    test_public_literal(data)
    test_named_variable(data)
    print('postprocess checks passed')


if __name__ == '__main__':
    main()
