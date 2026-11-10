import argparse
from pathlib import Path
import sys
from types import SimpleNamespace

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/kazarov/scripts'))

from kazarov_elf import Elf
from postprocess_object import (discard_dead_code_records, discard_unused_literals,
                                name_sections, project_name, rename_dng_main_local_static)


def test_dead_code_records():
    def fixture(target_names):
        sections = [SimpleNamespace(name=name, sh_name=0)
                    for name in ('', '.mwcats', '.dead', '.text')]
        symbols = [SimpleNamespace(st_shndx=2 if name == 'dead' else 3)
                   for name in target_names]
        record = SimpleNamespace(
            sh_info=1, name='.rel.mwcats', sh_name=0,
            relocations=[SimpleNamespace(symbol_index=i) for i in range(len(symbols))])
        elf = SimpleNamespace(
            sections=sections, symtab=SimpleNamespace(symbols=symbols),
            relocations=[record], add_sh_symbol=lambda name: 1)
        return elf, record

    elf, record = fixture(('dead', 'dead'))
    discard_dead_code_records(elf)
    assert elf.sections[1].name == '.dead'
    assert record.name == '.rel.dead'

    elf, record = fixture(('live',))
    discard_dead_code_records(elf)
    assert elf.sections[1].name == '.mwcats'
    assert record.name == '.rel.mwcats'

    elf, record = fixture(('dead', 'live'))
    try:
        discard_dead_code_records(elf)
    except ValueError as error:
        assert 'both dead and live' in str(error)
    else:
        raise AssertionError('mixed live/dead metadata was discarded')
    assert elf.sections[1].name == '.mwcats'
    assert record.name == '.rel.mwcats'


def test_dng_main_local_static():
    symbols = [SimpleNamespace(name=name, st_size=size, st_name=0, st_shndx=1, bind=0)
               for name, size in (('debug_event_stack_393', 0x30), ('init_912', 1),
                                  ('InitDungeonMain__F13INIT_LOOP_ARG', 64))]
    elf = SimpleNamespace(symtab=SimpleNamespace(symbols=symbols),
                          sections=[None, SimpleNamespace(sh_type=8)],
                          relocations=[SimpleNamespace(sh_info=1, relocations=[
                              SimpleNamespace(symbol_index=0), SimpleNamespace(symbol_index=1)])],
                          strtab=SimpleNamespace(add_symbol=lambda name: len(name)))
    rename_dng_main_local_static(elf, 'dng_main')
    assert [(symbol.name, symbol.st_size) for symbol in symbols[:2]] == [
        ('debug_event_stack_1106', 0x30), ('init_1107', 1)]
    assert [symbol.st_name for symbol in symbols[:2]] == [len(symbol.name) for symbol in symbols[:2]]

    # A second guard in the same owner must not be selected by suffix order.
    symbols[0].name = 'debug_event_stack_393'
    symbols[1].name = 'init_912'
    symbols.append(SimpleNamespace(name='init_394', st_size=1, st_name=0,
                                   st_shndx=1, bind=0))
    elf.relocations[0].relocations.append(SimpleNamespace(symbol_index=3))
    try:
        rename_dng_main_local_static(elf, 'dng_main')
    except ValueError:
        pass
    else:
        raise AssertionError('ambiguous initializer guard selected by ordinal')

    retail_symbols = [SimpleNamespace(name='debug_event_stack_1106', st_size=0x30)]
    retail_elf = SimpleNamespace(symtab=SimpleNamespace(symbols=retail_symbols))
    rename_dng_main_local_static(retail_elf, 'dng_main')

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
    test_dead_code_records()
    test_dng_main_local_static()
    test_unused_literal(data)
    test_referenced_literal(data)
    test_public_literal(data)
    test_named_variable(data)
    print('postprocess checks passed')


if __name__ == '__main__':
    main()
