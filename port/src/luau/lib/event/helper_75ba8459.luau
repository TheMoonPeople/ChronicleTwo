--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b90ffbb8 = require("@lib/event/helper_b90ffbb8")
local helper_cfb31f1f = require("@lib/event/helper_cfb31f1f")
local helper_fdffeda5 = require("@lib/event/helper_fdffeda5")

--- Helper function.
local function helper_75ba8459(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_fdffeda5(arg0, arg1, arg2, arg3, arg4)
			_, arg5 = helper_cfb31f1f(arg0, 1, arg5)
		end
		helper_b90ffbb8(arg0)
		return arg5
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_fdffeda5(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_cfb31f1f(arg0, 1, arg5)
	if vm.skipping() then
		return skip(2)
	end
	helper_b90ffbb8(arg0)
	return arg5
end

return helper_75ba8459
