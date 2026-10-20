--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5c123176 = require("@lib/event/helper_5c123176")
local helper_5e48b35f = require("@lib/event/helper_5e48b35f")
local helper_eb354717 = require("@lib/event/helper_eb354717")

--- Helper function.
local function helper_18063f80(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_eb354717(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_5e48b35f(arg0, 0, var6)
		end
		helper_5c123176(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_eb354717(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_5e48b35f(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_5c123176(arg0)
end

return helper_18063f80
