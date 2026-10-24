--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_138c0b3e = require("@lib/event/helper_138c0b3e")
local helper_5db79e11 = require("@lib/event/helper_5db79e11")
local helper_ccd06ee8 = require("@lib/event/helper_ccd06ee8")
local helper_e82009b1 = require("@lib/event/helper_e82009b1")

--- Helper function.
local function helper_1d8b114c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_e82009b1(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_ccd06ee8(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_5db79e11(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_138c0b3e(arg0, arg1)
		return
	end
end

return helper_1d8b114c
