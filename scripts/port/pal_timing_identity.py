#!/usr/bin/env python3
"""Require hunks changing PAL_TIMING calls to preserve the baseline PS2 tokens."""
import argparse
from collections import Counter
import difflib
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import unittest

TOKEN = re.compile(r'\w+|>>=|<<=|->\*|\.\.\.|::|->|\+\+|--|&&|\|\||[+*/%&|^!=<>-]=|<<|>>|.')

def literal_end(text, start):
    """Skip comments and C++ literals, including escaped and raw strings."""
    if text.startswith("//", start):
        end = text.find("\n", start + 2)
        return len(text) if end < 0 else end
    if text.startswith("/*", start):
        end = text.find("*/", start + 2)
        if end < 0:
            raise ValueError("unterminated comment")
        return end + 2
    for prefix in ('R"', 'u8R"', 'uR"', 'UR"', 'LR"'):
        if not text.startswith(prefix, start):
            continue
        delimiter_start = start + len(prefix)
        opening = text.find("(", delimiter_start)
        if opening < 0 or opening - delimiter_start > 16:
            raise ValueError("invalid raw string")
        delimiter = text[delimiter_start:opening]
        closing = ")" + delimiter + '"'
        end = text.find(closing, opening + 1)
        if end < 0:
            raise ValueError("unterminated raw string")
        return end + len(closing)
    if text[start] in "\"'":
        quote = text[start]
        index = start + 1
        while index < len(text):
            if text[index] == "\\":
                index += 2
            elif text[index] == quote:
                return index + 1
            else:
                index += 1
        raise ValueError("unterminated literal")
    return start


def arguments(text, opening):
    stack = [")"]
    comma = None
    index = opening + 1
    pairs = {"(": ")", "[": "]", "{": "}"}
    while index < len(text):
        end = literal_end(text, index)
        if end != index:
            index = end
            continue
        char = text[index]
        if char in pairs:
            stack.append(pairs[char])
        elif char in ")]}":
            if char != stack.pop():
                raise ValueError("unbalanced PAL_TIMING argument")
            if not stack:
                if comma is None:
                    raise ValueError("PAL_TIMING requires two arguments")
                if not text[comma + 1:index].strip():
                    raise ValueError("empty NTSC argument")
                pal = text[opening + 1:comma].strip()
                if not pal:
                    raise ValueError("empty PAL argument")
                return pal, text[comma + 1:index].strip(), index + 1
        elif char == "," and len(stack) == 1:
            if comma is not None:
                raise ValueError("PAL_TIMING requires exactly two arguments")
            comma = index
        index += 1
    raise ValueError("unterminated PAL_TIMING")


def restore(data):
    # latin-1 is a bijection over bytes; CRLF and non-UTF-8 bytes remain untouched.
    text = data.decode("latin-1")
    result = []
    index = 0
    while index < len(text):
        if index == 0 or text[index - 1] == "\n":
            include = re.match(r'[ \t]*#[ \t]*include[ \t]+"pal_timing\.hpp"[ \t]*(?:\r?\n|$)', text[index:])
            if include:
                index += include.end()
                continue
        end = literal_end(text, index)
        if end != index:
            result.append(text[index:end])
            index = end
            continue
        if text[index].isalpha() or text[index] == "_":
            end = index + 1
            while end < len(text) and (text[end].isalnum() or text[end] == "_"):
                end += 1
            if text[index:end] == "PAL_TIMING":
                opening = end
                while opening < len(text) and text[opening].isspace():
                    opening += 1
                if opening < len(text) and text[opening] == "(":
                    pal, _, end = arguments(text, opening)
                    replacement = restore(pal.encode("latin-1")).decode("latin-1")
                    result.append(replacement)
                    index = end
                    continue
            result.append(text[index:end])
            index = end
            continue
        result.append(text[index])
        index += 1
    return "".join(result).encode("latin-1")


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args])


def token_lines(text):
    """Ignore spacing between tokens, preserving spacing inside literals/comments."""
    result = [[]]
    index = 0
    while index < len(text):
        end = literal_end(text, index)
        if end != index:
            parts = text[index:end].split("\n")
            result[-1].append(parts[0])
            for part in parts[1:]:
                result.append([part])
        elif text[index].isspace():
            end = index + 1
            if text[index] == "\n":
                result.append([])
        else:
            token = TOKEN.match(text, index)
            end = index + len(token.group())
            result[-1].append(text[index:end])
        index = end
    return [tuple(line) for line in result]


def tokens(text):
    return tuple(token for line in token_lines(text) for token in line)


class Source:
    """Lex a complete file, retaining call spans and restored token positions."""

    def __init__(self, text):
        self.rows = []
        self.calls = []
        self.scan(text)

    def scan(self, text):
        line = 1
        index = 0
        while index < len(text):
            if index == 0 or text[index - 1] == "\n":
                include = re.match(r'[ \t]*#[ \t]*include[ \t]+"pal_timing\.hpp"[^\n]*(?:\n|$)', text[index:])
                if include:
                    end = index + include.end()
                    line += text[index:end].count("\n")
                    index = end
                    continue
            end = literal_end(text, index)
            if end != index:
                last = line + text[index:end].count("\n")
                if not text.startswith(("//", "/*"), index):
                    self.rows.append((text[index:end], line, last))
            elif text[index].isspace():
                end = index + 1
                last = line + (text[index] == "\n")
            else:
                token = TOKEN.match(text, index)
                end = token.end()
                last = line
                if token.group() == "PAL_TIMING":
                    opening = end
                    while opening < len(text) and text[opening].isspace():
                        opening += 1
                    if opening < len(text) and text[opening] == "(":
                        pal, _, end = arguments(text, opening)
                        last = line + text[index:end].count("\n")
                        first = len(self.rows)
                        restored = Source(restore(pal.encode("latin-1")).decode("latin-1"))
                        self.rows.extend((value, line, last) for value, _, _ in restored.rows)
                        self.calls.append((line, last, tokens(text[index:end]), first, len(self.rows)))
                    else:
                        self.rows.append((token.group(), line, last))
                else:
                    self.rows.append((token.group(), line, last))
            line = last
            index = end


def overlaps(first, last, start, count):
    return count > 0 and first < start + count and last >= start


def hunk_side(source, start, count):
    calls = [call for call in source.calls if overlaps(call[0], call[1], start, count)]
    # Include complete multiline calls even when only one argument line changed.
    first = min([start] + [call[0] for call in calls])
    last = max([start + count - 1] + [call[1] for call in calls])
    selected = [(index, value) for index, (value, low, high) in enumerate(source.rows)
                if count and low <= last and high >= first]
    offset = selected[0][0] if selected else 0
    return [value for _, value in selected], calls, offset


def preserves_hunk(before, after, old_start, old_count, new_start, new_count):
    old, old_calls, old_offset = hunk_side(before, old_start, old_count)
    new, new_calls, new_offset = hunk_side(after, new_start, new_count)
    # No fragment is ever lexed; irrelevant hunks and unchanged calls pass.
    if Counter(call[2] for call in old_calls) == Counter(call[2] for call in new_calls):
        return True
    blocks = difflib.SequenceMatcher(a=old, b=new, autojunk=False).get_matching_blocks()
    boundaries = {";", "{", "}"}
    for values, calls, offset, side in ((old, old_calls, old_offset, 0), (new, new_calls, new_offset, 1)):
        for _, _, _, first, last in calls:
            first -= offset
            last -= offset
            # Keep the wrapper's own statement intact, while permitting a
            # neighboring statement's unrelated edit in the same hunk or line.
            while first > 0 and values[first - 1] not in boundaries:
                first -= 1
            while last < len(values) and values[last] not in boundaries:
                last += 1
            def same_position(block):
                if not (block[side] <= first and last <= block[side] + block.size):
                    return False
                other = new if side == 0 else old
                peer = block[1 - side] + first - block[side]
                return sum(value in boundaries for value in values[:first]) == sum(
                    value in boundaries for value in other[:peer])

            if not any(same_position(block) for block in blocks):
                return False
    return True


def hunks(diff):
    for line in diff.splitlines():
        match = re.match(r'@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@', line)
        if match:
            old, old_count, new, new_count = match.groups()
            yield int(old), int(old_count or 1), int(new), int(new_count or 1)


def preserves(before, after, diff=None):
    before = before.decode("latin-1")
    after = after.decode("latin-1")
    if diff is None:
        diff = "".join(difflib.unified_diff(before.splitlines(keepends=True),
                                         after.splitlines(keepends=True), n=0))
    old, new = Source(before), Source(after)
    return all(preserves_hunk(old, new, *span) for span in hunks(diff))


def check(root, base):
    # Comparing the working tree also catches uncommitted wrappers and accidental edits.
    changed = [name for name in git(root, "diff", "--name-only", "-z", base, "--", "ps2/").split(b"\0")
               if name and Path(name.decode()).suffix in {".c", ".cpp", ".h", ".hpp", ".inc"}
               and name != b"ps2/include/pal_timing.hpp"]
    mismatches = []
    for name in filter(None, changed):
        path = name.decode("utf-8")
        try:
            exists = subprocess.run(["git", "-C", str(root), "cat-file", "-e", f"{base}:{path}"], capture_output=True)
            if exists.returncode != 0:
                print(f"PAL_TIMING source identity: new file {path} skipped; ps2-pal and verify.py are authoritative")
                continue
            before = git(root, "show", f"{base}:{path}")
            target = root / path
            after = target.read_bytes() if target.exists() else b""
            # Lex complete files once; Git bounds the token alignment to each hunk.
            diff = git(root, "diff", "--no-ext-diff", "--unified=0", base, "--", path).decode("latin-1")
            if not preserves(before, after, diff):
                mismatches.append(path)
        except (ValueError, OSError, subprocess.CalledProcessError) as error:
            mismatches.append(f"{path}: {error}")
    if mismatches:
        print("PAL_TIMING source identity mismatches:", file=sys.stderr)
        print("\n".join(mismatches), file=sys.stderr)
        return 1
    print(f"PAL_TIMING source identity: {len(list(filter(None, changed)))} changed files match {base}")
    return 0


def baseline(root, base):
    try:
        if not base:
            raise ValueError("an explicit baseline is required")
        return git(root, "rev-parse", "--verify", f"{base}^{{commit}}").decode().strip()
    except (ValueError, subprocess.CalledProcessError):
        print(f"ERROR: PAL_TIMING source identity: baseline/history unavailable ({base}); "
              "fetch history and provide an explicit base", file=sys.stderr)
        return None


class IdentityTest(unittest.TestCase):
    def test_real_room_comment_edit(self):
        before = (Path(__file__).resolve().parents[2] / "ps2/src/dngmenu.cpp").read_bytes()
        old = b"Draws the selected room's floor information"
        self.assertIn(old, before)
        self.assertTrue(preserves(before, before.replace(old, b"Draws the selected room's floor details")))

    def test_block_comment_opening_without_wrappers(self):
        self.assertTrue(preserves(b"/* summary\n * text\n */\nint a = 1;\n",
                                  b"/* new summary\n * text\n */\nint a = 1;\n"))

    def test_multiline_lexical_context_around_wrapper(self):
        before = (b"/* room's\n PAL_TIMING(1, 2)\n */\n"
                  b'const char *text = R"tag(\nPAL_TIMING(3, 4)\n)tag";\n'
                  b"int a = 25; /* room's\n floor */\n")
        after = before.replace(b"room's", b"rooms'").replace(b"(3, 4)", b"(5, 6)")
        after = after.replace(b"a = 25", b"a = PAL_TIMING(\n25,\n30)")
        self.assertTrue(preserves(before, after))
        self.assertFalse(preserves(before, after.replace(b"\n25,", b"\n26,")))

    def test_wrap_sharing_hunk_with_unrelated_edit(self):
        for before, after in [
                (b"a = 25;\nb = 7;\n", b"a = PAL_TIMING(25, 30);\nb = 8;\n"),
                (b"a = 25; b = 7;\n", b"a = PAL_TIMING(25, 30); b = 8;\n")]:
            self.assertTrue(preserves(before, after))
            self.assertFalse(preserves(before, after.replace(b"(25,", b"(26,")))

    def test_added_wrapper_line_is_rejected(self):
        before = b"int a = 25;\n"
        self.assertFalse(preserves(before, before + b"int b = PAL_TIMING(25, 30);\n"))
        self.assertFalse(preserves(b"a = 25;\n", b"a = 26;\na = PAL_TIMING(25, 30);\n"))

    def test_missing_history_fails(self):
        with tempfile.TemporaryDirectory() as directory:
            subprocess.check_call(["git", "init", "--quiet", directory])
            self.assertIsNone(baseline(Path(directory), "missing-upstream"))

    def test_unrelated_later_edit(self):
        before = b'int a = PAL_TIMING(25, 30);\n'
        self.assertTrue(preserves(before, before + b'// later change\nint b = 1;\n'))
        self.assertTrue(preserves(b'int b = 0;\n' + before, b'int b = 1;\n' + before))

    def test_changed_pal_token(self):
        self.assertFalse(preserves(b'int a = 25;\n', b'int a = PAL_TIMING(26, 30);\n'))
        self.assertFalse(preserves(b'int a = PAL_TIMING(25, 30);\n', b'int a = PAL_TIMING(26, 30);\n'))
        self.assertFalse(preserves(b'int a = 25;\n', b'int changed = PAL_TIMING(25, 30);\n'))

    def test_removed_and_moved_wrappers(self):
        before = b'int a = PAL_TIMING(200, 240);\nint b = 130;\n'
        self.assertFalse(preserves(before, b'int a = 201;\nint b = PAL_TIMING(130, 156);\n'))
        self.assertFalse(preserves(before, b'int a = 201;\nint b = 130;\n'))
        self.assertTrue(preserves(before, b'int a = 200;\nint b = 130;\n'))

    def test_later_rename_with_unchanged_calls(self):
        self.assertTrue(preserves(b'blink_cnt >= PAL_TIMING(25, 30);\n',
                                  b'blink_count >= PAL_TIMING(25, 30);\n'))

    def test_new_file_is_skipped(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            subprocess.check_call(["git", "init", "--quiet", directory])
            subprocess.check_call(["git", "-C", directory, "-c", "user.name=Fixture",
                                   "-c", "user.email=fixture@example.invalid", "commit", "--quiet", "--allow-empty", "-m", "base"])
            (root / "ps2/src").mkdir(parents=True)
            (root / "ps2/src/new.cpp").write_text("int a = PAL_TIMING(25, 30);\n")
            subprocess.check_call(["git", "-C", directory, "add", "."])
            self.assertEqual(check(root, "HEAD"), 0)

    def test_whitespace_realignment(self):
        self.assertTrue(preserves(b'#define F(n) \\\n  ((n) * 5 / 6) \\\n  + 1\n',
                                  b'#define F(n)             \\\n  PAL_TIMING(((n) * 5 / 6), (n)) \\\n  + 1\n'))

    def test_synthetic_pair(self):
        before = b'float a = fn(1, 2);\r\nconst char *b = "x,)\\\"";\r\n'
        after = (b'#include "pal_timing.hpp"\r\n'
                 b'float a = PAL_TIMING(fn(1, 2), fn(3, 4));\r\n'
                 b'const char *b = PAL_TIMING("x,)\\\"", "y");\r\n')
        self.assertEqual(restore(after), before)

    def test_comments_literals_nested_and_bytes(self):
        text = b'// PAL_TIMING(a,b)\n/* PAL_TIMING(c,d) */\n"PAL_TIMING(e,f)"\n'
        self.assertEqual(restore(text), text)
        raw = b'R"(\n#include "pal_timing.hpp"\n)"'
        self.assertEqual(restore(raw), raw)
        prefixed = b'u8R"tag( " PAL_TIMING(a,b) )tag"'
        self.assertEqual(restore(prefixed), prefixed)
        self.assertEqual(restore(b'PAL_TIMING(PAL_TIMING(5, 6), f("a,b"))'), b'5')
        self.assertEqual(restore(b'PAL_TIMING(R"tag(a, ) b)tag", "n")'), b'R"tag(a, ) b)tag"')
        self.assertEqual(restore(b'\xff PAL_TIMING((a + b), array[i, j])\r\n'), b'\xff (a + b)\r\n')
        self.assertEqual(restore(b'MY_PAL_TIMING(a,b)'), b'MY_PAL_TIMING(a,b)')

    def test_rejects_broken_wrappers(self):
        for text in [b'PAL_TIMING(a)', b'PAL_TIMING(a,b,c)', b'PAL_TIMING(a,b',
                     b'PAL_TIMING(,b)', b'PAL_TIMING(a,)', b'PAL_TIMING((a],b)']:
            with self.subTest(text=text), self.assertRaises(ValueError):
                restore(text)

    def test_unrelated_edits_are_not_erased(self):
        self.assertNotEqual(restore(b'int a = PAL_TIMING(51, 60);\n'), b'int a = 50;\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("base", nargs="?")
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        suite = unittest.defaultTestLoader.loadTestsFromTestCase(IdentityTest)
        return 0 if unittest.TextTestRunner().run(suite).wasSuccessful() else 1
    root = args.root.resolve()
    base = baseline(root, args.base)
    return check(root, base) if base else 1


if __name__ == "__main__":
    sys.exit(main())
