--!strict
-- Shared event helper used by 30 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_d5638365 = require("@lib/event/helper_d5638365")
local helper_dc39b923 = require("@lib/event/helper_dc39b923")

--- Helper function.
local function helper_d1353c5b(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_dc39b923(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_d5638365(arg0, 0, var6)
		end
		helper_7e2956fd(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_dc39b923(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_d5638365(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_7e2956fd(arg0)
end

return helper_d1353c5b
