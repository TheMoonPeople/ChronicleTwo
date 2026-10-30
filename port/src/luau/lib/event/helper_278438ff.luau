--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_278438ff()
	local flag: s32 = 0
	flag = event.get_save_flag(536) or flag
	event.get_save_flag(540)
	if flag == 1 then
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "chara/p00_05a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, 0.0, 70.0, -80.0)
		event.set_character_rotation(8, 0.0, 0.0, 0.0)
		event.set_character_motion(8, "立ち", 4)
		event.set_scene_character_number(8, 400)
	end
end

return helper_278438ff
