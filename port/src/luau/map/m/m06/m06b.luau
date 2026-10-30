--!strict
-- map/m/m06/m06b.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_48d33e71 = require("@lib/event/helper_48d33e71")
local helper_523109b8 = require("@lib/event/helper_523109b8")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_61e5dba6 = require("@lib/event/helper_61e5dba6")
local helper_7334e9f5 = require("@lib/event/helper_7334e9f5")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8d25bb56 = require("@lib/event/helper_8d25bb56")
local helper_972d1084 = require("@lib/event/helper_972d1084")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_d743ebd8 = require("@lib/event/helper_d743ebd8")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f616ba9e = require("@lib/event/helper_f616ba9e")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_d01c()
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
		helper_888ab2a3(4)
		event.load_music(102)
		event.load_map_sounds(1204)
		event.play_environment_music(3)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p1/op1ch4.txt")
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
		helper_888ab2a3(30)
		event.start_crossfade(120)
		event.play_music(0, -1)
		event.set_camera_sequence_position(2199.29, 81.59, 2071.01)
		event.set_camera_sequence_look_at(2199.55, 105.83, 2098.65)
		event.move_camera_sequence(2199.29, 29.61, 2071.01, 2199.55, 28.79, 2098.65, 300)
		event.open_voice_stream_wave(1, 10240)
		at = 6
		var1 = helper_f616ba9e(1)
		at = 7
		helper_888ab2a3(vm.i32(294 - var1))
		event.play_object_sequence_sound(0, var0, 26)
		event.move_object_sequence(0, 2201.47, 0.0, 2087.45, 6)
		event.set_mouth_texture_animations(0, "口パク")
		event.play_voice_stream(1)
		event.open_message_window_2(0, 10240)
		open_message(0, -1, 8, 0, 0)
		at = 8
		helper_61e5dba6(0, 30)
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		event.close_voice_stream(1)
		event.reset_mouth_texture_animations()
		event.move_camera_sequence_eased(2198.18, 29.61, 1953.27, 2199.55, 28.79, 2098.65, 120, 2, 0.4)
		at = 9
		helper_888ab2a3(10)
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
		helper_0382f327(10250, 300)
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
		helper_0382f327(10253, 50)
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
		helper_0382f327(10256, 90)
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
		helper_0382f327(10260, 60)
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
		helper_0382f327(10270, 100)
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
		helper_888ab2a3(240)
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
			helper_038a2e4d(30)
		end
		if at <= 5 then
			var1 = helper_523109b8(1)
		end
		if at <= 6 then
			helper_038a2e4d(vm.i32(294 - var1))
		end
		if at <= 7 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_972d1084(0, 30)
		end
		if at <= 8 then
			helper_d16eef1e(0)
			helper_038a2e4d(10)
		end
		if at <= 9 then
			helper_53ffe901(10250, 300)
		end
		if at <= 10 then
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_53ffe901(10253, 50)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_53ffe901(10256, 90)
		end
		if at <= 15 then
			helper_238b5abc(1)
		end
		if at <= 16 then
			helper_53ffe901(10260, 60)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_53ffe901(10270, 100)
		end
		if at <= 19 then
			helper_038a2e4d(240)
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

--- Helper function.
local function helper_fa78()
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_time_of_day_advancing(0)
		event.set_time_of_day(24)
		event.set_event_projection(618.0)
		event.load_map_sounds(1207)
		event.set_character_active(8)
		event.set_character_position(8, 2260.0, 0.0, 2233.0)
		event.set_character_rotation(8, 0.0, 3.14, 0.0)
		event.set_character_motion(8, "立ち")
		event.attach_object_handle_to_character(0, 8)
		event.set_object_handle_frame_visible(0, "R_yaiba", 0)
		event.set_object_handle_frame_visible(0, "obj11", 0)
		event.set_object_handle_frame_visible(0, "L_yaiba", 0)
		event.set_object_handle_frame_visible(0, "obj4", 0)
		event.set_character_active(0, 9)
		event.set_character_position(9, 1522.37, 4.0, 2978.08)
		event.set_character_rotation(9, 0.0, 1.94, 0.0)
		event.set_character_active(0, 10)
		event.set_character_position(10, 2108.0, 0.0, 3231.65)
		event.set_character_rotation(10, 0.0, 3.14, 0.0)
		event.set_character_active(0, 11)
		event.set_character_position(11, 2713.25, 4.0, 2224.2)
		event.set_character_rotation(11, 0.0, -0.34, 0.0)
		event.set_character_active(12)
		event.set_character_position(12, 2575.78, 4.0, 2107.88)
		event.set_character_rotation(12, 0.0, -0.34, 0.0)
		event.set_character_motion(12, "ゆれて飛ぶ", 5)
		event.set_character_active(13)
		event.attach_object_handle_to_character(1, 13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 2356.99, 0.0, 2165.63)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "歩き")
		event.set_character_active(14)
		event.attach_object_handle_to_character(2, 14)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 2133.14, 0.0, 1632.04)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "歩き")
		event.set_character_active(15)
		event.attach_object_handle_to_character(3, 15)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 2258.71, 0.0, 1849.84)
		event.set_object_sequence_rotation(3, 0.0, -1.1, 0.0)
		event.set_object_sequence_motion(3, "立ち")
		event.set_character_active(16)
		event.attach_object_handle_to_character(4, 16)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 2148.07, 0.0, 1632.04)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "歩き")
		event.set_character_active(17)
		event.attach_object_handle_to_character(5, 17)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 2215.91, 0.0, 1567.22)
		event.set_object_sequence_rotation(5, 0.0, 1.34, 0.0)
		event.set_object_sequence_motion(5, "会話")
		event.set_character_active(18)
		event.attach_object_handle_to_character(6, 18)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, 2224.72, 0.0, 1598.72)
		event.set_object_sequence_rotation(6, 0.0, 2.66, 0.0)
		event.set_object_sequence_motion(6, "会話")
		event.enable_drama_skip()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 2181.14, 0.0, 1491.45)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "立ち")
		event.set_marker(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2202.0, 271.0, 1419.0)
		event.set_camera_sequence_look_at(2202.0, 271.0, 1806.0)
		event.move_camera_sequence(2202.0, 52.0, 1419.0, 2202.0, 52.0, 1806.0, 300)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(120)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 400)
		event.add_object_sequence_path_point(1, 2356.99, 0.0, 2165.63)
		event.add_object_sequence_path_point(1, 2324.21, 0.0, 2166.75)
		event.add_object_sequence_path_point(1, 2294.14, 0.0, 2152.14)
		event.add_object_sequence_path_point(1, 2273.08, 0.0, 2088.6)
		event.add_object_sequence_path_point(1, 2260.07, 0.0, 2028.27)
		event.add_object_sequence_path_point(1, 2253.46, 0.0, 1967.56)
		event.add_object_sequence_path_point(1, 2247.69, 0.0, 1917.81)
		event.start_object_sequence_path(1)
		event.move_object_sequence(2, 2133.14, 0.0, 1832.04, 400)
		event.move_object_sequence(4, 2148.07, 0.0, 1832.04, 400)
		helper_888ab2a3(240)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 160)
		event.add_object_sequence_path_point(0, 2181.14, 0.0, 1491.45)
		event.add_object_sequence_path_point(0, 2190.49, 0.0, 1560.16)
		event.add_object_sequence_path_point(0, 2199.03, 0.0, 1630.16)
		event.add_object_sequence_path_point(0, 2200.51, 0.0, 1690.16)
		event.add_object_sequence_path_point(0, 2200.51, 0.0, 1762.16)
		event.add_object_sequence_path_point(0, 2200.51, 0.0, 1862.16)
		event.add_object_sequence_path_point(0, 2200.51, 0.0, 2062.16)
		event.start_object_sequence_path(0)
		event.set_object_sequence_motion(0, "走り")
		helper_888ab2a3(130)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		wait_camera()
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, -1)
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.clear_object_sequence(2)
	event.clear_object_sequence(3)
	event.clear_object_sequence(4)
	event.clear_object_sequence(5)
	event.clear_object_sequence(6)
	event.clear_object_sequence(7)
	event.clear_object_sequence(8)
	event.clear_object_sequence(9)
	event.clear_object_sequence(10)
	event.clear_object_sequence(11)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_character_active(11)
	event.set_character_motion(0, "立ち", 4)
	helper_8d25bb56()
	event.set_character_position(0, 2200.51, 0.0, 2062.16)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_active(0)
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.set_camera_position(2200.87, 39.52, 1932.16)
	event.set_camera_look_at(2200.51, 30.0, 2062.16)
	event.reset_follow_camera(0)
	event.finish_event()
	event.load_map_sounds(1208)
	event.fade_in_screen(10)
end

--- Helper function.
local function helper_11838()
	local var0: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		event.set_character_motion(0, "立ち")
		wait_camera()
		event.load_map_sounds(1209)
		var0 = event.load_sound_effect_file_2(1209) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p1/op1_5.txt")
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 2260.0, 0.0, 2233.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "立ち")
		event.load_character_motion_pack(5, "event/opening/p1/p1_5_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(1, 0)
		event.set_object_handle_footstep_sound(1, 2)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 2260.0, 0.0, 2160.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "旧・立ち")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "目パチ")
		event.set_object_sequence_texture_animation(1, 1, "うれし口")
		event.load_character(5, "event/opening/p1/p1_5_ticket.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.attach_object_handle_to_character(2, 20)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 2260.0, 0.0, 2204.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "チケットを渡す", 5)
		event.load_character(5, "event/opening/p1/p1_5_boy.gltf", "info", 21)
		event.set_character_active(0, 21)
		event.attach_object_handle_to_character(3, 21)
		event.set_object_handle_sound_bank(3, var0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 2342.84, 0.0, 2225.88)
		event.set_object_sequence_rotation(3, 0.0, 1.57, 0.0)
		event.set_object_sequence_motion(3, "ひったくり走り", 4)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.move_object_sequence(1, 2260.0, 0.0, 2204.0, 40)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2316.32, 55.34, 2082.86)
		event.set_camera_sequence_look_at(2255.09, 19.29, 2223.48)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		wait_camera()
		wait_objects(1)
		event.set_camera_sequence_position(2335.02, 32.15, 2225.77)
		event.set_camera_sequence_look_at(2254.69, 19.29, 2220.02)
		event.set_object_sequence_motion(1, "旧・立ち")
		helper_888ab2a3(10)
		event.set_object_sequence_motion(1, "チケットを渡す", 6)
		event.queue_object_sequence_next_motion(1, "チケットを渡すL", 4)
		event.set_character_active(20)
		event.set_object_sequence_motion(2, "チケットを渡す", 6)
		event.queue_object_sequence_next_motion(2, "チケットを渡すL", 4)
		event.play_object_sequence_sound(0, var0, 4)
		helper_888ab2a3(20)
		event.set_mouth_texture_animations(1, "通常口パク", "うれし口")
		helper_0382f327(10300, 20)
		event.reset_mouth_texture_animations()
		wait_objects(1)
		event.set_object_sequence_motion(0, "もぎり", 6)
		event.queue_object_sequence_next_motion(0, "もぎりL", 4)
		event.set_character_active(21)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 160)
		event.add_object_sequence_path_point(3, 2342.84, 0.0, 2225.88)
		event.add_object_sequence_path_point(3, 2265.2, 0.0, 2220.33)
		event.add_object_sequence_path_point(3, 2145.86, 0.0, 2211.81)
		event.add_object_sequence_path_point(3, 2114.11, 0.0, 2211.45)
		event.add_object_sequence_path_point(3, 2009.12, 0.0, 2222.65)
		event.add_object_sequence_path_point(3, 1912.97, 0.0, 2256.82)
		event.add_object_sequence_path_point(3, 1821.43, 0.0, 2302.92)
		event.add_object_sequence_path_point(3, 1716.38, 0.0, 2374.01)
		event.add_object_sequence_path_point(3, 1661.85, 0.0, 2462.44)
		event.start_object_sequence_path(3)
		helper_888ab2a3(15)
		event.set_character_active(0, 20)
		event.set_object_sequence_motion(1, "チケットを取られる", 6)
		event.queue_object_sequence_next_motion(1, "チケットを取られるL", 4)
		event.play_object_sequence_sound(0, var0, 5)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "目パチ")
		event.set_object_sequence_motion(0, "少年を見る", 6)
		event.queue_object_sequence_next_motion(0, "少年を見るL", 4)
		vm.wait(9)
		event.set_mouth_texture_animations(1, "通常口パク", "口パク大")
		helper_0382f327(10310, 20)
		event.reset_mouth_texture_animations()
		wait_objects(1)
		event.set_mouth_texture_animations(1, "通常口パク", "口パク大")
		helper_0382f327(10320, 50)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(2237.85, 16.17, 2229.34)
		event.set_camera_sequence_look_at(2261.06, 22.16, 2203.21)
		event.set_character_active(0, 21)
		event.set_object_sequence_rotation(1, 0.0, -1.2, 0.0)
		event.set_object_sequence_motion(1, "立ち2", 6, -1.0, 1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "真剣目")
		event.set_object_sequence_texture_animation(1, 1, "口パク小")
		helper_888ab2a3(20)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, 2230.82, 0.0, 2208.96, 10)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "真剣目")
		event.set_object_sequence_texture_animation(1, 1, "怒り口")
		wait_objects(1)
		event.set_camera_sequence_position(1699.32, 73.27, 2202.85)
		event.set_camera_sequence_look_at(1973.4, 44.98, 2268.33)
		event.move_camera_sequence(1699.32, 73.27, 2202.85, 1862.18, 11.38, 2316.42, 100)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 100)
		event.add_object_sequence_path_point(1, 2146.75, 0.0, 2208.56)
		event.add_object_sequence_path_point(1, 2052.61, 0.0, 2224.84)
		event.add_object_sequence_path_point(1, 1947.63, 0.0, 2244.64)
		event.add_object_sequence_path_point(1, 1840.32, 0.0, 2274.25)
		event.add_object_sequence_path_point(1, 1724.36, 0.0, 2317.09)
		event.start_object_sequence_path(1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "真剣目")
		event.set_object_sequence_texture_animation(1, 1, "怒り口")
		wait_objects(1)
		event.set_camera_sequence_position(1834.95, 35.66, 2229.37)
		event.set_camera_sequence_look_at(1697.59, 7.87, 2411.67)
		event.set_object_sequence_position(1, 1798.09, 0.0, 2277.17)
		event.set_object_sequence_rotation(1, 0.0, -0.67, 0.0)
		event.reset_object_sequence_motion(1)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(1, 1699.68, 0.0, 2409.28, 40)
		event.delay_object_sequence_motion_track(1, 38)
		event.set_object_sequence_motion(1, "旧・立ち", 0)
		wait_objects(1)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(1671.69, 14.08, 2425.85)
		event.set_camera_sequence_look_at(1699.11, 20.51, 2408.48)
		event.set_object_sequence_motion(1, "キョロキョロ立ち", 2)
		event.queue_object_sequence_next_motion(1, "立ち2", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "困った目")
		vm.wait(18)
		event.set_mouth_texture_animations(1, "通常口パク", "怒り口")
		helper_0382f327(10330, 180)
		event.reset_mouth_texture_animations()
		wait_objects(1)
		event.set_object_sequence_motion(1, "ため息", 2)
		event.queue_object_sequence_next_motion(1, "立ち2", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "閉じる目（半目）")
		event.set_object_sequence_texture_animation(1, 1, "ため息")
		helper_0382f327(10340, 60)
		wait_objects(1)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		wait_camera()
	end)
	event.cancel_drama_scene_skip()
	event.close_voice_stream(1)
	event.set_object_handle_footstep_sound(1, -1)
	event.delete_character_extension_packs(0)
	event.delete_character(20)
	event.delete_character(21)
	event.set_character_position(0, 1699.68, 0.0, 2409.28)
	event.set_character_rotation(0, 0.0, -0.67, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_motion(8, "立ち", 4)
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.clear_object_sequence(2)
	event.clear_object_sequence(3)
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.set_camera_position(1780.41, 40.0, 2307.38)
	event.set_camera_look_at(1699.68, 30.0, 2409.28)
	event.reset_follow_camera(0)
	event.finish_event()
	event.load_map_sounds(1210)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(10)
	wait_camera()
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, 9000030)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
	event.set_message_draw_speed(0, 0)
	event.load_message_file(0, -1)
end

--- Helper function.
local function helper_1432c()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_map_sounds(1211)
		var1 = event.load_sound_effect_file_2(1211) or var1
		event.load_message_file(0, 5, "event/opening/p1/op1_5.txt")
		event.attach_object_handle_to_character(0, 11)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.delete_character_extension_packs(0)
		event.load_character_motion_pack(5, "event/opening/p1/p1_5_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(4, 0)
		event.set_object_handle_footstep_sound(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 2698.72, 4.0, 2252.22)
		event.set_object_sequence_rotation(4, 0.0, 2.76, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.load_character(5, "event/opening/p1/p1_5_boy.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.attach_object_handle_to_character(5, 20)
		event.set_object_handle_sound_bank(5, var1)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 2565.75, 4.0, 2081.64)
		event.set_object_sequence_rotation(5, 0.0, -0.36, 0.0)
		event.set_object_sequence_motion(5, "立ち")
		event.set_object_sequence_texture_animation(5, 0)
		event.load_character(5, "event/opening/p1/p1_5_ticket.gltf", "info", 21)
		event.set_character_active(0, 21)
		event.attach_object_handle_to_character(6, 21)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, 2732.64, 0.0, 2456.06)
		event.set_object_sequence_rotation(6, 0.0, -3.1, 0.0)
		event.attach_object_handle_to_character(7, 12)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_handle_frame_visible(7, "himonet", 1)
		event.set_object_handle_frame_visible(7, "f2--A01C0S1", 1)
		event.load_character(5, "event/opening/p1/p1_5_kirakira.gltf", "info", 22)
		event.set_character_active(0, 22)
		event.attach_object_handle_to_character(8, 22)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_object_sequence_position(8, 2199.6, -10000.0, 2617.93)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(8, "キラキラ", 5)
		event.set_camera_sequence_position(2737.66, 29.82, 2342.9)
		event.set_camera_sequence_look_at(2670.87, 30.6, 2198.83)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		at = 2
		wait_camera()
		event.set_object_sequence_motion(4, "会話", 2)
		event.queue_object_sequence_next_motion(4, "旧・立ち")
		at = 3
		helper_0382f327(10420, 90)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 4
		helper_888ab2a3(10)
		at = 5
		helper_0382f327(10430, 60)
		at = 6
		helper_0382f327(10440, 40)
		event.set_object_sequence_motion(7, "ゆれて飛ぶ", 6)
		event.wait_object_sequence_motion_end(7)
		event.play_object_sequence_sound(7, var1, 6)
		at = 7
		helper_888ab2a3(20)
		event.set_object_sequence_motion(4, "左を見る", 6)
		event.queue_object_sequence_next_motion(4, "左を見るL", 4)
		at = 8
		wait_objects(4)
		at = 9
		helper_888ab2a3(10)
		event.set_camera_sequence_position(2681.3, 19.18, 2231.06)
		event.set_camera_sequence_look_at(2697.39, 26.81, 2253.46)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "真剣目")
		event.set_object_sequence_texture_animation(4, 1, "口パク小")
		at = 10
		helper_0382f327(10450, 30)
		event.set_object_handle_frame_visible(7, "himonet", 0)
		event.set_object_handle_frame_visible(7, "f2--A01C0S1", 0)
		event.set_camera_sequence_position(2687.25, 43.11, 2323.13)
		event.set_camera_sequence_look_at(2666.93, 22.05, 2225.82)
		event.set_object_sequence_motion(4, "旧・立ち", 4)
		at = 11
		vm.wait(11)
		event.open_voice_stream_wave(1, 10453)
		at = 12
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.set_object_sequence_motion(4, "走り")
		event.delay_object_sequence_position_track(4, 4)
		event.move_object_sequence(4, 2654.2, 4.0, 2208.09, 20)
		event.rotate_object_sequence(4, 0.0, -2.32, 0.0, 10)
		at = 13
		wait_objects(4)
		event.set_camera_sequence_position(2536.27, 35.1, 2224.26)
		event.set_camera_sequence_look_at(2573.27, 24.36, 2106.49)
		event.set_object_sequence_position(4, 2592.3, 4.0, 2180.9)
		event.move_object_sequence(4, 2561.21, 4.0, 2137.12, 20)
		event.delay_object_sequence_rotation_track(4, 14)
		event.rotate_object_sequence(4, 0.0, 2.76, 0.0, 6)
		at = 14
		wait_objects(4)
		event.set_object_sequence_motion(4, "旧・立ち")
		event.delay_object_sequence_motion_track(4, 4)
		event.set_object_sequence_motion(4, "キョロキョロ立ち", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		at = 15
		helper_888ab2a3(10)
		event.close_voice_stream(1)
		event.set_character_active(20)
		event.set_object_sequence_motion(5, "のぞく", 6)
		event.queue_object_sequence_next_motion(5, "のぞくL", 4)
		event.play_object_sequence_sound(5, var1, 7)
		at = 16
		wait_objects(4)
		at = 17
		wait_objects(5)
		event.open_voice_stream_wave(1, 10457)
		at = 18
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.set_object_sequence_motion(4, "かがみ歩き", 2)
		event.wait_object_sequence_motion_end(4)
		event.set_object_sequence_motion(5, "ひっこむ", 2)
		event.wait_object_sequence_motion_end(5)
		event.play_object_sequence_sound(5, var1, 8)
		at = 19
		wait_objects(5)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(2419.08, 78.17, 2101.42)
		event.set_camera_sequence_look_at(2563.13, 24.36, 2105.26)
		event.rotate_object_sequence(5, 0.0, 1.2, 0.0, 20)
		event.move_object_sequence(5, 2592.35, 4.0, 2089.42, 132)
		event.set_object_sequence_motion(5, "隠れ移動", 4)
		event.open_voice_stream_wave(1, 10458)
		at = 20
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		at = 21
		wait_objects(4)
		at = 22
		wait_objects(5)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(2507.18, 51.78, 2103.29)
		event.set_camera_sequence_look_at(2570.79, 20.66, 2091.49)
		event.set_object_sequence_position(4, 2542.51, 4.0, 2091.34)
		event.set_object_sequence_rotation(4, 0.0, 1.68, 0.0)
		event.set_object_sequence_motion(4, "指差す", 6)
		event.queue_object_sequence_next_motion(4, "指差すL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "真剣目")
		event.set_object_sequence_motion(5, "びっくり", 6)
		event.queue_object_sequence_next_motion(5, "びっくりL", 4)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "びっくり")
		event.play_object_sequence_sound(5, var1, 9)
		at = 23
		vm.wait(23)
		event.set_mouth_texture_animations(4, "通常口パク", "怒り口")
		at = 24
		helper_0382f327(10460, 30)
		event.reset_mouth_texture_animations()
		at = 25
		wait_objects(4)
		at = 26
		wait_objects(5)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_motion(4, "走り")
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 30)
		event.add_object_sequence_path_point(4, 2542.51, 4.0, 2091.34)
		event.add_object_sequence_path_point(4, 2552.74, 4.0, 2082.34)
		event.add_object_sequence_path_point(4, 2568.64, 4.0, 2077.28)
		event.add_object_sequence_path_point(4, 2585.94, 4.0, 2080.83)
		event.add_object_sequence_path_point(4, 2604.01, 4.0, 2092.89)
		event.start_object_sequence_path(4)
		event.set_object_sequence_motion(5, "走り")
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 30)
		event.add_object_sequence_path_point(5, 2592.35, 4.0, 2089.42)
		event.add_object_sequence_path_point(5, 2604.06, 4.0, 2096.07)
		event.add_object_sequence_path_point(5, 2622.54, 4.0, 2108.53)
		event.add_object_sequence_path_point(5, 2625.01, 4.0, 2129.26)
		event.add_object_sequence_path_point(5, 2618.08, 4.0, 2166.48)
		event.start_object_sequence_path(5)
		at = 27
		wait_objects(4)
		at = 28
		wait_objects(5)
		event.set_camera_sequence_position(2732.49, 83.6, 2321.91)
		event.set_camera_sequence_look_at(2590.66, 25.91, 2100.32)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 30)
		event.add_object_sequence_path_point(4, 2604.01, 4.0, 2092.89)
		event.add_object_sequence_path_point(4, 2615.74, 4.0, 2103.53)
		event.add_object_sequence_path_point(4, 2626.24, 4.0, 2132.0)
		event.add_object_sequence_path_point(4, 2632.92, 4.0, 2161.62)
		event.add_object_sequence_path_point(4, 2638.67, 4.0, 2195.37)
		event.add_object_sequence_path_point(4, 2646.65, 4.0, 2219.67)
		event.start_object_sequence_path(4)
		event.set_object_sequence_position(5, 2635.12, 4.0, 2186.57)
		event.set_object_sequence_rotation(5, 0.0, 0.36, 0.0)
		event.move_object_sequence(5, 2670.06, 0.0, 2284.25, 30)
		event.open_voice_stream_wave(1, 10467)
		at = 29
		var0 = helper_f616ba9e(1)
		at = 30
		helper_888ab2a3(vm.i32(16 - var0))
		event.play_voice_stream(1)
		at = 31
		wait_objects(4)
		at = 32
		wait_objects(5)
		event.set_camera_sequence_position(2714.93, 21.09, 2355.09)
		event.set_camera_sequence_look_at(2657.01, 19.42, 2296.64)
		event.move_camera_sequence(2769.08, 21.09, 2473.49, 2711.16, 19.42, 2415.04, 40)
		event.set_object_sequence_position(4, 2651.53, 0.0, 2235.87)
		event.move_object_sequence(4, 2737.55, 0.0, 2429.95, 40)
		event.reset_object_sequence_motion(4)
		event.set_object_sequence_motion(4, "走り", 4)
		event.set_object_sequence_position(5, 2690.44, 0.0, 2333.07)
		event.move_object_sequence(5, 2746.37, 0.0, 2453.89, 40)
		event.reset_object_sequence_motion(5)
		event.set_object_sequence_motion(5, "走り", 4)
		at = 33
		helper_888ab2a3(40)
		event.set_camera_sequence_position(2771.11, 13.16, 2406.61)
		event.set_camera_sequence_look_at(2657.95, 16.41, 2307.49)
		event.move_camera_sequence(2771.11, 13.16, 2406.61, 2719.85, 16.41, 2408.57, 30)
		event.set_camera_sequence_position(2704.73, 13.16, 2468.9)
		event.set_camera_sequence_look_at(2719.85, 16.41, 2408.57)
		event.move_camera_sequence(2704.73, 13.16, 2468.9, 2728.51, 7.46, 2434.51, 15)
		event.set_object_sequence_position(4, 2656.59, 0.0, 2298.73)
		event.set_object_sequence_rotation(4, 0.0, 0.5, 0.0)
		event.set_object_sequence_motion(4, "つかまえる", 6)
		event.queue_object_sequence_next_motion(4, "つかまえるL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "怒り目")
		event.play_object_sequence_sound(4, var1, 10)
		event.set_object_sequence_position(5, 2656.59, 0.0, 2298.73)
		event.set_object_sequence_rotation(5, 0.0, 0.5, 0.0)
		event.set_object_sequence_motion(5, "つかまえる", 6)
		event.queue_object_sequence_next_motion(5, "つかまえるL", 4)
		at = 34
		wait_objects(4)
		at = 35
		wait_objects(5)
		event.close_voice_stream(1)
		at = 36
		vm.wait(36)
		event.set_mouth_texture_animations(4, "通常口パク", "捕まえた！！")
		at = 37
		helper_0382f327(10470, 40)
		event.reset_mouth_texture_animations()
		at = 38
		wait_camera()
		event.open_voice_stream_wave(1, 10475)
		at = 39
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.set_object_sequence_motion(4, "自由にする", 6)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "怒り目")
		event.set_object_sequence_texture_animation(4, 1, "怒り口")
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "口小")
		at = 40
		helper_888ab2a3(12)
		event.set_camera_sequence_position(2722.6, 24.07, 2468.94)
		event.set_camera_sequence_look_at(2723.04, 20.49, 2423.97)
		event.set_object_sequence_position(4, 2730.11, 0.0, 2439.37)
		event.set_object_sequence_rotation(4, 0.0, -2.38, 0.0)
		event.set_object_sequence_motion(4, "立ち上がる", 6)
		event.queue_object_sequence_next_motion(4, "立ち2")
		event.set_object_sequence_position(5, 2713.88, 0.0, 2419.11)
		event.set_object_sequence_rotation(5, 0.0, 0.66, 0.0)
		event.set_object_sequence_motion(5, "立ち上がる", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.set_object_sequence_texture_animation(5, 0)
		at = 41
		wait_objects(4)
		at = 42
		wait_objects(5)
		event.close_voice_stream(1)
		event.set_object_sequence_motion(4, "チケット返して", 2)
		event.queue_object_sequence_next_motion(4, "チケット返してL", 4)
		event.delay_object_sequence_texture_animation_track(4, 14)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		event.set_mouth_texture_animations(4, "通常口パク", "怒り口")
		at = 43
		helper_0382f327(10480, 60)
		event.reset_mouth_texture_animations()
		at = 44
		wait_objects(4)
		event.set_camera_sequence_position(2667.51, 26.85, 2432.26)
		event.set_camera_sequence_look_at(2719.84, 16.79, 2426.86)
		event.set_object_sequence_position(5, 2730.11, 0.0, 2439.37)
		event.set_object_sequence_rotation(5, 0.0, -2.38, 0.0)
		event.set_object_sequence_position(6, 2730.11, 0.0, 2439.37)
		event.set_object_sequence_rotation(6, 0.0, -2.38, 0.0)
		event.set_object_sequence_motion(5, "チケット返す", 6)
		event.queue_object_sequence_next_motion(5, "チケット返すL", 4)
		event.play_object_sequence_sound(5, var1, 11)
		event.set_character_active(21)
		event.set_object_sequence_motion(6, "チケット返す", 6)
		event.queue_object_sequence_next_motion(6, "チケット返すL", 4)
		event.set_mouth_texture_animations(5, "口パク")
		at = 45
		helper_0382f327(10490, 164)
		event.reset_mouth_texture_animations()
		at = 46
		wait_objects(5)
		at = 47
		wait_objects(6)
		event.set_object_sequence_motion(4, "チケット受け取る", 6)
		event.queue_object_sequence_next_motion(4, "チケット受け取るL", 4)
		event.set_object_sequence_motion(6, "チケット受け取る", 6)
		event.queue_object_sequence_next_motion(6, "チケット受け取るL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト目（瞬有）")
		event.set_object_sequence_motion(5, "チケット返す戻り", 6)
		event.queue_object_sequence_next_motion(5, "下見立ち", 4)
		at = 48
		vm.wait(48)
		event.set_mouth_texture_animations(4, "通常口パク", "すまし口")
		at = 49
		helper_0382f327(10500, 60)
		event.reset_mouth_texture_animations()
		at = 50
		wait_objects(4)
		at = 51
		wait_objects(5)
		at = 52
		wait_objects(6)
		event.set_object_sequence_motion(5, "うなづく", 6)
		event.queue_object_sequence_next_motion(5, "下見立ち", 4)
		at = 53
		wait_objects(5)
		event.open_voice_stream_wave(1, 10510)
		at = 54
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		at = 55
		helper_888ab2a3(30)
		event.close_voice_stream(1)
		event.set_object_sequence_motion(5, "あやまる", 6)
		event.queue_object_sequence_next_motion(5, "下見立ち", 4)
		event.set_mouth_texture_animations(5, "口パク")
		at = 56
		helper_0382f327(10520, 120)
		event.reset_mouth_texture_animations()
		at = 57
		wait_objects(5)
		event.set_object_sequence_motion(4, "なやむ", 6)
		event.queue_object_sequence_next_motion(4, "なやむL", 4)
		event.set_object_sequence_motion(6, "なやむ", 6)
		event.queue_object_sequence_next_motion(6, "なやむL", 4)
		at = 58
		wait_objects(4)
		event.delay_object_sequence_motion_track(6, 80)
		event.set_object_sequence_motion(6, "チケットあげる", 6)
		event.queue_object_sequence_next_motion(6, "チケットあげるL", 4)
		event.delay_object_sequence_motion_track(4, 80)
		event.set_object_sequence_motion(4, "チケットあげる", 6)
		event.queue_object_sequence_next_motion(4, "チケットあげるL", 4)
		event.delay_object_sequence_texture_animation_track(4, 80)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		event.delay_object_sequence_sound_track(4, 80)
		event.play_object_sequence_sound(4, var1, 12)
		at = 59
		vm.wait(59)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 60
		helper_0382f327(10530, 140)
		event.reset_mouth_texture_animations()
		at = 61
		wait_objects(4)
		event.set_camera_sequence_position(2733.02, 29.86, 2442.53)
		event.set_camera_sequence_look_at(2711.0, 18.68, 2417.08)
		event.set_character_active(0, 0)
		event.set_object_sequence_motion(5, "ミンツを見る", 6)
		event.queue_object_sequence_next_motion(5, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(5, "口パク")
		at = 62
		helper_0382f327(10540, 30)
		event.reset_mouth_texture_animations()
		at = 63
		wait_objects(5)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 64
		helper_0382f327(10550, 40)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "チケットもらう", 6)
		event.queue_object_sequence_next_motion(5, "チケットもらうL", 4)
		event.set_object_sequence_texture_animation(5, 0)
		event.delay_object_sequence_sound_track(5, 10)
		event.play_object_sequence_sound(5, var1, 13)
		at = 65
		vm.wait(65)
		event.set_mouth_texture_animations(5, "口パク", "口小")
		at = 66
		helper_0382f327(10560, 30)
		event.reset_mouth_texture_animations()
		at = 67
		wait_objects(5)
		at = 68
		helper_0382f327(10570, 120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "ありがとう", 6)
		event.queue_object_sequence_next_motion(5, "ありがとうL", 4)
		event.set_object_sequence_motion(6, "ありがとう", 6)
		event.queue_object_sequence_next_motion(6, "ありがとうL", 4)
		event.set_object_sequence_texture_animation(5, 0)
		at = 69
		vm.wait(69)
		event.set_mouth_texture_animations(5, "笑い口パク", "笑い閉じ")
		at = 70
		helper_0382f327(10580, 70)
		event.reset_mouth_texture_animations()
		at = 71
		wait_objects(5)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_camera_sequence_position(2667.51, 26.85, 2432.26)
		event.set_camera_sequence_look_at(2719.84, 16.79, 2426.86)
		event.set_character_active(0)
		event.set_object_sequence_motion(4, "少年見立ち", 4, -1, 1)
		event.set_character_active(0, 21)
		event.set_object_sequence_position(5, 2714.52, 0.0, 2418.25)
		event.set_object_sequence_rotation(5, 0.0, 0.66, 0.0)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 72
		helper_0382f327(10590, 80)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "うなづく2", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.set_mouth_texture_animations(5, "口パク", "笑み")
		at = 73
		helper_0382f327(10600, 56)
		event.reset_mouth_texture_animations()
		at = 74
		wait_objects(5)
		event.set_object_sequence_motion(5, "走り")
		event.rotate_object_sequence(5, 0.0, -2.86, 0.0, 10)
		event.move_object_sequence(5, 2707.03, 0.0, 2390.53, 20)
		event.move_object_sequence(5, 2707.03, -1000.0, 2390.53, 80)
		event.set_object_sequence_motion(4, "見送る", 6)
		event.queue_object_sequence_next_motion(4, "見送るL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		at = 75
		helper_888ab2a3(20)
		event.move_camera_sequence_eased(2697.7, 21.72, 2425.94, 2730.54, 21.26, 2439.46, 60, 0, 0.2)
		at = 76
		wait_camera()
		at = 77
		wait_objects(4)
		event.set_object_sequence_motion(4, "ため息", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "閉じる目（半目）２")
		event.set_object_sequence_texture_animation(4, 1, "ため息２")
		at = 78
		helper_888ab2a3(20)
		at = 79
		helper_0382f327(10610, 60)
		at = 80
		wait_objects(4)
		at = 81
		wait_objects(5)
		event.set_object_sequence_motion(5, "立ち")
		at = 82
		helper_888ab2a3(30)
		event.set_object_sequence_motion(4, "はっとする", 2)
		event.queue_object_sequence_next_motion(4, "はっとするL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		event.set_object_sequence_texture_animation(4, 1, "口パク小")
		at = 83
		wait_objects(4)
		event.set_camera_sequence_position(2761.08, 44.84, 2484.29)
		event.set_camera_sequence_look_at(2714.37, 23.72, 2415.71)
		event.set_object_sequence_motion(5, "歩き", 4)
		event.set_object_sequence_position(5, 2642.36, 0.0, 2314.3)
		event.set_object_sequence_rotation(5, 0.0, -2.5, 0.0)
		event.move_object_sequence(5, 2626.57, 0.0, 2291.63, 30)
		event.delay_object_sequence_rotation_track(5, 20)
		event.rotate_object_sequence(5, 0.0, 0.66, 0.0, 16)
		at = 84
		wait_objects(5)
		event.set_object_sequence_motion(5, "立ち")
		at = 85
		helper_888ab2a3(60)
		event.set_camera_sequence_follow_object(4, 0.0, 15.0, 0.0, 0.56, 14.87, 54.88, "ground", 1)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		event.set_object_sequence_texture_animation(4, 1, "口パク大")
		at = 86
		helper_0382f327(10625, 60)
		event.fade_out_music(10)
		event.stop_environment_music()
		event.start_crossfade(10)
		at = 87
		vm.wait(87)
		event.set_object_sequence_position(4, 2200.16, -10000.0, 2784.02)
		event.set_object_sequence_rotation(4, 0.0, -3.1, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_map_lighting(8)
		at = 88
		vm.wait(88)
		at = 89
		helper_888ab2a3(10)
		event.stop_music(0)
		at = 90
		helper_888ab2a3(4)
		event.load_music(104)
		event.play_music(0, -1)
		at = 91
		helper_888ab2a3(22)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(2220.92, -9977.47, 2767.01)
		event.set_camera_sequence_look_at(2201.97, -9985.02, 2636.05)
		event.set_object_sequence_position(5, 2199.6, -10000.0, 2617.93)
		event.set_object_sequence_rotation(5, 0.0, 0.06, 0.0)
		event.set_camera_sequence_position(2199.79, -9989.26, 2736.2)
		event.set_camera_sequence_look_at(2200.22, -9977.21, 2785.19)
		event.set_object_sequence_motion(4, "不思議キョロキョロ", 6)
		event.queue_object_sequence_next_motion(4, "立ち2")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		at = 92
		vm.wait(92)
		event.set_mouth_texture_animations(4, "通常口パク", "怒り口")
		at = 93
		helper_0382f327(10630, 70)
		event.reset_mouth_texture_animations()
		at = 94
		wait_objects(4)
		event.set_camera_sequence_position(2220.92, -9977.47, 2767.01)
		event.set_camera_sequence_look_at(2201.97, -9985.02, 2636.05)
		event.set_mouth_texture_animations(5, "口パク")
		at = 95
		helper_0382f327(10640, 180)
		at = 96
		helper_0382f327(10650, 180)
		event.reset_mouth_texture_animations()
		event.set_character_active(22)
		event.set_object_sequence_motion(8, "キラキラ", 6)
		event.wait_object_sequence_motion_end(8)
		event.play_object_sequence_sound(8, var1, 14)
		event.start_crossfade(30)
		at = 97
		vm.wait(97)
		event.set_character_active(0, 20)
		at = 98
		wait_objects(8)
		at = 99
		helper_888ab2a3(30)
		event.set_camera_sequence_follow_object(4, 0.0, 15.0, 0.0, 0.56, 14.87, 54.88, "ground", 1)
		event.set_object_sequence_motion(4, "ちょっと待ってポーズ", 6)
		event.queue_object_sequence_next_motion(4, "ちょっと待ってポーズL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		event.set_object_sequence_texture_animation(4, 1, "怒り口")
		event.delay_object_sequence_texture_animation_track(4, 20)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト（瞬有）２")
		event.set_object_sequence_texture_animation(4, 1, "口パク小")
		at = 100
		helper_0382f327(10660, 30)
		at = 101
		wait_objects(4)
		event.fade_out_music(30)
		event.set_map_lighting(5)
		event.start_crossfade(30)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(2676.93, 29.87, 2425.83)
		event.set_camera_sequence_look_at(2730.11, 15.0, 2439.37)
		event.set_object_sequence_position(4, 2730.11, 0.0, 2439.37)
		event.set_object_sequence_rotation(4, 0.0, -2.38, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_object_sequence_motion(4, "ちょっと待ってポーズ戻り", 6)
		event.queue_object_sequence_next_motion(4, "不思議キョロキョロ", 6)
		event.queue_object_sequence_next_motion(4, "立ち2", 2)
		event.delay_object_sequence_texture_animation_track(4, 20)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "左→中→右")
		event.set_object_sequence_texture_animation(4, 1, "怒り口")
		at = 102
		wait_objects(4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト目（瞬有）")
		at = 103
		helper_888ab2a3(15)
		event.set_object_sequence_motion(4, "はっとする", 2)
		event.queue_object_sequence_next_motion(4, "はっとするL", 4)
		event.set_object_sequence_texture_animation(4, 1, "開閉口")
		at = 104
		wait_objects(4)
		at = 105
		helper_888ab2a3(30)
		event.stop_music(0)
		event.set_object_sequence_motion(4, "歩き2")
		event.move_object_sequence_eased(4, 2643.5, 0.0, 2316.9, 110, 1, 0.1)
		event.rotate_object_sequence(4, 0.0, -2.5, 0.0, 20)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		event.set_object_sequence_texture_animation(4, 1, "口パク小")
		at = 106
		helper_888ab2a3(30)
		event.set_character_active(1, 21)
		event.set_object_sequence_position(6, 2626.57, 0.0, 2291.63)
		event.set_object_sequence_rotation(6, 0.0, 0.66, 0.0)
		event.set_object_sequence_motion(6, "チケットを拾う", 5)
		event.set_camera_sequence_position(2832.0, 103.46, 2584.07)
		event.set_camera_sequence_look_at(2683.35, 17.47, 2369.67)
		at = 107
		wait_objects(4)
		event.set_camera_sequence_position(2587.9, 10.29, 2286.73)
		event.set_camera_sequence_look_at(2643.19, 14.66, 2311.47)
		event.set_object_sequence_motion(4, "チケットを拾う", 6)
		event.queue_object_sequence_next_motion(4, "チケットを拾うL", 6)
		event.queue_object_sequence_next_motion(4, "顔を上げる", 6)
		event.queue_object_sequence_next_motion(4, "顔を上げるL", 4)
		event.delay_object_sequence_texture_animation_track(4, 144)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト目（瞬有）")
		event.set_object_sequence_position(6, 2643.5, 0.0, 2316.9)
		event.set_object_sequence_rotation(6, 0.0, -2.5, 0.0)
		event.set_object_sequence_motion(6, "チケットを拾う", 6)
		event.queue_object_sequence_next_motion(6, "チケットを拾うL", 6)
		event.queue_object_sequence_next_motion(6, "顔を上げる", 6)
		event.queue_object_sequence_next_motion(6, "顔を上げるL", 4)
		at = 108
		wait_objects(4)
		at = 109
		helper_888ab2a3(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		at = 110
		wait_camera()
	end, function(received: { any }): boolean
		if at == 29 then
			var0 = received[1] :: number
		end
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			helper_53ffe901(10420, 90)
		end
		if at <= 3 then
			helper_038a2e4d(10)
		end
		if at <= 4 then
			helper_53ffe901(10430, 60)
		end
		if at <= 5 then
			helper_53ffe901(10440, 40)
		end
		if at <= 6 then
			helper_038a2e4d(20)
		end
		if at <= 7 then
			helper_238b5abc(4)
		end
		if at <= 8 then
			helper_038a2e4d(10)
		end
		if at <= 9 then
			helper_53ffe901(10450, 30)
		end
		if at <= 11 then
			helper_238b5abc(1)
		end
		if at <= 12 then
			helper_238b5abc(4)
		end
		if at <= 13 then
			helper_238b5abc(4)
		end
		if at <= 14 then
			helper_038a2e4d(10)
		end
		if at <= 15 then
			helper_238b5abc(4)
		end
		if at <= 16 then
			helper_238b5abc(5)
		end
		if at <= 17 then
			helper_238b5abc(1)
		end
		if at <= 18 then
			helper_238b5abc(5)
		end
		if at <= 19 then
			helper_238b5abc(1)
		end
		if at <= 20 then
			helper_238b5abc(4)
		end
		if at <= 21 then
			helper_238b5abc(5)
		end
		if at <= 23 then
			helper_53ffe901(10460, 30)
		end
		if at <= 24 then
			helper_238b5abc(4)
		end
		if at <= 25 then
			helper_238b5abc(5)
		end
		if at <= 26 then
			helper_238b5abc(4)
		end
		if at <= 27 then
			helper_238b5abc(5)
		end
		if at <= 28 then
			var0 = helper_523109b8(1)
		end
		if at <= 29 then
			helper_038a2e4d(vm.i32(16 - var0))
		end
		if at <= 30 then
			helper_238b5abc(4)
		end
		if at <= 31 then
			helper_238b5abc(5)
		end
		if at <= 32 then
			helper_038a2e4d(40)
		end
		if at <= 33 then
			helper_238b5abc(4)
		end
		if at <= 34 then
			helper_238b5abc(5)
		end
		if at <= 36 then
			helper_53ffe901(10470, 40)
		end
		if at <= 37 then
			helper_344d6cd8()
		end
		if at <= 38 then
			helper_238b5abc(1)
		end
		if at <= 39 then
			helper_038a2e4d(12)
		end
		if at <= 40 then
			helper_238b5abc(4)
		end
		if at <= 41 then
			helper_238b5abc(5)
		end
		if at <= 42 then
			helper_53ffe901(10480, 60)
		end
		if at <= 43 then
			helper_238b5abc(4)
		end
		if at <= 44 then
			helper_53ffe901(10490, 164)
		end
		if at <= 45 then
			helper_238b5abc(5)
		end
		if at <= 46 then
			helper_238b5abc(6)
		end
		if at <= 48 then
			helper_53ffe901(10500, 60)
		end
		if at <= 49 then
			helper_238b5abc(4)
		end
		if at <= 50 then
			helper_238b5abc(5)
		end
		if at <= 51 then
			helper_238b5abc(6)
		end
		if at <= 52 then
			helper_238b5abc(5)
		end
		if at <= 53 then
			helper_238b5abc(1)
		end
		if at <= 54 then
			helper_038a2e4d(30)
		end
		if at <= 55 then
			helper_53ffe901(10520, 120)
		end
		if at <= 56 then
			helper_238b5abc(5)
		end
		if at <= 57 then
			helper_238b5abc(4)
		end
		if at <= 59 then
			helper_53ffe901(10530, 140)
		end
		if at <= 60 then
			helper_238b5abc(4)
		end
		if at <= 61 then
			helper_53ffe901(10540, 30)
		end
		if at <= 62 then
			helper_238b5abc(5)
		end
		if at <= 63 then
			helper_53ffe901(10550, 40)
		end
		if at <= 65 then
			helper_53ffe901(10560, 30)
		end
		if at <= 66 then
			helper_238b5abc(5)
		end
		if at <= 67 then
			helper_53ffe901(10570, 120)
		end
		if at <= 69 then
			helper_53ffe901(10580, 70)
		end
		if at <= 70 then
			helper_238b5abc(5)
		end
		if at <= 71 then
			helper_53ffe901(10590, 80)
		end
		if at <= 72 then
			helper_53ffe901(10600, 56)
		end
		if at <= 73 then
			helper_238b5abc(5)
		end
		if at <= 74 then
			helper_038a2e4d(20)
		end
		if at <= 75 then
			helper_344d6cd8()
		end
		if at <= 76 then
			helper_238b5abc(4)
		end
		if at <= 77 then
			helper_038a2e4d(20)
		end
		if at <= 78 then
			helper_53ffe901(10610, 60)
		end
		if at <= 79 then
			helper_238b5abc(4)
		end
		if at <= 80 then
			helper_238b5abc(5)
		end
		if at <= 81 then
			helper_038a2e4d(30)
		end
		if at <= 82 then
			helper_238b5abc(4)
		end
		if at <= 83 then
			helper_238b5abc(5)
		end
		if at <= 84 then
			helper_038a2e4d(60)
		end
		if at <= 85 then
			helper_53ffe901(10625, 60)
		end
		if at <= 88 then
			helper_038a2e4d(10)
		end
		if at <= 89 then
			helper_038a2e4d(4)
		end
		if at <= 90 then
			helper_038a2e4d(22)
		end
		if at <= 92 then
			helper_53ffe901(10630, 70)
		end
		if at <= 93 then
			helper_238b5abc(4)
		end
		if at <= 94 then
			helper_53ffe901(10640, 180)
		end
		if at <= 95 then
			helper_53ffe901(10650, 180)
		end
		if at <= 97 then
			helper_238b5abc(8)
		end
		if at <= 98 then
			helper_038a2e4d(30)
		end
		if at <= 99 then
			helper_53ffe901(10660, 30)
		end
		if at <= 100 then
			helper_238b5abc(4)
		end
		if at <= 101 then
			helper_238b5abc(4)
		end
		if at <= 102 then
			helper_038a2e4d(15)
		end
		if at <= 103 then
			helper_238b5abc(4)
		end
		if at <= 104 then
			helper_038a2e4d(30)
		end
		if at <= 105 then
			helper_038a2e4d(30)
		end
		if at <= 106 then
			helper_238b5abc(4)
		end
		if at <= 107 then
			helper_238b5abc(4)
		end
		if at <= 108 then
			helper_038a2e4d(30)
		end
		if at <= 109 then
			helper_344d6cd8()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var1, 10)
	event.stop_sound_effect(var1, 14)
	event.close_voice_stream(1)
	event.set_object_handle_frame_visible(7, "himonet", 0)
	event.set_object_handle_frame_visible(7, "f2--A01C0S1", 0)
	event.set_map_lighting(5)
	event.set_object_handle_footstep_sound(4, -1)
	event.delete_character_extension_packs(0)
	event.delete_character(20)
	event.delete_character(21)
	event.delete_character(22)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, 2643.5, 0.0, 2316.9)
	event.set_character_rotation(0, 0.0, -2.5, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.stop_music(0)
	at = 111
	helper_888ab2a3(6)
	event.load_music(102)
	event.play_music(0, -1)
	event.load_map_sounds(1212)
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.set_camera_position(2721.3, 40.0, 2421.05)
	event.set_camera_look_at(2643.5, 30.0, 2316.9)
	event.reset_follow_camera(0)
	event.finish_event()
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(10)
	at = 112
	wait_camera()
end

--- Helper function.
local function helper_1c538()
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
		helper_888ab2a3(4)
		event.load_map_sounds(1219)
		event.play_environment_music(0)
		event.load_music(107)
		event.enable_drama_skip()
		var0 = event.load_sound_effect_file_2(1219) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/opening/p5/")
		event.load_message_file(0, 5, "op5.txt")
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
		helper_888ab2a3(4)
		event.play_music(0, -1)
		at = 7
		wait_objects(2)
		at = 8
		wait_objects(3)
		at = 9
		helper_888ab2a3(20)
		event.set_character_active(0, 0)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.start_crossfade(30)
		event.set_camera_sequence_position(2200.0, 13.0, 1761.66)
		event.set_camera_sequence_look_at(2200.0, 250.08, 3021.4)
		event.move_camera_sequence(2200.0, 13.0, 1811.66, 2200.0, 250.08, 3021.4, 120)
		at = 10
		helper_888ab2a3(94)
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
		helper_888ab2a3(30)
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
		helper_888ab2a3(30)
		event.set_camera_sequence_position(2189.74, 124.48, 1971.11)
		event.set_camera_sequence_look_at(2182.94, 127.74, 2019.16)
		event.set_object_sequence_texture_animation(5, 1, "にやり口")
		event.set_object_sequence_motion(5, "帽子直し", 6)
		event.queue_object_sequence_next_motion(5, "帽子直しL", 4)
		event.delay_object_sequence_texture_animation_track(5, 40)
		event.set_object_sequence_texture_animation(5, 0, "目パチ")
		event.set_object_sequence_texture_animation(5, 1, "怒り目（目パチ）")
		at = 18
		helper_888ab2a3(6)
		event.set_mouth_texture_animations(5, "口パク", "にやり口")
		event.open_message_window_2(0, 50010)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		event.set_object_handle_texture_animation(5, 0, "にやり口")
		event.set_object_handle_texture_animation(5, 1, "口パク")
		at = 19
		helper_888ab2a3(30)
		event.set_object_handle_texture_animation(5, 0, "口パク")
		at = 20
		helper_888ab2a3(10)
		event.set_object_handle_frame_visible(5, "sashi", 1)
		event.set_object_handle_frame_visible(5, "cube61_8", 0)
		at = 21
		helper_61e5dba6(0, -1)
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		at = 22
		wait_objects(5)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(1903.57, 177.35, 2408.27)
		event.set_camera_sequence_look_at(2208.66, 112.3, 1994.07)
		at = 23
		helper_888ab2a3(10)
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
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			helper_038a2e4d(4)
		end
		if at <= 6 then
			helper_238b5abc(2)
		end
		if at <= 7 then
			helper_238b5abc(3)
		end
		if at <= 8 then
			helper_038a2e4d(20)
		end
		if at <= 9 then
			helper_038a2e4d(94)
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
			helper_038a2e4d(30)
		end
		if at <= 14 then
			helper_238b5abc(1)
		end
		if at <= 15 then
			helper_238b5abc(4)
		end
		if at <= 16 then
			helper_038a2e4d(30)
		end
		if at <= 17 then
			helper_038a2e4d(6)
		end
		if at <= 18 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_038a2e4d(30)
		end
		if at <= 19 then
			helper_038a2e4d(10)
		end
		if at <= 20 then
			helper_972d1084(0, -1)
		end
		if at <= 21 then
			helper_d16eef1e(0)
			helper_238b5abc(5)
		end
		if at <= 22 then
			helper_038a2e4d(10)
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

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_d01c

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	helper_d01c()
	event.jump_to_map_3(-1, "s42", 502)
end

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	helper_7334e9f5()
	helper_fa78()
	event.set_active_camera_slot(0)
	event.set_previous_camera_slot(0)
	event.load_event_script("m06/m06.stb", -1)
end

--- Event 153, which map data, a script or the engine runs by number.
function script.event_153()
	helper_11838()
	event.set_active_camera_slot(0)
	event.set_previous_camera_slot(0)
	event.load_event_script("m06/m06.stb", -1)
end

--- Event 154, which map data, a script or the engine runs by number.
function script.event_154()
	event.add_inventory_item(353)
	helper_1432c()
	event.set_active_camera_slot(0)
	event.set_previous_camera_slot(0)
	event.load_event_script("m06/m06.stb", -1)
end

--- Event 155, which map data, a script or the engine runs by number.
function script.event_155()
	helper_1c538()
	event.set_active_camera_slot(0)
	event.set_previous_camera_slot(0)
	event.jump_to_map_3(-1, "m08", 152)
end

return script
