--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2f7fa31f = require("@lib/event/helper_2f7fa31f")
local helper_b41851d8 = require("@lib/event/helper_b41851d8")
local helper_c434a645 = require("@lib/event/helper_c434a645")
local helper_d0af19e3 = require("@lib/event/helper_d0af19e3")

--- Helper function.
local function helper_fe7d0734(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_d0af19e3(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_2f7fa31f(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_c434a645(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b41851d8(arg0, arg1)
		return
	end
end

return helper_fe7d0734
