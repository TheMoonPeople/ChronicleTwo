--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_d4f01060()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local rot_y: f32 = 0
	local angle: f32 = 0
	local var14: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or var0
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
	do
		local out1, out2, out3 = event.get_object_handle_position(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(1)
		rot_y = out2 or rot_y
	end
	angle = vm.f32(rot_y - vm.f32(3.1415927))
	angle = event.wrap_angle(angle) or angle
	pos_x_2 = vm.f32(vm.f32(vm.sin(angle) * 200.0) + pos_x_3)
	pos_y_2 = pos_y_3
	pos_z_2 = vm.f32(vm.f32(vm.cos(angle) * 200.0) + pos_z_3)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.move_object_sequence_eased(1, pos_x_3, pos_y_3, pos_z_3, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1514.63, 208.98, 2402.32)
	event.set_camera_sequence_look_at(1792.39, 155.32, 2165.78)
	event.fade_in_screen(30)
	event.play_sound_effect(var0, 0)
	wait_objects(1)
	event.set_camera_sequence_position(1890.88, 13.68, 2033.57)
	event.set_camera_sequence_look_at(1970.25, 31.92, 2037.52)
	event.set_character_active(0)
	event.set_object_handle_position(1, pos_x_3, pos_y_3, pos_z_3)
	event.set_object_sequence_position(0, 2125.0, 40.0, 2080.0)
	event.set_object_sequence_rotation(0, 0.0, -2.26, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
	var14 = event.get_sound_id(2) or var14
	event.play_sound_effect(var14, 92)
	wait_frames(30)
	event.move_object_sequence(5, pos_x + 11.25, pos_y - 4.75, pos_z, 30)
	wait_frames(20)
	event.move_object_sequence(0, 2050.0, 0.0, 2015.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	wait_objects(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait_frames(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, pos_x_3, pos_y_3, pos_z_3)
	event.set_object_handle_rotation(1, 0.0, rot_y, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, pos_x, pos_y, pos_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_character_active(0)
	helper_9dafbc83(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(15)
end

return helper_d4f01060
