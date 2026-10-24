--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0f77aa34 = require("@lib/event/helper_0f77aa34")
local helper_2918f3cd = require("@lib/event/helper_2918f3cd")
local helper_32ffba09 = require("@lib/event/helper_32ffba09")
local helper_dfc8eadf = require("@lib/event/helper_dfc8eadf")

--- Helper function.
local function helper_6b3da2ca(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_dfc8eadf(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_32ffba09(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_0f77aa34(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2918f3cd(arg0, arg1)
		return
	end
end

return helper_6b3da2ca
