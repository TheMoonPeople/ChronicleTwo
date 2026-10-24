import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb.assembler import assemble  # noqa: E402
from stb.opcodes import AddrMode  # noqa: E402
from stb.program import DecodeError, decode  # noqa: E402
from stb2luau import event_args  # noqa: E402

LOCAL = AddrMode.LOCAL


def script(body):
    return assemble({"main": (0, 0, [("END",)]), "p100": (0, 0, body)}, "main", {100: "p100"})


VALID = [
    ("push", 1), ("push", 123), ("EXT", 2),
    ("push", 0), ("push", 1), ("pushf", 1.25), ("pushs", "テスト".encode("cp932")), ("push", 4), ("push", 2), ("OR",), ("EXT", 5),
    ("push", 0), ("RET",),
]


class EventArgsTest(unittest.TestCase):
    def test_emits_commands_in_order(self):
        text = event_args.emit(decode(script(VALID)), "event/x.stb")
        self.assertIn('{ command = 1, args = { { type = "int", value = 123 } } },', text)
        self.assertIn('type = "int", value = 1 }', text)
        self.assertIn('type = "float", value = 1.25', text)
        self.assertIn('type = "string"', text)
        self.assertIn('value = 6', text)
        self.assertLess(text.index("command = 1"), text.index("command = 0"))

    def test_loaded_variable_is_refused(self):
        body = [("push", 0), ("push", 1), ("LOAD", 0, LOCAL), ("EXT", 2), ("push", 0), ("RET",)]
        with self.assertRaises(DecodeError):
            event_args.actions(decode(script(body)))

    def test_unknown_command_is_refused(self):
        body = [("push", 9), ("push", 1), ("EXT", 2), ("push", 0), ("RET",)]
        with self.assertRaises(DecodeError):
            event_args.actions(decode(script(body)))

    def test_valid_script_verifies(self):
        self.assertIsNone(event_args.verify(decode(script(VALID))))


if __name__ == "__main__":
    unittest.main()
