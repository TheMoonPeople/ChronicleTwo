import tempfile
import unittest
from pathlib import Path

import unit_copy


class RetailBridgeTests(unittest.TestCase):
    def setUp(self):
        root = Path(__file__).resolve().parents[2]
        self.override = unit_copy.load_port_override(root / "tools/kazarov/scripts/build/port_override.py")

    def test_bridge_preserves_body_and_public_calls(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "editctrl.cpp"
            body = "void ResetViewMode(CScene *scene) { ResetViewMode(scene); scene->Reset(); }"
            source.write_text(body + "\nvoid Caller(CScene *scene) { ResetViewMode(scene); }")
            mirror = unit_copy.retail_bridges(self.override, source, True)
            self.assertEqual(mirror, f'#line 1 "{source.resolve().as_posix()}"\n' +
                             body.replace("void ResetViewMode(", "void PortRetailResetViewMode(", 1))
            stripped = self.override.strip_unit(source, {"ResetViewMode(CScene*)"}, {}, (), True)
            self.assertIn("void Caller(CScene *scene) { ResetViewMode(scene); }", stripped)
            self.assertNotIn(body, stripped)

    def test_bridge_maps_to_the_retail_definition_line(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "editctrl.cpp"
            source.write_text("// retail declarations\n\n\nvoid ResetViewMode(CScene *scene) {\n    scene->Reset();\n}")
            mirror = unit_copy.retail_bridges(self.override, source, True)
            self.assertTrue(mirror.startswith(f'#line 4 "{source.resolve().as_posix()}"\n'))
            self.assertIn("void PortRetailResetViewMode(CScene *scene) {\n    scene->Reset();\n}", mirror.replace("\r\n", "\n"))

    def test_missing_retail_body_fails_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "editctrl.cpp"
            source.write_text("void Other() {}")
            with self.assertRaises(self.override.Error):
                unit_copy.retail_bridges(self.override, source, True)

    def test_other_units_have_no_bridge(self):
        self.assertEqual(unit_copy.retail_bridges(self.override, Path("other.cpp"), True), "")


if __name__ == "__main__":
    unittest.main()
