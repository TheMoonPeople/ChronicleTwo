--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0883dac4 = require("@lib/event/helper_0883dac4")
local helper_2727f3d5 = require("@lib/event/helper_2727f3d5")
local helper_3019d791 = require("@lib/event/helper_3019d791")
local helper_4151039a = require("@lib/event/helper_4151039a")

--- Helper function.
local function helper_a67d4aed(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2727f3d5(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_0883dac4(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_4151039a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_3019d791(arg0, arg1)
		return
	end
end

return helper_a67d4aed
