--!strict
-- Shared monster helper used by 44 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0682d2de = require("@lib/monster/helper_0682d2de")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_cd4ea219(move_speed: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
	local pos_y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	if arg2 < move_speed then
		arg2 = vm.f32(move_speed + 1.0)
	end
	arg1 = helper_787df986(arg1)
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_x_2 = vm.f32(pos_x_2 + vm.f32(vm.sin(arg1) * arg2))
	pos_z_2 = vm.f32(pos_z_2 + vm.f32(vm.cos(arg1) * arg2))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(pos_x_2, pos_y, pos_z_2, move_speed, move_speed + 1.0)
	helper_0682d2de(arg3, arg4)
	monster.stop_moving()
end

return helper_cd4ea219
