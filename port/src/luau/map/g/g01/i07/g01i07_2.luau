--!strict
-- map/g/g01/i07/g01i07_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1a45a79f = require("@lib/event/helper_1a45a79f")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_43cef388 = require("@lib/event/helper_43cef388")
local helper_76f23193 = require("@lib/event/helper_76f23193")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9c9ed513 = require("@lib/event/helper_9c9ed513")
local helper_afbdd04b = require("@lib/event/helper_afbdd04b")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_f2e47558 = require("@lib/event/helper_f2e47558")
local helper_f4d83329 = require("@lib/event/helper_f4d83329")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_181c0()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e200/e250/e250_noam.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e250/e250_rococo.gltf", "info", 41)
	event.attach_object_handle_to_character(8, 41)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.set_character_active(0, 41)
	event.load_character(5, "event/e200/e250/e250_zak.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e200/e250/e250_wicky.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e250/e250_tobo.gltf", "info", 40)
	event.attach_object_handle_to_character(7, 40)
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e200/e250/e250_mogri.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
	event.load_message_file(0, 5, "event/e200/e250/e250_1.txt")
end

--- Helper function.
local function helper_17dec()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(39)
	event.delete_character(34)
	event.delete_character(41)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_character(38)
	event.delete_character(40)
end

--- Helper function.
local function helper_194b8()
	local var1: s32 = 0
	local var2: s32 = 0
	vm.section(function()
		event.set_save_flag(250, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var1 = event.load_sound_effect_file_2(2226) or var1
		helper_181c0()
		event.set_object_handle_footstep_sound(5, 3)
		event.set_object_handle_footstep_sound(7, 3)
		event.set_object_handle_footstep_sound(8, 3)
		event.set_object_handle_footstep_sound(2, 3)
		event.set_object_handle_footstep_sound(4, 3)
		event.set_object_handle_footstep_sound(3, 3)
		event.set_object_handle_footstep_sound(6, 3)
		var2 = event.get_active_music_number() or var2
		if var2 ~= 57 then
			event.stop_music(0)
			wait_frames(4)
			event.load_music(57)
			event.play_music(0)
		end
		event.set_camera_position(61.02, 50.01, -21.23)
		event.set_camera_look_at(38.72, 33.02, 92.47)
		event.set_character_position(0, 36.74, 11.68, 80.62)
		event.set_character_rotation(0, 0.0, 3.08, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.set_character_position(global0, 36.74, 11.68, 80.62)
		event.set_character_rotation(global0, 0.0, 3.08, 0.0)
		event.set_character_position(global1, 36.74, 11.68, 80.62)
		event.set_character_rotation(global1, 0.0, 3.08, 0.0)
		event.set_character_position(39, 36.74, 11.68, 80.62)
		event.set_character_rotation(39, 0.0, 3.08, 0.0)
		event.set_character_position(34, 36.74, 11.68, 80.62)
		event.set_character_rotation(34, 0.0, 3.08, 0.0)
		event.set_character_position(35, 36.74, 11.68, 80.62)
		event.set_character_rotation(35, 0.0, 3.08, 0.0)
		event.set_character_position(40, 36.74, 11.68, 80.62)
		event.set_character_rotation(40, 0.0, 3.08, 0.0)
		event.set_character_position(36, 36.74, 11.68, 80.62)
		event.set_character_rotation(36, 0.0, 3.08, 0.0)
		event.set_character_position(41, 36.74, 11.68, 80.62)
		event.set_character_rotation(41, 0.0, 3.08, 0.0)
		event.set_character_position(38, 36.74, 11.68, 80.62)
		event.set_character_rotation(38, 0.0, 3.08, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(91.91, 40.58, -22.22)
		event.set_camera_sequence_look_at(60.35, 28.33, -88.23)
		event.set_object_sequence_position(5, 61.73, 0.0, -98.0)
		event.set_object_sequence_rotation(5, 0.0, -0.16, 0.0)
		event.fade_in_screen(30)
		event.play_sound_effect(var1, 8)
		event.set_object_sequence_motion(5, "うたたね", 4)
		wait_frames(30)
		wait_frames(30)
		wait_frames(60)
		event.play_sound_effect(var1, 9)
		event.play_sound_effect(var1, 10)
		event.set_object_sequence_motion(5, "目を覚ます", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		wait_frames(56)
		event.set_object_sequence_motion(5, "会話", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500010)
		event.set_object_sequence_motion(5, "歩き", 0)
		event.move_object_sequence(5, 14.66, 0.0, -93.65, 90)
		event.rotate_object_sequence(5, 0.0, -1.36, 0.0, 15)
		wait_frames(60)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 41)
		event.set_character_active(1, 34)
		event.set_character_active(1, 40)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_character_active(1, 38)
		event.set_camera_sequence_position(114.27, 52.14, 5.16)
		event.set_camera_sequence_look_at(75.96, 38.4, 31.19)
		event.set_object_sequence_position(0, 41.21, 12.34, 89.84)
		event.set_object_sequence_rotation(0, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(1, 59.24, 12.34, 90.02)
		event.set_object_sequence_rotation(1, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(2, 50.17, 12.34, 41.54)
		event.set_object_sequence_rotation(2, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(7, -47.75, 0.0, -33.99)
		event.set_object_sequence_rotation(7, 0.0, 1.28, 0.0)
		event.set_object_sequence_position(3, 65.47, 12.34, 70.09)
		event.set_object_sequence_rotation(3, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(4, 48.11, 12.34, 62.89)
		event.set_object_sequence_rotation(4, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(8, -40.99, 0.0, -53.0)
		event.set_object_sequence_rotation(8, 0.0, 0.68, 0.0)
		event.set_object_sequence_position(6, 26.04, 12.34, 58.13)
		event.set_object_sequence_rotation(6, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(5, -3.45, 0.0, -90.22)
		event.set_object_sequence_rotation(5, 0.0, -0.16, 0.0)
		event.move_camera_sequence_eased(71.46, 34.6, 10.91, -11.65, 23.24, -37.81, 48, 2, 0.4)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 75)
		event.add_object_sequence_path_point(2, 50.17, 12.34, 41.54)
		event.add_object_sequence_path_point(2, 34.93, 4.87, 15.29)
		event.add_object_sequence_path_point(2, 8.97, 0.0, -10.99)
		event.add_object_sequence_path_point(2, -11.35, 0.0, -43.14)
		event.add_object_sequence_path_point(2, -20.73, 0.0, -44.48)
		event.add_object_sequence_path_point(2, -25.84, 0.0, -41.54)
		event.start_object_sequence_path(2)
		event.rotate_object_sequence(2, 0.0, -1.06, 0.0, 60)
		event.delay_object_sequence_position_track(4, 5)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 60)
		event.add_object_sequence_path_point(4, 47.83, 12.34, 60.96)
		event.add_object_sequence_path_point(4, 35.91, 12.34, 38.26)
		event.add_object_sequence_path_point(4, 26.63, 1.97, 7.16)
		event.add_object_sequence_path_point(4, -3.9, 0.0, -27.19)
		event.add_object_sequence_path_point(4, -17.06, 0.0, -28.08)
		event.add_object_sequence_path_point(4, -22.59, 0.0, -27.4)
		event.start_object_sequence_path(4)
		event.rotate_object_sequence(4, 0.0, -1.87, 0.0, 65)
		event.delay_object_sequence_position_track(3, 15)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 60)
		event.add_object_sequence_path_point(3, 65.47, 12.34, 70.09)
		event.add_object_sequence_path_point(3, 48.07, 12.34, 41.25)
		event.add_object_sequence_path_point(3, 17.35, 0.0, 4.4)
		event.add_object_sequence_path_point(3, -6.48, 0.0, -13.51)
		event.add_object_sequence_path_point(3, -21.65, 0.0, -14.06)
		event.start_object_sequence_path(3)
		event.rotate_object_sequence(3, 0.0, -2.12, 0.0, 75)
		event.delay_object_sequence_position_track(6, 10)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 60)
		event.add_object_sequence_path_point(6, 26.04, 12.34, 58.13)
		event.add_object_sequence_path_point(6, 16.54, 12.34, 39.83)
		event.add_object_sequence_path_point(6, 15.0, 1.75, 6.54)
		event.add_object_sequence_path_point(6, -18.95, 0.07, -5.53)
		event.add_object_sequence_path_point(6, -36.21, 0.07, -6.68)
		event.start_object_sequence_path(6)
		event.rotate_object_sequence(6, 0.0, -2.94, 0.0, 70)
		event.move_object_sequence(7, -48.33, 0.0, -19.5, 15)
		event.rotate_object_sequence(7, 0.0, 1.76, 0.0, 15)
		event.move_object_sequence(8, -47.4, 0.0, -39.83, 15)
		event.rotate_object_sequence(8, 0.0, 1.04, 0.0, 15)
		event.move_object_sequence(5, -41.32, 0.0, -54.14, 15)
		event.rotate_object_sequence(5, 0.0, 0.68, 0.0, 15)
		event.set_object_sequence_motion(2, "走り", 0)
		event.delay_object_sequence_motion_track(2, 75)
		event.set_object_sequence_motion(2, "立ち", 0)
		event.set_object_sequence_motion(4, "立ち", 0)
		event.delay_object_sequence_motion_track(5)
		event.set_object_sequence_motion(4, "走り2", 0)
		event.delay_object_sequence_motion_track(4, 60)
		event.set_object_sequence_motion(4, "立ち", 0)
		event.set_object_sequence_motion(3, "立ち", 0)
		event.delay_object_sequence_motion_track(3, 15)
		event.set_object_sequence_motion(3, "走り", 0)
		event.delay_object_sequence_motion_track(3, 60)
		event.set_object_sequence_motion(3, "立ち", 0)
		event.set_object_sequence_motion(6, "立ち", 0)
		event.delay_object_sequence_motion_track(6, 10)
		event.set_object_sequence_motion(6, "走り", 0)
		event.delay_object_sequence_motion_track(6, 60)
		event.set_object_sequence_motion(6, "立ち", 0)
		event.set_object_sequence_motion(7, "走り", 0)
		event.delay_object_sequence_motion_track(7, 15)
		event.set_object_sequence_motion(7, "立ち", 0)
		event.set_object_sequence_motion(8, "走り", 0)
		event.delay_object_sequence_motion_track(8, 15)
		event.set_object_sequence_motion(8, "立ち", 0)
		event.set_object_sequence_motion(5, "走り", 0)
		event.delay_object_sequence_motion_track(5, 15)
		event.set_object_sequence_motion(5, "立ち", 0)
		helper_9c9ed513(2500020, 90)
		event.set_object_sequence_motion(7, "会話", 0)
		event.delay_object_sequence_motion_track(3, 15)
		event.set_object_sequence_motion(3, "会話", 0)
		event.delay_object_sequence_motion_track(2, 20)
		event.set_object_sequence_motion(2, "会話", 0)
		event.delay_object_sequence_motion_track(8, 30)
		event.set_object_sequence_motion(8, "会話", 0)
		event.delay_object_sequence_motion_track(4, 20)
		event.set_object_sequence_motion(4, "会話", 0)
		event.delay_object_sequence_motion_track(6, 30)
		event.set_object_sequence_motion(6, "会話", 0)
		event.set_mouth_texture_animations(7, "口パク")
		helper_4116e6bb(2500040)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		helper_4116e6bb(2500050)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(8, "口パク")
		helper_4116e6bb(2500060)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "口パク")
		helper_4116e6bb(2500070)
		event.reset_mouth_texture_animations()
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_motion(5, "会話2", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		event.delay_object_sequence_motion_track(2, 68)
		event.set_object_sequence_motion(2, "立ち", 0)
		event.delay_object_sequence_motion_track(3, 73)
		event.set_object_sequence_motion(3, "立ち", 0)
		event.delay_object_sequence_motion_track(4, 68)
		event.set_object_sequence_motion(4, "立ち", 0)
		event.delay_object_sequence_motion_track(6, 78)
		event.set_object_sequence_motion(6, "立ち", 0)
		event.delay_object_sequence_motion_track(7, 68)
		event.set_object_sequence_motion(7, "立ち", 0)
		event.delay_object_sequence_motion_track(8, 73)
		event.set_object_sequence_motion(8, "立ち", 0)
		helper_4116e6bb(2500080)
		wait_objects(5)
		event.set_object_sequence_motion(5, "歩き", 0)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 120)
		event.add_object_sequence_path_point(5, -40.55, 0.0, -53.27)
		event.add_object_sequence_path_point(5, -21.22, 0.0, -65.68)
		event.add_object_sequence_path_point(5, -5.35, 0.0, -60.71)
		event.add_object_sequence_path_point(5, -3.11, 0.0, -43.59)
		event.add_object_sequence_path_point(5, 5.06, 0.0, -14.63)
		event.add_object_sequence_path_point(5, 20.49, 0.0, 8.1)
		event.start_object_sequence_path(5)
		wait_frames(120)
		event.set_camera_sequence_position(7.29, 16.04, -33.96)
		event.set_camera_sequence_look_at(10.55, 19.12, 1.79)
		event.set_object_sequence_position(0, 41.21, 12.34, 89.84)
		event.set_object_sequence_rotation(0, 0.0, -2.72, 0.0)
		event.set_object_sequence_position(1, 59.24, 12.34, 90.02)
		event.set_object_sequence_rotation(1, 0.0, -2.6, 0.0)
		event.set_object_sequence_position(5, 9.1, 0.0, 9.43)
		event.set_object_sequence_rotation(5, 0.0, 0.45, 0.0)
		event.set_object_sequence_motion(5, "会話2", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500090)
		event.set_object_sequence_motion(5, "会話2", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500100)
		event.set_object_sequence_motion(5, "会話2", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500110)
		helper_4116e6bb(2500115)
		helper_4116e6bb(2500120)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(2500130)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話2", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500140)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(2500150)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(70.03, 70.11, 56.44)
		event.set_camera_sequence_look_at(5.23, 27.72, -0.73)
		event.set_object_sequence_position(5, 4.81, 0.0, 5.51)
		event.set_object_sequence_rotation(5, 0.0, 0.93, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.74, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 1.04, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.69, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 1.42, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 1.16, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 0.92, 0.0)
		event.play_sound_effect(var1, 11)
		event.set_object_sequence_motion(5, "振り返り", 6)
		event.queue_object_sequence_next_motion(5, "振り返り会話", 0)
		helper_9c9ed513(2500160, 130)
		wait_objects(5)
		event.play_sound_effect(var1, 12)
		event.set_object_sequence_motion(2, "おー", 6)
		event.set_object_sequence_motion(3, "おー", 6)
		event.set_object_sequence_motion(4, "おー", 6)
		event.set_object_sequence_motion(6, "おー", 6)
		event.set_object_sequence_motion(7, "おー", 6)
		event.set_object_sequence_motion(8, "おー", 6)
		event.play_sound_effect(var1, 13)
		event.set_object_sequence_motion(5, "振り返り2", 6)
		event.delay_object_sequence_motion_track(5, 52)
		event.set_object_sequence_motion(5, "走り", 0)
		event.delay_object_sequence_motion_track(2, 62)
		event.set_object_sequence_motion(2, "走り2", 0)
		event.delay_object_sequence_motion_track(3, 72)
		event.set_object_sequence_motion(3, "走り", 0)
		event.delay_object_sequence_motion_track(4, 82)
		event.set_object_sequence_motion(4, "走り", 0)
		event.delay_object_sequence_motion_track(6, 92)
		event.set_object_sequence_motion(6, "走り", 0)
		event.delay_object_sequence_motion_track(7, 102)
		event.set_object_sequence_motion(7, "走り", 0)
		event.delay_object_sequence_motion_track(8, 92)
		event.set_object_sequence_motion(8, "走り", 0)
		event.delay_object_sequence_position_track(5, 52)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 45)
		event.add_object_sequence_path_point(5, 4.81, 0.0, 5.51)
		event.add_object_sequence_path_point(5, 15.09, 7.98, 24.0)
		event.add_object_sequence_path_point(5, 25.36, 12.34, 52.49)
		event.add_object_sequence_path_point(5, 39.32, 12.34, 82.98)
		event.start_object_sequence_path(5)
		event.delay_object_sequence_position_track(2, 62)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 45)
		event.add_object_sequence_path_point(2, -25.84, 0.0, -41.54)
		event.add_object_sequence_path_point(2, -20.06, 0.0, -45.69)
		event.add_object_sequence_path_point(2, 3.7, 0.0, -10.84)
		event.add_object_sequence_path_point(2, 39.39, 12.34, 77.06)
		event.start_object_sequence_path(2)
		event.delay_object_sequence_position_track(3, 72)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 45)
		event.add_object_sequence_path_point(3, -21.96, 0.0, -12.25)
		event.add_object_sequence_path_point(3, 14.28, 0.0, -4.5)
		event.add_object_sequence_path_point(3, 71.46, 12.34, 38.42)
		event.start_object_sequence_path(3)
		event.delay_object_sequence_position_track(4, 82)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 45)
		event.add_object_sequence_path_point(4, -22.59, 0.0, -27.4)
		event.add_object_sequence_path_point(4, -17.06, 0.0, -28.08)
		event.add_object_sequence_path_point(4, 15.38, 0.0, -0.94)
		event.add_object_sequence_path_point(4, 46.35, 12.34, 60.68)
		event.start_object_sequence_path(4)
		event.delay_object_sequence_position_track(6, 92)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 45)
		event.add_object_sequence_path_point(6, -36.21, 0.0, -6.68)
		event.add_object_sequence_path_point(6, 11.35, 0.0, -7.15)
		event.add_object_sequence_path_point(6, 56.62, 12.34, 55.65)
		event.start_object_sequence_path(6)
		event.delay_object_sequence_position_track(7, 102)
		event.clear_object_sequence_path(7)
		event.set_object_sequence_path_frames(7, 45)
		event.add_object_sequence_path_point(7, -47.74, 0.0, -19.5)
		event.add_object_sequence_path_point(7, 8.7, 0.0, -6.82)
		event.add_object_sequence_path_point(7, 34.63, 12.34, 67.71)
		event.start_object_sequence_path(7)
		event.delay_object_sequence_position_track(8, 92)
		event.clear_object_sequence_path(8)
		event.set_object_sequence_path_frames(8, 45)
		event.add_object_sequence_path_point(8, -47.4, 0.0, -39.83)
		event.add_object_sequence_path_point(8, 15.0, 0.0, 5.12)
		event.add_object_sequence_path_point(8, 16.13, 21.34, 75.28)
		event.start_object_sequence_path(8)
		event.delay_object_sequence_sound_track(5, 150)
		event.play_object_sequence_sound(5, var1, 14)
		event.delay_object_sequence_motion_track(5, 88)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.delay_object_sequence_motion_track(2, 93)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.delay_object_sequence_motion_track(3, 98)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.delay_object_sequence_motion_track(4, 103)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.delay_object_sequence_motion_track(6, 108)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.delay_object_sequence_motion_track(7, 113)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.delay_object_sequence_motion_track(8, 118)
		event.set_object_sequence_motion(8, "立ち", 4)
		helper_1a45a79f(2500170, 240, 30)
		event.reset_mouth_texture_animations()
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(1)
	event.stop_music(0)
	helper_17dec()
	event.reset_follow_camera(0)
end

--- Helper function.
local function helper_e8dc()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e209/e209_rococo.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e209/e209_tobo.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e200/e209/e209_conda.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	block = event.load_event_image_4(5, "textures/event/e200/e209/cap_e209.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "森の美女", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "美女と七人", block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
	event.set_event_sprite_size(1, 512, 448)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(11, 1)
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "森に入っていく美女", block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
	event.set_event_sprite_size(2, 512, 448)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(12, 2)
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "悲しむ七人", block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 448.0)
	event.set_event_sprite_size(3, 512, 448)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(13, 3)
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "捜索隊結成！", block)
	event.set_event_sprite_color(4, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(4, 0, 0, 512.0, 448.0)
	event.set_event_sprite_size(4, 512, 448)
	event.set_event_sprite_position(4, 256, 208)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(14, 4)
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	event.load_event_script_arguments(5, "event/e200/e209/e209_arg.stb")
	event.load_message_file(0, 5, "event/e200/e209/e209_1.txt")
	event.set_object_handle_frame_visible(4, "tue", 0)
	event.set_scene_status_flags(1, global0, 256, 1)
	event.set_scene_status_flags(1, global1, 256, 1)
end

--- Helper function.
local function helper_21c00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_e3f4()
	local active_chr_no: s32 = 0
	event.set_scene_status_flags(1, global0, 256, 0)
	event.set_scene_status_flags(1, global1, 256, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_105ec()
	local var1: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(209, 1)
		event.initialize_event()
		event.load_map_sounds(2220)
		var1 = event.load_sound_effect_file_2(2220) or var1
		var2 = event.get_active_music_number() or var2
		if var2 ~= 57 then
			event.stop_music(0)
			at = 1
			wait_frames(4)
			event.load_music(57)
			event.play_music(0)
		end
		helper_e8dc()
		event.set_object_handle_sound_bank(2, var1)
		event.set_object_handle_frame_visible(4, "tue", 0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_sound_bank(2, var1)
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(47.0, 34.37, -20.4)
		event.set_camera_sequence_look_at(48.77, 33.02, 92.31)
		event.set_object_sequence_position(0, 37.73, 12.34, 48.71)
		event.set_object_sequence_rotation(0, 0.0, -3.13, 0.0)
		event.set_object_sequence_position(1, 59.47, 12.34, 50.85)
		event.set_object_sequence_rotation(1, 0.0, -3.09, 0.0)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_footstep_sound(1, 3)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 90)
		event.add_object_sequence_path_point(0, 14.08, 22.46, 76.1)
		event.add_object_sequence_path_point(0, 29.1, 16.19, 75.87)
		event.add_object_sequence_path_point(0, 38.77, 12.34, 66.82)
		event.add_object_sequence_path_point(0, 40.57, 12.24, 54.03)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, 15.0, 21.86, 97.09)
		event.add_object_sequence_path_point(1, 34.81, 12.34, 96.25)
		event.add_object_sequence_path_point(1, 56.96, 12.34, 86.7)
		event.add_object_sequence_path_point(1, 59.47, 12.34, 50.85)
		event.start_object_sequence_path(1)
		at = 2
		wait_frames(90)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_handle_footstep_sound(1, 0)
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_object_handle_frame_visible(4, "cube37", 0)
		event.set_object_handle_frame_visible(4, "cube38", 0)
		event.set_camera_sequence_position(61.85, 30.75, 55.74)
		event.set_camera_sequence_look_at(57.45, 21.42, -9.43)
		event.set_object_sequence_position(2, 58.4, 0.0, 1.06)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(3, 28.34, 0.57, -39.22)
		event.set_object_sequence_rotation(3, 0.0, 1.96, 0.0)
		event.set_object_sequence_position(4, 68.15, 0.0, -98.49)
		event.set_object_sequence_rotation(4, 0.0, -0.36, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "右向き座り", 4)
		event.set_object_sequence_motion(4, "座り", 4)
		at = 3
		wait_frames(60)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(55.75, 34.46, -7.05)
		event.set_camera_sequence_look_at(57.08, 35.01, 47.34)
		event.set_object_sequence_position(0, 47.38, 12.34, 47.12)
		event.set_object_sequence_rotation(0, 0.0, 3.02, 0.0)
		event.set_object_sequence_position(1, 66.48, 12.34, 44.88)
		event.set_object_sequence_rotation(1, 0.0, -3.05, 0.0)
		event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "小人見立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 4
		helper_4116e6bb(2090070)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(101.12, 31.73, 32.84)
		event.set_camera_sequence_look_at(86.47, 31.09, 33.6)
		event.set_object_sequence_position(0, 32.8, 12.34, 47.06)
		event.set_object_sequence_rotation(0, 0.0, 2.54, 0.0)
		event.set_object_sequence_position(1, 54.18, 12.34, 45.41)
		event.set_object_sequence_rotation(1, 0.0, -3.05, 0.0)
		event.set_object_sequence_position(2, 58.74, 0.0, -1.86)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.move_object_sequence(2, 48.3, 7.12, 21.59, 45)
		at = 5
		wait_frames(45)
		event.set_object_sequence_motion(2, "立ち", 0)
		at = 6
		wait_frames(30)
		event.play_sound_effect(var1, 8)
		event.set_object_sequence_motion(2, "手を出す", 6)
		event.queue_object_sequence_next_motion(2, "手を出すL", 0)
		at = 7
		wait_frames(20)
		at = 8
		wait_frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 9
		helper_4116e6bb(2090080)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "よこせ", 6)
		event.queue_object_sequence_next_motion(2, "よこせ戻り", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		at = 10
		wait_frames(53)
		at = 11
		wait_frames(15)
		event.set_object_sequence_motion(1, "腕組み", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "腕組みL", 0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "前向き～左向き")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 12
		helper_4116e6bb(2090090)
		event.reset_mouth_texture_animations()
		at = 13
		wait_objects(1)
		event.set_object_sequence_motion(2, "うなづく", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		at = 14
		wait_frames(37)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 15
		helper_4116e6bb(2090100)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var1, 10)
		event.set_object_sequence_motion(2, "うぬぬぬ", 6)
		event.queue_object_sequence_next_motion(2, "うぬぬぬL", 0)
		at = 16
		wait_frames(20)
		event.set_mouth_texture_animations(2, "口くいしばり")
		at = 17
		helper_4116e6bb(2090110)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "腕組み戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
		at = 18
		wait_frames(36)
		at = 19
		wait_frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 20
		helper_4116e6bb(2090120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 1, "左向き～前向き")
		event.set_object_sequence_motion(1, "小人見会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 21
		helper_4116e6bb(2090125)
		event.reset_mouth_texture_animations()
		at = 22
		wait_objects(1)
		at = 23
		wait_frames(15)
		event.play_sound_effect(var1, 11)
		event.set_object_sequence_motion(2, "うぬぬぬ戻り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		at = 24
		wait_frames(13)
		event.set_mouth_texture_animations(2, "口パク")
		at = 25
		helper_4116e6bb(2090130)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 26
		helper_4116e6bb(2090140)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク")
		at = 27
		helper_4116e6bb(2090150)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 34)
		event.set_camera_sequence_position(47.37, 32.06, 15.25)
		event.set_camera_sequence_look_at(54.66, 33.2, 46.95)
		event.set_object_sequence_rotation(1, 0.0, -2.93, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 28
		helper_4116e6bb(2090160)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 29
		helper_4116e6bb(2090170)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 30
		helper_4116e6bb(2090180)
		event.reset_mouth_texture_animations()
		if global0 ~= 0 then
			event.set_character_active(0, 37)
		end
		event.set_character_active(0, global0)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(23.05, 41.22, 65.24)
		event.set_camera_sequence_look_at(38.44, 35.55, 49.41)
		event.set_object_sequence_motion(1, "小人見会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 31
		helper_4116e6bb(2090190)
		event.reset_mouth_texture_animations()
		at = 32
		wait_objects(1)
		event.set_object_sequence_motion(2, "やだよ", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		event.set_mouth_texture_animations(2, "口パク")
		at = 33
		helper_4116e6bb(2090200)
		event.reset_mouth_texture_animations()
		at = 34
		wait_objects(2)
		if global0 ~= 0 then
			event.set_character_active(1, 37)
		end
		event.set_character_active(1, global0)
		event.set_character_active(0, 34)
		event.set_camera_sequence_position(73.08, 33.52, 20.51)
		event.set_camera_sequence_look_at(34.32, 34.8, 47.0)
		event.set_object_sequence_rotation(0, 0.0, 2.54, 0.0)
		event.set_object_sequence_motion(0, "小人見会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "小人見立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 35
		helper_4116e6bb(2090210)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(88.63, 47.47, 55.5)
		event.set_camera_sequence_look_at(45.2, 27.56, 32.66)
		event.set_object_sequence_position(2, 49.44, 6.02, 28.31)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.play_sound_effect(var1, 12)
		event.set_object_sequence_motion(2, "腕組み", 6)
		event.queue_object_sequence_next_motion(2, "腕組みL", 0)
		at = 36
		wait_frames(13)
		event.set_mouth_texture_animations(2, "口パク")
		at = 37
		helper_4116e6bb(2090220)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "腕組み戻り", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		event.delay_object_sequence_motion_track(0, 45)
		event.set_object_sequence_motion(0, "前を見る", 6)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "前を見る", 6)
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "振り向く", 6)
		event.queue_object_sequence_next_motion(2, "振り向くL", 0)
		at = 38
		helper_4116e6bb(2090230)
		at = 39
		helper_4116e6bb(2090235)
		event.set_camera_sequence_position(33.22, 50.72, 90.25)
		event.set_camera_sequence_look_at(67.33, 16.97, -92.82)
		event.set_object_sequence_position(4, 65.22, 0.0, -99.04)
		event.set_object_sequence_rotation(4, 0.0, -0.12, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "座り", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		at = 40
		helper_4116e6bb(2090240)
		event.delay_object_sequence_motion_track(4, 30)
		event.set_object_sequence_motion(4, "手まねき", 6)
		event.queue_object_sequence_next_motion(4, "座り", 0)
		at = 41
		helper_4116e6bb(2090245)
		at = 42
		wait_objects(4)
		event.mark_camera_sequence_fade_track()
		event.fade_out_music(30)
		event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
		at = 43
		wait_frames(30)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(-44.56, 40.35, -82.32)
		event.set_camera_sequence_look_at(30.18, 23.34, -95.14)
		event.set_object_sequence_position(0, 90.21, 0.0, -36.12)
		event.set_object_sequence_rotation(0, 0.0, -2.18, 0.0)
		event.set_object_sequence_position(1, 98.27, 0.0, -52.72)
		event.set_object_sequence_rotation(1, 0.0, -1.61, 0.0)
		event.set_object_sequence_position(2, 29.51, 0.0, -37.25)
		event.set_object_sequence_rotation(2, 0.0, 2.32, 0.0)
		event.set_object_sequence_position(3, 21.3, 0.0, -61.73)
		event.set_object_sequence_rotation(3, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(4, 59.82, 0.0, -98.58)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "座り", 4)
		event.set_object_sequence_motion(1, "座り", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "座り", 4)
		event.set_object_sequence_motion(3, "座り", 4)
		event.set_object_sequence_motion(4, "座り2", 4)
		event.stop_music(0)
		at = 44
		wait_frames(4)
		event.load_music(101)
		event.play_music(0)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
		event.move_camera_sequence_eased(-38.67, 40.35, -48.0, 36.07, 23.34, -60.82, 60, 2, 0.4)
		at = 45
		wait_camera()
		event.set_object_sequence_motion(4, "座り会話", 6)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		at = 46
		helper_4116e6bb(2090250)
		event.set_object_sequence_motion(4, "トボを指す", 6)
		event.queue_object_sequence_next_motion(4, "トボを指すL", 0)
		at = 47
		helper_4116e6bb(2090253)
		event.set_object_sequence_motion(4, "ロココを指す", 6)
		event.queue_object_sequence_next_motion(4, "ロココを差すL", 0)
		at = 48
		helper_4116e6bb(2090255)
		event.queue_object_sequence_next_motion(4, "ロココを指す戻り", 2)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		at = 49
		helper_4116e6bb(2090257)
		event.set_object_sequence_motion(1, "座り会話", 2)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 50
		helper_4116e6bb(2090260)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 51
		helper_4116e6bb(2090270)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "座り会話", 2)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 52
		helper_4116e6bb(2090280)
		event.reset_mouth_texture_animations()
		at = 53
		wait_objects(1)
		at = 54
		helper_4116e6bb(2090290)
		event.set_object_sequence_motion(4, "座り会話", 2)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		at = 55
		helper_4116e6bb(2090300)
		at = 56
		helper_4116e6bb(2090305)
		at = 57
		wait_objects(4)
		event.set_camera_sequence_position(78.46, 25.97, -62.11)
		event.set_camera_sequence_look_at(60.62, 21.41, -99.2)
		event.set_object_sequence_motion(4, "座り2", 4)
		at = 58
		helper_4116e6bb(2090310)
		event.set_camera_sequence_position(71.99, 24.65, -75.78)
		event.set_camera_sequence_look_at(95.96, 21.41, -49.6)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 59
		helper_4116e6bb(2090320)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(78.46, 25.97, -62.11)
		event.set_camera_sequence_look_at(60.62, 21.41, -99.2)
		event.set_object_sequence_motion(4, "座り会話", 6)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		at = 60
		helper_4116e6bb(2090330)
		at = 61
		helper_4116e6bb(2090335)
		at = 62
		wait_objects(4)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 30)
		at = 63
		helper_4116e6bb(2090340)
		at = 64
		helper_4116e6bb(2090345)
		at = 65
		helper_4116e6bb(2090350)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(11, 128.0, 128.0, 128.0, 128.0, 15)
		at = 66
		wait_frames(15)
		event.set_event_sprite_draw_pass(0, 0)
		at = 67
		helper_4116e6bb(2090360)
		at = 68
		helper_4116e6bb(2090370)
		at = 69
		helper_4116e6bb(2090375)
		at = 70
		helper_4116e6bb(2090380)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(12, 128.0, 128.0, 128.0, 128.0, 15)
		at = 71
		wait_frames(15)
		event.set_event_sprite_draw_pass(1, 0)
		at = 72
		helper_4116e6bb(2090390)
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(13, 128.0, 128.0, 128.0, 128.0, 15)
		at = 73
		wait_frames(15)
		event.set_event_sprite_draw_pass(2, 0)
		at = 74
		helper_4116e6bb(2090400)
		at = 75
		helper_4116e6bb(2090410)
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(14, 128.0, 128.0, 128.0, 128.0, 15)
		at = 76
		wait_frames(15)
		event.set_event_sprite_draw_pass(3, 0)
		at = 77
		helper_4116e6bb(2090420)
		at = 78
		helper_4116e6bb(2090430)
		event.set_camera_sequence_position(90.58, 30.29, -39.36)
		event.set_camera_sequence_look_at(66.74, 28.6, -43.56)
		event.set_object_sequence_motion(4, "ぽりぽり", 4)
		event.move_camera_sequence_eased(90.58, 30.29, -39.36, 78.8, 28.6, -60.82, 120, 2, 0.4)
		event.set_object_sequence_color(14, 128.0, 128.0, 128.0, 0.0, 15)
		at = 79
		wait_frames(15)
		event.set_event_sprite_draw_pass(4, 0)
		at = 80
		helper_4116e6bb(2090440)
		at = 81
		helper_4116e6bb(2090445)
		at = 82
		helper_4116e6bb(2090450)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(83.43, 24.94, -81.73)
		event.set_camera_sequence_look_at(100.36, 18.47, -43.72)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		at = 83
		helper_4116e6bb(2090460)
		at = 84
		helper_4116e6bb(2090470)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 85
		helper_4116e6bb(2090480)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(82.07, 24.94, -61.63)
		event.set_camera_sequence_look_at(61.24, 20.49, -98.09)
		event.set_object_sequence_motion(4, "座り2", 4)
		at = 86
		helper_4116e6bb(2090490)
		event.set_camera_sequence_position(83.43, 24.94, -81.73)
		event.set_camera_sequence_look_at(100.36, 18.47, -43.72)
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(1, 45)
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "右を見る", 6)
		event.queue_object_sequence_next_motion(0, "右を見るL", 0)
		event.set_object_sequence_motion(1, "座り会話", 6)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 87
		helper_4116e6bb(2090500)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 88
		helper_4116e6bb(2090505)
		event.reset_mouth_texture_animations()
		at = 89
		wait_objects(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_camera_sequence_position(117.78, 25.28, -19.32)
		event.set_camera_sequence_look_at(91.26, 22.12, -49.27)
		event.set_object_sequence_motion(0, "座り", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "座り会話2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		at = 90
		helper_4116e6bb(2090510)
		event.set_camera_sequence_position(83.43, 24.94, -81.73)
		event.set_camera_sequence_look_at(100.36, 18.47, -43.72)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 91
		helper_4116e6bb(2090520)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 92
		helper_4116e6bb(2090525)
		event.reset_mouth_texture_animations()
		at = 93
		wait_objects(1)
		event.set_camera_sequence_position(84.67, 30.18, -70.24)
		event.set_camera_sequence_look_at(51.19, 19.0, -102.93)
		event.set_object_sequence_motion(4, "ぽりぽり", 4)
		at = 94
		helper_4116e6bb(2090530)
		at = 95
		helper_4116e6bb(2090535)
		at = 96
		wait_frames(60)
		event.delay_object_sequence_motion_track(4, 30)
		event.set_object_sequence_motion(4, "そうじゃ", 6)
		event.queue_object_sequence_next_motion(4, "そうじゃL", 0)
		at = 97
		helper_4116e6bb(2090540)
		event.set_camera_sequence_position(76.8, 23.38, -37.04)
		event.set_camera_sequence_look_at(35.31, 22.33, -45.08)
		event.set_object_sequence_position(3, 22.62, 0.0, -61.38)
		event.set_mouth_texture_animations(2, "口パク")
		at = 98
		helper_4116e6bb(2090550)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		at = 99
		helper_4116e6bb(2090560)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(81.93, 21.24, -74.02)
		event.set_camera_sequence_look_at(90.52, 21.61, -60.68)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目あきれ")
		event.play_sound_effect(var1, 13)
		event.set_object_sequence_motion(1, "あきれる", 6)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 100
		helper_4116e6bb(2090570)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
		event.play_sound_effect(var1, 14)
		event.set_object_sequence_motion(0, "衝撃", 6)
		event.set_object_sequence_motion(0, "衝撃L", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 101
		helper_4116e6bb(2090580)
		event.reset_mouth_texture_animations()
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 102
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_21c00000()
			wait_frames_skipping(90)
		end
		if at <= 2 then
			wait_frames_skipping(60)
		end
		if at <= 3 then
			helper_8cd371d7(2090070)
		end
		if at <= 4 then
			wait_frames_skipping(45)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			wait_frames_skipping(20)
		end
		if at <= 7 then
			wait_frames_skipping(15)
		end
		if at <= 8 then
			helper_8cd371d7(2090080)
		end
		if at <= 9 then
			wait_frames_skipping(53)
		end
		if at <= 10 then
			wait_frames_skipping(15)
		end
		if at <= 11 then
			helper_8cd371d7(2090090)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			wait_frames_skipping(37)
		end
		if at <= 14 then
			helper_8cd371d7(2090100)
		end
		if at <= 15 then
			wait_frames_skipping(20)
		end
		if at <= 16 then
			helper_8cd371d7(2090110)
		end
		if at <= 17 then
			wait_frames_skipping(36)
		end
		if at <= 18 then
			wait_frames_skipping(15)
		end
		if at <= 19 then
			helper_8cd371d7(2090120)
		end
		if at <= 20 then
			helper_8cd371d7(2090125)
		end
		if at <= 21 then
			helper_238b5abc(1)
		end
		if at <= 22 then
			wait_frames_skipping(15)
		end
		if at <= 23 then
			wait_frames_skipping(13)
		end
		if at <= 24 then
			helper_8cd371d7(2090130)
		end
		if at <= 25 then
			helper_8cd371d7(2090140)
		end
		if at <= 26 then
			helper_8cd371d7(2090150)
		end
		if at <= 27 then
			helper_8cd371d7(2090160)
		end
		if at <= 28 then
			helper_8cd371d7(2090170)
		end
		if at <= 29 then
			helper_8cd371d7(2090180)
		end
		if at <= 30 then
			helper_8cd371d7(2090190)
		end
		if at <= 31 then
			local _ = global0 ~= 0
			helper_238b5abc(1)
		end
		if at <= 32 then
			helper_8cd371d7(2090200)
		end
		if at <= 33 then
			helper_238b5abc(2)
		end
		if at <= 34 then
			helper_8cd371d7(2090210)
		end
		if at <= 35 then
			local _ = global0 ~= 0
			wait_frames_skipping(13)
		end
		if at <= 36 then
			helper_8cd371d7(2090220)
		end
		if at <= 37 then
			helper_8cd371d7(2090230)
		end
		if at <= 38 then
			helper_8cd371d7(2090235)
		end
		if at <= 39 then
			helper_8cd371d7(2090240)
		end
		if at <= 40 then
			helper_8cd371d7(2090245)
		end
		if at <= 41 then
			helper_238b5abc(4)
		end
		if at <= 42 then
			wait_frames_skipping(30)
		end
		if at <= 43 then
			wait_frames_skipping(4)
		end
		if at <= 44 then
			helper_344d6cd8()
		end
		if at <= 45 then
			helper_8cd371d7(2090250)
		end
		if at <= 46 then
			helper_8cd371d7(2090253)
		end
		if at <= 47 then
			helper_8cd371d7(2090255)
		end
		if at <= 48 then
			helper_8cd371d7(2090257)
		end
		if at <= 49 then
			helper_8cd371d7(2090260)
		end
		if at <= 50 then
			helper_8cd371d7(2090270)
		end
		if at <= 51 then
			helper_8cd371d7(2090280)
		end
		if at <= 52 then
			helper_238b5abc(1)
		end
		if at <= 53 then
			helper_8cd371d7(2090290)
		end
		if at <= 54 then
			helper_8cd371d7(2090300)
		end
		if at <= 55 then
			helper_8cd371d7(2090305)
		end
		if at <= 56 then
			helper_238b5abc(4)
		end
		if at <= 57 then
			helper_8cd371d7(2090310)
		end
		if at <= 58 then
			helper_8cd371d7(2090320)
		end
		if at <= 59 then
			helper_8cd371d7(2090330)
		end
		if at <= 60 then
			helper_8cd371d7(2090335)
		end
		if at <= 61 then
			helper_238b5abc(4)
		end
		if at <= 62 then
			helper_8cd371d7(2090340)
		end
		if at <= 63 then
			helper_8cd371d7(2090345)
		end
		if at <= 64 then
			helper_8cd371d7(2090350)
		end
		if at <= 65 then
			wait_frames_skipping(15)
		end
		if at <= 66 then
			helper_8cd371d7(2090360)
		end
		if at <= 67 then
			helper_8cd371d7(2090370)
		end
		if at <= 68 then
			helper_8cd371d7(2090375)
		end
		if at <= 69 then
			helper_8cd371d7(2090380)
		end
		if at <= 70 then
			wait_frames_skipping(15)
		end
		if at <= 71 then
			helper_8cd371d7(2090390)
		end
		if at <= 72 then
			wait_frames_skipping(15)
		end
		if at <= 73 then
			helper_8cd371d7(2090400)
		end
		if at <= 74 then
			helper_8cd371d7(2090410)
		end
		if at <= 75 then
			wait_frames_skipping(15)
		end
		if at <= 76 then
			helper_8cd371d7(2090420)
		end
		if at <= 77 then
			helper_8cd371d7(2090430)
		end
		if at <= 78 then
			wait_frames_skipping(15)
		end
		if at <= 79 then
			helper_8cd371d7(2090440)
		end
		if at <= 80 then
			helper_8cd371d7(2090445)
		end
		if at <= 81 then
			helper_8cd371d7(2090450)
		end
		if at <= 82 then
			helper_8cd371d7(2090460)
		end
		if at <= 83 then
			helper_8cd371d7(2090470)
		end
		if at <= 84 then
			helper_8cd371d7(2090480)
		end
		if at <= 85 then
			helper_8cd371d7(2090490)
		end
		if at <= 86 then
			helper_8cd371d7(2090500)
		end
		if at <= 87 then
			helper_8cd371d7(2090505)
		end
		if at <= 88 then
			helper_238b5abc(1)
		end
		if at <= 89 then
			helper_8cd371d7(2090510)
		end
		if at <= 90 then
			helper_8cd371d7(2090520)
		end
		if at <= 91 then
			helper_8cd371d7(2090525)
		end
		if at <= 92 then
			helper_238b5abc(1)
		end
		if at <= 93 then
			helper_8cd371d7(2090530)
		end
		if at <= 94 then
			helper_8cd371d7(2090535)
		end
		if at <= 95 then
			wait_frames_skipping(60)
		end
		if at <= 96 then
			helper_8cd371d7(2090540)
		end
		if at <= 97 then
			helper_8cd371d7(2090550)
		end
		if at <= 98 then
			helper_8cd371d7(2090560)
		end
		if at <= 99 then
			helper_8cd371d7(2090570)
		end
		if at <= 100 then
			helper_8cd371d7(2090580)
		end
		if at <= 101 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_e3f4()
end

--- Helper function.
local function helper_17120()
	vm.section(function()
		event.initialize_event()
		helper_e8dc()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_object_handle_frame_visible(4, "cube37", 0)
		event.set_object_handle_frame_visible(4, "cube38", 0)
		event.set_camera_sequence_position(48.97, 32.89, 40.91)
		event.set_camera_sequence_look_at(61.89, 18.47, -74.73)
		event.set_object_sequence_position(0, 90.21, 0.0, -36.12)
		event.set_object_sequence_rotation(0, 0.0, -2.18, 0.0)
		event.set_object_sequence_position(1, 98.27, 0.0, -52.72)
		event.set_object_sequence_rotation(1, 0.0, -1.61, 0.0)
		event.set_object_sequence_position(0, 90.21, 0.0, -36.12)
		event.set_object_sequence_rotation(0, 0.0, -2.18, 0.0)
		event.set_object_sequence_position(1, 98.27, 0.0, -52.72)
		event.set_object_sequence_rotation(1, 0.0, -1.61, 0.0)
		event.set_object_sequence_position(2, 29.51, 0.0, -37.25)
		event.set_object_sequence_rotation(2, 0.0, 2.32, 0.0)
		event.set_object_sequence_position(3, 21.3, 0.0, -61.73)
		event.set_object_sequence_rotation(3, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(4, 59.82, 0.0, -98.58)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "衝撃L", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "座り", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "座り", 4)
		event.set_object_sequence_motion(3, "座り", 4)
		event.set_object_sequence_motion(4, "座り会話2", 4)
		event.move_camera_sequence_eased(46.34, 32.89, 64.43, 61.89, 18.47, -74.73, 90, 2, 0.4)
		helper_4116e6bb(2090600)
		wait_camera()
		event.set_camera_sequence_position(82.72, 22.53, -61.3)
		event.set_camera_sequence_look_at(93.83, 21.33, -34.43)
		event.move_camera_sequence_eased(83.31, 22.53, -59.88, 92.29, 21.33, -38.16, 90, 2, 0.4)
		helper_4116e6bb(2090610)
		helper_4116e6bb(2090615)
		event.clear_camera_sequence()
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, global0, 256, 0)
	event.set_scene_status_flags(1, global1, 256, 0)
	helper_e3f4()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	helper_43cef388()
	flag = event.get_save_flag(247) or flag
	if flag == 1 then
		flag = event.get_save_flag(250) or flag
		if flag == 0 then
			helper_194b8()
			event.skip_next_music_load()
			event.jump_to_map_3(-1, "s47", 501)
			vm.wait(2)
			return
		end
	end
	event.set_character_position(0, 20.0, 19.5, 89.5)
	event.set_character_rotation(0, 0.0, 1.8, 0.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	print("-----event200--------------------------------------\n")
	flag = event.get_save_flag(250) or flag
	if flag == 0 then
		event.jump_to_map_3(-1, "g01", 100)
		vm.wait(1)
		return
	end
	vm.wait(2)
	event.go_to_outside_map(-1, "g01", 100)
	vm.wait(3)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: any = 0
	helper_afbdd04b(0)
	var0 = helper_f4d83329(0)
	helper_f2e47558()
	if var0 == 0 then
		event.go_to_interior_map(-1, "i01h01")
		vm.wait(2)
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_105ec()
	event.fade_out_screen(30)
	wait_frames(30)
	event.skip_next_music_play()
	event.jump_to_map_3(-1, "s46", 501)
	vm.wait(3)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_17120()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s02", 502)
	vm.wait(2)
end

--- Event 610, which map data, a script or the engine runs by number.
script.event_610 = helper_105ec

--- Event 611, which map data, a script or the engine runs by number.
script.event_611 = helper_17120

--- Event 620, which map data, a script or the engine runs by number.
function script.event_620()
	helper_194b8()
	event.fade_in_screen(30)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local player_chara: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	player_chara = event.get_player_character_slot() or player_chara
	do
		local out1, _, out3 = event.get_character_position(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.get_character_position(var0)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.get_look_angle(var5 - var2, var7 - var4) or var8
	helper_76f23193(player_chara, var8)
	event.set_character_rotation(player_chara, 0.0, var8, 0.0)
	event.set_character_motion(player_chara, "立ち")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Bonjouuuur.\nBeau temps, non ?")
	if var0 == 8 then
		event.open_message_window_2(
			0,
			"[UNI00c9]coutez. Veillez surtout [UNI00e0] ne pas\nvous trouver nez [UNI00e0] nez avec ce\nsatan[UNI00e9] Papillon arc-en-ciel OK ?<page>Et si [UNI00e7]a arrive, faites comme\nsi vous l'aviez pas vu, d'accord ?"
		)
		helper_0ffc2526(0, -1, var0, player_chara, 0)
		event.open_message_window_2(
			0,
			"Si vous l'apercevez juste du coin\nde l'[UNI0153]il, [UNI00e7]a devrait aller si\nvous faites mine de n'avoir rien<page>vu. Enfin, peut-[UNI00ea]tre..."
		)
	end
	if var0 == 9 then
		event.open_message_window_2(
			0,
			"Mmmhhh, je grignoterais bien une\ntarte aux pommes de Holly avec\nun verre de jus de raisin, [UNI00e7]a oui !"
		)
	end
	if var0 == 10 then
		event.open_message_window_2(
			0,
			"Holly nous a abandonn[UNI00e9]s et nos\nquatre amis ne sont pas rentr[UNI00e9]s.<page>Je ne supporterais pas de perdre\nqui que ce soit d'autre."
		)
	end
	helper_0ffc2526(0, -1, var0, player_chara, 0)
end

--- Event 12500, which map data, a script or the engine runs by number.
function script.event_12500()
	helper_194b8()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s47", 501)
	vm.wait(2)
end

return script
