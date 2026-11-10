--!strict
-- dungeon/monster/e227a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1aed60f3 = require("@lib/monster/helper_1aed60f3")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5af194a0 = require("@lib/monster/helper_5af194a0")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d742309a = require("@lib/monster/helper_d742309a")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e91cba05 = require("@lib/monster/helper_e91cba05")

--- Helper function.
local function helper_3400()
	local boss: s32 = 0
	helper_1adea708(500.0)
	helper_6911bbcd(80.0)
	helper_5a759074(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Helper function.
local function helper_18d0(arg0: f32)
	local var2: f32 = 0
	local var4: f32 = 0
	var4 = monster.get_target_angle() or var4
	do
		local _, out2, _ = monster.get_rotation()
		var2 = out2 or var2
	end
	if
		var2 < vm.f32(var4 + vm.f32(arg0 * vm.f32(0.017453292)))
		and var2 > vm.f32(var4 + vm.f32(-arg0 * vm.f32(0.017453292)))
	then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_1b3c()
	if helper_18d0(80.0) == 0 then
		monster.set_defense_rate(0.5)
	else
		monster.set_defense_rate(10.0)
	end
end

--- Helper function.
local function helper_3094()
	helper_e91cba05()
	if helper_a25c5b2e() ~= 0 then
		if helper_1aed60f3() ~= 0 then
			helper_65eb2b74(0)
		end
	end
	helper_1b3c()
	vm.wait()
end

--- Helper function.
local function helper_4400(arg0: f32, arg1: f32, arg2: f32)
	local var4: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	var8 = arg2
	if arg1 < 3.0 then
		var9 = helper_787df986(3.0)
	else
		var9 = arg1
	end
	var7 = 0.0
	while var7 < var8 do
		do
			local _, out2, _ = monster.get_rotation()
			var4 = out2 or var4
		end
		if var4 > vm.f32(arg0 - var9) and var4 < vm.f32(arg0 + var9) then
			helper_442b9962()
			break
		elseif helper_8971d3b6(arg0, var4, arg1) == 0 then
			helper_442b9962()
			break
		elseif var7 >= arg2 then
			helper_442b9962()
			break
		else
			helper_3094()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_7328(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.get_target_angle() or var5
	local _ = helper_4400(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_1181c(arg0: any)
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		helper_3094()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				helper_7328(vm.f32(4.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_11aec()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_1181c(monster_id)
	end
end

--- Helper function.
local function helper_12138(arg0: f32, arg1: s32)
	local rot_speed: f32 = 0
	local var3: f32 = 0
	rot_speed = vm.f32(arg0 * vm.f32(0.017453292))
	for var4 = 0, arg1 - 1 do
		var3 = monster.get_target_angle() or var3
		monster.turn_toward_angle(var3, rot_speed)
		if helper_8cdd6198(5.0) ~= 0 then
			return 1
		end
		helper_3094()
	end
	helper_442b9962()
	return 0
end

--- Helper function.
local function helper_3198(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_3094()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_8c04(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	helper_7328(rot_speed)
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
			return
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
		helper_3094()
		var18 = var18 + 1
		monster.stop_moving()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_32d8()
	local var0: s32 = 0
	while true do
		helper_3094()
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_13184()
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	helper_8c04(1.75, 6.0, 60.0, 75)
	helper_7328(8.0)
	monster.set_motion("攻撃１", -1, 2)
	helper_32d8()
	monster.set_motion("立ち", -1, 0)
	helper_3198(9)
end

--- Helper function.
local function helper_85e4(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: s32 = 0
	rot_speed = helper_787df986(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	var12 = 0
	while var12 < arg3 do
		var10 = monster.get_target_distance() or var10
		if var10 < arg2 then
			helper_442b9962()
			monster.stop_moving()
			return
		end
		var11 = monster.get_target_angle() or var11
		monster.turn_toward_angle(var11, rot_speed)
		do
			local out1, out2, out3 = monster.get_target_position()
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		monster.get_rotation()
		monster.move_toward_position(var4, var5 - 20.0, var6, arg0, arg0)
		helper_3094()
		var12 = var12 + 1
		monster.stop_moving()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_13440()
	monster.set_motion("歩き", -1, 0)
	helper_7328(6.0)
	monster.set_motion("攻撃２in", -1, 2)
	helper_32d8()
	monster.set_motion("攻撃２loop", -1, 0)
	helper_85e4(vm.f32(3.7), 4.0, 45.0, 90)
	monster.stop_moving()
	monster.set_motion("攻撃２out", -1, 6)
	helper_32d8()
	monster.set_motion("攻撃２end", -1, 2)
	helper_32d8()
	monster.set_motion("立ち", -1, 0)
	helper_3198(9)
end

--- Helper function.
local function helper_1632c()
	local argc: s32 = 0
	local var1: f32 = 0
	var1 = monster.get_target_distance() or var1
	if var1 < 75.0 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			if helper_8cdd6198(80.0) == 0 then
				monster.set_defense_rate(0.5)
			else
				monster.set_defense_rate(10.0)
			end
			monster.set_motion("歩き", -1, 0)
			if helper_12138(4.0, 70) ~= 0 then
				monster.set_motion("立ち", -1, 0)
				helper_3198(10)
			end
		else
			helper_13184()
		end
		return
	end
	if var1 >= 75.0 and var1 < 230.0 then
		argc = monster.get_random(100) or argc
		if argc < 95 then
			monster.set_motion("歩き", -1, 0)
			helper_12138(4.0, 70)
		else
			monster.set_defense_rate(1.0)
			helper_13440()
		end
	end
end

--- Helper function.
local function helper_6758(next_rot: f32, rot_speed: f32)
	next_rot = helper_787df986(next_rot)
	if next_rot > vm.f32(3.1415927) then
		next_rot = vm.f32(next_rot - vm.f32(6.2831855))
	end
	if next_rot <= vm.f32(-3.1415927) then
		next_rot = vm.f32(next_rot + vm.f32(6.2831855))
	end
	rot_speed = helper_787df986(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(next_rot, rot_speed)
	local _ = helper_4400(
		helper_28452e16(next_rot),
		helper_28452e16(rot_speed),
		vm.f32(vm.fdiv(360.0, helper_28452e16(rot_speed)))
	)
	helper_442b9962()
end

--- Helper function.
local function helper_58e8(arg0: f32, arg1: any)
	local var2: s32 = 0
	local arrived: s32 = 0
	local var4: f32 = 0
	var2 = 0
	while var2 < arg1 do
		arrived = monster.is_move_finished() or arrived
		var4 = monster.get_target_distance() or var4
		if var4 < arg0 then
			monster.stop_moving()
			return 1
		end
		if arrived == 0 then
			helper_3094()
		else
			monster.stop_moving()
			return 2
		end
		if arrived == 1 then
			monster.stop_moving()
			return 1
		end
		var2 = vm.i32(var2 + 1)
	end
	return 0
end

--- Helper function.
local function helper_7b30(arg0: f32, move_speed: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
	local pos_y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	arg2 = helper_787df986(arg2)
	if arg2 < helper_787df986(arg0) then
		arg2 = vm.f32(arg2 + helper_787df986(arg0))
	end
	helper_6758(helper_28452e16(arg2), arg0)
	helper_442b9962()
	if arg3 < move_speed then
		arg3 = vm.f32(move_speed + 1.0)
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_x_2 = vm.f32(pos_x_2 + vm.f32(vm.sin(arg2) * arg3))
	pos_z_2 = vm.f32(pos_z_2 + vm.f32(vm.cos(arg2) * arg3))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(pos_x_2, pos_y - 20.0, pos_z_2, move_speed, move_speed + 1.0)
	local _ = helper_58e8(arg4, arg5)
	monster.stop_moving()
end

--- Helper function.
local function helper_c92c(
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
	helper_6758(helper_28452e16(arg6), arg4)
	helper_442b9962()
	monster.move_toward_position(target_4, pos_y - 20.0, target_3_2, arg3, arg3)
	local _ = helper_58e8(arg7, arg8)
	monster.stop_moving()
end

--- Helper function.
local function helper_60d4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
	for var5 = 0, arg4 - 1 do
		helper_3094()
		if helper_5af194a0(arg0, arg1, arg2, arg3) == 1 then
			return 1
		end
	end
	return 0
end

--- Helper function.
local function helper_bfdc(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
	local var6: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: s32 = 0
	var6, target_2, target_3 = helper_125e5305(arg2, arg3, var6, target_2, target_3)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	arg2 = monster.get_angle_to_position(var6, target_2, target_3) or arg2
	if arg2 > vm.f32(3.1415927) then
		arg2 = vm.f32(arg2 - vm.f32(6.2831855))
	end
	if arg2 <= vm.f32(-3.1415927) then
		arg2 = vm.f32(arg2 + vm.f32(6.2831855))
	end
	helper_6758(helper_28452e16(arg2), arg1)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.copy_vector(var6, target_2, target_3) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
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
	var18 = monster.get_clear_distance(arg0 + arg4, 0.0) or var18
	if var18 < vm.f32(arg0 + arg4) then
		var6 = vm.f32(pos_x + vm.f32(vm.sin(arg2) * var18))
		target_2 = pos_y
		target_3 = vm.f32(pos_z + vm.f32(vm.cos(arg2) * var18))
		var18 = vm.f32(var18 - arg4)
		if var18 < arg4 then
			return -1
		end
	end
	monster.move_toward_position(var6, pos_y - 20.0, target_3, arg0, arg0)
	var19 = helper_58e8(arg4, arg5)
	monster.stop_moving()
	return var19
end

--- Helper function.
local function helper_aea8(move_speed: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
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
	helper_58e8(arg3, arg4)
	monster.stop_moving()
end

--- Helper function.
local function helper_a5f4(arg0: f32, arg1: f32, arg2: f32, range: f32, range_2: f32, arg5: f32, arg6: s32)
	local pos_y: f32 = 0
	local var11: f32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	range = helper_787df986(range)
	var19 = monster.get_random_whole_number(range_2) or var19
	var20 = monster.get_random_whole_number(range) or var20
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x_2 = out1 or pos_x_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local _, out2, _ = monster.get_rotation()
		var21 = out2 or var21
	end
	var21 = vm.f32(var21 + helper_787df986(var20))
	helper_6758(helper_28452e16(var21), arg1)
	helper_442b9962()
	do
		local _, out2, _ = monster.get_rotation()
		var11 = out2 or var11
	end
	var22 = monster.get_clear_distance(100.0, 0.0) or var22
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
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(pos_x_2, pos_y - 20.0, pos_z_2, arg0, arg0)
	local _ = helper_58e8(arg5, arg6)
	monster.stop_moving()
end

--- Helper function.
local function helper_f41c()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var15: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	helper_3094()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var5 = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or var5
	do
		local _, out2, _ = monster.get_rotation()
		var15 = out2 or var15
	end
	var17 = monster.get_clear_distance(100.0, 0.0) or var17
	if var17 < 60.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1.0, 0)
		helper_6758(var7, vm.f32(4.8))
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 60.0)
		if var17 > 0.0 then
			helper_7b30(vm.f32(4.8), 1.75, var7, var17, 60.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if var5 > 300.0 then
		argc = monster.get_random(100) or argc
		if argc < 90 then
			if var5 > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			argc = monster.get_random(100) or argc
			if argc < 30 then
				monster.set_variable(0, 4)
				argc = monster.get_random(100) or argc
				var18 = monster.get_random_whole_number(360.0) or var18
				var5 = monster.get_random_whole_number(150.0) or var5
				if argc < 50 then
					var18 = vm.f32(-var18 - 30.0)
				else
					var18 = vm.f32(var18 + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				helper_c92c(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), var5, var18, 60.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_6758(var19, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_60d4(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.get_random(100, argc)
			return
		end
	end
	argc = monster.get_random(100) or argc
	if argc < 70 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			helper_60d4(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			helper_6758(var7, vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_variable(0, 4)
					argc = monster.get_random(100) or argc
					var20 = monster.get_random_whole_number(180.0) or var20
					var21 = monster.get_random_whole_number(30.0) or var21
					var22 = monster.get_target_distance() or var22
					var21 = vm.f32(var21 + var22)
					if argc < 50 then
						var20 = vm.f32(var20 * -1.0)
					end
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var20 = vm.f32(-var20 - 30.0)
					else
						var20 = vm.f32(var20 + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					var1 = helper_bfdc(1.75, vm.f32(4.8), var20, var21, 60.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_6758(var23, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						var15 = out2 or var15
					end
					var7 = helper_28452e16(var15)
					if var7 > vm.f32(3.1415927) then
						var7 = vm.f32(var7 - vm.f32(6.2831855))
					end
					if var7 <= vm.f32(-3.1415927) then
						var7 = vm.f32(var7 + vm.f32(6.2831855))
					end
					helper_aea8(1.75, var7, 1000.0, 60.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_60d4(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
		elseif var2 == 8 then
			monster.set_variable(0, 1)
			argc = monster.get_random(120) or argc
			var5 = monster.get_target_distance() or var5
			argc = vm.i32(argc + 15)
			monster.set_motion("歩き", -1.0, 0)
			helper_a5f4(1.75, vm.f32(4.8), var5, 360.0, 40.0, 60.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_168b4()
	monster.set_motion("歩き", -1, 0)
	helper_12138(4.0, 90)
	monster.set_motion("歩き", -1, 0)
	helper_85e4(1.75, 4.0, 45.0, 30)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_16ab8()
	local var0: f32 = 0
	local var1: f32 = 0
	helper_11aec()
	var0 = monster.get_target_distance() or var0
	if helper_a25c5b2e() == 0 then
		if var0 < 230.0 then
			helper_1632c()
		else
			monster.set_defense_rate(1.0)
			helper_f41c()
		end
	else
		var1 = helper_243517f2(var1)
		if var0 < var1 then
			if var0 < 135.0 then
				helper_65eb2b74(0)
				helper_1632c()
			else
				helper_168b4()
			end
		else
			helper_65eb2b74(0)
		end
	end
end

--- Helper function.
local function helper_e550()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	helper_3094()
	monster.set_action_status(1)
end

--- Helper function.
local function helper_12bf0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var4 = out2 or var4
	end
	var4 = vm.f32(var4 + vm.f32(3.1415927))
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(var4)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(var4)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 6)
	helper_3198(helper_9df6409a(8))
	monster.move_toward_position(pos_x, pos_y, pos_z, 1.75, 1.75)
	helper_3198(helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_32d8()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_12430()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var9: f32 = 0
	local argc: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var4 = out2 or var4
	end
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("ステップ左", -1, 6)
		var4 = vm.f32(var4 + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 6)
		var4 = vm.f32(var4 - vm.f32(1.5707964))
	end
	var9 = 100.0
	target = vm.f32(pos_x + vm.f32(vm.sin(var4) * var9))
	target_2 = vm.f32(pos_y - 20.0)
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(var4) * var9))
	helper_3198(helper_9df6409a(8))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target, target_2, target_3, 1.75, 1.75)
	helper_3198(helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_32d8()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_f1b8()
	while true do
		helper_3094()
	end
end

--- Helper function.
local function helper_f268()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_3198(10)
	monster.reset_motion()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("弱攻撃", 8.0, "攻撃１", 0.365, 0.487, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 10.0, "攻撃２loop", 0.0, 1.0, 1)
	monster.set_variable(0, 0)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("攻撃１", 0.122, 0.457, 1021)
	end
	helper_3400()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		helper_3094()
		helper_16ab8()
	end
end

--- Reacts to a hit while greyed out, or to a hit that greys it out.
function script.on_status_hit()
	local var0: s32 = 0
	helper_5d37e9f4()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	var0 = 1
	while var0 ~= 0 do
		var0 = monster.get_status_ailments(40) or var0
		helper_3094()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	if helper_8cdd6198(60.0) == 0 then
		monster.set_defense_rate(0.5)
	else
		monster.set_defense_rate(10.0)
	end
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	monster.set_monster_attributes(32, 1)
	helper_32d8()
	helper_3198(6)
	monster.set_monster_attributes(32, 0)
	helper_3198(6)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_e550()
	monster.set_defense_rate(1.0)
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_32d8()
	monster.set_action_status(1)
	helper_3198(10)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_32d8()
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("歩き", -1, 0)
	helper_7328(20.0)
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_3198(8)
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, var0, 0.0)
	helper_3094()
	helper_12bf0()
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, var0, 0.0)
	helper_3094()
	helper_12430()
	monster.set_motion("歩き", -1, 0)
	helper_7328(4.0)
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_d742309a()
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_3094()
	end
	helper_f1b8()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_f268()
	monster.stop_moving()
	monster.end_throw()
	helper_3198(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_32d8()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_defense_rate(1.0)
	monster.set_motion("吹っ飛び", -1, 6)
	helper_32d8()
	monster.set_motion("起き上がり", -1, 6)
	helper_32d8()
	helper_e05438b5()
end

return script
