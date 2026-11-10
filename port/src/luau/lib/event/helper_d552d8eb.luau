--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_d552d8eb()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m0")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x - 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m1")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x - 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m2")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x - 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m3")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x + 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 3.1415927, -0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m4")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x + 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 3.1415927, -0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m5")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_handle_position(0, pos_x + 56.0, pos_y, pos_z)
	event.set_object_handle_rotation(0, 0.0, 3.1415927, -0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a0")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a1")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a2")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a3")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a4")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a5")
	event.set_object_handle_visible(0, 1)
end

return helper_d552d8eb
