--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_b6e37bb7 = require("@lib/event/helper_b6e37bb7")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

--- Helper function.
local function helper_0263ba85(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _ = helper_f018b3c0(arg0, arg1, arg2, arg3, arg4)
	local _ = helper_b6e37bb7(arg0, arg5)
end

return helper_0263ba85
