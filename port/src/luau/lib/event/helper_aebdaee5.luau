--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3e89157d = require("@lib/event/helper_3e89157d")
local helper_bd71c327 = require("@lib/event/helper_bd71c327")
local helper_c690067d = require("@lib/event/helper_c690067d")

--- Helper function.
local function helper_aebdaee5(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bd71c327(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_c690067d(arg0, 0, var5)
		end
		helper_3e89157d(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_bd71c327(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_c690067d(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_3e89157d(arg0)
end

return helper_aebdaee5
