--!strict
-- map/i/i03/h02/i03h02.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_183cf34f = require("@lib/event/helper_183cf34f")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_b8ac()
	local var0: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.enable_drama_skip()
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		var0 = event.load_sound_effect_file_2(1213) or var0
		event.load_character_motion_pack(5, "event/opening/p1/p1_mints4.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, -540.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/opening/p1/p1_people.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, 0.0, 0.0, -405.0)
		event.load_character(5, "event/opening/p1/p1_onna1.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_position(10, 18.39, 0.0, -421.29)
		event.load_character(5, "event/opening/p1/p1_otoko1.gltf", "info", 11)
		event.set_character_active(11)
		event.set_character_position(11, 27.92, 0.0, -433.74)
		event.load_character(5, "event/opening/p1/p1_otoko2.gltf", "info", 12)
		event.set_character_active(12)
		event.set_character_position(12, -25.29, 0.0, -426.67)
		event.load_character(5, "event/opening/p1/p2_macho.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_frame_visible(5, "sphere1", 0)
		event.set_object_handle_frame_visible(5, "sphere1_1", 0)
		event.set_object_handle_frame_visible(5, "sphere1_2", 0)
		event.set_object_handle_frame_visible(5, "sphere1_3", 0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 0.0, 11.23, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 3.14, 0.0)
		event.set_object_handle_shadow_enabled(5, 0)
		event.start_background_file_loads_1("event/opening/p1/p2_pierrot.gltf")
		vm.wait(1)
		helper_479dc9e9()
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 14)
		event.set_character_active(14)
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 15)
		event.set_character_active(15)
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 16)
		event.set_character_active(16)
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 17)
		event.set_character_active(17)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 0.0, 0.0, -440.0, 120)
		event.set_object_sequence_motion(5, "投げ4回", 4)
		event.set_character_motion(14, "回転1", 4)
		event.attach_character_to_frame(13, "sphere1", 14)
		event.set_character_motion(15, "回転1", 4)
		event.attach_character_to_frame(13, "sphere1_1", 15)
		event.set_character_motion(16, "回転1", 4)
		event.attach_character_to_frame(13, "sphere1_2", 16)
		event.set_character_motion(17, "回転1", 4)
		event.attach_character_to_frame(13, "sphere1_3", 17)
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
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 18.72, -581.27)
		event.set_camera_sequence_look_at(0.0, -0.38, -526.54)
		event.move_camera_sequence(0.0, 21.63, -581.27, 0.0, 38.43, -476.49, 120)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		wait_camera()
		wait_objects(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-17.16, 17.61, -542.92)
		event.set_camera_sequence_look_at(2.33, 20.36, -409.98)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(0, "見えないよ", 2)
		event.queue_object_sequence_next_motion(0, "見えないよL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var0, 4)
		event.delay_object_sequence_sound_track(0, 110)
		event.play_object_sequence_sound(0, var0, 5)
		helper_888ab2a3(200)
		event.play_object_sequence_sound(0, var0, 6)
		helper_75684dd8(0, 1033, 8, 200, 200)
		wait_objects(0)
		event.set_object_sequence_motion(0, "見えないよ戻り", 2)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		wait_objects(0)
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		wait_objects(0)
		helper_888ab2a3(10)
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
		wait_objects(0)
		event.set_map_lighting(0)
		vm.wait(15)
		event.set_camera_sequence_position(385.44, 20.74, -469.02)
		event.set_camera_sequence_look_at(478.52, 20.25, -405.79)
		event.set_object_sequence_position(0, 431.02, 0.0, -509.53)
		event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
		event.move_object_sequence(0, 457.0, 0.0, -428.0, 40)
		event.delay_object_sequence_rotation_track(0, 35)
		event.rotate_object_sequence(0, 0.0, 0.72, 0.0, 5)
		wait_objects(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "はしご登り", 2)
		helper_888ab2a3(40)
		event.set_object_handle_footstep_sound(0, 9)
		event.move_camera_sequence(385.44, 20.74, -469.02, 478.52, 129.61, -405.79, 180)
		event.wait_object_sequence_motion_end(0)
		wait_objects(0)
		wait_camera()
		event.set_camera_sequence_position(490.63, 181.9, -336.25)
		event.set_camera_sequence_look_at(424.28, 114.59, -295.7)
		event.set_object_sequence_position(0, 441.37, 133.45, -339.86)
		event.set_object_sequence_rotation(0, 0.0, 0.41, 0.0)
		event.move_object_sequence(0, 459.04, 133.45, -308.23, 40)
		event.set_object_handle_shadow_enabled(5, 1)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_sequence_motion(0, "右向き歩き", 6)
		event.queue_object_sequence_next_motion(0, "右を向く", 6)
		event.queue_object_sequence_next_motion(0, "右を向くL", 4)
		event.delay_object_sequence_sound_track(0, 40)
		event.play_object_sequence_sound(0, var0, 9)
		helper_183cf34f(0, 1034, 8, 200, 200, 60)
		wait_objects(0)
		wait_camera()
		event.move_camera_sequence(492.91, 169.38, -343.35, 431.02, 155.35, -293.19, 200)
		event.slow_down_camera_sequence_position(0.94, 30)
		wait_camera()
		helper_888ab2a3(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(60)
		wait_camera()
	end)
	vm.entry(27)
	event.cancel_drama_scene_skip()
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
local function helper_eef0()
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
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
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
		event.start_background_file_loads_1("event/opening/p2/p2_pierrot.gltf")
		at = 2
		vm.wait(2)
		at = 3
		helper_479dc9e9()
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.set_object_handle_sound_bank(1, var0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_sound_bank(2, var0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, var0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 12)
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
		at = 4
		wait_camera()
		event.set_camera_sequence_position(0.0, 30.0, -180.0)
		event.set_camera_sequence_look_at(0.0, 30.0, 0.0)
		event.set_object_sequence_motion(0, "投げ４回からTポーズ", 6)
		event.queue_object_sequence_next_motion(0, "Tポーズ", 4)
		at = 5
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
		at = 6
		helper_888ab2a3(10)
		event.set_object_sequence_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "着地ループ", 4)
		at = 7
		helper_888ab2a3(10)
		event.set_object_sequence_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "着地ループ", 4)
		at = 8
		helper_888ab2a3(10)
		event.set_object_sequence_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "着地ループ", 4)
		event.set_object_handle_shadow_enabled(1, 1)
		at = 9
		helper_888ab2a3(12)
		event.set_object_handle_shadow_enabled(2, 1)
		at = 10
		helper_888ab2a3(12)
		event.set_object_handle_shadow_enabled(3, 1)
		at = 11
		helper_888ab2a3(12)
		event.set_object_handle_shadow_enabled(4, 1)
		event.set_object_sequence_motion(0, "Tポーズから決め", 6)
		event.queue_object_sequence_next_motion(0, "決めループ", 6)
		event.wait_object_sequence_motion_end(0)
		at = 12
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
		at = 13
		wait_objects(0)
		at = 14
		wait_objects(1)
		at = 15
		wait_objects(2)
		at = 16
		wait_objects(3)
		at = 17
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
		at = 18
		helper_888ab2a3(3)
		event.set_object_sequence_motion(3, "走り")
		event.move_object_sequence(3, 90.31, 11.23, -38.89, 30)
		event.rotate_object_sequence(3, 0.0, 2.18, 0.0, 10)
		at = 19
		helper_888ab2a3(2)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -90.31, 11.23, -38.89, 15)
		event.rotate_object_sequence(1, 0.0, -2.18, 0.0, 10)
		event.set_object_sequence_motion(4, "走り")
		event.move_object_sequence(4, 90.31, 11.23, -38.89, 15)
		event.rotate_object_sequence(4, 0.0, 2.18, 0.0, 10)
		at = 20
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		at = 21
		wait_objects(4)
		event.set_object_sequence_motion(4, "立ち")
		at = 22
		wait_objects(2)
		event.set_object_sequence_motion(2, "立ち")
		at = 23
		wait_objects(3)
		event.set_object_sequence_motion(3, "立ち")
		at = 24
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
		at = 25
		wait_objects(5)
		event.set_object_sequence_motion(5, "パオーン", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.delay_object_sequence_sound_track(5, 20)
		event.play_object_sequence_sound(5, var0, 7)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, var0, 8)
		at = 26
		helper_888ab2a3(62)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		at = 27
		wait_objects(5)
		at = 28
		wait_camera()
		event.start_background_file_loads_2("event/opening/p2/p2_bura_pie.gltf", "event/opening/p2/p2_buranko.gltf")
		event.set_object_sequence_motion(7, "歩き", 4)
		event.set_object_sequence_position(7, 15.06, 11.23, -91.33)
		event.set_object_sequence_rotation(7, 0.0, -0.96, 0.0)
		event.delay_object_sequence_rotation_track(7, 80)
		event.rotate_object_sequence(7, 0.0, -1.8, 0.0, 10)
		event.move_object_sequence(7, -68.07, 11.23, -40.78, 90)
		at = 29
		wait_objects(7)
		event.set_object_sequence_motion(7, "登場ポーズ", 2)
		event.wait_object_sequence_motion_end(7)
		event.move_camera_sequence(-131.01, 23.7, -59.75, -0.22, 39.36, -20.34, 143)
		at = 30
		wait_camera()
		at = 31
		wait_objects(7)
		event.set_object_sequence_motion(7, "歩き")
		event.move_object_sequence(7, -31.47, 11.23, -3.92, 60)
		event.rotate_object_sequence(7, 0.0, 0.72, 0.0, 10)
		at = 32
		wait_objects(7)
		event.set_object_sequence_motion(5, "ごにょごごにょ", 2)
		event.queue_object_sequence_next_motion(5, "ごにょごにょループ", 4)
		event.rotate_object_sequence(7, 0.0, 1.32, 0.0, 20)
		event.set_object_sequence_motion(7, "ごにょごにょ", 2)
		event.queue_object_sequence_next_motion(7, "ごにょごにょL", 6)
		event.wait_object_sequence_motion_end(7)
		event.delay_object_sequence_sound_track(7, 10)
		event.play_object_sequence_sound(7, var0, 9)
		at = 33
		wait_objects(7)
		event.set_camera_sequence_position(-40.25, 30.96, -47.72)
		event.set_camera_sequence_look_at(-5.49, 44.23, -27.58)
		event.set_character_active(0, 13)
		event.set_character_active(1, 16)
		event.play_object_sequence_sound(5, var0, 10)
		at = 34
		helper_888ab2a3(60)
		event.set_camera_sequence_position(0.0, 95.44, -190.42)
		event.set_camera_sequence_look_at(0.0, 62.65, 0.0)
		event.set_character_active(1, 13)
		event.set_character_active(0, 16)
		event.set_object_sequence_motion(5, "玉持ち上げ", 6)
		event.queue_object_sequence_next_motion(5, "玉持ち上げループ", 4)
		event.play_object_sequence_sound(5, var0, 11)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, var0, 12)
		event.set_object_sequence_position(6, 0.0, 11.23, -30.0)
		event.set_object_sequence_motion(6, "玉持ち上げ", 6)
		event.queue_object_sequence_next_motion(6, "玉持ち上げループ", 4)
		event.set_object_sequence_rotation(7, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(7, "歩き", 4)
		event.rotate_object_sequence(7, 0.0, -1.57, 0.0, 20)
		event.move_object_sequence(7, -132.5, 11.23, 0.93, 90)
		at = 35
		wait_objects(7)
		event.set_character_active(0, 15)
		event.set_camera_sequence_position(0.4, 14.44, -179.22)
		event.set_camera_sequence_look_at(0.0, 67.37, 0.0)
		event.set_object_sequence_motion(5, "バイシクルシュート", 6)
		event.set_object_sequence_motion(6, "バイシクルシュート", 6)
		at = 36
		helper_888ab2a3(70)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		at = 37
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
			at = 38
			vm.wait(38)
		end
		event.set_character_active(17)
		event.set_object_sequence_motion(9, "キラーン", 6)
		event.play_object_sequence_sound(5, var0, 13)
		at = 39
		helper_888ab2a3(10)
		event.set_character_active(0, 17)
		at = 40
		helper_888ab2a3(10)
		event.set_camera_sequence_position(-168.96, 18.9, -103.54)
		event.set_camera_sequence_look_at(-5.14, 75.4, 8.39)
		event.set_character_active(1, 13)
		event.set_character_active(0, 16)
		event.set_object_sequence_motion(5, "バイシクルシュート", 2)
		event.set_object_sequence_motion(6, "バイシクルシュート", 2)
		event.play_object_sequence_sound(5, var0, 14)
		at = 41
		helper_888ab2a3(9)
		event.set_object_sequence_motion_step(5, 0.01)
		event.set_object_sequence_motion_step(6, 0.01)
		event.set_camera_sequence_position(-197.04, 171.4, 0.74)
		event.set_camera_sequence_look_at(0.0, 121.4, 0.0)
		event.move_camera_sequence_angle_height_distance(1.57, 0.0, 197.04, 100)
		event.move_camera_sequence_angle_height_distance(3.14, -25.0, 197.04, 50)
		event.move_camera_sequence_angle_height_distance(-1.57, -50.0, 197.04, 50)
		at = 42
		wait_camera()
		event.set_object_sequence_motion_step(5, 0.6)
		event.set_object_sequence_motion_step(6, 0.6)
		event.wait_object_sequence_motion_end(5)
		event.play_object_sequence_sound(5, var0, 15)
		at = 43
		helper_888ab2a3(5)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		at = 44
		wait_camera()
		at = 45
		wait_objects(5)
		event.set_camera_sequence_position(-120.33, 279.87, -18.7)
		event.set_camera_sequence_look_at(138.46, 217.78, 141.95)
		event.set_object_sequence_position(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(6, "右のピエロ", 6)
		event.delay_object_sequence_sound_track(6, 10)
		event.play_object_sequence_sound(6, var0, 16)
		at = 46
		helper_888ab2a3(20)
		event.set_camera_sequence_position(87.54, 42.85, 80.82)
		event.set_camera_sequence_look_at(-204.62, 211.5, 188.69)
		event.set_object_sequence_motion(6, "左のピエロ", 6)
		event.delay_object_sequence_sound_track(6, 10)
		event.play_object_sequence_sound(6, var0, 16)
		at = 47
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
		at = 48
		helper_888ab2a3(50)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		at = 49
		wait_objects(5)
		event.play_object_sequence_sound(5, var0, 18)
		event.set_camera_sequence_position(-55.0, 150.0, 230.0)
		event.set_camera_sequence_look_at(0.0, 50.0, -30.0)
		event.move_camera_sequence(55.0, 150.0, 230.0, 0.0, 50.0, -30.0, 120)
		at = 50
		wait_camera()
		event.set_camera_sequence_position(37.29, 24.91, -191.53)
		event.set_camera_sequence_look_at(5.05, 69.55, -9.71)
		event.set_object_sequence_motion(6, "キャッチ＆決め終わり", 6)
		event.set_object_sequence_motion(5, "キャッチ＆決め終わり", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		at = 51
		helper_888ab2a3(30)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
		at = 52
		wait_camera()
		at = 53
		wait_objects(5)
		at = 54
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
		at = 55
		wait_camera()
		event.set_character_active(0, 13)
		event.set_camera_sequence_follow_object(0, 0.0, 14.0, 0.0, -2.67, 31.0, 140.0, "skin")
		at = 56
		helper_888ab2a3(60)
		event.stop_sound_effect(var0, 19)
		event.play_sound_effect(var0, 20)
		event.set_object_sequence_motion(0, "ピエロブランコ", 6)
		event.set_object_sequence_motion(1, "ピエロブランコ", 6)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, var0, 21)
		event.delay_object_sequence_sound_track(0, 50)
		event.play_object_sequence_sound(0, var0, 21)
		at = 57
		helper_888ab2a3(60)
		at = 58
		helper_888ab2a3(40)
		event.move_camera_sequence_angle_height_distance(-3.14, 0.0, 140.0, 60)
		at = 59
		helper_888ab2a3(90)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02")
		event.set_object_handle_visible(31, 0)
		event.release_camera_sequence_follow_object()
		event.play_object_sequence_sound(0, var0, 25)
		event.move_camera_sequence(145.04, 229.37, -319.27, -156.54, 156.11, -23.11, 60)
		at = 60
		wait_camera()
		event.set_camera_sequence_position(0.0, 237.95, -275.71)
		event.set_camera_sequence_look_at(0.0, 212.96, -32.39)
		event.set_object_sequence_position(0, 170.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 170.0, 0.0, 0.0)
		at = 61
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
		at = 62
		helper_888ab2a3(50)
		event.set_object_handle_visible(31, 1)
		at = 63
		wait_camera()
		event.set_camera_sequence_position(0.0, 53.51, -115.19)
		event.set_camera_sequence_look_at(0.0, 35.43, 0.41)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		at = 64
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
		at = 65
		wait_objects(7)
		at = 66
		helper_888ab2a3(30)
		event.move_camera_sequence_eased(-391.9, 285.91, -201.78, 1.6, 40.06, 1.5, 90, 0, 0.2)
		at = 67
		wait_camera()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		at = 68
		wait_camera()
	end, function(received: { any }): boolean
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_344d6cd8()
		end
		if at <= 4 then
			helper_038a2e4d(26)
		end
		if at <= 5 then
			helper_038a2e4d(10)
		end
		if at <= 6 then
			helper_038a2e4d(10)
		end
		if at <= 7 then
			helper_038a2e4d(10)
		end
		if at <= 8 then
			helper_038a2e4d(12)
		end
		if at <= 9 then
			helper_038a2e4d(12)
		end
		if at <= 10 then
			helper_038a2e4d(12)
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			helper_238b5abc(1)
		end
		if at <= 14 then
			helper_238b5abc(2)
		end
		if at <= 15 then
			helper_238b5abc(3)
		end
		if at <= 16 then
			helper_238b5abc(4)
		end
		if at <= 17 then
			helper_038a2e4d(3)
		end
		if at <= 18 then
			helper_038a2e4d(2)
		end
		if at <= 19 then
			helper_238b5abc(1)
		end
		if at <= 20 then
			helper_238b5abc(4)
		end
		if at <= 21 then
			helper_238b5abc(2)
		end
		if at <= 22 then
			helper_238b5abc(3)
		end
		if at <= 23 then
			helper_238b5abc(5)
		end
		if at <= 24 then
			helper_238b5abc(5)
		end
		if at <= 25 then
			helper_038a2e4d(62)
		end
		if at <= 26 then
			helper_238b5abc(5)
		end
		if at <= 27 then
			helper_344d6cd8()
		end
		if at <= 28 then
			helper_238b5abc(7)
		end
		if at <= 29 then
			helper_344d6cd8()
		end
		if at <= 30 then
			helper_238b5abc(7)
		end
		if at <= 31 then
			helper_238b5abc(7)
		end
		if at <= 32 then
			helper_238b5abc(7)
		end
		if at <= 33 then
			helper_038a2e4d(60)
		end
		if at <= 34 then
			helper_238b5abc(7)
		end
		if at <= 35 then
			helper_038a2e4d(70)
		end
		if at <= 36 then
			helper_038a2e4d(29)
		end
		if at <= 37 then
			var1 = 0
			var2 = vm.f32(0.8)
			pos_y = vm.f32(-2.07)
			var2 = vm.f32(var2 * vm.f32(0.8))
			pos_y = vm.f32(pos_y - var2)
			local _ = var1 < 10
			var1 = var1 + 1
			print(vm.float(pos_y), "\n")
		end
		if at <= 38 then
			helper_038a2e4d(10)
		end
		if at <= 39 then
			helper_038a2e4d(10)
		end
		if at <= 40 then
			helper_038a2e4d(9)
		end
		if at <= 41 then
			helper_344d6cd8()
		end
		if at <= 42 then
			helper_038a2e4d(5)
		end
		if at <= 43 then
			helper_344d6cd8()
		end
		if at <= 44 then
			helper_238b5abc(5)
		end
		if at <= 45 then
			helper_038a2e4d(20)
		end
		if at <= 46 then
			helper_038a2e4d(20)
		end
		if at <= 47 then
			helper_038a2e4d(50)
		end
		if at <= 48 then
			helper_238b5abc(5)
		end
		if at <= 49 then
			helper_344d6cd8()
		end
		if at <= 50 then
			helper_038a2e4d(30)
		end
		if at <= 51 then
			helper_344d6cd8()
		end
		if at <= 52 then
			helper_238b5abc(5)
		end
		if at <= 53 then
			helper_344d6cd8()
		end
		if at <= 54 then
			helper_344d6cd8()
		end
		if at <= 55 then
			helper_038a2e4d(60)
		end
		if at <= 56 then
			helper_038a2e4d(60)
		end
		if at <= 57 then
			helper_038a2e4d(40)
		end
		if at <= 58 then
			helper_038a2e4d(90)
		end
		if at <= 59 then
			helper_344d6cd8()
		end
		if at <= 60 then
			helper_038a2e4d(20)
		end
		if at <= 61 then
			helper_038a2e4d(50)
		end
		if at <= 62 then
			helper_344d6cd8()
		end
		if at <= 63 then
			helper_238b5abc(7)
		end
		if at <= 64 then
			helper_238b5abc(7)
		end
		if at <= 65 then
			helper_038a2e4d(30)
		end
		if at <= 66 then
			helper_344d6cd8()
		end
		if at <= 67 then
			helper_344d6cd8()
		end
		return true
	end)
	at = 69
	vm.entry(69)
	event.cancel_drama_scene_skip()
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
	event.stop_sound_effect(var0, 19)
	event.stop_sound_effect(var0, 28)
	event.stop_sound_effect(var0, 29)
	event.stop_environment_music()
	at = 70
	helper_888ab2a3(6)
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
		at = 1
		helper_b8ac()
		at = 2
		helper_eef0()
		event.load_event_script("i03h02/i03h02_2.stb", 151)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_eef0()
				return vm.continue_with(function()
					event.load_event_script("i03h02/i03h02_2.stb", 151)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
