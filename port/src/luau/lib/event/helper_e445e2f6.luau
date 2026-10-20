--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_69d1dd55 = require("@lib/event/helper_69d1dd55")
local helper_8f3694dd = require("@lib/event/helper_8f3694dd")
local helper_a31a7b46 = require("@lib/event/helper_a31a7b46")

--- Helper function.
local function helper_e445e2f6(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_8f3694dd(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_a31a7b46(arg0, 0, var6)
		end
		helper_69d1dd55(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_8f3694dd(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_a31a7b46(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_69d1dd55(arg0)
end

return helper_e445e2f6
