--!strict
-- Shared event helper used by 168 scripts, translated by tools/luau/stb2luau.

local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

--- Helper function.
local function helper_7d54f41c(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: s32 = 0
	local _ = helper_f018b3c0(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_d793ae41(arg0, arg5, arg6, 0)
	return var8
end

return helper_7d54f41c
