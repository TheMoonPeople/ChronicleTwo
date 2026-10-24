--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_35fe0d1b = require("@lib/event/helper_35fe0d1b")
local helper_5eec0990 = require("@lib/event/helper_5eec0990")
local helper_c779c42e = require("@lib/event/helper_c779c42e")

--- Helper function.
local function helper_6213684d(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5eec0990(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_c779c42e(arg0, 0, var5)
		end
		helper_35fe0d1b(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_5eec0990(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_c779c42e(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_35fe0d1b(arg0)
end

return helper_6213684d
