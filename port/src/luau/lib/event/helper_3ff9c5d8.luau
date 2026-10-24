--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

--- Helper function.
local function helper_3ff9c5d8(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var11: s32 = 0
	helper_f018b3c0(0, 2200, 5, 0, 0)
	var1 = helper_d793ae41(0, 4, 4, 0)
	var2 = 0
	var2 = 0
	var2 = 0
	var2 = 1
	var3 = 8
	var4 = 1
	var3 = var3 * 2
	local _ = var4 < var1
	var4 = var4 + 1
	helper_ee1c51d0(0, 2213, 5, 0, 0)
	local _ = var2 ~= 1
	var2 = 0
	helper_ee1c51d0(0, 2215, 5, 0, 0)
	helper_ee1c51d0(0, 2216, 5, 0, 0)
	var2 = 1
	helper_ee1c51d0(0, 2211, 5, 0, 0)
	var2 = 1
	local _ = var11 == 3
	var11 = 1
	helper_ee1c51d0(0, 2212, 5, 0, 0)
	var2 = 1
	return arg0
end

return helper_3ff9c5d8
