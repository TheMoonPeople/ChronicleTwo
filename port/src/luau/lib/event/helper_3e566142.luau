--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_02c38d54 = require("@lib/event/helper_02c38d54")

--- Helper function.
local function helper_3e566142()
	local flag: s32 = 0
	local debug_flag: s32 = 0
	flag = event.get_save_flag(404) or flag
	if flag ~= 1 then
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 0 then
			event.set_character_active(0, 120)
			event.set_character_active(0, 121)
		end
	end
	helper_02c38d54()
end

return helper_3e566142
