--!strict
-- map/s/s12/s12.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_35e14f02 = require("@lib/event/helper_35e14f02")
local helper_3efe4328 = require("@lib/event/helper_3efe4328")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a24f3c28 = require("@lib/event/helper_a24f3c28")
local helper_bdaf51ab = require("@lib/event/helper_bdaf51ab")
local helper_c8870924 = require("@lib/event/helper_c8870924")
local helper_ce60ccd6 = require("@lib/event/helper_ce60ccd6")
local helper_cf15df04 = require("@lib/event/helper_cf15df04")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local helper_dfad229b = require("@lib/event/helper_dfad229b")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	print("map_init-------------------------\n")
end

--- Helper function.
local function helper_12890()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	vm.section(function()
		event.set_save_flag(648, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7815)
		var0 = event.load_sound_effect_file_2(7815) or var0
		event.play_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 0)
		var1 = event.find_scene_character_slot(301) or var1
		event.set_character_active(0, var1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e600/e648/")
		event.load_message_file(0, 5, "e648.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e648_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e648_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e648_osmond.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(2, 35)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_2(3, "p01_train01")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_12-m")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_14-m")
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "s3601_16-m")
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "s3601_17-m1")
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e600/e648/e648_mints.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 33)
			event.load_equipment_model(5, 1, 4, "info", 33)
			event.load_equipment_model(5, 1, 3, "info", 33)
			event.load_equipment_model(5, 1, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e600/e648/e648_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_position(0, 3.38, -9.6, -127.86)
		event.set_object_handle_rotation(0, 0.0, 0.03, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, 19.72, -9.6, -146.14)
		event.set_object_handle_rotation(1, 0.0, -0.81, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(2, 0.11, -2.82, -96.44)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 1)
		event.set_object_handle_position(3, 10497.4, 4263.4, 16022.1)
		event.set_object_handle_rotation(3, 0.17453292, -2.268928, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(8906.16, 4062.09, 15480.96)
		event.set_camera_sequence_look_at(9213.43, 4103.76, 15508.46)
		event.set_character_active(0)
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_character_active(35)
		event.fade_in_screen(30)
		event.move_object_sequence(3, -738.8, 0.0, 4490.7, 300)
		event.rotate_object_sequence(3, 0.0, -2.286, 0.3, 300)
		event.play_sound_effect(var0, 4)
		event.move_camera_sequence(8070.99, 3228.35, 15847.63, 7999.18, 3244.28, 15637.48, 90)
		helper_888ab2a3(120)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_camera_sequence_position(-1639.57, 7.86, 5016.61)
		event.set_camera_sequence_look_at(-1218.91, 101.0, 4719.94)
		event.set_object_sequence_position(3, 1200.0, 237.6, 4500)
		event.set_object_sequence_rotation(3, 0.0, -1.57, 0.0)
		event.move_object_sequence(3, -400, 0.0, 4500, 60)
		event.move_object_sequence_eased(3, -990, 0.0, 4500, 90, 2, 0.8)
		helper_888ab2a3(210)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_object_sequence_position(3, -790, 0.0, 4500)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_position(0, -266.3, 0.0, 4342.88)
		event.set_object_sequence_rotation(0, 0.0, -3.13, 0.0)
		event.set_object_sequence_position(1, -263.45, 0.0, 4372.15)
		event.set_object_sequence_rotation(1, 0.0, -3.13, 0.0)
		event.set_object_sequence_position(2, -241.85, 11.82, 4430.23)
		event.set_object_sequence_rotation(2, 0.0, 3.03, 0.0)
		event.set_camera_sequence_position(-336.6, 39.36, 4198.84)
		event.set_camera_sequence_look_at(-239.26, 60.64, 4423.35)
		event.set_object_sequence_rotation(4, 0.0, 0.0, -1.5707964)
		event.set_object_sequence_rotation(5, 0.0, 0.0, -1.5707964)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.3926991)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.3926991)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -249.34, 0.0, 4318.43, 60)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -277.96, 0.0, 4332.42, 60)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, -253.46, 0.0, 4397.34, 30)
		event.move_object_sequence(2, -252.88, 0.0, 4367.79, 30)
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "立ち")
		wait_objects(2)
		event.set_camera_sequence_position(-130.69, 136.99, 4468.57)
		event.set_camera_sequence_look_at(-261.31, 3.53, 4336.64)
		event.set_object_sequence_position(0, -235.2, 0.0, 4329.41)
		event.set_object_sequence_rotation(0, 0.0, -0.09, 0.0)
		event.set_object_sequence_position(1, -276.84, 0.0, 4326.87)
		event.set_object_sequence_rotation(1, 0.0, 0.39, 0.0)
		event.set_object_sequence_position(2, -254.29, 0.0, 4359.67)
		event.set_object_sequence_rotation(2, 0.0, 3.03, 0.0)
		event.set_object_sequence_motion(0, "オズ見立ち", 4)
		event.set_object_sequence_motion(1, "オズ見", 4)
		event.set_object_sequence_motion(2, "立ち（上見）", 6)
		event.queue_object_sequence_next_motion(2, "会話（上見）", 6)
		event.queue_object_sequence_next_motion(2, "立ち（上見）", 4)
		helper_4116e6bb(6480100)
		wait_objects(2)
		event.set_object_sequence_motion(0, "オズ見うなづき", 6)
		event.queue_object_sequence_next_motion(0, "オズ見立ち", 6)
		event.set_object_sequence_motion(1, "オズ見うなずき", 6)
		event.queue_object_sequence_next_motion(1, "オズ見", 6)
		helper_4116e6bb(6480110)
		wait_objects(1)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 4)
	event.stop_music(0)
	helper_888ab2a3(4)
	var3 = event.get_default_music_number(72) or var3
	event.load_music(var3)
	event.play_music(0)
	event.set_character_active(1, var1)
	event.set_object_handle_position(3, -790, 0.0, 4500)
	event.set_object_handle_rotation(3, 0.0, -1.57, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_footstep_sound(2, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
end

--- Helper function.
local function helper_1ea78()
	local now_map_no: s32 = 0
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local world_coord_rot: f32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_y_2: f32 = 0
	local pos_x_2: f32 = 0
	local var16: s32 = 0
	local at: number = 0
	return vm.guard(function()
		now_map_no = event.get_current_map() or now_map_no
		event.initialize_event()
		event.get_sound_id(1)
		var5 = event.get_triggered_event_data_2(3) or var5
		event.get_triggered_event_data_2(4)
		event.call_command(1035, 8, world_coord_pos, world_coord_pos_2, world_coord_pos_3, var4) -- retail: the handler rejects 5 arguments
		print("train_id=", var5, "----------------\n")
		print("fpos[0]=", vm.float(world_coord_pos), "---------------\n")
		print("fpos[1]=", vm.float(world_coord_pos_2), "---------------\n")
		print("fpos[2]=", vm.float(world_coord_pos_3), "---------------\n")
		if world_coord_pos_3 < 4500.0 then
			world_coord_rot = vm.f32(1.5707964)
		else
			world_coord_rot = vm.f32(-1.5707964)
		end
		if now_map_no == 76 then
			if world_coord_pos_3 < 3600.0 then
				world_coord_rot = vm.f32(1.5707964)
			else
				world_coord_rot = vm.f32(-1.5707964)
			end
		end
		if now_map_no == 72 then
			if world_coord_pos_3 < 4500.0 then
				world_coord_rot = vm.f32(1.5707964)
			else
				world_coord_rot = vm.f32(-1.5707964)
			end
		end
		if now_map_no == 34 or now_map_no == 16 or now_map_no == 54 then
			world_coord_rot = vm.f32(3.1415927)
		end
		if now_map_no == 87 then
			world_coord_rot = vm.f32(2.3561945)
		end
		if now_map_no == 83 or now_map_no == 103 then
			world_coord_rot = vm.f32(1.5707964)
		end
		event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
		var9 = 0
		if now_map_no == 34 or now_map_no == 54 or now_map_no == 87 or now_map_no == 103 or now_map_no == 76 then
			var9 = 1
		end
		if var5 == 4 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			if var9 == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m6")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
			event.set_save_counter(0, 1)
		end
		if var5 == 5 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
			if var9 == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m7")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
			event.set_save_counter(0, 1)
		end
		if var5 == 2 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
			if var9 == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m3")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
			event.set_save_counter(0, 2)
		end
		if var5 == 3 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
			if var9 == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m11")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
			event.set_save_counter(0, 2)
		end
		if var5 == 6 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
			if var9 == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m5")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m8")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
			event.set_save_counter(0, 3)
		end
		if var5 == 7 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m2")
			if var9 == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m4")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m9")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m3")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m5")
			event.set_save_counter(0, 3)
		end
		var10 = event.get_sound_id(2) or var10
		event.play_sound_effect(var10, 92)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(5)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		pos_y_2 = 0.0
		pos_x_2 = 46.0
		if now_map_no == 34 then
			pos_y_2 = vm.f32(35.8)
		end
		if now_map_no == 16 then
			pos_y_2 = vm.f32(-7.86)
		end
		if now_map_no == 54 then
			pos_y_2 = 36.0
		end
		if now_map_no == 83 then
			pos_y_2 = vm.f32(29.22)
		end
		if now_map_no == 87 then
			pos_y_2 = -6.0
		end
		if now_map_no == 103 then
			pos_y_2 = vm.f32(-13.87)
		end
		if now_map_no == 72 then
			pos_x_2 = 30.0
			pos_y_2 = vm.f32(0.09)
		end
		event.set_object_sequence_position(0, pos_x_2, pos_y_2, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.5707964, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(148.0, 23.45, -118.4)
		event.set_camera_sequence_look_at(5.11, 26.65, 8.6)
		if now_map_no == 34 or now_map_no == 54 then
			event.set_camera_sequence_position(106.46, 47.9, -133.32)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		if now_map_no == 83 then
			event.set_camera_sequence_position(148.0, 35.52, -118.4)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		at = 1
		helper_888ab2a3(10)
		if vm.imod(var5, 2) ~= 1 then
			event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 2
				helper_888ab2a3(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
				at = 3
				helper_888ab2a3(30)
				if now_map_no == 103 then
					event.move_object_sequence(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
					at = 4
					helper_888ab2a3(20)
				else
					event.move_object_sequence(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
					at = 5
					helper_888ab2a3(10)
				end
			end
		else
			event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 6
				helper_888ab2a3(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
				at = 7
				helper_888ab2a3(30)
				if now_map_no == 103 then
					event.move_object_sequence(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
					at = 8
					helper_888ab2a3(20)
				else
					event.move_object_sequence(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
					at = 9
					helper_888ab2a3(10)
				end
			end
		end
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -50.0, 30.0, 0.0, 45)
		var16 = 0
		if
			now_map_no == 16
			or now_map_no == 83
			or now_map_no == 87
			or now_map_no == 103
			or now_map_no == 72
			or now_map_no == 76
			or now_map_no == 155
		then
			print("てつのあしおと\n")
			var16 = 6
		end
		if now_map_no == 34 or now_map_no == 54 then
			print("いしのあしおと\n")
			var16 = 2
		end
		event.set_object_handle_footstep_sound(0, var16)
		at = 10
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		at = 11
		helper_888ab2a3(30)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_handle_motion(0, "立ち", 4)
		if vm.imod(var5, 2) ~= 1 then
			event.set_character_position(0, 50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, -1.57, 0.0)
		else
			event.set_character_position(0, -50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
		end
		return
	end, function(received: { any })
		if at <= 11 then
			if at <= 1 then
				helper_038a2e4d(20)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			if at <= 3 then
				helper_038a2e4d(20)
			end
			if at <= 4 then
				helper_038a2e4d(10)
			end
			if at <= 5 then
				helper_038a2e4d(20)
			end
			if at <= 6 then
				helper_038a2e4d(30)
			end
			if at <= 7 then
				helper_038a2e4d(20)
			end
			if at <= 8 then
				helper_038a2e4d(10)
			end
			if at <= 9 then
				var16 = 0
				print("てつのあしおと\n")
				var16 = 6
				print("いしのあしおと\n")
				var16 = 2
				helper_038a2e4d(30)
			end
			if at <= 10 then
				helper_038a2e4d(30)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_23900000()
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: s32 = 0
	print("train_id=", var5, "----------------\n")
	print("fpos[0]=", vm.float(var1), "---------------\n")
	print("fpos[1]=", vm.float(var2), "---------------\n")
	print("fpos[2]=", vm.float(var3), "---------------\n")
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(30)
	helper_038a2e4d(20)
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(30)
	helper_038a2e4d(20)
	helper_038a2e4d(10)
	print("てつのあしおと\n")
	print("いしのあしおと\n")
	helper_038a2e4d(30)
	helper_038a2e4d(30)
end

--- Helper function.
local function helper_e2dc()
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
	event.attach_object_handle_to_map_part_2(14, "p01_shadow-0")
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_12-m1")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.attach_object_handle_to_map_part_3(6, "p01_train01", "s3601_14-m1")
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
local function helper_dee4()
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
local function helper_fba0()
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
		var6 = event.load_sound_effect_file_2(7202) or var6
		helper_e2dc()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_footstep_sound(2, 16)
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
		event.set_object_sequence_position(4, 790.0, 0.0, 4500.0)
		event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(8, 913.78, 1815.71, -1455.71)
		event.set_object_sequence_position(10, 913.78, 1815.71, -1455.71)
		event.set_object_sequence_rotation(10, 0.0, -0.04, 0.0)
		event.set_object_sequence_position(9, 347.12, 200.0, 1407.85)
		event.set_character_active(1, 40)
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
		event.set_camera_sequence_position(368.47, 250.27, 3796.05)
		event.set_camera_sequence_look_at(296.74, 109.55, 4410.1)
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
		event.add_object_sequence_path_point(var10, 272.66, 0.0, 4119.88)
		event.add_object_sequence_path_point(var10, 249.45, 0.0, 4367.87)
		event.add_object_sequence_path_point(var10, 241.61, 14.02, 4435.0)
		event.add_object_sequence_path_point(var10, 234.87, 28.2, 4492.6)
		event.start_object_sequence_path(var10)
		at = 10
		helper_888ab2a3(10)
		var10 = 0
		event.clear_object_sequence_path(var10)
		event.set_object_sequence_path_frames(var10, 120)
		event.add_object_sequence_path_point(var10, 272.66, 0.0, 4119.88)
		event.add_object_sequence_path_point(var10, 249.45, 0.0, 4367.87)
		event.add_object_sequence_path_point(var10, 241.61, 14.02, 4435.0)
		event.add_object_sequence_path_point(var10, 234.87, 28.2, 4492.6)
		event.start_object_sequence_path(var10)
		at = 11
		helper_888ab2a3(10)
		var10 = 1
		event.clear_object_sequence_path(var10)
		event.set_object_sequence_path_frames(var10, 120)
		event.add_object_sequence_path_point(var10, 272.66, 0.0, 4119.88)
		event.add_object_sequence_path_point(var10, 249.45, 0.0, 4367.87)
		event.add_object_sequence_path_point(var10, 241.61, 14.02, 4435.0)
		event.add_object_sequence_path_point(var10, 234.87, 28.2, 4492.6)
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
		event.add_camera_sequence_path_point(368.47, 250.27, 3796.05, 296.74, 109.55, 4410.1)
		event.add_camera_sequence_path_point(368.47, 250.27, 3796.05, 693.41, 109.55, 4324.2)
		event.start_camera_sequence_path()
		at = 14
		wait_camera()
		at = 15
		helper_888ab2a3(30)
		event.set_object_handle_visible(14, 0)
		event.set_camera_sequence_position(306.21, 234.45, 6861.67)
		event.set_camera_sequence_look_at(234.87, 296.89, 4492.6)
		event.play_sound_effect(var6, 8)
		at = 16
		helper_888ab2a3(60)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.rotate_object_sequence_eased(3, -0.209, 1.57, 0.0, 60, 0, 0.4)
		event.move_object_sequence(3, 8374.23, 2944.08, 3500.0, 360)
		at = 17
		helper_888ab2a3(30)
		event.play_sound_effect(var6, 9)
		event.move_object_sequence_eased(4, 790.0, 50.0, 4500.0, 60, 0, 1.0)
		event.move_camera_sequence_look_at(790.0, 100.0, 4500.0, 60)
		at = 18
		wait_objects(4)
		event.rotate_object_sequence_eased(4, -0.209, 1.57, 0.0, 120, 0, 0.4)
		pos_x_2 = 790.0
		var12 = 0.0
		var13 = vm.f32(0.26666668)
		pos_y_2 = 50.0
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
			pos_y_2 = 50.0
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
	event.fade_out_screen(30)
	at = 20
	helper_888ab2a3(35)
	event.stop_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_port_sound_effects(4)
	event.clear_effect_manager()
	at = 21
	vm.wait(21)
	at = 22
	helper_dee4()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event_99()
		print("start_event--------------------------------------------\n")
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			helper_35e14f02()
			helper_9dafbc83(70.0, vm.f32(0.6), 3440.0, vm.f32(3.14))
			event.reset_follow_camera(1, 3.14, 10.0)
			event.fade_in_screen(30)
		else
			print("000--------------------------------------------\n")
			old_map_no = event.get_previous_map() or old_map_no
			var2 = event.get_map_type(old_map_no) or var2
			if var2 ~= -1 then
				print("111--------------------------------------------\n")
				var3 = event.get_save_counter(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 7 then
					print("222--------------------------------------------\n")
					helper_35e14f02()
					at = 1
					helper_c8870924()
					helper_946c0402()
					event.fade_in_screen(15)
					event.reset_follow_camera(1, 0.0)
				else
					print("333--------------------------------------------\n")
					at = 2
					helper_dfad229b()
					helper_35e14f02()
				end
				print("444--------------------------------------------\n")
			end
			print("555--------------------------------------------\n")
			event.set_character_motion(0, "立ち")
		end
		print("999--------------------------------------------\n")
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_d7295df9()
				print("333--------------------------------------------\n")
				helper_bdaf51ab()
			end
			helper_1ef0d4b2()
			print("444--------------------------------------------\n")
			print("555--------------------------------------------\n")
			print("999--------------------------------------------\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_12890

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	if helper_a24f3c28() ~= 0 then
		flag = event.get_save_flag(700) or flag
		if flag == 0 then
			event.skip_next_music_load()
			event.jump_to_map_3(-1, "s68", 550)
			vm.wait(2)
		else
			event.jump_to_map_2(-1, "g05")
			vm.wait(3)
		end
	end
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_3efe4328()
		if var0 ~= 1 then
			return
		end
		event.set_save_counter(1, 7)
		var1 = event.get_triggered_event_data_2(3) or var1
		if var1 <= 1 then
			at = 2
			helper_cf15df04()
			event.stop_music(0)
			at = 3
			vm.wait(3)
			event.jump_to_map_2(-1, "s37")
			at = 4
			vm.wait(4)
		else
			at = 5
			helper_1ea78()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			return 0
		end
		if at <= 5 then
			if at <= 4 then
				helper_23900000()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_12890()
	helper_35e14f02()
	event.set_character_active(0)
	helper_9dafbc83(vm.f32(-249.34), 0.0, vm.f32(4318.43), vm.f32(3.14))
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- Event 590, which map data, a script or the engine runs by number.
function script.event_590()
	helper_fba0()
	event.jump_to_map_3(-1, "s11", 502)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	if var0 == 8 then
		helper_ce60ccd6()
	end
end

return script
