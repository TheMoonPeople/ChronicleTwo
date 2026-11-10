--!strict
-- dungeon/monster/e101a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_154d7e30 = require("@lib/monster/helper_154d7e30")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_274f6d9a = require("@lib/monster/helper_274f6d9a")
local helper_27a31f0d = require("@lib/monster/helper_27a31f0d")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_351dcd9e = require("@lib/monster/helper_351dcd9e")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a0577b0 = require("@lib/monster/helper_6a0577b0")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_708ce460 = require("@lib/monster/helper_708ce460")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_97f462c5 = require("@lib/monster/helper_97f462c5")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_c0339fe8 = require("@lib/monster/helper_c0339fe8")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_fbc2528f = require("@lib/monster/helper_fbc2528f")

--- Helper function.
local function helper_3194()
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
local function helper_115b0(arg0: any)
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		helper_274f6d9a()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				helper_708ce460(5.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_11880()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_115b0(monster_id)
	end
end

--- Helper function.
local function helper_bd70(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
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
	helper_154d7e30(helper_28452e16(arg2), arg1)
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
	var19 = helper_6a0577b0(arg4, arg5)
	monster.stop_moving()
	return var19
end

--- Helper function.
local function helper_11f28(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	var2 = 0
	monster.set_motion("遊び", -1, 0)
	while var2 < arg0 do
		if arg1 == 1 then
			var3 = helper_351dcd9e(75.0, 45.0, helper_9df6409a(84))
			if var3 == 1 then
				return var3
			end
		else
			var3 = 0
			helper_c0339fe8(helper_9df6409a(84))
		end
		var2 = var2 + 1
	end
	return 0
end

--- Helper function.
local function helper_d60c(rot_speed: f32)
	local var1: f32 = 0
	local var2: s32 = 0
	rot_speed = helper_787df986(rot_speed)
	while true do
		var1 = monster.get_target_angle() or var1
		monster.turn_toward_angle(var1, rot_speed)
		helper_274f6d9a()
		var2 = monster.is_motion_finished() or var2
		if var2 ~= 0 then
			helper_442b9962()
			break
		end
	end
end

--- Helper function.
local function helper_12240(arg0: s32)
	local target: f32 = 0
	local var2: f32 = 0
	local target_3: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃１in", -1, 2)
	helper_d60c(5.0)
	monster.set_motion("攻撃１", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var11 = out2 or var11
	end
	var13 = monster.get_target_distance() or var13
	target = vm.f32(pos_x + vm.f32(vm.f32(vm.sin(var11) * var13) * 2.0))
	target_3 = vm.f32(pos_z + vm.f32(vm.f32(vm.cos(var11) * var13) * 2.0))
	monster.move_toward_position(target, var2 - 10.0, target_3, 4.8, 4.8)
	helper_c0339fe8(arg0)
	monster.stop_moving()
	monster.reset_motion()
	monster.set_motion("攻撃１out", -1, 2)
	helper_fbc2528f()
end

--- Helper function.
local function helper_13724(move_speed: f32, arg1: f32)
	local pos_y: f32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local pos_x_2: f32 = 0
	local var8: f32 = 0
	local pos_z_2: f32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	argc_2 = monster.get_random(2) or argc_2
	monster.set_monster_attributes(32, 1)
	var10 = monster.get_target_distance() or var10
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x_2 = out1 or pos_x_2
		pos_z_2 = out3 or pos_z_2
	end
	var12 = monster.get_random_whole_number(10.0) or var12
	var10 = vm.f32(var10 + vm.f32(arg1 + var12))
	pos_x_2, var8, pos_z_2 = helper_125e5305(0.0, var10, pos_x_2, var8, pos_z_2)
	monster.set_motion("ステップ後", -1, 6)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(pos_x_2, pos_y, pos_z_2, move_speed, move_speed + 1.0)
	helper_c0339fe8(vm.i32(1 + argc_2))
	monster.set_monster_attributes(32, 0)
	helper_fbc2528f()
	monster.stop_moving()
	argc = monster.get_random(100) or argc
	if argc < 25 then
		helper_11f28(1, 1)
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1, 0)
			helper_708ce460(5.0)
			helper_12240(30)
			monster.set_motion("立ち", -1, 0)
			helper_c0339fe8(3)
		else
			monster.set_motion("立ち", -1)
		end
	end
end

--- Helper function.
local function helper_8998(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	helper_708ce460(rot_speed)
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
		helper_274f6d9a()
		var18 = var18 + 1
		monster.stop_moving()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_13ea8()
	local argc: s32 = 0
	local var1: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("立ち", -1, 0)
		helper_351dcd9e(30.0, 45.0, 30)
	else
		-- retail: the script tests this condition again, so its branch never runs
		if argc < 50 then
			argc = monster.get_random(100) or argc
			var3 = monster.get_random_whole_number(30.0) or var3
			var4 = monster.get_random_whole_number(30.0) or var4
			var4 = vm.f32(var4 + 90.0)
			if argc < 50 then
				var3 = vm.f32(-var3 - 30.0)
			else
				var3 = vm.f32(var3 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			var1 = helper_bd70(2.0, 5.0, var3, var4, 30.0, 30)
			helper_708ce460(5.0)
		elseif argc < 40 then
			argc = monster.get_random(2) or argc
			var1 = helper_11f28(vm.i32(1 + argc), 1)
			if var1 == 1 then
				argc = monster.get_random(100) or argc
				if argc < 10 then
					monster.set_motion("歩き", -1, 0)
					helper_708ce460(5.0)
					helper_13724(vm.f32(2.4), 25.0)
				else
					monster.set_motion("歩き", -1, 0)
					helper_8998(3.0, 5.0, 30.0, 30)
					helper_708ce460(5.0)
					helper_12240(30)
					monster.set_motion("立ち", -1, 0)
					helper_c0339fe8(3)
				end
			end
		end
	end
end

--- Helper function.
local function helper_a388(arg0: f32, arg1: f32, arg2: f32, range: f32, range_2: f32, arg5: f32, arg6: s32)
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
	helper_154d7e30(helper_28452e16(var21), arg1)
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
	local _ = helper_6a0577b0(arg5, arg6)
	monster.stop_moving()
end

--- Helper function.
local function helper_168ec()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 85 then
			monster.set_motion("歩き", -1, 0)
			helper_8998(2.0, 5.0, 90.0, 25)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			helper_351dcd9e(30.0, 45.0, 30)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 10 then
			monster.set_motion("歩き", -1, 0)
			helper_a388(2.0, 5.0, 30.0, 180.0, 30.0, 90.0, 25)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_127c0()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 4)
	helper_c0339fe8(helper_9df6409a(72))
	monster.set_motion("攻撃１", -1, 0)
	if argc < 50 then
		helper_c0339fe8(helper_9df6409a(15))
	else
		helper_27a31f0d(6.0, 5.0, 1.0, helper_9df6409a(15))
	end
	monster.reset_motion()
	monster.set_motion("攻撃１out", -1, 6)
	helper_fbc2528f()
	monster.reset_motion()
	monster.set_motion("立ち", -1, 4)
end

--- Helper function.
local function helper_15e88()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		if argc < 40 then
			argc = monster.get_random(2) or argc
			var1 = helper_11f28(vm.i32(1 + argc), 1)
			if var1 == 1 then
				argc = monster.get_random(100) or argc
				if argc < 10 then
					monster.set_motion("歩き", -1, 0)
					helper_708ce460(5.0)
					helper_13724(vm.f32(2.4), 25.0)
				else
					monster.set_motion("歩き", -1, 0)
					helper_8998(3.0, 5.0, 30.0, 30)
					helper_708ce460(5.0)
					helper_12240(30)
					monster.set_motion("立ち", -1, 0)
					helper_c0339fe8(3)
				end
			end
		else
			monster.set_motion("歩き", -1, 0)
			helper_708ce460(5.0)
			helper_127c0()
			helper_c0339fe8(3)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 15 then
			monster.set_motion("歩き", -1, 0)
			helper_708ce460(5.0)
			monster.set_motion("立ち", -1, 0)
			helper_351dcd9e(90.0, 45.0, 30)
		else
			argc = monster.get_random(100) or argc
			var2 = monster.get_random_whole_number(30.0) or var2
			if argc < 50 then
				var2 = vm.f32(-var2 - 30.0)
			else
				var2 = vm.f32(var2 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			var1 = helper_bd70(2.0, 5.0, var2, 60.0, 30.0, 40)
			helper_708ce460(5.0)
			if var1 == 1 then
				helper_12240(20)
			end
		end
	end
end

--- Helper function.
local function helper_12ec4(arg0: f32, arg1: f32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local target: f32 = 0
	local var5: f32 = 0
	local target_3: f32 = 0
	local pos_y: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local argc_3: s32 = 0
	argc = monster.get_random(2) or argc
	var10 = monster.get_target_distance() or var10
	monster.set_monster_attributes(32, 1)
	argc_2 = monster.get_random(100) or argc_2
	if argc_2 < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		var11 = arg1
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		var11 = -arg1
	end
	target, var5, target_3 = helper_125e5305(var11, var10, target, var5, target_3)
	helper_c0339fe8(vm.i32(1 + argc))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(target, pos_y - 10.0, target_3, arg0, arg0)
	monster.set_monster_attributes(32, 0)
	helper_fbc2528f()
	monster.stop_moving()
	var10 = monster.get_target_distance() or var10
	if var10 < 90.0 then
		argc_3 = monster.get_random(100) or argc_3
		if argc_3 < 50 then
			monster.set_motion("歩き", -1, 0)
			helper_708ce460(5.0)
			helper_12240(30)
			monster.set_motion("立ち", -1, 0)
			helper_c0339fe8(3)
		else
			monster.set_motion("立ち", -1)
		end
	else
		monster.set_motion("立ち", -1)
	end
end

--- Helper function.
local function helper_15370()
	local argc: s32 = 0
	local var1: s32 = 0
	local life: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	life = vm.bits_float(monster.get_life_int()) or life
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("歩き", -1, 0)
		helper_708ce460(5.0)
		helper_12240(20 + argc)
		monster.set_motion("立ち", -1, 0)
		helper_c0339fe8(3)
	else
		var3 = monster.get_target_distance() or var3
		if var3 > 30.0 then
			if life > 0.25 and life == 0.0 then
				monster.get_random(100, argc)
				monster.get_random_whole_number(30.0, var4)
				if argc < 50 then
					var4 = vm.f32(-var4 - 30.0)
				else
					var4 = vm.f32(var4 + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				var1 = helper_bd70(2.0, 5.0, var4, 60.0, 30.0, 40)
				helper_708ce460(5.0)
				if var1 == 1 then
					helper_12240(20)
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_708ce460(5.0)
				helper_127c0()
				helper_c0339fe8(3)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 60 then
				monster.set_motion("歩き", -1, 0)
				helper_708ce460(5.0)
				helper_13724(2.0, 15.0)
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_motion("立ち", -1, 0)
					helper_c0339fe8(2)
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_708ce460(5.0)
				helper_12ec4(2.0, 15.0)
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_motion("立ち", -1, 0)
					helper_c0339fe8(2)
				end
			end
		end
	end
end

--- Helper function.
local function helper_16dac()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_274f6d9a()
		helper_11880()
		var3 = monster.get_target_distance() or var3
		if var3 > 250.0 then
			helper_274f6d9a()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			helper_274f6d9a()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_13ea8()
			continue
		end
		if var3 < 250.0 and var3 >= 150.0 then
			helper_168ec()
		elseif var3 < 150.0 and var3 >= 90.0 then
			helper_15e88()
		else
			helper_15370()
		end
		helper_274f6d9a()
	end
end

--- Helper function.
local function helper_78c4(arg0: f32, move_speed: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
	local pos_y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	arg2 = helper_787df986(arg2)
	if arg2 < helper_787df986(arg0) then
		arg2 = vm.f32(arg2 + helper_787df986(arg0))
	end
	helper_154d7e30(helper_28452e16(arg2), arg0)
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
	local _ = helper_6a0577b0(arg4, arg5)
	monster.stop_moving()
end

--- Helper function.
local function helper_c6c0(
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
	helper_154d7e30(helper_28452e16(arg6), arg4)
	helper_442b9962()
	monster.move_toward_position(target_4, pos_y - 20.0, target_3_2, arg3, arg3)
	local _ = helper_6a0577b0(arg7, arg8)
	monster.stop_moving()
end

--- Helper function.
local function helper_ac3c(move_speed: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
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
	helper_6a0577b0(arg3, arg4)
	monster.stop_moving()
end

--- Helper function.
local function helper_f1b0()
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
	helper_274f6d9a()
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
	if var17 < 30.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1.0, 0)
		helper_154d7e30(var7, 5.0)
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 30.0)
		if var17 > 0.0 then
			helper_78c4(5.0, 2.0, var7, var17, 30.0, 30)
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
				helper_c6c0(place_pos_x, place_pos_y, place_pos_z, 2.0, 5.0, var5, var18, 30.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_154d7e30(var19, 5.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_97f462c5(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.get_random(100, argc)
			return
		end
	end
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			helper_97f462c5(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			helper_154d7e30(var7, 5.0)
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
					var1 = helper_bd70(2.0, 5.0, var20, var21, 30.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_154d7e30(var23, 5.0)
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
					helper_ac3c(2.0, var7, 1000.0, 30.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_97f462c5(100.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			helper_a388(2.0, 5.0, var5, 360.0, 40.0, 30.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_18774()
	helper_12240(60)
	monster.set_motion("歩き", -1, 0)
	helper_8998(2.0, 5.0, 30.0, 90)
	monster.set_motion("立ち", -1, 0)
	helper_12240(60)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_14758()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	local var9: f32 = 0
	monster.get_life_int()
	while true do
		helper_274f6d9a()
		var3 = monster.get_target_distance() or var3
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_13ea8()
			continue
		end
		if var3 < 90.0 then
			if argc < 45 then
				monster.set_motion("歩き", -1, 0)
				helper_708ce460(5.0)
				helper_12240(20 + argc)
				monster.set_motion("立ち", -1, 0)
				helper_c0339fe8(2)
			else
				var9 = monster.get_target_distance() or var9
				if var9 > 30.0 then
					monster.set_motion("歩き", -1, 0)
					helper_708ce460(5.0)
					helper_127c0()
					helper_c0339fe8(2)
				else
					argc = monster.get_random(100) or argc
					if argc < 60 then
						monster.set_motion("歩き", -1, 0)
						helper_708ce460(5.0)
						helper_13724(5.0, 30.0)
						argc = monster.get_random(100) or argc
						if argc < 50 then
							monster.set_motion("立ち", -1, 0)
							helper_c0339fe8(2)
						end
					else
						monster.set_motion("歩き", -1, 0)
						helper_708ce460(5.0)
						helper_12ec4(5.0, 30.0)
						argc = monster.get_random(100) or argc
						if argc < 50 then
							monster.set_motion("立ち", -1, 0)
							helper_c0339fe8(2)
						end
					end
				end
			end
		elseif var3 > 150.0 then
			monster.set_motion("歩き", -1, 0)
			helper_8998(2.0, 5.0, 90.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			helper_708ce460(5.0)
			helper_127c0()
			helper_c0339fe8(3)
		end
	end
end

--- Helper function.
local function helper_18990()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	var0 = monster.get_target_distance() or var0
	if gekirin > 0 then
		helper_11880()
		if helper_a25c5b2e() == 0 then
			if var0 < 90.0 then
				helper_16dac()
			else
				helper_f1b0()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 150.0 then
					monster.set_monster_escape_rate(-1, 1.0)
					helper_65eb2b74(0)
					helper_16dac()
				else
					monster.set_monster_escape_rate(-1, 10.0)
					helper_18774()
				end
			else
				monster.set_monster_escape_rate(-1, 1.0)
				helper_65eb2b74(0)
			end
		end
	else
		helper_14758()
	end
end

--- Helper function.
local function helper_e2e4()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	helper_274f6d9a()
	monster.set_action_status(1)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("吹っ飛び攻撃", 8.0, "攻撃１in", 0.887, 1.0, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 8.0, "攻撃１", 0.0, 0.5, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 8.0, "攻撃１", 0.5, 1.0, 0)
	monster.register_damage_hit("通常攻撃", 9.0, "攻撃２", 0.38, 0.68, 0, 1)
	monster.add_sword_trail(0, "攻撃２", 0.2, 0.22, "dcol0", "dcol1", 50, 10, 15)
	helper_3194()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.stop_moving()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_274f6d9a()
		helper_18990()
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
		helper_274f6d9a()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	local argc: s32 = 0
	helper_5d37e9f4()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_fbc2528f()
	helper_c0339fe8(12)
	monster.set_motion("立ち")
	argc = monster.get_random(100) or argc
	if argc < 8 then
		monster.set_motion("ステップ後", -1, 0)
		helper_13724(3.0, 30.0)
	end
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_e2e4()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_fbc2528f()
	monster.set_action_status(1)
	helper_c0339fe8(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_fbc2528f()
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local argc: s32 = 0
	helper_49610f43()
	argc = monster.get_random(20) or argc
	if argc < 20 then
		monster.set_motion("歩き", -1, 0)
		helper_708ce460(5.0)
		helper_12ec4(3.0, 45.0)
	else
		monster.set_motion("ステップ後", -1, 0)
		helper_13724(3.0, 30.0)
	end
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.set_motion("歩き", -1, 0)
	helper_708ce460(5.0)
	helper_12ec4(3.0, 45.0)
	monster.set_motion("立ち")
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
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_fbc2528f()
	monster.set_motion("起き上がり", -1, 6)
	helper_fbc2528f()
	helper_e05438b5()
end

return script
