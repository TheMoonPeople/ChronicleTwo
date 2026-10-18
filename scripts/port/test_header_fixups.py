import unittest
from pathlib import Path
import header_fixups


class UnitFixups(unittest.TestCase):
    def test_paint_constructor_initializes_return_on_every_first_open(self):
        source = Path(__file__).resolve().parents[2] / "ps2/include"
        mirrored = header_fixups.build_mirror(source)["editmenu.hpp"].decode("latin-1")
        self.assertEqual(mirrored.count("paint_top = 0; paint_return = 1;"), 1)
        self.assertEqual(mirrored.count("\n"), (source / "editmenu.hpp").read_bytes().count(b"\n"))

    def test_geostone_announcement_reserves_all_eight_nullable_message_slots(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/editmenu.cpp").read_text()
        mirrored = header_fixups.fixup_unit_text("editmenu.cpp", source)
        self.assertIn("static CDC2Mes *DownLoadMes[8];", mirrored)
        self.assertNotIn("static CDC2Mes *DownLoadMes[6];", mirrored)
        self.assertGreaterEqual(mirrored.count("i < 8;"), 2)

    def test_geostone_conditions_fit_their_text_and_wrap_buffers(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/editmenu.cpp").read_text()
        mirrored = header_fixups.fixup_unit_text("editmenu.cpp", source)
        self.assertIn('snprintf(text, sizeof(text), "%s", condition_name);', mirrored)
        self.assertNotIn("strcpy(text, condition_name);", mirrored)
        self.assertIn("char        *wrapped = (char *) stack->Alloc(8);", mirrored)
        self.assertEqual(mirrored.count("\n"), source.count("\n"))

    def test_georama_scroll_rate_is_zero_when_the_list_fits_one_page(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/editmenu.cpp").read_text()
        mirrored = header_fixups.fixup_unit_text("editmenu.cpp", source)
        self.assertIn("num > GEORAMA_LIST_LINE_NUM ? space / (num - GEORAMA_LIST_LINE_NUM) : 0.0f;", mirrored)
        self.assertEqual(mirrored.count("\n"), source.count("\n"))

    def test_option_cursor_bottom_limit_reaches_the_selected_row_on_its_line(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/menuop.cpp").read_text(encoding="latin-1")
        result = header_fixups.fixup_unit_text("menuop.cpp", source)
        self.assertEqual(result.count("limit[1] = PortOptionCursorBottom(limit[1], pos.y,"), 1)
        self.assertEqual(result.count("\n"), source.count("\n"))
        self.assertEqual(result.count("if (limit[1] < pos.y) {"), 1)
        self.assertEqual(header_fixups.fixup_unit_text("other.cpp", source), source)

    def test_password_generator_avoids_host_random_without_changing_its_body(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/password.cpp").read_text()
        result = header_fixups.fixup_unit_text("password.cpp", source)
        self.assertEqual(source.count("random()"), 5)
        self.assertEqual(result.count("PortPasswordRandom()"), 5)
        self.assertEqual(result.replace("PortPasswordRandom()", "random()"), source)
        self.assertEqual(header_fixups.fixup_unit_text("other.cpp", source), source)
        with self.assertRaises(SystemExit):
            header_fixups.fixup_unit_text("password.cpp", result)

    def test_party_ring_uses_rgba_variant_instead_of_palette_memory(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/menuchr.cpp").read_text()
        result = header_fixups.fixup_unit_text("menuchr.cpp", source)
        self.assertNotIn("->clut", result)
        self.assertNotIn("palette.clut", result)
        self.assertIn("MgTextureColorMode::PartyLocked", result)
        self.assertEqual(result.count("\n"), source.count("\n"))
        with self.assertRaises(SystemExit):
            header_fixups.fixup_unit_text("menuchr.cpp", result)

    def test_skip_intro_drops_only_the_boot_logo_fade_frames(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/nowload.cpp").read_text()
        result = header_fixups.fixup_unit_text("nowload.cpp", source)
        self.assertIn("frame <= 22 && !PortSkipIntro();", result)
        self.assertEqual(result.count("\n"), source.count("\n"))

    def test_skip_intro_fixup_optional_when_scelogo_fade_is_native(self):
        source = "// native SCElogoFade override; retail fade loop stripped\n"
        self.assertEqual(header_fixups.fixup_unit_text("nowload.cpp", source), source)

    def test_invent_constructor_emitted_exactly_once(self):
        source = "// constructor\ninline CMenuInvent::CMenuInvent() {\n    card_cursor = 0;\n}\n"
        result = header_fixups.fixup_unit_text("inventmn.cpp", source)
        self.assertEqual(result, source.replace("inline CMenuInvent", "CMenuInvent"))
        with self.assertRaises(SystemExit):
            header_fixups.fixup_unit_text("inventmn.cpp", result)
        with self.assertRaises(SystemExit):
            header_fixups.fixup_unit_text("inventmn.cpp", source + source)
        self.assertEqual(header_fixups.fixup_unit_text("other.cpp", source), source)

    def test_work_stacks_scale_with_sort_packets(self):
        root = Path(__file__).resolve().parents[2] / "ps2/src"
        for unit, stack in (("dng_main.cpp", "BuffWorkData"), ("editloop.cpp", "WorkBuffer")):
            source = (root / unit).read_text()
            result = header_fixups.fixup_unit_text(unit, source)
            self.assertIn(f"{stack}.stSetBuffer(", result)
            self.assertNotIn("stAlloc64(10000), 10000)", result)
            self.assertEqual(result.count(header_fixups.WORK_STACK_QUADWORDS), 2 if unit == "dng_main.cpp" else 5)
            self.assertEqual(result.count("\n"), source.count("\n"))

    def test_map_files_read_into_a_measured_buffer(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/sceneload.cpp").read_text()
        result = header_fixups.fixup_unit_text("sceneload.cpp", source)
        self.assertNotIn("load_buf = info.load_buf;", result)
        self.assertEqual(result.count("load_buf = PortMapLoadBuffer(info);"), 1)
        self.assertEqual(result.count("\n"), source.count("\n"))


if __name__ == "__main__":
    unittest.main()
