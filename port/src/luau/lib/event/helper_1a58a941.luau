--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_40c8fa95 = require("@lib/event/helper_40c8fa95")
local helper_59ad581b = require("@lib/event/helper_59ad581b")
local helper_6576b2c7 = require("@lib/event/helper_6576b2c7")
local helper_cc3bc91c = require("@lib/event/helper_cc3bc91c")

--- Helper function.
local function helper_1a58a941(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_40c8fa95(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_6576b2c7(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_59ad581b(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_cc3bc91c(arg0, arg1)
		return
	end
end

return helper_1a58a941
