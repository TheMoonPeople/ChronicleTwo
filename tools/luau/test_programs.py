"""Checks tools/luau/programs.json against the program enums of the PS2 headers."""

import json
import re
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
sys.path.insert(0, str(HERE))

from stb2luau.emit import SETUP, handlers  # noqa: E402

MANIFEST = HERE / "programs.json"
ENTRY = re.compile(r"^\s*(\w+)\s*=\s*(-?\d+),?\s*/\*\*<\s*(.*?)\s*\*/", re.MULTILINE)
NAME = re.compile(r"[a-z][a-z0-9_]*")
LUAU_KEYWORDS = frozenset(
    "and break continue do else elseif end export false for function if in local nil not or repeat return then "
    "true type until while".split()
)


def enum_programs(header: str, enum: str) -> dict[int, tuple[str, str]]:
    """Each non-negative entry of an enum in a header, as number to (entry name, doc comment text)."""
    text = (REPO / header).read_text(encoding="utf-8")
    body = re.search(r"enum\s+(?:class\s+)?" + enum + r"(?:\s*:\s*\w+)?\s*\{(.*?)\};", text, re.DOTALL)
    if body is None:
        raise AssertionError(f"enum {enum} not found in {header}")
    return {int(value): (name, desc) for name, value, desc in ENTRY.findall(body.group(1)) if int(value) >= 0}


class ProgramsTest(unittest.TestCase):
    def setUp(self):
        self.data = json.loads(MANIFEST.read_text(encoding="utf-8"))

    def test_schema(self):
        self.assertEqual(self.data["schema"], 1)
        self.assertEqual(sorted(self.data["kinds"]), ["action", "effect", "monster"])

    def test_entries_match_headers(self):
        for kind, info in self.data["kinds"].items():
            with self.subTest(kind=kind):
                expected = enum_programs(info["header"], info["enum"])
                # Programs retail's enum leaves unnamed are named by a port enum.
                if "port" in info:
                    expected |= enum_programs(info["port"]["header"], info["port"]["enum"])
                actual = {p["no"]: (p["enum"], p["description"]) for p in info["programs"]}
                self.assertEqual(actual, expected)
                self.assertEqual(len(info["programs"]), len(actual))

    def test_names_are_valid_and_unique(self):
        for kind, info in self.data["kinds"].items():
            with self.subTest(kind=kind):
                names = [p["name"] for p in info["programs"]]
                self.assertEqual(len(names), len(set(names)))
                for name in names:
                    self.assertRegex(name, NAME)
                    self.assertNotIn(name, LUAU_KEYWORDS)
                    self.assertNotEqual(name, "setup")

    def test_handlers_load_from_manifest(self):
        self.assertEqual(handlers("action")[100].name, "init")
        self.assertEqual(handlers("effect")[300].name, "on_finish")
        self.assertEqual(handlers("event"), {})
        self.assertEqual(SETUP, -1)


if __name__ == "__main__":
    unittest.main()
