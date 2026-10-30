--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_71148908()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	var0 = event.get_triggered_event_data_2(9) or var0
	var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_047.sound.json") or var1
	event.attach_object_handle_to_map_part_2(0, var0)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	var5 = vm.bits_float(event.get_triggered_event_data_2(11)) or var5
	var5 = vm.f32(var5 - vm.f32(3.1415927))
	var5 = event.wrap_angle(var5) or var5
	event.attach_object_handle_to_map_part_3(0, var0, "d07d05_3-m0")
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_3(1, var0, "d07d05_1-m0")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, var0, "d07d05_1-m1")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(pos_y_2 + 100.0)
	event.move_object_sequence_eased(0, pos_x_2, pos_y_2, pos_z_2, 40, 0, 0.6)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	pos_y_3 = vm.f32(pos_y_3 + 100.0)
	event.move_object_sequence_eased(1, pos_x_3, pos_y_3, pos_z_3, 40, 0, 0.6)
	do
		local out1, out2, out3 = event.get_object_handle_position(2)
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	pos_y_4 = vm.f32(pos_y_4 + 100.0)
	event.move_object_sequence_eased(2, pos_x_4, pos_y_4, pos_z_4, 40, 0, 0.6)
	event.play_sound_effect(var1, 0)
	var6 = 0
	while var6 < 30 do
		event.swing_camera_control_to_angle(var5)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var6 = var6 + 1
		vm.wait(1)
	end
	wait_objects(0)
	event.attach_object_handle_to_map_part_3(0, var0, "d07da05a-a")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, var0, "d07dv05a-c")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, var0, "d07da05b-a")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, var0, "d07dv05b-c")
	event.set_object_handle_visible(0, 1)
	event.set_function_point_enabled(var0, "door01", 0)
	event.reset_follow_camera(0)
end

return helper_71148908
