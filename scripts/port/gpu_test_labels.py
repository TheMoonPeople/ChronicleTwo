"""Reject unlabelled tests that directly create a device or use a renderer-owning fixture.

This is a cheap source guard, not a C++ call graph: indirect helper calls still need review.
Parameterized tests are checked with their discovery prefix and value suffix.
"""

import argparse
import fnmatch
import re
from pathlib import Path


def block(code, opening):
    depth = 1
    for end in range(opening + 1, len(code)):
        depth += (code[end] == '{') - (code[end] == '}')
        if depth == 0:
            return code[opening + 1:end]
    raise ValueError('unclosed test or fixture body')


def device_tests(path):
    code = path.read_text(encoding='utf-8')
    # Numeric tokens consume digit separators before character-literal handling.
    code = re.sub(r'//[^\n]*|/\*.*?\*/|"(?:\\.|[^"\\])*"|\b[0-9][\w.\']*|(?:u8|u|U|L)?\'(?:\\.|[^\'\\\r\n])*\'',
                  ' ', code, flags=re.S)
    device = re.compile(r'\b(?:GfxFixture|RendererInit)\b')
    fixtures = set()
    for match in re.finditer(r'\b(?:class|struct)\s+(\w+)[^;{]*\{', code):
        if device.search(block(code, match.end() - 1)):
            fixtures.add(match[1])
    for match in re.finditer(r'\b(TEST(?:_F|_P)?)\s*\(\s*(\w+)\s*,\s*(\w+)\s*\)\s*\{', code):
        body = block(code, match.end() - 1)
        owns_renderer = any(re.search(rf'\b{fixture}\b', body) for fixture in fixtures)
        if device.search(body) or owns_renderer or match[2] in fixtures:
            name = f'{match[2]}.{match[3]}'
            yield f'Parameters/{name}/0' if match[1] == 'TEST_P' else name


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('roots', type=Path, nargs='+')
    parser.add_argument('--filters', required=True)
    parser.add_argument('--cpu-filters', default='')
    args = parser.parse_args()
    filters = args.filters.split(':')
    cpu_filters = args.cpu_filters.split(':')
    missing = []
    for root in args.roots:
        for path in sorted(root.rglob('*_test.cpp')):
            for name in device_tests(path):
                if any(fnmatch.fnmatchcase(name, pattern) for pattern in cpu_filters):
                    missing.append(f'{path.name}: {name} creates a device but has a CPU exemption')
                elif not any(fnmatch.fnmatchcase(name, pattern) for pattern in filters):
                    missing.append(f'{path.name}: {name} needs a gpu filter')
    if missing:
        parser.exit(1, '\n'.join(missing) + '\n')


if __name__ == '__main__':
    main()
