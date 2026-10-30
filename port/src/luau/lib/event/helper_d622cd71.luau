--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_7fed7304 = require("@lib/event/helper_7fed7304")

--- Helper function.
local function helper_d622cd71()
	local flag: s32 = 0
	if helper_7fed7304() == 0 then
		return 0
	end
	flag = event.get_save_flag(548) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

return helper_d622cd71
