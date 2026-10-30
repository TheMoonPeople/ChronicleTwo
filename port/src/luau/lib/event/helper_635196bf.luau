--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_635196bf()
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local rot_x_2: f32 = 0
	local var4: f32 = 0
	local rot_z_2: f32 = 0
	local rot_x_3: f32 = 0
	local var7: f32 = 0
	local rot_z_3: f32 = 0
	event.attach_object_handle_to_map_part_3(29, "door34", "d07d05_3-m0")
	do
		local out1, out2, out3 = event.get_object_handle_rotation(29)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	rot_y = vm.f32(rot_y + 100.0)
	event.attach_object_handle_to_map_part_3(30, "door34", "d07d05_1-m0")
	do
		local out1, out2, out3 = event.get_object_handle_rotation(30)
		rot_x_2 = out1 or rot_x_2
		var4 = out2 or var4
		rot_z_2 = out3 or rot_z_2
	end
	event.attach_object_handle_to_map_part_3(31, "door34", "d07d05_1-m1")
	do
		local out1, out2, out3 = event.get_object_handle_rotation(31)
		rot_x_3 = out1 or rot_x_3
		var7 = out2 or var7
		rot_z_3 = out3 or rot_z_3
	end
	var4 = vm.f32(var4 - vm.f32(1.4))
	var4 = event.wrap_angle(var4) or var4
	var7 = vm.f32(var7 + vm.f32(1.4))
	var7 = event.wrap_angle(var7) or var7
	event.set_object_handle_position(29, rot_x, rot_y, rot_z)
	event.set_object_handle_rotation(30, rot_x_2, var4, rot_z_2)
	event.set_object_handle_rotation(31, rot_x_3, var7, rot_z_3)
	event.attach_object_handle_to_map_part_3(29, "door34", "d07da05a-a")
	event.set_object_handle_visible(29, 0)
	event.attach_object_handle_to_map_part_3(29, "door34", "d07dv05a-c")
	event.set_object_handle_visible(29, 0)
	event.attach_object_handle_to_map_part_3(29, "door34", "d07da05b-a")
	event.set_object_handle_visible(29, 1)
	event.attach_object_handle_to_map_part_3(29, "door34", "d07dv05b-c")
	event.set_object_handle_visible(29, 1)
end

return helper_635196bf
