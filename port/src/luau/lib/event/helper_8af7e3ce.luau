--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_8af7e3ce()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.load_character(5, "event/e600/e616/e616_iwa.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(4, 40)
	event.clear_object_sequence(4, 40)
	event.set_object_sequence_object(4, 4)
	event.copy_character(5, 40, 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(5, 41)
	event.clear_object_sequence(5, 41)
	event.set_object_sequence_object(5, 5)
	event.load_character(5, "event/e600/e616/e616_nageiwa.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.attach_object_handle_to_character(6, 42)
	event.clear_object_sequence(6, 42)
	event.set_object_sequence_object(6, 6)
	event.copy_character(5, 42, 43)
	event.set_character_active(0, 43)
	event.attach_object_handle_to_character(7, 43)
	event.clear_object_sequence(7, 43)
	event.set_object_sequence_object(7, 7)
end

return helper_8af7e3ce
