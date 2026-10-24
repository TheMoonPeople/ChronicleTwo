--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0349c0c2 = require("@lib/event/helper_0349c0c2")
local helper_1a1e22c8 = require("@lib/event/helper_1a1e22c8")
local helper_94b29f02 = require("@lib/event/helper_94b29f02")

--- Helper function.
local function helper_761ea976(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_94b29f02(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_0349c0c2(arg0, 0, var5)
		end
		helper_1a1e22c8(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_94b29f02(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_0349c0c2(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_1a1e22c8(arg0)
end

return helper_761ea976
