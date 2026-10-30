--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_d180fe9c = require("@lib/event/helper_d180fe9c")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

--- Helper function.
local function helper_2a0361d4(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _ = helper_f018b3c0(arg0, arg1, arg2, arg3, arg4)
	do
		local _: any
		_, var6 = helper_d180fe9c(arg0, 0, var6)
	end
	helper_d16eef1e(arg0)
end

return helper_2a0361d4
