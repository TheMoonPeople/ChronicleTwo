--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23369a5e = require("@lib/event/helper_23369a5e")
local helper_a47895cb = require("@lib/event/helper_a47895cb")
local helper_e62dd413 = require("@lib/event/helper_e62dd413")

--- Helper function.
local function helper_14d96446(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, sp: number)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_e62dd413(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_a47895cb(arg0, 0, var6, sp + 9)
		end
		helper_23369a5e(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_e62dd413(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_a47895cb(arg0, 0, var6, sp + 9)
	if vm.skipping() then
		return skip(2)
	end
	helper_23369a5e(arg0)
end

return helper_14d96446
