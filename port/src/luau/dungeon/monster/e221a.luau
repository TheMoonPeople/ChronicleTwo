--!strict
-- dungeon/monster/e221a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_067263da = require("@lib/monster/helper_067263da")
local helper_0c6dce14 = require("@lib/monster/helper_0c6dce14")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_195a8eaa = require("@lib/monster/helper_195a8eaa")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_3dad8a79 = require("@lib/monster/helper_3dad8a79")
local helper_401e2ea3 = require("@lib/monster/helper_401e2ea3")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_4d763a19 = require("@lib/monster/helper_4d763a19")
local helper_511f7998 = require("@lib/monster/helper_511f7998")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5c86001d = require("@lib/monster/helper_5c86001d")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_6b22152e = require("@lib/monster/helper_6b22152e")
local helper_6fc9b142 = require("@lib/monster/helper_6fc9b142")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_7a6c1499 = require("@lib/monster/helper_7a6c1499")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a052ddbe = require("@lib/monster/helper_a052ddbe")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_a6b45eeb = require("@lib/monster/helper_a6b45eeb")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_abd1478c = require("@lib/monster/helper_abd1478c")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_bee0409d = require("@lib/monster/helper_bee0409d")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_dcede5dc = require("@lib/monster/helper_dcede5dc")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e4054524 = require("@lib/monster/helper_e4054524")

--- Helper function.
local function helper_3164()
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
local function helper_11fb8(arg0: s32, rot_speed: f32, arg2: s32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var9: f32 = 0
	print("id=", arg0, "-----------------\n")
	rot_speed = vm.f32(vm.f32(rot_speed / 180.0) * vm.f32(3.1415927))
	for var10 = 0, arg2 - 1 do
		do
			local out1, out2, out3 = monster.get_monster_position(arg0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		var9 = monster.get_angle_to_position(var3, var4, var5) or var9
		monster.turn_toward_angle(var9, rot_speed)
		vm.wait()
	end
	helper_442b9962()
end

--- Helper function.
local function helper_dab4(arg0: s32, rot_speed: f32, arg2: f32, arg3: f32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	if arg3 == -1.0 then
		arg3 = vm.f32(0.05)
	end
	rot_speed = helper_787df986(rot_speed)
	while true do
		do
			local out1, out2, out3 = monster.get_monster_position(arg0)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		var7 = monster.get_angle_to_position(var4, var5, var6) or var7
		monster.turn_toward_angle(var7, rot_speed)
		var8 = monster.get_motion_progress() or var8
		if var8 < vm.f32(arg2 + arg3) and var8 > vm.f32(arg2 - arg3) then
			break
		else
			helper_bee0409d()
		end
	end
	helper_442b9962()
end

--- Helper function.
local function helper_6014(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	if arg1 == -1.0 then
		arg1 = vm.f32(0.03)
	end
	var3 = 0
	while true do
		helper_bee0409d()
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
local function helper_12304()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local rank: s32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local argc: s32 = 0
	local value: s32 = 0
	local argc_2: s32 = 0
	local max_life: s32 = 0
	local var15: s32 = 0
	local chara_type: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	value = monster.get_variable(7) or value
	if value < 300 then
		return
	end
	argc = monster.get_monster_count() or argc
	rank = 0
	var10 = -1
	var4 = monster.get_monster_life_fraction(-1) or var4
	while rank < argc do
		var9 = monster.get_nearby_monster(150.0, rank) or var9
		if var9 ~= -1 then
			var3 = monster.get_monster_life_fraction(var9) or var3
		end
		if var3 < var4 then
			var4 = var3
			var10 = var9
		end
		rank = rank + 1
	end
	if var10 ~= -1 then
		var17 = vm.float_bits(monster.get_monster_life_fraction(-1)) or var17
		var18 = vm.float_bits(monster.get_monster_life_fraction(var10)) or var18
		if var17 < var18 then
			var10 = -2
		end
	else
		var4 = monster.get_monster_life_fraction(-1) or var4
		var10 = -2
	end
	if var10 == -1 or var4 > vm.f32(0.9) then
		return
	end
	if var10 == -2 then
		var10 = -1
	else
		do
			local out1, out2, out3 = monster.get_monster_position(var10)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		var19 = monster.get_angle_to_position(var5, var6, var7) or var19
		monster.set_motion("歩き", -1, 0)
		helper_7a6c1499(helper_28452e16(var19), 6.0)
	end
	monster.set_motion("攻撃２in", -1, 6)
	if var10 ~= -1 then
		helper_11fb8(var10, 6.0, helper_9df6409a(12))
	else
		helper_c3e8ae39(helper_9df6409a(15))
	end
	monster.set_motion("攻撃２loop", -1, 6)
	if var10 ~= -1 then
		helper_11fb8(var10, 6.0, 24)
	else
		helper_c3e8ae39(24)
	end
	monster.set_motion("攻撃２", -1, 6)
	do
		local out1, out2, out3 = monster.get_frame_position("magic_coll")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("Ｍ回復Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	if var10 ~= -1 then
		helper_dab4(var10, 3.0, vm.f32(0.497), -1.0)
	else
		helper_6014(3.0, vm.f32(0.497))
	end
	if var10 == -1 then
		chara_type = monster.get_character_number() or chara_type
	else
		chara_type = var10
	end
	var20 = monster.get_monster_life_fraction(chara_type) or var20
	if var20 <= 0.0 then
		return
	end
	monster.create_effect_1("Ｍ回復")
	monster.set_effect_value(-1, 0, chara_type)
	if var10 ~= -1 then
		helper_11fb8(var10, 6.0, helper_9df6409a(15))
	else
		helper_c3e8ae39(helper_9df6409a(15))
	end
	var20 = monster.get_monster_life_fraction(chara_type) or var20
	if var20 <= 0.0 then
		return
	end
	max_life = monster.get_monster_max_life(var10) or max_life
	var15 = vm.ftoi(vm.f32(max_life * vm.f32(0.3)))
	argc_2 = monster.get_random(vm.ftoi(vm.f32(var15 * vm.f32(0.2)))) or argc_2
	var15 = vm.i32(vm.ftoi(vm.f32(var15 * vm.f32(0.8))) + argc_2)
	monster.show_damage_number(var10, var15, 1)
	monster.add_monster_life(var10, var15)
	if var10 ~= -1 then
		helper_11fb8(var10, 6.0, helper_9df6409a(15))
	else
		helper_c3e8ae39(helper_9df6409a(15))
	end
	monster.set_variable(7, 0)
	helper_56d63eae()
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(10)
end

--- Helper function.
local function helper_11628(arg0: any)
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		helper_bee0409d()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				helper_401e2ea3(3.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_118f8()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_11628(monster_id)
	end
end

--- Helper function.
local function helper_15304()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 110.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = helper_6b22152e(2.0, 3.0, var3, var4, 47.0, 30)
		helper_401e2ea3(3.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_4d763a19(47.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_cf90(arg0: f32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local var4: f32 = 0
	local rot_speed: f32 = 0
	if arg2 == -1.0 then
		arg2 = vm.f32(0.05)
	end
	rot_speed = helper_787df986(arg0)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	while true do
		var3 = monster.get_target_angle() or var3
		monster.turn_toward_angle(var3, rot_speed)
		var4 = monster.get_motion_progress() or var4
		if var4 < vm.f32(arg1 + arg2) and var4 > vm.f32(arg1 - arg2) then
			break
		else
			helper_bee0409d()
		end
	end
	helper_442b9962()
end

--- Helper function.
local function helper_14a34()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	monster.set_variable(0, 2)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1, 0)
	helper_401e2ea3(3.0)
	monster.set_motion("攻撃２in", -1, 6)
	helper_5c86001d(helper_9df6409a(12))
	monster.set_motion("攻撃２loop", -1, 2)
	helper_a052ddbe(3.0, helper_9df6409a(24))
	monster.set_motion("攻撃２", -1, 6)
	helper_cf90(3.0, vm.f32(0.513), vm.f32(0.01))
	do
		local out1, out2, out3 = monster.get_frame_position("magic_coll")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("呪い弾Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	helper_6014(vm.f32(0.533), vm.f32(0.01))
	monster.create_effect_1("呪い弾Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.set_effect_value(-1, 0, attack)
	helper_6fc9b142()
	monster.set_motion("立ち", -1, 0)
	helper_5c86001d(9)
end

--- Helper function.
local function helper_171ac()
	local argc: s32 = 0
	local var2: f32 = 0
	local life: f32 = 0
	local var4: f32 = 0
	life = 0.0
	var2 = monster.get_target_distance() or var2
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 45 then
			argc = monster.get_random(100) or argc
			if argc < 25 then
				life = monster.get_life() or life
				if life < 0.5 then
					monster.set_motion("歩き", -1, 0)
					helper_401e2ea3(3.0)
					monster.set_motion("走り", -1, 0)
					helper_195a8eaa(3.0, 3.0, 110.0, 60)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					helper_195a8eaa(2.0, 3.0, 110.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_motion("立ち", -1, 0)
				helper_4d763a19(47.0, 45.0, 75)
			end
		else
			monster.set_motion("歩き", -1, 0)
			helper_401e2ea3(3.0)
			helper_14a34()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			var4 = -30.0
		else
			var4 = 30.0
		end
		monster.set_motion("歩き", -1, 0)
		helper_401e2ea3(3.0)
		monster.set_motion("歩き", -1, 0)
		helper_6b22152e(2.0, 3.0, var4, var2, 110.0, 45)
		monster.set_motion("歩き", -1, 0)
		helper_401e2ea3(3.0)
		monster.set_motion("立ち", -1, 0)
		helper_4d763a19(47.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_13f5c(arg0: f32, arg1: f32, arg2: s32, arg3: f32, arg4: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var9 = out2 or var9
	end
	if arg2 ~= 0 then
		monster.set_motion("歩き右", -1, 0)
		var9 = vm.f32(var9 + vm.f32(1.5707964))
	else
		monster.set_motion("歩き左", -1, 0)
		var9 = vm.f32(var9 - vm.f32(1.5707964))
	end
	var15 = var9
	if var15 > vm.f32(3.1415927) then
		var15 = vm.f32(var15 - vm.f32(6.2831855))
	end
	if var15 <= vm.f32(-3.1415927) then
		var15 = vm.f32(var15 + vm.f32(6.2831855))
	end
	var14 = monster.get_clear_distance(100.0, 0.0) or var14
	if var14 < 100.0 then
		arg1 = vm.f32(arg1 - var14)
		if arg1 < arg3 then
			return
		end
	end
	target = vm.f32(pos_x + vm.f32(vm.sin(var15) * arg1))
	target_2 = vm.f32(pos_y - 20.0)
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(var15) * arg1))
	monster.move_toward_position(target, target_2, target_3, arg0, arg0)
	helper_067263da(arg3, arg4)
	monster.stop_moving()
end

--- Helper function.
local function helper_168d8()
	local argc: s32 = 0
	local var3: f32 = 0
	local var6: s32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 65 then
		monster.set_motion("歩き", -1, 0)
		helper_401e2ea3(3.0)
		helper_14a34()
	else
		argc = monster.get_random(100) or argc
		if argc < 75 then
			monster.set_motion("走り", -1, 0)
			helper_195a8eaa(3.0, 6.0, 47.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			var3 = monster.get_target_angle() or var3
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var3 = vm.f32(var3 - vm.f32(0.7853982))
				var6 = 1
			else
				var3 = vm.f32(var3 + vm.f32(0.7853982))
				var6 = 0
			end
			if var3 > vm.f32(3.1415927) then
				var3 = vm.f32(var3 - vm.f32(6.2831855))
			end
			if var3 <= vm.f32(-3.1415927) then
				var3 = vm.f32(var3 + vm.f32(6.2831855))
			end
			monster.set_motion("歩き", -1, 0)
			helper_7a6c1499(helper_28452e16(var3), 3.0)
			helper_13f5c(3.0, 80.0, var6, 47.0, 60)
			monster.set_motion("歩き", -1, 0)
			helper_401e2ea3(3.0)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_147b4()
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	helper_401e2ea3(6.0)
	monster.set_motion("攻撃１", -1, 2)
	helper_a052ddbe(3.0, helper_9df6409a(58))
	monster.set_motion("立ち", -1, 0)
	helper_5c86001d(9)
end

--- Helper function.
local function helper_1393c()
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
	helper_5c86001d(helper_9df6409a(10))
	monster.move_toward_position(pos_x, pos_y, pos_z, 4.5, 4.5)
	helper_5c86001d(helper_9df6409a(9))
	monster.stop_moving()
	helper_6fc9b142()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_16124()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 68 then
		var3 = monster.get_target_distance() or var3
		argc = monster.get_random(100) or argc
		if var3 < 70.0 then
			helper_147b4()
		else
			helper_14a34()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 75 then
			monster.set_motion("走り", -1, 0)
			helper_195a8eaa(3.0, 6.0, 47.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				argc = monster.get_random(100) or argc
				var4 = monster.get_random_whole_number(60.0) or var4
				if argc < 50 then
					var4 = vm.f32(-var4 - 30.0)
				else
					var4 = vm.f32(var4 + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				helper_6b22152e(2.0, 3.0, var4, 94.0, 1.0, 25)
				helper_401e2ea3(3.0)
				monster.set_motion("立ち", -1, 0)
				helper_5c86001d(9)
			else
				helper_1393c()
			end
		end
	end
end

--- Helper function.
local function helper_17c20()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_bee0409d()
		helper_12304()
		monster.get_life()
		helper_118f8()
		var0 = monster.get_target_distance() or var0
		if var0 > 270.0 then
			helper_bee0409d()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			helper_bee0409d()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_15304()
			continue
		end
		if var0 < 270.0 and var0 >= 170.0 then
			helper_171ac()
		elseif var0 < 170.0 and var0 >= 110.0 then
			helper_168d8()
		else
			helper_16124()
		end
	end
end

--- Helper function.
local function helper_f180()
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
	helper_bee0409d()
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
	if var17 < 47.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1.0, 0)
		helper_7a6c1499(var7, 3.0)
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 47.0)
		if var17 > 0.0 then
			helper_abd1478c(3.0, vm.f32(1.8), var7, var17, 47.0, 30)
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
				helper_e4054524(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.8), 3.0, var5, var18, 47.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_7a6c1499(var19, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_0c6dce14(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.get_random(100, argc)
			return
		end
	end
	argc = monster.get_random(100) or argc
	if argc < 75 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			helper_0c6dce14(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			helper_7a6c1499(var7, 3.0)
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
					var1 = helper_6b22152e(vm.f32(1.8), 3.0, var20, var21, 47.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_7a6c1499(var23, 3.0)
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
					helper_511f7998(vm.f32(1.8), var7, 1000.0, 47.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_0c6dce14(100.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			helper_dcede5dc(vm.f32(1.8), 3.0, var5, 360.0, 40.0, 47.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_193e4()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 98 then
		helper_f180()
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			helper_13f5c(3.0, 80.0, 1, 47.0, 60)
		else
			helper_13f5c(3.0, 80.0, 0, 47.0, 60)
		end
		monster.set_motion("立ち", -1, 0)
		helper_4d763a19(47.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_19258()
	monster.set_motion("走り", -1, 0)
	helper_195a8eaa(3.0, 3.0, 47.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_15814()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	monster.get_life()
	while true do
		helper_bee0409d()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_15304()
			continue
		end
		var3 = monster.get_target_distance() or var3
		if var3 < 110.0 then
			argc = monster.get_random(100) or argc
			if argc < 80 then
				argc = monster.get_random(100) or argc
				if argc < 50 then
					helper_147b4()
				else
					helper_14a34()
				end
			else
				monster.set_motion("走り", -1, 0)
				helper_195a8eaa(3.0, 6.0, 47.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 60 then
				helper_14a34()
			else
				argc = monster.get_random(100) or argc
				if argc < 90 then
					monster.set_motion("走り", -1, 0)
					helper_195a8eaa(3.0, 3.0, 47.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					helper_195a8eaa(2.0, 6.0, 47.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
	end
end

--- Helper function.
local function helper_196fc()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	helper_12304()
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	var0 = monster.get_target_distance() or var0
	if gekirin > 0 then
		helper_118f8()
		if helper_a25c5b2e() == 0 then
			if var0 < 270.0 then
				helper_17c20()
			else
				helper_193e4()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 170.0 then
					helper_65eb2b74(0)
					helper_17c20()
				else
					helper_19258()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_15814()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local get_not_used_texb: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	monster.register_damage_hit("通常攻撃", 4.0, "攻撃１", 0.376, 0.411, 0)
	monster.set_variable(0, 0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("呪い弾Ｆ", get_not_used_texb) or var1
		var2 = monster.load_effect_script("呪い弾Ｌ", get_not_used_texb) or var2
		var3 = monster.load_effect_script("呪い弾Ｈ", get_not_used_texb) or var3
		if (if (if var1 ~= 0 then 1 else var2) ~= 0 then 1 else var3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("Ｍ回復Ｆ", get_not_used_texb) or var1
		var2 = monster.load_effect_script("Ｍ回復", get_not_used_texb) or var2
		if (if var1 ~= 0 then 1 else var2) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(7, 90)
	helper_3164()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_bee0409d()
		helper_196fc()
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
		helper_bee0409d()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_6fc9b142()
	helper_5c86001d(12)
	monster.set_motion("立ち", -1, 0)
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_a6b45eeb()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_6fc9b142()
	monster.set_action_status(1)
	helper_5c86001d(45)
	monster.set_action_status(0)
	monster.set_motion("起き上り", -1, 6)
	helper_6fc9b142()
	monster.set_motion("立ち", -1, 0)
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_5c86001d(8)
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
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
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_3dad8a79()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_6fc9b142()
	monster.set_motion("起き上り", -1, 6)
	helper_6fc9b142()
	helper_e05438b5()
end

return script
