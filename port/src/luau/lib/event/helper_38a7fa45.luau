--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_007bf08c = require("@lib/event/helper_007bf08c")

--- Helper function.
local function helper_38a7fa45()
	local flag: s32 = 0
	if helper_007bf08c() == 0 then
		return 0
	end
	flag = event.get_save_flag(744) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

return helper_38a7fa45
