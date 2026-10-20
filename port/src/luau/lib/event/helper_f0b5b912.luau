--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0af90df5 = require("@lib/event/helper_0af90df5")
local helper_2522b596 = require("@lib/event/helper_2522b596")
local helper_b22a2e75 = require("@lib/event/helper_b22a2e75")

--- Helper function.
local function helper_f0b5b912(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b22a2e75(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_2522b596(arg0, 0, var5)
		end
		helper_0af90df5(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_b22a2e75(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_2522b596(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_0af90df5(arg0)
end

return helper_f0b5b912
