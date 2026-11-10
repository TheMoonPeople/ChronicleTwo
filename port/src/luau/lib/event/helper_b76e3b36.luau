--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_fe3af31d = require("@lib/event/helper_fe3af31d")

--- Helper function.
local function helper_b76e3b36()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	print("slope-------------------off\t\n")
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m0")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x + 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m1")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x + 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m2")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x + 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m3")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x - 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m4")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x - 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m5")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x - 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	vm.wait(1)
	helper_fe3af31d()
end

return helper_b76e3b36
