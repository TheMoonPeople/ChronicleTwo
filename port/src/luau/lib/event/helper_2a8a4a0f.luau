--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47343ad6 = require("@lib/event/helper_47343ad6")
local helper_5716569e = require("@lib/event/helper_5716569e")
local helper_a00daa3c = require("@lib/event/helper_a00daa3c")

--- Helper function.
local function helper_2a8a4a0f(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a00daa3c(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_47343ad6(arg0, 0, var5)
		end
		helper_5716569e(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_a00daa3c(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_47343ad6(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_5716569e(arg0)
end

return helper_2a8a4a0f
