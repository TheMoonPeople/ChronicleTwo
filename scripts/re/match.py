#!/usr/bin/env python3
import argparse
import bisect
import fcntl
import hashlib
import json
import os
import re
import shlex
import shutil
import struct
import subprocess
import sys
import tempfile
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'scripts/build'))
sys.path.insert(0, str(ROOT / 'tools/mwccgap'))

import disassemble
import layout

MASKS = {2: 0xFFFFFFFF, 4: 0x03FFFFFF, 5: 0xFFFF, 6: 0xFFFF, 7: 0xFFFF}


def project_name(name):
    name = re.sub(r'[,<>.$]', '_', name).removesuffix('__DATA')
    return 'at_' + name[1:] if name.startswith('@') else name


def word(data, offset):
    return struct.unpack_from('<I', data, offset)[0]


def signed16(value):
    value &= 0xFFFF
    return value - 0x10000 if value & 0x8000 else value


def compiler_command(unit, output, drafts):
    toolchain = Path('ps2/cmake/Toolchain.cmake').read_text()
    flags = re.search(r'set\(CC_FLAGS\s+([^)]*)\)', toolchain).group(1)
    flags = shlex.split(flags.replace('${INCLUDE_DIR}', 'ps2/include'))
    compiler = Path(os.environ.get('MW_DIR', 'tools/compilers/mw/3.0-011126')) / 'mwccps2.exe'
    command = ['wibo', str(compiler), *flags, '-lang', 'c++']
    for row in Path('ps2/config/pal/gcc_units.txt').read_text().splitlines():
        parts = row.split()
        if parts and parts[0] == unit:
            raise ValueError(f'{unit}: use check_objects.py for EE GCC units')
    command.append('-DMIGRATED_CPP')
    if drafts:
        command.extend(['-DNONMATCHING', '-DUNMATCHING'])
    command.extend(['-o', str(output), f'ps2/src/{unit}.cpp'])
    return command, compiler


def compile_unit(unit, drafts, rebuild, canonical=False):
    directory = Path('build/re/match/canonical' if canonical else 'build/re/match')
    output = directory / ('drafts' if drafts else 'native') / f'{unit}.o'
    output.parent.mkdir(parents=True, exist_ok=True)
    command, compiler = compiler_command(unit, output, drafts)
    runner = shutil.which(command[0])
    if runner is None:
        raise ValueError('wibo is missing; run scripts/re/match.sh in the dev container')
    inputs = [Path(f'ps2/src/{unit}.cpp'), compiler, Path(runner), Path(__file__)]
    expanded = None
    asm_files = []
    if canonical:
        from mwccgap.preprocessor import Preprocessor
        with inputs[0].open() as source:
            lines, asm_files = Preprocessor().preprocess_c_file(source)
        expanded = '\n'.join(lines)
        inputs.extend(path for path, count in asm_files)
        inputs.extend(sorted((ROOT / 'tools/mwccgap/mwccgap').glob('*.py')))
    inputs.extend(sorted(compiler.parent.glob('*')))
    inputs.extend(sorted(Path('ps2/src').rglob('*.h')))
    inputs.extend(sorted(Path('ps2/src').rglob('*.hpp')))
    digest = hashlib.sha256(json.dumps(command).encode())
    if expanded is not None:
        digest.update(expanded.encode())
    includes = os.environ.get('MWCIncludes', 'ps2/include/std;ps2/include/sce')
    digest.update(includes.encode())
    for directory in ['ps2/include', *includes.split(';')]:
        inputs.extend(sorted(Path(directory).rglob('*')))
    for path in sorted(set(inputs)):
        if path.is_file():
            digest.update(str(path).encode())
            digest.update(path.read_bytes())
    fingerprint = digest.hexdigest()
    stamp = output.with_suffix('.json')
    with output.with_suffix('.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        if not rebuild and output.is_file() and stamp.is_file():
            try:
                cached = json.loads(stamp.read_text())
            except json.JSONDecodeError:
                cached = None
            if cached == {'inputs': fingerprint, 'object': hashlib.sha256(output.read_bytes()).hexdigest()}:
                return output, True
        output.unlink(missing_ok=True)
        stamp.unlink(missing_ok=True)
        result = subprocess.run(command, env={**os.environ, 'MWCIncludes': includes},
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        if result.stdout.strip():
            print(result.stdout.replace('\r', '').strip(), file=sys.stderr)
        if result.returncode or not output.is_file():
            output.unlink(missing_ok=True)
            raise ValueError(f'{unit}: compilation failed')
        if asm_files:
            from mwccgap.elf import Elf
            from mwccgap.mwccgap import replace_sinit
            functions = {function.function_name for function in Elf(output.read_bytes()).get_functions()}
            if any(path.stem not in functions for path, count in asm_files):
                with tempfile.NamedTemporaryFile(suffix='.c', dir=inputs[0].parent) as source:
                    source.write(expanded.encode())
                    source.flush()
                    result = subprocess.run([*command[:-1], source.name],
                                            env={**os.environ, 'MWCIncludes': includes},
                                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
                    if result.stdout.strip():
                        print(result.stdout.replace('\r', '').strip(), file=sys.stderr)
                    if result.returncode or not output.is_file():
                        output.unlink(missing_ok=True)
                        raise ValueError(f'{unit}: expanded compilation failed')
                    elf = Elf(output.read_bytes())
                    for symbol in elf.symtab.symbols:
                        if '__sinit_' + Path(source.name).name in symbol.name:
                            symbol.name = replace_sinit(symbol.name, Path(source.name).name, inputs[0].name)
                            symbol.st_name = elf.strtab.add_symbol(symbol.name)
                    output.write_bytes(elf.pack())
        stamp.write_text(json.dumps({'inputs': fingerprint,
                                    'object': hashlib.sha256(output.read_bytes()).hexdigest()}))
    return output, False


def symbol_address(symbol, addresses, sections):
    if 'address' in symbol:
        return symbol['address']
    if symbol['section'] == 0xFFF1:
        return symbol['value']
    if symbol['section'] in sections:
        return sections[symbol['section']] + symbol['value']
    name = project_name(symbol['name'])
    address = addresses.get(name)
    if address is None:
        match = re.fullmatch(r'(?:D_|\.L)([0-9A-Fa-f]{8})', symbol['name'])
        if match:
            address = int(match.group(1), 16)
    return address


def unit_name(name, names, local=False):
    candidates = [candidate for candidate in names
                  if candidate == name or re.fullmatch(re.escape(name) + r'__\d+', candidate)]
    if len(candidates) == 1:
        return candidates[0]
    if local:
        stem = re.sub(r'_\d+$', '', name)
        candidates = [candidate for candidate in names
                      if re.fullmatch(re.escape(stem) + r'_\d+(?:__\d+)?', candidate)]
        if len(candidates) == 1:
            return candidates[0]
    return name


def literal_address(data, regions, relocations, retail_relocations, candidates=False):
    if not data or len({r['offset'] for r in relocations}) != len(relocations):
        return [] if candidates else None
    found = []
    positions = sorted(retail_relocations)
    for start, contents in regions:
        offset = contents.find(data)
        while offset >= 0:
            address = start + offset
            lo = bisect.bisect_left(positions, address)
            hi = bisect.bisect_left(positions, address + len(data))
            actual = {position - address: retail_relocations[position] for position in positions[lo:hi]}
            if actual == {r['offset']: r['type'] for r in relocations}:
                found.append(address)
            offset = contents.find(data, offset + 1)
    if candidates:
        return found
    return found[0] if len(found) == 1 else None


def bind_literals(data, expected, relocations, symbols, gp, retail_relocations):
    resolved = symbols.copy()
    for position, entry in enumerate(relocations):
        index, offset, kind = entry['symbol'], entry['offset'], entry['type']
        candidates = symbols[index].get('candidates', [])
        if (not candidates or resolved[index].get('address') is not None
                or offset < 0 or offset + 4 > min(len(data), len(expected))
                or retail_relocations.get(offset) != kind
                or (word(data, offset) ^ word(expected, offset)) & ~MASKS.get(kind, 0)):
            continue
        if kind == 7:
            target = gp + signed16(word(expected, offset)) - signed16(word(data, offset))
        elif kind == 5:
            partner = next((other for other in relocations[position + 1:]
                            if other['type'] == 6 and other['symbol'] == index), None)
            if partner is None:
                continue
            low = partner['offset']
            if (low < 0 or low + 4 > min(len(data), len(expected))
                    or retail_relocations.get(low) != 6
                    or (word(data, low) ^ word(expected, low)) & 0xFFFF0000):
                continue
            target = ((word(expected, offset) & 0xFFFF) << 16) + signed16(word(expected, low))
            target -= ((word(data, offset) & 0xFFFF) << 16) + signed16(word(data, low))
        else:
            continue
        if target in candidates:
            resolved[index] = {**symbols[index], 'address': target}
    return resolved


def relocate(data, relocations, symbols, addresses, sections, gp, place=0):
    data = bytearray(data)
    problems = []
    original = bytes(data)
    for index, relocation in enumerate(relocations):
        offset, kind = relocation['offset'], relocation['type']
        target_symbol = symbols[relocation['symbol']]
        target = symbol_address(target_symbol, addresses, sections)
        if kind not in MASKS or offset < 0 or offset % 4 or offset + 4 > len(data):
            problems.append(f'unsupported relocation at +0x{offset:X}, type {kind}')
            continue
        if target is None:
            problems.append(f"unresolved {target_symbol['name']} at +0x{offset:X}")
            continue
        value = word(original, offset)
        if kind == 2:
            field = target + value
        elif kind == 4:
            destination = target + ((value & MASKS[kind]) << 2)
            if (destination % 4 or not 0 <= destination <= 0xFFFFFFFF
                    or destination & 0xF0000000 != (place + offset + 4) & 0xF0000000):
                problems.append(f'jump target out of range at +0x{offset:X}')
                continue
            field = destination >> 2
        elif kind == 7:
            field = target + signed16(value) - gp
            if not -32768 <= field <= 32767:
                problems.append(f'GP-relative target out of range at +0x{offset:X}')
                continue
        elif kind == 6:
            field = target + signed16(value)
        else:
            partner = None
            for other in relocations[index + 1:]:
                if other['type'] == 6 and other['symbol'] == relocation['symbol']:
                    partner = other
                    break
            if partner is None:
                problems.append(f'unpaired HI16 at +0x{offset:X}')
                continue
            if partner['offset'] < 0 or partner['offset'] % 4 or partner['offset'] + 4 > len(data):
                problems.append(f'invalid LO16 partner at +0x{offset:X}')
                continue
            addend = ((value & 0xFFFF) << 16) + signed16(word(original, partner['offset']))
            field = (target + addend + 0x8000) >> 16
        mask = MASKS[kind]
        struct.pack_into('<I', data, offset, (value & ~mask) | (field & mask))
    return bytes(data), problems


def compare(unit, path, wanted=None):
    from mwccgap.elf import Elf

    retail = layout.Retail()
    pieces = disassemble.Pieces(references=[])
    functions = {}
    unit_names = set()
    for section, run in pieces.unit(unit):
        unit_names.update(name for name, start, end in run)
        if section in disassemble.CODE_SECTIONS:
            for name, start, end in run:
                functions[name] = (start, end)
    if wanted and wanted not in functions:
        raise ValueError(f'{wanted}: not a function of {unit}')
    addresses = {name: address for address, name, size, function in pieces.symbols.rows}
    raw = path.read_bytes()
    if raw[:7] != b'\x7fELF\x01\x01\x01' or struct.unpack_from('<HH', raw, 16) != (1, 8):
        raise ValueError(f'{path}: expected a little-endian MIPS ELF32 object')
    elf = Elf(raw)
    symbols = [{'name': symbol.name, 'section': symbol.st_shndx, 'value': symbol.st_value}
               for symbol in elf.symtab.symbols]
    sections = {}
    compiled = {}
    for symbol_index, symbol in enumerate(elf.symtab.symbols):
        index = symbol.st_shndx
        if not 0 < index < len(elf.sections) or symbol.type == 3:
            continue
        name = project_name(symbol.name)
        local = '$' in symbol.name and symbol.bind == 0 and symbol.type == 1
        name = unit_name(name, unit_names, local)
        if '$' in symbol.name and name not in unit_names:
            symbols[symbol_index]['address'] = None
            continue
        if symbol.name.startswith('@'):
            symbols[symbol_index]['address'] = None
            continue
        if name in addresses:
            symbols[symbol_index]['address'] = addresses[name]
            sections[index] = addresses[name] - symbol.st_value
        if symbol.type == 2 and name in functions:
            compiled[name] = symbol
    relocations = {}
    for record in elf.relocations:
        relocations.setdefault(record.sh_info, []).extend(
            {'offset': r.r_offset, 'type': r.reloc_type, 'symbol': r.symbol_index}
            for r in record.relocations)
    guards = [address for address, name, size, function in pieces.symbols.rows
              if name in unit_names and size == 1 and re.fullmatch(r'init_\d+(?:__\d+)?', name)
              and layout.section_of(address) in layout.NOBITS]
    guard_indices = []
    for index, symbol in enumerate(elf.symtab.symbols):
        if (re.fullmatch(r'init\$\d+', symbol.name) and symbol.type == 1 and symbol.bind == 0
                and symbol.st_size == 1 and 0 < symbol.st_shndx < len(elf.sections)
                and elf.sections[symbol.st_shndx].sh_type == 8):
            symbols[index]['address'] = None
            symbols[index]['candidates'] = guards
            guard_indices.append(index)
    evidence = {index: set() for index in guard_indices}
    for name, symbol in compiled.items():
        start, end = functions[name]
        data = bytes(elf.sections[symbol.st_shndx].data)
        entries = relocations.get(symbol.st_shndx, [])
        metadata = {address - start: kind for address, kind in retail.relocations.items() if start <= address < end}
        for entry in entries:
            if entry['symbol'] not in evidence or entry['type'] != 7:
                continue
            bound = bind_literals(data, retail.bytes(start, end), [entry], symbols, addresses['_gp'], metadata)
            address = bound[entry['symbol']].get('address')
            if address is not None:
                evidence[entry['symbol']].add(address)
    for index, candidates in evidence.items():
        symbols[index]['address'] = next(iter(candidates)) if len(candidates) == 1 else None
        symbols[index].pop('candidates')
    regions = [(lo, retail.bytes(lo, hi)) for section, lo, hi in pieces.layout.sections(unit)
               if section in ('.rodata', '.sdata', '.data')]
    zero_data = [(address, size) for address, name, size, function in pieces.symbols.rows
                 if name in unit_names and not function and size and layout.section_of(address) in layout.NOBITS]
    for symbol_index, symbol in enumerate(elf.symtab.symbols):
        if not symbol.name.startswith('@') or not 0 < symbol.st_shndx < len(elf.sections) or not symbol.st_size:
            continue
        section = elf.sections[symbol.st_shndx]
        section_name = elf.shstrtab.get_symbol_by_index(section.sh_name)
        if section_name not in ('.rodata', '.sdata', '.data', '.bss', '.sbss'):
            continue
        data = (bytes(symbol.st_size) if section.sh_type == 8 else
                bytes(section.data[symbol.st_value:symbol.st_value + symbol.st_size]))
        entries = [{'offset': r['offset'] - symbol.st_value, 'type': r['type'], 'symbol': r['symbol']}
                   for r in relocations.get(symbol.st_shndx, [])
                   if symbol.st_value <= r['offset'] < symbol.st_value + symbol.st_size]
        resolved, problems = relocate(data, entries, symbols, addresses, sections, addresses['_gp'])
        if not problems:
            candidates = literal_address(resolved, regions, entries, retail.relocations, candidates=True)
            if not entries and resolved and not any(resolved):
                candidates.extend(address for address, size in zero_data if size >= len(resolved)
                                  and address % max(1, section.sh_addralign) == 0)
            symbols[symbol_index]['candidates'] = candidates
            symbols[symbol_index]['address'] = candidates[0] if len(candidates) == 1 else None
    results = []
    for name, (start, end) in functions.items():
        if wanted and name != wanted:
            continue
        row = {'symbol': name, 'address': start, 'retail_size': end - start, 'status': 'ABSENT', 'problems': []}
        symbol = compiled.get(name)
        if symbol is None:
            results.append(row)
            continue
        section = elf.sections[symbol.st_shndx]
        data = bytes(section.data[symbol.st_value:symbol.st_value + symbol.st_size])
        row['size'] = len(data)
        ours = relocations.get(symbol.st_shndx, [])
        if symbol.st_value or len(data) != len(section.data):
            row['problems'].append('function shares a section; use check_objects.py')
            row['status'] = 'UNRESOLVED'
            results.append(row)
            continue
        expected = retail.bytes(start, end)
        theirs = {address - start: kind for address, kind in retail.relocations.items() if start <= address < end}
        function_symbols = bind_literals(data, expected, ours, symbols, addresses['_gp'], theirs)
        resolved, problems = relocate(data, ours, function_symbols, addresses, sections, addresses['_gp'], start)
        row['problems'].extend(problems)
        row['status'] = 'UNRESOLVED' if problems else 'MATCH'
        padded = resolved + bytes(max(0, len(expected) - len(resolved)))
        row['words_differ'] = sum(padded[i:i + 4] != expected[i:i + 4]
                                 for i in range(0, max(len(padded), len(expected)), 4))
        mine = {}
        for entry in ours:
            offset = entry['offset']
            target = symbols[entry['symbol']]
            if (offset not in theirs and entry['type'] == 7 and target['name'] == '_gp'
                    and symbol_address(target, addresses, sections) == addresses['_gp']
                    and 0 <= offset <= len(data) - 4 and signed16(word(data, offset)) == 0):
                continue
            mine[offset] = entry['type']
        duplicate_relocations = len({r['offset'] for r in ours}) != len(ours)
        if mine != theirs:
            row['problems'].append('relocation offsets or types differ')
        if duplicate_relocations:
            row['problems'].append('duplicate relocation offsets')
        if len(data) > end - start or end - start > (len(data) + 15) // 16 * 16:
            row['problems'].append('function size differs after alignment')
        if section.sh_addralign != 16:
            row['problems'].append('function alignment differs from retail')
        if (row['words_differ'] or mine != theirs or duplicate_relocations
                or section.sh_addralign != 16 or any('size differs' in p for p in row['problems'])):
            row['status'] = 'DIFF'
        if wanted:
            row['retail_words'] = [f'{word(expected, i):08X}' for i in range(0, len(expected), 4)]
            row['compiled_words'] = [f'{word(padded, i):08X}' for i in range(0, len(padded), 4)]
        results.append(row)
    return results


def main():
    os.chdir(ROOT)
    parser = argparse.ArgumentParser(description='Compile one migrated unit and compare its functions with retail.')
    parser.add_argument('unit')
    parser.add_argument('--symbol')
    parser.add_argument('--object', type=Path, help='compare an existing object without compiling')
    parser.add_argument('--drafts', action='store_true', help='also enable NONMATCHING and UNMATCHING')
    parser.add_argument('--rebuild', action='store_true')
    parser.add_argument('--canonical', action='store_true', help='use the build\'s expanded placeholder source')
    parser.add_argument('--json', action='store_true')
    args = parser.parse_args()
    start = time.perf_counter()
    try:
        if layout.Layout().kinds.get(args.unit) != 'cpp':
            raise ValueError(f'{args.unit}: not a C++ unit')
        cached = False
        if args.object:
            output = args.object
        else:
            output, cached = compile_unit(args.unit, args.drafts, args.rebuild, args.canonical)
        results = compare(args.unit, output, args.symbol)
    except (ValueError, OSError, ImportError, struct.error) as error:
        print(str(error), file=sys.stderr)
        return 2
    counts = {status: sum(row['status'] == status for row in results)
              for status in ['MATCH', 'DIFF', 'UNRESOLVED', 'ABSENT']}
    report = {'unit': args.unit, 'object': str(output), 'cached': cached,
              'seconds': round(time.perf_counter() - start, 3), 'counts': counts, 'functions': results}
    if args.json:
        print(json.dumps(report, indent=2))
    else:
        for row in results:
            if row['status'] == 'ABSENT' and not args.symbol:
                continue
            detail = f", {row['words_differ']} words differ" if row.get('words_differ') else ''
            print(f"{row['status']:<10} {row['symbol']}{detail}")
            for problem in row['problems']:
                print(f'           {problem}')
        print(f"{args.unit}: {counts}, {report['seconds']:.3f}s" + (' (cached)' if cached else ''))
    return 0 if counts['MATCH'] and not counts['DIFF'] and not counts['UNRESOLVED'] and not (args.symbol and counts['ABSENT']) else 1


if __name__ == '__main__':
    sys.exit(main())
