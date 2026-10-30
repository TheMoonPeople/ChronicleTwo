--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_4d5a4434()
	event.set_object_sequence_position(2, 0.0, -24.0, -1000.0)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(10, "p01_train01", "train06-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.attach_object_handle_to_map_part_3(11, "p01_train01", "train06-m1")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.attach_object_handle_to_map_part_3(12, "p01_train01", "train05-m10")
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.attach_object_handle_to_map_part_3(13, "p01_train01", "train05-m11")
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.attach_object_handle_to_map_part_3(14, "p01_train01", "train05-m12")
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	event.attach_object_handle_to_map_part_3(15, "p01_train01", "train05-m13")
	event.clear_object_sequence(15)
	event.set_object_sequence_object(15, 15)
	event.attach_object_handle_to_map_part_3(16, "p01_train01", "train05-m14")
	event.clear_object_sequence(16)
	event.set_object_sequence_object(16, 16)
	event.attach_object_handle_to_map_part_3(17, "p01_train01", "train05-m15")
	event.clear_object_sequence(17)
	event.set_object_sequence_object(17, 17)
	event.attach_object_handle_to_map_part_3(18, "p01_train01", "train05-m16")
	event.clear_object_sequence(18)
	event.set_object_sequence_object(18, 18)
	event.attach_object_handle_to_map_part_3(19, "p01_train01", "train05-m17")
	event.clear_object_sequence(19)
	event.set_object_sequence_object(19, 19)
	event.attach_object_handle_to_map_part_3(20, "p01_train01", "train05-m18")
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.attach_object_handle_to_map_part_3(21, "p01_train01", "train05-m19")
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	for var0 = 0, 11 do
		event.rotate_object_sequence(10 + var0, 0.1, 0.0, 0.0, -1)
	end
end

return helper_4d5a4434
