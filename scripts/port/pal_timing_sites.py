#!/usr/bin/env python3
"""Check the committed, ordered manifest of executable PAL_TIMING sites."""
import argparse
from pathlib import Path
import re
import sys
import unittest

from pal_timing_identity import arguments, literal_end, tokens

ROOT = Path(__file__).resolve().parents[2]
MANIFEST = Path(__file__).with_suffix(".txt")
IDENTIFIER = re.compile(r'[A-Za-z_]\w*')
FUNCTION = re.compile(r'^[ \t]*(?:[\w:*<>]+[ \t\n]+)+((?:\w+::)*\w+)\s*\([^;{}]*\)\s*(?:const\s*)?\{', re.MULTILINE)


def sites(text):
    index = 0
    while index < len(text):
        end = literal_end(text, index)
        if end != index:
            index = end
            continue
        identifier = IDENTIFIER.match(text, index)
        if identifier:
            end = index + len(identifier.group())
            if identifier.group() == "PAL_TIMING":
                opening = end
                while opening < len(text) and text[opening].isspace():
                    opening += 1
                if opening >= len(text) or text[opening] != "(":
                    raise ValueError("PAL_TIMING requires two arguments")
                pal, ntsc, end = arguments(text, opening)
                if tokens(pal) == tokens(ntsc):
                    raise ValueError("PAL_TIMING arguments must differ")
                yield index, end
            index = end
        else:
            index += 1


def enclosing_functions(text):
    # Mask comments/literals before identifying signatures and matching body braces.
    masked = list(text)
    index = 0
    while index < len(text):
        end = literal_end(text, index)
        if end != index:
            masked[index:end] = ['\n' if c == '\n' else ' ' for c in text[index:end]]
            index = end
        else:
            index += 1
    masked = ''.join(masked)
    for match in FUNCTION.finditer(masked):
        depth = 1
        end = match.end()
        while end < len(masked) and depth:
            depth += (masked[end] == '{') - (masked[end] == '}')
            end += 1
        yield match.start(), end, match.group(1)


def entries(path, text):
    functions = list(enclosing_functions(text))
    for start, end in sites(text):
        function = next((name for a, b, name in functions if a <= start < b), None)
        if function is None:
            prefix = text[:start]
            macro = re.search(r'^\s*#define\s+(\w+)[^\n]*(?:\\\n[^\n]*)*\Z', prefix, re.MULTILINE)
            if macro is None:
                raise ValueError(f"site at line {text.count(chr(10), 0, start) + 1} has no enclosing function or macro")
            function = '#define ' + macro.group(1)
        yield f"{path}\t{function}\t{' '.join(tokens(text[start:end]))}"


def collect(root):
    result = []
    for directory in (root / "ps2/src", root / "port/src"):
        for path in sorted(directory.rglob("*")):
            if path.suffix not in {".c", ".cpp", ".h", ".hpp", ".inc"}:
                continue
            text = path.read_bytes().decode("latin-1")
            if "PAL_TIMING" in text:
                result.extend(entries(path.relative_to(root).as_posix(), text))
    return result


class SitesTest(unittest.TestCase):
    def test_pins_pairs_order_functions_and_paths(self):
        text = 'void First() { a = PAL_TIMING(25, 30); b = PAL_TIMING(50, 60); }\n'
        expected = list(entries('a.cpp', text))
        for changed in (text.replace('25, 30', '25, 31'),
                        text.replace('25, 30', '25, 60').replace('50, 60', '50, 30'),
                        text.replace('a = PAL_TIMING(25, 30);', ''),
                        text.replace('First', 'Second'),
                        text.replace('25, 30', '50, 60').replace('b = PAL_TIMING(50, 60)', 'b = PAL_TIMING(25, 30)'),
                        text + '\nvoid Extra() { c = PAL_TIMING(1, 2); }'):
            with self.subTest(changed=changed):
                self.assertNotEqual(list(entries('a.cpp', changed)), expected)
        self.assertNotEqual(list(entries('b.cpp', text)), expected)
        self.assertEqual(list(entries('a.cpp', text.replace('25, 30', '25,   30'))), expected)

    def test_ignores_comments_and_literals(self):
        self.assertEqual(list(sites('// PAL_TIMING(1, 2)\n"PAL_TIMING(3, 4)"')), [])
        for text in ('PAL_TIMING(1, 1)', 'PAL_TIMING(1)', 'PAL_TIMING(1, 2, 3)'):
            with self.subTest(text=text), self.assertRaises(ValueError):
                list(sites(text))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--regenerate', action='store_true', help='explicitly replace the reviewed manifest')
    parser.add_argument('--self-test', action='store_true')
    args = parser.parse_args()
    if args.self_test:
        return 0 if unittest.TextTestRunner().run(unittest.defaultTestLoader.loadTestsFromTestCase(SitesTest)).wasSuccessful() else 1
    try:
        actual = collect(ROOT)
        if args.regenerate:
            MANIFEST.write_text('\n'.join(actual) + '\n', encoding='utf-8')
            print(f"PAL_TIMING manifest: wrote {len(actual)} reviewed sites")
            return 0
        expected = MANIFEST.read_text(encoding='utf-8').splitlines()
        if actual != expected:
            import difflib
            print('PAL_TIMING site manifest mismatch (missing, extra, changed or reordered site):', file=sys.stderr)
            print('\n'.join(difflib.unified_diff(expected, actual, fromfile='expected', tofile='actual', lineterm='')), file=sys.stderr)
            return 1
        print(f"PAL_TIMING sites: {len(actual)}; expected {len(expected)}; paths, functions and ordered pairs match")
        return 0
    except (ValueError, OSError) as error:
        print(f"PAL_TIMING sites: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
