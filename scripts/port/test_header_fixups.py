import re
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

    def test_manual_event_table_covers_every_help_list_row(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/menuop.cpp").read_text(encoding="latin-1")
        self.assertIn("for (list = 0, entry = 0; list < 5; list++, entry += 10) {", source)
        self.assertIn("for (item = 0; item < 10; item++) {", source)
        result = header_fixups.fixup_unit_text("menuop.cpp", source)
        table = re.search(r"static short manual_boot_event_no\[(\d+)\] = \{(.*?)\};", result, re.S)
        self.assertIsNotNone(table)
        entries = [entry.strip() for entry in table.group(2).split(",")]
        self.assertEqual(int(table.group(1)), 5 * 10)
        self.assertEqual(len(entries), 5 * 10)
        self.assertEqual(entries[46:], ["-1"] * 4)
        self.assertEqual(result.count("\n"), source.count("\n"))

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

    def test_character_model_stacks_grow(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/charasetup.cpp").read_text()
        result = header_fixups.fixup_unit_text("charasetup.cpp", source)
        extra = f" + {header_fixups.CHARA_MODEL_STACK_EXTRA}"
        for size in ("68500", "40000", "30000", "60000", "75000", "120000"):
            self.assertIn(size + extra, result)
        self.assertEqual(result.count(extra), 7)
        self.assertEqual(result.count("\n"), source.count("\n"))

    def test_monster_slots_keep_to_the_floor_limit(self):
        root = Path(__file__).resolve().parents[2] / "ps2/src"
        for unit, calls in (("monster.cpp", 1), ("dng_event.cpp", 2), ("event_func.cpp", 1)):
            source = (root / unit).read_text(encoding="latin-1")
            result = header_fixups.fixup_unit_text(unit, source)
            self.assertEqual(result.count("PortMonsterActiveLimit()"), calls)
            self.assertEqual(result.count("\n"), source.count("\n"))
        source = (root / "monster.cpp").read_text(encoding="latin-1")
        self.assertIn("priority_limit = PortMonsterLatchLimits();", header_fixups.fixup_unit_text("monster.cpp", source))

    def test_monster_scene_slots_start_at_the_monster_slot(self):
        root = Path(__file__).resolve().parents[2] / "ps2/src"
        for unit in ("actionchara.cpp", "actscript.cpp", "monster.cpp"):
            result = header_fixups.fixup_unit_text(unit, (root / unit).read_text(encoding="latin-1"))
            self.assertNotIn("MONSTER_ACTIVE_MAX * 2", result)
            self.assertNotRegex(result, r"(?<!DNG_CHARA_SLOT_MONSTER) \+ MONSTER_ACTIVE_MAX\b|[=-] MONSTER_ACTIVE_MAX;")

    def test_georama_tables_grow_with_the_town(self):
        source = Path(__file__).resolve().parents[2] / "ps2/include"
        mirror = header_fixups.build_mirror(source)
        editmap = mirror["editmap.hpp"].decode("latin-1")
        self.assertEqual(editmap.count("CEditHouse                          *house;"), 1)
        self.assertEqual(editmap.count("s32 *house_npc;"), 1)
        self.assertEqual(editmap.count("void PortRetailClearAllParts();"), 1)
        self.assertEqual(editmap.count("\n"), (source / "editmap.hpp").read_bytes().count(b"\n") + 1)
        collision = mirror["collision.hpp"].decode("latin-1")
        self.assertIn("CCPOLY_PARTS_EDIT = 0x8000,", collision)
        self.assertIn("CCPOLY_PARTS_SLOT_MASK = 0x7FFF,", collision)
        editmenu = mirror["editmenu.hpp"].decode("latin-1")
        for name in ("place_no", "place_name", "placed_list", "house_list"):
            self.assertIn(f"        {name} = NULL;", editmenu)
            self.assertNotIn(f"sizeof({name})", editmenu)
        self.assertIn("char (*place_name)[0x40];", editmenu)
        self.assertEqual(editmenu.count("\n"), (source / "editmenu.hpp").read_bytes().count(b"\n"))

    def test_georama_parts_have_no_placement_or_polygon_limit(self):
        root = Path(__file__).resolve().parents[2] / "ps2/src"
        source = (root / "editinfo.cpp").read_text(encoding="latin-1")
        result = header_fixups.fixup_unit_text("editinfo.cpp", source)
        self.assertIn(f"emapNowInfo->max_num = {header_fixups.GEORAMA_PARTS_MAX_NUM};", result)
        self.assertEqual(result.count("\n"), source.count("\n"))
        source = (root / "editmenu.cpp").read_text(encoding="latin-1")
        result = header_fixups.fixup_unit_text("editmenu.cpp", source)
        self.assertIn("    if (true) {\n        ExeScript(\"POLYOF\");", result)
        self.assertIn("(menu->make_parts->max_num < 99 ? menu->make_parts->max_num : 99)", result)
        self.assertEqual(result.count("\n"), source.count("\n"))
        with self.assertRaises(SystemExit):
            header_fixups.fixup_unit_text("editinfo.cpp", header_fixups.fixup_unit_text("editinfo.cpp", (root / "editinfo.cpp").read_text(encoding="latin-1")))

    def test_map_files_read_into_a_measured_buffer(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/sceneload.cpp").read_text()
        result = header_fixups.fixup_unit_text("sceneload.cpp", source)
        self.assertNotIn("load_buf = info.load_buf;", result)
        self.assertEqual(result.count("load_buf = PortMapLoadBuffer(info);"), 1)
        self.assertEqual(result.count("\n"), source.count("\n"))


if __name__ == "__main__":
    unittest.main()
