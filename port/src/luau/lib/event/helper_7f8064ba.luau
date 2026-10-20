--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_22e34d28 = require("@lib/event/helper_22e34d28")
local helper_cc5a75ce = require("@lib/event/helper_cc5a75ce")
local helper_d759a0ab = require("@lib/event/helper_d759a0ab")

--- Helper function.
local function helper_7f8064ba(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_22e34d28(arg0, arg1, arg2, arg3, arg4)
			_, arg5 = helper_cc5a75ce(arg0, 2, arg5)
		end
		helper_d759a0ab(arg0)
		return arg5
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_22e34d28(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_cc5a75ce(arg0, 2, arg5)
	if vm.skipping() then
		return skip(2)
	end
	helper_d759a0ab(arg0)
	return arg5
end

return helper_7f8064ba
