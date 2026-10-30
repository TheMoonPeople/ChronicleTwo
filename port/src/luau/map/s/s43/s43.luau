--!strict
-- map/s/s43/s43.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
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
local function helper_b8dc()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(1213)
		event.load_music(103)
		event.play_music(0)
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p1/op1ch8.txt")
		var0 = event.load_sound_effect_file_2(1213) or var0
		event.load_character_motion_pack(5, "event/opening/p1/p1_mints4.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, -540.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.load_character(5, "event/opening/p1/p1_people.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, 0.0, 0.0, -405.0)
		event.load_character(5, "event/opening/p1/p1_onna1.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, 18.39, 0.0, -421.29)
		event.load_character(5, "event/opening/p1/p1_otoko1.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_position(10, 27.92, 0.0, -433.74)
		event.load_character(5, "event/opening/p1/p1_otoko2.gltf", "info", 11)
		event.set_character_active(11)
		event.set_character_position(11, -25.29, 0.0, -426.67)
		event.load_character(5, "event/opening/p1/p2_macho.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(5, 12)
		event.set_object_handle_frame_visible(5, "sphere1", 0)
		event.set_object_handle_frame_visible(5, "sphere1_1", 0)
		event.set_object_handle_frame_visible(5, "sphere1_2", 0)
		event.set_object_handle_frame_visible(5, "sphere1_3", 0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 0.0, 11.23, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 3.14, 0.0)
		event.set_object_handle_shadow_enabled(5, 0)
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 13)
		event.set_character_active(13)
		event.set_character_motion(13, "回転1", 4)
		event.attach_character_to_frame(12, "sphere1", 13)
		event.copy_character(5, 13, 14)
		event.set_character_active(14)
		event.set_character_motion(14, "回転1", 4)
		event.attach_character_to_frame(12, "sphere1_1", 14)
		event.copy_character(5, 13, 15)
		event.set_character_active(15)
		event.set_character_motion(15, "回転1", 4)
		event.attach_character_to_frame(12, "sphere1_2", 15)
		event.copy_character(5, 13, 16)
		event.set_character_active(16)
		event.set_character_motion(16, "回転1", 4)
		event.attach_character_to_frame(12, "sphere1_3", 16)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 0.0, 0.0, -440.0, 120)
		event.set_object_sequence_motion(5, "投げ4回", 4)
		event.attach_object_handle_to_map_part_2(31, "p01_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p02_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-1")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-2")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-3")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-4")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-5")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-6")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-7")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p05_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p06_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p07_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p08_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p11_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p13_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p14_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p15_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-1")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-2")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-3")
		event.set_object_handle_visible(31, 0)
		event.set_map_lighting(1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 18.72, -581.27)
		event.set_camera_sequence_look_at(0.0, -0.38, -526.54)
		event.move_camera_sequence(0.0, 21.63, -581.27, 0.0, 38.43, -476.49, 120)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		at = 1
		wait_camera()
		at = 2
		wait_objects(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		event.open_voice_stream_wave(1, 10705)
		at = 3
		var1 = helper_f616ba9e(1)
		at = 4
		helper_888ab2a3(vm.i32(30 - var1))
		event.set_camera_sequence_position(-17.16, 17.61, -542.92)
		event.set_camera_sequence_look_at(2.33, 20.36, -409.98)
		event.play_voice_stream(1)
		at = 5
		helper_888ab2a3(30)
		event.set_object_sequence_motion(0, "見えないよ", 2)
		event.queue_object_sequence_next_motion(0, "見えないよL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var0, 4)
		event.delay_object_sequence_sound_track(0, 110)
		event.play_object_sequence_sound(0, var0, 5)
		at = 6
		helper_888ab2a3(200)
		event.close_voice_stream(1)
		event.play_object_sequence_sound(0, var0, 6)
		at = 7
		helper_0382f327(10710, 50)
		at = 8
		helper_0382f327(10715, 80)
		at = 9
		wait_objects(0)
		event.set_object_sequence_motion(0, "見えないよ戻り", 2)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		at = 10
		wait_objects(0)
		at = 11
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		at = 12
		wait_objects(0)
		at = 13
		helper_888ab2a3(10)
		event.open_voice_stream_wave(1, 10716)
		at = 14
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.set_camera_sequence_position(-54.54, 71.63, -344.23)
		event.set_camera_sequence_look_at(5.47, 6.56, -479.98)
		event.set_object_sequence_motion(0, "走り")
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 80)
		event.add_object_sequence_path_point(0, 0.0, 0.0, -440.0)
		event.add_object_sequence_path_point(0, 25.41, 0.0, -505.85)
		event.add_object_sequence_path_point(0, 59.73, 0.0, -569.39)
		event.add_object_sequence_path_point(0, 107.09, 0.0, -622.8)
		event.add_object_sequence_path_point(0, 163.05, 0.0, -656.61)
		event.add_object_sequence_path_point(0, 223.93, 0.0, -656.14)
		event.start_object_sequence_path(0)
		at = 15
		wait_objects(0)
		event.set_map_lighting(0)
		at = 16
		vm.wait(16)
		event.set_camera_sequence_position(385.44, 20.74, -469.02)
		event.set_camera_sequence_look_at(478.52, 20.25, -405.79)
		event.close_voice_stream(1)
		event.set_object_sequence_position(0, 431.02, 0.0, -509.53)
		event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
		event.move_object_sequence(0, 457.0, 0.0, -428.0, 40)
		event.delay_object_sequence_rotation_track(0, 35)
		event.rotate_object_sequence(0, 0.0, 0.72, 0.0, 5)
		at = 17
		wait_objects(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		at = 18
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "はしご登り", 2)
		event.open_voice_stream_wave(1, 10718)
		at = 19
		helper_888ab2a3(40)
		at = 20
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.set_object_handle_footstep_sound(0, 9)
		event.move_camera_sequence(385.44, 20.74, -469.02, 478.52, 129.61, -405.79, 180)
		event.wait_object_sequence_motion_end(0)
		at = 21
		wait_objects(0)
		at = 22
		wait_camera()
		event.set_camera_sequence_position(499.02, 167.79, -314.86)
		event.set_camera_sequence_look_at(424.99, 140.47, -326.88)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.close_voice_stream(1)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_object_sequence_position(0, 441.37, 133.45, -339.86)
		event.set_object_sequence_rotation(0, 0.0, 0.41, 0.0)
		event.move_object_sequence(0, 459.04, 133.45, -308.23, 40)
		event.set_object_handle_shadow_enabled(5, 1)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_sequence_motion(0, "右向き歩き", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "右を向く", 6)
		event.queue_object_sequence_next_motion(0, "右を向くL", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_sound_track(0, 40)
		event.play_object_sequence_sound(0, var0, 9)
		event.move_camera_sequence_eased(499.02, 167.79, -314.86, 407.46, 142.42, -261.94, 60, 2, 0.6)
		at = 23
		helper_0382f327(10720, 60)
		at = 24
		wait_objects(0)
		at = 25
		wait_camera()
		at = 26
		helper_888ab2a3(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(60)
		at = 27
		wait_camera()
	end, function(received: { any }): boolean
		if at == 3 then
			var1 = received[1] :: number
		end
		if at <= 1 then
			helper_238b5abc(0)
		end
		if at <= 2 then
			var1 = helper_523109b8(1)
		end
		if at <= 3 then
			helper_038a2e4d(vm.i32(30 - var1))
		end
		if at <= 4 then
			helper_038a2e4d(30)
		end
		if at <= 5 then
			helper_038a2e4d(200)
		end
		if at <= 6 then
			helper_53ffe901(10710, 50)
		end
		if at <= 7 then
			helper_53ffe901(10715, 80)
		end
		if at <= 8 then
			helper_238b5abc(0)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			helper_038a2e4d(10)
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_038a2e4d(10)
		end
		if at <= 13 then
			helper_238b5abc(1)
		end
		if at <= 14 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_238b5abc(0)
		end
		if at <= 17 then
			helper_038a2e4d(10)
		end
		if at <= 18 then
			helper_038a2e4d(40)
		end
		if at <= 19 then
			helper_238b5abc(1)
		end
		if at <= 20 then
			helper_238b5abc(0)
		end
		if at <= 21 then
			helper_344d6cd8()
		end
		if at <= 22 then
			helper_53ffe901(10720, 60)
		end
		if at <= 23 then
			helper_238b5abc(0)
		end
		if at <= 24 then
			helper_344d6cd8()
		end
		if at <= 25 then
			helper_038a2e4d(30)
		end
		if at <= 26 then
			helper_344d6cd8()
		end
		return true
	end)
	at = 28
	vm.entry(28)
	event.cancel_drama_scene_skip()
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.attach_object_handle_to_map_part_2(31, "p01_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p02_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-1")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-2")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-3")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-4")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-5")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-6")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-7")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p05_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p06_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p07_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p08_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p11_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p13_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p14_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p15_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-1")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-2")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-3")
	event.set_object_handle_visible(31, 1)
	event.set_map_lighting(0)
	event.set_character_active(0)
end

--- Helper function.
local function helper_f354()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local pos_y: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.set_character_active(0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_map_sounds(1214)
		var0 = event.load_sound_effect_file_2(1214) or var0
		event.load_character(5, "event/opening/p2/p2_erephant.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_sound_bank(5, var0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 279.22, 0.0, 581.89)
		event.set_object_sequence_rotation(5, 0.0, -1.68, 0.0)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.load_character(5, "event/opening/p2/p2_ball.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(6, 14)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, 0.0, -100.0, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(6, "玉持ち上げ", 5)
		event.load_character(5, "event/opening/p2/p2_myrene.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(7, 15)
		event.set_object_handle_sound_bank(7, var0)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 15.06, -111.23, -91.33)
		event.set_object_sequence_rotation(7, 0.0, -1.8, 0.0)
		event.set_object_sequence_texture_animation(7, 0)
		event.load_character(5, "event/opening/p2/p2_erephant_bup.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(8, 16)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_object_sequence_position(8, 6.14, 0.0, 4.14)
		event.set_object_sequence_rotation(8, 0.0, -2.88, 0.0)
		event.load_character(5, "event/opening/p2/p2_kiran.gltf", "info", 17)
		event.set_character_active(0, 17)
		event.attach_object_handle_to_character(9, 17)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.set_object_sequence_position(9, -5.37, 38.44, -29.5)
		event.set_object_sequence_rotation(9, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(9, "キラーン", 5)
		event.load_character(5, "event/opening/p1/p1_people.gltf", "info", 18)
		event.set_character_active(18)
		event.set_character_position(18, 0.0, 0.0, -405.0)
		event.assign_memory_stack(6)
		event.clear_memory_stack(6)
		event.load_character(6, "event/opening/p2/p2_macho.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.set_object_handle_sound_bank(0, var0)
		event.set_object_handle_frame_visible(0, "sphere1", 0)
		event.set_object_handle_frame_visible(0, "sphere1_1", 0)
		event.set_object_handle_frame_visible(0, "sphere1_2", 0)
		event.set_object_handle_frame_visible(0, "sphere1_3", 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 11.23, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.set_object_handle_sound_bank(1, var0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.copy_character(6, 9, 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_sound_bank(2, var0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.copy_character(6, 9, 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, var0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.copy_character(6, 9, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.set_object_handle_sound_bank(4, var0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "投げ4回", 4)
		event.set_object_sequence_motion(1, "回転1", 4)
		event.attach_character_to_frame(8, "sphere1", 9)
		event.set_object_sequence_motion(2, "回転1", 4)
		event.attach_character_to_frame(8, "sphere1_1", 10)
		event.set_object_sequence_motion(3, "回転1", 4)
		event.attach_character_to_frame(8, "sphere1_2", 11)
		event.set_object_sequence_motion(4, "回転1", 4)
		event.attach_character_to_frame(8, "sphere1_3", 12)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 125.0, -120.0)
		event.set_camera_sequence_look_at(0.0, 125.0, 0.0)
		event.move_camera_sequence(0.0, 30.0, -120.0, 0.0, 30.0, 0.0, 220)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		at = 2
		wait_camera()
		event.set_camera_sequence_position(0.0, 30.0, -180.0)
		event.set_camera_sequence_look_at(0.0, 30.0, 0.0)
		event.set_object_sequence_motion(0, "投げ４回からTポーズ", 6)
		event.queue_object_sequence_next_motion(0, "Tポーズ", 4)
		at = 3
		helper_888ab2a3(26)
		event.detach_character_from_frame(9)
		event.detach_character_from_frame(10)
		event.detach_character_from_frame(11)
		event.detach_character_from_frame(12)
		event.set_object_sequence_position(1, -60.0, 11.23, -30.0)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "着地", 5, 0.5)
		event.set_object_handle_shadow_enabled(1, 0)
		event.set_object_sequence_position(2, -20.0, 11.23, -30.0)
		event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(2, "着地", 5, 0.5)
		event.set_object_handle_shadow_enabled(2, 0)
		event.set_object_sequence_position(3, 20.0, 11.23, -30.0)
		event.set_object_sequence_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(3, "着地", 5, 0.5)
		event.set_object_handle_shadow_enabled(3, 0)
		event.set_object_sequence_position(4, 60.0, 11.23, -30.0)
		event.set_object_sequence_rotation(4, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(4, "着地", 5, 0.5)
		event.set_object_handle_shadow_enabled(4, 0)
		event.play_object_sequence_sound(1, var0, 5)
		event.set_object_sequence_motion(1, "着地", 6)
		event.queue_object_sequence_next_motion(1, "着地ループ", 4)
		at = 4
		helper_888ab2a3(10)
		event.set_object_sequence_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "着地ループ", 4)
		at = 5
		helper_888ab2a3(10)
		event.set_object_sequence_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "着地ループ", 4)
		at = 6
		helper_888ab2a3(10)
		event.set_object_sequence_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "着地ループ", 4)
		event.set_object_handle_shadow_enabled(1, 1)
		at = 7
		helper_888ab2a3(12)
		event.set_object_handle_shadow_enabled(2, 1)
		at = 8
		helper_888ab2a3(12)
		event.set_object_handle_shadow_enabled(3, 1)
		at = 9
		helper_888ab2a3(12)
		event.set_object_handle_shadow_enabled(4, 1)
		event.set_object_sequence_motion(0, "Tポーズから決め", 6)
		event.queue_object_sequence_next_motion(0, "決めループ", 6)
		event.wait_object_sequence_motion_end(0)
		at = 10
		wait_objects(0)
		event.set_object_sequence_motion(0, "決めからおじぎ", 6)
		event.queue_object_sequence_next_motion(0, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(0, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "着地ループからおじぎ", 6)
		event.queue_object_sequence_next_motion(1, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(1, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "着地ループからおじぎ", 6)
		event.queue_object_sequence_next_motion(2, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(2, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "着地ループからおじぎ", 6)
		event.queue_object_sequence_next_motion(3, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(3, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_object_sequence_motion(4, "着地ループからおじぎ", 6)
		event.queue_object_sequence_next_motion(4, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(4, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.set_object_sequence_motion(5, "歩き", 4)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 280)
		event.add_object_sequence_path_point(5, 279.22, 0.0, 581.89)
		event.add_object_sequence_path_point(5, 178.82, 0.0, 562.97)
		event.add_object_sequence_path_point(5, 117.49, 0.0, 543.89)
		event.add_object_sequence_path_point(5, 66.41, 0.0, 514.73)
		event.start_object_sequence_path(5)
		event.delay_object_sequence_sound_track(5, 120)
		event.play_object_sequence_sound(5, var0, 6)
		event.delay_object_sequence_sound_track(5, 120)
		event.play_object_sequence_sound(5, var0, 6)
		at = 11
		wait_objects(0)
		at = 12
		wait_objects(1)
		at = 13
		wait_objects(2)
		at = 14
		wait_objects(3)
		at = 15
		wait_objects(4)
		event.set_object_handle_sound_bank(1, -1)
		event.set_object_handle_sound_bank(2, var0)
		event.set_object_handle_sound_bank(3, var0)
		event.set_object_handle_sound_bank(4, -1)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -43.35, 11.23, -155.32, 120)
		event.rotate_object_sequence(0, 0.0, -2.9, 0.0, 10)
		event.set_object_sequence_motion(2, "走り")
		event.move_object_sequence(2, -90.31, 11.23, -38.89, 30)
		event.rotate_object_sequence(2, 0.0, -2.18, 0.0, 10)
		at = 16
		helper_888ab2a3(3)
		event.set_object_sequence_motion(3, "走り")
		event.move_object_sequence(3, 90.31, 11.23, -38.89, 30)
		event.rotate_object_sequence(3, 0.0, 2.18, 0.0, 10)
		at = 17
		helper_888ab2a3(2)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -90.31, 11.23, -38.89, 15)
		event.rotate_object_sequence(1, 0.0, -2.18, 0.0, 10)
		event.set_object_sequence_motion(4, "走り")
		event.move_object_sequence(4, 90.31, 11.23, -38.89, 15)
		event.rotate_object_sequence(4, 0.0, 2.18, 0.0, 10)
		at = 18
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		at = 19
		wait_objects(4)
		event.set_object_sequence_motion(4, "立ち")
		at = 20
		wait_objects(2)
		event.set_object_sequence_motion(2, "立ち")
		at = 21
		wait_objects(3)
		event.set_object_sequence_motion(3, "立ち")
		at = 22
		wait_objects(5)
		event.set_camera_sequence_position(-107.78, 17.46, -52.75)
		event.set_camera_sequence_look_at(-0.22, 62.14, -20.34)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_object_sequence_position(5, 0.0, 11.23, 80.0)
		event.set_object_sequence_rotation(5, 0.0, 3.14, 0.0)
		event.move_object_sequence(5, 0.0, 11.23, -30.0, 160)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, var0, 6)
		event.delay_object_sequence_sound_track(5, 90)
		event.play_object_sequence_sound(5, var0, 6)
		at = 23
		wait_objects(5)
		event.set_object_sequence_motion(5, "パオーン", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.delay_object_sequence_sound_track(5, 20)
		event.play_object_sequence_sound(5, var0, 7)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, var0, 8)
		at = 24
		helper_888ab2a3(62)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		at = 25
		wait_objects(5)
		at = 26
		wait_camera()
		event.start_background_file_loads_2("event/opening/p2/p2_bura_pie.gltf", "event/opening/p2/p2_buranko.gltf")
		event.set_object_sequence_motion(7, "歩き", 4)
		event.set_object_sequence_position(7, 15.06, 11.23, -91.33)
		event.set_object_sequence_rotation(7, 0.0, -0.96, 0.0)
		event.delay_object_sequence_rotation_track(7, 80)
		event.rotate_object_sequence(7, 0.0, -1.8, 0.0, 10)
		event.move_object_sequence(7, -68.07, 11.23, -40.78, 90)
		at = 27
		wait_objects(7)
		event.set_object_sequence_motion(7, "登場ポーズ", 2)
		event.wait_object_sequence_motion_end(7)
		event.move_camera_sequence(-131.01, 23.7, -59.75, -0.22, 39.36, -20.34, 143)
		at = 28
		wait_camera()
		at = 29
		wait_objects(7)
		event.set_object_sequence_motion(7, "歩き")
		event.move_object_sequence(7, -31.47, 11.23, -3.92, 60)
		event.rotate_object_sequence(7, 0.0, 0.72, 0.0, 10)
		at = 30
		wait_objects(7)
		event.set_object_sequence_motion(5, "ごにょごごにょ", 2)
		event.queue_object_sequence_next_motion(5, "ごにょごにょループ", 4)
		event.rotate_object_sequence(7, 0.0, 1.32, 0.0, 20)
		event.set_object_sequence_motion(7, "ごにょごにょ", 2)
		event.queue_object_sequence_next_motion(7, "ごにょごにょL", 6)
		event.wait_object_sequence_motion_end(7)
		event.delay_object_sequence_sound_track(7, 10)
		event.play_object_sequence_sound(7, var0, 9)
		at = 31
		wait_objects(7)
		event.set_camera_sequence_position(-40.25, 30.96, -47.72)
		event.set_camera_sequence_look_at(-5.49, 44.23, -27.58)
		event.set_character_active(0, 13)
		event.set_character_active(1, 16)
		event.play_object_sequence_sound(5, var0, 10)
		at = 32
		helper_888ab2a3(60)
		event.set_camera_sequence_position(0.0, 95.44, -190.42)
		event.set_camera_sequence_look_at(0.0, 62.65, 0.0)
		event.set_character_active(1, 13)
		event.set_character_active(0, 16)
		event.set_object_sequence_motion(5, "玉持ち上げ", 6)
		event.queue_object_sequence_next_motion(5, "玉持ち上げループ", 4)
		event.delay_object_sequence_sound_track(5, 4)
		event.play_object_sequence_sound(5, var0, 11)
		event.set_object_sequence_position(6, 0.0, 11.23, -30.0)
		event.set_object_sequence_motion(6, "玉持ち上げ", 6)
		event.queue_object_sequence_next_motion(6, "玉持ち上げループ", 4)
		event.set_object_sequence_rotation(7, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(7, "歩き", 4)
		event.rotate_object_sequence(7, 0.0, -1.57, 0.0, 20)
		event.move_object_sequence(7, -132.5, 11.23, 0.93, 90)
		at = 33
		wait_objects(7)
		event.set_character_active(0, 15)
		event.set_camera_sequence_position(0.4, 14.44, -179.22)
		event.set_camera_sequence_look_at(0.0, 67.37, 0.0)
		event.set_object_sequence_motion(5, "バイシクルシュート", 6)
		event.set_object_sequence_motion(6, "バイシクルシュート", 6)
		event.delay_object_sequence_sound_track(5, 62)
		event.play_object_sequence_sound(5, var0, 12)
		at = 34
		helper_888ab2a3(70)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		at = 35
		helper_888ab2a3(29)
		event.set_object_sequence_motion(5, "バイシクルシュート", 1)
		event.set_object_sequence_motion(6, "バイシクルシュート", 1)
		event.set_camera_sequence_position(-10.4, 37.62, -49.49)
		event.set_camera_sequence_look_at(-1.23, 39.37, -21.13)
		event.set_character_active(0, 13)
		event.set_character_active(1, 16)
		event.set_object_sequence_position(8, -2.78, -2.07, 15.89)
		event.set_object_sequence_rotation(8, 0.0, 3.02, 0.0)
		var1 = 0
		var2 = vm.f32(0.8)
		pos_y = vm.f32(-2.07)
		while var1 < 10 do
			var2 = vm.f32(var2 * vm.f32(0.8))
			pos_y = vm.f32(pos_y - var2)
			event.set_object_sequence_position(8, -2.78, pos_y, 15.89)
			var1 = var1 + 1
			print(vm.float(pos_y), "\n")
			at = 36
			vm.wait(36)
		end
		event.set_character_active(17)
		event.set_object_sequence_motion(9, "キラーン", 6)
		event.play_object_sequence_sound(5, var0, 13)
		at = 37
		helper_888ab2a3(10)
		event.set_character_active(0, 17)
		at = 38
		helper_888ab2a3(10)
		event.set_camera_sequence_position(-168.96, 18.9, -103.54)
		event.set_camera_sequence_look_at(-5.14, 75.4, 8.39)
		event.set_character_active(1, 13)
		event.set_character_active(0, 16)
		event.set_object_sequence_motion(5, "バイシクルシュート", 2)
		event.set_object_sequence_motion(6, "バイシクルシュート", 2)
		event.play_object_sequence_sound(5, var0, 14)
		at = 39
		helper_888ab2a3(9)
		event.set_object_sequence_motion_step(5, 0.01)
		event.set_object_sequence_motion_step(6, 0.01)
		event.set_camera_sequence_position(-197.04, 171.4, 0.74)
		event.set_camera_sequence_look_at(0.0, 121.4, 0.0)
		event.move_camera_sequence_angle_height_distance(1.57, 0.0, 197.04, 100)
		event.move_camera_sequence_angle_height_distance(3.14, -25.0, 197.04, 50)
		event.move_camera_sequence_angle_height_distance(-1.57, -50.0, 197.04, 50)
		at = 40
		wait_camera()
		event.set_object_sequence_motion_step(5, 0.6)
		event.set_object_sequence_motion_step(6, 0.6)
		event.wait_object_sequence_motion_end(5)
		event.play_object_sequence_sound(5, var0, 15)
		at = 41
		helper_888ab2a3(5)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		at = 42
		wait_camera()
		at = 43
		wait_objects(5)
		event.set_camera_sequence_position(-120.33, 279.87, -18.7)
		event.set_camera_sequence_look_at(138.46, 217.78, 141.95)
		event.set_object_sequence_position(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(6, "右のピエロ", 6)
		event.delay_object_sequence_sound_track(6, 10)
		event.play_object_sequence_sound(6, var0, 16)
		at = 44
		helper_888ab2a3(20)
		event.set_camera_sequence_position(87.54, 42.85, 80.82)
		event.set_camera_sequence_look_at(-204.62, 211.5, 188.69)
		event.set_object_sequence_motion(6, "左のピエロ", 6)
		event.delay_object_sequence_sound_track(6, 10)
		event.play_object_sequence_sound(6, var0, 16)
		at = 45
		helper_888ab2a3(20)
		event.set_camera_sequence_position(37.29, 24.91, -191.53)
		event.set_camera_sequence_look_at(5.05, 69.55, -9.71)
		event.set_object_sequence_motion(5, "キャッチ＆決め入り", 6)
		event.queue_object_sequence_next_motion(5, "決めループ", 4)
		event.delay_object_sequence_sound_track(5, 24)
		event.play_object_sequence_sound(5, var0, 17)
		event.set_object_sequence_position(6, 0.0, 11.23, -30.0)
		event.set_object_sequence_rotation(6, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(6, "キャッチ＆決め入り", 6)
		event.queue_object_sequence_next_motion(6, "決めループ", 4)
		at = 46
		helper_888ab2a3(50)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		at = 47
		wait_objects(5)
		event.play_object_sequence_sound(5, var0, 18)
		event.set_camera_sequence_position(-55.0, 150.0, 230.0)
		event.set_camera_sequence_look_at(0.0, 50.0, -30.0)
		event.move_camera_sequence(55.0, 150.0, 230.0, 0.0, 50.0, -30.0, 120)
		at = 48
		wait_camera()
		event.set_camera_sequence_position(37.29, 24.91, -191.53)
		event.set_camera_sequence_look_at(5.05, 69.55, -9.71)
		event.set_object_sequence_motion(6, "キャッチ＆決め終わり", 6)
		event.set_object_sequence_motion(5, "キャッチ＆決め終わり", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		at = 49
		helper_888ab2a3(30)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
		at = 50
		wait_camera()
		at = 51
		wait_objects(5)
		at = 52
		helper_479dc9e9()
		event.set_character_active(0, 14)
		event.play_sound_effect(var0, 19)
		event.move_camera_sequence_eased(245.05, 229.37, -124.72, 308.65, 198.37, -0.0, 90, 0, 0.3)
		event.clear_object_sequence(0)
		event.clear_object_sequence(1)
		event.clear_object_sequence(2)
		event.clear_object_sequence(3)
		event.clear_object_sequence(4)
		event.delete_character(8)
		event.delete_character(9)
		event.delete_character(10)
		event.delete_character(11)
		event.delete_character(12)
		event.clear_memory_stack(6)
		event.load_character(6, "event/opening/p2/p2_bura_pie.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "待機", 4)
		event.load_character(6, "event/opening/p2/p2_buranko.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "待機", 4)
		at = 53
		wait_camera()
		event.set_character_active(0, 13)
		event.set_camera_sequence_follow_object(0, 0.0, 14.0, 0.0, -2.67, 31.0, 140.0, "skin")
		at = 54
		helper_888ab2a3(60)
		event.stop_sound_effect(var0, 19)
		event.play_sound_effect(var0, 20)
		event.set_object_sequence_motion(0, "ピエロブランコ", 6)
		event.set_object_sequence_motion(1, "ピエロブランコ", 6)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, var0, 21)
		event.delay_object_sequence_sound_track(0, 50)
		event.play_object_sequence_sound(0, var0, 21)
		at = 55
		helper_888ab2a3(60)
		at = 56
		helper_888ab2a3(40)
		event.move_camera_sequence_angle_height_distance(-3.14, 0.0, 140.0, 60)
		at = 57
		helper_888ab2a3(90)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02")
		event.set_object_handle_visible(31, 0)
		event.release_camera_sequence_follow_object()
		event.play_object_sequence_sound(0, var0, 25)
		event.move_camera_sequence(145.04, 229.37, -319.27, -156.54, 156.11, -23.11, 60)
		at = 58
		wait_camera()
		event.set_camera_sequence_position(0.0, 237.95, -275.71)
		event.set_camera_sequence_look_at(0.0, 212.96, -32.39)
		event.set_object_sequence_position(0, 170.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 170.0, 0.0, 0.0)
		at = 59
		helper_888ab2a3(20)
		event.set_character_active(1, 15)
		event.set_object_sequence_position(7, 0.0, 11.23, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(7, "ムーンサルト", 6)
		event.queue_object_sequence_next_motion(7, "ムーンサルトL", 4)
		event.delay_object_sequence_sound_track(7, 20)
		event.play_object_sequence_sound(7, var0, 26)
		event.delay_object_sequence_sound_track(7, 45)
		event.play_object_sequence_sound(7, var0, 27)
		at = 60
		helper_888ab2a3(50)
		event.set_object_handle_visible(31, 1)
		at = 61
		wait_camera()
		event.set_camera_sequence_position(0.0, 53.51, -115.19)
		event.set_camera_sequence_look_at(0.0, 35.43, 0.41)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		at = 62
		wait_objects(7)
		event.set_camera_sequence_position(-27.17, 57.91, -13.37)
		event.set_camera_sequence_look_at(1.6, 40.06, 1.5)
		event.set_object_sequence_motion(7, "ウィンク", 6)
		event.queue_object_sequence_next_motion(7, "ウィンクL", 4)
		event.set_object_sequence_texture_animation(7, 0)
		event.set_object_sequence_texture_animation(7, 1, "ウインク")
		event.set_object_sequence_texture_animation(7, 1, "決めの口")
		event.play_object_sequence_sound(7, var0, 28)
		event.delay_object_sequence_sound_track(7, 20)
		event.play_object_sequence_sound(7, var0, 29)
		at = 63
		wait_objects(7)
		at = 64
		helper_888ab2a3(30)
		event.move_camera_sequence_eased(-391.9, 285.91, -201.78, 1.6, 40.06, 1.5, 90, 0, 0.2)
		at = 65
		wait_camera()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		at = 66
		wait_camera()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			helper_038a2e4d(26)
		end
		if at <= 3 then
			helper_038a2e4d(10)
		end
		if at <= 4 then
			helper_038a2e4d(10)
		end
		if at <= 5 then
			helper_038a2e4d(10)
		end
		if at <= 6 then
			helper_038a2e4d(12)
		end
		if at <= 7 then
			helper_038a2e4d(12)
		end
		if at <= 8 then
			helper_038a2e4d(12)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_238b5abc(1)
		end
		if at <= 12 then
			helper_238b5abc(2)
		end
		if at <= 13 then
			helper_238b5abc(3)
		end
		if at <= 14 then
			helper_238b5abc(4)
		end
		if at <= 15 then
			helper_038a2e4d(3)
		end
		if at <= 16 then
			helper_038a2e4d(2)
		end
		if at <= 17 then
			helper_238b5abc(1)
		end
		if at <= 18 then
			helper_238b5abc(4)
		end
		if at <= 19 then
			helper_238b5abc(2)
		end
		if at <= 20 then
			helper_238b5abc(3)
		end
		if at <= 21 then
			helper_238b5abc(5)
		end
		if at <= 22 then
			helper_238b5abc(5)
		end
		if at <= 23 then
			helper_038a2e4d(62)
		end
		if at <= 24 then
			helper_238b5abc(5)
		end
		if at <= 25 then
			helper_344d6cd8()
		end
		if at <= 26 then
			helper_238b5abc(7)
		end
		if at <= 27 then
			helper_344d6cd8()
		end
		if at <= 28 then
			helper_238b5abc(7)
		end
		if at <= 29 then
			helper_238b5abc(7)
		end
		if at <= 30 then
			helper_238b5abc(7)
		end
		if at <= 31 then
			helper_038a2e4d(60)
		end
		if at <= 32 then
			helper_238b5abc(7)
		end
		if at <= 33 then
			helper_038a2e4d(70)
		end
		if at <= 34 then
			helper_038a2e4d(29)
		end
		if at <= 35 then
			var1 = 0
			var2 = vm.f32(0.8)
			pos_y = vm.f32(-2.07)
			var2 = vm.f32(var2 * vm.f32(0.8))
			pos_y = vm.f32(pos_y - var2)
			local _ = var1 < 10
			var1 = var1 + 1
			print(vm.float(pos_y), "\n")
		end
		if at <= 36 then
			helper_038a2e4d(10)
		end
		if at <= 37 then
			helper_038a2e4d(10)
		end
		if at <= 38 then
			helper_038a2e4d(9)
		end
		if at <= 39 then
			helper_344d6cd8()
		end
		if at <= 40 then
			helper_038a2e4d(5)
		end
		if at <= 41 then
			helper_344d6cd8()
		end
		if at <= 42 then
			helper_238b5abc(5)
		end
		if at <= 43 then
			helper_038a2e4d(20)
		end
		if at <= 44 then
			helper_038a2e4d(20)
		end
		if at <= 45 then
			helper_038a2e4d(50)
		end
		if at <= 46 then
			helper_238b5abc(5)
		end
		if at <= 47 then
			helper_344d6cd8()
		end
		if at <= 48 then
			helper_038a2e4d(30)
		end
		if at <= 49 then
			helper_344d6cd8()
		end
		if at <= 50 then
			helper_238b5abc(5)
		end
		if at <= 51 then
			helper_344d6cd8()
		end
		if at <= 52 then
			helper_344d6cd8()
		end
		if at <= 53 then
			helper_038a2e4d(60)
		end
		if at <= 54 then
			helper_038a2e4d(60)
		end
		if at <= 55 then
			helper_038a2e4d(40)
		end
		if at <= 56 then
			helper_038a2e4d(90)
		end
		if at <= 57 then
			helper_344d6cd8()
		end
		if at <= 58 then
			helper_038a2e4d(20)
		end
		if at <= 59 then
			helper_038a2e4d(50)
		end
		if at <= 60 then
			helper_344d6cd8()
		end
		if at <= 61 then
			helper_238b5abc(7)
		end
		if at <= 62 then
			helper_238b5abc(7)
		end
		if at <= 63 then
			helper_038a2e4d(30)
		end
		if at <= 64 then
			helper_344d6cd8()
		end
		if at <= 65 then
			helper_344d6cd8()
		end
		return true
	end)
	at = 67
	vm.entry(67)
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	event.delete_character(8)
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
	event.stop_sound_effect(var0, 19)
	event.stop_sound_effect(var0, 28)
	event.stop_sound_effect(var0, 29)
end

--- Helper function.
local function helper_16ee0()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_dungeon_pause_flags(1, 1)
		event.show_dungeon_status_bar(0, 0.033333335)
		at = 1
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		at = 2
		helper_888ab2a3(30)
		event.clear_event_battle_monsters(-1)
		event.set_dungeon_pause_flags(16384, 0)
		event.initialize_event()
		event.show_dungeon_status_bar(0, 1.0)
		event.add_hp_by_rate(1.0, 0)
		event.add_battle_weapon_durability(0, 999)
		var1 = event.load_sound_effect_file_2(1216) or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p4/op4ch1.txt")
		event.load_character_motion_pack(5, "event/opening/p4/p4_mints3.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 0)
		event.attach_object_handle_to_character(21, 2)
		event.set_object_handle_visible(21, 0)
		event.load_character(5, "event/opening/p4/light.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_frame_visible(2, "kusari", 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character_frame(7, 10, "light_rot")
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.rotate_object_sequence(7, 0.01, 0.0, 0.0, -1)
		event.load_character(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
		event.load_character_motion_pack(5, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, var1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.copy_character(5, 11, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.set_object_handle_sound_bank(4, var1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.copy_character(5, 11, 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_sound_bank(5, var1)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.copy_character(5, 11, 14)
		event.set_character_active(0, 14)
		event.load_character(5, "event/opening/p4/p4_people.gltf", "info", 15)
		event.set_character_active(15)
		event.set_character_position(15, 0.0, 0.0, -405.0)
		event.load_character(5, "event/opening/p4/up_kusari.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_character_to_frame(10, "up_kusari", 18)
		event.load_character(5, "event/opening/p4/shuchusen.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(6, 8)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "event/opening/p4/p4_kemuri.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.set_character_position(20, 0.0, 10.0, 0.0)
		event.set_object_sequence_motion(4, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot2", 12)
		event.set_object_sequence_motion(5, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot3", 13)
		event.set_object_sequence_motion(3, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot1", 11)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.attach_character_to_frame(10, "mints", 0)
		event.set_object_sequence_motion(0, "見上げるL", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.open_voice_stream_wave(1, 40060)
		at = 3
		helper_9cbdc640(1)
		event.set_character_motion(10, "落下", 6, 0.3)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 8.0, -0.16, 15.0, 20.0, "bcol00", 2)
		event.play_sound_effect(var1, 33)
		event.keep_character_in_front_of_camera_sequence(8, 60.0, 30)
		event.set_character_active(8)
		event.set_character_active(18)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "落ちるー（３）")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.play_voice_stream(1)
		event.open_message_window_2(0, 40060)
		open_message(0, -1, 8, 0, 0)
		at = 4
		helper_61e5dba6(0, 30)
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		at = 5
		wait_objects(6)
		event.close_voice_stream(1)
		event.release_camera_sequence_follow_object()
		event.set_character_active(0, 8)
		event.set_camera_sequence_position(0.0, 18.46, -95.54)
		event.set_camera_sequence_look_at(0.0, 194.33, 107.78)
		event.move_camera_sequence(0.0, 18.46, -95.54, 0.0, 66.62, 107.78, 30)
		event.set_character_active(11)
		event.set_character_active(12)
		event.set_character_active(13)
		event.set_character_active(0, 18)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "落下", 6, 0.3)
		event.queue_object_sequence_next_motion(2, "停止", 4)
		event.play_sound_effect(var1, 27)
		at = 6
		helper_888ab2a3(14)
		event.set_object_sequence_motion(0, "飛び降りる", 2)
		event.queue_object_sequence_next_motion(0, "飛び降りるL", 6, 0.2)
		event.queue_object_sequence_next_motion(0, "ライトから着地", 6)
		event.wait_object_sequence_motion_end(0)
		event.delay_object_sequence_motion_track(0, 10)
		at = 7
		helper_888ab2a3(10)
		event.detach_character_from_frame(0)
		event.set_object_sequence_position(0, 0.0, 65.81, 94.16)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.jump_object_sequence(0, 0.0, 10.6, 6.0, -0.2, 30)
		at = 8
		helper_888ab2a3(5)
		event.set_character_active(20)
		event.set_character_motion(20, "けむり", 6)
		at = 9
		helper_d743ebd8(40062)
		at = 10
		wait_objects(2)
		event.clear_object_sequence(7)
		event.detach_character_from_frame(11)
		event.set_object_sequence_position(3, -46.01, 150.0, 50.48)
		event.set_object_sequence_rotation(3, 0.0, 2.42, 0.0)
		event.detach_character_from_frame(12)
		event.set_object_sequence_position(4, -48.62, 150.0, 60.52)
		event.set_object_sequence_rotation(4, 0.0, -2.42, 0.0)
		event.detach_character_from_frame(13)
		event.set_object_sequence_position(5, -35.87, 150.0, -54.34)
		event.set_object_sequence_rotation(5, 0.0, 0.38, 0.0)
		event.set_character_active(14)
		event.attach_object_handle_to_character(20, 14)
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.set_object_sequence_position(20, 30.12, 150.0, -61.93)
		event.set_object_sequence_rotation(20, 0.0, -0.6, 0.0)
		at = 11
		wait_objects(0)
		event.set_camera_sequence_position(1.17, 26.95, -26.03)
		event.set_camera_sequence_look_at(1.17, 33.68, 4.49)
		event.set_object_sequence_position(0, 0.0, 10.0, 6.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "舞台上キョロキョロ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "拍手喝采（３）")
		event.set_object_sequence_texture_animation(0, 1, "開きからにこり")
		event.play_object_sequence_sound(0, var1, 28)
		event.close_voice_stream(1)
		at = 12
		helper_d743ebd8(40064)
		at = 13
		wait_objects(0)
		event.set_camera_sequence_look_at(0.0, 33.68, 4.49)
		event.set_camera_sequence_angle_height_distance(0.9, 9.0, 50.0)
		event.move_camera_sequence_angle_height_distance(-0.9, 9.0, 50.0, 180)
		event.set_object_sequence_motion(0, "手を振る", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "感動（３）")
		event.set_object_sequence_texture_animation(0, 1, "うれし口（３）")
		at = 14
		wait_camera()
		event.set_camera_sequence_position(0.61, 45.86, -150.28)
		event.set_camera_sequence_look_at(0.57, 21.14, 5.95)
		event.set_character_active(0, 10)
		event.set_object_sequence_motion(20, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(20, "着地", 6)
		event.queue_object_sequence_next_motion(20, "立ち", 4)
		event.jump_object_sequence(20, 30.12, 8.8, -61.93, -0.2, 30)
		event.delay_object_sequence_sound_track(20, 30)
		event.play_object_sequence_sound(20, var1, 34)
		at = 15
		helper_888ab2a3(6)
		event.set_object_sequence_motion(3, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.jump_object_sequence(3, -46.01, 8.8, 50.48, -0.2, 30)
		event.delay_object_sequence_sound_track(3, 30)
		event.play_object_sequence_sound(3, var1, 34)
		at = 16
		helper_888ab2a3(4)
		event.set_object_sequence_motion(5, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(5, "着地", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.jump_object_sequence(5, -35.87, 8.8, -54.34, -0.2, 30)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, var1, 34)
		at = 17
		helper_888ab2a3(3)
		event.set_object_sequence_motion(4, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.jump_object_sequence(4, 48.62, 8.8, 60.52, -0.2, 30)
		event.delay_object_sequence_sound_track(4, 30)
		event.play_object_sequence_sound(4, var1, 34)
		at = 18
		helper_888ab2a3(20)
		event.set_object_sequence_motion(0, "キョロキョロ立ち")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		event.close_voice_stream(1)
		at = 19
		helper_0382f327(40080, 30)
		at = 20
		helper_888ab2a3(10)
		event.set_camera_sequence_position(-20.61, 33.01, -18.61)
		event.set_camera_sequence_look_at(1.45, 30.1, 6.28)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_object_sequence_motion(0, "レンチを取り出す", 6)
		event.queue_object_sequence_next_motion(0, "レンチを取り出すL", 4)
		event.close_voice_stream(1)
		event.open_voice_stream_wave(1, 40082)
		at = 21
		var2 = helper_f616ba9e(1)
		event.play_voice_stream(1)
		at = 22
		helper_888ab2a3(vm.i32(40 - var2))
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 1)
		at = 23
		helper_888ab2a3(46)
		event.play_object_sequence_sound(0, var1, 35)
		at = 24
		wait_objects(0)
		at = 25
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-4.51, 25.29, -32.6)
		event.set_camera_sequence_look_at(1.45, 30.1, 6.28)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.delay_object_sequence_sound_track(0, 4)
		event.play_object_sequence_sound(0, var1, 36)
		event.close_voice_stream(1)
		at = 26
		helper_d743ebd8(40083)
		at = 27
		wait_objects(0)
		at = 28
		helper_888ab2a3(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		at = 29
		wait_camera()
	end, function(received: { any }): boolean
		if at == 21 then
			var2 = received[1] :: number
		end
		if at <= 1 then
			helper_038a2e4d(30)
		end
		if at <= 2 then
			helper_238b5abc(1)
		end
		if at <= 3 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_972d1084(0, 30)
		end
		if at <= 4 then
			helper_d16eef1e(0)
			helper_238b5abc(6)
		end
		if at <= 5 then
			helper_038a2e4d(14)
		end
		if at <= 6 then
			helper_038a2e4d(10)
		end
		if at <= 7 then
			helper_038a2e4d(5)
		end
		if at <= 8 then
			helper_48d33e71(40062)
		end
		if at <= 9 then
			helper_238b5abc(2)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_48d33e71(40064)
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			helper_344d6cd8()
		end
		if at <= 14 then
			helper_038a2e4d(6)
		end
		if at <= 15 then
			helper_038a2e4d(4)
		end
		if at <= 16 then
			helper_038a2e4d(3)
		end
		if at <= 17 then
			helper_038a2e4d(20)
		end
		if at <= 18 then
			helper_53ffe901(40080, 30)
		end
		if at <= 19 then
			helper_038a2e4d(10)
		end
		if at <= 20 then
			var2 = helper_523109b8(1)
		end
		if at <= 21 then
			helper_038a2e4d(vm.i32(40 - var2))
		end
		if at <= 22 then
			helper_038a2e4d(46)
		end
		if at <= 23 then
			helper_238b5abc(0)
		end
		if at <= 24 then
			helper_038a2e4d(30)
		end
		if at <= 25 then
			helper_48d33e71(40083)
		end
		if at <= 26 then
			helper_238b5abc(0)
		end
		if at <= 27 then
			helper_038a2e4d(30)
		end
		if at <= 28 then
			helper_344d6cd8()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var1, 33)
	event.stop_sound_effect(var1, 27)
	event.stop_sound_effect(var1, 28)
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
	event.load_map_sounds(1217)
	event.stop_port_sound_effects(4)
	for var3 = 0, 31 do
		event.clear_object_sequence(var3)
	end
	event.set_camera_look_at(0.0, 33.8, 6.0)
	event.set_camera_position(0.0, 38.8, 86.0)
	event.reset_follow_camera(0)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(8)
	event.set_character_active(1, 0)
	event.detach_character_from_frame(0)
	event.set_character_position(0, 0.0, 8.8, 6.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "バトル立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(21, 1)
	event.set_object_handle_visible(21, 1)
	event.attach_object_handle_to_character(21, 2)
	event.set_object_handle_visible(21, 0)
	event.initialize_sound_port(4)
	event.assign_memory_stack(3)
	event.clear_memory_stack(3)
	event.load_dungeon_monster(600, 1)
	event.place_dungeon_monster(600, -46.01, 8.8, 50.48, 0.0, 2.42, 0.0)
	event.place_dungeon_monster(600, 48.62, 8.8, 60.52, 0.0, -2.42, 0.0)
	event.place_dungeon_monster(600, -35.87, 8.8, -54.34, 0.0, 0.38, 0.0)
	event.place_dungeon_monster(600, 30.12, 8.8, -61.93, 0.0, -0.6, 0.0)
	var0 = event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json") or var0
	event.play_sound_effect(var0, 0)
	at = 30
	vm.wait(30)
	event.set_dungeon_pause_flags(16384, 1)
	var4 = event.get_sound_id(4) or var4
	event.set_action_character_second_sound_bank(0, var4)
	event.copy_action_character_sound_to_parts(0)
	event.set_dungeon_pause_flags(1, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Helper function.
local function helper_1b4e4()
	local var0: s32 = 0
	local var1: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.show_dungeon_status_bar(0, 0.033333335)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		event.set_character_motion(0, "バトル立ち")
		helper_888ab2a3(30)
		event.stop_music(0)
		event.set_message_window_mode(0, 7)
		event.enable_drama_skip()
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p4/op4ch2.txt")
		event.load_map_sounds(1218)
		var0 = event.load_sound_effect_file_2(1216) or var0
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var1
		event.load_character_motion_pack(5, "event/opening/p4/p4_mints4.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 10.0, -80.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_motion(0, "かまえるL", 4)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 1)
		event.attach_object_handle_to_character(21, 2)
		event.set_object_handle_visible(21, 0)
		event.load_character(5, "event/opening/p4/p4_people.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, 0.0, 0.0, -405.0)
		event.load_character(5, "event/opening/p4/p4_otoko1.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, 20.0, 0.0, -420.0)
		event.load_character(5, "event/opening/p4/p4_otoko2.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_position(10, -20.0, 0.0, -420.0)
		event.load_character(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
		event.load_character_motion_pack(5, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, var0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, -50.82, 150.0, -15.75)
		event.set_object_sequence_rotation(3, 0.0, 2.2, 0.0)
		event.copy_character(5, 11, 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(4, 12)
		event.set_object_handle_sound_bank(4, var0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 47.49, 150.0, -2.37)
		event.set_object_sequence_rotation(4, 0.0, -2.64, 0.0)
		event.copy_character(5, 11, 13)
		event.set_character_active(0, 13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_sound_bank(5, var0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, -28.7, 150.0, 70.26)
		event.set_object_sequence_rotation(5, 0.0, 2.8, 0.0)
		event.copy_character(5, 11, 14)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(6, 14)
		event.set_object_handle_sound_bank(6, var0)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, 1.79, 150.0, 28.91)
		event.set_object_sequence_rotation(6, 0.0, 2.92, 0.0)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(7, 15)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 0.0, 42.0, -84.0)
		event.set_object_sequence_rotation(7, 1.57, 0.0, 0.0)
		event.set_object_sequence_motion(7, "発動", 5)
		event.set_camera_sequence_position(-2.8, 29.02, -36.61)
		event.set_camera_sequence_look_at(0.85, 26.87, -88.33)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.play_sound_effect(var1, 0)
		event.set_object_sequence_motion(0, "かかげる", 6)
		event.queue_object_sequence_next_motion(0, "かかげるL", 4)
		event.play_object_sequence_sound(0, var0, 37)
		helper_888ab2a3(16)
		event.set_object_sequence_motion(7, "発動", 6)
		event.move_camera_sequence_eased(-0.86, 81.13, -64.1, 0.85, 26.87, -88.33, 12, 2, 1.0)
		helper_888ab2a3(20)
		event.play_object_sequence_sound(0, var0, 38)
		helper_888ab2a3(60)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 0)
		event.open_message_window_2(0, 40085)
		helper_75684dd8(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_draw_speed(0, 1)
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "気がつく", 6)
		event.queue_object_sequence_next_motion(0, "気がつくL", 4)
		wait_objects(0)
		event.set_character_active(11)
		event.set_character_active(12)
		event.set_character_active(13)
		event.set_character_active(14)
		event.set_object_sequence_motion(3, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.jump_object_sequence(3, -50.82, 8.8, -15.75, -0.1, 30)
		event.delay_object_sequence_sound_track(3, 30)
		event.play_object_sequence_sound(3, var0, 29)
		event.delay_object_sequence_motion_track(4, 3)
		event.delay_object_sequence_position_track(4, 3)
		event.delay_object_sequence_sound_track(4, 3)
		event.set_object_sequence_motion(4, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.jump_object_sequence(4, 47.49, 8.8, -2.37, -0.1, 30)
		event.delay_object_sequence_sound_track(4, 30)
		event.play_object_sequence_sound(4, var0, 29)
		event.delay_object_sequence_motion_track(5, 9)
		event.delay_object_sequence_position_track(5, 9)
		event.delay_object_sequence_sound_track(5, 9)
		event.set_object_sequence_motion(5, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(5, "着地", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.jump_object_sequence(5, -28.7, 8.8, 70.26, -0.1, 30)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, var0, 29)
		event.delay_object_sequence_motion_track(6, 15)
		event.delay_object_sequence_position_track(6, 15)
		event.delay_object_sequence_sound_track(6, 15)
		event.set_object_sequence_motion(6, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(6, "着地", 6)
		event.queue_object_sequence_next_motion(6, "立ち", 4)
		event.jump_object_sequence(6, 1.79, 8.8, 28.91, -0.1, 30)
		event.delay_object_sequence_sound_track(6, 30)
		event.play_object_sequence_sound(6, var0, 29)
		helper_888ab2a3(20)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 0)
		event.set_camera_sequence_position(-12.49, 56.75, -150.16)
		event.set_camera_sequence_look_at(-0.59, 13.56, -3.76)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "かまえ立ち", 4, -1.0, 1)
		helper_888ab2a3(40)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.set_camera_sequence_position(-27.38, 36.23, -86.69)
		event.set_camera_sequence_look_at(29.33, 26.13, -60.27)
		event.set_character_cloth_animation_enabled(0, 0)
		event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "かまえ立ち", 4, -1.0, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "落ちるー（３）")
		vm.wait(11)
		event.set_mouth_texture_animations(0, "通常口パク", "怒り口（３）")
		helper_0382f327(40090, 120)
		event.reset_mouth_texture_animations()
		helper_d743ebd8(40100)
		event.set_object_sequence_motion(0, "出口を見る", 6)
		event.queue_object_sequence_next_motion(0, "出口を見るL", 6)
		helper_888ab2a3(12)
		event.set_object_sequence_motion(0, "→走り", 2)
		event.queue_object_sequence_next_motion(0, "走り", 4)
		helper_888ab2a3(10)
		event.move_object_sequence(0, 0.0, 10.0, -120.0, 20)
		wait_objects(0)
		event.set_camera_sequence_position(0.0, 41.13, -104.26)
		event.set_camera_sequence_look_at(0.0, 20.2, -217.19)
		event.set_object_sequence_position(0, 0.0, 0.0, -200.0)
		event.move_object_sequence(0, 0.0, 0.0, -350.0, 30)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "拍手喝采（３）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		wait_objects(0)
		event.set_camera_sequence_position(-60.96, 9.43, -525.19)
		event.set_camera_sequence_look_at(0.0, 28.11, -410.09)
		event.move_camera_sequence(-60.96, 9.43, -525.19, 0.0, 28.11, -451.39, 35)
		event.set_object_sequence_motion(0, "客を飛び超える", 6)
		event.move_object_sequence(0, 0.0, 0.0, -470.0, 35)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var0, 30)
		event.set_character_motion(9, "振り向き", 2)
		event.set_character_motion(10, "振り向き", 2)
		wait_objects(0)
		event.set_camera_sequence_position(-107.5, 71.31, -471.79)
		event.set_camera_sequence_look_at(21.82, 28.11, -671.17)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_position(0, -40.33, 0.0, -525.86)
		event.set_object_sequence_rotation(0, 0.0, 2.7, 0.0)
		event.move_object_sequence(0, 29.23, 5.07, -691.14, 50)
		helper_888ab2a3(20)
		event.fade_out_screen(30)
		event.fade_out_music(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_character_cloth_animation_enabled(0, 1)
	event.add_hp_by_rate(1.0, 0)
	event.add_battle_weapon_durability(0, 999)
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.stop_music(0)
	event.stop_environment_music()
	helper_888ab2a3(4)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	local at: number = 0
	return vm.guard(function()
		event.set_time_of_day_advancing(0)
		event.show_dungeon_status_bar(0, 1.0)
		event.set_save_control_bits(1, 1)
		event.set_dungeon_pause_flags(256, 1)
		at = 1
		helper_b8dc()
		at = 2
		helper_f354()
		event.load_event_script("s43/s43b.stb", 151)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_f354()
				return vm.continue_with(function()
					event.load_event_script("s43/s43b.stb", 151)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	local var0: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(3)
	event.clear_memory_stack(3)
	event.load_dungeon_monster(600, 1)
	event.place_dungeon_monster(600, -46.01, 8.8, 50.48, 0.0, 2.42, 0.0)
	event.place_dungeon_monster(600, 48.62, 8.8, 60.52, 0.0, -2.42, 0.0)
	event.place_dungeon_monster(600, -35.87, 8.8, -54.34, 0.0, 0.38, 0.0)
	event.place_dungeon_monster(600, 30.12, 8.8, -61.93, 0.0, -0.6, 0.0)
	var0 = event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json") or var0
	event.play_sound_effect(var0, 0)
	event.set_dungeon_pause_flags(16384, 1)
	event.set_save_counter(5, 2)
	vm.wait(1)
	event.show_dungeon_status_bar(1, 0.033333335)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
script.event_1200 = helper_16ee0

--- The dungeon system event run when every monster on the floor has been defeated.
function script.floor_clear()
	helper_1b4e4()
	event.add_inventory_item(1)
	event.equip_character_item(0, 1)
	event.remove_item(387)
	event.set_save_control_bits(1, 0)
	event.set_dungeon_pause_flags(256, 0)
	event.go_to_georama_edit(17, 153)
end

--- Event 8000, which map data, a script or the engine runs by number.
function script.event_8000()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.stop_music(0)
		event.stop_environment_music()
		at = 1
		helper_888ab2a3(6)
		event.load_map_sounds(1213)
		event.load_music(103)
		event.play_music(0)
		event.show_dungeon_status_bar(0, 1.0)
		event.set_save_control_bits(1, 1)
		event.set_dungeon_pause_flags(256, 1)
		at = 2
		helper_f354()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_f354()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 8001, which map data, a script or the engine runs by number.
function script.event_8001()
	event.initialize_event()
	event.stop_music(0)
	event.stop_environment_music()
	helper_888ab2a3(6)
	event.load_map_sounds(1213)
	event.load_music(103)
	event.play_music(0)
	event.show_dungeon_status_bar(0, 1.0)
	event.set_save_control_bits(1, 1)
	event.set_dungeon_pause_flags(256, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_event_script("s43/s43b.stb", 151)
end

--- Event 8002, which map data, a script or the engine runs by number.
function script.event_8002()
	event.initialize_event()
	vm.wait(1)
	event.show_dungeon_status_bar(0, 1.0)
	event.set_save_control_bits(1, 1)
	event.set_dungeon_pause_flags(256, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_event_script("s43/s43b.stb", 8000)
end

return script
