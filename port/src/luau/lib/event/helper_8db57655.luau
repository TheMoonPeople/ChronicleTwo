--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_c7fd75fb = require("@lib/event/helper_c7fd75fb")

--- Helper function.
local function helper_8db57655(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _ = helper_82705ce2(arg0, arg1, arg2, arg3, arg4)
	local _ = helper_c7fd75fb(arg0, arg5)
	event.SetMesPos(arg0, 0)
end

return helper_8db57655
