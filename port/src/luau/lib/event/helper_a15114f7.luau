--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_a15114f7()
	local flag: s32 = 0
	flag = event.get_save_flag(209) or flag
	if flag == 0 then
		event.set_function_point_enabled("p01_g010701", "door", 0)
	else
		event.set_function_point_enabled("p01_g010701", "door", 1)
	end
	flag = event.get_save_flag(250) or flag
	if flag == 1 then
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
	else
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
	end
end

return helper_a15114f7
