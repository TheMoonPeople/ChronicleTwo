--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_82f69831()
	local flag: s32 = 0
	local var1: s32 = 0
	flag = event.get_save_flag(500) or flag
	if flag == 0 then
		return
	end
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	var1 = event.get_chapter() or var1
	if var1 ~= 6 and var1 ~= 7 then
		event.load_character(4, "chara/p01_03a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, 2340.0, 0.0, 1645.0)
		event.set_character_rotation(8, 0.0, 3.14, 0.0)
		event.set_scene_character_number(8, 1)
		event.register_villager(8, 1)
	else
		event.load_character(4, "chara/p00_31a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, 2340.0, 0.0, 1645.0)
		event.set_character_rotation(8, 0.0, 3.14, 0.0)
		event.set_scene_character_number(8, 301)
		event.register_villager(8, 301)
	end
end

return helper_82f69831
