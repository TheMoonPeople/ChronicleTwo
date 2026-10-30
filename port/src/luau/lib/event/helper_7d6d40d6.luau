--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_523109b8 = require("@lib/event/helper_523109b8")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_f616ba9e = require("@lib/event/helper_f616ba9e")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_7d6d40d6()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(420, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		event.load_map_sounds(4811)
		var0 = event.load_sound_effect_file_2(4811) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e420/")
		event.load_message_file(0, 5, "e420_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e420_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e420_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e420_paw.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e420_shigu.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "mariometto_a.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_character_to_frame(11, "metto_null", 12)
		event.attach_object_handle_to_character(6, 12)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "e420_kanden.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e420/e420_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e400/e420/e420_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_position(0, -50.18, 3.08, 671.54)
		event.set_object_handle_rotation(0, 0.0, -2.9, 0.0)
		event.set_object_handle_motion(0, "上向くL", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -96.49, 3.79, 674.91)
		event.set_object_handle_rotation(1, 0.0, 2.78, 0.0)
		event.set_object_handle_motion(1, "上向くL", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -72.89, 2.34, 770.75)
		event.set_object_handle_rotation(2, 0.0, -3.02, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_handle_position(3, -78.16, -9.08, 455.31)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "立ち2", 4)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "赤目パチ")
		event.set_character_position(13, -78.16, -9.08, 455.31)
		event.set_character_rotation(13, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.enable_drama_skip()
		event.set_camera_sequence_position(-91.15, 8.06, 663.16)
		event.set_camera_sequence_look_at(-79.05, 47.63, 524.91)
		event.set_object_sequence_motion(3, "感電", 6)
		event.queue_object_sequence_next_motion(3, "感電L", 4)
		event.fade_in_screen(30)
		event.set_message_button_prompt(0, 0)
		event.open_voice_stream_wave(1, 4200010)
		at = 2
		var2 = helper_f616ba9e(1)
		at = 3
		wait_frames(vm.i32(10 - var2))
		event.play_voice_stream(1)
		at = 4
		wait_frames(vm.i32(30 - var2))
		at = 5
		wait_objects(3)
		event.set_function_point_enabled("", "e420_lg", 1)
		event.play_sound_effect(var0, 4)
		event.set_character_active(1, 13)
		at = 6
		wait_frames(80)
		event.set_character_active(0, 13)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		event.set_function_point_enabled("", "e420_lg", 0)
		event.set_camera_sequence_position(-39.38, 84.75, 556.88)
		event.set_camera_sequence_look_at(-82.55, -1.03, 671.45)
		event.move_object_sequence(2, -72.44, 3.87, 634.26, 40, 1)
		event.set_object_sequence_motion(2, "上見走り", 4)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "上見立ち")
		at = 7
		helper_4116e6bb(4200020)
		at = 8
		wait_objects(2)
		event.set_camera_sequence_position(-81.13, -20.11, 556.35)
		event.set_camera_sequence_look_at(-83.71, 9.43, 543.03)
		event.stop_sound_effect(var0, 4)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "赤目～赤目とじ")
		event.set_object_sequence_motion(3, "メット落ちる", 6)
		event.queue_object_sequence_next_motion(3, "倒れる", 6)
		event.wait_object_sequence_motion_end(3)
		event.delay_object_sequence_sound_track(3, 60)
		event.play_object_sequence_sound(3, var0, 6)
		event.move_object_sequence_eased(6, -75.71, -140.18, 221.57, 30, 1, 1.0)
		event.rotate_object_sequence_eased(6, 0.0, 0.0, 1.8, 30, 0, 1.0)
		event.delay_object_sequence_sound_track(6, 50)
		event.play_object_sequence_sound(6, var0, 5)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		at = 9
		wait_frames(60)
		event.set_character_active(0, 12)
		at = 10
		wait_objects(3)
		event.set_camera_sequence_position(-266.34, 202.78, 745.86)
		event.set_camera_sequence_look_at(-86.65, 17.8, 537.9)
		event.set_camera_sequence_position(-77.85, 7.32, 623.69)
		event.set_camera_sequence_look_at(-79.23, 12.59, 599.39)
		event.shake_camera_sequence(0.0, 2.0, 0.0, 25)
		at = 11
		wait_frames(25)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "苦痛目とじ")
		event.set_object_sequence_motion(3, "ぐったり", 6)
		event.set_camera_sequence_position(-266.34, 202.78, 745.86)
		event.set_camera_sequence_look_at(-86.65, 17.8, 537.9)
		at = 12
		helper_4116e6bb(4200030)
		event.move_object_sequence(2, -49.93, 4.12, 578.82, 30, 1)
		event.rotate_object_sequence(2, 0.0, 2.78, 0.0, 10)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "立ち")
		at = 13
		helper_4116e6bb(4200040)
		at = 14
		wait_objects(2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-126.48, 23.27, 645.95)
		event.set_camera_sequence_look_at(-48.09, 21.64, 692.16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 15
		helper_4116e6bb(4200050)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 16
		helper_4116e6bb(4200060)
		event.move_object_sequence(0, -73.29, 4.2, 606.39, 40, 1)
		event.delay_object_sequence_rotation_track(0, 30)
		event.rotate_object_sequence(0, 0.0, 2.9, 0.0, 10)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		at = 17
		wait_frames(8)
		event.move_object_sequence(1, -89.41, 4.65, 588.63, 40, 1)
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, 2.18, 0.0, 10)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		at = 18
		wait_frames(30)
		event.set_camera_sequence_position(-23.86, 87.25, 654.66)
		event.set_camera_sequence_look_at(-59.69, 21.64, 584.77)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "半目パチ")
		at = 19
		wait_objects(1)
		at = 20
		helper_4116e6bb(4200070)
		at = 21
		helper_4116e6bb(4200080)
		at = 22
		helper_4116e6bb(4200090)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 23
		helper_4116e6bb(4200100)
		event.fade_out_screen(30)
		at = 24
		wait_frames(30)
	end, function(received: { any }): boolean
		if at == 2 then
			var2 = received[1] :: number
		end
		if at <= 1 then
			var2 = helper_523109b8(1)
		end
		if at <= 2 then
			wait_frames_skipping(vm.i32(10 - var2))
		end
		if at <= 3 then
			wait_frames_skipping(vm.i32(30 - var2))
		end
		if at <= 4 then
			helper_238b5abc(3)
		end
		if at <= 5 then
			wait_frames_skipping(80)
		end
		if at <= 6 then
			helper_8cd371d7(4200020)
		end
		if at <= 7 then
			helper_238b5abc(2)
		end
		if at <= 8 then
			wait_frames_skipping(60)
		end
		if at <= 9 then
			helper_238b5abc(3)
		end
		if at <= 10 then
			wait_frames_skipping(25)
		end
		if at <= 11 then
			helper_8cd371d7(4200030)
		end
		if at <= 12 then
			helper_8cd371d7(4200040)
		end
		if at <= 13 then
			helper_238b5abc(2)
		end
		if at <= 14 then
			helper_8cd371d7(4200050)
		end
		if at <= 15 then
			helper_8cd371d7(4200060)
		end
		if at <= 16 then
			wait_frames_skipping(8)
		end
		if at <= 17 then
			wait_frames_skipping(30)
		end
		if at <= 18 then
			helper_238b5abc(1)
		end
		if at <= 19 then
			helper_8cd371d7(4200070)
		end
		if at <= 20 then
			helper_8cd371d7(4200080)
		end
		if at <= 21 then
			helper_8cd371d7(4200090)
		end
		if at <= 22 then
			helper_8cd371d7(4200100)
		end
		if at <= 23 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 25
	vm.entry(25)
	event.cancel_drama_scene_skip()
	event.set_function_point_enabled("", "e420_lg", 0)
	event.stop_sound_effect(var0, 4)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
	event.finish_event()
end

return helper_7d6d40d6
