--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_781c97dd = require("@lib/event/helper_781c97dd")
local helper_d29b6292 = require("@lib/event/helper_d29b6292")
local helper_e85c91da = require("@lib/event/helper_e85c91da")

--- Helper function.
local function helper_dbd14b96(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e85c91da(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_d29b6292(arg0, 0, var5)
		end
		helper_781c97dd(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_e85c91da(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_d29b6292(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_781c97dd(arg0)
end

return helper_dbd14b96
