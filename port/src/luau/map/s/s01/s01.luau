--!strict
-- map/s/s01/s01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_08ac1dd6 = require("@lib/event/helper_08ac1dd6")
local helper_0c718064 = require("@lib/event/helper_0c718064")
local helper_18c31a0e = require("@lib/event/helper_18c31a0e")
local helper_21e37ba4 = require("@lib/event/helper_21e37ba4")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_24692f72 = require("@lib/event/helper_24692f72")
local helper_28d4ec9f = require("@lib/event/helper_28d4ec9f")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4d5a4434 = require("@lib/event/helper_4d5a4434")
local helper_86ac6534 = require("@lib/event/helper_86ac6534")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	flag = event.get_save_flag(202) or flag
	if flag == 0 then
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.set_object_handle_position(0, 0.0, 0.0, -2000.0)
	end
end

--- Helper function.
local function helper_ebc4()
	vm.section(function()
		event.set_save_flag(201, 1)
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_message_window_mode(0, 7)
		event.load_character_motion_pack(5, "event/e200/e201/e201_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.fade_out_screen(0)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(111)
		event.play_music(0)
		event.set_camera_sequence_position(-560.0, 157.51, -568.46)
		event.set_camera_sequence_look_at(-560.0, 157.27, -483.32)
		event.fade_in_screen(30)
		event.enable_drama_skip()
		event.attach_object_handle_to_map_part_2(10, "p01_train01")
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_position(10, 0.0, -24.0, -1000.0)
		event.set_object_sequence_position(0, -560.0, 132.17, -500.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, -560.0, 132.17, -300.0, 270)
		helper_888ab2a3(285)
		event.set_object_sequence_position(0, -560.0, 132.17, -300.0)
		event.move_object_sequence(0, -560.0, 132.17, -100.0, 255)
		event.set_camera_sequence_follow_object(0, 0.0, 25.0, 0.0, 0.55, -1.91, 34.9)
		helper_888ab2a3(165)
		event.set_object_handle_footstep_sound(0, -1)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(90, 200, 200, 200)
		helper_888ab2a3(90)
		event.release_camera_sequence_follow_object()
		event.clear_camera_sequence()
		event.set_camera_sequence_look_at(-567.88, 154.74, -22.62)
		event.set_camera_sequence_angle_height_distance(1.68, -0.34, 88.57)
		event.move_camera_sequence_angle_height_distance_eased(-1.72, -0.34, 88.57, 360, 0, 0.2)
		event.fade_in_camera_sequence(90, 200, 200, 200)
		helper_888ab2a3(450)
		event.set_object_sequence_position(0, -560.0, 132.17, -200.0)
		event.move_object_sequence(0, -560.0, 132.17, -100.0, 120)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-785.67, 205.49, 52.24)
		event.set_camera_sequence_look_at(-512.83, 162.33, -212.01)
		helper_888ab2a3(30)
		event.move_camera_sequence_eased(-3101.09, 205.49, 1822.12, -512.83, 162.33, -212.01, 210, 0, 0.2)
		helper_888ab2a3(90)
		event.set_object_sequence_position(0, -560.0, 132.17, -100.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		helper_888ab2a3(190)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.delete_character_extension_packs(0)
	event.release_camera_sequence_follow_object()
	event.set_camera_position(-559.4, 187.73, -249.37)
	event.set_camera_look_at(-556.51, 162.33, -127.3)
	event.set_character_position(0, -557.84, 132.17, -142.95)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	vm.wait(10)
	event.set_object_handle_footstep_sound(0, 0)
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(193)
	event.play_music(0)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_16160()
	event.initialize_event()
	vm.wait(1)
	event.fade_in_screen(15)
	event.set_camera_sequence_position(-564.69, 162.76, -362.47)
	event.set_camera_sequence_look_at(-556.95, 162.37, -243.12)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -558.43, 132.37, -264.95)
	event.set_object_sequence_rotation(0, 0.0, 0.13, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.move_object_sequence(0, -556.95, 132.37, -243.12, 30)
	helper_888ab2a3(30)
	event.reset_follow_camera(0)
end

--- Helper function.
local function helper_e52c()
	event.initialize_event()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -215.0, 12.66, 60.0)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "走り")
	event.set_object_sequence_texture_animation(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, -24.0, -1800.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_time_of_day(7.0)
	event.set_time_of_day_advancing(1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-746.57, 16.36, 156.44)
	event.set_camera_sequence_look_at(-199.21, 142.65, 471.29)
	helper_888ab2a3(30)
	event.move_camera_sequence(-701.67, 16.36, 428.3, -154.32, 142.65, 743.14, 400)
	event.move_object_sequence(0, -215.0, 12.66, 1700.0, 460)
	event.move_object_sequence(1, 0.0, -24.0, 5000.0, 260)
	wait_camera()
	helper_c956b4a2(32)
end

--- Helper function.
local function helper_123a0()
	helper_18c31a0e()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.clear_camera_sequence()
	event.load_character_motion_pack(5, "event/e200/e202/e202_mints.gltf", "info", 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.load_character(5, "event/e200/e202/e202_starbre.gltf", "info", 9)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 9)
	event.load_character(5, "event/e200/e202/e202_train_pika.gltf", "info", 10)
	event.set_character_active(0, 10)
	event.attach_object_handle_to_map_part_2(2, "p01_train01")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "train07-m0")
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "train07-m1")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "train08-m2")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.attach_object_handle_to_map_part_3(6, "p01_train01", "train08-m3")
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.attach_object_handle_to_map_part_3(7, "p01_train01", "train08-m7")
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.attach_object_handle_to_map_part_3(8, "p01_train01", "train08-m6")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_3(9, "p01_train01", "train10-m2")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_3(22, "p01_train01", "train10-m3")
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.attach_object_handle_to_map_part_3(23, "p01_train01", "train10-m7")
	event.clear_object_sequence(23)
	event.set_object_sequence_object(23, 23)
	event.attach_object_handle_to_map_part_3(24, "p01_train01", "train10-m6")
	event.clear_object_sequence(24)
	event.set_object_sequence_object(24, 24)
	helper_4d5a4434()
	event.initialize_effect_manager(5)
	event.load_effect_base("列車煙")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(2, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 2)
	event.load_message_file(0, 5, "event/e200/e202/e202.txt")
end

--- Helper function.
local function helper_11324(se_id: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	do
		local out1, out2, out3 = event.get_object_handle_position(3)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_sequence_position(3, pos_x - 50.0, pos_y, pos_z)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.08726647)
	event.set_object_sequence_rotation(5, 0.0, -1.5707964, 0.0)
	event.set_object_sequence_rotation(6, 0.0, 1.5707964, 0.0)
	event.set_object_sequence_rotation(22, 0.0, -1.5707964, 0.0)
	event.set_object_sequence_rotation(9, 0.0, 1.5707964, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.set_object_sequence_motion(1, "歩き", 4)
	event.set_object_handle_footstep_sound(0, 6)
	event.set_object_handle_footstep_sound(1, 6)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 90)
	event.add_object_sequence_path_point(0, -160.36, 2.7, 634.04)
	event.add_object_sequence_path_point(0, -124.87, 2.7, 630.96)
	event.add_object_sequence_path_point(0, -89.31, 4.88, 627.74)
	event.add_object_sequence_path_point(0, -78.59, 9.51, 627.52)
	event.add_object_sequence_path_point(0, -58.26, 12.02, 627.52)
	event.add_object_sequence_path_point(0, -23.27, 22.08, 626.47)
	event.start_object_sequence_path(0)
	event.clear_object_sequence_path(1)
	event.set_object_sequence_path_frames(1, 90)
	event.add_object_sequence_path_point(1, -117.93, 2.01, 644.18)
	event.add_object_sequence_path_point(1, -87.39, 5.06, 643.55)
	event.add_object_sequence_path_point(1, -79.65, 10.25, 643.38)
	event.add_object_sequence_path_point(1, -61.53, 13.02, 643.01)
	event.add_object_sequence_path_point(1, -15.8, 26.38, 642.06)
	event.start_object_sequence_path(1)
	helper_888ab2a3(72)
	event.set_object_handle_footstep_sound(0, 4)
	event.set_object_handle_footstep_sound(1, 4)
	event.play_sound_effect(se_id, 12)
	event.rotate_object_sequence(6, 0.0, 0.0, 0.0, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, 0.0, 30)
	event.rotate_object_sequence(22, 0.0, 0.0, 0.0, 30)
	event.rotate_object_sequence(9, 0.0, 0.0, 0.0, 30)
	helper_888ab2a3(20)
	event.rotate_object_sequence(0, 0.0, 3.03, 0.0, 30)
	helper_888ab2a3(10)
	helper_888ab2a3(15)
	event.play_sound_effect(se_id, 13)
	event.rotate_object_sequence(3, 0.0, 0.0, 0.0, 30)
	helper_888ab2a3(30)
	event.play_sound_effect(se_id, 14)
	event.move_object_sequence(3, pos_x, pos_y, pos_z, 60)
	helper_888ab2a3(60)
	helper_888ab2a3(15)
end

--- Helper function.
local function helper_10848(se_id: s32)
	event.set_camera_sequence_position(3.45, 77.44, 1389.54)
	event.set_camera_sequence_look_at(3.0, 63.96, 1261.17)
	for var1 = 0, 11 do
		event.rotate_object_sequence(10 + var1, 0.03, 0.0, 0.0, -1)
	end
	event.play_sound_effect(se_id, 15)
	event.set_object_sequence_position(2, 0.0, -24.0, 500.0)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.set_character_active(1, 10)
	event.set_character_position(10, 1.55, 41.98, 824.64)
	event.set_character_motion(10, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	helper_888ab2a3(30)
	event.set_character_active(0, 10)
	event.move_object_sequence_eased(2, 0.0, -24.0, 5000.0, 360, 1, 0.7)
	event.play_sound_effect(se_id, 16)
	event.set_camera_sequence_position(-423.7, 77.44, 613.24)
	event.set_camera_sequence_look_at(-149.56, 63.96, 588.35)
	helper_888ab2a3(75)
	event.set_camera_sequence_position(3.45, 77.44, 1389.54)
	event.set_camera_sequence_look_at(3.0, 63.96, 1261.17)
	event.move_camera_sequence_eased(4.3, 77.44, 1631.73, 3.0, 63.96, 1261.17, 75, 2, 0.2)
	helper_888ab2a3(75)
	event.set_camera_sequence_position(-741.43, 330.34, 349.51)
	event.set_camera_sequence_look_at(-180.96, 187.05, 261.6)
	event.move_camera_sequence_eased(-741.43, 330.34, 349.51, -335.86, 187.05, 767.89, 90, 2, 0.4)
	helper_888ab2a3(150)
	event.clear_camera_sequence()
	event.delay_camera_sequence_fade_track(135)
	event.fade_out_camera_sequence(30, 0.0, 0.0)
	event.move_camera_sequence_eased(-1416.81, 608.29, -321.97, -333.28, 187.05, 759.45, 120, 0, 0.4)
	helper_888ab2a3(165)
	event.clear_camera_sequence()
	helper_888ab2a3(180)
end

--- Helper function.
local function helper_22100000(arg0: s32)
	helper_038a2e4d(72)
	helper_038a2e4d(20)
	helper_038a2e4d(10)
	helper_038a2e4d(15)
	helper_038a2e4d(30)
	helper_038a2e4d(60)
	helper_038a2e4d(15)
end

--- Helper function.
local function helper_22200000(arg0: s32)
	local var1: s32 = 0
	var1 = 0
	local _ = var1 < 12
	var1 = var1 + 1
	helper_038a2e4d(30)
	helper_038a2e4d(75)
	helper_038a2e4d(75)
	helper_038a2e4d(150)
	helper_038a2e4d(165)
	helper_038a2e4d(180)
end

--- Helper function.
local function helper_13074()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(202, 1)
		event.initialize_event()
		var0 = event.load_sound_effect_file_2(1837) or var0
		helper_123a0()
		event.set_object_handle_footstep_sound(0, 0)
		event.stop_music(0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(-339.31, 136.54, 364.85)
		event.set_camera_sequence_look_at(-238.55, 35.08, 513.89)
		event.set_object_sequence_position(0, -198.33, 13.59, 420.19)
		event.set_object_sequence_rotation(0, 0.0, -0.35, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ぼうぜん顔")
		event.set_object_sequence_texture_animation(0, 1, "つうじょう目パチ")
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 160)
		event.add_object_sequence_path_point(0, -198.33, 13.59, 420.19)
		event.add_object_sequence_path_point(0, -203.12, 13.59, 502.05)
		event.add_object_sequence_path_point(0, -216.28, 13.59, 545.08)
		event.add_object_sequence_path_point(0, -238.62, 13.59, 586.39)
		event.start_object_sequence_path(0)
		event.set_object_handle_footstep_sound(0, 15)
		at = 2
		helper_888ab2a3(30)
		event.set_object_handle_footstep_sound(0, 2)
		at = 3
		helper_888ab2a3(90)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_camera_sequence_position(-157.69, 69.09, 657.85)
		event.set_camera_sequence_look_at(-309.71, 39.39, 635.31)
		event.set_object_sequence_position(0, -218.73, 13.59, 644.79)
		event.set_object_sequence_rotation(0, 0.0, -1.67, 0.0)
		event.move_object_sequence(0, -301.77, 13.77, 637.45, 60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(-157.69, 69.09, 657.85, -309.71, 39.39, 635.31)
		event.add_camera_sequence_path_point(-182.29, 46.57, 654.2, -309.71, 39.39, 635.31)
		event.add_camera_sequence_path_point(-226.21, 39.3, 647.69, -309.71, 39.39, 635.31)
		event.start_camera_sequence_path()
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち", 0)
		at = 4
		helper_888ab2a3(150)
		at = 5
		helper_4116e6bb(2020010)
		event.set_camera_sequence_position(-325.02, 31.34, 616.64)
		event.set_camera_sequence_look_at(-305.34, 35.79, 635.58)
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		at = 6
		helper_4116e6bb(2020020)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.set_camera_sequence_position(-333.76, 40.57, 633.22)
		event.set_camera_sequence_look_at(-302.99, 37.72, 637.65)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "通常目～うれし目")
		event.set_object_sequence_texture_animation(0, 1, "半口～うれし開き")
		at = 7
		helper_888ab2a3(15)
		event.set_object_sequence_texture_animation(0, 1, "きらきら目")
		event.move_camera_sequence_eased(-326.11, 40.57, 634.32, -302.99, 37.72, 637.65, 90, 2, 0.4)
		at = 8
		helper_4116e6bb(2020030)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "まえ向き～左むき")
		event.play_sound_effect(var0, 6)
		event.set_object_sequence_motion(0, "振り返る", 6, -1.0, 1)
		at = 9
		helper_888ab2a3(10)
		event.clear_camera_sequence()
		helper_08ac1dd6(2200.0, 220)
		event.set_camera_sequence_position(-331.99, 42.11, 682.27)
		event.set_camera_sequence_look_at(-281.67, 40.37, 620.78)
		event.play_sound_effect(var0, 8)
		at = 10
		helper_888ab2a3(50)
		event.set_object_sequence_motion(0, "振り返るL", 6, -1.0, 1)
		at = 11
		helper_888ab2a3(70)
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_motion(0, "列車を見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "列車を見るL", 0)
		at = 12
		helper_888ab2a3(120)
		event.set_camera_sequence_position(-704.28, 74.53, 644.02)
		event.set_camera_sequence_look_at(-229.0, 60.03, 630.45)
		event.set_object_handle_shadow_enabled(0, 0)
		event.set_object_handle_shadow_enabled(1, 0)
		at = 13
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-272.98, 32.08, 611.38)
		event.set_camera_sequence_look_at(-292.01, 32.94, 630.57)
		event.set_object_sequence_rotation(0, 0.0, 1.93, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_motion(0, "キョロキョロ", 4, -1.0, 1)
		at = 14
		helper_888ab2a3(40)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-344.7, 43.98, 674.78)
		event.set_camera_sequence_look_at(-270.62, 44.19, 558.35)
		event.set_object_sequence_rotation(0, 0.0, 1.69, 0.0)
		event.set_object_sequence_position(1, -57.93, 11.86, 130.81)
		event.set_object_sequence_rotation(1, 0.0, -1.55, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_z = vm.f32(pos_z + vm.f32(-517.642))
		event.set_object_sequence_position(4, pos_x - 50.0, pos_y, pos_z)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.08726647)
		event.play_sound_effect(var0, 9)
		event.rotate_object_sequence(8, 0.0, -1.57, 0.0, 30)
		event.rotate_object_sequence(7, 0.0, 1.57, 0.0, 30)
		event.rotate_object_sequence(24, 0.0, -1.57, 0.0, 30)
		event.rotate_object_sequence(23, 0.0, 1.57, 0.0, 30)
		event.set_object_sequence_motion(0, "左を見る", 6)
		event.queue_object_sequence_next_motion(0, "左を見るL", 0)
		at = 15
		helper_888ab2a3(30)
		at = 16
		helper_888ab2a3(30)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 15)
		event.add_object_sequence_path_point(1, -58.2, 12.83, 120.56)
		event.add_object_sequence_path_point(1, -71.49, 12.83, 120.23)
		event.start_object_sequence_path(1)
		at = 17
		helper_888ab2a3(15)
		event.set_object_sequence_position(4, pos_x, pos_y, pos_z)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(24, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(23, 0.0, 0.0, 0.0)
		event.set_character_active(1, 0)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-429.29, 148.18, 653.31)
		event.set_camera_sequence_look_at(-322.93, 59.6, 619.28)
		event.set_object_sequence_rotation(0, 0.0, 2.65, 0.0)
		event.set_object_sequence_position(1, -223.19, 13.78, 510.23)
		event.set_object_sequence_rotation(1, 0.0, -0.5, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.move_object_sequence(1, -268.59, 13.78, 585.68, 75)
		at = 18
		helper_888ab2a3(75)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_camera_sequence_position(-291.41, 39.19, 607.31)
		event.set_camera_sequence_look_at(-299.71, 35.93, 634.94)
		event.set_object_handle_shadow_enabled(0, 1)
		event.set_object_handle_shadow_enabled(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "きらきら目")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 19
		helper_4116e6bb(2020040)
		event.reset_mouth_texture_animations()
		at = 20
		wait_objects(0)
		event.set_camera_sequence_position(-315.4, 36.86, 675.88)
		event.set_camera_sequence_look_at(-291.69, 35.93, 632.9)
		event.set_object_sequence_rotation(0, 0.0, 2.29, 0.0)
		event.set_object_sequence_position(1, -271.9, 13.78, 616.69)
		event.set_object_sequence_rotation(1, 0.0, -0.98, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "腰に手", 6)
		event.queue_object_sequence_next_motion(1, "腰に手L", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 21
		helper_4116e6bb(2020050)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 22
		helper_4116e6bb(2020055)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "乗れ", 6)
		event.queue_object_sequence_next_motion(1, "乗れL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 23
		helper_4116e6bb(2020060)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 24
		helper_4116e6bb(2020065)
		event.reset_mouth_texture_animations()
		at = 25
		wait_objects(1)
		event.set_camera_sequence_position(-264.17, 27.45, 662.14)
		event.set_camera_sequence_look_at(-203.38, 37.55, 662.68)
		event.set_object_sequence_position(0, -269.3, 13.77, 637.92)
		event.set_object_sequence_rotation(0, 0.0, 1.57, 0.0)
		event.set_object_sequence_position(1, -273.23, 13.77, 651.56)
		event.set_object_sequence_rotation(1, 0.0, 1.44, 0.0)
		at = 26
		helper_11324(var0)
		event.set_character_active(0, 0)
		event.set_character_active(0, 9)
		at = 27
		helper_10848(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_28d4ec9f()
			helper_038a2e4d(30)
		end
		if at <= 2 then
			helper_038a2e4d(90)
		end
		if at <= 3 then
			helper_038a2e4d(150)
		end
		if at <= 4 then
			helper_8cd371d7(2020010)
		end
		if at <= 5 then
			helper_8cd371d7(2020020)
		end
		if at <= 6 then
			helper_038a2e4d(15)
		end
		if at <= 7 then
			helper_8cd371d7(2020030)
		end
		if at <= 8 then
			helper_038a2e4d(10)
		end
		if at <= 9 then
			helper_24692f72(2200.0, 220)
			helper_038a2e4d(50)
		end
		if at <= 10 then
			helper_038a2e4d(70)
		end
		if at <= 11 then
			helper_038a2e4d(120)
		end
		if at <= 12 then
			helper_038a2e4d(60)
		end
		if at <= 13 then
			helper_038a2e4d(40)
		end
		if at <= 14 then
			pos_z = vm.f32(pos_z + vm.f32(-517.642))
			helper_038a2e4d(30)
		end
		if at <= 15 then
			helper_038a2e4d(30)
		end
		if at <= 16 then
			helper_038a2e4d(15)
		end
		if at <= 17 then
			helper_038a2e4d(75)
		end
		if at <= 18 then
			helper_8cd371d7(2020040)
		end
		if at <= 19 then
			helper_238b5abc(0)
		end
		if at <= 20 then
			helper_8cd371d7(2020050)
		end
		if at <= 21 then
			helper_8cd371d7(2020055)
		end
		if at <= 22 then
			helper_8cd371d7(2020060)
		end
		if at <= 23 then
			helper_8cd371d7(2020065)
		end
		if at <= 24 then
			helper_238b5abc(1)
		end
		if at <= 25 then
			helper_22100000(var0)
		end
		if at <= 26 then
			helper_22200000(var0)
		end
		if at <= 27 then
			helper_86ac6534(var0)
			helper_86ac6534(var0)
			helper_86ac6534(var0)
			helper_86ac6534(var0)
			helper_86ac6534(var0)
			helper_86ac6534(var0)
		end
		return true
	end)
	at = 28
	vm.entry(28)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.stop_sound_effect(var0, 7)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	helper_18c31a0e()
	event.clear_effect_manager()
	event.reset_follow_camera(1, 0.0, 20.0)
end

--- Helper function.
local function helper_16508()
	local var2: s32 = 0
	event.set_dungeon_stage_id(0)
	event.open_event_menu(3, 0)
	vm.wait(1)
	do
		local _, _, out3, _ = event.get_menu_results_4()
		var2 = out3 or var2
	end
	if var2 == 0 then
		event.jump_to_map_2(-1, "d01e01")
		vm.wait(2)
	elseif var2 == 8 then
		helper_16160()
	else
		event.go_to_dungeon(0, var2, 1010)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	event_99()
	flag = event.get_save_flag(201) or flag
	if flag == 0 then
		event.set_dungeon_floor_info(0, 8, 7, 1)
		event.set_dungeon_floor_info(0, 8, 5, 2)
		helper_ebc4()
	else
		helper_16160()
	end
	helper_21e37ba4()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_e52c

--- Event 160, which map data, a script or the engine runs by number.
function script.event_160()
	event.fade_out_screen(30, 255.0, 255.0, 255.0)
	helper_888ab2a3(30)
	event.jump_to_map_2(-1, "g02")
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_13074()
		event.skip_next_music_load()
		event.jump_to_map_3(-1, "s08", 501)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_13074()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s08", 501)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_0c718064(2)
	helper_ebc4()
	helper_21e37ba4()
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	event.initialize_event()
	event.get_message_window_frame(0)
	event.set_message_window_mode(0, 5)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_motion(0, "立ち", 4)
	event.open_message_window_2(0, "『地下水道』に移動しますか？")
	var1 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
	if var1 == 0 then
		event.set_camera_sequence_position(-637.75, 234.47, 94.15)
		event.set_camera_sequence_look_at(-573.29, 154.14, -234.77)
		event.set_object_sequence_position(0, -571.45, 132.37, -243.31)
		event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_camera_sequence(-637.75, 234.47, 94.15, -561.56, 145.42, -381.61, 45)
		event.move_object_sequence(0, -570.49, 132.37, -362.93, 45)
		helper_888ab2a3(15)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		helper_16508()
		return 1
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	var2 = vm.f32(var2 + vm.f32(30.0 * vm.sin(0.0)))
	var4 = vm.f32(var4 + vm.f32(30.0 * vm.cos(0.0)))
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 15)
	event.move_object_sequence(0, var2, var3, var4, 45)
	for var5 = 0, 44 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.set_camera_sequence_look_at(var2, var3 + 30.0, var4)
		vm.wait(5)
	end
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_message_window_mode(0, 7)
	return 0
end

--- Event 601, which map data, a script or the engine runs by number.
function script.event_601()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var0 = vm.f32(var0 + vm.f32(30.0 * vm.sin(vm.f32(3.1415927))))
	var2 = vm.f32(var2 + vm.f32(30.0 * vm.cos(vm.f32(3.1415927))))
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.rotate_object_sequence(0, 0.0, 3.1415927, 0.0, 15)
	event.move_object_sequence(0, var0, var1, var2, 45)
	for var3 = 0, 44 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		event.set_camera_sequence_look_at(var0, var1 + 30.0, var2)
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "ここから先は危険だ\n列車で移動しよう。")
	show_message(0, -1, 5, 0, 0)
	event.set_message_bubble_tail(0, 1)
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_13074()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_13074()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 12010, which map data, a script or the engine runs by number.
script.event_12010 = helper_ebc4

--- Event 12020, which map data, a script or the engine runs by number.
function script.event_12020()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_13074()
		event.fade_out_screen(30)
		at = 3
		helper_888ab2a3(30)
		event.skip_next_music_load()
		event.jump_to_map_3(-1, "s08", 501)
		at = 4
		vm.wait(4)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				at = 2
				helper_13074()
				return vm.continue_with(function()
					event.fade_out_screen(30)
					at = 3
					helper_888ab2a3(30)
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s08", 501)
					at = 4
					vm.wait(4)
					return
				end)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			return 0
		end
		return nil
	end)
end

return script
