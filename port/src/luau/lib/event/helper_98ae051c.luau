--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6f2b38f5 = require("@lib/event/helper_6f2b38f5")
local helper_a33c92c8 = require("@lib/event/helper_a33c92c8")
local helper_cb99d2e8 = require("@lib/event/helper_cb99d2e8")

--- Helper function.
local function helper_98ae051c(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any, sp: number)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6f2b38f5(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_a33c92c8(arg0, 0, var5, sp + 8)
		end
		helper_cb99d2e8(arg0, sp + 7)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_6f2b38f5(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_a33c92c8(arg0, 0, var5, sp + 8)
	if vm.skipping() then
		return skip(3)
	end
	helper_cb99d2e8(arg0, sp + 7)
end

return helper_98ae051c
