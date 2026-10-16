import unittest

import native_asset_paths


class NativeAssetPathsTests(unittest.TestCase):
    def test_direct_paths_and_dynamic_formats(self):
        original = 'LoadFile("map/itembox.chr", data, 0); sprintf(path, "dungeon/robo/%s.chr", name);'
        self.assertEqual(native_asset_paths.rewrite(original), original.replace(".chr", ".gltf"))

    def test_profile_names_are_semantic(self):
        original = 'chara->LoadPack((u32 *)data, "info.cfg", memory); LoadFile("menu/help.cfg", data, 0);'
        self.assertEqual(native_asset_paths.rewrite(original), original.replace('"info.cfg"', '"info"').replace("help.cfg", "help.cfg.json"))

    def test_scene_and_nested_character_calls_use_their_actual_profile_argument(self):
        original = 'scene->LoadChara(slot, data, "info.cfg", memory); CreateChara(data,"body.cfg",memory); LoadFile("info.cfg",data,0);'
        self.assertEqual(native_asset_paths.rewrite(original),
                         'scene->LoadChara(slot, data, "info", memory); CreateChara(data,"body",memory); LoadFile("info.cfg.json",data,0);')

    def test_npc_and_menu_profile_storage_is_semantic_without_changing_file_reads(self):
        npc = 'static char infocfg[] = "info.cfg"; LoadFile("info.cfg",data,0);'
        self.assertEqual(native_asset_paths.rewrite(npc, "npccfg.cpp"),
                         'static char infocfg[] = "info"; LoadFile("info.cfg.json",data,0);')
        menu = 'static char menu_infocfgname[10] = "info.cfg"; const char *file="layout.cfg";'
        self.assertEqual(native_asset_paths.rewrite(menu, "menuchr.cpp"),
                         'static char menu_infocfgname[10] = "info"; const char *file="layout.cfg.json";')
        self.assertIn('"info.cfg.json"', native_asset_paths.rewrite(npc, "other.cpp"))

    def test_monster_profile_producers_keep_model_stems(self):
        monster = 'sprintf(config_path, "%s.cfg", tbl->model); sprintf(path,"dungeon/cfg_file/%s.cfg",name);'
        self.assertEqual(native_asset_paths.rewrite(monster, "monster.cpp"),
                         'sprintf(config_path, "%s", tbl->model); sprintf(path,"dungeon/cfg_file/%s.cfg.json",name);')
        menu = 'strcpy(file_name, monster->model); strcat(file_name, ".cfg"); strcat(path, ".cfg");'
        self.assertEqual(native_asset_paths.rewrite(menu, "menuchr.cpp"),
                         'strcpy(file_name, monster->model); strcat(file_name, ""); strcat(path, ".cfg.json");')

    def test_unrelated_lexical_content_is_unchanged(self):
        original = '// "a.chr"\n/* "b.cfg" */ auto raw=R"x(a.img)x"; const char *text="a.chr has moved";'
        self.assertEqual(native_asset_paths.rewrite(original), original)

    def test_audio_and_movie_paths(self):
        original = '"snd2/SY_000.snd" "movie/L5Logo.PSS;1"'
        self.assertEqual(native_asset_paths.rewrite(original), '"snd2/SY_000.sound.json" "movie/L5Logo.mp4;1"')

    def test_scene_audio_metadata_uses_only_the_two_known_direct_json_paths(self):
        self.assertEqual(native_asset_paths.rewrite('"snd2/rev.bin" "snd2/MAP_index.txt" "unrelated.bin" "menu/names.txt"'),
                         '"snd2/rev.json" "snd2/map_index.json" "unrelated.bin" "menu/names.txt"')

    def test_dynamic_stream_paths_are_explicit(self):
        self.assertEqual(native_asset_paths.rewrite('"85200%d.wav" "8500%s.wav" "%07d.wav" "Logo.PSS"'),
                         '"sound/85200%d.wav" "sound/8500%s.wav" "sound/%07d.wav" "movie/Logo.mp4"')

    def test_suffix_fragments_do_not_acquire_directory_prefixes(self):
        self.assertEqual(native_asset_paths.rewrite('strcat(path, ".wav"); strcat(path, ".pss");'),
                         'strcat(path, ".wav"); strcat(path, ".mp4");')

    def test_buffer_copy_tracking_does_not_define_a_library_macro(self):
        self.assertEqual(native_asset_paths.rewrite('memcpy(dst, src, size); // memcpy(d,s,n)\n"memcpy(a,b,c)"'),
                         'PortTextureSourceCopy(dst, src, size); // memcpy(d,s,n)\n"memcpy(a,b,c)"')

    def test_character_backup_variant_has_a_distinct_native_name(self):
        self.assertEqual(native_asset_paths.rewrite('"event/b01a_buggy.chr_"'), '"event/b01a_buggy_.gltf"')

    def test_directory_calls_use_native_resource_kinds(self):
        self.assertEqual(native_asset_paths.rewrite('GetPackFileExt(pack, "img", files, 4, sizes, names); GetPackFile(pack,"info.cfg",&size); GetPackFileNum(pack);'),
                         'AssetDirectoryReadExtension(pack, "texture", files, 4, sizes, names); AssetDirectoryRead(pack,"info.cfg.json",&size); AssetDirectoryCount(pack);')

    def test_text_map_paths_use_json(self):
        self.assertEqual(native_asset_paths.rewrite('strcat(path, ".map"); "map/town.map"'), 'strcat(path, ".map.json"); "map/town.map.json"')

    def test_map_and_config_paths_remain_distinct(self):
        self.assertEqual(native_asset_paths.rewrite('"map/floor.map" "map/floor.cfg"'),
                         '"map/floor.map.json" "map/floor.cfg.json"')

    def test_config_and_texture_paths_remain_distinct(self):
        self.assertEqual(native_asset_paths.rewrite('"menu/item.cfg" "menu/item.img"'),
                         '"menu/item.cfg.json" "menu/item.json"')

    def test_icon_models_and_skin_resources_use_gltf(self):
        self.assertEqual(native_asset_paths.rewrite('"dc2_ic.ico" "hero.wgt" "hero.bbp"'),
                         '"dc2_ic.gltf" "hero.gltf" "hero.gltf"')

    def test_fishing_requests_its_local_sound_bundle_explicitly(self):
        self.assertEqual(native_asset_paths.rewrite('GetPackFile(pack, bgm_path, NULL);', "fishing.cpp"),
                         'AssetDirectoryRead(pack, AssetMemberName(bgm_path), NULL);')

    def test_distinct_archive_models_do_not_overwrite_character_bundles(self):
        self.assertEqual(native_asset_paths.rewrite(
            '"etc/gsys.pak/a_mu.mds" "etc/gsys.pak/a_mu.chr" '
            '"etc/gsys.pak/sukkopu.mds" "other/a_mu.mds"'),
            '"etc/gsys.pak/a_mu.model.gltf" "etc/gsys.pak/a_mu.gltf" '
            '"etc/gsys.pak/sukkopu.model.gltf" "other/a_mu.gltf"')

    def test_edit_cursor_references_actual_folder_members(self):
        self.assertEqual(native_asset_paths.rewrite(
            'GetPackFile(pack, "etc/cone.mds", 0); GetPackFile(pack, "etc/hake.chr", 0); '
            'LoadFile("etc/hake.chr", data, 0);', "editmode.cpp"),
            'AssetDirectoryRead(pack, "cone.gltf", 0); AssetDirectoryRead(pack, "hake.gltf", 0); '
            'LoadFile("etc/hake.gltf", data, 0);')


if __name__ == "__main__":
    unittest.main()
