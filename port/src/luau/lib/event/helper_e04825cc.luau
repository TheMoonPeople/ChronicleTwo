--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e04825cc()
	local parts_id: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	event.initialize_event()
	parts_id = event.get_automap_door_parts() or parts_id
	event.attach_object_handle_to_function_point(0, parts_id, "door01")
	var1 = event.is_object_handle_visible(0) or var1
	if parts_id < 0 or var1 == 0 then
		return
	end
	event.attach_object_handle_to_map_part_2(0, parts_id)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(0, parts_id, "d07d05_3-m0")
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	rot_y = vm.f32(rot_y + 100.0)
	event.attach_object_handle_to_map_part_3(1, parts_id, "d07d05_1-m0")
	event.attach_object_handle_to_map_part_3(2, parts_id, "d07d05_1-m1")
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(pos_y_2 + 100.0)
	do
		local out1, out2, out3 = event.get_object_handle_position(2)
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	pos_y_3 = vm.f32(pos_y_3 + 100.0)
	event.set_object_handle_position(0, rot_x, rot_y, rot_z)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.set_object_handle_position(2, pos_x_3, pos_y_3, pos_z_3)
	event.attach_object_handle_to_map_part_3(0, parts_id, "d07da05a-a")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, parts_id, "d07dv05a-c")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, parts_id, "d07da05b-a")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, parts_id, "d07dv05b-c")
	event.set_object_handle_visible(0, 1)
	event.set_function_point_enabled(parts_id, "door01", 0)
end

return helper_e04825cc
