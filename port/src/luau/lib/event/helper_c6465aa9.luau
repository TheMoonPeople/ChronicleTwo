--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")

--- Helper function.
local function helper_c6465aa9()
	local parts_id: s32 = 0
	local var1: s32 = 0
	local rot_y: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_x_2: f32 = 0
	local rot_y_2: f32 = 0
	local rot_z_2: f32 = 0
	event.initialize_event()
	parts_id = event.get_automap_door_parts() or parts_id
	event.attach_object_handle_to_function_point(0, parts_id, "dkey")
	var1 = event.is_object_handle_visible(0) or var1
	do
		local _, out2, _ = event.get_object_handle_rotation(0)
		rot_y = out2 or rot_y
	end
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
	event.attach_object_handle_to_map_part_3(0, parts_id, "d04d00_101-m1")
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		rot_x_2 = out1 or rot_x_2
		rot_y_2 = out2 or rot_y_2
		rot_z_2 = out3 or rot_z_2
	end
	if helper_f7fba8ce(rot_y, 0.0, 1.0) == 0 or helper_f7fba8ce(rot_y, vm.f32(3.14), 1.0) == 0 then
		event.attach_object_handle_to_map_part_3(1, parts_id, "d04d00_11-m")
		event.attach_object_handle_to_map_part_3(2, parts_id, "d04d00_12-m")
		event.attach_object_handle_to_map_part_3(3, parts_id, "d04d00_13-m")
		event.attach_object_handle_to_map_part_3(4, parts_id, "d04d00_14-m")
		event.attach_object_handle_to_map_part_3(5, parts_id, "d04d00_15-m")
		event.attach_object_handle_to_map_part_3(6, parts_id, "d04d00_16-m")
		event.attach_object_handle_to_map_part_3(7, parts_id, "d04d00_17-m")
		event.attach_object_handle_to_map_part_3(8, parts_id, "d04d00_18-m")
	else
		event.attach_object_handle_to_map_part_3(1, parts_id, "d04d00_21-m")
		event.attach_object_handle_to_map_part_3(2, parts_id, "d04d00_22-m")
		event.attach_object_handle_to_map_part_3(3, parts_id, "d04d00_23-m")
		event.attach_object_handle_to_map_part_3(4, parts_id, "d04d00_24-m")
		event.attach_object_handle_to_map_part_3(5, parts_id, "d04d00_25-m")
		event.attach_object_handle_to_map_part_3(6, parts_id, "d04d00_26-m")
		event.attach_object_handle_to_map_part_3(7, parts_id, "d04d00_27-m")
		event.attach_object_handle_to_map_part_3(8, parts_id, "d04d00_28-m")
	end
	event.attach_object_handle_to_map_part_3(9, parts_id, "d04da05_2-a")
	event.set_object_handle_visible(9, 0)
	event.attach_object_handle_to_map_part_3(10, parts_id, "d04da99-a0")
	event.set_object_handle_visible(10, 1)
	event.set_object_handle_rotation(0, rot_x_2 - vm.f32(0.52), rot_y_2, rot_z_2)
	event.set_function_point_enabled(parts_id, "eff_d04f01-50", 0)
	event.set_function_point_enabled(parts_id, "eff_d04f01-51", 0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(2, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(3, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(4, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(5, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(6, 1.0, 1.0, 1.0)
	event.set_object_handle_visible(7, 0)
	event.set_object_handle_visible(8, 0)
	event.set_function_point_enabled(parts_id, "func", 0)
	event.set_function_point_enabled(parts_id, "dkey", 0)
end

return helper_c6465aa9
