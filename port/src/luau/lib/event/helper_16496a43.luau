--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0e75aa9e = require("@lib/event/helper_0e75aa9e")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_a518823a = require("@lib/event/helper_a518823a")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_16496a43()
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
		event.load_message_file(0, 5, "event/opening/p1/op1ch8_1.txt")
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
		var1 = 0
		at = 3
		wait_frames(30 - var1)
		event.set_camera_sequence_position(-17.16, 17.61, -542.92)
		event.set_camera_sequence_look_at(2.33, 20.36, -409.98)
		at = 4
		wait_frames(30)
		event.set_object_sequence_motion(0, "見えないよ", 2)
		event.queue_object_sequence_next_motion(0, "見えないよL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var0, 4)
		event.delay_object_sequence_sound_track(0, 110)
		event.play_object_sequence_sound(0, var0, 5)
		at = 5
		wait_frames(200)
		event.play_object_sequence_sound(0, var0, 6)
		at = 6
		helper_0e75aa9e(10710, -1, 10)
		at = 7
		wait_objects(0)
		event.set_object_sequence_motion(0, "見えないよ戻り", 2)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		at = 8
		wait_objects(0)
		at = 9
		wait_frames(10)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		at = 10
		wait_objects(0)
		at = 11
		wait_frames(10)
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
		at = 12
		wait_objects(0)
		event.set_map_lighting(0)
		at = 13
		vm.wait(13)
		event.set_camera_sequence_position(385.44, 20.74, -469.02)
		event.set_camera_sequence_look_at(478.52, 20.25, -405.79)
		event.set_object_sequence_position(0, 431.02, 0.0, -509.53)
		event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
		event.move_object_sequence(0, 457.0, 0.0, -428.0, 40)
		event.delay_object_sequence_rotation_track(0, 35)
		event.rotate_object_sequence(0, 0.0, 0.72, 0.0, 5)
		at = 14
		wait_objects(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		at = 15
		wait_frames(10)
		event.set_object_sequence_motion(0, "はしご登り", 2)
		at = 16
		wait_frames(40)
		event.set_object_handle_footstep_sound(0, 9)
		event.move_camera_sequence(385.44, 20.74, -469.02, 478.52, 129.61, -405.79, 180)
		event.wait_object_sequence_motion_end(0)
		at = 17
		wait_objects(0)
		at = 18
		wait_camera()
		event.set_camera_sequence_position(499.02, 167.79, -314.86)
		event.set_camera_sequence_look_at(424.99, 140.47, -326.88)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
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
		at = 19
		helper_1584c528(10720, 60)
		at = 20
		wait_objects(0)
		at = 21
		wait_camera()
		at = 22
		wait_frames(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(60)
		at = 23
		wait_camera()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_238b5abc(0)
		end
		if at <= 2 then
			var1 = 0
			wait_frames_skipping(30 - var1)
		end
		if at <= 3 then
			wait_frames_skipping(30)
		end
		if at <= 4 then
			wait_frames_skipping(200)
		end
		if at <= 5 then
			helper_a518823a(10710, -1, 10)
		end
		if at <= 6 then
			helper_238b5abc(0)
		end
		if at <= 7 then
			helper_238b5abc(0)
		end
		if at <= 8 then
			wait_frames_skipping(10)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			wait_frames_skipping(10)
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			wait_frames_skipping(10)
		end
		if at <= 15 then
			wait_frames_skipping(40)
		end
		if at <= 16 then
			helper_238b5abc(0)
		end
		if at <= 17 then
			helper_344d6cd8()
		end
		if at <= 18 then
			helper_52aadc70(10720, 60)
		end
		if at <= 19 then
			helper_238b5abc(0)
		end
		if at <= 20 then
			helper_344d6cd8()
		end
		if at <= 21 then
			wait_frames_skipping(30)
		end
		if at <= 22 then
			helper_344d6cd8()
		end
		return true
	end)
	at = 24
	vm.entry(24)
	event.cancel_drama_scene_skip()
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

return helper_16496a43
