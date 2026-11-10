--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0e75aa9e = require("@lib/event/helper_0e75aa9e")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_523109b8 = require("@lib/event/helper_523109b8")
local helper_705b02bc = require("@lib/event/helper_705b02bc")
local helper_917013c0 = require("@lib/event/helper_917013c0")
local helper_a518823a = require("@lib/event/helper_a518823a")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f616ba9e = require("@lib/event/helper_f616ba9e")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_7b442b70()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.set_time_of_day_advancing(0)
		event.set_time_of_day(24)
		event.set_event_projection(618.0)
		event.set_character_active(0, 0)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(102)
		event.load_map_sounds(1204)
		event.play_environment_music(3)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p1/op1ch4_1.txt")
		var0 = event.load_sound_effect_file_2(1204) or var0
		event.load_character(5, "event/opening/p1/p1_polcurse.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 2201.47, -17.0, 2087.45)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "立ち")
		event.start_background_file_loads_1("event/opening/p1/p1_pierrot.gltf")
		at = 2
		vm.wait(2)
		at = 3
		helper_479dc9e9()
		event.load_character(5, "event/opening/p1/p1_pierrot.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 2165.77, 0.0, 2124.68)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.load_character(5, "event/opening/p1/p1_pierrot.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 2239.05, 0.0, 2124.68)
		event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.load_character(5, "event/opening/p1/p1_pierrot.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 2137.24, 0.0, 2163.89)
		event.set_object_sequence_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.load_character(5, "event/opening/p1/p1_pierrot.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 2270.23, 0.0, 2168.7)
		event.set_object_sequence_rotation(4, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.start_background_file_loads_1("")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1240.09, 218.04, 1303.05)
		event.set_camera_sequence_look_at(1240.68, 300.58, 1344.23)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(200)
		at = 4
		wait_camera()
		at = 5
		wait_frames(30)
		event.start_crossfade(120)
		event.play_music(0, -1)
		event.set_camera_sequence_position(2199.29, 81.59, 2071.01)
		event.set_camera_sequence_look_at(2199.55, 105.83, 2098.65)
		event.move_camera_sequence(2199.29, 29.61, 2071.01, 2199.55, 28.79, 2098.65, 300)
		event.open_voice_stream_wave(1, 10240)
		at = 6
		var1 = helper_f616ba9e(1)
		at = 7
		wait_frames(vm.i32(294 - var1))
		event.play_object_sequence_sound(0, var0, 26)
		event.move_object_sequence(0, 2201.47, 0.0, 2087.45, 6)
		event.set_mouth_texture_animations(0, "口パク")
		event.play_voice_stream(1)
		event.open_message_window_2(0, 10240)
		open_message(0, -1, 8, 0, 0)
		at = 8
		helper_917013c0(0, 30)
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		event.close_voice_stream(1)
		event.reset_mouth_texture_animations()
		event.move_camera_sequence_eased(2198.18, 29.61, 1953.27, 2199.55, 28.79, 2098.65, 120, 2, 0.4)
		at = 9
		wait_frames(10)
		event.set_object_sequence_motion(0, "杖まわす", 2)
		event.queue_object_sequence_next_motion(0, "杖まわすL", 4)
		event.play_object_sequence_sound(0, var0, 27)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, var0, 27)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, var0, 27)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, var0, 27)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, var0, 27)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, var0, 27)
		event.set_mouth_texture_animations(0, "口パク")
		at = 10
		helper_0e75aa9e(10250, -1, 10)
		event.reset_mouth_texture_animations()
		at = 11
		wait_camera()
		at = 12
		wait_objects(0)
		event.set_object_sequence_motion(0, "回転", 6)
		event.queue_object_sequence_next_motion(0, "回転L", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var0, 28)
		event.set_mouth_texture_animations(0, "口パク")
		at = 13
		helper_0e75aa9e(10253, -1, 10)
		event.reset_mouth_texture_animations()
		at = 14
		wait_objects(0)
		event.set_object_sequence_motion(1, "回転", 6)
		event.queue_object_sequence_next_motion(1, "回転L", 4)
		event.set_object_sequence_motion(2, "回転", 6)
		event.queue_object_sequence_next_motion(2, "回転L", 4)
		event.set_object_sequence_motion(3, "回転", 6)
		event.queue_object_sequence_next_motion(3, "回転L", 4)
		event.set_object_sequence_motion(4, "回転", 6)
		event.queue_object_sequence_next_motion(4, "回転L", 4)
		event.delay_object_sequence_sound_track(1, 30)
		event.play_object_sequence_sound(1, var0, 29)
		event.delay_object_sequence_sound_track(1, 15)
		event.play_object_sequence_sound(1, var0, 30)
		event.set_mouth_texture_animations(0, "口パク")
		at = 15
		helper_0e75aa9e(10256, -1, 0)
		event.reset_mouth_texture_animations()
		at = 16
		wait_objects(1)
		event.set_object_sequence_motion(0, "決め", 6)
		event.queue_object_sequence_next_motion(0, "決めL", 4)
		event.delay_object_sequence_sound_track(0, 14)
		event.play_object_sequence_sound(0, var0, 31)
		event.set_object_sequence_motion(1, "決め", 6)
		event.queue_object_sequence_next_motion(1, "決めL", 4)
		event.set_object_sequence_motion(2, "決め", 6)
		event.queue_object_sequence_next_motion(2, "決めL", 4)
		event.set_object_sequence_motion(3, "決め", 6)
		event.queue_object_sequence_next_motion(3, "決めL", 4)
		event.set_object_sequence_motion(4, "決め", 6)
		event.queue_object_sequence_next_motion(4, "決めL", 4)
		event.set_mouth_texture_animations(0, "口パク")
		at = 17
		helper_0e75aa9e(10260, -1, 10)
		event.reset_mouth_texture_animations()
		at = 18
		wait_objects(0)
		event.set_object_sequence_motion(0, "杖まわす", 2)
		event.queue_object_sequence_next_motion(0, "杖まわすL", 4)
		event.delay_object_sequence_motion_track(0, 56)
		event.set_object_sequence_motion(0, "回転", 6)
		event.queue_object_sequence_next_motion(0, "回転L", 6)
		event.delay_object_sequence_motion_track(0, 16)
		event.set_object_sequence_motion(0, "決め", 2)
		event.queue_object_sequence_next_motion(0, "決めL", 4)
		at = 19
		helper_0e75aa9e(10270, -1, 10)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_handle_footstep_sound(3, -1)
		event.set_object_handle_footstep_sound(4, -1)
		event.move_object_sequence(1, 1819.42, 0.0, 1997.77, 120)
		event.move_object_sequence(1, 1819.42, -2000.0, 1997.77, 180)
		event.rotate_object_sequence(1, 0.0, -1.94, 0.0, 10)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(2, 2521.02, 0.0, 1952.71, 120)
		event.move_object_sequence(2, 2521.02, -2000.0, 1952.71, 180)
		event.rotate_object_sequence(2, 0.0, 2.06, 0.0, 10)
		event.set_object_sequence_motion(2, "走り")
		event.move_object_sequence(3, 1403.9, 0.0, 2435.27, 300)
		event.rotate_object_sequence(3, 0.0, -1.22, 0.0, 10)
		event.set_object_sequence_motion(3, "走り")
		event.move_object_sequence(4, 3065.93, 0.0, 2381.79, 300)
		event.rotate_object_sequence(4, 0.0, 1.34, 0.0, 10)
		event.set_object_sequence_motion(4, "走り")
		event.move_camera_sequence(2198.18, 81.59, 1953.27, 2199.55, 165.83, 2098.65, 300)
		at = 20
		wait_frames(240)
		event.fade_out_music(60)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(60)
		at = 21
		wait_camera()
	end, function(received: { any }): boolean
		if at == 6 then
			var1 = received[1] :: number
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_344d6cd8()
		end
		if at <= 4 then
			wait_frames_skipping(30)
		end
		if at <= 5 then
			var1 = helper_523109b8(1)
		end
		if at <= 6 then
			wait_frames_skipping(vm.i32(294 - var1))
		end
		if at <= 7 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_705b02bc(0, 30)
		end
		if at <= 8 then
			helper_d16eef1e(0)
			wait_frames_skipping(10)
		end
		if at <= 9 then
			helper_a518823a(10250, -1, 10)
		end
		if at <= 10 then
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_a518823a(10253, -1, 10)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_a518823a(10256, -1, 0)
		end
		if at <= 15 then
			helper_238b5abc(1)
		end
		if at <= 16 then
			helper_a518823a(10260, -1, 10)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_a518823a(10270, -1, 10)
		end
		if at <= 19 then
			wait_frames_skipping(240)
		end
		if at <= 20 then
			helper_344d6cd8()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.set_character_active(1, 0)
	event.stop_environment_music()
	event.stop_music(0)
end

return helper_7b442b70
