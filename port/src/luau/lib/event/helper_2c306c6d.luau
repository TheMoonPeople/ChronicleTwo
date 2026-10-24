--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_969c5ad6 = require("@lib/event/helper_969c5ad6")
local helper_d395a4a5 = require("@lib/event/helper_d395a4a5")
local helper_fba0f4b2 = require("@lib/event/helper_fba0f4b2")

--- Helper function.
local function helper_2c306c6d(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, sp: number)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d395a4a5(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_fba0f4b2(arg0, 0, var6, sp + 9)
		end
		helper_969c5ad6(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_d395a4a5(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_fba0f4b2(arg0, 0, var6, sp + 9)
	if vm.skipping() then
		return skip(2)
	end
	helper_969c5ad6(arg0)
end

return helper_2c306c6d
