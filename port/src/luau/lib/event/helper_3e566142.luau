--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_02c38d54 = require("@lib/event/helper_02c38d54")

--- Helper function.
local function helper_3e566142()
	local flag: s32 = 0
	local debug_flag: s32 = 0
	flag = event.GetFlag(404) or flag
	if flag ~= 1 then
		debug_flag = event.GetDebugFlag() or debug_flag
		if debug_flag == 0 then
			event.CharaActive(0, 120)
			event.CharaActive(0, 121)
		end
	end
	helper_02c38d54()
end

return helper_3e566142
