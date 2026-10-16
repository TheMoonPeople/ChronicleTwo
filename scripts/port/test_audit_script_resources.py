import struct
import tempfile
import unittest
from pathlib import Path

from audit_script_resources import audit, decode, is_valid_script, members, native_path, strings


def fixture(text=b"chara/hero.chr"):
    data = bytearray(108)
    data[:3] = b"SB2"
    for at, value in [(4, 28), (8, 28), (12, 28), (28, 56), (84, 3), (88, 3), (92, 80), (96, 15)]:
        struct.pack_into("<i", data, at, value)
    return bytes(data) + text + b"\0"


class ScriptResourceAuditTest(unittest.TestCase):
    def test_only_push_string_operands_are_reported(self):
        data = fixture() + b"unused/path.chr\0"
        self.assertEqual(list(strings(data)), [(84, b"chara/hero.chr")])
        self.assertEqual(list(strings(fixture(b"\x82\xa0"))), [(84, b"\x82\xa0")])

    def test_invalid_jump_is_rejected(self):
        data = bytearray(fixture())
        struct.pack_into("<iii", data, 84, 16, -1, 0)
        with self.assertRaisesRegex(ValueError, "jump"):
            decode(data)

    def test_residual_has_actual_published_target(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            raw, stage = base / "raw", base / "stage"
            (raw / "chara").mkdir(parents=True)
            (raw / "chara/hero.chr").write_bytes(b"raw")
            (stage / "port_data/chara").mkdir(parents=True)
            (stage / "port_data/chara/hero.gltf").write_text("{}")
            (stage / "data").mkdir()
            (stage / "data/test.stb").write_bytes(fixture())
            report = audit(raw, stage)
            self.assertEqual(report["scripts"], 1)
            self.assertEqual(report["actionable_residuals"][0]["published_targets"], ["chara/hero.gltf"])
            self.assertEqual(report["invalid_scripts"], [])

    def test_missing_converted_target_is_not_hidden_as_unknown_text(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            raw, stage = base / "raw", base / "stage"
            (raw / "chara").mkdir(parents=True)
            (raw / "chara/hero.chr").write_bytes(b"raw")
            (stage / "port_data").mkdir(parents=True)
            (stage / "data").mkdir()
            (stage / "data/test.stb").write_bytes(fixture())
            report = audit(raw, stage)
            self.assertEqual(len(report["missing_native_targets"]), 1)
            self.assertEqual(report["unresolved_original_references"], [])
            (stage / "data/test.stb").write_bytes(fixture(b"chara/hero.gltf"))
            report = audit(raw, stage)
            self.assertEqual(len(report["missing_direct_references"]), 1)

    def test_stem_whitespace_is_actionable_only_for_an_existing_exact_asset(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            raw, stage = base / "raw", base / "stage"
            (raw / "snd2/mon").mkdir(parents=True)
            (raw / "snd2/mon/en_044.snd").write_bytes(b"raw")
            (stage / "port_data/snd2/mon").mkdir(parents=True)
            (stage / "port_data/snd2/mon/en_044.sound.json").write_text("{}")
            (stage / "data").mkdir()
            (stage / "data/test.stb").write_bytes(fixture(b"snd2/mon/EN_044\t.snd"))
            report = audit(raw, stage)
            self.assertEqual(report["actionable_residuals"][0]["published_targets"], ["snd2/mon/en_044.sound.json"])
            (stage / "data/test.stb").write_bytes(fixture(b"snd2/mon/missing\t.snd"))
            report = audit(raw, stage)
            self.assertFalse(report["actionable_residuals"])
            self.assertEqual(len(report["unresolved_original_references"]), 1)

    def test_vm_headers_are_audited_independently_of_filename_suffix(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            raw, stage = base / "raw", base / "stage"
            raw.mkdir()
            (stage / "port_data").mkdir(parents=True)
            (stage / "data").mkdir()
            for name in ("main.stb", "extra.stb_", "other.bin"):
                (stage / "data" / name).write_bytes(fixture(b"non-resource dialogue"))
            (stage / "data/plain.txt").write_text("unrelated text")
            report = audit(raw, stage)
            self.assertEqual(report["scripts"], 3)
            self.assertEqual(report["string_pushes"], 3)
            self.assertFalse(report["invalid_scripts"])

    def test_valid_vm_takes_precedence_over_coincidental_pack_header(self):
        data = bytearray(700)
        data[:4] = b"SB2\0"
        for at, value in [(4, 80), (8, 80), (12, 64), (16, 2), (64, 500), (68, 80), (72, 150), (76, 80), (80, 56), (136, 15)]:
            struct.pack_into("<i", data, at, value)
        self.assertTrue(is_valid_script(data))
        self.assertIsNone(members(data))
        data[4:8] = bytes(4)
        self.assertFalse(is_valid_script(data))
        self.assertIsNotNone(members(data))
        archive = bytearray(160)
        archive[:3] = b"SB2"
        struct.pack_into("<III", archive, 64, 152, 8, 76)
        archive[152:] = b"payload!"
        self.assertFalse(is_valid_script(archive))
        self.assertEqual(members(archive), [("sb2", b"payload!")])

    def test_character_asset_names_follow_publisher(self):
        self.assertEqual(native_path("chara/hero.chr_/info.cfg", "json"), "chara/hero_.assets/info.json")
        self.assertEqual(native_path("chara/hero.chr_", "gltf"), "chara/hero_.gltf")
        self.assertEqual(native_path("map/data#offset:20", "gltf"), "map/data.offset_20.gltf")


if __name__ == "__main__":
    unittest.main()
