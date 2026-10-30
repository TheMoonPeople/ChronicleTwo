--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_2b01dbd7()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e200/e209/e209_minchu.gltf", "info", 32)
	event.attach_object_handle_to_character(0, 32)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 32)
	event.load_character(5, "event/e200/e209/e209_eina.gltf", "info", 33)
	event.attach_object_handle_to_character(1, 33)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 33)
	event.load_character(5, "event/e200/e209/e209_pai_b.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e209/e209_pai_s.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e209/e209_osara.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_message_file(0, 5, "event/e200/e209/e209.txt")
	event.set_character_active(0, 0)
end

return helper_2b01dbd7
