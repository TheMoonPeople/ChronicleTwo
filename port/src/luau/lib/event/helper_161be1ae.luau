--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_161be1ae()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(348) or flag
	if flag == 1 then
		event.set_function_point_enabled("", "e348", 0)
	end
	flag_2 = event.get_save_flag(352) or flag_2
	if flag_2 == 1 then
		event.set_function_point_enabled("", "event", 0)
	end
end

return helper_161be1ae
