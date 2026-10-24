--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_364319f4 = require("@lib/event/helper_364319f4")
local helper_6c0ef236 = require("@lib/event/helper_6c0ef236")

--- Helper function.
local function helper_acffd9e4()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	flag = event.GetFlag(38) or flag
	helper_6c0ef236(if flag == 0 then 1 else 0)
	var1 = event.GetQuestEtc(0, 18) or var1
	if var1 == 1 then
		var2 = event.GetCnt(11) or var2
		if var2 == 1 then
			helper_364319f4()
		end
	end
end

return helper_acffd9e4
