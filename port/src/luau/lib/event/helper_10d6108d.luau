--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_47ab4f2e = require("@lib/event/helper_47ab4f2e")

--- Helper function.
local function helper_10d6108d()
	local flag: s32 = 0
	if helper_47ab4f2e() == 0 then
		return 0
	end
	flag = event.get_save_flag(552) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

return helper_10d6108d
