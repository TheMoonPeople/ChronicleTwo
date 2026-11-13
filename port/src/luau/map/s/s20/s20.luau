--!strict
--- Mount Gundor Peak events: the Firesquall, the battleship assault and the two exits to the dungeon.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Loads the peak sounds and shows or hides the map parts by progress flags.
local function initialize_peak()
	local assault_flag: s32 = 0
	local battle_done_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(5684)
	event.set_function_point_enabled("", "useitem_00", 0)
	event.set_function_point_enabled("", "dun_entrance", 1)
	event.set_function_point_enabled("", "entrance", 1)
	assault_flag = event.get_save_flag(516) or assault_flag
	event.get_item_count(372)
	if assault_flag == 0 then
		event.set_function_point_enabled("", "useitem_00", 1)
	end
	if assault_flag == 1 then
		event.attach_object_handle_to_map_part_2(0, "p03_s2001")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(0, "p04_s2001")
		event.set_object_handle_visible(0, 1)
	end
	event.attach_object_handle_to_map_part_2(0, "p01_battleship")
	event.set_object_handle_visible(0, 0)
	battle_done_flag = event.get_save_flag(520) or battle_done_flag
	if battle_done_flag ~= 0 then
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

--- Plays the short skippable cutscene in which the party arrives at the Firesquall and discusses it.
local function play_firesquall_arrival_scene()
	local sound_effects: s32 = 0
	local active_character: s32 = 0
	vm.section(function()
		event.set_save_flag(512, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		event.load_map_sounds(5800)
		sound_effects = event.load_sound_effect_file_2(5800) or sound_effects
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.change_directory("event/e500/e512/")
		event.load_message_file(0, 5, "e512.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e512_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e512_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_character == 1 then
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
		object.wait_until_done(0)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "指さす", 6)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5120010)
		event.set_camera_sequence_position(-1899.45, 48.16, 2384.53)
		event.set_camera_sequence_look_at(-2089.91, 113.14, 2148.64)
		event.play_sound_effect(sound_effects, 1)
		event.move_camera_sequence(-1960.89, 51.28, 2421.91, -2089.91, 113.14, 2148.64, 210)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5120020)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5120030)
		camera.wait_until_done()
		event.stop_sound_effect(sound_effects, 1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(sound_effects, 1)
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

--- Fades in on the player character running along a path into the map and then restores the follow camera.
local function run_in_from_entrance()
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
	wait.for_frame_count(60)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

--- Plays the long skippable Guiltoni battleship cutscene and then restores the player character and the field music.
local function play_battleship_assault_scene()
	local sound_effects: s32 = 0
	local active_character: s32 = 0
	local image_block: s32 = 0
	local wind_direction_x: f32 = 0
	local wind_direction_y: f32 = 0
	local wind_direction_z: f32 = 0
	local music_number: s32 = 0
	local progress: number = 0
	vm.section(function()
		progress = 1
		vm.entry(1)
		event.set_save_flag(516, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		progress = 2
		wait.for_frame_count(4)
		event.load_music(30)
		event.play_music(0)
		event.load_map_sounds(5803)
		sound_effects = event.load_sound_effect_file_2(5803) or sound_effects
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.change_directory("event/e500/e516/")
		event.load_message_file(0, 5, "e516.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e516_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e516_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		image_block = event.load_event_image_4(5, "e516telop01.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e516telop01", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(29, 0)
		event.clear_object_sequence(29)
		event.set_object_sequence_object(29, 29)
		event.change_directory("")
		if active_character == 1 then
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
		progress = 3
		wait.for_frame_count(30)
		event.play_sound_effect(sound_effects, 2)
		progress = 4
		wait.for_frame_count(60)
		event.set_object_sequence_motion(0, "セット完了", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		progress = 5
		object.wait_until_done(0)
		event.stop_sound_effect(sound_effects, 2)
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
		progress = 6
		message.show_voiced_for_stopping(5160010, 90)
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, 0.03, 0.0, 12)
		event.move_object_sequence(1, -3035.41, 56.31, 201.54, 90, 1)
		event.delay_object_sequence_motion_track(1, 90)
		progress = 7
		wait.for_frame_count(90)
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
		progress = 8
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "爆発", 6)
		event.queue_object_sequence_next_motion(0, "爆発L", 4)
		event.set_object_sequence_motion(1, "爆発", 6)
		event.queue_object_sequence_next_motion(1, "爆発L", 4)
		progress = 9
		wait.for_frame_count(80)
		event.set_object_handle_visible(6, 1)
		event.set_object_handle_visible(7, 1)
		event.set_object_handle_visible(8, 1)
		event.shake_camera_sequence_vertically(1.0, 1.0, 0.0, -1)
		event.play_sound_effect(sound_effects, 3)
		event.set_object_sequence_scale(6, 2.0, 2.0, 2.0)
		event.set_object_sequence_position(6, -2984.05, 97.41, 475.09)
		event.set_object_sequence_motion(6, "大爆発", 6)
		progress = 10
		wait.for_frame_count(20)
		event.play_sound_effect(sound_effects, 3)
		event.set_object_sequence_scale(7, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(7, -3204.45, 289.83, 709.72)
		event.set_object_sequence_motion(7, "大爆発", 6)
		progress = 11
		wait.for_frame_count(10)
		event.play_sound_effect(sound_effects, 3)
		event.set_object_sequence_scale(8, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(8, -3463.32, 912.11, 504.04)
		event.set_object_sequence_motion(8, "大爆発", 6)
		progress = 12
		wait.for_frame_count(30)
		event.reset_object_sequence_motion(6)
		event.play_sound_effect(sound_effects, 3)
		event.set_object_sequence_scale(6, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(6, -3510.92, 560.62, 285.51)
		event.set_object_sequence_motion(6, "大爆発", 6)
		progress = 13
		wait.for_frame_count(15)
		event.reset_object_sequence_motion(7)
		event.play_sound_effect(sound_effects, 3)
		event.set_object_sequence_scale(7, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(7, -3204.45, 289.83, 709.72)
		event.set_object_sequence_motion(7, "大爆発", 6)
		progress = 14
		wait.for_frame_count(10)
		event.reset_object_sequence_motion(8)
		event.play_sound_effect(sound_effects, 3)
		event.set_object_sequence_scale(8, 5.0, 5.0, 5.0)
		event.set_object_sequence_position(8, -3068.72, 458.65, 504.04)
		event.set_object_sequence_motion(8, "大爆発", 6)
		progress = 15
		object.wait_until_done(6)
		progress = 16
		wait.for_frame_count(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1759.38, 5.5, 1964.74)
		event.set_camera_sequence_look_at(-1844.27, 25.84, 1966.01)
		event.set_object_handle_visible(28, 0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_visible(7, 0)
		event.set_object_handle_visible(8, 0)
		event.set_object_handle_visible(26, 0)
		event.set_object_handle_visible(27, 1)
		wind_direction_x = vm.f32(-1806.27)
		wind_direction_y = vm.f32(19.47)
		wind_direction_z = vm.f32(1965.44)
		do
			local out1, out2, out3 = event.subtract_vectors(wind_direction_x, wind_direction_y, wind_direction_z, -1845.82, 23.73, 1914.09)
			wind_direction_x = out1 or wind_direction_x
			wind_direction_y = out2 or wind_direction_y
			wind_direction_z = out3 or wind_direction_z
		end
		event.set_wind(10, wind_direction_x, wind_direction_y, wind_direction_z)
		event.set_object_handle_visible(14, 1)
		event.set_object_sequence_position(14, -1878.23, 50.83, 1917.42)
		event.set_object_sequence_rotation(14, 0.0, 1.68, 0.0)
		event.set_object_sequence_position(1, -1821.13, 0.0, 1967.45)
		event.set_object_sequence_rotation(1, 0.0, -2.37, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, -1828.24, 0.0, 1988.57)
		event.set_object_sequence_rotation(0, 0.0, -2.05, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		progress = 17
		wait.for_frame_count(120)
		event.set_character_visible(23, 0, 1, 0.1)
		event.set_wind(-1)
		progress = 18
		wait.for_frame_count(60)
		event.move_camera_sequence_eased(-1956.66, 22.88, 2209.65, -2035.8, 47.24, 2044.77, 120, 2, 0.1)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, -1.21, 0.0, 12)
		event.move_object_sequence(0, -1934.22, 0.0, 2047.37, 60)
		progress = 19
		wait.for_frame_count(5)
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, -1.29, 0.0, 12)
		event.move_object_sequence(1, -1902.38, 0.0, 2048.25, 60)
		progress = 20
		wait.for_frame_count(55)
		event.rotate_object_sequence(0, 0.0, -2.53, 0.0, 50)
		event.move_object_sequence(0, -2063.61, 0.0, 2032.5, 50)
		progress = 21
		wait.for_frame_count(5)
		event.rotate_object_sequence(1, 0.0, -2.61, 0.0, 50)
		event.move_object_sequence(1, -2029.94, 0.0, 2020.81, 50)
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(1, 50)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_out_music(30)
		progress = 22
		object.wait_until_done(0)
		progress = 23
		wait.for_frame_count(30)
		event.play_sound_effect(sound_effects, 4)
		event.set_object_sequence_motion(0, "やった", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		progress = 24
		message.show_voiced(5160020)
		progress = 25
		object.wait_until_done(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		progress = 26
		message.show_voiced(5160030)
		event.play_sound_effect(sound_effects, 5)
		progress = 27
		wait.for_frame_count(90)
		event.stop_music(0)
		progress = 28
		wait.for_frame_count(4)
		event.load_music(32)
		event.play_music(0)
		event.set_object_sequence_motion(0, "右上見る", 6)
		event.queue_object_sequence_next_motion(0, "右上見るL", 4)
		event.set_object_sequence_motion(1, "右上見る", 6)
		event.queue_object_sequence_next_motion(1, "右上見るL", 4)
		event.set_object_sequence_position(17, 3172.3, 1692, -5181.7)
		event.set_object_sequence_rotation(17, 0.0, -1.65, 0.0)
		progress = 29
		object.wait_until_done(0)
		event.move_camera_sequence_eased(-2070.54, 130.56, 2336.88, -2025.9, 157.89, 2103.23, 120, 2, 0.7)
		event.move_object_sequence(17, -1269.1, 1692, -5023.1, 360)
		progress = 30
		camera.wait_until_done()
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
		progress = 31
		wait.for_frame_count(100)
		event.set_object_sequence_color(29, 128, 128, 128, 0, 30)
		progress = 32
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-2086.09, 20.41, 2006.88)
		event.set_camera_sequence_look_at(-2057.35, 23.47, 2014.36)
		event.set_mouth_texture_animations(1, "通常口パク")
		progress = 33
		message.show_voiced(5160040)
		progress = 34
		object.wait_until_done(17)
		event.stop_sound_effect(sound_effects, 5)
		event.play_sound_effect(sound_effects, 6)
		event.play_sound_effect(sound_effects, 7)
		event.set_camera_sequence_position(-2269.17, 1948.94, -4490.73)
		event.set_camera_sequence_look_at(-1666.2, 1723.94, -4850.99)
		event.set_object_handle_visible(2, 1)
		event.move_camera_sequence(-2176.13, 1941.15, -4546.3, -1666.2, 1723.94, -4850.99, 60)
		progress = 35
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1687.33, 1724.29, -4834.16)
		event.set_camera_sequence_look_at(-1674.47, 1722.82, -4853.32)
		event.set_object_sequence_motion(2, "下向き会話", 6)
		event.queue_object_sequence_next_motion(2, "下向き立ち", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "下目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		progress = 36
		message.show_voiced(5160050)
		progress = 37
		object.wait_until_done(2)
		event.set_camera_sequence_position(-1563.71, 1717.81, -4937.18)
		event.set_camera_sequence_look_at(-1618.97, 1724.21, -4901.16)
		event.move_camera_sequence_eased(-1643.48, 1700.93, -4929.83, -1568.23, 1725.22, -4920.42, 170, 0, 0.6)
		event.play_sound_effect(sound_effects, 8)
		event.set_object_sequence_motion(2, "歩き")
		event.rotate_object_sequence(2, 0.0, 2.07, 0.0, 12)
		event.move_object_sequence(2, -1577.9, 1692.06, -4923.4, 180)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		progress = 38
		message.show_voiced_for_stopping(5160060, 120)
		progress = 39
		wait.for_frame_count(45)
		event.stop_sound_effect(sound_effects, 8)
		event.stop_sound_effect(sound_effects, 7)
		event.stop_sound_effect(sound_effects, 6)
		event.play_sound_effect(sound_effects, 12)
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
		event.play_sound_effect(sound_effects, 11)
		event.rotate_object_sequence(19, 0.09, 1.57, -0.09, 60)
		progress = 40
		wait.for_frame_count(30)
		event.rotate_object_sequence(18, 0.09, 1.57, -0.09, 60)
		event.rotate_object_sequence(20, 0.0, 2.26, -0.17, 60)
		event.rotate_object_sequence(21, 0.0, 2.26, -0.17, 60)
		progress = 41
		wait.for_frame_count(90)
		event.play_sound_effect(sound_effects, 13)
		event.set_object_handle_visible(4, 1)
		event.set_object_sequence_rotation(4, -0.09, -0.49, 0.09)
		event.set_object_sequence_position(4, -590.74, 404.66, 956.92)
		event.set_object_sequence_motion(4, "連射", 4)
		event.set_object_handle_visible(5, 1)
		event.set_object_sequence_rotation(5, -0.09, -0.49, 0.09)
		event.set_object_sequence_position(5, -528.29, 404.66, 1025.52)
		event.set_object_sequence_motion(5, "連射", 4)
		progress = 42
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-363.49, 1147.12, 997.14)
		event.set_camera_sequence_look_at(320.6, 1309.16, 876.66)
		event.play_sound_effect(sound_effects, 13)
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
		progress = 43
		wait.for_frame_count(90)
		event.set_object_sequence_position(0, -2118.68, 0.0, 1811.45)
		event.set_object_sequence_rotation(0, 0.0, 1.95, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -2126.8, 0.0, 1772.4)
		event.set_object_sequence_rotation(1, 0.0, 2.19, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_camera_sequence_position(-2091.86, 22.87, 1798.52)
		event.set_camera_sequence_look_at(-2117.77, 22.96, 1810.6)
		event.stop_sound_effect(sound_effects, 12)
		event.play_sound_effect(sound_effects, 15)
		event.play_sound_effect(sound_effects, 14)
		event.set_object_sequence_motion(0, "攻撃してきた！！", 6)
		event.queue_object_sequence_next_motion(0, "攻撃してきた！！L", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "大口パク")
		progress = 44
		message.show_voiced_for_stopping(5160070, 90)
		event.stop_sound_effect(sound_effects, 15)
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
		event.play_sound_effect(sound_effects, 16)
		event.set_object_sequence_position(10, -2222.67, 0.0, 1847.93)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 45
		wait.for_frame_count(3)
		event.set_object_sequence_position(11, -2081.98, 0.0, 1742.24)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		progress = 46
		wait.for_frame_count(3)
		event.set_object_sequence_position(10, -2135.97, 0.0, 1881.42)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 47
		wait.for_frame_count(3)
		event.set_object_sequence_position(11, -2207.11, 0.0, 1907.68)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		progress = 48
		wait.for_frame_count(3)
		event.set_object_sequence_position(10, -2182.0, 0.0, 1801.12)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 49
		wait.for_frame_count(3)
		event.set_object_sequence_position(11, -2124.16, 0.0, 1760.75)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		progress = 50
		wait.for_frame_count(3)
		event.play_sound_effect(sound_effects, 16)
		event.set_object_sequence_position(10, -2179.12, 0.0, 1835.11)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 51
		wait.for_frame_count(3)
		event.set_object_sequence_position(11, -2139.18, 0.0, 1814.26)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		progress = 52
		wait.for_frame_count(3)
		event.set_object_sequence_position(10, -2149.02, 0.0, 1845.22)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 53
		wait.for_frame_count(3)
		event.set_object_sequence_position(11, -2088.02, 0.0, 1809.06)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		progress = 54
		wait.for_frame_count(3)
		event.set_object_sequence_position(10, -2149.69, 0.0, 1874.46)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 55
		wait.for_frame_count(3)
		event.play_sound_effect(sound_effects, 16)
		event.set_object_sequence_position(11, -2094.38, 0.0, 1854.15)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		progress = 56
		wait.for_frame_count(3)
		event.set_object_sequence_position(10, -2105.71, 0.0, 1870.56)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 57
		wait.for_frame_count(3)
		event.set_object_sequence_position(11, -2044.0, 0.0, 1853.9)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		progress = 58
		wait.for_frame_count(3)
		event.set_object_sequence_position(10, -2113.06, 0.0, 1923.45)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 59
		wait.for_frame_count(3)
		event.set_object_sequence_position(11, -1944.54, 19.55, 1825.69)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		progress = 60
		wait.for_frame_count(3)
		event.set_object_sequence_position(10, -2038.0, 0.0, 1928.48)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 61
		wait.for_frame_count(3)
		event.set_object_sequence_position(11, -1937.33, 48.6, 1850.63)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		progress = 62
		wait.for_frame_count(3)
		event.set_object_sequence_position(10, -1926.89, 58.67, 1859.58)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		progress = 63
		wait.for_frame_count(3)
		event.play_sound_effect(sound_effects, 16)
		event.set_object_sequence_position(11, -1883.51, 46.67, 1805.86)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		event.set_object_sequence_position(0, -1995.65, 0.0, 1949.58)
		event.set_object_sequence_rotation(0, 0.0, -1.17, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -2003.28, 0.0, 1930.13)
		event.set_object_sequence_rotation(1, 0.0, -1.29, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.stop_sound_effect(sound_effects, 12)
		event.play_sound_effect(sound_effects, 17)
		event.play_sound_effect(sound_effects, 18)
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_camera_sequence_position(-2055.47, 22.7, 1963.27)
		event.set_camera_sequence_look_at(-1991.1, 19.3, 1932.54)
		event.play_sound_effect(sound_effects, 22)
		event.delay_object_sequence_motion_track(0, 30)
		event.play_sound_effect(sound_effects, 23)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		progress = 64
		message.show_voiced(5160080)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目～おこり目")
		event.set_mouth_texture_animations(1, "通常口パク")
		progress = 65
		message.show_voiced(5160085)
		progress = 66
		object.wait_until_done(17)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_camera_sequence_position(-2446.16, 9.76, 2115.63)
		event.set_camera_sequence_look_at(-2215.58, 87.07, 1943.17)
		event.stop_sound_effect(sound_effects, 17)
		event.stop_sound_effect(sound_effects, 18)
		event.play_sound_effect(sound_effects, 19)
		event.set_object_sequence_position(17, 2996.1, 1784.4, -684.4)
		event.set_object_sequence_rotation(17, 0.0, -2.44, 0.0)
		event.set_object_sequence_rotation(3, -0.09, -0.97, 0.09)
		event.set_object_sequence_position(3, 2525.53, 1980.24, 186.43)
		event.delay_object_sequence_motion_track(3, 90)
		event.set_object_sequence_motion(3, "発射", 4)
		event.delay_object_sequence_sound_track(3, 30)
		event.play_object_sequence_sound(3, sound_effects, 20)
		event.move_object_sequence(17, -393, 1784.4, -2820, 300)
		event.move_object_sequence(3, -846.75, 1980.24, -1950.79, 300)
		progress = 67
		wait.for_frame_count(30)
		event.set_object_handle_visible(3, 1)
		progress = 68
		wait.for_frame_count(30)
		event.set_object_handle_visible(9, 1)
		event.set_object_sequence_position(9, -2118.68, 0.0, 1811.45)
		event.set_object_sequence_motion(9, "砲着弾", 6)
		event.set_object_sequence_scale(9, 2.0, 2.0, 2.0)
		event.play_sound_effect(sound_effects, 21)
		progress = 69
		wait.for_frame_count(10)
		event.set_object_handle_visible(3, 0)
		event.set_wind(10, wind_direction_x, wind_direction_y, wind_direction_z)
		event.shake_camera_sequence_vertically(1.0, 2.0, 0.0, 90)
		progress = 70
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-2055.47, 22.7, 1963.27)
		event.set_camera_sequence_look_at(-1991.1, 19.3, 1932.54)
		event.set_object_handle_visible(14, 1)
		event.set_object_sequence_position(14, -1832.24, 10.3, 1915.21)
		event.set_object_sequence_rotation(14, 0.0, 2.28, 0.0)
		event.stop_sound_effect(sound_effects, 19)
		event.play_sound_effect(sound_effects, 24)
		event.play_sound_effect(sound_effects, 25)
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
		progress = 71
		wait.for_frame_count(120)
		event.set_character_visible(23, 0, 1, 0.1)
		event.set_wind(-1)
		progress = 72
		wait.for_frame_count(30)
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
		progress = 73
		message.show_voiced(5160090)
		event.set_object_sequence_motion(0, "うなづき", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見るL", 4)
		event.play_sound_effect(sound_effects, 26)
		event.set_mouth_texture_animations(0, "通常口パク")
		progress = 74
		message.show_voiced(5160100)
		progress = 75
		object.wait_until_done(0)
		progress = 76
		wait.for_frame_count(20)
		event.set_object_sequence_motion(1, "→左向き立ち", 4)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_object_sequence_motion(0, "→右向き立ち", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		progress = 77
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.play_sound_effect(sound_effects, 26)
		event.set_object_sequence_motion(1, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		progress = 78
		object.wait_until_done(0)
		progress = 79
		wait.for_frame_count(20)
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, -2.49, 0.0, 12)
		event.move_object_sequence(1, -2036.12, 0.0, 1861.33, 60, 1)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, 0.63, 0.0, 12)
		event.move_object_sequence(0, -1971.28, 0.0, 2032.87, 60, 1)
		progress = 80
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		progress = 81
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if progress <= 1 then
			wait.skip_frame_count(4)
		end
		if progress <= 2 then
			wait.skip_frame_count(30)
		end
		if progress <= 3 then
			wait.skip_frame_count(60)
		end
		if progress <= 4 then
			cutscene.skip_command(0)
		end
		if progress <= 5 then
			message.show_voiced_for_stopping_skipping(5160010, 90)
		end
		if progress <= 6 then
			wait.skip_frame_count(90)
		end
		if progress <= 7 then
			wait.skip_frame_count(10)
		end
		if progress <= 8 then
			wait.skip_frame_count(80)
		end
		if progress <= 9 then
			wait.skip_frame_count(20)
		end
		if progress <= 10 then
			wait.skip_frame_count(10)
		end
		if progress <= 11 then
			wait.skip_frame_count(30)
		end
		if progress <= 12 then
			wait.skip_frame_count(15)
		end
		if progress <= 13 then
			wait.skip_frame_count(10)
		end
		if progress <= 14 then
			cutscene.skip_command(6)
		end
		if progress <= 15 then
			wait.skip_frame_count(30)
		end
		if progress <= 16 then
			wind_direction_x = vm.f32(-1806.27)
			wind_direction_y = vm.f32(19.47)
			wind_direction_z = vm.f32(1965.44)
			wait.skip_frame_count(120)
		end
		if progress <= 17 then
			wait.skip_frame_count(60)
		end
		if progress <= 18 then
			wait.skip_frame_count(5)
		end
		if progress <= 19 then
			wait.skip_frame_count(55)
		end
		if progress <= 20 then
			wait.skip_frame_count(5)
		end
		if progress <= 21 then
			cutscene.skip_command(0)
		end
		if progress <= 22 then
			wait.skip_frame_count(30)
		end
		if progress <= 23 then
			message.show_voiced_skipping(5160020)
		end
		if progress <= 24 then
			cutscene.skip_command(0)
		end
		if progress <= 25 then
			message.show_voiced_skipping(5160030)
		end
		if progress <= 26 then
			wait.skip_frame_count(90)
		end
		if progress <= 27 then
			wait.skip_frame_count(4)
		end
		if progress <= 28 then
			cutscene.skip_command(0)
		end
		if progress <= 29 then
			wait.background_load_skipping()
		end
		if progress <= 30 then
			wait.skip_frame_count(100)
		end
		if progress <= 31 then
			wait.skip_frame_count(30)
		end
		if progress <= 32 then
			message.show_voiced_skipping(5160040)
		end
		if progress <= 33 then
			cutscene.skip_command(17)
		end
		if progress <= 34 then
			wait.background_load_skipping()
		end
		if progress <= 35 then
			message.show_voiced_skipping(5160050)
		end
		if progress <= 36 then
			cutscene.skip_command(2)
		end
		if progress <= 37 then
			message.show_voiced_for_stopping_skipping(5160060, 120)
		end
		if progress <= 38 then
			wait.skip_frame_count(45)
		end
		if progress <= 39 then
			wait.skip_frame_count(30)
		end
		if progress <= 40 then
			wait.skip_frame_count(90)
		end
		if progress <= 41 then
			wait.skip_frame_count(30)
		end
		if progress <= 42 then
			wait.skip_frame_count(90)
		end
		if progress <= 43 then
			message.show_voiced_for_stopping_skipping(5160070, 90)
		end
		if progress <= 44 then
			wait.skip_frame_count(3)
		end
		if progress <= 45 then
			wait.skip_frame_count(3)
		end
		if progress <= 46 then
			wait.skip_frame_count(3)
		end
		if progress <= 47 then
			wait.skip_frame_count(3)
		end
		if progress <= 48 then
			wait.skip_frame_count(3)
		end
		if progress <= 49 then
			wait.skip_frame_count(3)
		end
		if progress <= 50 then
			wait.skip_frame_count(3)
		end
		if progress <= 51 then
			wait.skip_frame_count(3)
		end
		if progress <= 52 then
			wait.skip_frame_count(3)
		end
		if progress <= 53 then
			wait.skip_frame_count(3)
		end
		if progress <= 54 then
			wait.skip_frame_count(3)
		end
		if progress <= 55 then
			wait.skip_frame_count(3)
		end
		if progress <= 56 then
			wait.skip_frame_count(3)
		end
		if progress <= 57 then
			wait.skip_frame_count(3)
		end
		if progress <= 58 then
			wait.skip_frame_count(3)
		end
		if progress <= 59 then
			wait.skip_frame_count(3)
		end
		if progress <= 60 then
			wait.skip_frame_count(3)
		end
		if progress <= 61 then
			wait.skip_frame_count(3)
		end
		if progress <= 62 then
			wait.skip_frame_count(3)
		end
		if progress <= 63 then
			message.show_voiced_skipping(5160080)
		end
		if progress <= 64 then
			message.show_voiced_skipping(5160085)
		end
		if progress <= 65 then
			cutscene.skip_command(17)
		end
		if progress <= 66 then
			wait.skip_frame_count(30)
		end
		if progress <= 67 then
			wait.skip_frame_count(30)
		end
		if progress <= 68 then
			wait.skip_frame_count(10)
		end
		if progress <= 69 then
			wait.skip_frame_count(30)
		end
		if progress <= 70 then
			wait.skip_frame_count(120)
		end
		if progress <= 71 then
			wait.skip_frame_count(30)
		end
		if progress <= 72 then
			message.show_voiced_skipping(5160090)
		end
		if progress <= 73 then
			message.show_voiced_skipping(5160100)
		end
		if progress <= 74 then
			cutscene.skip_command(0)
		end
		if progress <= 75 then
			wait.skip_frame_count(20)
		end
		if progress <= 76 then
			wait.skip_frame_count(30)
		end
		if progress <= 77 then
			cutscene.skip_command(0)
		end
		if progress <= 78 then
			wait.skip_frame_count(20)
		end
		if progress <= 79 then
			wait.skip_frame_count(30)
		end
		if progress <= 80 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	progress = 82
	vm.entry(82)
	event.cancel_drama_scene_skip()
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 32 then
		event.stop_music(0)
		progress = 83
		wait.for_frame_count(4)
		event.load_music(32)
		event.play_music(0)
	end
	event.set_wind(-1)
	event.set_object_handle_visible(28, 0)
	event.set_object_handle_visible(26, 0)
	event.set_object_handle_visible(27, 1)
	event.stop_sound_effect(sound_effects, 5)
	event.stop_sound_effect(sound_effects, 15)
	event.stop_sound_effect(sound_effects, 18)
	event.stop_sound_effect(sound_effects, 17)
	event.stop_sound_effect(sound_effects, 19)
	event.stop_sound_effect(sound_effects, 24)
	event.stop_sound_effect(sound_effects, 25)
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

--- Plays the skippable Guiltoni cutscene with Monica's fire magic, wind and gunfire effects, then restores the player character.
local function play_guiltoni_fight_scene()
	local sound_effects: s32 = 0
	local active_character: s32 = 0
	local wind_direction_x: f32 = 0
	local wind_direction_y: f32 = 0
	local wind_direction_z: f32 = 0
	local effect_handle: s32 = 0
	local item_x: f32 = 0
	local item_y: f32 = 0
	local item_z: f32 = 0
	local progress: number = 0
	vm.section(function()
		progress = 1
		vm.entry(1)
		event.set_save_flag(520, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		progress = 2
		wait.for_frame_count(4)
		event.load_music(35)
		event.load_map_sounds(5806)
		sound_effects = event.load_sound_effect_file_2(5806) or sound_effects
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		print("1--------------------------------\n")
		active_character = event.get_playable_character() or active_character
		if active_character == 2 then
			event.switch_dungeon_main_character(0)
			active_character = 0
		end
		if active_character == 3 then
			event.switch_dungeon_main_character(1)
			active_character = 1
		end
		event.change_directory("event/e500/e520/")
		event.load_message_file(0, 5, "e520.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e520_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e520_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_character == 1 then
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
		event.play_sound_effect(sound_effects, 2)
		progress = 3
		wait.for_frame_count(120)
		print("3--------------------------------\n")
		event.set_camera_sequence_position(-1986.48, 333.67, 558.59)
		event.set_camera_sequence_look_at(-1965.0, 337.43, 540.26)
		event.stop_sound_effect(sound_effects, 2)
		event.play_sound_effect(sound_effects, 3)
		print("4--------------------------------\n")
		event.set_object_sequence_position(16, -1947.7, 307.5, 101.3)
		event.set_object_sequence_rotation(16, 0.0, -2.1031218, 0.0)
		event.set_object_sequence_position(3, 1209.2, 1334.3, 0.0)
		event.set_object_sequence_rotation(3, 0.0, -2.1031218, 0.0)
		event.set_object_sequence_position(1, -2813.58, 84.71, 768.64)
		event.set_object_sequence_rotation(1, 0.0, 2.47, 0.0)
		wind_direction_x = vm.f32(-2438.17)
		wind_direction_y = vm.f32(332.67)
		wind_direction_z = 341.25
		do
			local out1, out2, out3 = event.subtract_vectors(wind_direction_x, wind_direction_y, wind_direction_z, -2380.18, 330.38, 324.27)
			wind_direction_x = out1 or wind_direction_x
			wind_direction_y = out2 or wind_direction_y
			wind_direction_z = out3 or wind_direction_z
		end
		event.set_wind(10, wind_direction_x, wind_direction_y, wind_direction_z)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "下目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		progress = 4
		message.show_voiced_for_stopping(5200010, -1)
		event.stop_sound_effect(sound_effects, 3)
		event.play_sound_effect(sound_effects, 4)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		event.set_object_sequence_motion(2, "落ちる", 6)
		event.queue_object_sequence_next_motion(2, "落ちるL", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "下向き～上向き")
		progress = 5
		wait.for_frame_count(10)
		progress = 6
		camera.wait_until_done()
		event.stop_sound_effect(sound_effects, 4)
		event.play_music(0)
		event.set_camera_sequence_position(-2696.98, 45.16, 871.07)
		event.set_camera_sequence_look_at(-2807.7, 201.06, 594.2)
		event.play_sound_effect(sound_effects, 5)
		event.play_sound_effect(sound_effects, 6)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		event.set_object_handle_footstep_sound(1, 6)
		event.move_object_sequence(1, -2763.63, 157.55, 674.32, 60)
		progress = 7
		wait.for_frame_count(60)
		event.stop_sound_effect(sound_effects, 6)
		event.move_object_sequence(1, -2672.25, 236.43, 545.71, 60)
		progress = 8
		wait.for_frame_count(60)
		event.stop_sound_effect(sound_effects, 5)
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
		event.play_sound_effect(sound_effects, 7)
		event.set_object_sequence_motion(1, "飛び", 6)
		event.queue_object_sequence_next_motion(1, "飛びL", 4)
		event.move_object_sequence(1, -2414.26, 303.6, 328.1, 60)
		event.move_camera_sequence(-2415.91, 282.04, 390.68, -2416.07, 304.55, 359.36, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "大口パク")
		progress = 9
		message.show_voiced_for_stopping(5200020, 50)
		progress = 10
		wait.for_frame_count(5)
		event.set_object_sequence_position(1, -2282.71, 308.37, 346.12)
		event.set_camera_sequence_position(-2025.37, 340.27, 478.9)
		event.set_camera_sequence_look_at(-1996.22, 338.59, 478.94)
		event.set_event_projection(524.9)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "下目～おどろき目")
		event.set_mouth_texture_animations(2, "大口パク")
		progress = 11
		message.show_voiced_for_stopping(5200030, -1)
		event.set_camera_sequence_position(-1937.42, 385.84, 606.52)
		event.set_camera_sequence_look_at(-2052.1, 341.76, 476.36)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_footstep_sound(1, 2)
		event.delay_object_sequence_sound_track(1, 30)
		event.play_object_sequence_sound(1, sound_effects, 9)
		event.set_object_sequence_motion(1, "着地2", 4)
		event.set_object_sequence_motion_step(1, 0.25)
		event.queue_object_sequence_next_motion(1, "着地立ち", 6)
		event.set_object_sequence_rotation(1, 0.0, 1.99, 0.0)
		progress = 12
		wait.for_frame_count(30)
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
		progress = 13
		wait.for_frame_count(90)
		event.set_object_sequence_motion(2, "ガード連スタート", 4)
		event.set_object_sequence_motion(1, "魔法構え", 6)
		event.queue_object_sequence_next_motion(1, "魔法構えL", 4)
		event.set_object_sequence_position(2, -2098.82, 307.87, 203.15)
		event.set_object_sequence_rotation(2, 0.0, 1.27, 0.0)
		progress = 14
		object.wait_until_done(1)
		event.play_sound_effect(sound_effects, 10)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(1, "item")
			item_x = out1 or item_x
			item_y = out2 or item_y
			item_z = out3 or item_z
		end
		effect_handle = event.create_effect_3("モニカ魔法－溜め", 9) or effect_handle
		event.set_effect_first_vector(item_x, item_y, item_z)
		event.set_effect_second_vector(128, 64, 64)
		event.set_mouth_texture_animations(1, "通常口パク")
		progress = 15
		message.show_voiced_for_stopping(5200040, -1)
		progress = 16
		wait.for_frame_count(30)
		event.set_object_sequence_motion(1, "魔法撃つ", 4)
		event.stop_sound_effect(sound_effects, 10)
		event.play_sound_effect(sound_effects, 11)
		event.create_effect_2("EVモニカ魔法－火", 9)
		event.set_effect_first_vector(item_x, item_y, item_z)
		event.set_effect_target(-1)
		event.finish_effect(9, effect_handle)
		progress = 17
		wait.for_frame_count(20)
		event.set_object_sequence_motion(1, "魔法撃つ", 4)
		event.play_sound_effect(sound_effects, 11)
		event.create_effect_2("EVモニカ魔法－火", 9)
		event.set_effect_first_vector(item_x, item_y, item_z)
		event.set_effect_target(-1)
		event.finish_effect(9, effect_handle)
		progress = 18
		wait.for_frame_count(10)
		event.set_object_sequence_motion(1, "魔法撃つ", 4)
		event.play_sound_effect(sound_effects, 11)
		event.create_effect_2("EVモニカ魔法－火", 9)
		event.set_effect_first_vector(item_x, item_y, item_z)
		event.set_effect_target(-1)
		event.finish_effect(9, effect_handle)
		progress = 19
		wait.for_frame_count(10)
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
		event.play_sound_effect(sound_effects, 12)
		event.set_scene_character_type(13, 4)
		event.set_object_handle_visible(4, 1)
		event.set_object_sequence_position(4, -2039.14, 327.12, 209.19)
		event.set_object_sequence_motion(4, "魔法ヒット", 6)
		progress = 20
		object.wait_until_done(4)
		progress = 21
		wait.for_frame_count(30)
		event.play_sound_effect(sound_effects, 13)
		event.set_object_sequence_motion(1, "よけ2つ")
		event.wait_object_sequence_motion_end(1)
		event.set_object_sequence_motion(2, "よけ2つ")
		event.wait_object_sequence_motion_end(2)
		progress = 22
		wait.for_frame_count(15)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		progress = 23
		wait.for_frame_count(15)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		progress = 24
		wait.for_frame_count(10)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		progress = 25
		wait.for_frame_count(20)
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
		event.play_sound_effect(sound_effects, 14)
		event.set_object_sequence_motion(1, "ムーンサルト", 6)
		event.wait_object_sequence_motion_end(1)
		event.set_object_sequence_motion(2, "ムーンサルト", 6)
		event.wait_object_sequence_motion_end(2)
		progress = 26
		wait.for_frame_count(10)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		progress = 27
		object.wait_until_done(1)
		event.set_camera_sequence_position(-2082.67, 325.7, 160.89)
		event.set_camera_sequence_look_at(-2021.3, 327.3, 209.89)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(sound_effects, 15)
		event.set_object_sequence_motion(1, "ぐらっ", 6)
		event.set_object_sequence_motion_step(1, 0.7)
		event.queue_object_sequence_next_motion(1, "ぐらっL", 4)
		event.set_object_sequence_motion(2, "ぐらっ", 6)
		event.set_object_sequence_motion_step(1, 0.7)
		event.queue_object_sequence_next_motion(2, "ぐらっL", 4)
		event.play_sound_effect(sound_effects, 16)
		event.delay_camera_sequence_shake_track(15)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		progress = 28
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		progress = 29
		message.show_voiced_for_stopping(5200050, -1)
		event.set_camera_sequence_position(-2043.31, 334.08, 203.6)
		event.set_camera_sequence_look_at(-2013.93, 336.49, 194.04)
		event.delay_object_sequence_sound_track(2, 8)
		event.play_object_sequence_sound(2, sound_effects, 20)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		progress = 30
		message.show_voiced_for_stopping(5200060, -1)
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
		progress = 31
		wait.for_frame_count(10)
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		progress = 32
		message.show_voiced_for_stopping(5200070, -1)
		event.wait_object_sequence_motion_end(2)
		progress = 33
		object.wait_until_done(1)
		event.set_camera_sequence_position(-2025.6, 317.11, 283.22)
		event.set_camera_sequence_look_at(-2022.52, 324.9, 217.92)
		progress = 34
		wait.for_frame_count(20)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "くるし顔")
		event.detach_character_from_frame(14)
		event.set_object_sequence_position(5, -2016.36, 313.05, 230.26)
		event.set_object_sequence_rotation(5, 0.5, 1.67, 0.8)
		event.set_camera_sequence_position(-2038.22, 330.43, 198.53)
		event.set_camera_sequence_look_at(-2027.97, 333.86, 219.66)
		event.set_object_sequence_motion(1, "殴られ顔", 4)
		event.reset_object_sequence_dynamic_animation(1)
		progress = 35
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-2063.52, 323.93, 286.2)
		event.set_camera_sequence_look_at(-2027.6, 321.15, 217.1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "くるし顔")
		event.set_object_sequence_texture_animation(1, 1, "かはっ目～目とじ")
		event.set_object_sequence_texture_animation(1, 1, "口あけ～口とじ")
		event.play_sound_effect(sound_effects, 21)
		event.play_sound_effect(sound_effects, 22)
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
		progress = 36
		wait.for_frame_count(60)
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
		progress = 37
		message.show_voiced_for_stopping(5200080, -1)
		event.delay_camera_sequence_shake_track(30)
		event.shake_camera_sequence(0.0, 0.2, 0.0, -1)
		event.play_sound_effect(sound_effects, 23)
		progress = 38
		wait.for_frame_count(60)
		event.set_object_sequence_motion(2, "上見", 6)
		event.queue_object_sequence_next_motion(2, "上見L", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_mouth_texture_animations(2, "おこり口パク")
		progress = 39
		message.show_voiced_for_stopping(5200090, -1)
		event.stop_sound_effect(sound_effects, 8)
		event.stop_sound_effect(sound_effects, 23)
		event.set_wind(-1)
		event.clear_camera_sequence()
		event.set_object_handle_visible(20, 1)
		event.set_camera_sequence_position(-2307.42, 27.19, 1937.3)
		event.set_camera_sequence_look_at(-2258.86, 36.53, 1808.93)
		progress = 40
		wait.for_frame_count(10)
		event.play_sound_effect(sound_effects, 24)
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
		progress = 41
		wait.for_frame_count(90)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "大口パク")
		progress = 42
		message.show_voiced_for_stopping(5200100, 60)
		event.move_camera_sequence_eased(-2198.1, 30.55, 1580.48, -2105.26, 29.78, 1380.32, 120, 1, 0.5)
		event.move_camera_sequence_eased(-2085.28, 88.8, 1337.19, -1972.16, 302.92, 1093.31, 90, 2, 1.0)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -2112.56, 0.0, 1396.51, 160)
		event.delay_object_sequence_motion_track(0, 160)
		event.set_object_sequence_motion(0, "立ち")
		progress = 43
		wait.for_frame_count(90)
		event.fade_out_music(90)
		event.set_mouth_texture_animations(0, "大口パク")
		progress = 44
		message.show_voiced_for_stopping(5200110, 90)
		event.fade_out_screen(30)
		progress = 45
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if progress <= 1 then
			wait.skip_frame_count(4)
		end
		if progress <= 2 then
			print("1--------------------------------\n")
			local _ = active_character == 2
			active_character = 0
			local _ = active_character == 3
			active_character = 1
			print("2--------------------------------\n")
			wait.skip_frame_count(120)
		end
		if progress <= 3 then
			print("3--------------------------------\n")
			print("4--------------------------------\n")
			wind_direction_x = vm.f32(-2438.17)
			wind_direction_y = vm.f32(332.67)
			wind_direction_z = 341.25
			message.show_voiced_for_stopping_skipping(5200010, -1)
		end
		if progress <= 4 then
			wait.skip_frame_count(10)
		end
		if progress <= 5 then
			wait.background_load_skipping()
		end
		if progress <= 6 then
			wait.skip_frame_count(60)
		end
		if progress <= 7 then
			wait.skip_frame_count(60)
		end
		if progress <= 8 then
			message.show_voiced_for_stopping_skipping(5200020, 50)
		end
		if progress <= 9 then
			wait.skip_frame_count(5)
		end
		if progress <= 10 then
			message.show_voiced_for_stopping_skipping(5200030, -1)
		end
		if progress <= 11 then
			wait.skip_frame_count(30)
		end
		if progress <= 12 then
			wait.skip_frame_count(90)
		end
		if progress <= 13 then
			cutscene.skip_command(1)
		end
		if progress <= 14 then
			message.show_voiced_for_stopping_skipping(5200040, -1)
		end
		if progress <= 15 then
			wait.skip_frame_count(30)
		end
		if progress <= 16 then
			wait.skip_frame_count(20)
		end
		if progress <= 17 then
			wait.skip_frame_count(10)
		end
		if progress <= 18 then
			wait.skip_frame_count(10)
		end
		if progress <= 19 then
			cutscene.skip_command(4)
		end
		if progress <= 20 then
			wait.skip_frame_count(30)
		end
		if progress <= 21 then
			wait.skip_frame_count(15)
		end
		if progress <= 22 then
			wait.skip_frame_count(15)
		end
		if progress <= 23 then
			wait.skip_frame_count(10)
		end
		if progress <= 24 then
			wait.skip_frame_count(20)
		end
		if progress <= 25 then
			wait.skip_frame_count(10)
		end
		if progress <= 26 then
			cutscene.skip_command(1)
		end
		if progress <= 27 then
			wait.skip_frame_count(15)
		end
		if progress <= 28 then
			message.show_voiced_for_stopping_skipping(5200050, -1)
		end
		if progress <= 29 then
			message.show_voiced_for_stopping_skipping(5200060, -1)
		end
		if progress <= 30 then
			wait.skip_frame_count(10)
		end
		if progress <= 31 then
			message.show_voiced_for_stopping_skipping(5200070, -1)
		end
		if progress <= 32 then
			cutscene.skip_command(1)
		end
		if progress <= 33 then
			wait.skip_frame_count(20)
		end
		if progress <= 34 then
			wait.skip_frame_count(30)
		end
		if progress <= 35 then
			wait.skip_frame_count(60)
		end
		if progress <= 36 then
			message.show_voiced_for_stopping_skipping(5200080, -1)
		end
		if progress <= 37 then
			wait.skip_frame_count(60)
		end
		if progress <= 38 then
			message.show_voiced_for_stopping_skipping(5200090, -1)
		end
		if progress <= 39 then
			wait.skip_frame_count(10)
		end
		if progress <= 40 then
			wait.skip_frame_count(90)
		end
		if progress <= 41 then
			message.show_voiced_for_stopping_skipping(5200100, 60)
		end
		if progress <= 42 then
			wait.skip_frame_count(90)
		end
		if progress <= 43 then
			message.show_voiced_for_stopping_skipping(5200110, 90)
		end
		if progress <= 44 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	progress = 46
	vm.entry(46)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 8, 0)
	event.set_scene_status_flags(1, 9, 8, 0)
	event.set_scene_status_flags(1, 11, 8, 0)
	event.set_wind(-1)
	event.set_object_handle_visible(3, 0)
	event.set_object_handle_visible(16, 0)
	event.stop_music(0)
	event.stop_sound_effect(sound_effects, 2)
	event.stop_sound_effect(sound_effects, 3)
	event.stop_sound_effect(sound_effects, 4)
	event.stop_sound_effect(sound_effects, 5)
	event.stop_sound_effect(sound_effects, 6)
	event.stop_sound_effect(sound_effects, 8)
	event.stop_sound_effect(sound_effects, 9)
	event.stop_sound_effect(sound_effects, 10)
	event.stop_sound_effect(sound_effects, 16)
	event.stop_sound_effect(sound_effects, 23)
	event.stop_sound_effect(sound_effects, 24)
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

--- Walks the player to the first exit, asking whether to leave there once the battleship battle is won, and returns 1 when leaving and 0 otherwise.
local function confirm_leave_at_first_exit()
	local active_character: s32 = 0
	local assault_flag: s32 = 0
	local battle_done_flag: s32 = 0
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local i: s32 = 0
	local speaking_character: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				step = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				step = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			step = 3
			wait.for_frame_count(10)
			event.set_character_position(0, -2074.0, -7.0, 3098.8)
			event.set_character_rotation(0, 0.0, 3.05, 0.0)
			event.set_camera_position(-2086.23, 51.55, 3226.23)
			event.set_camera_look_at(-2074.0, 22.99, 3098.82)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		assault_flag = event.get_save_flag(516) or assault_flag
		battle_done_flag = event.get_save_flag(520) or battle_done_flag
		if assault_flag ~= 0 and battle_done_flag == 0 then
			answer = 1
		else
			step = 4
			answer = message.ask_yes_no(2, -1)
		end
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
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
			step = 5
			wait.for_frame_count(40)
			event.fade_out_screen(20)
			step = 6
			wait.for_frame_count(20)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				player_x = out1 or player_x
				player_y = out2 or player_y
				player_z = out3 or player_z
			end
			destination_x = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 40.0) + player_x)
			destination_y = 0.0
			destination_z = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 40.0) + player_z)
			event.move_object_sequence(0, destination_x, destination_y, destination_z, 30, 1)
			event.turn_object_sequence_toward(0, destination_x, destination_y, destination_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					player_x = out1 or player_x
					player_y = out2 or player_y
					player_z = out3 or player_z
				end
				player_y = vm.f32(player_y + 30.0)
				event.set_camera_look_at(player_x, player_y, player_z)
				i = i + 1
				step = 7
				vm.wait(7)
			end
			event.set_object_sequence_motion(0, "立ち")
		end
		if assault_flag ~= 0 and battle_done_flag == 0 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			speaking_character = event.get_playable_character() or speaking_character
			if speaking_character == 0 then
				event.open_message_window_2(0, "「ライドポッド」で応戦だ！")
			else
				event.open_message_window_2(0, "ユリス、「ライドポッド」で応戦よ！")
			end
			step = 8
			message.show_and_wait(0, -1, 5, 256, 208)
		end
		event.set_object_handle_footstep_sound(0, 0)
		event.reset_follow_camera(0)
		event.finish_event()
		return 0
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			if step <= 2 then
				wait.skip_frame_count(10)
			end
			return 0
		end
		if step <= 6 then
			if step == 4 then
				answer = received[1] :: number
			end
			if step <= 4 then
				wait.skip_frame_count(40)
			end
			if step <= 5 then
				wait.skip_frame_count(20)
			end
			return 1
		end
		if step <= 8 then
			if step <= 7 then
				message.show_and_wait_skipping(0, -1, 5, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Walks the player to the second exit, asking whether to leave there once the battleship battle is won, and returns 1 when leaving and 0 otherwise.
local function confirm_leave_at_second_exit()
	local active_character: s32 = 0
	local assault_flag: s32 = 0
	local battle_done_flag: s32 = 0
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local i: s32 = 0
	local firesquall_appeared_flag: s32 = 0
	local speaking_character: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				step = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				step = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			step = 3
			wait.for_frame_count(10)
			event.set_character_position(0, 1459.7, -279.01, 2009.85)
			event.set_character_rotation(0, 0.0, -1.77, 0.0)
			event.set_camera_position(1584.28, -250.6, 2035.61)
			event.set_camera_look_at(1459.7, -249.01, 2009.85)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		assault_flag = event.get_save_flag(516) or assault_flag
		battle_done_flag = event.get_save_flag(520) or battle_done_flag
		if assault_flag == 0 or battle_done_flag == 0 then
			answer = 1
		else
			step = 4
			answer = message.ask_yes_no(1, -1)
		end
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
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
			step = 5
			wait.for_frame_count(40)
			event.fade_out_screen(20)
			step = 6
			wait.for_frame_count(20)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				player_x = out1 or player_x
				player_y = out2 or player_y
				player_z = out3 or player_z
			end
			destination_x = vm.f32(vm.f32(vm.sin(-2.0) * 50.0) + player_x)
			destination_y = 0.0
			destination_z = vm.f32(vm.f32(vm.cos(-2.0) * 50.0) + player_z)
			event.move_object_sequence(0, destination_x, destination_y, destination_z, 30, 1)
			event.turn_object_sequence_toward(0, destination_x, destination_y, destination_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 30)
			event.set_object_sequence_motion(0, "立ち")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					player_x = out1 or player_x
					player_y = out2 or player_y
					player_z = out3 or player_z
				end
				player_y = vm.f32(player_y + 30.0)
				event.set_camera_look_at(player_x, player_y, player_z)
				i = i + 1
				step = 7
				vm.wait(7)
			end
		end
		if assault_flag == 0 or battle_done_flag == 0 then
			firesquall_appeared_flag = event.get_save_flag(508) or firesquall_appeared_flag
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			speaking_character = event.get_playable_character() or speaking_character
			if speaking_character == 0 then
				if assault_flag == 0 then
					if firesquall_appeared_flag == 0 then
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
			elseif assault_flag == 0 then
				if firesquall_appeared_flag == 0 then
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
			step = 8
			message.show_and_wait(0, -1, 5, 256, 208)
		end
		event.set_object_handle_footstep_sound(0, 0)
		event.reset_follow_camera(0)
		event.finish_event()
		return 0
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			if step <= 2 then
				wait.skip_frame_count(10)
			end
			return 0
		end
		if step <= 6 then
			if step == 4 then
				answer = received[1] :: number
			end
			if step <= 4 then
				wait.skip_frame_count(40)
			end
			if step <= 5 then
				wait.skip_frame_count(20)
			end
			return 1
		end
		if step <= 8 then
			if step <= 7 then
				message.show_and_wait_skipping(0, -1, 5, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script loads.
function script.setup() end

script.initialize_peak = initialize_peak
script[99] = script.initialize_peak

--- Starts the peak, playing the Firesquall arrival scene when due.
function script.default_event()
	local firesquall_appeared_flag: s32 = 0
	local arrival_scene_seen_flag: s32 = 0
	initialize_peak()
	firesquall_appeared_flag = event.get_save_flag(508) or firesquall_appeared_flag
	arrival_scene_seen_flag = event.get_save_flag(512) or arrival_scene_seen_flag
	if firesquall_appeared_flag == 1 and arrival_scene_seen_flag == 0 then
		play_firesquall_arrival_scene()
	else
		run_in_from_entrance()
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default.
function script.key_open() end

--- Waits for the confirm button.
function script.wait_for_confirm_button()
	vm.wait(1)
	wait.until_button_pressed(32)
	event.finish_event()
end
script[151] = script.wait_for_confirm_button

--- Lets the player examine the Firesquall and use the item that starts the battleship assault.
function script.examine_firesquall()
	local active_character: s32 = 0
	local trigger_mode: s32 = 0
	local used_item: s32 = 0
	local item_count: s32 = 0
	local confirmed: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.apply_message_window_preset(0, 4)
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				step = 1
				message.show_and_wait(0, 22, 8, 0, 0)
			else
				step = 2
				message.show_and_wait(0, 23, 8, 0, 0)
			end
			event.finish_event()
			return
		end
		trigger_mode = event.get_triggered_event_data_2(6) or trigger_mode
		if trigger_mode == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			item_count = event.get_item_count(372) or item_count
			if item_count <= 0 then
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
			step = 3
			confirmed = message.ask_confirmation(0, -1, 5, 256, 208, confirmed)
			if confirmed == 1 then
				trigger_mode = 2
			end
		end
		if trigger_mode == 2 then
			event.open_use_item_menu(372)
			step = 4
			vm.wait(4)
			used_item = vmhost.used_item() or used_item
			if used_item > 0 then
				if used_item == 372 then
					event.fade_out_screen(15)
					step = 5
					wait.for_frame_count(15)
					event.switch_dungeon_main_character(0)
					step = 6
					play_battleship_assault_scene()
					event.set_save_control_bits(1, 1)
					event.set_function_point_enabled("", "dun_entrance", 0)
					event.set_function_point_enabled("", "entrance", 0)
					event.set_character_change_enabled(3, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_character_change_enabled(1, 0)
					event.set_character_change_unmasked(1, 0)
					event.initialize_event()
					step = 7
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
					step = 8
					character.shake_head()
				end
			end
		end
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				message.show_and_wait_skipping(0, 23, 8, 0, 0)
			end
			return 0
		end
		if step <= 7 then
			if step == 3 then
				confirmed = received[2] :: number
			end
			if step <= 3 then
				local _ = trigger_mode == 1
				trigger_mode = 2
			end
			if step <= 4 then
				wait.skip_frame_count(15)
			end
			if step <= 5 then
				step = 6
				play_battleship_assault_scene()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 1)
					event.set_function_point_enabled("", "dun_entrance", 0)
					event.set_function_point_enabled("", "entrance", 0)
					event.set_character_change_enabled(3, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_character_change_enabled(1, 0)
					event.set_character_change_unmasked(1, 0)
					event.initialize_event()
					step = 7
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
		if step <= 8 then
			return 0
		end
		return nil
	end)
end
script[502] = script.examine_firesquall

--- Resets the party and plays the Guiltoni fight scene.
function script.cutscene_guiltoni_fight()
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		step = 1
		wait.for_frame_count(20)
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
		step = 2
		play_guiltoni_fight_scene()
		event.set_save_control_bits(1, 0)
		event.set_function_point_enabled("", "dun_entrance", 1)
		event.set_function_point_enabled("", "entrance", 1)
		event.finish_event()
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				step = 2
				play_guiltoni_fight_scene()
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
script[503] = script.cutscene_guiltoni_fight

--- Loads the next dungeon after confirming the first exit.
function script.leave_via_first_exit()
	if confirm_leave_at_first_exit() ~= 0 then
		event.load_event_script("d05/d05.stb", 1000)
	end
end
script[550] = script.leave_via_first_exit

--- Advances the floor and loads the next dungeon after confirming the second exit.
function script.leave_via_second_exit()
	local stage_id: s32 = 0
	local current_floor: s32 = 0
	local next_floor: s32 = 0
	if confirm_leave_at_second_exit() ~= 0 then
		stage_id = event.get_dungeon_stage_id() or stage_id
		current_floor = event.get_dungeon_floor() or current_floor
		next_floor = event.get_dungeon_next_floor(current_floor, 0) or next_floor
		event.set_dungeon_floor(next_floor)
		event.set_dungeon_floor_info(stage_id, current_floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
		event.load_event_script("d05/d05.stb", 1000)
	end
end
script[551] = script.leave_via_second_exit

--- Starts the battleship battle with its music and monsters.
function script.start_battleship_battle()
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.stop_music(0)
	wait.for_frame_count(4)
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
script[600] = script.start_battleship_battle

--- Runs the silent defeat sequence when the party is defeated here.
function script.on_defeat()
	dungeon.run_defeat_sequence_silent(0)
end
script[1200] = script.on_defeat

--- Event 15120, which map data, a script or the engine runs by number.
script.play_firesquall_arrival_scene = play_firesquall_arrival_scene
script[15120] = script.play_firesquall_arrival_scene

--- Event 15160, which map data, a script or the engine runs by number.
script.play_battleship_assault_scene = play_battleship_assault_scene
script[15160] = script.play_battleship_assault_scene

--- Event 15200, which map data, a script or the engine runs by number.
script.play_guiltoni_fight_scene = play_guiltoni_fight_scene
script[15200] = script.play_guiltoni_fight_scene

return script
