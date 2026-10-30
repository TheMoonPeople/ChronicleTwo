--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_3f1a4e47()
	local var0: s32 = 0
	local flag: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	var0 = event.get_chapter() or var0
	if var0 ~= 6 and var0 ~= 7 then
		event.load_character(4, "chara/p01_03a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, -2030.0, 30.0, -100.0)
		event.set_character_rotation(8, 0.0, 3.14, 0.0)
		event.set_scene_character_number(8, 1)
		event.register_villager(8, 1)
	else
		event.load_character(4, "chara/p00_31a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, -2030.0, 30.0, -100.0)
		event.set_character_rotation(8, 0.0, 3.14, 0.0)
		event.set_scene_character_number(8, 301)
		event.register_villager(8, 301)
	end
	flag = event.get_save_flag(500) or flag
	if flag == 0 then
		event.load_character(4, "chara/p01_06a.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, -1045.1, 29.2, -103.3)
		event.set_character_rotation(9, 0.0, 3.1415927, 0.0)
		event.set_scene_character_number(9, 2)
		event.register_villager(9, 2)
		event.load_character(4, "chara/p01_07a.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_position(10, -707.6, -10.0, -172.5)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		event.set_scene_character_number(10, 13)
		event.register_villager(10, 13)
	end
end

return helper_3f1a4e47
