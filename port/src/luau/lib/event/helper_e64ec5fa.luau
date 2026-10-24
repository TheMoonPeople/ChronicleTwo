--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d1264e61 = require("@lib/event/helper_d1264e61")
local helper_d5f09cbd = require("@lib/event/helper_d5f09cbd")
local helper_d764167e = require("@lib/event/helper_d764167e")

--- Helper function.
local function helper_e64ec5fa(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d5f09cbd(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_d1264e61(arg0, 0, var6)
		end
		helper_d764167e(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_d5f09cbd(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_d1264e61(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_d764167e(arg0)
end

return helper_e64ec5fa
