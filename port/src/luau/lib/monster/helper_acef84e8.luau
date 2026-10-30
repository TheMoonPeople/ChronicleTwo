--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_acef84e8(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: s32 = 0
	helper_83e135e0(rot_speed)
	rot_speed = helper_787df986(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	var25 = 0
	while var25 < arg3 do
		var16 = monster.get_target_distance() or var16
		if var16 < arg2 then
			helper_442b9962()
			monster.stop_moving()
			return -1
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var21 = out1 or var21
			var22 = out2 or var22
			var23 = out3 or var23
		end
		pos_y_2 = vm.f32(pos_y_2 + 25.0)
		var22 = vm.f32(var22 + 25.0)
		do
			local out1, out2, out3 = monster.subtract_vectors(var21, var22, var23, pos_x_2, pos_y_2, pos_z_2)
			var21 = out1 or var21
			var22 = out2 or var22
			var23 = out3 or var23
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var21, var22, var23)
			var21 = out1 or var21
			var22 = out2 or var22
			var23 = out3 or var23
		end
		do
			local out1, out2, out3 = monster.scale_vector(var21, var22, var23, arg0 + arg2)
			var21 = out1 or var21
			var22 = out2 or var22
			var23 = out3 or var23
		end
		do
			local out1, out2, out3 = monster.add_vectors(var21, var22, var23, pos_x_2, pos_y_2, pos_z_2)
			var21 = out1 or var21
			var22 = out2 or var22
			var23 = out3 or var23
		end
		var24 = monster.get_clear_distance_between(pos_x_2, pos_y_2, pos_z_2, var21, var22, var23) or var24
		if var24 < vm.f32(vm.f32(arg0 + arg2) - 1.0) then
			helper_442b9962()
			monster.stop_moving()
			return -2
		end
		var17 = monster.get_target_angle() or var17
		monster.turn_toward_angle(var17, rot_speed)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.get_rotation()
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_target_position()
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var13, var14, var15, pos_x, pos_y, pos_z)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var13, var14, var15)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = monster.scale_vector(var13, var14, var15, arg0 * 10.0)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = monster.add_vectors(var13, var14, var15, pos_x, pos_y, pos_z)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		monster.move_toward_position(var13, pos_y - 20.0, var15, arg0, arg0)
		helper_b9fff8e1()
		var25 = var25 + 1
		monster.stop_moving()
		helper_442b9962()
	end
	return var25
end

return helper_acef84e8
