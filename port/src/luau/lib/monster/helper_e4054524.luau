--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_067263da = require("@lib/monster/helper_067263da")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_7a6c1499 = require("@lib/monster/helper_7a6c1499")

--- Helper function.
local function helper_e4054524(
	target: f32,
	target_2: f32,
	target_3: f32,
	arg3: f32,
	arg4: f32,
	arg5: f32,
	arg6: f32,
	arg7: f32,
	arg8: s32
)
	local target_4: f32 = 0
	local target_2_2: f32 = 0
	local target_3_2: f32 = 0
	local pos_y: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	var19 = vm.f32(arg6 * vm.f32(0.017453292))
	var20 = monster.get_angle_to_position(target, target_2, target_3) or var20
	var20 = vm.f32(var20 - vm.f32(3.1415927))
	var20 = vm.f32(var20 + var19)
	if var20 > vm.f32(3.1415927) then
		var20 = vm.f32(var20 - vm.f32(6.2831855))
	end
	if var20 <= vm.f32(-3.1415927) then
		var20 = vm.f32(var20 + vm.f32(6.2831855))
	end
	target_4 = vm.f32(target + vm.f32(arg5 * vm.sin(var20)))
	target_2_2 = target_2
	target_3_2 = vm.f32(target_3 + vm.f32(arg5 * vm.cos(var20)))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	arg6 = monster.get_angle_to_position(target_4, target_2_2, target_3_2) or arg6
	helper_7a6c1499(helper_28452e16(arg6), arg4)
	helper_442b9962()
	monster.move_toward_position(target_4, pos_y - 20.0, target_3_2, arg3, arg3)
	local _ = helper_067263da(arg7, arg8)
	monster.stop_moving()
end

return helper_e4054524
