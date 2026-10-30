--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_45ccfc9f()
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e700/e732/e732_sun.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(4, 35)
	event.clear_object_sequence(2, 35)
	event.set_object_sequence_object(2, 4)
	event.load_character(5, "event/e700/e732/e732_andrea.gltf", "info", 33)
	event.set_character_active(0, 33)
	event.attach_object_handle_to_character(5, 33)
	event.clear_object_sequence(3, 33)
	event.set_object_sequence_object(3, 5)
	event.load_character(5, "event/e700/e728/kaisou_waku.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.set_scene_character_type(34, 4)
	event.load_message_file(0, 5, "event/e700/e732/e732_1.txt")
end

return helper_45ccfc9f
