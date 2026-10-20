--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_7ece9391 = require("@lib/event/helper_7ece9391")

--- Helper function.
local function helper_08c337b8()
	local flag: s32 = 0
	local var1: s32 = 0
	if helper_7ece9391() == 0 then
		return 0
	end
	flag = event.GetFlag(468) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.CheckEnableCharaChange(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

return helper_08c337b8
