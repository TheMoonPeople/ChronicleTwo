--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_00b555d3 = require("@lib/event/helper_00b555d3")
local helper_b627904c = require("@lib/event/helper_b627904c")
local helper_c0b58ac1 = require("@lib/event/helper_c0b58ac1")
local helper_dc8318ff = require("@lib/event/helper_dc8318ff")

--- Helper function.
local function helper_9acf546e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_b627904c(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_dc8318ff(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_00b555d3(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c0b58ac1(arg0, arg1)
		return
	end
end

return helper_9acf546e
