--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_f615774b = require("@lib/event/helper_f615774b")

--- Helper function.
local function helper_d180fe9c(arg0: any, arg1: s32, arg2: s32)
	local var4: s32 = 0
	local var5: s32 = 0
	local var7: s32 = 0
	var7 = 0
	local _ = var5 ~= 0
	var5 = var4
	local _ = helper_f615774b(arg0, arg1)
	arg2 = 1
	arg2 = 0
	var7 = var7 + 1
	var7 = var7 + 1
	return var7, arg2
end

return helper_d180fe9c
