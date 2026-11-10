--!strict
-- map/s/s20/s20.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_786b79f1 = require("@lib/event/helper_786b79f1")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(5684)
	event.set_function_point_enabled("", "useitem_00", 0)
	event.set_function_point_enabled("", "dun_entrance", 1)
	event.set_function_point_enabled("", "entrance", 1)
	flag = event.get_save_flag(516) or flag
	event.get_item_count(372)
	if flag == 0 then
		event.set_function_point_enabled("", "useitem_00", 1)
	end
	if flag == 1 then
		event.attach_object_handle_to_map_part_2(0, "p03_s2001")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(0, "p04_s2001")
		event.set_object_handle_visible(0, 1)
	end
	event.attach_object_handle_to_map_part_2(0, "p01_battleship")
	event.set_object_handle_visible(0, 0)
	flag_2 = event.get_save_flag(520) or flag_2
	if flag_2 ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p04_s2001", "s2006-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(0, "firesquall")
		event.set_object_handle_visible(0, 0)
		event.set_function_point_enabled("p04_s2001", "eff_s20ef-0", 0)
		event.set_function_point_enabled("p04_s2001", "eff_s20ef-1", 0)
		event.set_function_point_enabled("p04_s2001", "eff_s20ef-2", 0)
		event.set_function_point_enabled("p04_s2001", "eff_s20ef-3", 0)
	end
end

--- Helper function.
local function helper_13e64()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(512, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		event.load_map_sounds(5800)
		var0 = event.load_sound_effect_file_2(5800) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e500/e512/")
		event.load_message_file(0, 5, "e512.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e512_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e512_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e512/e512_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e512/e512_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_map_part_2(2, "firesquall")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_visible(2, 1)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, -2114.39, -15.43, 3159.57)
		event.set_object_handle_rotation(0, 0.0, -2.73, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -2067.72, -11.31, 3130.76)
		event.set_object_handle_rotation(1, 0.0, -2.73, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-2167.75, 78.54, 2808.99)
		event.set_camera_sequence_look_at(-2123.94, -6.64, 3117.06)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -2154.86, 0.23, 2989.31, 60, 1)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -2121.93, 0.0, 2981.53, 70, 1)
		event.delay_object_sequence_motion_track(1, 70)
		event.set_object_sequence_motion(1, "立ち")
		event.stop_music(0)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		wait_objects(0)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(0, "指さす", 6)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(5120010)
		event.set_camera_sequence_position(-1899.45, 48.16, 2384.53)
		event.set_camera_sequence_look_at(-2089.91, 113.14, 2148.64)
		event.play_sound_effect(var0, 1)
		event.move_camera_sequence(-1960.89, 51.28, 2421.91, -2089.91, 113.14, 2148.64, 210)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5120020)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(5120030)
		wait_camera()
		event.stop_sound_effect(var0, 1)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(var0, 1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.load_message_file(0, -1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_active(0)
	event.set_character_position(0, -2154.86, 0.23, 2989.31)
	event.set_character_rotation(0, 0.0, -2.73, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.show_dungeon_status_bar(1, 1.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1069c()
	event.initialize_event()
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-2098.32, 112.9, 2914.62)
	event.set_camera_sequence_look_at(-2002.24, 24.33, 3103.52)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -1953.35, -38.07, 3352.55)
	event.set_object_sequence_rotation(0, 0.0, -2.4, 0.0)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 60)
	event.add_object_sequence_path_point(0, -1953.35, -38.07, 3352.55)
	event.add_object_sequence_path_point(0, -1973.62, -28.53, 3308.18)
	event.add_object_sequence_path_point(0, -1994.79, -9.95, 3175.09)
	event.add_object_sequence_path_point(0, -2000.28, 0.23, 3105.85)
	event.start_object_sequence_path(0)
	event.fade_in_screen(30)
	helper_888ab2a3(60)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

--- Helper function.
local function helper_15ae0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var6: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(516, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(30)
		event.play_music(0)
		event.load_map_sounds(5803)
		var0 = event.load_sound_effect_file_2(5803) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e500/e516/")
		event.load_message_file(0, 5, "e516.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e516_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e516_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		block = event.load_event_image_4(5, "e516telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e516telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(29, 0)
		event.clear_object_sequence(29)
		event.set_object_sequence_object(29, 29)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 9)
			event.load_equipment_model(5, 0, 4, "info", 9)
			event.load_equipment_model(5, 0, 3, "info", 9)
			event.load_equipment_model(5, 0, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e500/e516/e516_mints.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 9)
			event.attach_object_handle_to_character(0, 9)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 9)
			event.load_equipment_model(5, 1, 4, "info", 9)
			event.load_equipment_model(5, 1, 3, "info", 9)
			event.load_equipment_model(5, 1, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e500/e516/e516_monica.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(9)
		event.set_character_active(10)
		event.load_character(5, "event/e500/e516/e516_guiltoni.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2, 11)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e500/e516/e516_daibaku.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(6, 15)
		event.clear_object_sequence(6, 15)
		event.set_object_sequence_object(6, 6)
		event.copy_character(5, 15, 16)
		event.set_character_active(16)
		event.attach_object_handle_to_character(7, 16)
		event.clear_object_sequence(7, 16)
		event.set_object_sequence_object(7, 7)
		event.copy_character(5, 16, 17)
		event.set_character_active(17)
		event.attach_object_handle_to_character(8, 17)
		event.clear_object_sequence(8, 17)
		event.set_object_sequence_object(8, 8)
		event.load_character(5, "event/e500/e516/e352_gun_f.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(3, 12)
		event.clear_object_sequence(3, 12)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e500/e516/e516_hou_tyaku.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_object_handle_to_character(9, 18)
		event.clear_object_sequence(9, 18)
		event.set_object_sequence_object(9, 9)
		event.load_character(5, "event/e500/e516/e516_gun_s.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(4, 13)
		event.clear_object_sequence(4, 13)
		event.set_object_sequence_object(4, 4)
		event.copy_character(5, 13, 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(5, 14)
		event.clear_object_sequence(5, 14)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "event/e500/e516/e516_gun_tyaku.gltf", "info", 19)
		event.set_character_active(19)
		event.attach_object_handle_to_character(10, 19)
		event.clear_object_sequence(10, 19)
		event.set_object_sequence_object(10, 10)
		event.copy_character(5, 19, 20)
		event.set_character_active(20)
		event.attach_object_handle_to_character(11, 20)
		event.clear_object_sequence(11, 20)
		event.set_object_sequence_object(11, 11)
		event.load_character(5, "event/e500/e516/e516_bakufu.gltf", "info", 23)
		event.set_character_active(23)
		event.attach_object_handle_to_character(14, 23)
		event.clear_object_sequence(14, 23)
		event.set_object_sequence_object(14, 14)
		event.attach_object_handle_to_map_part_2(17, "p01_battleship")
		event.clear_object_sequence(17)
		event.set_object_sequence_object(17, 17)
		event.attach_object_handle_to_map_part_3(18, "p01_battleship", "kikan-m0")
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.attach_object_handle_to_map_part_3(19, "p01_battleship", "kikan-m1")
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.attach_object_handle_to_map_part_3(20, "p01_battleship", "kikan-m2")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.attach_object_handle_to_map_part_3(21, "p01_battleship", "kikan-m3")
		event.clear_object_sequence(21)
		event.set_object_sequence_object(21, 21)
		event.attach_object_handle_to_map_part_3(22, "p01_battleship", "battleship_6-m0")
		event.clear_object_sequence(22)
		event.set_object_sequence_object(22, 22)
		event.attach_object_handle_to_map_part_3(23, "p01_battleship", "battleship_7-m0")
		event.clear_object_sequence(23)
		event.set_object_sequence_object(23, 23)
		event.attach_object_handle_to_map_part_3(24, "p01_battleship", "battleship_8-m0")
		event.clear_object_sequence(24)
		event.set_object_sequence_object(24, 24)
		event.attach_object_handle_to_map_part_3(25, "p01_battleship", "battleship_9-m0")
		event.clear_object_sequence(25)
		event.set_object_sequence_object(25, 25)
		event.attach_object_handle_to_map_part_2(26, "p03_s2001")
		event.clear_object_sequence(26)
		event.set_object_sequence_object(26, 26)
		event.attach_object_handle_to_map_part_2(27, "p04_s2001")
		event.clear_object_sequence(27)
		event.set_object_sequence_object(27, 27)
		event.attach_object_handle_to_map_part_2(28, "firesquall")
		event.clear_object_sequence(28)
		event.set_object_sequence_object(28, 28)
		event.set_object_handle_visible(28, 1)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, -3378.46, 181.07, 33.61)
		event.set_object_handle_rotation(0, 0.0, -1.89, 0.0)
		event.set_object_handle_motion(0, "爆弾セット", 4)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_position(1, -3071, 105.8, 2.85)
		event.set_object_handle_rotation(1, 0.0, -1.29, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_position(2, -1676.01, 1691.67, -4853.66)
		event.set_object_handle_rotation(2, 0.0, -0.93, 0.0)
		event.set_object_handle_motion(2, "下向き立ち", 4)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_handle_position(17, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(17, 0.0, -1.186824, 0.0)
		event.set_object_handle_position(18, 367.1, -137.116, 64.3)
		event.set_object_handle_rotation(18, 0.0, 1.57, 0.0)
		event.set_object_handle_position(19, 367.4, -137.116, -25.8)
		event.set_object_handle_rotation(19, 0.0, 1.57, 0.0)
		event.set_object_handle_position(20, 291.6, -137.116, -207.3)
		event.set_object_handle_rotation(20, 0.0, 2.26, 0.0)
		event.set_object_handle_position(21, 232.8, -137.116, -295.9)
		event.set_object_handle_rotation(21, 0.0, 2.26, 0.0)
		event.set_object_handle_scale(22, 1.0, 1.0, 1.0)
		event.set_object_handle_scale(23, 1.0, 1.0, 1.0)
		event.set_object_handle_scale(24, 1.0, 1.0, 1.0)
		event.set_object_handle_scale(25, 1.0, 1.0, 1.0)
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_visible(7, 0)
		event.set_object_handle_visible(8, 0)
		event.set_object_handle_visible(9, 0)
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 0)
		event.set_object_handle_visible(17, 1)
		event.set_object_handle_visible(26, 1)
		event.set_object_handle_visible(27, 0)
		event.set_object_handle_visible(14, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-3300.38, 202.19, 148.68)
		event.set_camera_sequence_look_at(-3383.16, 195.14, 32.14)
		event.set_character_active(0)
		event.set_character_active(9)
		event.set_character_active(10)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		at = 3
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 2)
		at = 4
		helper_888ab2a3(60)
		event.set_object_sequence_motion(0, "セット完了", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 5
		wait_objects(0)
		event.stop_sound_effect(var0, 2)
		event.set_camera_sequence_position(-2977.95, 148.16, -54.81)
		event.set_camera_sequence_look_at(-3086.93, 135.01, -12.38)
		event.delay_object_sequence_position_track(0, 60)
		event.delay_object_sequence_rotation_track(0, 60)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, 1.63, 0.0, 12)
		event.move_object_sequence(0, -3286.64, 181.07, 20.0, 30, 1)
		event.move_object_sequence(0, -3109.88, 105.8, 15.86, 100, 1)
		event.delay_object_sequence_rotation_track(0, 130)
		event.delay_object_sequence_motion_track(0, 130)
		event.rotate_object_sequence(0, 0.0, 0.07, 0.0, 12)
		event.move_object_sequence(0, -3070.97, 65.59, 178.73, 90, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 6
		helper_0382f327(5160010, 90)
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, 0.03, 0.0, 12)
		event.move_object_sequence(1, -3035.41, 56.31, 201.54, 90, 1)
		event.delay_object_sequence_motion_track(1, 90)
		at = 7
		helper_888ab2a3(90)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(-1434.28, 46.52, 2276.43)
		event.set_camera_sequence_look_at(-1767.75, 128.39, 1914.88)
		event.set_object_sequence_position(17, 3172.3, 1692, -5181.7)
		event.set_object_sequence_rotation(17, 0.0, -1.65, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, -1847.62, 0.0, 2036.63)
		event.set_object_sequence_rotation(1, 0.0, 2.11, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -1896.36, 0.0, 2049.25)
		event.set_object_sequence_rotation(0, 0.0, 1.79, 0.0)
		event.rotate_object_sequence(1, 0.0, -2.97, 0.0, 45)
		event.move_object_sequence(1, -1803.2, 0.0, 1972.96, 45, 1)
		event.delay_object_sequence_motion_track(1, 45)
		event.set_object_sequence_motion(1, "立ち")
		event.rotate_object_sequence(0, 0.0, -2.45, 0.0, 45)
		event.move_object_sequence(0, -1824.29, 0.0, 1990.37, 45, 1)
		event.delay_object_sequence_motion_track(0, 45)
		event.set_object_sequence_motion(0, "立ち")
		at = 8
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "爆発", 6)
		event.queue_object_sequence_next_motion(0, "爆発L", 4)
		event.set_object_sequence_motion(1, "爆発", 6)
		event.queue_object_sequence_next_motion(1, "爆発L", 4)
		at = 9
		helper_888ab2a3(80)
		event.set_object_handle_visible(6, 1)
		event.set_object_handle_visible(7, 1)
		event.set_object_handle_visible(8, 1)
		event.shake_camera_sequence_vertically(1.0, 1.0, 0.0, -1)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(6, 2.0, 2.0, 2.0)
		event.set_object_sequence_position(6, -2984.05, 97.41, 475.09)
		event.set_object_sequence_motion(6, "大爆発", 6)
		at = 10
		helper_888ab2a3(20)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(7, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(7, -3204.45, 289.83, 709.72)
		event.set_object_sequence_motion(7, "大爆発", 6)
		at = 11
		helper_888ab2a3(10)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(8, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(8, -3463.32, 912.11, 504.04)
		event.set_object_sequence_motion(8, "大爆発", 6)
		at = 12
		helper_888ab2a3(30)
		event.reset_object_sequence_motion(6)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(6, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(6, -3510.92, 560.62, 285.51)
		event.set_object_sequence_motion(6, "大爆発", 6)
		at = 13
		helper_888ab2a3(15)
		event.reset_object_sequence_motion(7)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(7, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(7, -3204.45, 289.83, 709.72)
		event.set_object_sequence_motion(7, "大爆発", 6)
		at = 14
		helper_888ab2a3(10)
		event.reset_object_sequence_motion(8)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(8, 5.0, 5.0, 5.0)
		event.set_object_sequence_position(8, -3068.72, 458.65, 504.04)
		event.set_object_sequence_motion(8, "大爆発", 6)
		at = 15
		wait_objects(6)
		at = 16
		helper_888ab2a3(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1759.38, 5.5, 1964.74)
		event.set_camera_sequence_look_at(-1844.27, 25.84, 1966.01)
		event.set_object_handle_visible(28, 0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_visible(7, 0)
		event.set_object_handle_visible(8, 0)
		event.set_object_handle_visible(26, 0)
		event.set_object_handle_visible(27, 1)
		x = vm.f32(-1806.27)
		y = vm.f32(19.47)
		z = vm.f32(1965.44)
		do
			local out1, out2, out3 = event.subtract_vectors(x, y, z, -1845.82, 23.73, 1914.09)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		event.set_wind(10, x, y, z)
		event.set_object_handle_visible(14, 1)
		event.set_object_sequence_position(14, -1878.23, 50.83, 1917.42)
		event.set_object_sequence_rotation(14, 0.0, 1.68, 0.0)
		event.set_object_sequence_position(1, -1821.13, 0.0, 1967.45)
		event.set_object_sequence_rotation(1, 0.0, -2.37, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, -1828.24, 0.0, 1988.57)
		event.set_object_sequence_rotation(0, 0.0, -2.05, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		at = 17
		helper_888ab2a3(120)
		event.set_character_visible(23, 0, 1, 0.1)
		event.set_wind(-1)
		at = 18
		helper_888ab2a3(60)
		event.move_camera_sequence_eased(-1956.66, 22.88, 2209.65, -2035.8, 47.24, 2044.77, 120, 2, 0.1)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, -1.21, 0.0, 12)
		event.move_object_sequence(0, -1934.22, 0.0, 2047.37, 60)
		at = 19
		helper_888ab2a3(5)
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, -1.29, 0.0, 12)
		event.move_object_sequence(1, -1902.38, 0.0, 2048.25, 60)
		at = 20
		helper_888ab2a3(55)
		event.rotate_object_sequence(0, 0.0, -2.53, 0.0, 50)
		event.move_object_sequence(0, -2063.61, 0.0, 2032.5, 50)
		at = 21
		helper_888ab2a3(5)
		event.rotate_object_sequence(1, 0.0, -2.61, 0.0, 50)
		event.move_object_sequence(1, -2029.94, 0.0, 2020.81, 50)
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(1, 50)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_out_music(30)
		at = 22
		wait_objects(0)
		at = 23
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 4)
		event.set_object_sequence_motion(0, "やった", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 24
		helper_4116e6bb(5160020)
		at = 25
		wait_objects(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 26
		helper_4116e6bb(5160030)
		event.play_sound_effect(var0, 5)
		at = 27
		helper_888ab2a3(90)
		event.stop_music(0)
		at = 28
		helper_888ab2a3(4)
		event.load_music(32)
		event.play_music(0)
		event.set_object_sequence_motion(0, "右上見る", 6)
		event.queue_object_sequence_next_motion(0, "右上見るL", 4)
		event.set_object_sequence_motion(1, "右上見る", 6)
		event.queue_object_sequence_next_motion(1, "右上見るL", 4)
		event.set_object_sequence_position(17, 3172.3, 1692, -5181.7)
		event.set_object_sequence_rotation(17, 0.0, -1.65, 0.0)
		at = 29
		wait_objects(0)
		event.move_camera_sequence_eased(-2070.54, 130.56, 2336.88, -2025.9, 157.89, 2103.23, 120, 2, 0.7)
		event.move_object_sequence(17, -1269.1, 1692, -5023.1, 360)
		at = 30
		wait_camera()
		event.set_object_sequence_color(29, 128, 128, 128, 128, 30)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.set_object_sequence_position(0, -2061.96, 0.0, 2020.59)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(0, 0.0, -2.29, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -2053.46, 0.0, 2005.77)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_rotation(1, 0.0, -2.13, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		at = 31
		helper_888ab2a3(100)
		event.set_object_sequence_color(29, 128, 128, 128, 0, 30)
		at = 32
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-2086.09, 20.41, 2006.88)
		event.set_camera_sequence_look_at(-2057.35, 23.47, 2014.36)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 33
		helper_4116e6bb(5160040)
		at = 34
		wait_objects(17)
		event.stop_sound_effect(var0, 5)
		event.play_sound_effect(var0, 6)
		event.play_sound_effect(var0, 7)
		event.set_camera_sequence_position(-2269.17, 1948.94, -4490.73)
		event.set_camera_sequence_look_at(-1666.2, 1723.94, -4850.99)
		event.set_object_handle_visible(2, 1)
		event.move_camera_sequence(-2176.13, 1941.15, -4546.3, -1666.2, 1723.94, -4850.99, 60)
		at = 35
		wait_camera()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1687.33, 1724.29, -4834.16)
		event.set_camera_sequence_look_at(-1674.47, 1722.82, -4853.32)
		event.set_object_sequence_motion(2, "下向き会話", 6)
		event.queue_object_sequence_next_motion(2, "下向き立ち", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "下目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 36
		helper_4116e6bb(5160050)
		at = 37
		wait_objects(2)
		event.set_camera_sequence_position(-1563.71, 1717.81, -4937.18)
		event.set_camera_sequence_look_at(-1618.97, 1724.21, -4901.16)
		event.move_camera_sequence_eased(-1643.48, 1700.93, -4929.83, -1568.23, 1725.22, -4920.42, 170, 0, 0.6)
		event.play_sound_effect(var0, 8)
		event.set_object_sequence_motion(2, "歩き")
		event.rotate_object_sequence(2, 0.0, 2.07, 0.0, 12)
		event.move_object_sequence(2, -1577.9, 1692.06, -4923.4, 180)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 38
		helper_0382f327(5160060, 120)
		at = 39
		helper_888ab2a3(45)
		event.stop_sound_effect(var0, 8)
		event.stop_sound_effect(var0, 7)
		event.stop_sound_effect(var0, 6)
		event.play_sound_effect(var0, 12)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-830.14, 270.67, 1420.39)
		event.set_camera_sequence_look_at(-504.92, 480.66, 900.5)
		event.set_object_sequence_position(17, -139, 555.9, 667.2)
		event.set_object_sequence_rotation(17, 0.0, -2.45, 0.0)
		event.set_object_sequence_scale(22, 1.0, 0.0, 1.0)
		event.set_object_sequence_scale(23, 1.0, 0.0, 1.0)
		event.set_object_sequence_scale(24, 1.0, 0.0, 1.0)
		event.set_object_sequence_scale(25, 1.0, 0.0, 1.0)
		event.set_object_sequence_position(18, 453.231, -137.116, 64.3042)
		event.set_object_sequence_position(19, 453.231, -137.116, -28.3794)
		event.set_object_sequence_position(20, 361.006, -137.116, -275.332)
		event.set_object_sequence_position(21, 310.085, -137.116, -351.233)
		event.play_sound_effect(var0, 11)
		event.rotate_object_sequence(19, 0.09, 1.57, -0.09, 60)
		at = 40
		helper_888ab2a3(30)
		event.rotate_object_sequence(18, 0.09, 1.57, -0.09, 60)
		event.rotate_object_sequence(20, 0.0, 2.26, -0.17, 60)
		event.rotate_object_sequence(21, 0.0, 2.26, -0.17, 60)
		at = 41
		helper_888ab2a3(90)
		event.play_sound_effect(var0, 13)
		event.set_object_handle_visible(4, 1)
		event.set_object_sequence_rotation(4, -0.09, -0.49, 0.09)
		event.set_object_sequence_position(4, -590.74, 404.66, 956.92)
		event.set_object_sequence_motion(4, "連射", 4)
		event.set_object_handle_visible(5, 1)
		event.set_object_sequence_rotation(5, -0.09, -0.49, 0.09)
		event.set_object_sequence_position(5, -528.29, 404.66, 1025.52)
		event.set_object_sequence_motion(5, "連射", 4)
		at = 42
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-363.49, 1147.12, 997.14)
		event.set_camera_sequence_look_at(320.6, 1309.16, 876.66)
		event.play_sound_effect(var0, 13)
		event.set_object_sequence_rotation(4, -0.09, -0.49, 0.09)
		event.set_object_sequence_position(4, 4228.42, 1628.46, 1164.08)
		event.set_object_sequence_motion(4, "連射", 4)
		event.set_object_sequence_rotation(5, -0.09, -0.49, 0.09)
		event.set_object_sequence_position(5, 4307.65, 1629.32, 1204.73)
		event.set_object_sequence_motion(5, "連射", 4)
		event.set_object_sequence_position(17, 4574.6, 1784.4, 731.6)
		event.set_object_sequence_rotation(17, 0.0, -2.39, 0.0)
		event.move_camera_sequence(-3928.7, 1344.83, -1526.92, -1604.39, 1825.07, -2517.04, 90)
		event.move_object_sequence(17, -393, 1784.4, -2820, 90)
		event.move_object_sequence(4, -831.8, 1632.54, -2496.46, 90)
		event.rotate_object_sequence(4, -0.09, -0.73, 0.09, 90)
		event.move_object_sequence(5, -766.74, 1632.54, -2431.66, 90)
		event.rotate_object_sequence(5, -0.09, -0.49, 0.09, 90)
		at = 43
		helper_888ab2a3(90)
		event.set_object_sequence_position(0, -2118.68, 0.0, 1811.45)
		event.set_object_sequence_rotation(0, 0.0, 1.95, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -2126.8, 0.0, 1772.4)
		event.set_object_sequence_rotation(1, 0.0, 2.19, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_camera_sequence_position(-2091.86, 22.87, 1798.52)
		event.set_camera_sequence_look_at(-2117.77, 22.96, 1810.6)
		event.stop_sound_effect(var0, 12)
		event.play_sound_effect(var0, 15)
		event.play_sound_effect(var0, 14)
		event.set_object_sequence_motion(0, "攻撃してきた！！", 6)
		event.queue_object_sequence_next_motion(0, "攻撃してきた！！L", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "大口パク")
		at = 44
		helper_0382f327(5160070, 90)
		event.stop_sound_effect(var0, 15)
		event.set_camera_sequence_position(-2201.73, 3.46, 1889.23)
		event.set_camera_sequence_look_at(-1989.51, 56.22, 1730.41)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.set_object_sequence_position(17, 1789, 1284.4, -336.2)
		event.set_object_sequence_rotation(17, 0.0, -2.44, 0.0)
		event.set_object_sequence_rotation(4, -0.09, -0.85, 0.09)
		event.set_object_sequence_position(4, 1337.12, 1132.18, -39.15)
		event.set_object_sequence_rotation(5, -0.09, -0.85, 0.09)
		event.set_object_sequence_position(5, 1396.86, 1130.86, 32.17)
		event.move_object_sequence(17, -393, 1284.4, -2820, 150)
		event.move_object_sequence(4, -831.8, 1132.54, -2496.46, 150)
		event.rotate_object_sequence(4, -0.09, -0.73, 0.09, 150)
		event.move_object_sequence(5, -766.74, 1132.54, -2431.66, 150)
		event.rotate_object_sequence(5, -0.09, -0.49, 0.09, 150)
		event.delay_camera_sequence_position_track(30)
		event.set_camera_sequence_position(-2052.46, 8.64, 2070.3)
		event.set_camera_sequence_look_at(-2005.7, 60.1, 1797.97)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, 0.63, 0.0, 12)
		event.move_object_sequence(0, -2009.14, 0.0, 1963.15, 75)
		event.delay_object_sequence_motion_track(0, 75)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, 0.51, 0.0, 12)
		event.move_object_sequence(1, -2019.49, 0.0, 1931.46, 75)
		event.delay_object_sequence_motion_track(1, 75)
		event.set_object_sequence_motion(1, "左向くL")
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_position(10, -2222.67, 0.0, 1847.93)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 45
		helper_888ab2a3(3)
		event.set_object_sequence_position(11, -2081.98, 0.0, 1742.24)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 46
		helper_888ab2a3(3)
		event.set_object_sequence_position(10, -2135.97, 0.0, 1881.42)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 47
		helper_888ab2a3(3)
		event.set_object_sequence_position(11, -2207.11, 0.0, 1907.68)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 48
		helper_888ab2a3(3)
		event.set_object_sequence_position(10, -2182.0, 0.0, 1801.12)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 49
		helper_888ab2a3(3)
		event.set_object_sequence_position(11, -2124.16, 0.0, 1760.75)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 50
		helper_888ab2a3(3)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_position(10, -2179.12, 0.0, 1835.11)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 51
		helper_888ab2a3(3)
		event.set_object_sequence_position(11, -2139.18, 0.0, 1814.26)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 52
		helper_888ab2a3(3)
		event.set_object_sequence_position(10, -2149.02, 0.0, 1845.22)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 53
		helper_888ab2a3(3)
		event.set_object_sequence_position(11, -2088.02, 0.0, 1809.06)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 54
		helper_888ab2a3(3)
		event.set_object_sequence_position(10, -2149.69, 0.0, 1874.46)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 55
		helper_888ab2a3(3)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_position(11, -2094.38, 0.0, 1854.15)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 56
		helper_888ab2a3(3)
		event.set_object_sequence_position(10, -2105.71, 0.0, 1870.56)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 57
		helper_888ab2a3(3)
		event.set_object_sequence_position(11, -2044.0, 0.0, 1853.9)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 58
		helper_888ab2a3(3)
		event.set_object_sequence_position(10, -2113.06, 0.0, 1923.45)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 59
		helper_888ab2a3(3)
		event.set_object_sequence_position(11, -1944.54, 19.55, 1825.69)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 60
		helper_888ab2a3(3)
		event.set_object_sequence_position(10, -2038.0, 0.0, 1928.48)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 61
		helper_888ab2a3(3)
		event.set_object_sequence_position(11, -1937.33, 48.6, 1850.63)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 62
		helper_888ab2a3(3)
		event.set_object_sequence_position(10, -1926.89, 58.67, 1859.58)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 63
		helper_888ab2a3(3)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_position(11, -1883.51, 46.67, 1805.86)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		event.set_object_sequence_position(0, -1995.65, 0.0, 1949.58)
		event.set_object_sequence_rotation(0, 0.0, -1.17, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -2003.28, 0.0, 1930.13)
		event.set_object_sequence_rotation(1, 0.0, -1.29, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.stop_sound_effect(var0, 12)
		event.play_sound_effect(var0, 17)
		event.play_sound_effect(var0, 18)
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_camera_sequence_position(-2055.47, 22.7, 1963.27)
		event.set_camera_sequence_look_at(-1991.1, 19.3, 1932.54)
		event.play_sound_effect(var0, 22)
		event.delay_object_sequence_motion_track(0, 30)
		event.play_sound_effect(var0, 23)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 64
		helper_4116e6bb(5160080)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目～おこり目")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 65
		helper_4116e6bb(5160085)
		at = 66
		wait_objects(17)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_camera_sequence_position(-2446.16, 9.76, 2115.63)
		event.set_camera_sequence_look_at(-2215.58, 87.07, 1943.17)
		event.stop_sound_effect(var0, 17)
		event.stop_sound_effect(var0, 18)
		event.play_sound_effect(var0, 19)
		event.set_object_sequence_position(17, 2996.1, 1784.4, -684.4)
		event.set_object_sequence_rotation(17, 0.0, -2.44, 0.0)
		event.set_object_sequence_rotation(3, -0.09, -0.97, 0.09)
		event.set_object_sequence_position(3, 2525.53, 1980.24, 186.43)
		event.delay_object_sequence_motion_track(3, 90)
		event.set_object_sequence_motion(3, "発射", 4)
		event.delay_object_sequence_sound_track(3, 30)
		event.play_object_sequence_sound(3, var0, 20)
		event.move_object_sequence(17, -393, 1784.4, -2820, 300)
		event.move_object_sequence(3, -846.75, 1980.24, -1950.79, 300)
		at = 67
		helper_888ab2a3(30)
		event.set_object_handle_visible(3, 1)
		at = 68
		helper_888ab2a3(30)
		event.set_object_handle_visible(9, 1)
		event.set_object_sequence_position(9, -2118.68, 0.0, 1811.45)
		event.set_object_sequence_motion(9, "砲着弾", 6)
		event.set_object_sequence_scale(9, 2.0, 2.0, 2.0)
		event.play_sound_effect(var0, 21)
		at = 69
		helper_888ab2a3(10)
		event.set_object_handle_visible(3, 0)
		event.set_wind(10, x, y, z)
		event.shake_camera_sequence_vertically(1.0, 2.0, 0.0, 90)
		at = 70
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-2055.47, 22.7, 1963.27)
		event.set_camera_sequence_look_at(-1991.1, 19.3, 1932.54)
		event.set_object_handle_visible(14, 1)
		event.set_object_sequence_position(14, -1832.24, 10.3, 1915.21)
		event.set_object_sequence_rotation(14, 0.0, 2.28, 0.0)
		event.stop_sound_effect(var0, 19)
		event.play_sound_effect(var0, 24)
		event.play_sound_effect(var0, 25)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目とじ顔")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "目とじ顔")
		event.reset_object_sequence_motion(1)
		event.set_object_sequence_motion(1, "爆風", 6)
		event.queue_object_sequence_next_motion(1, "爆風L", 4)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "爆風", 6)
		event.queue_object_sequence_next_motion(0, "爆風L", 4)
		at = 71
		helper_888ab2a3(120)
		event.set_character_visible(23, 0, 1, 0.1)
		event.set_wind(-1)
		at = 72
		helper_888ab2a3(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目とじ顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "目とじ顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.set_object_sequence_motion(1, "ユリス見る", 6)
		event.queue_object_sequence_next_motion(1, "ユリス見るL", 4)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "モニカ見る", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見るL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 73
		helper_4116e6bb(5160090)
		event.set_object_sequence_motion(0, "うなづき", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見るL", 4)
		event.play_sound_effect(var0, 26)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 74
		helper_4116e6bb(5160100)
		at = 75
		wait_objects(0)
		at = 76
		helper_888ab2a3(20)
		event.set_object_sequence_motion(1, "→左向き立ち", 4)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_object_sequence_motion(0, "→右向き立ち", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		at = 77
		helper_888ab2a3(30)
		event.set_object_sequence_motion(0, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.play_sound_effect(var0, 26)
		event.set_object_sequence_motion(1, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		at = 78
		wait_objects(0)
		at = 79
		helper_888ab2a3(20)
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, -2.49, 0.0, 12)
		event.move_object_sequence(1, -2036.12, 0.0, 1861.33, 60, 1)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, 0.63, 0.0, 12)
		event.move_object_sequence(0, -1971.28, 0.0, 2032.87, 60, 1)
		at = 80
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		at = 81
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(4)
		end
		if at <= 2 then
			helper_038a2e4d(30)
		end
		if at <= 3 then
			helper_038a2e4d(60)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_53ffe901(5160010, 90)
		end
		if at <= 6 then
			helper_038a2e4d(90)
		end
		if at <= 7 then
			helper_038a2e4d(10)
		end
		if at <= 8 then
			helper_038a2e4d(80)
		end
		if at <= 9 then
			helper_038a2e4d(20)
		end
		if at <= 10 then
			helper_038a2e4d(10)
		end
		if at <= 11 then
			helper_038a2e4d(30)
		end
		if at <= 12 then
			helper_038a2e4d(15)
		end
		if at <= 13 then
			helper_038a2e4d(10)
		end
		if at <= 14 then
			helper_238b5abc(6)
		end
		if at <= 15 then
			helper_038a2e4d(30)
		end
		if at <= 16 then
			x = vm.f32(-1806.27)
			y = vm.f32(19.47)
			z = vm.f32(1965.44)
			helper_038a2e4d(120)
		end
		if at <= 17 then
			helper_038a2e4d(60)
		end
		if at <= 18 then
			helper_038a2e4d(5)
		end
		if at <= 19 then
			helper_038a2e4d(55)
		end
		if at <= 20 then
			helper_038a2e4d(5)
		end
		if at <= 21 then
			helper_238b5abc(0)
		end
		if at <= 22 then
			helper_038a2e4d(30)
		end
		if at <= 23 then
			helper_8cd371d7(5160020)
		end
		if at <= 24 then
			helper_238b5abc(0)
		end
		if at <= 25 then
			helper_8cd371d7(5160030)
		end
		if at <= 26 then
			helper_038a2e4d(90)
		end
		if at <= 27 then
			helper_038a2e4d(4)
		end
		if at <= 28 then
			helper_238b5abc(0)
		end
		if at <= 29 then
			helper_344d6cd8()
		end
		if at <= 30 then
			helper_038a2e4d(100)
		end
		if at <= 31 then
			helper_038a2e4d(30)
		end
		if at <= 32 then
			helper_8cd371d7(5160040)
		end
		if at <= 33 then
			helper_238b5abc(17)
		end
		if at <= 34 then
			helper_344d6cd8()
		end
		if at <= 35 then
			helper_8cd371d7(5160050)
		end
		if at <= 36 then
			helper_238b5abc(2)
		end
		if at <= 37 then
			helper_53ffe901(5160060, 120)
		end
		if at <= 38 then
			helper_038a2e4d(45)
		end
		if at <= 39 then
			helper_038a2e4d(30)
		end
		if at <= 40 then
			helper_038a2e4d(90)
		end
		if at <= 41 then
			helper_038a2e4d(30)
		end
		if at <= 42 then
			helper_038a2e4d(90)
		end
		if at <= 43 then
			helper_53ffe901(5160070, 90)
		end
		if at <= 44 then
			helper_038a2e4d(3)
		end
		if at <= 45 then
			helper_038a2e4d(3)
		end
		if at <= 46 then
			helper_038a2e4d(3)
		end
		if at <= 47 then
			helper_038a2e4d(3)
		end
		if at <= 48 then
			helper_038a2e4d(3)
		end
		if at <= 49 then
			helper_038a2e4d(3)
		end
		if at <= 50 then
			helper_038a2e4d(3)
		end
		if at <= 51 then
			helper_038a2e4d(3)
		end
		if at <= 52 then
			helper_038a2e4d(3)
		end
		if at <= 53 then
			helper_038a2e4d(3)
		end
		if at <= 54 then
			helper_038a2e4d(3)
		end
		if at <= 55 then
			helper_038a2e4d(3)
		end
		if at <= 56 then
			helper_038a2e4d(3)
		end
		if at <= 57 then
			helper_038a2e4d(3)
		end
		if at <= 58 then
			helper_038a2e4d(3)
		end
		if at <= 59 then
			helper_038a2e4d(3)
		end
		if at <= 60 then
			helper_038a2e4d(3)
		end
		if at <= 61 then
			helper_038a2e4d(3)
		end
		if at <= 62 then
			helper_038a2e4d(3)
		end
		if at <= 63 then
			helper_8cd371d7(5160080)
		end
		if at <= 64 then
			helper_8cd371d7(5160085)
		end
		if at <= 65 then
			helper_238b5abc(17)
		end
		if at <= 66 then
			helper_038a2e4d(30)
		end
		if at <= 67 then
			helper_038a2e4d(30)
		end
		if at <= 68 then
			helper_038a2e4d(10)
		end
		if at <= 69 then
			helper_038a2e4d(30)
		end
		if at <= 70 then
			helper_038a2e4d(120)
		end
		if at <= 71 then
			helper_038a2e4d(30)
		end
		if at <= 72 then
			helper_8cd371d7(5160090)
		end
		if at <= 73 then
			helper_8cd371d7(5160100)
		end
		if at <= 74 then
			helper_238b5abc(0)
		end
		if at <= 75 then
			helper_038a2e4d(20)
		end
		if at <= 76 then
			helper_038a2e4d(30)
		end
		if at <= 77 then
			helper_238b5abc(0)
		end
		if at <= 78 then
			helper_038a2e4d(20)
		end
		if at <= 79 then
			helper_038a2e4d(30)
		end
		if at <= 80 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 82
	vm.entry(82)
	event.cancel_drama_scene_skip()
	var6 = event.get_active_music_number() or var6
	if var6 ~= 32 then
		event.stop_music(0)
		at = 83
		helper_888ab2a3(4)
		event.load_music(32)
		event.play_music(0)
	end
	event.set_wind(-1)
	event.set_object_handle_visible(28, 0)
	event.set_object_handle_visible(26, 0)
	event.set_object_handle_visible(27, 1)
	event.stop_sound_effect(var0, 5)
	event.stop_sound_effect(var0, 15)
	event.stop_sound_effect(var0, 18)
	event.stop_sound_effect(var0, 17)
	event.stop_sound_effect(var0, 19)
	event.stop_sound_effect(var0, 24)
	event.stop_sound_effect(var0, 25)
	event.set_object_handle_visible(17, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_position(17, 3139.7, 9.0, 918.2)
	event.call_command(703, 17, 2.4260077, 0.0) -- retail: the handler rejects 3 arguments
	event.set_object_handle_position(18, 453.23, -137.116, 64.3042)
	event.set_object_handle_rotation(18, 0.09, 1.57, -0.09)
	event.set_object_handle_position(19, 453.231, -137.116, -28.3794)
	event.set_object_handle_rotation(19, 0.09, 1.57, -0.09)
	event.set_object_handle_position(20, 361.006, -137.116, -275.332)
	event.set_object_handle_rotation(20, 0.0, 2.26, -0.17)
	event.set_object_handle_position(21, 310.085, -137.116, -351.233)
	event.set_object_handle_rotation(21, 0.0, 2.26, -0.17)
	event.set_object_handle_scale(22, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(23, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(24, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(25, 1.0, 1.0, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(23)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_active(0)
	event.set_character_position(0, -2039.05, 0.0, 1976.01)
	event.set_character_rotation(0, 0.0, 1.99, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.show_dungeon_status_bar(1, 1.0)
end

--- Helper function.
local function helper_21910()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local result: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(520, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(35)
		event.load_map_sounds(5806)
		var0 = event.load_sound_effect_file_2(5806) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		print("1--------------------------------\n")
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
			active_chr_no = 0
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
			active_chr_no = 1
		end
		event.change_directory("event/e500/e520/")
		event.load_message_file(0, 5, "e520.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e520_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e520_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 9)
			event.load_equipment_model(5, 0, 4, "info", 9)
			event.load_equipment_model(5, 0, 3, "info", 9)
			event.load_equipment_model(5, 0, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e500/e520/e520_mints.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 9)
			event.attach_object_handle_to_character(0, 9)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 9)
			event.load_equipment_model(5, 1, 4, "info", 9)
			event.load_equipment_model(5, 1, 3, "info", 9)
			event.load_equipment_model(5, 1, 2, "info", 9, 10)
			event.load_equipment_model(5, 1, 0, "info", 9, 14)
			event.load_character_motion_pack(5, "event/e500/e520/e520_monica.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.attach_object_handle_to_character(5, 14)
			event.clear_object_sequence(5)
			event.set_object_sequence_object(5, 5)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(9)
		event.set_character_active(10)
		event.load_character(5, "event/e500/e520/e520_guiltoni.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2, 11)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e500/e520/e520_dsmoke.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(3, 12)
		event.clear_object_sequence(3, 12)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e500/e520/e520_mahou_h.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(4, 13)
		event.clear_object_sequence(4, 13)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_2(16, "p01_battleship")
		event.clear_object_sequence(16)
		event.set_object_sequence_object(16, 16)
		event.attach_object_handle_to_map_part_2(17, "p03_s2001")
		event.clear_object_sequence(17)
		event.set_object_sequence_object(17, 17)
		event.attach_object_handle_to_map_part_2(18, "p04_s2001")
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.attach_object_handle_to_map_part_2(19, "firesquall")
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.attach_object_handle_to_map_part_2(20, "p01_s2001")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.set_object_handle_visible(20, 1)
		event.create_character_sword_effect(14, 0, 5, 16, 8)
		event.set_character_sword_effect_texture(14, 0, 74, "sweff", 0, 0, 64, 32)
		event.create_character_sword_effect(14, 1, 5, 16, 8)
		event.set_character_sword_effect_texture(14, 1, 74, "sweff", 0, 0, 64, 32)
		event.initialize_effect_manager(5)
		event.load_effect_base("EVモニカ魔法－火")
		event.load_effect_base("EVモニカ魔法－火ヒット")
		event.load_effect_base("モニカ魔法－溜め")
		event.create_effect_work_buffer(5)
		event.set_character_active(0, 14)
		event.set_object_handle_position(0, -3391.16, 181.07, 100.69)
		event.set_object_handle_rotation(0, 0.0, -1.89, 0.0)
		event.set_object_handle_motion(0, "爆弾セット", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -792.45, 0.0, 2890.7)
		event.set_object_handle_rotation(1, 0.0, -2.13, 0.0)
		event.set_object_handle_motion(1, "走り", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -1961.74, 308.38, 537.92)
		event.set_object_handle_rotation(2, 0.0, 0.51, 0.0)
		event.set_object_handle_motion(2, "ガキどもめ", 4)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_handle_position(16, 1209.2, 1334.3, 0.0)
		event.set_object_handle_rotation(16, 0.0, -1.5707964, 0.0)
		event.set_object_handle_position(3, 1209.2, 1334.3, 0.0)
		event.set_object_handle_rotation(3, 0.0, -2.65, 0.0)
		event.set_object_handle_visible(2, 1)
		event.set_object_handle_visible(3, 1)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(16, 1)
		event.set_object_handle_visible(17, 0)
		event.set_object_handle_visible(18, 1)
		event.set_object_handle_visible(19, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1069.43, 18.8, 3159.35)
		event.set_camera_sequence_look_at(-1009.32, 43.21, 3030.33)
		event.set_event_projection(524.9)
		event.set_character_active(0)
		event.set_character_active(9)
		event.set_character_active(10)
		event.move_object_sequence(16, -389.1, 820, 0.0, 120)
		event.move_object_sequence(3, -389.1, 820, 0.0, 120)
		event.set_object_sequence_motion(1, "右向き走り")
		event.move_object_sequence(1, -985.05, 0.0, 2803.03, 120, 1)
		event.set_object_handle_frame_visible(2, "obj89", 0)
		event.set_scene_status_flags(1, 0, 8, 1)
		event.set_scene_status_flags(1, 9, 8, 1)
		event.set_scene_status_flags(1, 11, 8, 1)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		print("2--------------------------------\n")
		event.play_sound_effect(var0, 2)
		at = 3
		helper_888ab2a3(120)
		print("3--------------------------------\n")
		event.set_camera_sequence_position(-1986.48, 333.67, 558.59)
		event.set_camera_sequence_look_at(-1965.0, 337.43, 540.26)
		event.stop_sound_effect(var0, 2)
		event.play_sound_effect(var0, 3)
		print("4--------------------------------\n")
		event.set_object_sequence_position(16, -1947.7, 307.5, 101.3)
		event.set_object_sequence_rotation(16, 0.0, -2.1031218, 0.0)
		event.set_object_sequence_position(3, 1209.2, 1334.3, 0.0)
		event.set_object_sequence_rotation(3, 0.0, -2.1031218, 0.0)
		event.set_object_sequence_position(1, -2813.58, 84.71, 768.64)
		event.set_object_sequence_rotation(1, 0.0, 2.47, 0.0)
		x = vm.f32(-2438.17)
		y = vm.f32(332.67)
		z = 341.25
		do
			local out1, out2, out3 = event.subtract_vectors(x, y, z, -2380.18, 330.38, 324.27)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		event.set_wind(10, x, y, z)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "下目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 4
		helper_0382f327(5200010, -1)
		event.stop_sound_effect(var0, 3)
		event.play_sound_effect(var0, 4)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		event.set_object_sequence_motion(2, "落ちる", 6)
		event.queue_object_sequence_next_motion(2, "落ちるL", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "下向き～上向き")
		at = 5
		helper_888ab2a3(10)
		at = 6
		wait_camera()
		event.stop_sound_effect(var0, 4)
		event.play_music(0)
		event.set_camera_sequence_position(-2696.98, 45.16, 871.07)
		event.set_camera_sequence_look_at(-2807.7, 201.06, 594.2)
		event.play_sound_effect(var0, 5)
		event.play_sound_effect(var0, 6)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		event.set_object_handle_footstep_sound(1, 6)
		event.move_object_sequence(1, -2763.63, 157.55, 674.32, 60)
		at = 7
		helper_888ab2a3(60)
		event.stop_sound_effect(var0, 6)
		event.move_object_sequence(1, -2672.25, 236.43, 545.71, 60)
		at = 8
		helper_888ab2a3(60)
		event.stop_sound_effect(var0, 5)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		event.set_object_sequence_position(2, -1997.03, 308.38, 480.43)
		event.set_object_sequence_rotation(2, 0.0, -2.61, 0.0)
		event.set_object_sequence_motion(2, "なに？")
		event.set_object_sequence_position(1, -2470.35, 281.36, 358.2)
		event.set_object_sequence_rotation(1, 0.0, 1.99, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_event_projection(350.9)
		event.set_camera_sequence_position(-2437.16, 269.25, 417.91)
		event.set_camera_sequence_look_at(-2453.36, 309.91, 353.75)
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_motion(1, "飛び", 6)
		event.queue_object_sequence_next_motion(1, "飛びL", 4)
		event.move_object_sequence(1, -2414.26, 303.6, 328.1, 60)
		event.move_camera_sequence(-2415.91, 282.04, 390.68, -2416.07, 304.55, 359.36, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "大口パク")
		at = 9
		helper_0382f327(5200020, 50)
		at = 10
		helper_888ab2a3(5)
		event.set_object_sequence_position(1, -2282.71, 308.37, 346.12)
		event.set_camera_sequence_position(-2025.37, 340.27, 478.9)
		event.set_camera_sequence_look_at(-1996.22, 338.59, 478.94)
		event.set_event_projection(524.9)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "下目～おどろき目")
		event.set_mouth_texture_animations(2, "大口パク")
		at = 11
		helper_0382f327(5200030, -1)
		event.set_camera_sequence_position(-1937.42, 385.84, 606.52)
		event.set_camera_sequence_look_at(-2052.1, 341.76, 476.36)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_footstep_sound(1, 2)
		event.delay_object_sequence_sound_track(1, 30)
		event.play_object_sequence_sound(1, var0, 9)
		event.set_object_sequence_motion(1, "着地2", 4)
		event.set_object_sequence_motion_step(1, 0.25)
		event.queue_object_sequence_next_motion(1, "着地立ち", 6)
		event.set_object_sequence_rotation(1, 0.0, 1.99, 0.0)
		at = 12
		helper_888ab2a3(30)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-2045.44, 316.91, 227.14)
		event.set_camera_sequence_look_at(-2093.8, 322.86, 203.57)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_character_active(14)
		event.set_object_sequence_position(1, -2098.82, 307.87, 203.15)
		event.set_object_sequence_rotation(1, 0.0, 3.07, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		at = 13
		helper_888ab2a3(90)
		event.set_object_sequence_motion(2, "ガード連スタート", 4)
		event.set_object_sequence_motion(1, "魔法構え", 6)
		event.queue_object_sequence_next_motion(1, "魔法構えL", 4)
		event.set_object_sequence_position(2, -2098.82, 307.87, 203.15)
		event.set_object_sequence_rotation(2, 0.0, 1.27, 0.0)
		at = 14
		wait_objects(1)
		event.play_sound_effect(var0, 10)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(1, "item")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		result = event.create_effect_3("モニカ魔法－溜め", 9) or result
		event.set_effect_first_vector(pos_x, pos_y, pos_z)
		event.set_effect_second_vector(128, 64, 64)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 15
		helper_0382f327(5200040, -1)
		at = 16
		helper_888ab2a3(30)
		event.set_object_sequence_motion(1, "魔法撃つ", 4)
		event.stop_sound_effect(var0, 10)
		event.play_sound_effect(var0, 11)
		event.create_effect_2("EVモニカ魔法－火", 9)
		event.set_effect_first_vector(pos_x, pos_y, pos_z)
		event.set_effect_target(-1)
		event.finish_effect(9, result)
		at = 17
		helper_888ab2a3(20)
		event.set_object_sequence_motion(1, "魔法撃つ", 4)
		event.play_sound_effect(var0, 11)
		event.create_effect_2("EVモニカ魔法－火", 9)
		event.set_effect_first_vector(pos_x, pos_y, pos_z)
		event.set_effect_target(-1)
		event.finish_effect(9, result)
		at = 18
		helper_888ab2a3(10)
		event.set_object_sequence_motion(1, "魔法撃つ", 4)
		event.play_sound_effect(var0, 11)
		event.create_effect_2("EVモニカ魔法－火", 9)
		event.set_effect_first_vector(pos_x, pos_y, pos_z)
		event.set_effect_target(-1)
		event.finish_effect(9, result)
		at = 19
		helper_888ab2a3(10)
		event.set_object_handle_visible(20, 0)
		event.set_camera_sequence_position(-1961.75, 323.59, 207.69)
		event.set_camera_sequence_look_at(-2049.52, 323.57, 217.76)
		event.set_object_sequence_rotation(1, 0.0, 1.27, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.play_sound_effect(var0, 12)
		event.set_scene_character_type(13, 4)
		event.set_object_handle_visible(4, 1)
		event.set_object_sequence_position(4, -2039.14, 327.12, 209.19)
		event.set_object_sequence_motion(4, "魔法ヒット", 6)
		at = 20
		wait_objects(4)
		at = 21
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 13)
		event.set_object_sequence_motion(1, "よけ2つ")
		event.wait_object_sequence_motion_end(1)
		event.set_object_sequence_motion(2, "よけ2つ")
		event.wait_object_sequence_motion_end(2)
		at = 22
		helper_888ab2a3(15)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		at = 23
		helper_888ab2a3(15)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		at = 24
		helper_888ab2a3(10)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		at = 25
		helper_888ab2a3(20)
		event.set_object_handle_frame_visible(2, "obj88", 0)
		event.set_object_handle_frame_visible(2, "obj89", 1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		event.set_camera_sequence_position(-2063.52, 323.93, 286.2)
		event.set_camera_sequence_look_at(-2027.6, 321.15, 217.1)
		event.set_object_sequence_position(2, -2027.94, 307.87, 217.37)
		event.set_object_sequence_rotation(2, 0.0, -0.41, 0.0)
		event.reset_object_sequence_dynamic_animation(2)
		event.set_object_sequence_position(1, -2027.94, 307.87, 217.37)
		event.set_object_sequence_rotation(1, 0.0, -0.41, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.play_sound_effect(var0, 14)
		event.set_object_sequence_motion(1, "ムーンサルト", 6)
		event.wait_object_sequence_motion_end(1)
		event.set_object_sequence_motion(2, "ムーンサルト", 6)
		event.wait_object_sequence_motion_end(2)
		at = 26
		helper_888ab2a3(10)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		at = 27
		wait_objects(1)
		event.set_camera_sequence_position(-2082.67, 325.7, 160.89)
		event.set_camera_sequence_look_at(-2021.3, 327.3, 209.89)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(var0, 15)
		event.set_object_sequence_motion(1, "ぐらっ", 6)
		event.set_object_sequence_motion_step(1, 0.7)
		event.queue_object_sequence_next_motion(1, "ぐらっL", 4)
		event.set_object_sequence_motion(2, "ぐらっ", 6)
		event.set_object_sequence_motion_step(1, 0.7)
		event.queue_object_sequence_next_motion(2, "ぐらっL", 4)
		event.play_sound_effect(var0, 16)
		event.delay_camera_sequence_shake_track(15)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		at = 28
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 29
		helper_0382f327(5200050, -1)
		event.set_camera_sequence_position(-2043.31, 334.08, 203.6)
		event.set_camera_sequence_look_at(-2013.93, 336.49, 194.04)
		event.delay_object_sequence_sound_track(2, 8)
		event.play_object_sequence_sound(2, var0, 20)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 30
		helper_0382f327(5200060, -1)
		event.set_camera_sequence_position(-2058.89, 312.45, 158.48)
		event.set_camera_sequence_look_at(-2022.95, 325.53, 214.99)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～かはっ目")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "下目パチ")
		event.set_object_sequence_motion(1, "殴り", 6)
		event.queue_object_sequence_next_motion(1, "殴りL", 4)
		event.set_object_sequence_motion(2, "殴り", 6)
		event.queue_object_sequence_next_motion(2, "殴りL", 4)
		at = 31
		helper_888ab2a3(10)
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		at = 32
		helper_0382f327(5200070, -1)
		event.wait_object_sequence_motion_end(2)
		at = 33
		wait_objects(1)
		event.set_camera_sequence_position(-2025.6, 317.11, 283.22)
		event.set_camera_sequence_look_at(-2022.52, 324.9, 217.92)
		at = 34
		helper_888ab2a3(20)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "くるし顔")
		event.detach_character_from_frame(14)
		event.set_object_sequence_position(5, -2016.36, 313.05, 230.26)
		event.set_object_sequence_rotation(5, 0.5, 1.67, 0.8)
		event.set_camera_sequence_position(-2038.22, 330.43, 198.53)
		event.set_camera_sequence_look_at(-2027.97, 333.86, 219.66)
		event.set_object_sequence_motion(1, "殴られ顔", 4)
		event.reset_object_sequence_dynamic_animation(1)
		at = 35
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-2063.52, 323.93, 286.2)
		event.set_camera_sequence_look_at(-2027.6, 321.15, 217.1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "くるし顔")
		event.set_object_sequence_texture_animation(1, 1, "かはっ目～目とじ")
		event.set_object_sequence_texture_animation(1, 1, "口あけ～口とじ")
		event.play_sound_effect(var0, 21)
		event.play_sound_effect(var0, 22)
		event.move_object_sequence(5, -2016.36, 308.85, 230.26, 6)
		event.rotate_object_sequence(5, 0.0, 1.67, 0.0, 6)
		event.move_object_sequence(5, -2016.36, 310.0, 230.26, 6)
		event.rotate_object_sequence(5, 0.4, 1.67, 0.5, 6)
		event.move_object_sequence(5, -2016.36, 308.85, 230.26, 5)
		event.rotate_object_sequence(5, 0.0, 1.67, 0.0, 5)
		event.set_object_sequence_motion(1, "かかえ", 6)
		event.queue_object_sequence_next_motion(1, "かかえL", 4)
		event.set_object_sequence_motion(2, "かかえ", 6)
		event.queue_object_sequence_next_motion(2, "かかえL", 4)
		event.wait_object_sequence_motion_end(2)
		at = 36
		helper_888ab2a3(60)
		event.set_object_sequence_position(0, -2213.52, 0.0, 1691.84)
		event.set_object_sequence_rotation(0, 0.0, 2.83, 0.0)
		event.set_camera_sequence_position(-2040.48, 335.59, 231.83)
		event.set_camera_sequence_look_at(-2021.29, 337.31, 214.72)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "死に")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "下目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 37
		helper_0382f327(5200080, -1)
		event.delay_camera_sequence_shake_track(30)
		event.shake_camera_sequence(0.0, 0.2, 0.0, -1)
		event.play_sound_effect(var0, 23)
		at = 38
		helper_888ab2a3(60)
		event.set_object_sequence_motion(2, "上見", 6)
		event.queue_object_sequence_next_motion(2, "上見L", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_mouth_texture_animations(2, "おこり口パク")
		at = 39
		helper_0382f327(5200090, -1)
		event.stop_sound_effect(var0, 8)
		event.stop_sound_effect(var0, 23)
		event.set_wind(-1)
		event.clear_camera_sequence()
		event.set_object_handle_visible(20, 1)
		event.set_camera_sequence_position(-2307.42, 27.19, 1937.3)
		event.set_camera_sequence_look_at(-2258.86, 36.53, 1808.93)
		at = 40
		helper_888ab2a3(10)
		event.play_sound_effect(var0, 24)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_visible(1, 0)
		event.set_object_handle_visible(5, 0)
		event.move_object_sequence_eased(16, -604.5, -2501, 66.7, 360, 1, 0.7)
		event.rotate_object_sequence_eased(16, 0.0, -1.9024088, -0.6894051, 210, 1, 0.7)
		event.move_object_sequence_eased(3, -604.5, -2501, 66.7, 360, 1, 0.7)
		event.rotate_object_sequence_eased(3, 0.0, -1.6057029, -0.6894051, 210, 1, 0.7)
		at = 41
		helper_888ab2a3(90)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "大口パク")
		at = 42
		helper_0382f327(5200100, 60)
		event.move_camera_sequence_eased(-2198.1, 30.55, 1580.48, -2105.26, 29.78, 1380.32, 120, 1, 0.5)
		event.move_camera_sequence_eased(-2085.28, 88.8, 1337.19, -1972.16, 302.92, 1093.31, 90, 2, 1.0)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -2112.56, 0.0, 1396.51, 160)
		event.delay_object_sequence_motion_track(0, 160)
		event.set_object_sequence_motion(0, "立ち")
		at = 43
		helper_888ab2a3(90)
		event.fade_out_music(90)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 44
		helper_0382f327(5200110, 90)
		event.fade_out_screen(30)
		at = 45
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(4)
		end
		if at <= 2 then
			print("1--------------------------------\n")
			local _ = active_chr_no == 2
			active_chr_no = 0
			local _ = active_chr_no == 3
			active_chr_no = 1
			print("2--------------------------------\n")
			helper_038a2e4d(120)
		end
		if at <= 3 then
			print("3--------------------------------\n")
			print("4--------------------------------\n")
			x = vm.f32(-2438.17)
			y = vm.f32(332.67)
			z = 341.25
			helper_53ffe901(5200010, -1)
		end
		if at <= 4 then
			helper_038a2e4d(10)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_038a2e4d(60)
		end
		if at <= 7 then
			helper_038a2e4d(60)
		end
		if at <= 8 then
			helper_53ffe901(5200020, 50)
		end
		if at <= 9 then
			helper_038a2e4d(5)
		end
		if at <= 10 then
			helper_53ffe901(5200030, -1)
		end
		if at <= 11 then
			helper_038a2e4d(30)
		end
		if at <= 12 then
			helper_038a2e4d(90)
		end
		if at <= 13 then
			helper_238b5abc(1)
		end
		if at <= 14 then
			helper_53ffe901(5200040, -1)
		end
		if at <= 15 then
			helper_038a2e4d(30)
		end
		if at <= 16 then
			helper_038a2e4d(20)
		end
		if at <= 17 then
			helper_038a2e4d(10)
		end
		if at <= 18 then
			helper_038a2e4d(10)
		end
		if at <= 19 then
			helper_238b5abc(4)
		end
		if at <= 20 then
			helper_038a2e4d(30)
		end
		if at <= 21 then
			helper_038a2e4d(15)
		end
		if at <= 22 then
			helper_038a2e4d(15)
		end
		if at <= 23 then
			helper_038a2e4d(10)
		end
		if at <= 24 then
			helper_038a2e4d(20)
		end
		if at <= 25 then
			helper_038a2e4d(10)
		end
		if at <= 26 then
			helper_238b5abc(1)
		end
		if at <= 27 then
			helper_038a2e4d(15)
		end
		if at <= 28 then
			helper_53ffe901(5200050, -1)
		end
		if at <= 29 then
			helper_53ffe901(5200060, -1)
		end
		if at <= 30 then
			helper_038a2e4d(10)
		end
		if at <= 31 then
			helper_53ffe901(5200070, -1)
		end
		if at <= 32 then
			helper_238b5abc(1)
		end
		if at <= 33 then
			helper_038a2e4d(20)
		end
		if at <= 34 then
			helper_038a2e4d(30)
		end
		if at <= 35 then
			helper_038a2e4d(60)
		end
		if at <= 36 then
			helper_53ffe901(5200080, -1)
		end
		if at <= 37 then
			helper_038a2e4d(60)
		end
		if at <= 38 then
			helper_53ffe901(5200090, -1)
		end
		if at <= 39 then
			helper_038a2e4d(10)
		end
		if at <= 40 then
			helper_038a2e4d(90)
		end
		if at <= 41 then
			helper_53ffe901(5200100, 60)
		end
		if at <= 42 then
			helper_038a2e4d(90)
		end
		if at <= 43 then
			helper_53ffe901(5200110, 90)
		end
		if at <= 44 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 46
	vm.entry(46)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 8, 0)
	event.set_scene_status_flags(1, 9, 8, 0)
	event.set_scene_status_flags(1, 11, 8, 0)
	event.set_wind(-1)
	event.set_object_handle_visible(3, 0)
	event.set_object_handle_visible(16, 0)
	event.stop_music(0)
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 3)
	event.stop_sound_effect(var0, 4)
	event.stop_sound_effect(var0, 5)
	event.stop_sound_effect(var0, 6)
	event.stop_sound_effect(var0, 8)
	event.stop_sound_effect(var0, 9)
	event.stop_sound_effect(var0, 10)
	event.stop_sound_effect(var0, 16)
	event.stop_sound_effect(var0, 23)
	event.stop_sound_effect(var0, 24)
	event.set_object_handle_visible(16, 0)
	event.set_object_handle_visible(20, 1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_position(16, 3139.7, 9.0, 918.2)
	event.call_command(703, 16, 2.4260077, 0.0) -- retail: the handler rejects 3 arguments
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.load_message_file(0, -1)
	event.delete_event_image(0)
	event.delete_event_image(1)
	event.clear_effect_manager()
	event.set_character_active(0)
	event.set_character_position(0, -2213.52, 0.0, 1691.84)
	event.set_character_rotation(0, 0.0, 2.59, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.show_dungeon_status_bar(1, 1.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_10c74()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: any = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local active_chr_no_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 20, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			at = 3
			helper_888ab2a3(10)
			event.set_character_position(0, -2074.0, -7.0, 3098.8)
			event.set_character_rotation(0, 0.0, 3.05, 0.0)
			event.set_camera_position(-2086.23, 51.55, 3226.23)
			event.set_camera_look_at(-2074.0, 22.99, 3098.82)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		flag = event.get_save_flag(516) or flag
		flag_2 = event.get_save_flag(520) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var3 = 1
		else
			at = 4
			var3 = helper_ed4dc120(2, -1)
		end
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var3 == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-2067.37, 112.9, 2821.78)
			event.set_camera_sequence_look_at(-2002.24, 24.33, 3103.52)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -2000.28, 0.23, 3105.85)
			event.add_object_sequence_path_point(0, -2010.93, -14.79, 3194.18)
			event.add_object_sequence_path_point(0, -2000.43, -24.24, 3288.22)
			event.add_object_sequence_path_point(0, -1957.41, -49.2, 3404.27)
			event.start_object_sequence_path(0)
			at = 5
			helper_888ab2a3(40)
			event.fade_out_screen(20)
			at = 6
			helper_888ab2a3(20)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			var7 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 40.0) + var4)
			var8 = 0.0
			var9 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 40.0) + var6)
			event.move_object_sequence(0, var7, var8, var9, 30, 1)
			event.turn_object_sequence_toward(0, var7, var8, var9, 10)
			event.set_object_sequence_motion(0, "歩き")
			var10 = 0
			while var10 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var4 = out1 or var4
					var5 = out2 or var5
					var6 = out3 or var6
				end
				var5 = vm.f32(var5 + 30.0)
				event.set_camera_look_at(var4, var5, var6)
				var10 = var10 + 1
				at = 7
				vm.wait(7)
			end
			event.set_object_sequence_motion(0, "立ち")
		end
		if flag ~= 0 and flag_2 == 0 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			active_chr_no_2 = event.get_playable_character() or active_chr_no_2
			if active_chr_no_2 == 0 then
				event.open_message_window_2(0, "「ライドポッド」で応戦だ！")
			else
				event.open_message_window_2(0, "ユリス、「ライドポッド」で応戦よ！")
			end
			at = 8
			helper_75684dd8(0, -1, 5, 256, 208)
		end
		event.set_object_handle_footstep_sound(0, 0)
		event.reset_follow_camera(0)
		event.finish_event()
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				helper_038a2e4d(10)
			end
			return 0
		end
		if at <= 6 then
			if at == 4 then
				var3 = received[1] :: number
			end
			if at <= 4 then
				helper_038a2e4d(40)
			end
			if at <= 5 then
				helper_038a2e4d(20)
			end
			return 1
		end
		if at <= 8 then
			if at <= 7 then
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_11f38()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: any = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local flag_3: s32 = 0
	local active_chr_no_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 20, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			at = 3
			helper_888ab2a3(10)
			event.set_character_position(0, 1459.7, -279.01, 2009.85)
			event.set_character_rotation(0, 0.0, -1.77, 0.0)
			event.set_camera_position(1584.28, -250.6, 2035.61)
			event.set_camera_look_at(1459.7, -249.01, 2009.85)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		flag = event.get_save_flag(516) or flag
		flag_2 = event.get_save_flag(520) or flag_2
		if flag == 0 or flag_2 == 0 then
			var3 = 1
		else
			at = 4
			var3 = helper_ed4dc120(1, -1)
		end
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var3 == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(1237.07, -178.87, 1868.72)
			event.set_camera_sequence_look_at(1400.74, -221.62, 1965.01)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, 1494.73, -279.24, 2020.78)
			event.add_object_sequence_path_point(0, 1549.77, -279.45, 2063.4)
			event.add_object_sequence_path_point(0, 1615.07, -279.45, 2101.81)
			event.add_object_sequence_path_point(0, 1681.3, -279.46, 2136.65)
			event.start_object_sequence_path(0)
			at = 5
			helper_888ab2a3(40)
			event.fade_out_screen(20)
			at = 6
			helper_888ab2a3(20)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			var7 = vm.f32(vm.f32(vm.sin(-2.0) * 50.0) + var4)
			var8 = 0.0
			var9 = vm.f32(vm.f32(vm.cos(-2.0) * 50.0) + var6)
			event.move_object_sequence(0, var7, var8, var9, 30, 1)
			event.turn_object_sequence_toward(0, var7, var8, var9, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 30)
			event.set_object_sequence_motion(0, "立ち")
			var10 = 0
			while var10 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var4 = out1 or var4
					var5 = out2 or var5
					var6 = out3 or var6
				end
				var5 = vm.f32(var5 + 30.0)
				event.set_camera_look_at(var4, var5, var6)
				var10 = var10 + 1
				at = 7
				vm.wait(7)
			end
		end
		if flag == 0 or flag_2 == 0 then
			flag_3 = event.get_save_flag(508) or flag_3
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			active_chr_no_2 = event.get_playable_character() or active_chr_no_2
			if active_chr_no_2 == 0 then
				if flag == 0 then
					if flag_3 == 0 then
						event.open_message_window_2(
							0,
							"炎の雨を降らせているのは、\nあの機械みたいだ。<page>あれはほうっておけない！\nでも、どうすれば良いんだ？"
						)
					else
						event.open_message_window_2(0, "「ファイアースコール」を破壊しなきゃ！")
					end
				else
					event.open_message_window_2(0, "「ライドポッド」で応戦だ！")
				end
			elseif flag == 0 then
				if flag_3 == 0 then
					event.open_message_window_2(
						0,
						"炎の雨を降らせているのは、\nあの機械みたいだ。<page>あれはほうっておけない！\nでも、どうすれば良いんだ？"
					)
				else
					event.open_message_window_2(0, "「ファイアースコール」はこっちじゃないわよ。")
				end
			else
				event.open_message_window_2(0, "ユリス、「ライドポッド」で応戦よ！")
			end
			at = 8
			helper_75684dd8(0, -1, 5, 256, 208)
		end
		event.set_object_handle_footstep_sound(0, 0)
		event.reset_follow_camera(0)
		event.finish_event()
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				helper_038a2e4d(10)
			end
			return 0
		end
		if at <= 6 then
			if at == 4 then
				var3 = received[1] :: number
			end
			if at <= 4 then
				helper_038a2e4d(40)
			end
			if at <= 5 then
				helper_038a2e4d(20)
			end
			return 1
		end
		if at <= 8 then
			if at <= 7 then
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event_99()
	flag = event.get_save_flag(508) or flag
	flag_2 = event.get_save_flag(512) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_13e64()
	else
		helper_1069c()
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	vm.wait(1)
	helper_c956b4a2(32)
	event.finish_event()
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local item: s32 = 0
	local argc: s32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.apply_message_window_preset(0, 4)
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 22, 8, 0, 0)
			else
				at = 2
				helper_75684dd8(0, 23, 8, 0, 0)
			end
			event.finish_event()
			return
		end
		var1 = event.get_triggered_event_data_2(6) or var1
		if var1 == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			argc = event.get_item_count(372) or argc
			if argc <= 0 then
				event.open_message_window_2(
					0,
					"炎の雨を降らせているのは、\nこの機械みたいだ。<page>これはほうっておけない！\nでも、どうすれば良いんだ？\n（(#)でアイテム使用）"
				)
			else
				event.open_message_window_2(
					0,
					"「ファイアースコール」がある。\n（(#)ボタンでメニューを開く）"
				)
			end
			at = 3
			var4 = helper_c292fa16(0, -1, 5, 256, 208, var4)
			if var4 == 1 then
				var1 = 2
			end
		end
		if var1 == 2 then
			event.open_use_item_menu(372)
			at = 4
			vm.wait(4)
			item = vmhost.used_item() or item
			if item > 0 then
				if item == 372 then
					event.fade_out_screen(15)
					at = 5
					helper_888ab2a3(15)
					event.switch_dungeon_main_character(0)
					at = 6
					helper_15ae0()
					event.set_save_control_bits(1, 1)
					event.set_function_point_enabled("", "dun_entrance", 0)
					event.set_function_point_enabled("", "entrance", 0)
					event.set_character_change_enabled(3, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_character_change_enabled(1, 0)
					event.set_character_change_unmasked(1, 0)
					event.initialize_event()
					at = 7
					vm.wait(7)
					event.attach_object_handle_to_map_part_2(0, "p01_battleship")
					event.set_object_handle_visible(0, 1)
					event.load_dungeon_monster(517, 1)
					event.load_dungeon_monster(518, 0)
					event.load_dungeon_monster(519, 0)
					event.place_dungeon_monster(517, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.fade_in_screen(15)
					return
				else
					at = 8
					helper_5fb66cb1()
				end
			end
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 23, 8, 0, 0)
			end
			return 0
		end
		if at <= 7 then
			if at == 3 then
				var4 = received[2] :: number
			end
			if at <= 3 then
				local _ = var1 == 1
				var1 = 2
			end
			if at <= 4 then
				helper_038a2e4d(15)
			end
			if at <= 5 then
				at = 6
				helper_15ae0()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 1)
					event.set_function_point_enabled("", "dun_entrance", 0)
					event.set_function_point_enabled("", "entrance", 0)
					event.set_character_change_enabled(3, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_character_change_enabled(1, 0)
					event.set_character_change_unmasked(1, 0)
					event.initialize_event()
					at = 7
					vm.wait(7)
					event.attach_object_handle_to_map_part_2(0, "p01_battleship")
					event.set_object_handle_visible(0, 1)
					event.load_dungeon_monster(517, 1)
					event.load_dungeon_monster(518, 0)
					event.load_dungeon_monster(519, 0)
					event.place_dungeon_monster(517, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.fade_in_screen(15)
					return
				end)
			end
			return 0
		end
		if at <= 8 then
			return 0
		end
		return nil
	end)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		helper_888ab2a3(20)
		event.clear_event_battle_monsters(-1)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.return_monica_items_to_inventory()
		event.set_party_member(3, 0)
		event.set_character_change_enabled(3, 0)
		event.set_character_change_unmasked(3, 0)
		event.set_party_member(1, 0)
		event.set_character_change_enabled(1, 0)
		event.set_character_change_unmasked(1, 0)
		at = 2
		helper_21910()
		event.set_save_control_bits(1, 0)
		event.set_function_point_enabled("", "dun_entrance", 1)
		event.set_function_point_enabled("", "entrance", 1)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_21910()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 0)
					event.set_function_point_enabled("", "dun_entrance", 1)
					event.set_function_point_enabled("", "entrance", 1)
					event.finish_event()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	if helper_10c74() ~= 0 then
		event.load_event_script("d05/d05.stb", 1000)
	end
end

--- Event 551, which map data, a script or the engine runs by number.
function script.event_551()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	if helper_11f38() ~= 0 then
		stage_id = event.get_dungeon_stage_id() or stage_id
		var1 = event.get_dungeon_floor() or var1
		argc = event.get_dungeon_next_floor(var1, 0) or argc
		event.set_dungeon_floor(argc)
		event.set_dungeon_floor_info(stage_id, var1, 5, 2)
		event.set_dungeon_floor_info(stage_id, argc, 5, 1)
		event.load_event_script("d05/d05.stb", 1000)
	end
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(32)
	event.play_music(0)
	event.set_character_position(0, -1755.3, 0.0, 2614.3)
	event.attach_object_handle_to_map_part_2(0, "p01_battleship")
	event.set_object_handle_visible(0, 1)
	event.load_dungeon_monster(517, 1)
	event.load_dungeon_monster(518, 0)
	event.load_dungeon_monster(519, 0)
	event.place_dungeon_monster(517, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	vm.wait(2)
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_786b79f1(0)
end

--- Event 15120, which map data, a script or the engine runs by number.
script.event_15120 = helper_13e64

--- Event 15160, which map data, a script or the engine runs by number.
script.event_15160 = helper_15ae0

--- Event 15200, which map data, a script or the engine runs by number.
script.event_15200 = helper_21910

return script
