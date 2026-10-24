--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_0048d4e7 = require("@lib/event/helper_0048d4e7")

--- Helper function.
local function helper_72334e82()
	local flag: s32 = 0
	local var1: s32 = 0
	if helper_0048d4e7() == 0 then
		return 0
	end
	flag = event.GetFlag(456) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.CheckEnableCharaChange(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

return helper_72334e82
