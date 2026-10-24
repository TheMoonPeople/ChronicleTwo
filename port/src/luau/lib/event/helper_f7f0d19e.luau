--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c81fece = require("@lib/event/helper_1c81fece")
local helper_5cadcbc1 = require("@lib/event/helper_5cadcbc1")
local helper_ff2d03ef = require("@lib/event/helper_ff2d03ef")

--- Helper function.
local function helper_f7f0d19e(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1c81fece(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_ff2d03ef(arg0, 0, var6)
		end
		helper_5cadcbc1(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_1c81fece(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_ff2d03ef(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_5cadcbc1(arg0)
end

return helper_f7f0d19e
