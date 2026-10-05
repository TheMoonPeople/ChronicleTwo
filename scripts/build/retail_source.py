import argparse
import os
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))

import disassemble
import layout


def arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('--unit', required=True)
    parser.add_argument('--output', type=Path, required=True)
    return parser.parse_args()


def prepare_assembly(unit, pieces):
    retail = layout.Retail()
    resolver = disassemble.Resolver(pieces.defined())
    disassemble.write_unit_files(pieces, retail, resolver, unit)
    for section, run in pieces.unit(unit):
        if section not in disassemble.CODE_SECTIONS:
            continue
        for name, start, end in run:
            target = ROOT / disassemble.NONMATCHINGS / unit / (name + '.s')
            if target.is_file():
                continue
            matching = ROOT / disassemble.MATCHINGS / unit / (name + '.s')
            if not matching.is_file():
                raise ValueError(f'{unit}: assembly for {name} is missing; rerun disassemble.py')
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(matching, target)


def retail_source(unit, pieces):
    folder = str(disassemble.NONMATCHINGS / unit)
    lines = ['#include "common.h"', '']
    for section, run in pieces.unit(unit):
        for name, start, end in run:
            if not re.fullmatch(r'[A-Za-z_$][\w$]*', name) or end <= start:
                raise ValueError(f'{unit}: invalid retail piece {name}')
            if section in disassemble.CODE_SECTIONS:
                lines.append(f'INCLUDE_ASM("{folder}", {name});')
            elif section in disassemble.DATA_SECTIONS:
                lines.append(f'INCLUDE_RODATA("{folder}", {disassemble.placeholder(name)});')
            elif section in disassemble.BSS_SECTIONS:
                lines.append(f'INCLUDE_BSS({name}, 0x{end - start:X});')
            else:
                raise ValueError(f'{unit}: unsupported retail section {section}')
        lines.append('')
    return '\n'.join(lines).rstrip() + '\n'


def main():
    args = arguments()
    os.chdir(ROOT)
    native_layout = layout.Layout()
    if native_layout.kinds.get(args.unit) != 'cpp':
        raise ValueError(f'{args.unit}: not a native cpp unit')
    output = args.output.resolve()
    if not output.is_relative_to((ROOT / 'build').resolve()):
        raise ValueError('output must be inside the ignored build directory')
    pieces = disassemble.Pieces(native_layout)
    source = retail_source(args.unit, pieces)
    prepare_assembly(args.unit, pieces)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(source)
    print(output)
    return 0


if __name__ == '__main__':
    sys.exit(main())
