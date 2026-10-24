--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_7e2ff146 = require("@lib/event/helper_7e2ff146")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")

--- Helper function.
local function helper_32eed468(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _ = helper_82705ce2(arg0, arg1, arg2, arg3, arg4)
	local _ = helper_7e2ff146(arg0, arg5)
	event.SetMesPos(arg0, 0)
end

return helper_32eed468
