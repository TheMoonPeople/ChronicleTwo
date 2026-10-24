--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_31166470 = require("@lib/event/helper_31166470")
local helper_4c6a3cf5 = require("@lib/event/helper_4c6a3cf5")
local helper_74572c46 = require("@lib/event/helper_74572c46")
local helper_d4378c2a = require("@lib/event/helper_d4378c2a")

--- Helper function.
local function helper_7feb0351(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_31166470(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_4c6a3cf5(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_74572c46(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d4378c2a(arg0, arg1)
		return
	end
end

return helper_7feb0351
