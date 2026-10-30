--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local helper_33e2d523 = require("@lib/event/helper_33e2d523")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

--- Helper function.
local function helper_22a04edc(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _ = helper_f018b3c0(arg0, arg1, arg2, arg3, arg4)
	local _ = helper_33e2d523(arg0, arg5)
end

return helper_22a04edc
