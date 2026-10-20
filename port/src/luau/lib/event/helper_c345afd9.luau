--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31ce49cc = require("@lib/event/helper_31ce49cc")
local helper_5cadcbc1 = require("@lib/event/helper_5cadcbc1")
local helper_ff2d03ef = require("@lib/event/helper_ff2d03ef")

--- Helper function.
local function helper_c345afd9(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_31ce49cc(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_ff2d03ef(arg0, 0, var5)
		end
		helper_5cadcbc1(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_31ce49cc(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_ff2d03ef(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_5cadcbc1(arg0)
end

return helper_c345afd9
