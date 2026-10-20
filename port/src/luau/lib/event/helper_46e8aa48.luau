--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6b3518ef = require("@lib/event/helper_6b3518ef")
local helper_922071e7 = require("@lib/event/helper_922071e7")
local helper_95a41f48 = require("@lib/event/helper_95a41f48")

--- Helper function.
local function helper_46e8aa48(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_922071e7(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_95a41f48(arg0, 0, var6)
		end
		helper_6b3518ef(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_922071e7(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_95a41f48(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_6b3518ef(arg0)
end

return helper_46e8aa48
