--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_a0d546a7()
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.change_directory("event/e200/e209/")
	event.load_character(4, "e209_conda.gltf", "info", 8)
	event.set_scene_character_number(8, 34)
	event.set_character_active(8)
	event.set_character_position(8, 59.82, 0.0, -98.58)
	event.set_character_rotation(8, 0.0, 0.0, 0.0)
	event.set_character_motion(8, "座り")
	event.load_character(4, "e209_rococo.gltf", "info", 9)
	event.set_scene_character_number(9, 151)
	event.set_character_active(9)
	event.set_character_position(9, 37.28, 0.0, -29.43)
	event.set_character_rotation(9, 0.0, 2.56, 0.0)
	event.set_character_motion(9, "座り")
	event.load_character(4, "e209_tobo.gltf", "info", 10)
	event.set_scene_character_number(10, 154)
	event.set_character_active(10)
	event.set_character_position(10, 21.3, 0.0, -61.73)
	event.set_character_rotation(10, 0.0, 1.32, 0.0)
	event.set_character_motion(10, "座り")
	event.change_directory("")
end

return helper_a0d546a7
