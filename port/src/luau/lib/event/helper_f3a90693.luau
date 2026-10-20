--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_24d1805d = require("@lib/event/helper_24d1805d")
local helper_2ba993e3 = require("@lib/event/helper_2ba993e3")
local helper_42da9aa6 = require("@lib/event/helper_42da9aa6")

--- Helper function.
local function helper_f3a90693(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_24d1805d(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_42da9aa6(arg0, 0, var6)
		end
		helper_2ba993e3(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_24d1805d(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_42da9aa6(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_2ba993e3(arg0)
end

return helper_f3a90693
