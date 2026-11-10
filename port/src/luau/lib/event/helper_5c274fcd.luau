--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local set_window_mode = require("@lib/event/set_window_mode")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_5c274fcd()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local at: number = 0
	do
		local ret = vm.section(function()
			event.set_save_flag(111, 1)
			event.initialize_event()
			event.show_dungeon_status_bar(0, 0.033333335)
			active_chr_no = event.get_playable_character() or active_chr_no
			if active_chr_no == 2 then
				var1 = event.get_player_move_type() or var1
				if var1 == 1 then
					event.set_character_motion(0, "立ち-足")
				end
				if var1 == 2 then
					event.set_character_motion(0, "立ち-キャタピラ")
				end
			else
				event.set_character_motion(0, "バトル立ち")
			end
			var2 = event.is_trial_version() or var2
			if var2 == 1 then
				event.fade_out_music(30)
			end
			event.fade_out_screen(30)
			at = 1
			wait_frames(30)
			if active_chr_no == 2 then
				event.switch_dungeon_main_character(0)
				event.set_playable_character(0)
			end
			event.change_directory("event/e100/e111/")
			event.start_background_file_loads_9(
				"e111_mints.gltf",
				"e111_Halloween.gltf",
				"e111_polcurse.gltf",
				"e111_pierrot.gltf",
				"e111baku.gltf",
				"e111pikipiki.gltf",
				"e111_hahen01.gltf",
				"e111_hahen02.gltf",
				"e111_1.txt"
			)
			event.stop_port_sound_effects(7)
			event.set_dungeon_pause_flags(17, 1)
			var4 = event.is_trial_version() or var4
			if var4 == 1 then
				event.assign_memory_stack(5)
				event.clear_memory_stack(5)
				event.set_character_active(0, 0)
				at = 2
				helper_479dc9e9()
				event.load_character(5, "e111_Halloween.gltf", "info", 9)
				event.set_character_active(9)
				event.attach_object_handle_to_character(1, 9)
				event.clear_object_sequence(1)
				event.set_object_sequence_object(1, 1)
				event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
				event.set_object_sequence_rotation(1, 0.0, 1.8, 0.0)
				event.set_object_sequence_motion(1, "立ち", 4)
				event.load_character(5, "e111pikipiki.gltf", "info", 13)
				event.set_character_active(0, 13)
				event.set_character_position(13, 0.0, 0.0, 0.0)
				event.set_character_rotation(13, 0.0, 1.8, 0.0)
				event.load_character(5, "e111baku.gltf", "info", 14)
				event.set_character_active(0, 14)
				event.set_character_position(14, 0.0, 0.0, 0.0)
				event.set_character_rotation(14, 0.0, 1.8, 0.0)
				event.set_character_motion(14, "爆発", 5)
				event.set_current_directory("")
				var3 = event.load_sound_effect_file_2(1831) or var3
				event.set_object_sequence_motion(1, "倒れ", 6)
				event.wait_object_sequence_motion_end(1)
				event.clear_camera_sequence()
				event.set_camera_sequence_position(229.93, 23.29, -84.91)
				event.set_camera_sequence_look_at(-23.55, 60.99, 1.2)
				event.mark_camera_sequence_fade_track()
				event.fade_in_camera_sequence(30)
				at = 3
				wait_camera()
				at = 4
				wait_frames(12)
				event.play_sound_effect(var3, 18)
				at = 5
				wait_objects(1)
				event.set_character_active(13)
				event.play_object_sequence_sound(1, var3, 31)
				event.delay_object_sequence_sound_track(1, 20)
				event.play_object_sequence_sound(1, var3, 32)
				event.delay_object_sequence_sound_track(1, 8)
				event.play_object_sequence_sound(1, var3, 31)
				at = 6
				wait_frames(30)
				event.set_character_active(14)
				event.set_character_motion(14, "爆発", 6)
				at = 7
				wait_frames(10)
				event.play_sound_effect(var3, 33)
				at = 8
				wait_frames(45)
				event.fade_out_music(90)
				event.fade_out_screen(30)
				at = 9
				wait_frames(30)
				at = 10
				wait_frames(60)
				event.stop_sound_effect(var3, 31)
				event.stop_sound_effect(var3, 32)
				event.stop_sound_effect(var3, 33)
				event.set_character_active(0)
				event.set_scene_exit_flag(1)
				return table.pack()
			end
			event.stop_music(0)
			set_window_mode(0, 7)
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			at = 11
			helper_479dc9e9()
			event.load_message_file(0, 5, "e111_1.txt")
			event.load_character_motion_pack(5, "e111_mints.gltf", "info", 0)
			event.set_character_position(0, 202.87, 0.0, -74.61)
			event.set_character_rotation(0, 0.0, -1.2, 0.0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.set_object_handle_footstep_sound(0, 2)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 202.87, 0.0, -74.61)
			event.set_object_sequence_rotation(0, 0.0, -1.2, 0.0)
			event.set_object_sequence_motion(0, "旧・立ち", 4, -1, 1)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目パチ")
			event.load_character(5, "e111_Halloween.gltf", "info", 9)
			event.set_character_active(9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(1, 0.0, 1.8, 0.0)
			event.set_object_sequence_motion(1, "立ち", 4)
			event.load_character(5, "e111_polcurse.gltf", "info", 10)
			event.set_character_active(10)
			event.attach_object_handle_to_character(2, 10)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_object_sequence_position(2, 0.0, 170.0, 0.0)
			event.set_object_sequence_rotation(2, 0.0, 1.8, 0.0)
			event.set_object_sequence_motion(2, "浮遊２", 4)
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "目・こまり")
			event.set_object_sequence_texture_animation(2, 1, "口・こまり")
			event.load_character(5, "e111_pierrot.gltf", "info", 11)
			event.set_character_active(0, 11)
			event.attach_object_handle_to_character(3, 11)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(3, "立ち", 4)
			event.copy_character(5, 11, 12)
			event.set_character_active(0, 12)
			event.attach_object_handle_to_character(4, 12)
			event.clear_object_sequence(4)
			event.set_object_sequence_object(4, 4)
			event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(4, "立ち", 4)
			event.load_character(5, "e111pikipiki.gltf", "info", 13)
			event.set_character_active(0, 13)
			event.set_character_position(13, 0.0, 0.0, 0.0)
			event.set_character_rotation(13, 0.0, 1.8, 0.0)
			event.load_character(5, "e111baku.gltf", "info", 14)
			event.set_character_active(0, 14)
			event.set_character_position(14, 0.0, 0.0, 0.0)
			event.set_character_rotation(14, 0.0, 1.8, 0.0)
			event.set_character_motion(14, "爆発", 5)
			event.load_character(5, "e111_hahen01.gltf", "info", 15)
			event.set_character_active(0, 15)
			event.set_character_position(15, 0.0, 0.0, 0.0)
			event.set_character_rotation(15, 0.0, 1.0, 0.0)
			event.attach_object_handle_to_character(7, 15)
			event.clear_object_sequence(7)
			event.set_object_sequence_object(7, 7)
			event.copy_character(5, 15, 16)
			event.set_character_active(0, 16)
			event.set_character_position(16, 0.0, 0.0, 0.0)
			event.set_character_rotation(16, 0.0, 3.0, 0.0)
			event.attach_object_handle_to_character(8, 16)
			event.clear_object_sequence(8)
			event.set_object_sequence_object(8, 8)
			event.load_character(5, "e111_hahen02.gltf", "info", 17)
			event.set_character_active(0, 17)
			event.set_character_position(17, 0.0, 0.0, 0.0)
			event.set_character_rotation(17, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_character(9, 17)
			event.clear_object_sequence(9)
			event.set_object_sequence_object(9, 9)
			event.set_current_directory("")
			var3 = event.load_sound_effect_file_2(1831) or var3
			event.set_object_handle_sound_bank(2, var3)
			event.set_object_handle_sound_bank(3, var3)
			event.set_object_handle_sound_bank(4, var3)
			event.set_object_handle_sound_bank(7, -1)
			event.set_object_handle_sound_bank(8, -1)
			event.set_object_handle_sound_bank(9, -1)
			event.attach_object_handle_to_character(5, 1)
			event.set_object_handle_visible(5, 0)
			event.attach_object_handle_to_character(6, 2)
			event.set_object_handle_visible(6, 0)
			event.set_object_sequence_motion(1, "倒れ", 6)
			event.wait_object_sequence_motion_end(1)
			event.enable_drama_skip()
			event.clear_camera_sequence()
			event.set_camera_sequence_position(315.53, 60.49, -68.59)
			event.set_camera_sequence_look_at(-19.71, 69.17, 0.25)
			event.mark_camera_sequence_fade_track()
			event.fade_in_camera_sequence(30)
			at = 12
			wait_camera()
			at = 13
			wait_frames(12)
			event.play_sound_effect(var3, 18)
			at = 14
			wait_objects(1)
			event.set_character_active(13)
			event.play_object_sequence_sound(1, var3, 31)
			event.delay_object_sequence_sound_track(1, 20)
			event.play_object_sequence_sound(1, var3, 32)
			event.delay_object_sequence_sound_track(1, 8)
			event.play_object_sequence_sound(1, var3, 31)
			at = 15
			wait_frames(30)
			event.set_camera_sequence_position(44.03, 197.99, -10.5)
			event.set_camera_sequence_look_at(0.02, 199.41, -0.53)
			event.set_object_sequence_motion(2, "両手広げる", 6)
			event.queue_object_sequence_next_motion(2, "両手広げるL", 4)
			event.set_object_handle_texture_animation(2, 0, "口・こまり")
			event.set_mouth_texture_animations(2, "口パク２", "口・こまり")
			at = 16
			helper_4116e6bb(1110010)
			event.reset_mouth_texture_animations()
			at = 17
			wait_objects(2)
			event.set_camera_sequence_position(238.32, 116.37, -106.27)
			event.set_camera_sequence_look_at(-6.37, 50.07, -17.02)
			event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(2, 0.0, 1.8, 0.0)
			event.set_object_sequence_motion(2, "抱き着き", 6)
			event.queue_object_sequence_next_motion(2, "抱き着きL", 4)
			event.set_object_handle_texture_animation(2, 0, "口・こまり")
			event.set_mouth_texture_animations(2, "口パク２", "口・こまり")
			at = 18
			helper_4116e6bb(1110020)
			event.reset_mouth_texture_animations()
			at = 19
			wait_objects(2)
			event.set_camera_sequence_position(230.72, 15.98, -98.52)
			event.set_camera_sequence_look_at(28.12, 61.49, 12.32)
			event.set_character_active(0)
			event.set_character_active(14)
			event.set_character_motion(14, "爆発", 6)
			at = 20
			wait_frames(4)
			event.play_sound_effect(var3, 33)
			var5 = 0
			at = 21
			wait_frames(16 - var5)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・フクザツ")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			event.set_object_sequence_motion(0, "爆発", 6)
			event.queue_object_sequence_next_motion(0, "爆発L", 4)
			at = 22
			wait_frames(60)
			event.set_camera_sequence_position(224.0, 20.06, -43.69)
			event.set_camera_sequence_look_at(253.55, 21.35, -49.32)
			event.set_object_sequence_position(0, 250.0, 0.0, -50.0)
			event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
			event.reset_object_sequence_motion(0)
			event.set_object_sequence_motion(0, "爆発L", 4, -1.0, 1)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_character_active(0, 9)
			event.set_character_active(0, 10)
			event.set_character_active(0, 13)
			event.set_character_active(0, 14)
			event.set_character_active(1, 15)
			event.set_character_active(1, 16)
			event.set_character_active(1, 17)
			at = 23
			wait_frames(40)
			event.reset_object_sequence_motion(7)
			event.set_object_sequence_motion(7, "破片", 6)
			at = 24
			wait_frames(5)
			event.reset_object_sequence_motion(8)
			event.set_object_sequence_motion(8, "破片", 6)
			event.reset_object_sequence_motion(9)
			event.set_object_sequence_motion(9, "破片", 6)
			at = 25
			wait_frames(15)
			event.set_camera_sequence_position(47.2, 92.89, -142.19)
			event.set_camera_sequence_look_at(85.43, 16.34, 45.38)
			event.set_object_sequence_position(7, -22.38, 0.0, -1.68)
			event.set_object_sequence_position(8, -5.05, 0.0, -21.05)
			event.set_object_sequence_position(9, -0.08, 0.0, -45.14)
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "目・閉じ")
			event.set_object_sequence_texture_animation(2, 1, "口・こまり")
			event.set_character_active(10)
			event.set_character_visible(10, 1)
			event.set_object_sequence_rotation(2, 0.0, -2.08, 0.0)
			event.move_object_sequence_eased(2, 84.29, 0.0, 53.13, 40, 2, 0.2)
			event.set_object_sequence_motion(2, "倒れる", 6)
			event.queue_object_sequence_next_motion(2, "倒れるL", 4)
			event.move_object_sequence(7, 221.23, 0.0, 41.5, 80)
			at = 26
			wait_frames(5)
			event.move_object_sequence(8, 31.26, 0.0, 224.79, 68)
			event.move_object_sequence(9, 85.17, 0.0, 135.16, 60)
			at = 27
			wait_frames(2)
			event.play_sound_effect(var3, 37)
			at = 28
			wait_objects(2)
			at = 29
			wait_frames(30)
			event.set_camera_sequence_position(198.72, 10.01, -8.33)
			event.set_camera_sequence_look_at(245.11, 19.47, -50.58)
			event.set_object_sequence_motion(0, "ポルカスに近づく")
			event.set_object_sequence_motion_blend_step(0, 0.04)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・真剣")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			at = 30
			wait_frames(20)
			event.move_object_sequence_eased(0, 218.58, 0.0, -35.53, 40, 1, 0.4)
			at = 31
			wait_frames(47)
			event.set_camera_sequence_position(109.18, 34.69, -86.0)
			event.set_camera_sequence_look_at(83.61, 7.22, 47.83)
			event.set_object_sequence_position(0, 71.02, 0.0, -22.65)
			event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
			event.move_object_sequence(0, 77.52, 0.0, 8.58, 50)
			event.reset_object_sequence_motion(0)
			event.set_object_sequence_motion(0, "ポルカスに近づく", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "振り向く", 6)
			event.queue_object_sequence_next_motion(0, "振り向くL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.delay_object_sequence_texture_animation_track(0, 30)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・振り向き")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			at = 32
			wait_frames(40)
			at = 33
			helper_4116e6bb(1110030)
			event.set_object_handle_texture_animation(0, 0, "口・フクザツ")
			event.set_mouth_texture_animations(0, "通常口パク", "口・フクザツ")
			at = 34
			helper_4116e6bb(1110040)
			event.reset_mouth_texture_animations()
			event.set_camera_sequence_position(204.37, 31.72, 9.99)
			event.set_camera_sequence_look_at(264.2, 27.01, -5.8)
			event.set_character_active(11)
			event.set_character_active(12)
			event.set_object_sequence_position(3, 375.73, 0.0, -22.37)
			event.set_object_sequence_rotation(3, 0.0, -1.32, 0.0)
			event.move_object_sequence(3, 224.72, 0.0, 9.78, 30)
			event.set_object_sequence_motion(3, "走り", 4)
			event.set_object_sequence_position(4, 436.56, 0.0, -64.46)
			event.set_object_sequence_rotation(4, 0.0, -1.32, 0.0)
			event.move_object_sequence(4, 268.47, 0.0, -20.1, 30)
			event.set_object_sequence_motion(4, "走り", 4)
			event.set_object_sequence_motion_time(4, 5.7)
			at = 35
			wait_objects(3)
			event.set_camera_sequence_position(80.24, 21.69, -11.79)
			event.set_camera_sequence_look_at(80.02, 22.6, 6.87)
			event.set_object_handle_texture_animation(0, 0, "口・フクザツ")
			event.set_mouth_texture_animations(0, "通常口パク", "口・フクザツ")
			at = 36
			helper_1584c528(1110050, -1)
			event.reset_mouth_texture_animations()
			event.set_camera_sequence_position(169.2, 49.46, -43.53)
			event.set_camera_sequence_look_at(78.35, 3.24, 42.02)
			event.set_object_sequence_motion(0, "こける", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "こけるL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・ビックリ")
			event.set_object_sequence_texture_animation(0, 1, "口・ビックリ")
			event.set_object_sequence_position(3, 139.55, 0.0, -50.54)
			event.set_object_sequence_rotation(3, 0.0, -0.24, 0.0)
			event.move_object_sequence(3, 112.86, 0.0, 70.42, 30)
			event.delay_object_sequence_rotation_track(3, 20)
			event.rotate_object_sequence(3, 0.0, -2.16, 0.0, 10)
			event.delay_object_sequence_motion_track(3, 30)
			event.set_object_sequence_motion(3, "立ち")
			event.set_object_sequence_position(4, 41.41, 0.0, -20.18)
			event.set_object_sequence_rotation(4, 0.0, 0.24, 0.0)
			event.move_object_sequence(4, 68.8, 0.0, 44.59, 30)
			event.delay_object_sequence_rotation_track(4, 20)
			event.rotate_object_sequence(4, 0.0, 1.08, 0.0, 10)
			event.delay_object_sequence_motion_track(4, 30)
			event.set_object_sequence_motion(4, "立ち")
			at = 37
			wait_objects(3)
			at = 38
			wait_objects(4)
			at = 39
			wait_frames(2)
			event.set_object_sequence_motion(2, "持ち上げ", 6)
			event.set_object_sequence_motion(3, "頭持ち上げ", 6)
			event.set_object_sequence_motion(4, "足持ち上げ", 6)
			at = 40
			wait_frames(78)
			event.set_object_sequence_motion(0, "見送る", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "見送るL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目パチ")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			event.set_object_sequence_motion(2, "運ばれる")
			event.set_object_sequence_motion(3, "頭持ち歩きL")
			event.set_object_sequence_motion(4, "足持ち歩き")
			event.move_object_sequence_eased(2, 140.22, 0.0, -53.49, 60, 1, 0.1)
			event.move_object_sequence_eased(3, 174.0, 0.0, -35.88, 60, 1, 0.1)
			event.move_object_sequence_eased(4, 128.99, 0.0, -59.89, 60, 1, 0.1)
			at = 41
			helper_1584c528(1110060, 60)
			at = 42
			wait_objects(2)
			event.set_camera_sequence_position(12.04, 19.34, -2.84)
			event.set_camera_sequence_look_at(163.83, 7.62, -48.59)
			event.set_object_sequence_position(0, 71.02, 0.0, -22.65)
			event.set_object_sequence_rotation(0, 0.0, -1.08, 0.0)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_position(2, 233.65, 0.0, -50.46)
			event.set_object_sequence_rotation(2, 0.0, -2.92, 0.0)
			event.set_object_sequence_position(3, 241.55, 0.0, -12.36)
			event.set_object_sequence_rotation(3, 0.0, -3.0, 0.0)
			event.set_object_sequence_position(4, 230.89, 0.0, -63.54)
			event.set_object_sequence_rotation(4, 0.0, 0.24, 0.0)
			event.move_object_sequence(2, 671.22, 0.0, -131.94, 160)
			event.move_object_sequence(3, 678.84, 0.0, -94.13, 160)
			event.move_object_sequence(4, 668.34, 0.0, -144.99, 160)
			at = 43
			helper_1584c528(1110060, 60)
			event.set_object_handle_texture_animation(0, 0, "口・フクザツ")
			event.set_mouth_texture_animations(0, "通常口パク", "口・フクザツ")
			at = 44
			helper_1584c528(1110080, 90)
			event.reset_mouth_texture_animations()
			at = 45
			wait_objects(2)
			event.set_character_active(0, 10)
			event.set_character_active(0, 11)
			event.set_character_active(0, 12)
			event.set_camera_sequence_position(115.02, 23.5, 34.8)
			event.set_camera_sequence_look_at(83.65, 15.41, -18.49)
			event.set_object_sequence_position(0, 83.74, 0.0, -19.9)
			event.set_object_sequence_rotation(0, 0.0, 0.84, 0.0)
			event.set_object_sequence_motion(0, "立ちあがる", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "ため息", 6)
			event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.delay_object_sequence_texture_animation_track(0, 34)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目パチ")
			event.set_object_sequence_texture_animation(0, 1, "口・ため息")
			at = 46
			wait_frames(34)
			at = 47
			helper_4116e6bb(1110090)
			at = 48
			wait_objects(0)
			event.set_camera_sequence_position(157.76, 23.5, -3.06)
			event.set_camera_sequence_look_at(61.27, 16.36, -2.61)
			event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
			event.set_object_sequence_motion(0, "振り返る", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・真剣")
			event.set_object_sequence_texture_animation(0, 1, "口・真剣")
			at = 49
			wait_objects(0)
			at = 50
			wait_frames(30)
			event.set_camera_sequence_position(-430.32, 64.84, 57.91)
			event.set_camera_sequence_look_at(-921.56, 67.83, 181.76)
			event.move_camera_sequence(-526.57, 64.84, 82.17, -921.56, 67.83, 181.76, 120)
			at = 51
			wait_camera()
			event.set_camera_sequence_position(58.55, 16.4, 0.48)
			event.set_camera_sequence_look_at(82.64, 21.24, -20.55)
			event.set_object_handle_texture_animation(0, 0, "口・真剣")
			event.set_mouth_texture_animations(0, "通常口パク", "口・真剣")
			at = 52
			helper_4116e6bb(1110100)
			event.reset_mouth_texture_animations()
			event.start_crossfade(60)
			event.set_camera_sequence_position(69.71, 21.68, -9.26)
			event.set_camera_sequence_look_at(82.64, 24.57, -20.55)
			at = 53
			wait_frames(120)
			event.mark_camera_sequence_fade_track()
			event.fade_out_camera_sequence(30)
			at = 54
			wait_camera()
			return nil
		end, function(received: { any }): boolean
			if at <= 10 then
				return false
			end
			if at <= 11 then
				helper_344d6cd8()
			end
			if at <= 12 then
				wait_frames_skipping(12)
			end
			if at <= 13 then
				helper_238b5abc(1)
			end
			if at <= 14 then
				wait_frames_skipping(30)
			end
			if at <= 15 then
				helper_8cd371d7(1110010)
			end
			if at <= 16 then
				helper_238b5abc(2)
			end
			if at <= 17 then
				helper_8cd371d7(1110020)
			end
			if at <= 18 then
				helper_238b5abc(2)
			end
			if at <= 19 then
				wait_frames_skipping(4)
			end
			if at <= 20 then
				var5 = 0
				wait_frames_skipping(16 - var5)
			end
			if at <= 21 then
				wait_frames_skipping(60)
			end
			if at <= 22 then
				wait_frames_skipping(40)
			end
			if at <= 23 then
				wait_frames_skipping(5)
			end
			if at <= 24 then
				wait_frames_skipping(15)
			end
			if at <= 25 then
				wait_frames_skipping(5)
			end
			if at <= 26 then
				wait_frames_skipping(2)
			end
			if at <= 27 then
				helper_238b5abc(2)
			end
			if at <= 28 then
				wait_frames_skipping(30)
			end
			if at <= 29 then
				wait_frames_skipping(20)
			end
			if at <= 30 then
				wait_frames_skipping(47)
			end
			if at <= 31 then
				wait_frames_skipping(40)
			end
			if at <= 32 then
				helper_8cd371d7(1110030)
			end
			if at <= 33 then
				helper_8cd371d7(1110040)
			end
			if at <= 34 then
				helper_238b5abc(3)
			end
			if at <= 35 then
				helper_52aadc70(1110050, -1)
			end
			if at <= 36 then
				helper_238b5abc(3)
			end
			if at <= 37 then
				helper_238b5abc(4)
			end
			if at <= 38 then
				wait_frames_skipping(2)
			end
			if at <= 39 then
				wait_frames_skipping(78)
			end
			if at <= 40 then
				helper_52aadc70(1110060, 60)
			end
			if at <= 41 then
				helper_238b5abc(2)
			end
			if at <= 42 then
				helper_52aadc70(1110060, 60)
			end
			if at <= 43 then
				helper_52aadc70(1110080, 90)
			end
			if at <= 44 then
				helper_238b5abc(2)
			end
			if at <= 45 then
				wait_frames_skipping(34)
			end
			if at <= 46 then
				helper_8cd371d7(1110090)
			end
			if at <= 47 then
				helper_238b5abc(0)
			end
			if at <= 48 then
				helper_238b5abc(0)
			end
			if at <= 49 then
				wait_frames_skipping(30)
			end
			if at <= 50 then
				helper_344d6cd8()
			end
			if at <= 51 then
				helper_8cd371d7(1110100)
			end
			if at <= 52 then
				wait_frames_skipping(120)
			end
			if at <= 53 then
				helper_344d6cd8()
			end
			return true
		end)
		if ret ~= nil then
			return
		end
	end
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	event.clear_event_battle_monsters(-1)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, -1)
	event.attach_object_handle_to_character(5, 1)
	event.set_object_handle_visible(5, 1)
	event.attach_object_handle_to_character(6, 2)
	event.set_object_handle_visible(6, 1)
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
	event.set_character_active(0)
	event.set_character_position(0, 83.74, 0.0, -19.9)
	event.set_character_rotation(0, 0.0, -1.32, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_action_character_motion(0)
	event.set_camera_position(209.67, 35.0, -52.16)
	event.set_camera_look_at(83.74, 30.0, -19.9)
	event.reset_follow_camera(0)
	event.load_map_sounds(1683)
	event.show_dungeon_status_bar(1)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_5c274fcd
