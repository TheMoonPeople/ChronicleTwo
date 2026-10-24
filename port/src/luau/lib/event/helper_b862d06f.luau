--!strict
-- Shared event helper used by 100 scripts, translated by tools/luau/stb2luau.

local helper_250b314c = require("@lib/event/helper_250b314c")
local helper_955d22b3 = require("@lib/event/helper_955d22b3")
local helper_ba297414 = require("@lib/event/helper_ba297414")

--- Helper function.
local function helper_b862d06f(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	var6 = helper_955d22b3(arg0, arg4, arg5)
	var8 = helper_250b314c(0, arg1, arg0, var7, arg2, arg3)
	helper_ba297414(arg0, var6, arg4, arg5)
	return var8
end

return helper_b862d06f
