--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_604d1827 = require("@lib/event/helper_604d1827")
local helper_63f23066 = require("@lib/event/helper_63f23066")
local helper_a03f6352 = require("@lib/event/helper_a03f6352")

--- Helper function.
local function helper_65950238(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a03f6352(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_63f23066(arg0, 0, var5)
		end
		helper_604d1827(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_a03f6352(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_63f23066(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_604d1827(arg0)
end

return helper_65950238
