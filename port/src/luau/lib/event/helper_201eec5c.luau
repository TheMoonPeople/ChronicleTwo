--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_201eec5c()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_save_counter(0) or var0
		if var0 == 0 then
			helper_946c0402()
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0)
			event.fade_in_screen(30)
			return
		end
		var1 = event.get_save_counter(15) or var1
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.set_object_handle_position(1, -790.0, 0.0, 4500.0)
		event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var1 == 0 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
			if var0 == 2 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m3")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
			end
			if var0 == 3 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m5")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
			end
		else
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
			if var0 == 2 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
			end
			if var0 == 3 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m2")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m4")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m3")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m5")
			end
		end
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
		var5 = -240.0
		if var0 == 2 then
			var5 = 270.0
		end
		if var0 == 3 then
			var5 = 790.0
		end
		event.clear_camera_sequence()
		if var1 == 0 then
			event.set_camera_sequence_position(var5 + vm.f32(135.23), 32.86, 4778.39)
			event.set_camera_sequence_look_at(var5, 31.8, 4650.0)
		else
			event.set_camera_sequence_position(var5 - vm.f32(135.23), 32.86, 4221.61)
			event.set_camera_sequence_look_at(var5, 31.8, 4350.0)
		end
		event.fade_in_screen(30)
		if var1 == 0 then
			event.set_object_sequence_position(0, var5, 25.9, 4550.0)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		else
			event.set_object_sequence_position(0, var5, 30.0, 4480.0)
			event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
		end
		if var1 == 0 then
			event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
			event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
		else
			event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
			event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
		end
		var6 = event.get_sound_id(2) or var6
		event.play_sound_effect(var6, 92)
		at = 1
		wait_frames(30)
		event.move_object_sequence(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
		at = 2
		wait_frames(20)
		if var1 == 0 then
			event.move_object_sequence(0, var5, 0.0, 4600.0, 30)
		else
			event.move_object_sequence(0, var5, 0.0, 4400.0, 30)
		end
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_handle_footstep_sound(0, 6)
		at = 3
		wait_objects(0)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_sequence_motion(0, "立ち")
		at = 4
		wait_frames(10)
		event.fade_in_screen(1)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_position(5, pos_x, pos_y, pos_z)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		helper_946c0402()
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				wait_frames_skipping(20)
			end
			if at <= 2 then
				helper_238b5abc(0)
			end
			if at <= 3 then
				wait_frames_skipping(10)
			end
			helper_d7295df9()
			return 0
		end
		return nil
	end)
end

return helper_201eec5c
