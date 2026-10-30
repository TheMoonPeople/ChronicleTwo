--!strict
-- map/s/s71/s71.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_1cddc()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.load_character(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(8, 40)
	event.clear_object_sequence(8, 40)
	event.set_object_sequence_object(8, 8)
	event.load_character(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(9, 41)
	event.clear_object_sequence(9, 41)
	event.set_object_sequence_object(9, 9)
	event.load_character(5, "event/e600/e616/e616_tama1.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.attach_object_handle_to_character(10, 42)
	event.clear_object_sequence(10, 42)
	event.set_object_sequence_object(10, 10)
	event.initialize_effect_manager(5)
	event.load_effect_base("Ｅ６１６月花ビームＢ")
	event.create_effect_work_buffer(5)
	event.load_character(5, "event/e600/e616/e616_iwa.gltf", "info", 43)
	event.set_character_active(0, 43)
	event.attach_object_handle_to_character(11, 43)
	event.clear_object_sequence(11, 43)
	event.set_object_sequence_object(11, 11)
	event.copy_character(5, 43, 44)
	event.set_character_active(0, 44)
	event.attach_object_handle_to_character(12, 44)
	event.clear_object_sequence(12, 44)
	event.set_object_sequence_object(12, 12)
	event.attach_object_handle_to_map_part_2(4, "p01_train01")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(14, "p04_s7101-0", "shadow-m")
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_12-m1")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.attach_object_handle_to_map_part_3(6, "p01_train01", "s3601_14-m6")
	event.set_object_sequence_object(6, 6)
	event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(7, "p01_train01", "s3601_16-m1")
	event.set_object_sequence_object(7, 7)
	event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(13, "p01_train01", "s3601_17-m")
	event.set_object_sequence_object(13, 13)
	event.set_object_sequence_rotation(13, 0.0, 0.0, 0.0)
	event.load_message_file(0, 5, "event/e600/e616/e616.txt")
end

--- Helper function.
local function helper_1c9e4()
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
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_character(43)
	event.delete_character(44)
	event.finish_event()
	vm.wait(1)
end

--- Helper function.
local function helper_1e6bc()
	local var6: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: s32 = 0
	local pos_x_2: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local pos_y_2: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local pos_z_2: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7202)
		var6 = event.load_sound_effect_file_2(7202) or var6
		helper_4337dd96()
		helper_1cddc()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_footstep_sound(2, 16)
		event.play_sound_effect(var6, 3)
		event.attach_object_handle_to_character_frame(20, 39, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_object_sequence_position(4, 790.0, 20.0, 4500.0)
		event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(8, 913.78, 1815.71, -1455.71)
		event.set_object_sequence_position(10, 913.78, 1815.71, -1455.71)
		event.set_object_sequence_rotation(10, 0.0, -0.04, 0.0)
		event.set_object_sequence_position(9, 347.12, 200.0, 1407.85)
		event.set_character_active(1, 40)
		event.play_sound_effect(var6, 0)
		event.set_object_sequence_motion(8, "入り", 6)
		event.queue_object_sequence_next_motion(8, "溜めループ", 4)
		event.set_camera_sequence_position(740.39, 361.22, 3768.25)
		event.set_camera_sequence_look_at(58.72, 398.27, 1944.66)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "走り")
		event.set_object_sequence_position(3, 607.53, 453.56, -239.32)
		event.set_object_sequence_rotation(3, 0.0, -2.56, 0.0)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 120)
		event.add_object_sequence_path_point(2, 0.0, 173.54, 2717.0)
		event.add_object_sequence_path_point(2, 0.0, 59.11, 3144.44)
		event.start_object_sequence_path(2, 1)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 140)
		event.add_object_sequence_path_point(1, 25.0, 189.22, 2617.0)
		event.add_object_sequence_path_point(1, 25.0, 49.45, 3179.82)
		event.start_object_sequence_path(1, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 130)
		event.add_object_sequence_path_point(0, -25.0, 184.27, 2667.0)
		event.add_object_sequence_path_point(0, -25.75, 51.4, 3172.67)
		event.start_object_sequence_path(0, 1)
		event.set_object_sequence_motion(3, "岩を投げる", 4)
		event.set_character_active(1, 43)
		event.set_character_active(1, 44)
		event.fade_in_screen(30)
		event.set_object_sequence_position(11, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(11, -200.0, 700.0, -1000.0, -1.2, 60)
		at = 1
		helper_888ab2a3(30)
		event.set_object_sequence_position(12, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(12, 200.0, 700.0, -1000.0, -1.2, 60)
		at = 2
		helper_888ab2a3(30)
		event.set_character_active(1, 42)
		event.play_sound_effect(var6, 1)
		event.set_object_sequence_motion(8, "発射", 6)
		event.set_object_sequence_motion(10, "弾道", 6)
		event.create_effect("Ｅ６１６月花ビームＢ")
		event.set_effect_first_vector(913.78, 1815.71, -1455.71)
		event.set_effect_second_vector(0.0, -0.04, 0.0)
		event.set_object_sequence_position(11, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(11, -200.0, 700.0, -1000.0, -1.2, 60)
		at = 3
		helper_888ab2a3(10)
		event.move_object_sequence(3, 395.57, 707.08, -157.89, 10)
		event.set_object_sequence_position(12, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(12, 200.0, 700.0, -1000.0, -1.2, 60)
		at = 4
		helper_888ab2a3(20)
		event.play_sound_effect(var6, 2)
		event.set_character_active(1, 41)
		event.set_character_motion(41, "ヒット", 6, -1, 1)
		at = 5
		helper_888ab2a3(30)
		event.set_object_sequence_position(11, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(11, -200.0, 700.0, -1000.0, -1.2, 60)
		at = 6
		helper_888ab2a3(30)
		event.set_object_sequence_position(12, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(12, 200.0, 700.0, -1000.0, -1.2, 60)
		at = 7
		helper_888ab2a3(30)
		event.set_camera_sequence_position(368.47, 270.27002, 3796.05)
		event.set_camera_sequence_look_at(296.74, 129.55, 4410.1)
		event.play_sound_effect(var6, 7)
		do
			local out1, out2, out3 = event.get_object_handle_position(13)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.rotate_object_sequence(5, 0.0, 0.0, 1.5707964, 30)
		event.rotate_object_sequence(6, 0.0, 0.0, 1.5707964, 30)
		event.rotate_object_sequence(7, 0.0, 0.0, -0.3926991, 30)
		event.rotate_object_sequence(13, 0.0, 0.0, -0.3926991, 30)
		at = 8
		helper_888ab2a3(30)
		event.move_object_sequence(13, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
		at = 9
		helper_888ab2a3(20)
		var10 = 2
		event.clear_object_sequence_path(var10)
		event.set_object_sequence_path_frames(var10, 120)
		event.add_object_sequence_path_point(var10, 272.66, 20.0, 4119.88)
		event.add_object_sequence_path_point(var10, 249.45, 20.0, 4367.87)
		event.add_object_sequence_path_point(var10, 241.61, 34.02, 4435.0)
		event.add_object_sequence_path_point(var10, 234.87, 48.2, 4492.6)
		event.start_object_sequence_path(var10)
		at = 10
		helper_888ab2a3(10)
		var10 = 0
		event.clear_object_sequence_path(var10)
		event.set_object_sequence_path_frames(var10, 120)
		event.add_object_sequence_path_point(var10, 272.66, 20.0, 4119.88)
		event.add_object_sequence_path_point(var10, 249.45, 20.0, 4367.87)
		event.add_object_sequence_path_point(var10, 241.61, 34.02, 4435.0)
		event.add_object_sequence_path_point(var10, 234.87, 48.2, 4492.6)
		event.start_object_sequence_path(var10)
		at = 11
		helper_888ab2a3(10)
		var10 = 1
		event.clear_object_sequence_path(var10)
		event.set_object_sequence_path_frames(var10, 120)
		event.add_object_sequence_path_point(var10, 272.66, 20.0, 4119.88)
		event.add_object_sequence_path_point(var10, 249.45, 20.0, 4367.87)
		event.add_object_sequence_path_point(var10, 241.61, 34.02, 4435.0)
		event.add_object_sequence_path_point(var10, 234.87, 48.2, 4492.6)
		event.start_object_sequence_path(var10)
		at = 12
		wait_objects(1)
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(0, 38)
		at = 13
		helper_888ab2a3(10)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(368.47, 270.27002, 3796.05, 296.74, 129.55, 4410.1)
		event.add_camera_sequence_path_point(368.47, 270.27002, 3796.05, 693.41, 129.55, 4324.2)
		event.start_camera_sequence_path()
		at = 14
		wait_camera()
		at = 15
		helper_888ab2a3(30)
		event.set_object_handle_visible(14, 0)
		event.set_camera_sequence_position(306.21, 254.45, 6861.67)
		event.set_camera_sequence_look_at(234.87, 316.89, 4492.6)
		event.play_sound_effect(var6, 8)
		at = 16
		helper_888ab2a3(60)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.rotate_object_sequence_eased(3, -0.209, 1.57, 0.0, 60, 0, 0.4)
		event.move_object_sequence(3, 8374.23, 2964.08, 3500.0, 400)
		at = 17
		helper_888ab2a3(30)
		event.play_sound_effect(var6, 9)
		event.move_object_sequence_eased(4, 790.0, 70.0, 4500.0, 60, 0, 1.0)
		event.move_camera_sequence_look_at(790.0, 120.0, 4500.0, 60)
		at = 18
		wait_objects(4)
		event.rotate_object_sequence_eased(4, -0.209, 1.57, 0.0, 120, 0, 0.4)
		pos_x_2 = 790.0
		var12 = 0.0
		var13 = vm.f32(0.26666668)
		pos_y_2 = 70.0
		var15 = 0.0
		var16 = vm.f32(0.1)
		pos_z_2 = 4500.0
		var18 = 0.0
		var19 = 0.0
		var20 = 0
		while var20 < 240 do
			event.set_object_sequence_position(4, pos_x_2, pos_y_2, pos_z_2)
			event.set_camera_sequence_look_at(pos_x_2, pos_y_2 + 50.0, pos_z_2)
			pos_x_2 = vm.f32(pos_x_2 + var12)
			var12 = vm.f32(var12 + var13)
			pos_y_2 = vm.f32(pos_y_2 + var15)
			var15 = vm.f32(var15 + var16)
			pos_z_2 = vm.f32(pos_z_2 + var18)
			var18 = vm.f32(var18 + var19)
			var20 = var20 + 1
			if var20 == 210 then
				event.fade_out_music(30)
				event.fade_out_screen(30)
			end
			at = 19
			vm.wait(19)
		end
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(30)
		end
		if at <= 2 then
			helper_038a2e4d(10)
		end
		if at <= 3 then
			helper_038a2e4d(20)
		end
		if at <= 4 then
			helper_038a2e4d(30)
		end
		if at <= 5 then
			helper_038a2e4d(30)
		end
		if at <= 6 then
			helper_038a2e4d(30)
		end
		if at <= 7 then
			helper_038a2e4d(30)
		end
		if at <= 8 then
			helper_038a2e4d(20)
		end
		if at <= 9 then
			var10 = 2
			helper_038a2e4d(10)
		end
		if at <= 10 then
			var10 = 0
			helper_038a2e4d(10)
		end
		if at <= 11 then
			var10 = 1
			helper_238b5abc(1)
		end
		if at <= 12 then
			helper_038a2e4d(10)
		end
		if at <= 13 then
			helper_344d6cd8()
		end
		if at <= 14 then
			helper_038a2e4d(30)
		end
		if at <= 15 then
			helper_038a2e4d(60)
		end
		if at <= 16 then
			helper_038a2e4d(30)
		end
		if at <= 17 then
			helper_238b5abc(4)
		end
		if at <= 18 then
			pos_x_2 = 790.0
			var12 = 0.0
			var13 = vm.f32(0.26666668)
			pos_y_2 = 70.0
			var15 = 0.0
			var16 = vm.f32(0.1)
			pos_z_2 = 4500.0
			var18 = 0.0
			var19 = 0.0
			var20 = 0
			pos_x_2 = vm.f32(pos_x_2 + var12)
			var12 = vm.f32(var12 + var13)
			pos_y_2 = vm.f32(pos_y_2 + var15)
			var15 = vm.f32(var15 + var16)
			pos_z_2 = vm.f32(pos_z_2 + var18)
			var18 = vm.f32(var18 + var19)
			local _ = var20 < 240
			var20 = var20 + 1
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_music(30)
	event.fade_out_screen(0)
	event.stop_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_sound_effect(var6, 3)
	event.clear_effect_manager()
	event.skip_next_music_load()
	at = 20
	vm.wait(20)
	at = 21
	helper_1c9e4()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
function script.event_99()
	print("map_init-------------------------\n")
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1e6bc

--- Event 590, which map data, a script or the engine runs by number.
function script.event_590()
	helper_1e6bc()
	event.jump_to_map_3(-1, "s11", 502)
	vm.wait(2)
end

return script
