--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_72881967()
	local flag: s32 = 0
	local var1: s32 = 0
	flag = event.get_save_flag(408) or flag
	if flag == 0 then
		var1 = event.find_scene_character_slot(301) or var1
		event.delete_character(var1)
		event.delete_villager(var1)
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "event/e400/e414/e414_osmond.gltf", "info", var1)
		event.set_character_active(var1)
		event.set_character_position(var1, -57.0056, 8.73, 219.919)
		event.set_character_rotation(var1, 0.0, -0.157, 0.0)
		event.set_character_motion(var1, "寝る", 4)
		event.set_scene_character_number(var1, 301)
	end
end

return helper_72881967
