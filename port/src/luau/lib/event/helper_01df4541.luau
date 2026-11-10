--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_01df4541()
	event.set_time_of_day_advancing(0)
	event.set_villager_ai_enabled(0, 8)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.change_directory("event/opening/p6/")
	event.load_character(4, "p6_donnie.gltf", "info", 8)
	event.set_character_active(8)
	event.set_character_position(8, 124.7, 104.0, 183.68)
	event.set_character_rotation(8, 0.0, 0.85, 0.0)
	event.set_character_motion(8, "立ち", 4)
	event.change_directory("")
	event.load_music(108)
	event.play_music(0)
end

return helper_01df4541
