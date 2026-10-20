--!strict
-- Shared monster helper used by 21 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_33b3650b = require("@lib/monster/helper_33b3650b")
local helper_66b3681f = require("@lib/monster/helper_66b3681f")

--- Helper function.
local function helper_de1504df(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	if arg4 > vm.f32(3.1415927) then
		arg4 = vm.f32(arg4 - vm.f32(6.2831855))
	end
	if arg4 <= vm.f32(-3.1415927) then
		arg4 = vm.f32(arg4 + vm.f32(6.2831855))
	end
	var9 = monster.GetHigh2(arg0, arg1, arg2) or var9
	arg1 = vm.f32(arg1 - vm.f32(arg1 - var9))
	if var9 < 0.0 then
		print("high=", var9, "-------------------\n")
		return -2
	end
	var12 = helper_66b3681f(var12)
	if var9 > var12 then
		return -2
	end
	var11 = helper_33b3650b(var11)
	var10 = monster.FlyingSearchArea(arg3 + var11, arg4) or var10
	if var10 < vm.f32(arg3 + var11) then
		return -1
	end
	return 0
end

return helper_de1504df
