--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_cce8673f(arg0: s32)
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local pos_y: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local world_coord_rot: f32 = 0
	local pos_x: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z: f32 = 0
	local var11: s32 = 0
	local var14: s32 = 0
	local now_map_no: s32 = 0
	local var16: s32 = 0
	event.initialize_event()
	event.get_sound_id(1)
	var11 = event.get_triggered_event_data_2(3) or var11
	event.get_triggered_event_data_2(4)
	event.call_command(1035, 8, world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot) -- retail: the handler rejects 5 arguments
	print("train_id=", var11, "----------------\n")
	print("fpos[0]=", vm.float(world_coord_pos), "---------------\n")
	print("fpos[1]=", vm.float(world_coord_pos_2), "---------------\n")
	print("fpos[2]=", vm.float(world_coord_pos_3), "---------------\n")
	print("train_id=", var11, "---------------\n")
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.attach_object_handle_to_map_part_2(0, "p01_train01")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y_2 = out2 or pos_y_2
		pos_z = out3 or pos_z
	end
	if arg0 ~= 0 then
		pos_y = vm.f32(5.51)
		var5 = vm.f32(19.05)
		var6 = vm.f32(19.05)
		var14 = 6
	else
		pos_y = 19.75
		var5 = 19.75
		var6 = 19.75
		var14 = 2
		now_map_no = event.get_current_map() or now_map_no
		if now_map_no == 83 then
			pos_y = vm.f32(14.049999)
			var5 = vm.f32(17.05)
			var6 = vm.f32(22.05)
			event.set_object_handle_position(0, pos_x, pos_y_2 - 2.0, pos_z)
			var14 = 3
		end
		if now_map_no == 54 then
			pos_y = vm.f32(20.55)
			var5 = vm.f32(20.55)
			var6 = vm.f32(22.05)
			var14 = 2
		end
	end
	if vm.imod(var11, 2) ~= 1 then
		world_coord_rot = vm.f32(-3.1415927)
	end
	if var11 == 2 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m0")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m1")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m0")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m1")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m12")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m13")
		event.set_save_counter(0, 1)
	end
	if var11 == 3 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m2")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m3")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m3")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m2")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m15")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m14")
		event.set_save_counter(0, 1)
	end
	if var11 == 4 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m4")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m5")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m4")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m5")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m16")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m17")
		event.set_save_counter(0, 2)
	end
	if var11 == 5 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m6")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m7")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m6")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m7")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m18")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m19")
		event.set_save_counter(0, 2)
	end
	if var11 == 6 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m8")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m9")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m8")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m9")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m20")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m21")
		event.set_save_counter(0, 3)
	end
	if var11 == 7 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m10")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m11")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m10")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m11")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m22")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m23")
		event.set_save_counter(0, 3)
	end
	var16 = event.get_sound_id(2) or var16
	event.play_sound_effect(var16, 66)
	if vm.imod(var11, 2) ~= 1 then
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 12.08, pos_y, 0.42)
		event.set_object_sequence_rotation(0, 0.0, -1.5015928, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(124.87, 46.06, -74.18)
		event.set_camera_sequence_look_at(-3.0, 50.74, 0.18)
		helper_888ab2a3(10)
		event.rotate_object_sequence(1, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		helper_888ab2a3(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -5.04, var5, 0.84, 30)
		event.move_object_sequence(0, -33.49, var6, -0.56, 30)
		event.set_object_handle_footstep_sound(0, var14)
		helper_888ab2a3(18)
		event.set_object_handle_footstep_sound(0, 4)
		helper_888ab2a3(12)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_object_handle_motion(0, "立ち", 4)
	else
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -12.08, pos_y, -0.42)
		event.set_object_sequence_rotation(0, 0.0, 1.64, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-124.87, 46.06, 74.18)
		event.set_camera_sequence_look_at(3.0, 50.74, -0.18)
		helper_888ab2a3(10)
		event.rotate_object_sequence(1, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, 1.5, 0.0, 30)
		helper_888ab2a3(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 5.04, var5, -0.84, 30)
		event.move_object_sequence(0, 33.49, var6, 0.56, 30)
		event.set_object_handle_footstep_sound(0, var14)
		helper_888ab2a3(18)
		event.set_object_handle_footstep_sound(0, 4)
		helper_888ab2a3(12)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_object_handle_motion(0, "立ち", 4)
	end
	if vm.imod(var11, 2) ~= 1 then
		event.set_character_position(0, 65.0, 36.0, 0.0)
		event.set_character_rotation(0, 0.0, -1.57, 0.0)
	else
		event.set_character_position(0, -65.0, 36.0, 0.0)
		event.set_character_rotation(0, 0.0, 1.57, 0.0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.attach_object_handle_to_map_part_2(0, "p01_train01")
	event.set_object_handle_position(0, pos_x, pos_y_2, pos_z)
end

return helper_cce8673f
