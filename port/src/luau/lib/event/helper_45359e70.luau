--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27d4dc14 = require("@lib/event/helper_27d4dc14")
local helper_85bd97d8 = require("@lib/event/helper_85bd97d8")
local helper_cf9db1a6 = require("@lib/event/helper_cf9db1a6")

--- Helper function.
local function helper_45359e70(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_85bd97d8(arg0)
		return arg5
	end
	local _ = helper_27d4dc14(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_cf9db1a6(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_85bd97d8(arg0)
	return arg5
end

return helper_45359e70
