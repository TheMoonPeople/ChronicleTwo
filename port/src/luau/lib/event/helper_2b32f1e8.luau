--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_c247398f = require("@lib/event/helper_c247398f")

--- Helper function.
local function helper_2b32f1e8()
	local flag: s32 = 0
	if helper_c247398f() == 0 then
		return 0
	end
	flag = event.get_save_flag(748) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

return helper_2b32f1e8
