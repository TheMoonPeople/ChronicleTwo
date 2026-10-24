--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_604d1827 = require("@lib/event/helper_604d1827")
local helper_63f23066 = require("@lib/event/helper_63f23066")
local helper_b4b9bfbc = require("@lib/event/helper_b4b9bfbc")

--- Helper function.
local function helper_41b1236d(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_b4b9bfbc(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_63f23066(arg0, 0, var6)
		end
		helper_604d1827(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_b4b9bfbc(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_63f23066(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_604d1827(arg0)
end

return helper_41b1236d
