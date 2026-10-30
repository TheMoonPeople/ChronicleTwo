--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_23ac133f()
	local var0: s32 = 0
	local flag: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	var0 = event.get_chapter() or var0
	if var0 ~= 6 and var0 ~= 7 then
		event.load_character(4, "chara/p01_03a.gltf", "info", 24)
		event.set_character_position(24, -123.0, 36.0, -68.0)
		event.set_character_rotation(24, 0.0, -1.57, 0.0)
		event.set_scene_character_number(24, 1)
		event.register_villager(24, 1)
	else
		event.load_character(4, "chara/p00_31a.gltf", "info", 24)
		event.set_character_position(24, -123.0, 36.0, -68.0)
		event.set_character_rotation(24, 0.0, -1.57, 0.0)
		event.set_scene_character_number(24, 301)
		event.register_villager(24, 301)
	end
	flag = event.get_save_flag(500) or flag
	if flag == 0 then
		event.load_character(4, "chara/p01_06a.gltf", "info", 25)
		event.set_character_position(25, -99.9, 36.0, 456.5)
		event.set_character_rotation(25, 0.0, -1.5, 0.0)
		event.set_scene_character_number(25, 2)
		event.register_villager(25, 2)
		event.load_character(4, "chara/p01_07a.gltf", "info", 26)
		event.set_character_position(26, -99.6, 36.0, 855.2)
		event.set_character_rotation(26, 0.0, -2.37, 0.0)
		event.set_scene_character_number(26, 13)
		event.register_villager(26, 13)
	end
end

return helper_23ac133f
