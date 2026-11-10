--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_a4ceb2b8()
	local parts_id: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	event.initialize_event()
	parts_id = event.get_automap_door_parts() or parts_id
	event.attach_object_handle_to_function_point(0, parts_id, "key")
	var1 = event.is_object_handle_visible(0) or var1
	if parts_id < 0 or var1 == 0 then
		return
	end
	event.attach_object_handle_to_map_part_2(20, parts_id)
	do
		local out1, out2, out3 = event.get_object_handle_position(20)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(21, parts_id, "d01d01_00-m0")
	event.set_object_handle_position(21, 0.0, 80.0, 0.0)
	event.set_function_point_enabled(parts_id, "key", 0)
	event.attach_object_handle_to_map_part_3(22, parts_id, "d01da00-a")
	event.set_object_handle_position(22, 0.0, 80.0, 0.0)
	event.attach_object_handle_to_map_part_3(23, parts_id, "d01dv00-c")
	event.set_object_handle_visible(23, 0)
end

return helper_a4ceb2b8
