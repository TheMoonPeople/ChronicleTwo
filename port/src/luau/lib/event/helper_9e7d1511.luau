--!strict
-- Shared event helper used by 121 scripts, translated by tools/luau/stb2luau.

local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_7ddc1f42 = require("@lib/event/helper_7ddc1f42")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")

--- Helper function.
local function helper_9e7d1511(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _ = helper_82705ce2(arg0, arg1, arg2, arg3, arg4)
	do
		local _: any
		_, var6 = helper_7ddc1f42(arg0, 0, var6)
	end
	helper_6992f518(arg0)
end

return helper_9e7d1511
