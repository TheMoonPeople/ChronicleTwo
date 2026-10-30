--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_48d33e71 = require("@lib/event/helper_48d33e71")
local helper_705b02bc = require("@lib/event/helper_705b02bc")
local helper_917013c0 = require("@lib/event/helper_917013c0")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_d743ebd8 = require("@lib/event/helper_d743ebd8")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_7edc335b()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_time_of_day(24.0)
		event.set_event_projection(618.0)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_map_sounds(1219)
		event.play_environment_music(0)
		event.load_music(107)
		event.enable_drama_skip()
		var0 = event.load_sound_effect_file_2(1219) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/opening/p5/")
		event.load_message_file(0, 5, "op5_1.txt")
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 2198.2, 0.0, 2227.47)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.load_character(5, "p5_pierrot.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.set_object_handle_footstep_sound(1, 2)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 2195.08, 0.0, 2575.62)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.copy_character(5, 9, 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_footstep_sound(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 2229.28, 0.0, 2598.0)
		event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
		event.copy_character(5, 9, 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_footstep_sound(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 2173.22, 0.0, 2657.79)
		event.set_object_sequence_rotation(3, 0.0, 3.14, 0.0)
		event.load_character(5, "p5_halloween.gltf", "p00_10a", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.set_object_handle_sound_bank(4, var0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 2200.0, 0.0, 3021.4)
		event.set_object_sequence_rotation(4, 0.0, 3.14, 0.0)
		event.load_character(5, "p5_polcurse.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_frame_visible(5, "sashi", 0)
		event.set_object_handle_frame_visible(5, "cube61_8", 1)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.attach_character_to_frame(12, "polcurse", 13)
		event.set_object_sequence_texture_animation(5, 0, "口パク")
		event.change_directory("")
		event.attach_object_handle_to_character_frame(6, 12, "cube39")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.rotate_object_sequence(6, 0.0, -0.02, 0.0, -1)
		at = 2
		helper_d743ebd8(50005)
		event.open_message_window_2(0, 50005)
		event.set_message_button_prompt(0, 0)
		open_message(0, -1, 8, 0, 0)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_object_sequence(0, 2198.2, 0.0, 1839.29, 90)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(1, 2195.08, 0.0, 1839.62, 140)
		event.set_object_sequence_motion(2, "走り", 4, 0.9)
		event.set_object_sequence_motion_time(2, 4.5)
		event.move_object_sequence(2, 2229.28, 0.0, 1839.62, 150)
		event.set_object_sequence_motion(3, "走り", 4, 0.9)
		event.set_object_sequence_motion_time(3, 9.9)
		event.move_object_sequence(3, 2173.22, 0.0, 1839.62, 160)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1834.01, 105.83, 2170.98)
		event.set_camera_sequence_look_at(2138.28, 60.96, 2221.1)
		event.move_camera_sequence(1833.59, 105.83, 2170.07, 2114.57, 60.96, 2042.3, 90)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		at = 3
		wait_camera()
		at = 4
		wait_objects(0)
		at = 5
		wait_objects(1)
		at = 6
		wait_frames(4)
		event.play_music(0, -1)
		at = 7
		wait_objects(2)
		at = 8
		wait_objects(3)
		at = 9
		wait_frames(20)
		event.set_character_active(0, 0)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		close_message(0)
		event.set_message_button_prompt(0, 1)
		event.start_crossfade(30)
		event.set_camera_sequence_position(2200.0, 13.0, 1761.66)
		event.set_camera_sequence_look_at(2200.0, 250.08, 3021.4)
		event.move_camera_sequence(2200.0, 13.0, 1811.66, 2200.0, 250.08, 3021.4, 120)
		at = 10
		wait_frames(94)
		event.close_voice_stream(1)
		event.play_object_sequence_sound(4, var0, 9)
		at = 11
		wait_camera()
		event.jump_object_sequence(4, 2200.0, 0.0, 2100.0, -1.2, 60)
		event.set_object_sequence_motion(4, "ジャンプ上昇", 6)
		event.queue_object_sequence_next_motion(4, "ジャンプ下降")
		event.set_object_sequence_motion_blend_step(4, 0.08)
		event.delay_object_sequence_motion_track(4, 30)
		event.set_object_sequence_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "立ち")
		event.move_camera_sequence(2200.0, 13.0, 1811.66, 2200.0, 539.39, 2576.05, 30)
		at = 12
		wait_camera()
		event.set_camera_sequence_position(1736.02, 386.45, 2011.23)
		for var1_i = 0, 29 do
			do
				local out1, out2, out3 = event.get_character_position(12)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			event.set_camera_sequence_look_at(var2, var3 + 20.0, var4)
			at = 13
			vm.wait(13)
		end
		event.shake_camera_sequence(0.0, 6.0, 0.0, 25)
		at = 14
		wait_frames(30)
		event.set_camera_sequence_position(2201.44, 61.26, 1712.51)
		event.set_camera_sequence_look_at(2201.87, 89.26, 2115.81)
		event.set_object_sequence_motion(4, "きょろきょろカメラ目線", 6)
		event.queue_object_sequence_next_motion(4, "ポル持ち立ち", 4)
		event.play_object_sequence_sound(4, var0, 10)
		event.delay_object_sequence_sound_track(4, 20)
		event.play_object_sequence_sound(4, var0, 10)
		event.delay_object_sequence_sound_track(4, 22)
		event.play_object_sequence_sound(4, var0, 10)
		event.open_voice_stream_wave(1, 50010)
		at = 15
		helper_9cbdc640(1)
		at = 16
		wait_objects(4)
		at = 17
		wait_frames(30)
		event.set_camera_sequence_position(2189.74, 124.48, 1971.11)
		event.set_camera_sequence_look_at(2182.94, 127.74, 2019.16)
		event.set_object_sequence_texture_animation(5, 1, "にやり口")
		event.set_object_sequence_motion(5, "帽子直し", 6)
		event.queue_object_sequence_next_motion(5, "帽子直しL", 4)
		event.delay_object_sequence_texture_animation_track(5, 40)
		event.set_object_sequence_texture_animation(5, 0, "目パチ")
		event.set_object_sequence_texture_animation(5, 1, "怒り目（目パチ）")
		at = 18
		wait_frames(6)
		event.set_mouth_texture_animations(5, "口パク", "にやり口")
		event.open_message_window_2(0, 50010)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		event.set_object_handle_texture_animation(5, 0, "にやり口")
		event.set_object_handle_texture_animation(5, 1, "口パク")
		at = 19
		wait_frames(30)
		event.set_object_handle_texture_animation(5, 0, "口パク")
		at = 20
		wait_frames(10)
		event.set_object_handle_frame_visible(5, "sashi", 1)
		event.set_object_handle_frame_visible(5, "cube61_8", 0)
		at = 21
		helper_917013c0(0, -1)
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		at = 22
		wait_objects(5)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(1903.57, 177.35, 2408.27)
		event.set_camera_sequence_look_at(2208.66, 112.3, 1994.07)
		at = 23
		wait_frames(10)
		event.set_object_sequence_motion(4, "歩き")
		event.set_object_sequence_motion(5, "立ち", 4)
		event.move_object_sequence(4, 2200.0, 0.0, 1500.0, 60)
		at = 24
		wait_objects(4)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		at = 25
		wait_camera()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_48d33e71(50005)
		end
		if at <= 2 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			wait_frames_skipping(4)
		end
		if at <= 6 then
			helper_238b5abc(2)
		end
		if at <= 7 then
			helper_238b5abc(3)
		end
		if at <= 8 then
			wait_frames_skipping(20)
		end
		if at <= 9 then
			helper_d16eef1e(0)
			wait_frames_skipping(94)
		end
		if at <= 10 then
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_344d6cd8()
		end
		if at <= 12 then
			var1 = 0
		end
		if at <= 13 then
			local _ = var1 < 30
			var1 = var1 + 1
			wait_frames_skipping(30)
		end
		if at <= 14 then
			helper_238b5abc(1)
		end
		if at <= 15 then
			helper_238b5abc(4)
		end
		if at <= 16 then
			wait_frames_skipping(30)
		end
		if at <= 17 then
			wait_frames_skipping(6)
		end
		if at <= 18 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			wait_frames_skipping(30)
		end
		if at <= 19 then
			wait_frames_skipping(10)
		end
		if at <= 20 then
			helper_705b02bc(0, -1)
		end
		if at <= 21 then
			helper_d16eef1e(0)
			helper_238b5abc(5)
		end
		if at <= 22 then
			wait_frames_skipping(10)
		end
		if at <= 23 then
			helper_238b5abc(4)
		end
		if at <= 24 then
			helper_344d6cd8()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.close_voice_stream(1)
	event.play_music(0, -1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.clear_object_sequence(6)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
end

return helper_7edc335b
