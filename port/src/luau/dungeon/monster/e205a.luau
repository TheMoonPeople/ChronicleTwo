--!strict
-- dungeon/monster/e205a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
local helper_5743cba3 = require("@lib/monster/helper_5743cba3")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e91cba05 = require("@lib/monster/helper_e91cba05")

--- Helper function.
local function helper_18d0(arg0: s32)
	local timer: s32 = 0
	timer = monster.get_dungeon_timer() or timer
	monster.set_variable(vm.i32(3 + arg0), timer)
end

--- Helper function.
local function helper_3250()
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
local function helper_2ee4()
	helper_e91cba05()
	if helper_a25c5b2e() ~= 0 then
		if helper_1aed60f3() ~= 0 then
			helper_65eb2b74(0)
		end
	end
	helper_1ef0d4b2()
	vm.wait()
end

--- Helper function.
local function helper_4250(arg0: f32, arg1: f32, arg2: f32)
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
			helper_2ee4()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_7178(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.get_target_angle() or var5
	local _ = helper_4250(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_1166c(arg0: any)
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		helper_2ee4()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				helper_7178(3.5)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_1193c()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_1166c(monster_id)
	end
end

--- Helper function.
local function helper_65a8(next_rot: f32, rot_speed: f32)
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
	local _ = helper_4250(
		helper_28452e16(next_rot),
		helper_28452e16(rot_speed),
		vm.f32(vm.fdiv(360.0, helper_28452e16(rot_speed)))
	)
	helper_442b9962()
end

--- Helper function.
local function helper_5738(arg0: f32, arg1: any)
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
			helper_2ee4()
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
local function helper_be2c(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
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
	helper_65a8(helper_28452e16(arg2), arg1)
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
	var19 = helper_5738(arg4, arg5)
	monster.stop_moving()
	return var19
end

--- Helper function.
local function helper_5c94(arg0: f32, arg1: f32, arg2: s32)
	for var8 = 0, arg2 - 1 do
		monster.get_rotation()
		monster.get_target_distance()
		monster.get_target_angle()
		helper_2ee4()
		if helper_5743cba3(arg0, arg1) == 1 then
			return 1
		end
	end
	return 0
end

--- Helper function.
local function helper_164c0()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 120.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = helper_be2c(vm.f32(1.8), 3.5, var3, var4, 80.0, 30)
		helper_7178(3.5)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_5c94(80.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_11d80(arg0: f32, arg1: f32, arg2: s32, arg3: f32)
	local var5: f32 = 0
	local var7: f32 = 0
	arg0 = helper_787df986(arg0)
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	monster.set_motion("歩き", -1.0, 0)
	var7 = vm.f32(var5 + arg0)
	helper_65a8(helper_28452e16(var7), arg1)
	monster.set_motion("立ち", -1, 0)
	if helper_5c94(arg3, 80.0, arg2) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	monster.set_motion("歩き", -1.0, 0)
	var7 = vm.f32(var5 - arg0)
	helper_65a8(helper_28452e16(var7), arg1)
	monster.set_motion("立ち", -1, 0)
	if helper_5c94(arg3, 80.0, arg2) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	monster.set_motion("歩き", -1.0, 0)
	var7 = vm.f32(var5 - arg0)
	helper_65a8(helper_28452e16(var7), arg1)
	monster.set_motion("立ち", -1, 0)
	if helper_5c94(arg3, 80.0, arg2) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	monster.set_motion("歩き", -1.0, 0)
	var7 = vm.f32(var5 + arg0)
	helper_65a8(helper_28452e16(var7), arg1)
	monster.set_motion("立ち", -1, 0)
	if helper_5c94(arg3, 80.0, arg2) == 1 then
		return 0
	end
	return 0
end

--- Helper function.
local function helper_8a54(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	helper_7178(rot_speed)
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
		helper_2ee4()
		var18 = var18 + 1
		monster.stop_moving()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_2fe8(arg0: s32)
	for var1 = 0, arg0 - 1 do
		helper_2ee4()
	end
end

--- Helper function.
local function helper_cf44(arg0: s32)
	monster.stop_moving()
	monster.reset_motion()
	monster.set_motion("立ち", -1, 4)
	helper_2fe8(arg0)
end

--- Helper function.
local function helper_15e94()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 40 then
		if helper_11d80(45.0, 3.5, 60, 200.0) == 1 then
			monster.set_motion("歩き", -1.0, 0)
			helper_7178(3.5)
			monster.set_motion("歩き", -1.0, 0)
			helper_8a54(vm.f32(1.8), 3.5, 80.0, 45)
			monster.set_motion("立ち", -1, 0)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("待機", -1, 0)
			if helper_5c94(310.0, 45.0, 75) == 1 then
				monster.set_motion("歩き", -1.0, 0)
				helper_7178(3.5)
				monster.set_motion("歩き", -1.0, 0)
				helper_8a54(vm.f32(1.8), 3.5, 80.0, 45)
				monster.set_motion("立ち", -1, 0)
			end
		else
			helper_cf44(30)
		end
	end
	helper_2ee4()
end

--- Helper function.
local function helper_6e04(rot_speed: f32, arg1: f32, arg2: s32)
	local var3: f32 = 0
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	var3 = monster.get_target_angle() or var3
	arg1 = helper_787df986(arg1)
	rot_speed = helper_787df986(rot_speed)
	if argc < arg2 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			var3 = vm.f32(var3 + arg1)
		else
			var3 = vm.f32(var3 - arg1)
		end
	end
	monster.turn_toward_angle(var3, rot_speed)
	local _ = helper_4250(helper_28452e16(var3), helper_28452e16(rot_speed), 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_19c8(arg0: s32)
	local timer: s32 = 0
	local value: s32 = 0
	timer = monster.get_dungeon_timer() or timer
	value = monster.get_variable(vm.i32(3 + arg0)) or value
	timer = vm.i32(timer - value)
	return timer
end

--- Helper function.
local function helper_3128()
	local var0: s32 = 0
	while true do
		helper_2ee4()
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_12688()
	monster.set_motion("攻撃１", -1, 2)
	helper_3128()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_6100(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	if arg1 == -1.0 then
		arg1 = vm.f32(0.03)
	end
	var3 = 0
	while true do
		helper_2ee4()
		var2 = monster.get_motion_progress() or var2
		if var2 < vm.f32(arg0 + arg1) and var2 > vm.f32(arg0 - arg1) then
			break
		else
			var4 = monster.is_motion_finished() or var4
			if var4 ~= 0 then
				break
			else
				var3 = vm.i32(var3 + 1)
			end
		end
	end
end

--- Helper function.
local function helper_127cc()
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: s32 = 0
	local argc_2: s32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var10: f32 = 0
	local grade: s32 = 0
	if helper_19c8(0) < 300 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("立ち", -1, 0)
			helper_2fe8(15)
		else
			monster.set_motion("歩き", -1, 0)
			helper_8a54(vm.f32(1.8), 7.0, 80.0, 90)
			helper_7178(3.5)
			helper_12688()
		end
	end
	helper_18d0(0)
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	helper_6100(vm.f32(0.412), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("トーレの煙")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	helper_2fe8(11)
	argc_2 = monster.get_monster_count() or argc_2
	if argc_2 < 18 then
		monster.get_random(3, argc)
		var4 = 0
		argc = vm.i32(argc + 1)
		while var4 < 3 do
			monster.set_monster_attributes(16, 1)
			do
				local out1, out2, out3 = monster.get_position_3()
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
			do
				local _, out2, _ = monster.get_rotation()
				var10 = out2 or var10
			end
			do
				local out1, out2, out3 = monster.get_point_from_facing(0.0, 10.0)
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
			grade = monster.get_monster_grade_2(-1) or grade
			monster.create_monster(vm.i32(16 + grade), pos_x_2, pos_y_2, pos_z_2, var10)
			helper_2ee4()
			var4 = var4 + 1
		end
	end
	helper_3128()
	helper_2fe8(15)
	monster.set_monster_attributes(16, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_7ec8(move_speed: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target: f32 = 0
	local target_3: f32 = 0
	local var11: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	helper_7178(arg1)
	helper_442b9962()
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var20 = monster.get_target_distance() or var20
	var21 = monster.get_clear_distance(move_speed + arg2, 0.0) or var21
	if var21 < vm.f32(move_speed + arg2) then
		return
	end
	do
		local _, out2, _ = monster.get_rotation()
		var11 = out2 or var11
	end
	target = vm.f32(pos_x + vm.f32(vm.sin(var11) * var20))
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(var11) * var20))
	monster.move_toward_position(target, pos_y - 20.0, target_3, move_speed, arg2 + move_speed)
	local _ = helper_5738(arg2, arg3)
	monster.stop_moving()
end

--- Helper function.
local function helper_a444(arg0: f32, arg1: f32, arg2: f32, range: f32, range_2: f32, arg5: f32, arg6: s32)
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
	helper_65a8(helper_28452e16(var21), arg1)
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
	local _ = helper_5738(arg5, arg6)
	monster.stop_moving()
end

--- Helper function.
local function helper_157b4()
	local argc: s32 = 0
	local argc_2: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 40 then
		argc_2 = monster.get_monster_count() or argc_2
		if argc_2 < 18 then
			monster.set_motion("歩き", -1.0, 0)
			helper_6e04(7.0, 30.0, 15)
			helper_127cc()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1.0, 0)
			helper_7178(3.5)
			monster.set_motion("歩き", -1.0, 0)
			helper_7ec8(vm.f32(1.8), 3.5, 80.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 30 then
				monster.set_motion("歩き", -1.0, 0)
				helper_a444(vm.f32(1.8), 3.5, 40.0, 180.0, 30.0, 80.0, 40)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				helper_5c94(150.0, 45.0, 45)
			end
		end
	end
	helper_2ee4()
end

--- Helper function.
local function helper_acf8(move_speed: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
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
	helper_5738(arg3, arg4)
	monster.stop_moving()
end

--- Helper function.
local function helper_15080()
	local argc: s32 = 0
	local var3: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 65 then
		monster.set_motion("歩き", -1.0, 0)
		helper_7178(3.5)
		helper_12688()
	else
		monster.get_target_distance()
		argc = monster.get_random(100) or argc
		if argc < 45 then
			monster.set_motion("歩き", -1.0, 0)
			helper_7178(3.5)
			monster.set_motion("歩き", -1.0, 0)
			helper_8a54(vm.f32(1.8), 3.5, 80.0, 50)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 30 then
				monster.set_motion("立ち", -1, 0)
				helper_5c94(120.0, 30.0, 45)
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_7178(3.5)
				var3 = monster.get_target_angle() or var3
				monster.set_motion("歩き", -1.0, 0)
				helper_acf8(vm.f32(1.8), helper_28452e16(var3), 100.0, 360.0, 45)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_169a0()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_2ee4()
		helper_1193c()
		var3 = monster.get_target_distance() or var3
		if var3 > 360.0 then
			monster.set_variable(0, 0)
			helper_2ee4()
			return
		elseif var3 > 120.0 then
			monster.set_variable(0, 0)
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin <= 0 then
			helper_2ee4()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_164c0()
			continue
		end
		if var3 < 360.0 and var3 >= 200.0 then
			helper_15e94()
		elseif var3 < 200.0 and var3 >= 120.0 then
			helper_157b4()
		else
			helper_15080()
		end
		helper_2ee4()
	end
end

--- Helper function.
local function helper_16ed0()
	local var3: f32 = 0
	local value: s32 = 0
	monster.set_variable(0, 0)
	while true do
		helper_2ee4()
		var3 = monster.get_target_distance() or var3
		-- retail: monster.set_variable(0, value) does nothing, since its handler stores only an integer or a float
		if var3 < 220.0 and value == 0 then
			monster.set_motion("立ち", -1, 0)
			monster.set_motion("歩き", -1.0, 0)
			helper_7178(vm.f32(2.45))
			monster.set_motion("立ち", -1, 0)
			helper_2ee4()
			monster.set_variable(0, 1)
			return
		end
		value = monster.get_variable(0) or value
		if value == 0 then
			monster.set_motion("待機", -1, 0)
			helper_2fe8(10)
		end
		if helper_a25c5b2e() ~= 0 then
			break
		end
	end
end

--- Helper function.
local function helper_186a4()
	local var0: f32 = 0
	local argc: s32 = 0
	monster.set_monster_attributes(16, 0)
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	helper_8a54(vm.f32(1.8), 7.0, 80.0, 60)
	monster.set_motion("立ち", -1, 0)
	var0 = monster.get_target_distance() or var0
	if var0 > 200.0 then
		argc = monster.get_monster_count() or argc
		if argc < 18 then
			monster.set_motion("歩き", -1.0, 0)
			helper_6e04(7.0, 30.0, 15)
			helper_127cc()
		end
	end
end

--- Helper function.
local function helper_13eb8()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var9: f32 = 0
	local argc_3: s32 = 0
	local argc_4: s32 = 0
	local var12: f32 = 0
	while true do
		helper_2ee4()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		var3 = monster.get_target_distance() or var3
		if var3 > 360.0 then
			helper_2ee4()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1.0, 0)
				helper_7178(vm.f32(1.8))
				monster.set_motion("歩き", -1.0, 0)
				helper_acf8(vm.f32(1.8), 180.0, 200.0, 200.0, 90)
			else
				monster.set_motion("立ち", -1, 0)
				helper_5c94(80.0, 90.0, 30)
			end
			continue
		end
		if var3 < 360.0 and var3 >= 200.0 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				argc_2 = monster.get_monster_count() or argc_2
				if argc_2 < 18 then
					monster.set_motion("歩き", -1.0, 0)
					helper_6e04(7.0, 30.0, 15)
					helper_127cc()
				end
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_7178(3.5)
				monster.set_motion("歩き", -1.0, 0)
				helper_7ec8(vm.f32(3.6), 3.5, 80.0, 30)
				monster.set_motion("立ち", -1, 0)
			end
		else
			var9 = monster.get_target_distance() or var9
			if var9 < 70.0 then
				argc = monster.get_random(100) or argc
				if argc < 60 then
					argc_3 = monster.get_monster_count() or argc_3
					if argc_3 < 18 then
						monster.set_motion("歩き", -1.0, 0)
						helper_6e04(7.0, 30.0, 15)
						helper_127cc()
					end
				end
			end
			argc = monster.get_random(100) or argc
			if argc < 65 then
				argc = monster.get_random(100) or argc
				if argc < 40 then
					argc_4 = monster.get_monster_count() or argc_4
					if argc_4 < 18 then
						monster.set_motion("歩き", -1.0, 0)
						helper_6e04(7.0, 30.0, 15)
						helper_127cc()
					end
				else
					monster.set_motion("歩き", -1.0, 0)
					helper_7178(7.0)
					helper_12688()
				end
			else
				argc = monster.get_random(100) or argc
				if argc < 70 then
					monster.set_motion("歩き", -1.0, 0)
					helper_7178(5.25)
					var12 = monster.get_target_angle() or var12
					helper_acf8(vm.f32(2.6999998), helper_28452e16(var12), 100.0, 360.0, 45)
				else
					monster.set_motion("歩き", -1.0, 0)
					helper_7178(3.5)
					monster.set_motion("歩き", -1.0, 0)
					helper_7ec8(vm.f32(2.6999998), 3.5, 80.0, 30)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
		helper_2ee4()
	end
end

--- Helper function.
local function helper_e3a0()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	helper_2ee4()
	monster.set_action_status(1)
end

--- Helper function.
local function helper_f0b8()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_2fe8(10)
	monster.reset_motion()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local var0: s32 = 0
	local get_not_used_texb: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	monster.register_damage_hit("通常攻撃", 10.0, "攻撃１", 0.3, 0.7, 1)
	monster.register_damage_hit("通常攻撃", 10.0, "攻撃１", 0.4, 0.8, 2)
	monster.call_command(171, var0) -- retail: the handler rejects 1 arguments
	if var0 == 0 then
		monster.set_photo_opportunity("待機", 0.0, 1.0, 1019)
	end
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var2 = monster.load_effect_script("トーレの煙", get_not_used_texb) or var2
		var3 = monster.load_effect_script("Ｍ小爆発", get_not_used_texb) or var3
		if (if var2 ~= 0 then 1 else var3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.reset_dungeon_timer()
	helper_18d0(0)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	helper_3250()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local gekirin: s32 = 0
	local var2: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(16, 0)
	while true do
		helper_2ee4()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			helper_1193c()
			var0 = monster.get_target_distance() or var0
			if helper_a25c5b2e() == 0 then
				print("normal mode ----------------------\n")
				if var0 < 360.0 then
					helper_65eb2b74(0)
					helper_169a0()
				else
					helper_16ed0()
				end
			else
				print("notice mode ----------------------\n")
				var2 = helper_243517f2(var2)
				if var0 < var2 then
					if var0 < 120.0 then
						helper_65eb2b74(0)
						helper_169a0()
					else
						helper_186a4()
					end
				else
					helper_65eb2b74(0)
					monster.set_variable(0, 0)
				end
			end
		else
			helper_13eb8()
		end
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
		helper_2ee4()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.set_monster_attributes(16, 0)
	helper_5d37e9f4()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_3128()
	helper_2fe8(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.set_monster_attributes(16, 0)
	helper_e3a0()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_3128()
	helper_2fe8(12)
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	monster.set_monster_attributes(16, 0)
	helper_ab4b367a()
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	monster.set_monster_attributes(16, 0)
	helper_49610f43()
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	monster.set_monster_attributes(16, 0)
	helper_49610f43()
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
	monster.set_monster_attributes(16, 0)
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_2ee4()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	monster.set_monster_attributes(16, 0)
	helper_f0b8()
	monster.stop_moving()
	monster.end_throw()
	helper_2fe8(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_3128()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	monster.set_monster_attributes(16, 0)
	helper_d30a9fa2()
	monster.set_motion("ダメージ", -1, 6)
	helper_2fe8(12)
	helper_e05438b5()
end

return script
