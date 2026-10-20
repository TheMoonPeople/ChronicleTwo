--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47343ad6 = require("@lib/event/helper_47343ad6")
local helper_522670ce = require("@lib/event/helper_522670ce")
local helper_5716569e = require("@lib/event/helper_5716569e")

--- Helper function.
local function helper_51999b4f(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_5716569e(arg0)
		return arg5
	end
	local _ = helper_522670ce(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_47343ad6(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_5716569e(arg0)
	return arg5
end

return helper_51999b4f
