--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00026766 = require("@lib/event/helper_00026766")
local helper_5f77409f = require("@lib/event/helper_5f77409f")
local helper_f4c756d7 = require("@lib/event/helper_f4c756d7")

--- Helper function.
local function helper_53843df7(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_5f77409f(arg0)
		return arg5
	end
	local _ = helper_00026766(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_f4c756d7(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_5f77409f(arg0)
	return arg5
end

return helper_53843df7
