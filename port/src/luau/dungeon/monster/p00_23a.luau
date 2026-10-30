--!strict
-- dungeon/monster/p00_23a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_754712d9 = require("@lib/monster/helper_754712d9")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

local global3: s32 = 0
local global4: s32 = 0
local global5: any = 0
local global6: any = 0

--- Helper function.
local function helper_1c54()
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
local function helper_1c4c8()
	local chara_type: s32 = 0
	chara_type = monster.get_character_number() or chara_type
	global5 = monster.create_effect_2("Ｍギルぽたぽた") or global5
	monster.set_effect_owner(global5, chara_type)
	monster.set_effect_value(global5, 2, 0)
	vm.wait()
end

--- Helper function.
local function helper_ff50(arg0: s32)
	for var1 = 0, arg0 - 1 do
		vm.wait()
	end
end

--- Helper function.
local function helper_18c8(arg0: any)
	return vm.ftoi(arg0)
end

--- Helper function.
local function helper_10084()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local attack: s32 = 0
	print("Attack3------------------------\n")
	monster.reset_motion()
	monster.set_motion("攻撃３", -1, 6)
	helper_ff50(helper_18c8(14))
	attack = monster.get_attack_power_1() or attack
	do
		local out1, _, out3 = monster.get_frame_position("dcol00")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x, 0.0, pos_z)
	monster.set_effect_value(-1, 0, attack)
	monster.shake_camera(2.0, 30)
	helper_56d63eae()
end

--- Helper function.
local function helper_10430()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local attack: s32 = 0
	print("Attack3------------------------\n")
	monster.reset_motion()
	monster.set_motion("攻撃４", -1, 6)
	helper_ff50(helper_18c8(14))
	attack = monster.get_attack_power_1() or attack
	do
		local out1, _, out3 = monster.get_frame_position("dcol01")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x, 0.0, pos_z)
	monster.set_effect_value(-1, 0, attack)
	monster.shake_camera(2.0, 30)
	helper_56d63eae()
end

--- Helper function.
local function helper_1107c(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
	local arrived: s32 = 0
	local argc: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	for var5 = 0, arg4 - 1 do
		arrived = monster.is_move_finished() or arrived
		var8 = monster.get_target_distance() or var8
		var9 = 1.0
		var9 = monster.get_motion_progress() or var9
		if var8 < 75.0 then
			argc = monster.get_random(200) or argc
			if argc < 10 then
				monster.stop_moving()
				var10 = monster.get_target_angle() or var10
				if var10 > vm.f32(3.1415927) then
					var10 = vm.f32(var10 - vm.f32(6.2831855))
				end
				if var10 <= vm.f32(-3.1415927) then
					var10 = vm.f32(var10 + vm.f32(6.2831855))
				end
				helper_890ee63a(5.0)
				if var10 < 0.0 then
					helper_10084()
				else
					helper_10430()
				end
				monster.set_motion("立ち", -1, 0)
				helper_ff50(15)
				monster.set_motion("歩き", -1, 0)
				do
					local _, out2, _ = monster.get_rotation_toward_6(arg0, arg1, arg2)
					var12 = out2 or var12
				end
				helper_595cbf61(helper_28452e16(var12), 5.0)
				monster.set_motion("歩き", -1, 0)
				monster.move_toward_position(arg0, arg1, arg2, arg3, arg3)
			end
		end
		if var9 >= vm.f32(0.524998) and var9 <= vm.f32(0.539998) then
			monster.shake_camera(1.8, 12)
		end
		if var9 >= vm.f32(0.97) then
			monster.shake_camera(1.8, 9)
		end
		if arrived == 0 then
			vm.wait()
		else
			monster.stop_moving()
			return
		end
	end
end

--- Helper function.
local function helper_131a8(x: f32, arg1: f32, z: f32, arg3: f32, arg4: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	var5 = vm.f32(vm.fdiv(arg3, arg4))
	var6 = 0.0
	while var6 < arg4 do
		var7 = monster.get_target_angle() or var7
		monster.set_position(x, arg1 + vm.f32(var5 * var6), z)
		monster.set_rotation(0.0, var7, 0.0)
		var6 = vm.f32(var6 + 1.0)
		vm.wait()
	end
	monster.set_position(x, arg1 + arg3, z)
end

--- Helper function.
local function helper_134a4()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local vector: f32 = 0
	local value: s32 = 0
	local id: s32 = 0
	local attack: s32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	local chara_type: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_monster_attributes(32, 1)
	print("Attack1-------------------------\n")
	var17 = 50.0
	monster.reset_motion()
	monster.set_motion("攻撃１入り", -1, 6)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	monster.copy_vector(pos_x_2, pos_y_2, pos_z_2)
	helper_754712d9(10.0, helper_18c8(11))
	monster.set_monster_attributes(32, 0)
	monster.set_invulnerable_time(helper_18c8(124))
	var18 = helper_18c8(29)
	helper_131a8(pos_x_2, pos_y_2, pos_z_2, var17, var18)
	helper_56d63eae()
	monster.set_motion("攻撃１", -1, 6)
	value = helper_754712d9(5.0, helper_18c8(28))
	helper_ff50(helper_18c8(vm.i32(28 - value)))
	value = monster.get_variable(4) or value
	if value == 0 then
		id = 0
	else
		id = 1
	end
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.3)))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol02")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	chara_type = monster.get_character_number() or chara_type
	id = 0
	vector = 16.0
	monster.play_monster_sound(chara_type, 5)
	monster.create_effect_1("Ｍギル火炎弾２")
	monster.set_effect_target(-1, id)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, vector, 0.2, -90.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, chara_type)
	monster.play_monster_sound(chara_type, 5)
	helper_ff50(helper_18c8(10))
	monster.create_effect_1("Ｍギル火炎弾２")
	monster.set_effect_target(-1, id)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, vector, 0.2, -0.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, chara_type)
	monster.play_monster_sound(chara_type, 5)
	helper_ff50(helper_18c8(10))
	monster.create_effect_1("Ｍギル火炎弾２")
	monster.set_effect_target(-1, id)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, vector, 0.2, -180.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, chara_type)
	monster.play_monster_sound(chara_type, 5)
	helper_ff50(helper_18c8(10))
	monster.create_effect_1("Ｍギル火炎弾２")
	monster.set_effect_target(-1, id)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, vector, 0.2, 90.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, chara_type)
	monster.play_monster_sound(chara_type, 5)
	helper_ff50(helper_18c8(10))
	monster.set_motion("攻撃１終わり", -1, 6)
	pos_y_2 = vm.f32(pos_y_2 + var17)
	var18 = helper_18c8(32)
	helper_131a8(pos_x_2, pos_y_2, pos_z_2, -var17, var18)
	monster.stop_moving()
	monster.shake_camera(2.0, helper_18c8(15))
	helper_56d63eae()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	monster.set_position(pos_x_2, 0.0, pos_z_2)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_monster_attributes(32, 0)
end

--- Helper function.
local function helper_1aab0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	monster.set_motion("歩き", -1, 0)
	var3 = monster.get_random_whole_number(6.2831855) or var3
	print("random angle=", vm.float(var3), "-----------------\n")
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = 0.0
	pos_z = 0.0
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var3) * 250.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var3) * 250.0))
	var3 = monster.get_angle_to_position(pos_x, pos_y, pos_z) or var3
	helper_595cbf61(helper_28452e16(var3), 5.0)
	helper_442b9962()
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.0, 3.0)
	var4 = monster.get_distance_to_position(pos_x, pos_y, pos_z) or var4
	var5 = vm.ftoi(vm.f32(var4 / 3.0))
	print("frame=", var5, "--------------------\n")
	helper_1107c(pos_x, pos_y, pos_z, 3.0, var5)
	monster.stop_moving()
	helper_890ee63a(5.0)
	helper_134a4()
	monster.set_motion("立ち", -1, 0)
	helper_ff50(15)
end

--- Helper function.
local function helper_107dc(target: f32, target_2: f32, target_3: f32, arg3: f32)
	local arrived: s32 = 0
	local argc: s32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	arrived = monster.is_move_finished() or arrived
	var7 = monster.get_target_distance() or var7
	var8 = 1.0
	var8 = monster.get_motion_progress() or var8
	if var7 < 75.0 then
		argc = monster.get_random(200) or argc
		if argc < 10 then
			monster.stop_moving()
			var9 = monster.get_target_angle() or var9
			if var9 > vm.f32(3.1415927) then
				var9 = vm.f32(var9 - vm.f32(6.2831855))
			end
			if var9 <= vm.f32(-3.1415927) then
				var9 = vm.f32(var9 + vm.f32(6.2831855))
			end
			helper_890ee63a(5.0)
			if var9 < 0.0 then
				helper_10084()
			else
				helper_10430()
			end
			monster.set_motion("立ち", -1, 0)
			helper_ff50(15)
			monster.set_motion("歩き", -1, 0)
			monster.call_command(101, target, target_2, target_3, var10) -- retail: the handler rejects 4 arguments
			helper_595cbf61(helper_28452e16(var10), 5.0)
			monster.set_motion("歩き", -1, 0)
			monster.move_toward_position(target, target_2, target_3, arg3, arg3)
		end
	end
	if var8 >= vm.f32(0.524998) and var8 <= vm.f32(0.539998) then
		monster.shake_camera(1.8, 12)
	end
	if var8 >= vm.f32(0.97) then
		monster.shake_camera(1.8, 9)
	end
	if arrived == 0 then
		vm.wait()
	else
		monster.stop_moving()
		return 2
	end
	return 0
end

--- Helper function.
local function helper_126f0(arg0: f32, arg1: f32, arg2: any, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var11: f32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local _ = helper_787df986(arg1)
	var13 = 0
	while var13 < arg3 do
		do
			local out1, out2, out3 = monster.get_target_position()
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		var11 = monster.get_target_angle() or var11
		if helper_107dc(var4, var5, var6, arg0) == 2 then
			break
		else
			monster.move_toward_position(var4, var5, var6, arg0, arg0)
			monster.set_rotation(0.0, var11, 0.0)
			vm.wait()
			var13 = var13 + 1
		end
	end
	monster.stop_moving()
	return var12
end

--- Helper function.
local function helper_162a8(arg0: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local chara_type: s32 = 0
	local value: s32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local attack: s32 = 0
	monster.set_motion("立ち", -1, 0)
	vm.wait()
	monster.set_motion("吠える", -1, 6)
	helper_ff50(helper_18c8(58))
	monster.shake_camera(3.0, 90)
	chara_type = monster.get_character_number() or chara_type
	value = chara_type
	do
		local out1, out2, out3 = monster.get_frame_position("dcol02")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg0 == 1 then
		value_3 = 10.0
		value_2 = 1.5
		attack = monster.get_attack_power_1() or attack
		monster.create_effect_1("Ｍギル火炎弾３")
		monster.set_effect_target(-1, chara_type)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, 50.0, 0.0, 30.0)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value_float(-1, 1, value_2)
		monster.set_effect_value_float(-1, 2, value_3)
		monster.set_effect_value(-1, 3, value)
		helper_ff50(helper_18c8(10))
		monster.create_effect_1("Ｍギル火炎弾３")
		monster.set_effect_target(-1, chara_type)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, 50.0, 120.0, 40.0)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value_float(-1, 1, value_2)
		monster.set_effect_value_float(-1, 2, value_3)
		monster.set_effect_value(-1, 3, value)
		helper_ff50(helper_18c8(10))
		monster.create_effect_1("Ｍギル火炎弾３")
		monster.set_effect_target(-1, chara_type)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, 50.0, 240.0, 30.0)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value_float(-1, 1, value_2)
		monster.set_effect_value_float(-1, 2, value_3)
		monster.set_effect_value(-1, 3, value)
		helper_ff50(helper_18c8(10))
		monster.create_effect_1("Ｍギル火炎弾３")
		monster.set_effect_target(-1, chara_type)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, 50.0, 0.0, 40.0)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value_float(-1, 1, value_2)
		monster.set_effect_value_float(-1, 2, value_3)
		monster.set_effect_value(-1, 3, value)
	end
	helper_56d63eae()
end

--- Helper function.
local function helper_1a888()
	local value: s32 = 0
	value = monster.get_variable(4) or value
	monster.set_motion("歩き", -1, 0)
	local _ = helper_126f0(3.0, 5.0, 75.0, 60)
	if value == 0 then
		helper_162a8(0)
	else
		helper_162a8(1)
	end
end

--- Helper function.
local function helper_db88(arg0: s32)
	if arg0 ~= 0 then
		global5 = monster.create_effect_2("Ｍギルぽたぽた") or global5
		monster.set_effect_value(global5, 2, 0)
		monster.set_effect_value(global6, 2, 1)
		monster.finish_effect(global6)
	else
		global6 = monster.create_effect_2("Ｍギル煙") or global6
		monster.set_effect_value(global5, 2, 1)
		monster.set_effect_value(global6, 2, 0)
		monster.finish_effect(global5)
	end
end

--- Helper function.
local function helper_de98(arg0: s32)
	local var4: s32 = 0
	for var1 = 0, 9 do
		monster.set_model_color(128, 128, 128, 128, "skin")
		monster.set_model_color(128, 128, 128, 128, "skin5")
		monster.set_model_color(128, 128, 128, 128, "skin6")
		monster.set_model_color(128, 128, 128, 128, "skin7")
		monster.set_model_color(128, 128, 128, 128, "kao")
		monster.set_model_color(128, 128, 128, 128, "ha1")
		monster.set_model_color(128, 128, 128, 128, "ha2")
		monster.set_model_color(128, 128, 128, 128, "ha3")
		monster.set_model_color(128, 128, 128, 128, "ha4")
		monster.set_model_color(128, 128, 128, 128, "ha5")
		monster.set_model_color(128, 128, 128, 128, "ha6")
		monster.set_model_color(128, 128, 128, 128, "skin8")
		vm.wait()
		monster.set_model_color(112, 112, 112, 128, "skin")
		monster.set_model_color(112, 112, 112, 128, "skin5")
		monster.set_model_color(112, 112, 112, 128, "skin6")
		monster.set_model_color(112, 112, 112, 128, "skin7")
		monster.set_model_color(112, 112, 112, 128, "kao")
		monster.set_model_color(112, 112, 112, 128, "ha1")
		monster.set_model_color(112, 112, 112, 128, "ha2")
		monster.set_model_color(112, 112, 112, 128, "ha3")
		monster.set_model_color(112, 112, 112, 128, "ha4")
		monster.set_model_color(112, 112, 112, 128, "ha5")
		monster.set_model_color(112, 112, 112, 128, "ha6")
		monster.set_model_color(112, 112, 112, 128, "skin8")
		vm.wait()
		monster.set_model_color(80, 80, 80, 128, "skin")
		monster.set_model_color(80, 80, 80, 128, "skin5")
		monster.set_model_color(80, 80, 80, 128, "skin6")
		monster.set_model_color(80, 80, 80, 128, "skin7")
		monster.set_model_color(80, 80, 80, 128, "kao")
		monster.set_model_color(80, 80, 80, 128, "ha1")
		monster.set_model_color(80, 80, 80, 128, "ha2")
		monster.set_model_color(80, 80, 80, 128, "ha3")
		monster.set_model_color(80, 80, 80, 128, "ha4")
		monster.set_model_color(80, 80, 80, 128, "ha5")
		monster.set_model_color(80, 80, 80, 128, "ha6")
		monster.set_model_color(80, 80, 80, 128, "skin8")
		vm.wait()
	end
	if arg0 ~= 0 then
		var4 = 128
		monster.set_defense_rate(1.0)
	else
		var4 = 32
		monster.set_defense_rate(0.5)
	end
	monster.set_model_color(var4, var4, var4, 128, "skin")
	monster.set_model_color(var4, var4, var4, 128, "skin5")
	monster.set_model_color(var4, var4, var4, 128, "skin6")
	monster.set_model_color(var4, var4, var4, 128, "skin7")
	monster.set_model_color(var4, var4, var4, 128, "kao")
	monster.set_model_color(var4, var4, var4, 128, "ha1")
	monster.set_model_color(var4, var4, var4, 128, "ha2")
	monster.set_model_color(var4, var4, var4, 128, "ha3")
	monster.set_model_color(var4, var4, var4, 128, "ha4")
	monster.set_model_color(var4, var4, var4, 128, "ha5")
	monster.set_model_color(var4, var4, var4, 128, "ha6")
	monster.set_model_color(var4, var4, var4, 128, "skin8")
end

--- Helper function.
local function helper_1cb0c()
	while true do
		global3 = monster.get_variable(11) or global3
		if global3 <= 1 then
			helper_1aab0()
		end
		if global3 <= 2 and global3 > 1 then
			helper_1a888()
		end
		if global3 <= 3 and global3 > 2 then
			helper_1aab0()
		end
		if global3 > 3 then
			helper_db88(0)
			helper_de98(0)
			global3 = 0
			monster.set_variable(9, 1)
			monster.set_variable(11, global3)
			break
		else
			global3 = global3 + 1
			monster.set_variable(11, global3)
		end
	end
end

--- Helper function.
local function helper_11a30(arg0: s32)
	local arrived: s32 = 0
	local var5: f32 = 0
	for var1 = 0, arg0 - 1 do
		arrived = monster.is_move_finished() or arrived
		monster.get_target_distance()
		var5 = 1.0
		var5 = monster.get_motion_progress() or var5
		if var5 >= vm.f32(0.524998) and var5 <= vm.f32(0.539998) then
			monster.shake_camera(1.8, 12)
		end
		if var5 >= vm.f32(0.97) then
			monster.shake_camera(1.8, 9)
		end
		if arrived == 0 then
			vm.wait()
		else
			monster.stop_moving()
			return
		end
	end
end

--- Helper function.
local function helper_11e40(arg0: f32, arg1: f32, arg2: f32)
	local var4: f32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: f32 = 0
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	var8 = vm.ftoi(arg2)
	var7 = 0
	while var7 < var8 do
		var9 = 1.0
		var9 = monster.get_motion_progress() or var9
		if var9 >= vm.f32(0.524998) and var9 <= vm.f32(0.539998) then
			monster.shake_camera(1.2, 12)
		end
		if var9 >= vm.f32(0.97) then
			monster.shake_camera(1.2, 9)
		end
		do
			local _, out2, _ = monster.get_rotation()
			var4 = out2 or var4
		end
		if var4 > vm.f32(arg0 - arg1) and var4 < vm.f32(arg0 + arg1) then
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
			var7 = var7 + 1
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_12598(arg0: f32)
	local var2: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var2 = monster.get_target_angle() or var2
	local _ = helper_11e40(helper_28452e16(var2), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_1b594()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local old_pos_x: f32 = 0
	local old_pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local argc: s32 = 0
	local var12: s32 = 0
	local value: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
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
		local out1, _, out3 = monster.get_target_previous_position()
		old_pos_x = out1 or old_pos_x
		old_pos_z = out3 or old_pos_z
	end
	var10 = monster.get_distance_between(var3, var4, var5, pos_x, pos_y, pos_z) or var10
	var9 = monster.get_target_angle() or var9
	if var10 < 600.0 then
		var9 = vm.f32(var9 + vm.f32(3.1415927))
	end
	if var9 > vm.f32(3.1415927) then
		var9 = vm.f32(var9 - vm.f32(6.2831855))
	end
	if var9 <= vm.f32(-3.1415927) then
		var9 = vm.f32(var9 + vm.f32(6.2831855))
	end
	if var3 ~= old_pos_x and var5 ~= old_pos_z then
		monster.set_motion("歩き", -1, 0)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = 0.0
		pos_z = 0.0
		pos_x = vm.f32(pos_x + vm.f32(vm.sin(var9) * 250.0))
		pos_z = vm.f32(pos_z + vm.f32(vm.cos(var9) * 250.0))
		var9 = monster.get_angle_to_position(pos_x, pos_y, pos_z) or var9
		helper_595cbf61(helper_28452e16(var9), 5.0)
		helper_442b9962()
		monster.move_toward_position(pos_x, pos_y, pos_z, 3.0, 3.0)
		var10 = monster.get_distance_to_position(pos_x, pos_y, pos_z) or var10
		var12 = vm.ftoi(vm.f32(var10 / 3.0))
		helper_11a30(var12)
		monster.stop_moving()
		helper_12598(5.0)
	end
	argc = monster.get_random(100) or argc
	if argc < 30 then
		value = monster.get_variable(5) or value
		if value == 1 then
			var9 = monster.get_target_angle() or var9
			if var9 > vm.f32(3.1415927) then
				var9 = vm.f32(var9 - vm.f32(6.2831855))
			end
			if var9 <= vm.f32(-3.1415927) then
				var9 = vm.f32(var9 + vm.f32(6.2831855))
			end
			if var9 < 0.0 then
				helper_10084()
			else
				helper_10430()
			end
			monster.set_motion("立ち", -1, 0)
			helper_ff50(15)
		else
			monster.set_motion("疲労立ち", -1, 0)
			helper_c3e8ae39(90)
		end
	else
		monster.set_motion("疲労立ち", -1, 0)
		helper_c3e8ae39(120)
	end
end

--- Helper function.
local function helper_17338(arg0: f32, arg1: s32)
	local move_speed: f32 = 0
	local value: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local value_int = true
	value = monster.get_variable(3) or value
	if value == 0 then
		monster.set_mask_flags(2, 1)
		do
			local out1, out2, out3 = monster.get_target_position()
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		monster.get_position_3()
		var10 = vm.f32(99999.9)
		for var7 = 0, 7 do
			if var7 == 0 then
				var28 = vm.f32(272.51)
				var29 = 0.0
				var30 = vm.f32(-568.85)
			end
			if var7 == 1 then
				var28 = vm.f32(503.09)
				var29 = 0.0
				var30 = vm.f32(-432.41)
			end
			if var7 == 2 then
				var28 = vm.f32(630.23)
				var29 = 0.0
				var30 = vm.f32(-179.24)
			end
			if var7 == 3 then
				var28 = vm.f32(633.72)
				var29 = 0.0
				var30 = vm.f32(36.76)
			end
			if var7 == 4 then
				var28 = vm.f32(562.85)
				var29 = 0.0
				var30 = vm.f32(308.49)
			end
			if var7 == 5 then
				var28 = vm.f32(320.65)
				var29 = 0.0
				var30 = vm.f32(542.79)
			end
			if var7 == 6 then
				var28 = vm.f32(-309.06)
				var29 = 0.0
				var30 = vm.f32(581.76)
			end
			if var7 == 7 then
				var28 = vm.f32(-527.6)
				var29 = 0.0
				var30 = vm.f32(387.76)
			end
			var9 = monster.get_distance_between(var18, var19, var20, var28, var29, var30) or var9
			if var9 < var10 then
				var10 = var9
				do
					local out1, out2, out3 = monster.copy_vector(var28, var29, var30)
					var12 = out1 or var12
					var13 = out2 or var13
					var14 = out3 or var14
				end
			end
		end
		monster.set_motion("歩き", -1, 0)
		if var27 > vm.f32(3.1415927) then
			var27 = vm.f32(var27 - vm.f32(6.2831855))
		end
		if var27 <= vm.f32(-3.1415927) then
			var27 = vm.f32(var27 + vm.f32(6.2831855))
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		do
			local out1, out2, out3 = monster.copy_vector(var12, var13, var14)
			var24 = out1 or var24
			var25 = out2 or var25
			var26 = out3 or var26
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var24, var25, var26, pos_x_2, pos_y_2, pos_z_2)
			var24 = out1 or var24
			var25 = out2 or var25
			var26 = out3 or var26
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var24, var25, var26)
			var24 = out1 or var24
			var25 = out2 or var25
			var26 = out3 or var26
		end
		do
			local out1, out2, out3 = monster.scale_vector(var24, var25, var26, 450.0)
			var24 = out1 or var24
			var25 = out2 or var25
			var26 = out3 or var26
		end
		var27 = monster.get_angle_to_position(var24, var25, var26) or var27
		helper_595cbf61(helper_28452e16(var27), 5.0)
		helper_442b9962()
		monster.move_toward_position(var24, 0.0, var26, 3.0, 3.0)
		helper_11a30(180)
		monster.stop_moving()
		monster.set_motion("歩き", 0)
		helper_12598(5.0)
		helper_442b9962()
		do
			local out1, out2, out3 = monster.get_position_3()
			var24 = out1 or var24
			var25 = out2 or var25
			var26 = out3 or var26
		end
		var10 = monster.get_distance_between(var24, var25, var26, var12, var13, var14) or var10
		var11 = 37.0
		move_speed = vm.f32(vm.fdiv(var10, var11))
		print("magma flag=", if value_int then value else vm.float(value), "------------------\n")
		print("pos[0]=", vm.float(var12), "------------------\n")
		print("pos[1]=", vm.float(var13), "------------------\n")
		print("pos[2]=", vm.float(var14), "------------------\n\n")
		monster.set_monster_attributes(32, 1)
		monster.set_motion("ジャンプ入り", -1, 6)
		helper_ff50(helper_18c8(14))
		monster.set_monster_attributes(16, 1)
		monster.move_toward_position(var12, var13, var14, move_speed, move_speed * 0.5)
		helper_c3e8ae39(helper_18c8(vm.ftoi(var11)))
		monster.set_monster_attributes(16, 0)
		monster.set_position(var12, var13, var14)
		helper_ff50(helper_18c8(vm.i32(20 - vm.ftoi(var11))))
		helper_db88(1)
		monster.set_effect_value(global5, 1, 1)
		monster.create_effect_1("Ｍギルしぶき")
		monster.set_effect_first_vector(-1, var12, var13 - 20.0, var14)
		monster.stop_moving()
		monster.set_motion("ジャンプ終わり", -1, 2)
		value = helper_890ee63a(10.0)
		value_int = false
		if helper_18c8(74) > helper_18c8(value) then
			helper_ff50(helper_18c8(vm.f32(74 - value)))
		end
		helper_56d63eae()
		do
			local out1, out2, out3 = monster.get_position_3()
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		print("pos[0]=", vm.float(var12), "------------------\n")
		print("pos[1]=", vm.float(var13), "------------------\n")
		print("pos[2]=", vm.float(var14), "------------------\n")
		monster.set_variable(3, 1)
		monster.set_motion("マグマ立ち", -1, 0)
		monster.stop_moving()
		monster.set_monster_attributes(32, 0)
		helper_de98(1)
		if arg1 ~= 0 then
			helper_890ee63a(5.0)
			helper_7ca8a12f(arg0, 45.0, arg1)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_14d78(arg0: s32)
	local vector: f32 = 0
	local vector_2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local id: s32 = 0
	local value: s32 = 0
	local argc: s32 = 0
	local attack: s32 = 0
	local chara_type: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	print("Attack2------------------------\n")
	chara_type = monster.get_character_number() or chara_type
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	helper_ff50(60)
	if arg0 == 1 then
		vector = 15.0
		vector_2 = vm.f32(0.4)
	end
	if arg0 == 2 then
		vector = 22.5
		vector_2 = vm.f32(0.3)
	end
	if arg0 == 4 then
		vector = 20.0
		vector_2 = vm.f32(0.2)
	end
	if arg0 == 8 then
		vector = 30.0
		vector_2 = vm.f32(0.15)
	end
	value = monster.get_variable(4) or value
	if value == 0 then
		id = 0
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			id = 1
			vector = 20.0
		else
			id = 0
		end
	end
	do
		local out1, out2, out3 = monster.get_frame_position("dcol02")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	vector_2 = vm.f32(0.2)
	vector = 25.0
	id = 0
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.3)))
	var6 = monster.get_target_distance() or var6
	for var14 = 1, 4 do
		monster.play_monster_sound(chara_type, 8)
		var6 = monster.get_target_distance() or var6
		if var6 < 400.0 then
			vector_2 = 1.0
			monster.create_effect_1("Ｍギル火炎弾２")
			monster.set_effect_target(-1, id)
			monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
			monster.set_effect_second_vector(-1, 10.0, vector_2, 0.0)
			monster.set_effect_value(-1, 0, attack)
			monster.set_effect_value(-1, 1, chara_type)
			helper_ff50(helper_18c8(15))
		else
			var13 = monster.get_target_angle() or var13
			if var13 > vm.f32(3.1415927) then
				var13 = vm.f32(var13 - vm.f32(6.2831855))
			end
			if var13 <= vm.f32(-3.1415927) then
				var13 = vm.f32(var13 + vm.f32(6.2831855))
			end
			print("angle=", vm.float(var13), "--------------------\n")
			vector_2 = vm.f32(0.19)
			var12 = monster.get_random_whole_number(10.0) or var12
			vector_2 = vm.f32(vector_2 + vm.f32(var12 / 1000.0))
			print("ratio=", vm.float(vector_2), "---------------------\n")
			if vm.imod(var14 + 1, 2) == 1 then
				var13 = monster.get_random_whole_number(20.0) or var13
				var13 = vm.f32(5.0 + var13)
			else
				var13 = monster.get_random_whole_number(20.0) or var13
				var13 = vm.f32(175.0 - var13)
			end
			var12 = monster.get_random_whole_number(15.0) or var12
			monster.create_effect_1("Ｍギル火炎弾２")
			monster.set_effect_target(-1, id)
			monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
			monster.set_effect_second_vector(-1, vector, vector_2, -var13)
			monster.set_effect_value(-1, 0, attack)
			monster.set_effect_value(-1, 1, chara_type)
			helper_ff50(helper_18c8(30))
		end
	end
end

--- Helper function.
local function helper_1b234()
	local var0: s32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local argc: s32 = 0
	value = monster.get_variable(4) or value
	value_2 = monster.get_variable(5) or value_2
	var0 = helper_17338(1200.0, 30)
	if var0 == 1 then
		helper_890ee63a(5.0)
		helper_14d78(value_2)
	end
	if value == 2 then
		helper_890ee63a(5.0)
		helper_14d78(value_2)
		argc = monster.get_random(100) or argc
		if argc < 5 then
			helper_890ee63a(5.0)
			helper_14d78(value_2)
		end
	end
	monster.set_motion("マグマ立ち", -1, 0)
end

--- Helper function.
local function helper_1943c()
	local value: s32 = 0
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	value = monster.get_variable(3) or value
	if value == 1 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			do
				local out1, out2, out3 = monster.get_position_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = monster.get_target_position()
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			var2 = monster.get_distance_between(pos_x, pos_y, pos_z, var4, 0.0, var6) or var2
			var3 = 26.0
			var2 = vm.f32(vm.fdiv(var2, var3))
		else
			monster.set_motion("歩き", 0)
			helper_12598(10.0)
			do
				local out1, out2, out3 = monster.get_position_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var13 = monster.get_target_angle() or var13
			var4 = vm.f32(250.0 * vm.sin(var13))
			var5 = pos_y
			var6 = vm.f32(250.0 * vm.cos(var13))
			do
				local out1, out2, out3 = monster.get_target_position()
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			var2 = monster.get_distance_between(var10, var11, var12, var4, var5, var6) or var2
			if var2 > 250.0 then
				var13 = monster.get_target_angle() or var13
				var13 = vm.f32(var13 + vm.f32(3.1415927))
				if var13 > vm.f32(3.1415927) then
					var13 = vm.f32(var13 - vm.f32(6.2831855))
				end
				if var13 <= vm.f32(-3.1415927) then
					var13 = vm.f32(var13 + vm.f32(6.2831855))
				end
				var4 = vm.f32(250.0 * vm.sin(var13))
				var5 = pos_y
				var6 = vm.f32(250.0 * vm.cos(var13))
			end
			var2 = monster.get_distance_between(pos_x, pos_y, pos_z, var4, 0.0, var6) or var2
			var3 = 26.0
			var2 = vm.f32(vm.fdiv(var2, var3))
			global3 = 2
		end
		monster.set_motion("マグマ脱出", -1, 6)
		helper_ff50(helper_18c8(29))
		monster.move_toward_position(var4, 0.0, var6, var2, var2 * 0.5)
		helper_ff50(helper_18c8(30))
		monster.shake_camera(2.5, helper_18c8(20))
		helper_56d63eae()
		monster.stop_moving()
		monster.set_variable(3, 0)
		monster.set_mask_flags(2, 0)
		return
	end
end

--- Helper function.
local function helper_1c7f8()
	while true do
		global4 = monster.get_variable(12) or global4
		if global4 < 1 then
			helper_1b594()
		else
			helper_1b234()
		end
		if global4 >= 3 then
			helper_1943c()
			global4 = 0
			monster.set_variable(9, 2)
			monster.set_variable(12, global4)
			break
		else
			global4 = global4 + 1
			monster.set_variable(12, global4)
		end
	end
end

--- Helper function.
local function helper_1d0b0()
	local var1: f32 = 0
	local life: f32 = 0
	local life_2: s32 = 0
	local value: s32 = 0
	local life_int = true
	global3 = 0
	while true do
		vm.wait()
		var1 = monster.get_target_distance() or var1
		life = (if life_int then vm.bits_float(monster.get_life_int()) else monster.get_life()) or life
		print("life=", vm.float(life), "----------\n")
		life_int = false
		life_2 = monster.get_life_int() or life_2
		if vm.f32(life_2 / 200.0) < 0.5 or life < 0.5 and life ~= 0.0 then
			monster.set_variable(4, 0)
			if vm.f32(life_2 / 200.0) < vm.f32(0.2) or life < 0.5 and life ~= 0.0 then
				monster.set_variable(4, 2)
			end
		end
		var1 = monster.get_target_distance() or var1
		if var1 >= 1200.0 then
			vm.wait()
			return
		end
		if var1 < 1200.0 and var1 >= 800.0 then
			print("FarRange-------------------------------\n")
			monster.set_variable(5, 4)
		elseif var1 < 800.0 and var1 >= 400.0 then
			print("MidRange-------------------------------\n")
			helper_1ef0d4b2()
			monster.set_variable(5, 2)
		else
			print("NearRange-------------------------------\n")
			helper_1ef0d4b2()
			monster.set_variable(5, 1)
		end
		value = monster.get_variable(9) or value
		if value == 2 then
			helper_1cb0c()
		elseif value == 1 then
			helper_1c7f8()
		end
		vm.wait()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	print("initialize -------------------\n")
	global3 = 0
	global4 = 0
	monster.register_damage_hit("吹っ飛び弱", 9.0, "攻撃３", 0.393, 0.426, 0)
	monster.register_damage_hit("吹っ飛び弱", 9.0, "攻撃４", 0.393, 0.426, 1)
	monster.load_effect_script("Ｍギル火炎弾２")
	monster.load_effect_script("Ｍギル火炎弾３")
	monster.load_effect_script("ヴァンガード衝撃波")
	monster.load_effect_script("Ｍギル火柱１")
	monster.load_effect_script("Ｍギルぽたぽた")
	monster.load_effect_script("Ｍギルしぶき")
	monster.load_effect_script("Ｍギル煙")
	monster.set_camera_mode(4)
	monster.set_model_lighting(0)
	monster.set_model_color(128, 128, 128, 128)
	global3 = 0
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	monster.set_variable(4, 0)
	monster.set_variable(5, 0)
	monster.set_variable(6, 128)
	monster.set_variable(7, 128)
	monster.set_variable(8, 128)
	monster.set_variable(9, 2)
	monster.set_variable(11, 0)
	monster.set_variable(12, 0)
	helper_1c54()
	monster.set_clip_distance(9999.9)
	monster.set_photo_opportunity(1017)
	helper_1c4c8()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	print("start---------\n")
	while true do
		helper_1d0b0()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	local value: s32 = 0
	monster.set_monster_attributes(32, 0)
	value = monster.get_variable(4) or value
	if value == 0 then
		helper_162a8(0)
	else
		helper_162a8(1)
	end
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Guards against a hit.
function script.on_guard()
	monster.set_monster_attributes(32, 0)
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	helper_442b9962()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	helper_442b9962()
end

--- Runs the monster's death.
function script.on_death()
	local value: s32 = 0
	monster.finish_effect(global5)
	monster.finish_effect(global6)
	monster.stop_moving()
	helper_442b9962()
	monster.set_camera_mode(0)
	monster.set_monster_attributes(64, 1)
	monster.set_monster_attributes(2, 1)
	monster.start_death()
	value = monster.get_variable(3) or value
	monster.reset_motion()
	if value == 1 then
		monster.set_motion("マグマ死に", -1, 6)
	else
		monster.set_motion("死に", -1, 6)
	end
	helper_56d63eae()
	monster.request_event_script(570)
	helper_c3e8ae39(30)
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	helper_442b9962()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	helper_442b9962()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	helper_442b9962()
end

return script
