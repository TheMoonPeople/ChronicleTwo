--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_c6124e13()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(5, 40)
	event.clear_object_sequence(5, 40)
	event.set_object_sequence_object(5, 5)
	event.load_character(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(6, 41)
	event.clear_object_sequence(6, 41)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/e600/e616/e616_tama.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.attach_object_handle_to_character(7, 42)
	event.clear_object_sequence(7, 42)
	event.set_object_sequence_object(7, 7)
	event.initialize_effect_manager(5)
	event.load_effect_base("Ｅ６１６月花ビームＡ")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(4, "p01_s3202-0")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
end

return helper_c6124e13
