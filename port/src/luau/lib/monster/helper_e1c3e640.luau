--!strict
-- Shared monster helper used by 43 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_e1c3e640(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	helper_83e135e0(rot_speed)
	rot_speed = helper_787df986(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	var18 = 0
	while var18 < arg3 do
		var13 = monster.get_target_distance() or var13
		if var13 < arg2 then
			helper_442b9962()
			monster.stop_moving()
			return -1
		end
		var14 = monster.get_target_angle() or var14
		monster.turn_toward_angle(var14, rot_speed)
		monster.get_target_position()
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
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var15, var16, var17, pos_x, pos_y, pos_z)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var15, var16, var17)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.scale_vector(var15, var16, var17, arg0 + arg2)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.add_vectors(var15, var16, var17, pos_x, pos_y, pos_z)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		monster.move_toward_position(var15, pos_y - 20.0, var17, arg0, arg0)
		helper_b9fff8e1()
		var18 = var18 + 1
		monster.stop_moving()
		helper_442b9962()
	end
	return var18
end

return helper_e1c3e640
