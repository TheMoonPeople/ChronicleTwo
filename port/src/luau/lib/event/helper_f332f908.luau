--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_329c1757 = require("@lib/event/helper_329c1757")
local helper_5d763052 = require("@lib/event/helper_5d763052")
local helper_63b6ba28 = require("@lib/event/helper_63b6ba28")

--- Helper function.
local function helper_f332f908(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_329c1757(arg0)
		return arg5
	end
	local _ = helper_5d763052(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_63b6ba28(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_329c1757(arg0)
	return arg5
end

return helper_f332f908
