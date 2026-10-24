--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0f09cb15 = require("@lib/event/helper_0f09cb15")
local helper_32937cf6 = require("@lib/event/helper_32937cf6")
local helper_b4db1ad2 = require("@lib/event/helper_b4db1ad2")
local helper_c32abcfd = require("@lib/event/helper_c32abcfd")

--- Helper function.
local function helper_26944adf(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_32937cf6(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_c32abcfd(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_b4db1ad2(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_0f09cb15(arg0, arg1)
		return
	end
end

return helper_26944adf
