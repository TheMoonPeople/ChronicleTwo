--!strict
-- Shared monster helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_7863d8b6 = require("@lib/monster/helper_7863d8b6")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_dc78fc76(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local pos_y: f32 = 0
	local var11: f32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	arg3 = helper_787df986(arg3)
	var19 = monster.GetRndf(arg4) or var19
	var20 = monster.GetRndf(arg3) or var20
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x_2 = out1 or pos_x_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local _, out2, _ = monster.GetRot()
		var21 = out2 or var21
	end
	var21 = vm.f32(var21 + helper_787df986(var20))
	helper_595cbf61(helper_28452e16(var21), arg1)
	helper_442b9962()
	do
		local _, out2, _ = monster.GetRot()
		var11 = out2 or var11
	end
	var22 = monster.SearchArea(100.0, 0.0) or var22
	if var22 == 100.0 then
		var19 = vm.f32(var19 + vm.f32(arg2 + arg0))
		pos_x_2 = vm.f32(pos_x_2 + vm.f32(var19 * vm.sin(var11)))
		pos_z_2 = vm.f32(pos_z_2 + vm.f32(var19 * vm.cos(var11)))
	else
		var22 = vm.f32(var22 - arg5)
		if var22 > 0.0 then
			pos_x_2 = vm.f32(pos_x_2 + vm.f32(var19 * vm.sin(var11)))
			pos_z_2 = vm.f32(pos_z_2 + vm.f32(var19 * vm.cos(var11)))
		else
			return
		end
	end
	if var19 < arg0 then
		var19 = vm.f32(var19 + arg0)
	end
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	monster.SetNextPos(pos_x_2, pos_y - 20.0, pos_z_2, arg0, arg0)
	local _ = helper_7863d8b6(arg5, arg6)
	monster.ResetMove()
end

return helper_dc78fc76
