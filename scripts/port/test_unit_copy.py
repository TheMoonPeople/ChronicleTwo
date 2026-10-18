import tempfile
import unittest
from pathlib import Path

import unit_copy


class RetailBridgeTests(unittest.TestCase):
    def test_character_item_read_uses_path_without_moving_lines(self):
        source = ("int ReadMainCharaBG() {\n"
                  "    auto *item = GetReadBGFile(1)->buffer;\n"
                  "    return item != nullptr;\n"
                  "}\n"
                  "int Other() { return GetReadBGFile(2)->buffer != nullptr; }\n")
        actual = unit_copy.resolve_main_character_item_read(source)
        self.assertEqual(actual.count("\n"), source.count("\n"))
        self.assertIn("PortMainCharaItemReadBuffer()", actual)
        self.assertIn("GetReadBGFile(2)->buffer", actual)
        with self.assertRaises(ValueError):
            unit_copy.resolve_main_character_item_read(source.replace("GetReadBGFile(1)->buffer", "GetReadBGFile(0)->buffer"))

    def test_costume_arena_hook_precedes_only_selected_character_construction(self):
        source = "void Other() { LoadPack(); }\nstatic void MenuItemCharaDataLoadPack(int part) {\n    if ((chara != NULL && part != 1) || part == 1) {\n        switch (part) { case 0: chara->Initialize(stack); break; }\n    }\n}\n"
        actual = unit_copy.prepare_menu_character_arena(source)
        self.assertEqual(actual.count("PortPrepareMenuCharacterArena("), 1)
        self.assertLess(actual.index("PortPrepareMenuCharacterArena("), actual.index("chara->Initialize(stack)"))
        self.assertIn("void Other() { LoadPack(); }", actual)
        self.assertIn("if ((chara != NULL && part != 1) || part == 1) {\n        PortPrepareMenuCharacterArena", actual)

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

    def test_town_clear_keeps_retail_body_under_its_bridge(self):
        source = Path(__file__).resolve().parents[2] / "ps2/src/editmap.cpp"
        mirror = unit_copy.retail_bridges(self.override, source, True)
        self.assertEqual(mirror.count("void CEditMap::PortRetailClearAllParts() {"), 1)
        self.assertIn("(&parts_heap)->ClearHeapMem();", mirror)
        self.assertNotIn("CEditMap::ClearAllParts()", mirror)

    def test_georama_cursor_step_keeps_retail_body_under_its_bridge(self):
        source = Path(__file__).resolve().parents[2] / "ps2/src/editmode.cpp"
        mirror = unit_copy.retail_bridges(self.override, source, True)
        self.assertEqual(mirror.count("void PortRetailEditMode(CScene *scene) {"), 1)
        self.assertIn("camera->AddAngle(0.1f * -pad->Analog(PAD_ANALOG_RIGHT_X));", mirror)
        self.assertNotIn("void EditMode(", mirror)

    def test_other_units_have_no_bridge(self):
        self.assertEqual(unit_copy.retail_bridges(self.override, Path("other.cpp"), True), "")


if __name__ == "__main__":
    unittest.main()


class ConfigSeamTests(unittest.TestCase):
    def test_seam_replaces_only_the_interpreter_run_and_keeps_line_numbers(self):
        source = ("static void LoadSkyPack(MAP_SKY_INFO *info, char *script, int size) {\n"
                  "    skyInfo = info;\n"
                  "    CScriptInterpreter interpreter;\n"
                  "    interpreter.SetTag(tag);\n"
                  "    interpreter.SetScript(script, size);\n"
                  "    interpreter.Run();\n"
                  "}\n"
                  "void Other() { CScriptInterpreter interpreter; interpreter.Run(); }\n")
        actual = unit_copy.config_seams(source, "mapsky.cpp")
        self.assertEqual(actual.count("\n"), source.count("\n"))
        self.assertIn("    skyInfo = info;\n    PortLoadSkyInfo(info, script, size);\n", actual)
        self.assertNotIn("interpreter.SetTag(tag)", actual)
        self.assertIn("void Other() { CScriptInterpreter interpreter; interpreter.Run(); }", actual)
        self.assertEqual(unit_copy.config_seams(source, "other.cpp"), source)

    def test_config_bridges_are_found_by_unit_name(self):
        self.assertEqual(unit_copy.native_bridge("character.cpp").name, "character_metadata_bridge.inc")
        self.assertEqual(unit_copy.native_bridge("menuaqua.cpp").name, "menuaqua_config_bridge.inc")
        self.assertIsNone(unit_copy.native_bridge("no_such_unit.cpp"))
