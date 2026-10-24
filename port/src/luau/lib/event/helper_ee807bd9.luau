--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_85bd97d8 = require("@lib/event/helper_85bd97d8")
local helper_cf9db1a6 = require("@lib/event/helper_cf9db1a6")
local helper_f4e9c048 = require("@lib/event/helper_f4e9c048")

--- Helper function.
local function helper_ee807bd9(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f4e9c048(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_cf9db1a6(arg0, 0, var5)
		end
		helper_85bd97d8(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_f4e9c048(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_cf9db1a6(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_85bd97d8(arg0)
end

return helper_ee807bd9
