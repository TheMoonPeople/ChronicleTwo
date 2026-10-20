--!strict
-- Shared monster helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_7863d8b6 = require("@lib/monster/helper_7863d8b6")

--- Helper function.
local function helper_80832373(
	arg0: f32,
	arg1: f32,
	arg2: f32,
	arg3: f32,
	arg4: f32,
	arg5: f32,
	arg6: f32,
	arg7: f32,
	arg8: s32
)
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local pos_y: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	var19 = vm.f32(arg6 * vm.f32(0.017453292))
	var20 = monster.GetRefAngle(arg0, arg1, arg2) or var20
	var20 = vm.f32(var20 - vm.f32(3.1415927))
	var20 = vm.f32(var20 + var19)
	if var20 > vm.f32(3.1415927) then
		var20 = vm.f32(var20 - vm.f32(6.2831855))
	end
	if var20 <= vm.f32(-3.1415927) then
		var20 = vm.f32(var20 + vm.f32(6.2831855))
	end
	var9 = vm.f32(arg0 + vm.f32(arg5 * vm.sin(var20)))
	var10 = arg1
	var11 = vm.f32(arg2 + vm.f32(arg5 * vm.cos(var20)))
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	arg6 = monster.GetRefAngle(var9, var10, var11) or arg6
	helper_595cbf61(helper_28452e16(arg6), arg4)
	helper_442b9962()
	monster.SetNextPos(var9, pos_y - 20.0, var11, arg3, arg3)
	local _ = helper_7863d8b6(arg7, arg8)
	monster.ResetMove()
end

return helper_80832373
