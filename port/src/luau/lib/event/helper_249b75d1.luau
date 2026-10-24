--!strict
-- Shared event helper used by 14 scripts, translated by tools/luau/stb2luau.

local helper_87d9cac7 = require("@lib/event/helper_87d9cac7")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_e1be9f05 = require("@lib/event/helper_e1be9f05")

--- Helper function.
local function helper_249b75d1(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: any)
	local var5: s32 = 0
	helper_e1be9f05(arg0, arg1, arg2, arg3)
	do
		local _: any
		_, var5 = helper_87d9cac7(arg0, 0, var5)
	end
	helper_d16eef1e(arg0)
end

return helper_249b75d1
