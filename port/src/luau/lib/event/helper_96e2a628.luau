--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_96e2a628()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e200/e205/e205_starbre.gltf", "info", 32)
	event.attach_object_handle_to_character(0, 32)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 32)
	event.load_character(5, "event/e200/e205/e205_vorneo.gltf", "info", 33)
	event.attach_object_handle_to_character(1, 33)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 33)
	event.load_character(5, "event/e200/e205/e205_tom.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_message_file(0, 5, "event/e200/e205/e205_1.txt")
	event.set_character_active(0, 0)
end

return helper_96e2a628
