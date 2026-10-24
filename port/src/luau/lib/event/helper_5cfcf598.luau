--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1953c457 = require("@lib/event/helper_1953c457")
local helper_5c0f57bf = require("@lib/event/helper_5c0f57bf")
local helper_ec8c1ff6 = require("@lib/event/helper_ec8c1ff6")

--- Helper function.
local function helper_5cfcf598(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ec8c1ff6(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_5c0f57bf(arg0, 0, var5)
		end
		helper_1953c457(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_ec8c1ff6(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_5c0f57bf(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_1953c457(arg0)
end

return helper_5cfcf598
