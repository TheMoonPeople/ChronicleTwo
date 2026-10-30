--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_55215ed6()
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
		wait_frames(4)
		event.load_music(30)
		event.play_music(0)
		event.load_map_sounds(5803)
		var0 = event.load_sound_effect_file_2(5803) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e500/e516/")
		event.load_message_file(0, 5, "e516_1.txt")
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
		block = event.load_event_image_4(5, "e516telop01_1.json", 0) or block
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
		wait_frames(30)
		event.play_sound_effect(var0, 2)
		at = 4
		wait_frames(60)
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
		helper_1584c528(5160010, 90)
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, 0.03, 0.0, 12)
		event.move_object_sequence(1, -3035.41, 56.31, 201.54, 90, 1)
		event.delay_object_sequence_motion_track(1, 90)
		at = 7
		wait_frames(90)
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
		wait_frames(10)
		event.set_object_sequence_motion(0, "爆発", 6)
		event.queue_object_sequence_next_motion(0, "爆発L", 4)
		event.set_object_sequence_motion(1, "爆発", 6)
		event.queue_object_sequence_next_motion(1, "爆発L", 4)
		at = 9
		wait_frames(80)
		event.set_object_handle_visible(6, 1)
		event.set_object_handle_visible(7, 1)
		event.set_object_handle_visible(8, 1)
		event.shake_camera_sequence_vertically(1.0, 1.0, 0.0, -1)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(6, 2.0, 2.0, 2.0)
		event.set_object_sequence_position(6, -2984.05, 97.41, 475.09)
		event.set_object_sequence_motion(6, "大爆発", 6)
		at = 10
		wait_frames(20)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(7, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(7, -3204.45, 289.83, 709.72)
		event.set_object_sequence_motion(7, "大爆発", 6)
		at = 11
		wait_frames(10)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(8, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(8, -3463.32, 912.11, 504.04)
		event.set_object_sequence_motion(8, "大爆発", 6)
		at = 12
		wait_frames(30)
		event.reset_object_sequence_motion(6)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(6, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(6, -3510.92, 560.62, 285.51)
		event.set_object_sequence_motion(6, "大爆発", 6)
		at = 13
		wait_frames(15)
		event.reset_object_sequence_motion(7)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(7, 3.0, 3.0, 3.0)
		event.set_object_sequence_position(7, -3204.45, 289.83, 709.72)
		event.set_object_sequence_motion(7, "大爆発", 6)
		at = 14
		wait_frames(10)
		event.reset_object_sequence_motion(8)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_scale(8, 5.0, 5.0, 5.0)
		event.set_object_sequence_position(8, -3068.72, 458.65, 504.04)
		event.set_object_sequence_motion(8, "大爆発", 6)
		at = 15
		wait_objects(6)
		at = 16
		wait_frames(30)
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
		wait_frames(120)
		event.set_character_visible(23, 0, 1, 0.1)
		event.set_wind(-1)
		at = 18
		wait_frames(60)
		event.move_camera_sequence_eased(-1956.66, 22.88, 2209.65, -2035.8, 47.24, 2044.77, 120, 2, 0.1)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, -1.21, 0.0, 12)
		event.move_object_sequence(0, -1934.22, 0.0, 2047.37, 60)
		at = 19
		wait_frames(5)
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, -1.29, 0.0, 12)
		event.move_object_sequence(1, -1902.38, 0.0, 2048.25, 60)
		at = 20
		wait_frames(55)
		event.rotate_object_sequence(0, 0.0, -2.53, 0.0, 50)
		event.move_object_sequence(0, -2063.61, 0.0, 2032.5, 50)
		at = 21
		wait_frames(5)
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
		wait_frames(30)
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
		wait_frames(90)
		event.stop_music(0)
		at = 28
		wait_frames(4)
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
		wait_frames(100)
		event.set_object_sequence_color(29, 128, 128, 128, 0, 30)
		at = 32
		wait_frames(30)
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
		helper_1584c528(5160060, 120)
		at = 39
		wait_frames(45)
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
		wait_frames(30)
		event.rotate_object_sequence(18, 0.09, 1.57, -0.09, 60)
		event.rotate_object_sequence(20, 0.0, 2.26, -0.17, 60)
		event.rotate_object_sequence(21, 0.0, 2.26, -0.17, 60)
		at = 41
		wait_frames(90)
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
		wait_frames(30)
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
		wait_frames(90)
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
		helper_1584c528(5160070, 90)
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
		wait_frames(3)
		event.set_object_sequence_position(11, -2081.98, 0.0, 1742.24)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 46
		wait_frames(3)
		event.set_object_sequence_position(10, -2135.97, 0.0, 1881.42)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 47
		wait_frames(3)
		event.set_object_sequence_position(11, -2207.11, 0.0, 1907.68)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 48
		wait_frames(3)
		event.set_object_sequence_position(10, -2182.0, 0.0, 1801.12)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 49
		wait_frames(3)
		event.set_object_sequence_position(11, -2124.16, 0.0, 1760.75)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 50
		wait_frames(3)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_position(10, -2179.12, 0.0, 1835.11)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 51
		wait_frames(3)
		event.set_object_sequence_position(11, -2139.18, 0.0, 1814.26)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 52
		wait_frames(3)
		event.set_object_sequence_position(10, -2149.02, 0.0, 1845.22)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 53
		wait_frames(3)
		event.set_object_sequence_position(11, -2088.02, 0.0, 1809.06)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 54
		wait_frames(3)
		event.set_object_sequence_position(10, -2149.69, 0.0, 1874.46)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 55
		wait_frames(3)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_position(11, -2094.38, 0.0, 1854.15)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 56
		wait_frames(3)
		event.set_object_sequence_position(10, -2105.71, 0.0, 1870.56)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 57
		wait_frames(3)
		event.set_object_sequence_position(11, -2044.0, 0.0, 1853.9)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 58
		wait_frames(3)
		event.set_object_sequence_position(10, -2113.06, 0.0, 1923.45)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 59
		wait_frames(3)
		event.set_object_sequence_position(11, -1944.54, 19.55, 1825.69)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 60
		wait_frames(3)
		event.set_object_sequence_position(10, -2038.0, 0.0, 1928.48)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 61
		wait_frames(3)
		event.set_object_sequence_position(11, -1937.33, 48.6, 1850.63)
		event.set_object_sequence_motion(11, "機銃着弾", 4)
		at = 62
		wait_frames(3)
		event.set_object_sequence_position(10, -1926.89, 58.67, 1859.58)
		event.set_object_sequence_motion(10, "機銃着弾", 4)
		at = 63
		wait_frames(3)
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
		wait_frames(30)
		event.set_object_handle_visible(3, 1)
		at = 68
		wait_frames(30)
		event.set_object_handle_visible(9, 1)
		event.set_object_sequence_position(9, -2118.68, 0.0, 1811.45)
		event.set_object_sequence_motion(9, "砲着弾", 6)
		event.set_object_sequence_scale(9, 2.0, 2.0, 2.0)
		event.play_sound_effect(var0, 21)
		at = 69
		wait_frames(10)
		event.set_object_handle_visible(3, 0)
		event.set_wind(10, x, y, z)
		event.shake_camera_sequence_vertically(1.0, 2.0, 0.0, 90)
		at = 70
		wait_frames(30)
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
		wait_frames(120)
		event.set_character_visible(23, 0, 1, 0.1)
		event.set_wind(-1)
		at = 72
		wait_frames(30)
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
		wait_frames(20)
		event.set_object_sequence_motion(1, "→左向き立ち", 4)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_object_sequence_motion(0, "→右向き立ち", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		at = 77
		wait_frames(30)
		event.set_object_sequence_motion(0, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.play_sound_effect(var0, 26)
		event.set_object_sequence_motion(1, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		at = 78
		wait_objects(0)
		at = 79
		wait_frames(20)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, 0.63, 0.0, 15)
		event.move_object_sequence(0, -1971.28, 0.0, 2032.87, 90, 1)
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(1, 0.0, -2.49, 0.0, 15)
		event.move_object_sequence(1, -2036.12, 0.0, 1861.33, 75, 1)
		at = 80
		wait_frames(45)
		event.fade_out_screen(30)
		at = 81
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(4)
		end
		if at <= 2 then
			wait_frames_skipping(30)
		end
		if at <= 3 then
			wait_frames_skipping(60)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_52aadc70(5160010, 90)
		end
		if at <= 6 then
			wait_frames_skipping(90)
		end
		if at <= 7 then
			wait_frames_skipping(10)
		end
		if at <= 8 then
			wait_frames_skipping(80)
		end
		if at <= 9 then
			wait_frames_skipping(20)
		end
		if at <= 10 then
			wait_frames_skipping(10)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		if at <= 12 then
			wait_frames_skipping(15)
		end
		if at <= 13 then
			wait_frames_skipping(10)
		end
		if at <= 14 then
			helper_238b5abc(6)
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			x = vm.f32(-1806.27)
			y = vm.f32(19.47)
			z = vm.f32(1965.44)
			wait_frames_skipping(120)
		end
		if at <= 17 then
			wait_frames_skipping(60)
		end
		if at <= 18 then
			wait_frames_skipping(5)
		end
		if at <= 19 then
			wait_frames_skipping(55)
		end
		if at <= 20 then
			wait_frames_skipping(5)
		end
		if at <= 21 then
			helper_238b5abc(0)
		end
		if at <= 22 then
			wait_frames_skipping(30)
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
			wait_frames_skipping(90)
		end
		if at <= 27 then
			wait_frames_skipping(4)
		end
		if at <= 28 then
			helper_238b5abc(0)
		end
		if at <= 29 then
			helper_344d6cd8()
		end
		if at <= 30 then
			wait_frames_skipping(100)
		end
		if at <= 31 then
			wait_frames_skipping(30)
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
			helper_52aadc70(5160060, 120)
		end
		if at <= 38 then
			wait_frames_skipping(45)
		end
		if at <= 39 then
			wait_frames_skipping(30)
		end
		if at <= 40 then
			wait_frames_skipping(90)
		end
		if at <= 41 then
			wait_frames_skipping(30)
		end
		if at <= 42 then
			wait_frames_skipping(90)
		end
		if at <= 43 then
			helper_52aadc70(5160070, 90)
		end
		if at <= 44 then
			wait_frames_skipping(3)
		end
		if at <= 45 then
			wait_frames_skipping(3)
		end
		if at <= 46 then
			wait_frames_skipping(3)
		end
		if at <= 47 then
			wait_frames_skipping(3)
		end
		if at <= 48 then
			wait_frames_skipping(3)
		end
		if at <= 49 then
			wait_frames_skipping(3)
		end
		if at <= 50 then
			wait_frames_skipping(3)
		end
		if at <= 51 then
			wait_frames_skipping(3)
		end
		if at <= 52 then
			wait_frames_skipping(3)
		end
		if at <= 53 then
			wait_frames_skipping(3)
		end
		if at <= 54 then
			wait_frames_skipping(3)
		end
		if at <= 55 then
			wait_frames_skipping(3)
		end
		if at <= 56 then
			wait_frames_skipping(3)
		end
		if at <= 57 then
			wait_frames_skipping(3)
		end
		if at <= 58 then
			wait_frames_skipping(3)
		end
		if at <= 59 then
			wait_frames_skipping(3)
		end
		if at <= 60 then
			wait_frames_skipping(3)
		end
		if at <= 61 then
			wait_frames_skipping(3)
		end
		if at <= 62 then
			wait_frames_skipping(3)
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
			wait_frames_skipping(30)
		end
		if at <= 67 then
			wait_frames_skipping(30)
		end
		if at <= 68 then
			wait_frames_skipping(10)
		end
		if at <= 69 then
			wait_frames_skipping(30)
		end
		if at <= 70 then
			wait_frames_skipping(120)
		end
		if at <= 71 then
			wait_frames_skipping(30)
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
			wait_frames_skipping(20)
		end
		if at <= 76 then
			wait_frames_skipping(30)
		end
		if at <= 77 then
			helper_238b5abc(0)
		end
		if at <= 78 then
			wait_frames_skipping(20)
		end
		if at <= 79 then
			wait_frames_skipping(45)
		end
		if at <= 80 then
			wait_frames_skipping(30)
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
		wait_frames(4)
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

return helper_55215ed6
