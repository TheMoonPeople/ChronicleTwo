#!/usr/bin/env python3
"""Track source identities and fallback classification that affect the global split."""

import argparse
import json
from pathlib import Path
import re

from disassemble import source_addresses


# The pinned splat CommonSegC classifier preserves literals while stripping
# comments, then identifies source definitions and include-macro symbols.
SOURCE_COMMENTS = re.compile(
    r'//.*?$|/\*.*?\*/|\'(?:\\.|[^\\\'])*\'|"(?:\\.|[^\\"])*"',
    re.MULTILINE | re.DOTALL)
SOURCE_FUNCTIONS = re.compile(
    r'^(?:static\s+)?[^\s]+\s+([^\s(]+)\(([^;)]*)\)[^;]+?{',
    re.MULTILINE | re.DOTALL)


def source_split_signature(source):
    """Mirror splat's per-source function and fallback classification inputs."""
    text = SOURCE_COMMENTS.sub(
        lambda match: ' ' if match.group(0).startswith('/') else match.group(0), source)

    def include_symbols(macro):
        names = set()
        offset = 0
        prefix = macro + '('
        while True:
            start = text.find(prefix, offset)
            if start < 0:
                return sorted(names)
            end = start + len(prefix)
            depth = 0
            while end < len(text):
                if text[end] == '(':
                    depth += 1
                elif text[end] == ')':
                    if not depth:
                        break
                    depth -= 1
                end += 1
            if end == len(text):
                raise ValueError(f'Unterminated {macro} source marker')
            arguments = text[start:end + 1].split(',')
            if len(arguments) >= 2:
                names.add(arguments[1].strip(' )'))
            offset = start + len(prefix)

    return (sorted({match.group(1) for match in SOURCE_FUNCTIONS.finditer(text)}),
            include_symbols('INCLUDE_ASM'), include_symbols('INCLUDE_RODATA'))


def write_source_cuts(output, sources):
    """Preserve the timestamp when address cuts and source classification stay intact."""
    addresses = set()
    signatures = {}
    for source in sources:
        contents = source.read_text(encoding='utf-8')
        addresses.update(source_addresses(contents))
        signatures[str(source)] = source_split_signature(contents)
    text = ''.join(f'D_{address:08X}\n' for address in sorted(addresses))
    text += ''.join('SOURCE ' + json.dumps([source, *signature]) + '\n'
                    for source, signature in sorted(signatures.items()))
    if output.is_file() and output.read_text(encoding='utf-8') == text:
        return False
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(text, encoding='utf-8')
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('output', type=Path)
    parser.add_argument('sources', type=Path, nargs='+')
    args = parser.parse_args()
    write_source_cuts(args.output, args.sources)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
