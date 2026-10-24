--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9f003eee = require("@lib/event/helper_9f003eee")
local helper_b0b5eabd = require("@lib/event/helper_b0b5eabd")
local helper_bf142b4b = require("@lib/event/helper_bf142b4b")

--- Helper function.
local function helper_fb6fbabc(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bf142b4b(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_b0b5eabd(arg0, 0, var5)
		end
		helper_9f003eee(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_bf142b4b(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_b0b5eabd(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_9f003eee(arg0)
end

return helper_fb6fbabc
