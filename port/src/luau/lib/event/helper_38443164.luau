--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_87d9cac7 = require("@lib/event/helper_87d9cac7")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_e1be9f05 = require("@lib/event/helper_e1be9f05")

--- Helper function.
local function helper_38443164(arg0: s32, arg1: s32, arg2: any, arg3: any, arg4: any)
	local var5: s32 = 0
	helper_e1be9f05(arg0, arg1, arg2, arg3)
	do
		local _: any
		_, var5 = helper_87d9cac7(arg0, 0, var5)
	end
	helper_d16eef1e(arg0)
end

return helper_38443164
