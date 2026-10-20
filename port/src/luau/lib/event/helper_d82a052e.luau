--!strict
-- Shared event helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c080e46 = require("@lib/event/helper_0c080e46")
local helper_9f003eee = require("@lib/event/helper_9f003eee")
local helper_b0b5eabd = require("@lib/event/helper_b0b5eabd")

--- Helper function.
local function helper_d82a052e(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_0c080e46(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_b0b5eabd(arg0, 0, var6)
		end
		helper_9f003eee(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_0c080e46(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_b0b5eabd(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_9f003eee(arg0)
end

return helper_d82a052e
