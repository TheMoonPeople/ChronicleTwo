--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_66ee0e0a = require("@lib/event/helper_66ee0e0a")

--- Helper function.
local function helper_e57e2768()
	local flag: s32 = 0
	event.stop_music(0)
	flag = event.get_save_flag(24) or flag
	if flag ~= 0 then
		event.set_function_point_enabled("", "e255", 0)
		helper_66ee0e0a(2)
		flag = event.get_save_flag(260) or flag
		if flag ~= 0 then
			event.set_function_point_enabled("", "e256", 0)
			helper_66ee0e0a(1)
		else
			event.set_function_point_enabled("", "e256", 1)
		end
	else
		event.set_function_point_enabled("", "e255", 1)
		event.set_function_point_enabled("", "e256", 0)
		flag = event.get_save_flag(23) or flag
		if flag ~= 0 then
			helper_66ee0e0a(0)
		else
			helper_66ee0e0a(3)
		end
	end
end

return helper_e57e2768
