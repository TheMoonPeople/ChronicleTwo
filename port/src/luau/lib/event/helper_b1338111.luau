--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b90ffbb8 = require("@lib/event/helper_b90ffbb8")
local helper_bcd84660 = require("@lib/event/helper_bcd84660")
local helper_fdffeda5 = require("@lib/event/helper_fdffeda5")

--- Helper function.
local function helper_b1338111(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_fdffeda5(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_bcd84660(arg0, 0, var6)
		end
		helper_b90ffbb8(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_fdffeda5(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_bcd84660(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_b90ffbb8(arg0)
end

return helper_b1338111
