--!strict
-- dungeon/monster/e212a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_4a39d2ab = require("@lib/monster/helper_4a39d2ab")
local helper_54469cb2 = require("@lib/monster/helper_54469cb2")
local helper_549e2b35 = require("@lib/monster/helper_549e2b35")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5743cba3 = require("@lib/monster/helper_5743cba3")
local helper_57db7062 = require("@lib/monster/helper_57db7062")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_97d8f861 = require("@lib/monster/helper_97d8f861")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ade2dbe2 = require("@lib/monster/helper_ade2dbe2")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_ba87ea88 = require("@lib/monster/helper_ba87ea88")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_c9cc0e7b = require("@lib/monster/helper_c9cc0e7b")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_cd4ea219 = require("@lib/monster/helper_cd4ea219")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")

--- Helper function.
local function helper_3048()
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
local function helper_14cd0()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 150.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = helper_bfbcfc9f(1.75, vm.f32(4.8), var3, var4, 79.0, 30)
		helper_83e135e0(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(79.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_46b0(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local var6: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	var10 = arg4
	var9 = 0.0
	while var9 < var10 do
		do
			local _, out2, _ = monster.get_rotation()
			var6 = out2 or var6
		end
		if helper_5743cba3(arg2, arg3) ~= 0 then
			return -1
		end
		if var6 > vm.f32(arg0 - arg1) and var6 < vm.f32(arg0 + arg1) then
			helper_442b9962()
			break
		elseif helper_8971d3b6(arg0, var6, arg1) == 0 then
			helper_442b9962()
			break
		elseif var9 >= arg4 then
			helper_442b9962()
			break
		else
			helper_b9fff8e1()
			var9 = vm.f32(var9 + 1.0)
		end
	end
	helper_442b9962()
	return vm.ftoi(var9)
end

--- Helper function.
local function helper_12244()
	local var0: s32 = 0
	local var1: f32 = 0
	local rot_speed: f32 = 0
	var1 = monster.get_random_whole_number(360.0) or var1
	monster.set_motion("歩き", -1, 0)
	var1 = helper_787df986(var1)
	if var1 > vm.f32(3.1415927) then
		var1 = vm.f32(var1 - vm.f32(6.2831855))
	end
	if var1 <= vm.f32(-3.1415927) then
		var1 = vm.f32(var1 + vm.f32(6.2831855))
	end
	rot_speed = helper_787df986(vm.f32(4.8))
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(var1, rot_speed)
	var0 = helper_46b0(
		helper_28452e16(var1),
		helper_28452e16(rot_speed),
		350.0,
		60.0,
		vm.f32(vm.fdiv(360.0, helper_28452e16(rot_speed)))
	)
	helper_442b9962()
	if var0 == -1 then
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(vm.f32(4.8))
		monster.set_motion("走り", -1, 0)
		helper_e1c3e640(4.0, vm.f32(4.8), 79.0, 160)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(350.0, 60.0, 45)
	end
end

--- Helper function.
local function helper_12a40()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local value: f32 = 0
	local attack: s32 = 0
	monster.set_variable(0, 1)
	value = 8.0
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(7.2000003))
	monster.set_motion("攻撃１in", -1, 2)
	helper_c9cc0e7b(vm.f32(4.8))
	monster.set_motion("攻撃１", -1, 6)
	helper_4a39d2ab(vm.f32(0.15), -1.0)
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_rotation()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.get_frame_position("eff288")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var3, var4, var5, pos_x, pos_y, pos_z)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7 + vm.f32(0.18), var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value)
	do
		local out1, out2, out3 = monster.get_frame_position("eff289")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var3, var4, var5, pos_x, pos_y, pos_z)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7 + vm.f32(0.18), var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value - 1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("eff290")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var3, var4, var5, pos_x, pos_y, pos_z)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7 + vm.f32(0.18), var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value - 2.0)
	do
		local out1, out2, out3 = monster.get_frame_position("eff276")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var3, var4, var5, pos_x, pos_y, pos_z)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7 - vm.f32(0.18), var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value)
	do
		local out1, out2, out3 = monster.get_frame_position("eff277")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var3, var4, var5, pos_x, pos_y, pos_z)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7 - vm.f32(0.18), var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value - 1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("eff278")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var3, var4, var5, pos_x, pos_y, pos_z)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7 - vm.f32(0.18), var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value - 2.0)
	helper_cbe4d8e2()
	monster.set_motion("攻撃１out", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(6)
end

--- Helper function.
local function helper_166e8()
	local argc: s32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			helper_12244()
		else
			helper_12a40()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 90 then
			monster.set_motion("歩き", -1, 0)
			helper_e1c3e640(1.75, vm.f32(4.8), 150.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			helper_e62edeb2(79.0, 45.0, 75)
		end
	end
end

--- Helper function.
local function helper_14738()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(7.2000003))
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var3 = monster.get_target_angle() or var3
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var3) * 100.0))
	pos_y = vm.f32(pos_y - 20.0)
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var3) * 100.0))
	monster.set_motion("攻撃２", -1, 2)
	helper_4a39d2ab(vm.f32(0.323), -1.0)
	monster.move_toward_position(pos_x, pos_y, pos_z, 8.0, 8.0)
	helper_4a39d2ab(vm.f32(0.404), -1.0)
	monster.stop_moving()
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(6)
end

--- Helper function.
local function helper_15970()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 30 then
		helper_12a40()
	end
	argc = monster.get_random(100) or argc
	if argc < 75 then
		monster.set_motion("歩き", -1, 0)
		helper_e1c3e640(1.75, vm.f32(4.8), 79.0, 60)
		var3 = monster.get_target_distance() or var3
		if var3 < 94.0 then
			helper_14738()
		else
			helper_12a40()
		end
		monster.set_motion("立ち", -1, 0)
	else
		argc = monster.get_random(100) or argc
		if argc < 15 then
			argc = monster.get_random(100) or argc
			var4 = monster.get_random_whole_number(60.0) or var4
			if argc < 50 then
				var4 = vm.f32(-var4 - 30.0)
			else
				var4 = vm.f32(var4 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			helper_bfbcfc9f(1.75, vm.f32(4.8), var4, 158.0, 1.0, 25)
			helper_83e135e0(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			helper_ee5b84d4(6)
		else
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_16b38()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		monster.get_life()
		helper_ade2dbe2()
		var0 = monster.get_target_distance() or var0
		if var0 > 350.0 then
			helper_b9fff8e1()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_14cd0()
			continue
		end
		if var0 < 350.0 and var0 >= 150.0 then
			helper_166e8()
		else
			helper_15970()
		end
	end
end

--- Helper function.
local function helper_f064()
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
	helper_b9fff8e1()
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
	if var17 < 79.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1.0, 0)
		helper_179581d3(var7, vm.f32(4.8))
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 79.0)
		if var17 > 0.0 then
			helper_54469cb2(vm.f32(4.8), 1.75, var7, var17, 79.0, 30)
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
				helper_549e2b35(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), var5, var18, 79.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_179581d3(var19, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_57db7062(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.get_random(100, argc)
			return
		end
	end
	argc = monster.get_random(100) or argc
	if argc < 20 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			helper_57db7062(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			helper_179581d3(var7, vm.f32(4.8))
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
					var1 = helper_bfbcfc9f(1.75, vm.f32(4.8), var20, var21, 79.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_179581d3(var23, vm.f32(4.8))
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
					helper_cd4ea219(1.75, var7, 1000.0, 79.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_57db7062(100.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			helper_97d8f861(1.75, vm.f32(4.8), var5, 360.0, 40.0, 79.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_18398()
	monster.set_motion("走り", -1, 0)
	helper_e1c3e640(4.0, vm.f32(4.8), 79.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_151e0()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	monster.get_life()
	while true do
		helper_b9fff8e1()
		helper_ade2dbe2()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_14cd0()
			continue
		end
		var3 = monster.get_target_distance() or var3
		if var3 < 150.0 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
				monster.set_motion("走り", -1, 0)
				helper_e1c3e640(4.0, vm.f32(4.8), 79.0, 60)
				helper_14738()
			else
				helper_12a40()
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				helper_14738()
			else
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(7.2000003))
				monster.set_motion("走り", -1, 0)
				helper_e1c3e640(4.0, vm.f32(4.8), 79.0, 75)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_18524()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		helper_ade2dbe2()
		var0 = monster.get_target_distance() or var0
		if helper_a25c5b2e() == 0 then
			if var0 < 350.0 then
				helper_16b38()
			else
				helper_f064()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 150.0 then
					helper_65eb2b74(0)
					helper_16b38()
				else
					helper_18398()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_151e0()
	end
end

--- Helper function.
local function helper_11c20()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	var6 = monster.get_target_angle() or var6
	monster.set_rotation(0.0, var6, 0.0)
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
	helper_ee5b84d4(helper_9df6409a(6))
	monster.move_toward_position(pos_x, pos_y, pos_z, 4.0, 4.0)
	helper_ee5b84d4(helper_9df6409a(17))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local get_not_used_texb: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	monster.register_damage_hit("通常攻撃", 5.0, "攻撃２", 0.404, 0.417, 0)
	monster.register_damage_hit("通常攻撃", 7.2, "攻撃２", 0.35, 0.417, 1)
	monster.register_damage_hit("通常攻撃", 7.2, "攻撃２", 0.35, 0.417, 2)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("ティグ羽根Ｌ", get_not_used_texb) or var1
		var2 = monster.load_effect_script("ティグ羽根Ｈ", get_not_used_texb) or var2
		if (if var1 ~= 0 then 1 else var2) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(0, 0)
	helper_3048()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_b9fff8e1()
		helper_18524()
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
		helper_b9fff8e1()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_cbe4d8e2()
	helper_ee5b84d4(12)
	monster.set_motion("立ち", 0)
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_ee5b84d4(8)
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
	helper_b9fff8e1()
	helper_11c20()
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
	helper_b9fff8e1()
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(4.8))
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
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_b9fff8e1()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_ba87ea88()
	monster.stop_moving()
	monster.end_throw()
	helper_ee5b84d4(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_cbe4d8e2()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("起き上がり", -1, 6)
	helper_cbe4d8e2()
	helper_e05438b5()
end

return script
