--!strict
-- Shared event helper used by 260 scripts, translated by tools/luau/stb2luau.

local helper_60f4dcf2 = require("@lib/event/helper_60f4dcf2")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_7ddc1f42 = require("@lib/event/helper_7ddc1f42")

--- Helper function.
local function helper_b5a98ffa(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	helper_60f4dcf2(arg0, arg1, arg2, arg3)
	do
		local _: any
		_, var5 = helper_7ddc1f42(arg0, 0, var5)
	end
	helper_6992f518(arg0)
end

return helper_b5a98ffa
