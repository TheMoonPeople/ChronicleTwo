--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_f9039243(arg0: s32)
	event.load_character(6, "event/e200/e250/e250_toryon.gltf", "info", 42)
	event.attach_object_handle_to_character(9, 42)
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.set_character_active(0, 42)
	event.set_object_handle_sound_bank(9, arg0)
	event.load_character(6, "event/lm/e250r/e250_tree.gltf", "info", 43)
	event.attach_object_handle_to_character(10, 43)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_character_active(0, 43)
	event.attach_character_to_frame(42, "R_tree", 43)
	event.load_character(6, "event/lm/e250r/e250_tree.gltf", "info", 44)
	event.attach_object_handle_to_character(11, 44)
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.set_character_active(0, 44)
	event.attach_character_to_frame(42, "L_tree", 44)
	event.load_character(6, "event/e200/e250/e250_konoha.gltf", "info", 46)
	event.set_character_active(0, 46)
	event.attach_object_handle_to_character(15, 46)
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 15)
	event.load_character(6, "event/e200/e250/shuchusen.gltf", "info", 45)
	event.attach_object_handle_to_character(14, 45)
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 14)
	event.set_character_active(0, 45)
end

return helper_f9039243
