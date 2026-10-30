--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_0660a773()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		var0 = event.load_sound_effect_file_2(802) or var0
		event.set_scene_status_flags(1, 0, 256, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e00/e50/")
		event.load_message_file(0, 5, "e50_1.txt")
		event.load_character_motion_pack(5, "e50_monica.gltf", "info", 0)
		event.load_character_motion_pack(5, "e50_monica2.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e50_guiltoni.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_object_handle_to_character(2, 18)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e50_timegate_f.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.load_character(5, "e50_ou.gltf", "info", 13)
		event.set_character_active(1, 13)
		event.change_directory("")
		event.load_character(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(7, 9)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 7)
		event.load_equipment_model(5, 1, 0, "info", 0, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(1, 12)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_character(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.attach_object_handle_to_map_part_2(3, "p10_s5102-0")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_2(4, "p10_s5102-1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_position(0, -494.38, -0.17, 247.95)
		event.set_object_handle_rotation(0, 0.0, 2.01, 0.0)
		event.set_object_handle_motion(0, "走り", 4)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(2, 0.0, 0.0, -250.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_sound_bank(2, var0)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_rotation(3, 0.0, -0.2, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.2, 0.0)
		event.set_object_handle_position(7, 0.0, 30.0, -300.0)
		event.set_character_position(11, 0.0, 30.0, -300.0)
		event.set_character_position(13, 18.0, 0.0, -220.0)
		event.set_character_rotation(13, 0.0, -1.57, 0.0)
		event.set_character_motion(13, "倒れ", 4)
		event.enable_drama_skip()
		event.move_object_sequence(0, -368.53, -0.17, 185.7, 50)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-467.79, 15.29, 271.35)
		event.set_camera_sequence_look_at(-445.52, 25.45, 209.11)
		event.fade_in_screen(30)
		at = 2
		wait_objects(0)
		event.set_camera_sequence_position(-134.51, 100.78, 136.35)
		event.set_camera_sequence_look_at(-54.64, 52.81, 37.61)
		event.set_object_sequence_position(0, -117.35, -0.17, 66.54)
		event.move_object_sequence(0, -9.29, -0.17, 0.77, 30)
		event.delay_object_sequence_rotation_track(0, 22)
		event.rotate_object_sequence(0, 0.0, 0.12, 0.0, 8)
		event.delay_object_sequence_motion_track(0, 28)
		event.set_object_sequence_motion(0, "壁立ち")
		at = 3
		wait_frames(10)
		event.set_object_handle_footstep_sound(0, 2)
		at = 4
		wait_frames(12)
		event.play_sound_effect(var0, 14)
		at = 5
		wait_objects(0)
		at = 6
		wait_frames(10)
		event.set_object_sequence_motion(0, "像見る", 2)
		event.queue_object_sequence_next_motion(0, "像見るL", 4)
		at = 7
		wait_frames(40)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_camera_sequence_position(-95.58, 18.43, -157.01)
		event.set_camera_sequence_look_at(0.23, 35.57, -22.29)
		event.play_sound_effect(var0, 15)
		event.rotate_object_sequence(3, 0.0, -1.8, 0.0, 16)
		event.rotate_object_sequence_eased(3, 0.0, -1.7, 0.0, 20, 2, 1.0)
		event.rotate_object_sequence(4, 0.0, 1.8, 0.0, 16)
		event.rotate_object_sequence_eased(4, 0.0, 1.7, 0.0, 20, 2, 1.0)
		event.set_object_sequence_position(0, 0.0, -0.17, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "あたりドア開け", 6)
		event.queue_object_sequence_next_motion(0, "構え", 4)
		at = 8
		wait_frames(30)
		event.set_camera_sequence_position(-12.11, 17.82, -20.43)
		event.set_camera_sequence_look_at(1.71, 21.68, 0.96)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_motion(0, "ショック", 6)
		event.queue_object_sequence_next_motion(0, "ショックL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 9
		wait_frames(40)
		event.set_camera_sequence_position(0.0, 20.0, -80.0)
		event.set_camera_sequence_look_at(0.0, 20.0, -160.0)
		event.move_camera_sequence(0.0, 20.0, -120.0, 0.0, 20.0, -200.0, 120.0)
		at = 10
		wait_camera()
		event.start_crossfade(40)
		event.set_camera_sequence_position(0.0, 30.0, -210.0)
		event.set_camera_sequence_look_at(0.0, 30.0, -245.0)
		event.move_camera_sequence_angle_height_distance_eased(-1.2, 0.0, 35.0, 90, 0, 1.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ショック顔")
		event.set_object_sequence_texture_animation(0, 1, "ショック目パチ")
		event.set_object_sequence_motion(0, "立ちN", 4, -1.0, 1)
		event.play_sound_effect(var0, 17)
		event.set_object_sequence_motion(2, "振り返り", 6)
		event.queue_object_sequence_next_motion(2, "振り返りL", 4)
		at = 11
		wait_objects(2)
		event.open_voice_stream_wave(1, 500050)
		at = 12
		wait_frames(30)
		at = 13
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		at = 14
		wait_camera()
		event.set_camera_sequence_position(0.0, 30.0, -210.0)
		event.set_camera_sequence_look_at(0.0, 30.0, -290.0)
		event.move_camera_sequence_eased(0.0, 20.0, -160.0, 0.0, 20.0, -280.0, 120, 0, 0.4)
		event.play_sound_effect(var0, 18)
		event.set_object_sequence_motion(2, "振り返り戻り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		at = 15
		wait_objects(2)
		event.play_sound_effect(var0, 19)
		event.set_character_active(1, 11)
		event.set_character_motion(11, "発生", 6)
		at = 16
		wait_frames(10)
		event.set_character_active(1, 9)
		event.set_character_visible(9, 1, 1, 0.1)
		at = 17
		wait_frames(30)
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, 0.0, 0.0, -300.0, 60)
		at = 18
		wait_frames(30)
		event.set_character_visible(18, 0, 1, 0.033333335)
		at = 19
		wait_frames(30)
		event.set_character_visible(9, 0, 1, 0.05)
		var1 = 1.0
		var2 = vm.f32(0.01)
		var3 = vm.f32(-0.002)
		var4 = 0
		while var4 < 20 do
			var1 = vm.f32(var1 + var2)
			var2 = vm.f32(var2 + var3)
			event.set_character_scale(9, var1, var1, var1)
			var4 = var4 + 1
			at = 20
			vm.wait(20)
		end
		at = 21
		wait_frames(30)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(0.0, 23.0, -34.0)
		event.set_camera_sequence_look_at(0.0, 23.0, 0.0)
		event.move_camera_sequence_eased(0.0, 23.0, -24.0, 0.0, 23.0, 0.0, 60, 2, 1.0)
		at = 22
		wait_camera()
		at = 23
		wait_frames(20)
		event.set_camera_sequence_position(0.0, 23.0, -297.58)
		event.set_camera_sequence_look_at(0.0, 23.0, -273.58)
		event.play_sound_effect(var0, 20)
		event.detach_character_from_frame(12)
		event.set_object_sequence_position(1, 10.0, 8.0, 0.0)
		event.set_object_sequence_rotation(1, 0.4, 2.88, 0.0)
		event.move_object_sequence(1, 10.0, 1.0, 0.0, 10)
		event.rotate_object_sequence(1, 0.0, 2.88, 0.0, 8)
		event.rotate_object_sequence(1, 0.0, 2.88, 0.3, 6)
		event.rotate_object_sequence(1, 0.0, 2.88, -0.2, 4)
		event.rotate_object_sequence(1, 0.0, 2.88, 0.1, 3)
		event.rotate_object_sequence(1, 0.0, 2.88, -0.05, 2)
		event.rotate_object_sequence(1, 0.0, 2.88, 0.0, 2)
		at = 24
		wait_objects(1)
		at = 25
		wait_frames(40)
		event.set_object_sequence_motion(0, "ヨロあるき")
		event.set_object_sequence_motion_blend_step(0, 0.05)
		event.move_object_sequence(0, 0.0, -0.17, -80.0, 120)
		at = 26
		wait_frames(90)
		event.fade_out_screen(30)
		at = 27
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_238b5abc(0)
		end
		if at <= 2 then
			wait_frames_skipping(10)
		end
		if at <= 3 then
			wait_frames_skipping(12)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			wait_frames_skipping(10)
		end
		if at <= 6 then
			wait_frames_skipping(40)
		end
		if at <= 7 then
			wait_frames_skipping(30)
		end
		if at <= 8 then
			wait_frames_skipping(40)
		end
		if at <= 9 then
			helper_344d6cd8()
		end
		if at <= 10 then
			helper_238b5abc(2)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_344d6cd8()
		end
		if at <= 14 then
			helper_238b5abc(2)
		end
		if at <= 15 then
			wait_frames_skipping(10)
		end
		if at <= 16 then
			wait_frames_skipping(30)
		end
		if at <= 17 then
			wait_frames_skipping(30)
		end
		if at <= 18 then
			wait_frames_skipping(30)
		end
		if at <= 19 then
			var1 = 1.0
			var2 = vm.f32(0.01)
			var3 = vm.f32(-0.002)
			var4 = 0
			var1 = vm.f32(var1 + var2)
			var2 = vm.f32(var2 + var3)
			local _ = var4 < 20
			var4 = var4 + 1
		end
		if at <= 20 then
			wait_frames_skipping(30)
		end
		if at <= 21 then
			helper_344d6cd8()
		end
		if at <= 22 then
			wait_frames_skipping(20)
		end
		if at <= 23 then
			helper_238b5abc(1)
		end
		if at <= 24 then
			wait_frames_skipping(40)
		end
		if at <= 25 then
			wait_frames_skipping(90)
		end
		if at <= 26 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 28
	vm.entry(28)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, 1, "通常目パチ")
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_visible(5, 1)
	event.set_object_handle_visible(6, 1)
	event.stop_sound_effect(var0, 14)
	event.stop_sound_effect(var0, 15)
	event.stop_sound_effect(var0, 16)
	event.stop_sound_effect(var0, 17)
	event.stop_sound_effect(var0, 18)
	event.stop_sound_effect(var0, 19)
	event.stop_sound_effect(var0, 20)
	event.delete_character_extension_packs(0)
	event.delete_character(18)
	event.delete_character(9)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

return helper_0660a773
