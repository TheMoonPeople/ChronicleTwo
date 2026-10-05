import argparse
import os
import struct
import tempfile
from pathlib import Path

import match


def test_addresses():
    addresses = {'destination': 0x123450}
    assert match.symbol_address({'name': 'destination', 'section': 0, 'value': 0}, addresses, {}) == 0x123450
    assert match.symbol_address({'name': '', 'section': 3, 'value': 12}, addresses, {3: 0x123450}) == 0x12345C
    assert match.symbol_address({'name': 'constant', 'section': 0xFFF1, 'value': 42}, addresses, {}) == 42
    assert match.symbol_address({'name': 'D_00123450', 'section': 0, 'value': 0}, {}, {}) == 0x123450
    assert match.symbol_address({'name': 'missing', 'section': 0, 'value': 0}, addresses, {}) is None
    assert match.symbol_address({'name': '@20', 'section': 3, 'value': 0, 'address': None}, {'at_20': 42}, {3: 42}) is None
    assert match.unit_name('buffer', ['buffer__2', 'other']) == 'buffer__2'
    assert match.unit_name('buffer', ['buffer', 'buffer__2']) == 'buffer'
    assert match.unit_name('counter_20', ['counter_30', 'other'], True) == 'counter_30'
    assert match.unit_name('counter_20', ['counter_30', 'counter_40'], True) == 'counter_20'


def test_literals():
    data = b'example\0'
    regions = [(0x1000, b'prefix' + data + b'suffix')]
    assert match.literal_address(data, regions, [], {}) == 0x1006
    assert match.literal_address(data, regions + [(0x2000, data)], [], {}) is None
    assert match.literal_address(b'different\0', regions, [], {}) is None
    table = struct.pack('<2I', 0x100040, 0x100064)
    entries = [{'offset': 0, 'type': 2}, {'offset': 4, 'type': 2}]
    assert match.literal_address(table, [(0x3000, table)], entries, {0x3000: 2, 0x3004: 2}) == 0x3000
    assert match.literal_address(table, [(0x3000, table)], entries, {0x3000: 2}) is None
    assert match.literal_address(table, [(0x3000, table)], entries + [entries[0]], {0x3000: 2, 0x3004: 2}) is None
    assert match.literal_address(b'', regions, [], {}) is None


def test_relocations():
    symbols = [{'name': 'destination', 'section': 0, 'value': 0}]
    addresses = {'destination': 0x123450}
    data = struct.pack('<5I', 0x0C000001, 0x3C020001, 0x24428000, 0x8F82FFF8, 8)
    relocations = [{'offset': offset, 'type': kind, 'symbol': 0}
                   for offset, kind in [(0, 4), (4, 5), (8, 6), (12, 7), (16, 2)]]
    resolved, problems = match.relocate(data, relocations, symbols, addresses, {}, 0x120000)
    assert not problems
    assert struct.unpack('<5I', resolved) == (0x0C048D15, 0x3C020013, 0x2442B450, 0x8F823448, 0x123458)
    addresses['destination'] += 4
    changed, problems = match.relocate(data, relocations, symbols, addresses, {}, 0x120000)
    assert changed != resolved
    assert not problems


def test_literal_bindings():
    symbols = [{'name': '@1', 'address': None, 'candidates': [0x123450, 0x223450]}]
    data = struct.pack('<2I', 0x3C020000, 0x24420000)
    expected = struct.pack('<2I', 0x3C020022, 0x24423450)
    entries = [{'offset': 0, 'type': 5, 'symbol': 0}, {'offset': 4, 'type': 6, 'symbol': 0}]
    metadata = {0: 5, 4: 6}
    resolved = match.bind_literals(data, expected, entries, symbols, 0, metadata)
    assert resolved[0]['address'] == 0x223450
    assert symbols[0]['address'] is None
    assert match.relocate(data, entries, resolved, {}, {}, 0)[0] == expected
    for contents, records in [(struct.pack('<2I', 0x3C030022, 0x24423450), metadata),
                              (struct.pack('<2I', 0x3C020032, 0x24423450), metadata),
                              (expected, {0: 5})]:
        assert match.bind_literals(data, contents, entries, symbols, 0, records)[0]['address'] is None
    symbols[0]['candidates'] = [0x380010, 0x380020]
    data = struct.pack('<I', 0x8F820004)
    expected = struct.pack('<I', 0x8F820024)
    entries = [{'offset': 0, 'type': 7, 'symbol': 0}]
    resolved = match.bind_literals(data, expected, entries, symbols, 0x380000, {0: 7})
    assert resolved[0]['address'] == 0x380020
    assert match.relocate(data, entries, resolved, {}, {}, 0x380000)[0] == expected


def test_unresolved():
    symbols = [{'name': 'missing', 'section': 0, 'value': 0}]
    resolved, problems = match.relocate(bytes(4), [{'offset': 0, 'type': 4, 'symbol': 0}], symbols, {}, {}, 0)
    assert problems and resolved == bytes(4)
    symbols[0]['name'] = 'destination'
    addresses = {'destination': 0x123450}
    for relocation in [{'offset': 0, 'type': 5, 'symbol': 0},
                       {'offset': 0, 'type': 99, 'symbol': 0},
                       {'offset': 4, 'type': 4, 'symbol': 0},
                       {'offset': -4, 'type': 4, 'symbol': 0},
                       {'offset': 1, 'type': 4, 'symbol': 0}]:
        resolved, problems = match.relocate(bytes(4), [relocation], symbols, addresses, {}, 0)
        assert problems


def test_relocation_ranges():
    symbols = [{'name': 'destination', 'section': 0, 'value': 0}]
    gp = 0x380000
    relocation = [{'offset': 0, 'type': 7, 'symbol': 0}]
    for offset in [-32768, 32767]:
        resolved, problems = match.relocate(bytes(4), relocation, symbols, {'destination': gp + offset}, {}, gp)
        assert not problems
        assert match.word(resolved, 0) == offset & 0xFFFF
    for offset in [-32769, 32768, 65536]:
        resolved, problems = match.relocate(bytes(4), relocation, symbols, {'destination': gp + offset}, {}, gp)
        assert problems
    relocation[0]['type'] = 4
    for target in [0x123451, 0x10123450]:
        resolved, problems = match.relocate(bytes(4), relocation, symbols, {'destination': target}, {}, gp, 0x100000)
        assert problems


def test_cache():
    directory = Path.cwd()
    previous_path = os.environ['PATH']
    with tempfile.TemporaryDirectory() as temporary:
        root = Path(temporary)
        os.chdir(root)
        try:
            for path in ['ps2/src', 'ps2/include', 'ps2/config/pal', 'ps2/cmake',
                         'tools/compilers/mw/3.0-011126', 'bin']:
                Path(path).mkdir(parents=True)
            source = Path('ps2/src/sample.cpp')
            source.write_text('int sample() { return 1; }')
            header = Path('ps2/include/sample.h')
            header.write_text('int sample();')
            Path('ps2/config/pal/gcc_units.txt').touch()
            Path('ps2/cmake/Toolchain.cmake').write_text('set(CC_FLAGS -c -i ${INCLUDE_DIR})')
            Path('tools/compilers/mw/3.0-011126/mwccps2.exe').write_bytes(b'compiler')
            runner = Path('bin/wibo')
            runner.write_text('#!/usr/bin/env python3\n'
                              'import pathlib, sys\n'
                              'source = pathlib.Path(sys.argv[-1]).read_text()\n'
                              'if source == "broken": sys.exit(1)\n'
                              'pathlib.Path(sys.argv[sys.argv.index("-o") + 1]).write_bytes(source.encode())\n')
            runner.chmod(0o755)
            os.environ['PATH'] = str(root / 'bin') + os.pathsep + previous_path
            output, cached = match.compile_unit('sample', False, False)
            assert not cached and output.is_file()
            output, cached = match.compile_unit('sample', False, False)
            assert cached
            canonical, cached = match.compile_unit('sample', False, False, True)
            assert not cached and canonical != output and canonical.read_bytes() == output.read_bytes()
            canonical, cached = match.compile_unit('sample', False, False, True)
            assert cached
            header.write_text('int sample(int);')
            output, cached = match.compile_unit('sample', False, False)
            assert not cached
            output.write_bytes(b'corrupted')
            output, cached = match.compile_unit('sample', False, False)
            assert not cached and output.read_bytes() == source.read_bytes()
            output.with_suffix('.json').write_text('corrupted')
            output, cached = match.compile_unit('sample', False, False)
            assert not cached
            output, cached = match.compile_unit('sample', False, True)
            assert not cached
            source.write_text('broken')
            try:
                match.compile_unit('sample', False, False)
            except ValueError as error:
                assert 'compilation failed' in str(error)
            else:
                raise AssertionError('broken source reused the cache')
            assert not output.exists() and not output.with_suffix('.json').exists()
        finally:
            os.chdir(directory)
            os.environ['PATH'] = previous_path


def test_object(path):
    from mwccgap.elf import Elf

    assert all(row['status'] == 'MATCH' for row in match.compare('mg_camera', path))
    with tempfile.TemporaryDirectory() as temporary:
        changed = Path(temporary) / 'changed.o'
        elf = Elf(path.read_bytes())
        symbol = next(s for s in elf.symtab.symbols if s.name == 'SetPos__9mgCCameraFfff')
        data = bytearray(elf.sections[symbol.st_shndx].data)
        data[0] ^= 1
        elf.sections[symbol.st_shndx].data = bytes(data)
        changed.write_bytes(elf.pack())
        assert match.compare('mg_camera', changed, symbol.name)[0]['status'] == 'DIFF'
        elf = Elf(path.read_bytes())
        symbol = next(s for s in elf.symtab.symbols if s.name == 'StopCamera__9mgCCamera')
        symbol.name = 'save_spectol_fusion_param'
        symbol.st_name = elf.strtab.add_symbol(symbol.name)
        changed.write_bytes(elf.pack())
        for name in ['Step__9mgCCameraFi', 'Step__15mgCCameraFollowFi']:
            row = match.compare('mg_camera', changed, name)[0]
            assert row['status'] != 'MATCH'
            assert any('GP-relative target out of range' in problem for problem in row['problems'])
        elf = Elf(path.read_bytes())
        symbol = next(s for s in elf.symtab.symbols if s.name == 'Stay__9mgCCameraFv')
        record = next(r for r in elf.relocations if r.sh_info == symbol.st_shndx)
        record.relocations[0].symbol_index = next(i for i, s in enumerate(elf.symtab.symbols)
                                                if s.name == 'sceVu0Normalize')
        changed.write_bytes(elf.pack())
        assert match.compare('mg_camera', changed, symbol.name)[0]['status'] == 'DIFF'


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--object', type=Path)
    args = parser.parse_args()
    test_addresses()
    test_literals()
    test_literal_bindings()
    test_relocations()
    test_unresolved()
    test_relocation_ranges()
    test_cache()
    if args.object:
        test_object(args.object)
    print('match checks passed')
