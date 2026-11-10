--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_d4581b6b()
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_npc_character(0, 4, 24, 28)
	event.set_character_position(28, 42.4, 123.8, -110.2)
	event.set_character_rotation(28, 0.0, -0.31, 0.0)
	event.set_character_motion(28, "立ち", 4)
	event.set_scene_character_number(28, 24)
	event.register_villager(28, 24)
	event.set_character_active(28)
end

return helper_d4581b6b
