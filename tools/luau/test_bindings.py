import json
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

import bindings  # noqa: E402

CATALOG = HERE / "commands.json"
PROGRAMS = HERE / "programs.json"


def synthetic_catalog() -> dict:
    return {
        "kinds": {
            "test": {
                "namespace": "test",
                "table_size": 16,
                "commands": [
                    {
                        "no": 7,
                        "luau": "Probe",
                        "signatures": [
                            {
                                "argc": 2,
                                "handler_rejects": True,
                                "params": [
                                    {"name": "f", "dir": "in", "type": "f32"},
                                    {"name": "out", "dir": "out", "type": "s32"},
                                ],
                            },
                            {"argc": 0, "params": []},
                        ],
                    }
                ],
            }
        }
    }


class GenerateTest(unittest.TestCase):
    def test_action_output_is_deterministic(self):
        catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
        first = bindings.generate(catalog, ["action"])
        second = bindings.generate(catalog, ["action"])
        self.assertEqual(first, second)
        self.assertIn('{"ProgSet", 1,', first)
        self.assertIn("constexpr Kind kKinds[]", first)
        self.assertEqual(
            first.count("constexpr Signature "),
            len(catalog["kinds"]["action"]["commands"]),
        )

    def test_synthetic_signatures_and_params(self):
        text = bindings.generate(synthetic_catalog(), ["test"])
        self.assertIn("constexpr Signature kTest7[] = {{0, false, {}}, {2, true, kTest7Argc2}};", text)
        self.assertIn("constexpr Param kTest7Argc2[] = {{In, F32}, {Out, S32}};", text)
        self.assertIn('    {"Probe", 7, kTest7},', text)
        self.assertIn('    {"test", "test", 16, kTestCommands, {}},', text)

    def test_tagged_param_is_marked(self):
        catalog = synthetic_catalog()
        catalog["kinds"]["test"]["commands"][0]["signatures"][0]["params"][0]["tagged"] = True
        text = bindings.generate(catalog, ["test"])
        self.assertIn("constexpr Param kTest7Argc2[] = {{In, F32, true}, {Out, S32}};", text)

    def test_fallback_modules_are_listed(self):
        fallback = {"scripts": {"dungeon/monster/p00_23a.stb": "why", "mainchr/c02.stb_": "why"}}
        text = bindings.generate(synthetic_catalog(), ["test"], None, fallback)
        self.assertIn('constexpr std::string_view kFallback[] = {\n    "dungeon/monster/p00_23a",\n    "mainchr/c02_",\n};', text)
        self.assertIn("std::span<const std::string_view> FallbackModules() { return kFallback; }", text)

    def test_inout_param_direction(self):
        catalog = synthetic_catalog()
        catalog["kinds"]["test"]["commands"][0]["signatures"][0]["params"][1]["dir"] = "inout"
        text = bindings.generate(catalog, ["test"])
        self.assertIn("constexpr Param kTest7Argc2[] = {{In, F32}, {InOut, S32}};", text)

    def test_unknown_kind_exits(self):
        with self.assertRaises(SystemExit):
            bindings.generate(synthetic_catalog(), ["missing"])

    def test_action_output_names_programs(self):
        catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
        programs = json.loads(PROGRAMS.read_text(encoding="utf-8"))
        text = bindings.generate(catalog, ["action"], programs)
        self.assertIn('{100, "init"}', text)
        self.assertIn('{200, "loop"}', text)
        self.assertIn("    {\"action\", \"action\", 256, kActionCommands, kActionPrograms},", text)

    def test_setup_program_name_exits(self):
        programs = {"kinds": {"test": {"programs": [{"no": 1, "name": "setup"}]}}}
        with self.assertRaises(SystemExit):
            bindings.generate(synthetic_catalog(), ["test"], programs)

    def test_duplicate_program_number_exits(self):
        programs = {
            "kinds": {
                "test": {
                    "programs": [
                        {"no": 1, "name": "first"},
                        {"no": 1, "name": "second"},
                    ]
                }
            }
        }
        with self.assertRaises(SystemExit):
            bindings.generate(synthetic_catalog(), ["test"], programs)

    def test_invalid_program_name_exits(self):
        programs = {"kinds": {"test": {"programs": [{"no": 1, "name": "On-Death"}]}}}
        with self.assertRaises(SystemExit):
            bindings.generate(synthetic_catalog(), ["test"], programs)


if __name__ == "__main__":
    unittest.main()
