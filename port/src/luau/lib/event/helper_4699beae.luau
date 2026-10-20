--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_8bbac5f2 = require("@lib/event/helper_8bbac5f2")

--- Helper function.
local function helper_4699beae()
	local flag: s32 = 0
	local var1: s32 = 0
	if helper_8bbac5f2() == 0 then
		return 0
	end
	flag = event.GetFlag(448) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.CheckEnableCharaChange(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

return helper_4699beae
