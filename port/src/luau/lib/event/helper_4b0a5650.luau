--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19ac8530 = require("@lib/event/helper_19ac8530")
local helper_40f32ea5 = require("@lib/event/helper_40f32ea5")
local helper_b9ea6aa8 = require("@lib/event/helper_b9ea6aa8")

--- Helper function.
local function helper_4b0a5650(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_19ac8530(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_40f32ea5(arg0, 0, var5)
		end
		helper_b9ea6aa8(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_19ac8530(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_40f32ea5(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_b9ea6aa8(arg0)
end

return helper_4b0a5650
