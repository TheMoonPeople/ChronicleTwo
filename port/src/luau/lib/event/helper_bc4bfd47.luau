--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00026766 = require("@lib/event/helper_00026766")
local helper_5f77409f = require("@lib/event/helper_5f77409f")
local helper_f4c756d7 = require("@lib/event/helper_f4c756d7")

--- Helper function.
local function helper_bc4bfd47(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_00026766(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_f4c756d7(arg0, 0, var6)
		end
		helper_5f77409f(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_00026766(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_f4c756d7(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_5f77409f(arg0)
end

return helper_bc4bfd47
