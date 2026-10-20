--!strict
-- Shared monster helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_7863d8b6 = require("@lib/monster/helper_7863d8b6")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_a4ff7523(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
	local pos_y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	arg2 = helper_787df986(arg2)
	if arg2 < helper_787df986(arg0) then
		arg2 = vm.f32(arg2 + helper_787df986(arg0))
	end
	helper_595cbf61(helper_28452e16(arg2), arg0)
	helper_442b9962()
	if arg3 < arg1 then
		arg3 = vm.f32(arg1 + 1.0)
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_x_2 = vm.f32(pos_x_2 + vm.f32(vm.sin(arg2) * arg3))
	pos_x_2 = pos_x_2
	pos_y_2 = pos_y_2
	pos_z_2 = vm.f32(pos_z_2 + vm.f32(vm.cos(arg2) * arg3))
	pos_z_2 = pos_z_2
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	monster.SetNextPos(pos_x_2, pos_y - 20.0, pos_z_2, arg1, arg1 + 1.0)
	local _ = helper_7863d8b6(arg4, arg5)
	monster.ResetMove()
end

return helper_a4ff7523
