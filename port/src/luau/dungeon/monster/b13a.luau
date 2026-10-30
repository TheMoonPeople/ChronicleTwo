--!strict
-- dungeon/monster/b13a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07b5f915 = require("@lib/monster/helper_07b5f915")
local helper_13320956 = require("@lib/monster/helper_13320956")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_84a6a4c4 = require("@lib/monster/helper_84a6a4c4")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_b3b48995 = require("@lib/monster/helper_b3b48995")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b937768e = require("@lib/monster/helper_b937768e")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_cea0e31f = require("@lib/monster/helper_cea0e31f")
local helper_d742309a = require("@lib/monster/helper_d742309a")
local helper_dd45b7cf = require("@lib/monster/helper_dd45b7cf")
local helper_de1504df = require("@lib/monster/helper_de1504df")

--- Helper function.
local function helper_2a70()
	for var0 = 0, 3 do
		monster.set_variable(var0 + 96, -9999)
	end
end

--- Helper function.
local function helper_ab58()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Helper function.
local function helper_2cc0()
	local value: s32 = 0
	value = monster.get_variable(96) or value
	if value ~= -9999 then
		monster.finish_effect(value)
		monster.set_variable(96, -9999)
	end
	value = monster.get_variable(97) or value
	if value ~= -9999 then
		monster.set_effect_value(value, 1, 2)
		monster.finish_effect(value)
		monster.set_variable(97, -9999)
	end
end

--- Helper function.
local function helper_54c4()
	local value: s32 = 0
	local argc: s32 = 0
	value = monster.get_variable(3) or value
	if value == 1 then
		argc = monster.get_monster_count() or argc
		if argc > 2 then
			argc = vm.i32(argc * 2)
		end
	else
		argc = monster.get_monster_count() or argc
	end
end

--- Helper function.
local function helper_5790(arg0: s32, arg1: s32)
	local att_type: s32 = 0
	att_type = monster.get_last_attack_type() or att_type
	monster.set_variable(5, att_type)
	monster.set_variable(6, vm.i32(arg1 - arg0))
end

--- Helper function.
local function helper_5a64()
	local life: s32 = 0
	local value: s32 = 0
	value = monster.get_variable(4) or value
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		monster.set_variable(4, life)
		return 1
	end
	if vm.i32(life - value) < 0 then
		monster.set_variable(4, life)
		helper_5790(life, value)
		return 2
	end
	monster.set_variable(4, life)
	return 0
end

--- Helper function.
local function helper_29b4()
	local var0: s32 = 0
	var0 = helper_13320956(var0)
	helper_84a6a4c4(vm.i32(var0 + 1))
end

--- Helper function.
local function helper_452c()
	local value: s32 = 0
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	value = monster.get_variable(3) or value
	if value == 2 and helper_b937768e(1) > 60 then
		argc = monster.get_monster_count() or argc
		if argc < 13 then
			do
				local out1, out2, out3 = monster.get_position_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local _, out2, _ = monster.get_rotation()
				var8 = out2 or var8
			end
			monster.create_monster(630, pos_x, pos_y - 10.0, pos_z, var8)
			helper_cea0e31f(2)
			helper_442b9962()
			helper_29b4()
		end
		helper_cea0e31f(1)
	end
end

--- Helper function.
local function helper_51f0()
	local value: s32 = 0
	value = monster.get_variable(3) or value
	monster.get_monster_count()
	monster.set_variable(13, 1)
	if value == 2 then
		print("kita-------------------\n")
		monster.set_invulnerable_time(0)
		monster.set_variable(3, 1)
	else
		monster.set_invulnerable_time(9999)
		monster.set_variable(3, 2)
	end
end

--- Helper function.
local function helper_a078()
	local value: s32 = 0
	local var1: s32 = 0
	var1 = helper_13320956(var1)
	value = monster.get_variable(3) or value
	if value == 2 then
		helper_cea0e31f(0)
	end
	if value == 2 and var1 == 6 then
		print("change color blue-----------------\n")
		helper_51f0()
		helper_84a6a4c4(0)
		helper_cea0e31f(0)
	end
	if value == 1 and helper_b937768e(0) > 300 then
		print("change color red-----------------\n")
		helper_51f0()
		helper_84a6a4c4(0)
	end
end

--- Helper function.
local function helper_4900()
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	value_2 = monster.get_variable(13) or value_2
	if value_2 ~= 0 then
		monster.set_variable(14, 0)
		monster.set_variable(13, 0)
	else
		monster.set_model_lighting(1)
	end
	value = monster.get_variable(14) or value
	if value < 15 then
		monster.set_model_lighting(0)
		value_3 = monster.get_variable(3) or value_3
		if value_3 == 1 then
			if vm.imod(value, 2) == 0 then
				monster.set_model_color(128.0, 128.0, 148.0, 128.0)
			end
			if vm.imod(value, 4) == 0 then
				monster.set_model_color(160.0, 160.0, 180.0, 160.0)
			end
			if vm.imod(value, 6) == 0 then
				monster.set_model_color(140.0, 140.0, 160.0, 140.0)
			end
		else
			if vm.imod(value, 2) == 0 then
				monster.set_model_color(148.0, 128.0, 128.0, 128.0)
			end
			if vm.imod(value, 4) == 0 then
				monster.set_model_color(180.0, 160.0, 160.0, 160.0)
			end
			if vm.imod(value, 6) == 0 then
				monster.set_model_color(160.0, 140.0, 140.0, 140.0)
			end
		end
		if value == 14 then
			if value_3 == 1 then
				monster.set_invulnerable_time(0)
				monster.apply_reserved_image(1)
			else
				monster.set_invulnerable_time(9999)
				monster.apply_reserved_image(0)
			end
		end
		monster.set_variable(14, value + 1)
	end
end

--- Helper function.
local function helper_5de0(arg0: f32)
	local value: f32 = 0
	value = 0.0
	value = monster.get_variable_float(15) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_9288(arg0: f32, arg1: f32, arg2: any, arg3: f32)
	local var6: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(arg0 - pos_x)
	pos_y = vm.f32(arg1 - pos_y)
	do
		local _, _, out3 = monster.get_rotation_toward_6(pos_x, pos_y, pos_z)
		var6 = out3 or var6
	end
	var10 = var6
	if var10 > vm.f32(3.1415927) then
		var10 = vm.f32(var10 - vm.f32(6.2831855))
	end
	if var10 <= vm.f32(-3.1415927) then
		var10 = vm.f32(var10 + vm.f32(6.2831855))
	end
	arg3 = var10
	return arg3
end

--- Helper function.
local function helper_9698()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local value: f32 = 0
	local var18: f32 = 0
	value = 0.0
	value = monster.get_variable_float(19) or value
	value = vm.f32(value + vm.f32(0.08726647))
	var18 = vm.f32(200.0 + vm.f32(vm.sin(value) * 15.0))
	monster.set_variable_float(19, value)
	var6 = helper_5de0(var6)
	var0 = 0.0
	var1 = 0.0
	var2 = 0.0
	var3 = vm.f32(var0 + vm.f32(vm.sin(var6) * 400.0))
	var4 = vm.f32(var1 + var18)
	var5 = vm.f32(var2 + vm.f32(vm.cos(var6) * 400.0))
	var10 = helper_9288(var3, var4, var5, var10)
	var7 = monster.get_angle_to_position(var3, var4, var5) or var7
	monster.set_position(var3, var4, var5)
	monster.set_rotation(0.0, var7, 0.0)
	helper_dd45b7cf(vm.f32(var6 + vm.f32(0.017453292)))
end

--- Helper function.
local function helper_1bf4(arg0: f32, arg1: f32, arg2: f32)
	local var4: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	arg0 = vm.f32(arg0 * vm.f32(0.017453292))
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = vm.f32(arg1 * vm.f32(0.017453292))
	var8 = arg2
	if arg1 < 3.0 then
		var9 = vm.f32(0.05235988)
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
			vm.wait()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_22bc(next_rot: f32, rot_speed: f32)
	next_rot = vm.f32(next_rot * vm.f32(0.017453292))
	if next_rot > vm.f32(3.1415927) then
		next_rot = vm.f32(next_rot - vm.f32(6.2831855))
	end
	if next_rot <= vm.f32(-3.1415927) then
		next_rot = vm.f32(next_rot + vm.f32(6.2831855))
	end
	rot_speed = vm.f32(rot_speed * vm.f32(0.017453292))
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(next_rot, rot_speed)
	local _ = helper_1bf4(
		vm.f32(next_rot * vm.f32(57.295776)),
		vm.f32(rot_speed * vm.f32(57.295776)),
		vm.f32(vm.fdiv(360.0, vm.f32(rot_speed * vm.f32(57.295776))))
	)
	helper_442b9962()
end

--- Helper function.
local function helper_5ef0(arg0: f32, arg1: f32, arg2: f32, scale: f32, arg4: f32, arg5: s32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	print("kita---------------------------\n")
	do
		local out1, out2, out3 = monster.get_position_3()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var12, var13, var14, var6, var7, var8)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var12, var13, var14)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.scale_vector(var12, var13, var14, scale)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	print("x=", vm.float(arg0), "------------------\n")
	print("y=", vm.float(arg1), "------------------\n")
	print("z=", vm.float(arg2), "------------------\n")
	print("pos[0]=", vm.float(var6), "------------------\n")
	print("pos[1]=", vm.float(var7), "------------------\n")
	print("pos[2]=", vm.float(var8), "------------------\n")
	print("speed=", vm.float(scale), "---------------------\n")
	print("velo[0]=", vm.float(var12), "------------------\n")
	print("velo[1]=", vm.float(var13), "------------------\n")
	print("velo[2]=", vm.float(var14), "------------------\n")
	var16 = 0
	while var16 < arg5 do
		do
			local out1, out2, out3 = monster.add_vectors(var6, var7, var8, var12, var13, var14)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local _, out2, _ = monster.get_rotation_toward_6(var6, var7, var8)
			var10 = out2 or var10
		end
		var15 = monster.get_distance_between(var6, var7, var8, arg0, arg1, arg2) or var15
		if var15 < arg4 then
			break
		else
			monster.set_position(var6, var7, var8)
			monster.set_rotation(0.0, var10, 0.0)
			vm.wait()
			var16 = var16 + 1
		end
	end
end

--- Helper function.
local function helper_2c04(arg0: s32, value: s32)
	monster.set_variable(vm.i32(arg0 + 96), value)
end

--- Helper function.
local function helper_3010()
	local chara_type: s32 = 0
	local slot: s32 = 0
	local attack: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local scale: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var25: f32 = 0
	helper_2cc0()
	monster.set_motion("飛行ループ", -1, 0)
	var10 = monster.get_target_angle() or var10
	helper_22bc(vm.f32(var10 * vm.f32(57.295776)), vm.f32(1.9999999))
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.8)))
	chara_type = monster.get_character_number() or chara_type
	do
		local out1, _, _ = monster.get_scale()
		var7 = out1 or var7
	end
	var23 = 0.0
	var25 = 0.0
	do
		local out1, out2, out3 = monster.get_target_position()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var11 = monster.get_random_whole_number(6.2831855) or var11
	var14 = vm.f32(var23 + vm.f32(vm.sin(var11) * 170.0))
	var15 = 5.0
	var16 = vm.f32(var25 + vm.f32(vm.cos(var11) * 170.0))
	do
		local out1, out2, out3 = monster.get_target_position()
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	do
		local out1, out2, out3 = monster.copy_vector(var17, var18, var19)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var20, var21, var22, var14, var15, var16)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var20, var21, var22)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	var12 = 396.0
	scale = vm.f32(var12 / 60.0)
	do
		local out1, out2, out3 = monster.scale_vector(var20, var21, var22, scale)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.copy_vector(var14, var15, var16)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var10 = monster.get_angle_to_position(var14, var15, var16) or var10
	chara_type = monster.get_character_number() or chara_type
	monster.play_monster_sound(chara_type, 3)
	slot = monster.create_effect_2("魔人ビームＦ２") or slot
	helper_2c04(0, slot)
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value_float(slot, 0, var7)
	monster.set_effect_first_vector(slot, var14, var15, var16)
	slot = monster.create_effect_2("魔人ビームＬ２") or slot
	helper_2c04(1, slot)
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, attack)
	monster.set_effect_value_float(slot, 2, var7)
	monster.set_effect_value(slot, 1, 1)
	for var2 = 0, 89 do
		do
			local out1, out2, out3 = monster.add_vectors(var4, var5, var6, var20, var21, var22)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		var10 = monster.get_angle_to_position(var4, var5, var6) or var10
		monster.set_effect_first_vector(slot, var4, var5, var6)
		monster.set_rotation(0.0, var10, 0.0)
		vm.wait()
	end
	monster.set_effect_value(slot, 1, 2)
	helper_c3e8ae39(90)
	helper_c3e8ae39(60)
	monster.set_motion("飛行ループ", -1, 0)
end

--- Helper function.
local function helper_9cdc()
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var3: f32 = 0
	target = 0.0
	target_2 = 0.0
	target_3 = 0.0
	monster.set_motion("飛行ループ", -1, 0)
	var3 = monster.get_angle_to_position(target, target_2, target_3) or var3
	helper_22bc(vm.f32(var3 * vm.f32(57.295776)), vm.f32(1.9999999))
	helper_5ef0(target, 300.0, target_3, 12.0, 50.0, 300)
	helper_3010()
	monster.set_motion("泳ぐ", -1, 0)
end

--- Helper function.
local function helper_7c90(arg0: f32, arg1: f32, arg2: f32, scale: f32, arg4: f32, arg5: f32, arg6: any, arg7: s32)
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var28 = out1 or var28
		var29 = out2 or var29
		var30 = out3 or var30
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var28, var29, var30, var8, var9, var10)
		var28 = out1 or var28
		var29 = out2 or var29
		var30 = out3 or var30
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var28, var29, var30)
		var28 = out1 or var28
		var29 = out2 or var29
		var30 = out3 or var30
	end
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var11, var12, var13, var8, var9, var10)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var11, var12, var13)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	x = vm.f32(vm.f32(var11 * vm.cos(arg5)) + vm.f32(var13 * vm.sin(arg5)))
	y = var12
	z = vm.f32(vm.f32(var11 * -vm.sin(arg5)) + vm.f32(var13 * vm.cos(arg5)))
	do
		local out1, out2, out3 = monster.normalize_vector(x, y, z)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	var27 = 0
	while var27 < arg7 do
		do
			local out1, out2, out3 = monster.copy_vector(var28, var29, var30)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = monster.scale_vector(var17, var18, var19, scale)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = monster.add_vectors(var8, var9, var10, var17, var18, var19)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local _, out2, _ = monster.get_rotation_toward_6(var8, var9, var10)
			var21 = out2 or var21
		end
		if var9 < 60.0 then
			var9 = 60.0
		end
		var26 = monster.get_distance_between(var8, var9, var10, arg0, arg1, arg2) or var26
		if var26 < arg4 then
			break
		else
			monster.set_position(var8, var9, var10)
			monster.set_rotation(0.0, var21, 0.0)
			vm.wait()
			var27 = var27 + 1
		end
	end
end

--- Helper function.
local function helper_8940()
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	var7 = 0.0
	var8 = 0.0
	var9 = 0.0
	do
		local out1, out2, out3 = monster.get_target_position()
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var10, var11, var12, var7, var8, var9)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var10, var11, var12)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	var6 = monster.get_arc_tangent(var10, var12) or var6
	var6 = vm.f32(var6 + vm.f32(3.1415927))
	if var6 > vm.f32(3.1415927) then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if var6 <= vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	var6 = helper_5de0(var6)
	var6 = vm.f32(var6 + vm.f32(3.1415927))
	target = vm.f32(target + vm.f32(vm.f32(vm.sin(var6) * 220.0) * 2.0))
	target_2 = 150.0
	target_3 = vm.f32(target_3 + vm.f32(vm.f32(vm.cos(var6) * 220.0) * 2.0))
	monster.set_motion("飛行ループ", -1, 0)
	var6 = monster.get_angle_to_position(target, target_2, target_3) or var6
	helper_22bc(vm.f32(var6 * vm.f32(57.295776)), vm.f32(1.9999999))
	helper_7c90(target, target_2, target_3, 12.0, 100.0, vm.f32(3.1415927), vm.f32(0.2), 500)
end

--- Helper function.
local function helper_69ac(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local scale: f32 = 0
	local var14: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var10, var11, var12, var4, var5, var6)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var10, var11, var12)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	var14 = monster.get_distance_between(arg0, arg1, arg2, var4, var5, var6) or var14
	scale = vm.f32(vm.fdiv(var14, arg3))
	do
		local out1, out2, out3 = monster.scale_vector(var10, var11, var12, scale)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	for var15 = 0, arg3 - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(var4, var5, var6, var10, var11, var12)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local _, out2, _ = monster.get_rotation_toward_6(var4, var5, var6)
			var8 = out2 or var8
		end
		monster.set_position(var4, var5, var6)
		monster.set_rotation(0.0, var8, 0.0)
		vm.wait()
	end
end

--- Helper function.
local function helper_7104()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local value: f32 = 0
	local var18: f32 = 0
	value = 0.0
	value = monster.get_variable_float(19) or value
	value = vm.f32(value + vm.f32(0.08726647))
	var18 = vm.f32(200.0 + vm.f32(vm.sin(value) * 30.0))
	monster.set_variable_float(19, value)
	var6 = helper_5de0(var6)
	var6 = monster.get_random_whole_number(0.63661975) or var6
	var0 = 0.0
	var1 = 0.0
	var2 = 0.0
	target = vm.f32(var0 + vm.f32(vm.sin(var6) * 400.0))
	target_2 = vm.f32(var1 + var18)
	target_3 = vm.f32(var2 + vm.f32(vm.cos(var6) * 400.0))
	var7 = monster.get_angle_to_position(target, target_2, target_3) or var7
	helper_22bc(vm.f32(var7 * vm.f32(57.295776)), vm.f32(1.9999999))
	helper_69ac(target, target_2, target_3, 80)
	helper_dd45b7cf(var6)
	monster.set_motion("泳ぐ", -1, 0)
end

--- Helper function.
local function helper_a3b8()
	local var2: s32 = 0
	local value: s32 = 0
	local no_damage_cnt: s32 = 0
	helper_54c4()
	var2 = helper_5a64()
	if var2 == 1 then
		monster.set_variable(64, 1)
	end
	no_damage_cnt = monster.get_no_damage_hit_count() or no_damage_cnt
	value = monster.get_variable(14) or value
	monster.get_variable(12)
	if value > 14 then
		helper_452c()
	end
	helper_a078()
	monster.set_variable(12, no_damage_cnt)
	helper_4900()
	if helper_b937768e(2) < 150 then
		monster.set_monster_attributes(16, 1)
	else
		monster.set_monster_attributes(16, 0)
	end
	helper_9698()
	if helper_b937768e(2) > 300 and value > 14 then
		helper_9cdc()
		helper_8940()
		helper_7104()
		helper_cea0e31f(2)
	end
end

--- Helper function.
local function helper_a870()
	helper_a3b8()
	vm.wait()
end

--- Helper function.
local function helper_17e7c(arg0: f32, arg1: f32, arg2: f32, scale: f32, arg4: f32, arg5: f32, arg6: any)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	local var24: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	var19 = helper_57b569a8(var19)
	arg1 = vm.f32(var19 + arg5)
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var13, var14, var15, var7, var8, var9)
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
		local out1, out2, out3 = monster.scale_vector(var13, var14, var15, scale)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	monster.copy_vector(arg0, arg1, arg2)
	var11 = monster.get_angle_to_position(var7 + var13, var8 + var14, var9 + var15) or var11
	var23 = 0
	while var23 < arg6 do
		do
			local out1, out2, out3 = monster.add_vectors(var7, var8, var9, var13, var14, var15)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var22 = monster.get_height_above_ground_at(var7, var8, var9) or var22
		if var22 >= 200.0 or var22 <= 0.0 then
			var8 = vm.f32(var8 - var14)
			var14 = 0.0
		end
		var20 = monster.get_distance_between(var7, var8, var9, arg0, arg1, arg2) or var20
		if var20 < vm.f32(scale + arg4) then
			return
		end
		var24 = helper_de1504df(var7, var8, var9, scale, var11)
		if var24 ~= 0 then
			return
		end
		monster.set_position(var7, var8, var9)
		monster.copy_vector(var7, var8, var9)
		helper_a870()
		var23 = vm.i32(var23 + 1)
	end
end

--- Helper function.
local function helper_a8f0(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_a870()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_16388()
	while true do
		helper_a870()
	end
end

--- Helper function.
local function helper_16438()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_a8f0(10)
	monster.reset_motion()
end

--- Helper function.
local function helper_aa30()
	local var0: s32 = 0
	while true do
		helper_a870()
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			return
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local life: s32 = 0
	local get_not_used_texb: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local no_damage_cnt: s32 = 0
	monster.set_variable(2, 0)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, pos_y + 10.0, pos_z)
	monster.reset_dungeon_timer()
	monster.set_monster_attributes(512, 1)
	monster.set_visible_monster_limit(6)
	helper_cea0e31f(0)
	helper_cea0e31f(1)
	helper_cea0e31f(2)
	helper_cea0e31f(2)
	life = monster.get_monster_life(-1) or life
	monster.set_variable(4, life)
	monster.set_variable(64, 0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var5 = monster.load_effect_script("ねばねばＦ", get_not_used_texb) or var5
		var6 = monster.load_effect_script("ねばねばＬ", get_not_used_texb) or var6
		var7 = monster.load_effect_script("ねばねばＨ", get_not_used_texb) or var7
		if (if (if var5 ~= 0 then 1 else var6) ~= 0 then 1 else var7) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var5 = monster.load_effect_script("魔人ビームＦ２", get_not_used_texb) or var5
		var6 = monster.load_effect_script("魔人ビームＨ２", get_not_used_texb) or var6
		var7 = monster.load_effect_script("魔人ビームＬ２", get_not_used_texb) or var7
		if (if (if var5 ~= 0 then 1 else var6) ~= 0 then 1 else var7) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	helper_84a6a4c4(0)
	monster.set_photo_opportunity(249)
	monster.set_monster_attributes(128, 1)
	no_damage_cnt = monster.get_no_damage_hit_count() or no_damage_cnt
	monster.set_variable(12, no_damage_cnt)
	monster.set_variable(13, 0)
	monster.set_variable(14, 999999)
	monster.set_variable_float(15, 0.0)
	helper_2a70()
	monster.set_variable_float(19, 0.0)
	helper_b3b48995()
	helper_ac26cdde(250.0)
	helper_07b5f915(42.0)
	helper_ab58()
	monster.set_clip_distance(999999.9)
	monster.load_reserved_image(0, "textures/dungeon/monster/b13a01.json")
	monster.load_reserved_image(1, "textures/dungeon/monster/b13a02.json")
	monster.set_camera_mode(0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(16, 1)
	helper_2cc0()
	value = monster.get_variable(2) or value
	if value == 0 then
		monster.set_invulnerable_time(9999)
		monster.apply_reserved_image(0)
		monster.set_variable(3, 2)
		monster.set_scale(8.0, 8.0, 8.0)
		monster.set_motion("飛行ループ入り", -1, 6)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		helper_17e7c(pos_x, pos_y, pos_z, 2.0, 21.0, 200.0, 33)
		monster.set_motion("泳ぐ", -1, 0)
		monster.set_variable(2, 1)
	end
	while true do
		monster.set_motion("泳ぐ", -1, 0)
		helper_a870()
		helper_a8f0(60)
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_2cc0()
	monster.stop_moving()
	monster.reset_motion()
	monster.set_action_status(0)
	monster.set_motion("空中ダメージ", -1, 6)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("泳ぐ", -1, 0)
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
function script.on_death()
	monster.set_variable(64, 1)
	monster.stop_moving()
	helper_442b9962()
	monster.start_death()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(256, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_motion("ダメージ", -1, 0)
	helper_2cc0()
	monster.set_monster_attributes(2, 1)
	monster.set_monster_attributes(64, 1)
	monster.reset_camera_limits()
	monster.set_motion("死亡", -1, 6)
	helper_56d63eae()
	monster.set_motion("死亡とめ", -1, 0)
	monster.request_event_script(510)
	helper_c3e8ae39(30)
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_d742309a()
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_a870()
	end
	helper_16388()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_16438()
	monster.stop_moving()
	monster.end_throw()
	helper_a8f0(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_aa30()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
