--!strict
-- dungeon/monster/e206a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_0fd3af5e = require("@lib/monster/helper_0fd3af5e")
local helper_1487c2ae = require("@lib/monster/helper_1487c2ae")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_754712d9 = require("@lib/monster/helper_754712d9")
local helper_7863d8b6 = require("@lib/monster/helper_7863d8b6")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_7e925497 = require("@lib/monster/helper_7e925497")
local helper_80832373 = require("@lib/monster/helper_80832373")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a4ff7523 = require("@lib/monster/helper_a4ff7523")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b0ab6794 = require("@lib/monster/helper_b0ab6794")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b8f0234c = require("@lib/monster/helper_b8f0234c")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_dc78fc76 = require("@lib/monster/helper_dc78fc76")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e7936dab = require("@lib/monster/helper_e7936dab")
local helper_f1703059 = require("@lib/monster/helper_f1703059")

--- Helper function.
local function helper_1c5c()
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
local function helper_a6f4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
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
	var6, target_2, target_3 = helper_1487c2ae(arg2, arg3, var6, target_2, target_3)
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
	helper_595cbf61(helper_28452e16(arg2), arg1)
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
	var19 = helper_7863d8b6(arg4, arg5)
	monster.stop_moving()
	return var19
end

--- Helper function.
local function helper_15464()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 80.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = helper_a6f4(2.0, 5.0, var3, var4, 30.0, 30)
		helper_890ee63a(5.0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(30.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_1109c(arg0: s32)
	local argc: s32 = 0
	local var2: s32 = 0
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	argc = monster.get_random(5) or argc
	var2 = vm.i32(arg0 + argc)
	monster.set_motion("攻撃１ループ", -1, 0)
	helper_754712d9(5.0, var2)
	monster.set_motion("攻撃１", -1, 6)
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_frame_position("dcol00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("fox_銃弾")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_value(-1, 0, attack)
	monster.create_effect_1("マズルフラッシュ")
	helper_56d63eae()
end

--- Helper function.
local function helper_9fcc(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local target_3: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var16: f32 = 0
	var16 = monster.get_target_distance() or var16
	var7, var8, target_3 = helper_1487c2ae(arg1, var16, var7, var8, target_3)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(var7, var8, target_3) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var10, var11, var12, pos_x, pos_y, pos_z)
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
	var16 = monster.get_clear_distance(100.0, 0.0) or var16
	if var16 < 100.0 then
		var7 = vm.f32(pos_x + vm.f32(var10 * var16))
		var8 = pos_y
		target_3 = vm.f32(pos_z + vm.f32(var12 * var16))
		var16 = vm.f32(var16 - arg2)
		if var16 < arg2 then
			return
		end
	end
	monster.move_toward_position(var7, pos_y, target_3, arg0, arg0)
	local _ = helper_7863d8b6(arg2, arg3)
	monster.stop_moving()
end

--- Helper function.
local function helper_14dd8()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 60 then
		argc = monster.get_random(100) or argc
		if argc < 60 then
			helper_1109c(60)
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1.0, 0)
				helper_dc78fc76(2.0, 5.0, 15.0, 180.0, 20.0, 30.0, 20)
			else
				monster.set_motion("立ち", -1, 0)
				helper_7ca8a12f(200.0, 45.0, 30)
			end
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1.0, 0)
			helper_890ee63a(5.0)
			monster.set_motion("歩き右", -1, 4)
			helper_9fcc(2.0, 30.0, 200.0, 30)
		else
			monster.set_motion("歩き", -1.0, 0)
			helper_890ee63a(5.0)
			monster.set_motion("歩き左", -1, 4)
			helper_9fcc(2.0, -30.0, 200.0, 30)
		end
	end
end

--- Helper function.
local function helper_115dc(move_speed: f32)
	local pos_x: f32 = 0
	local var3: f32 = 0
	local pos_z: f32 = 0
	local pos_y: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	monster.set_monster_attributes(32, 1)
	var8 = monster.get_target_distance() or var8
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var10 = monster.get_random_whole_number(15.0) or var10
	var8 = vm.f32(var8 + vm.f32(100.0 + var10))
	pos_x, var3, pos_z = helper_1487c2ae(0.0, var8, pos_x, var3, pos_z)
	monster.set_motion("歩き後", -1, 2)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(pos_x, pos_y - 10.0, pos_z, move_speed, move_speed + 1.0)
	helper_c3e8ae39(helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	helper_56d63eae()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Helper function.
local function helper_143bc()
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 70 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			helper_1109c(35)
		else
			monster.get_random(100, argc)
			monster.get_random_whole_number(45.0, var3)
			monster.get_random_whole_number(30.0, var2)
			if argc < 50 then
				var3 = vm.f32(-var3 - 45.0)
			else
				var3 = vm.f32(var3 + 45.0)
			end
			var2 = vm.f32(var2 + 40.0)
			monster.set_motion("歩き", -1.0, 0)
			local _ = helper_a6f4(2.0, 5.0, var3, vm.f32(200.0 + var2), 30.0, 30)
			helper_890ee63a(5.0)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 15 then
			helper_115dc(vm.f32(3.2))
			helper_1109c(20)
		elseif argc < 35 then
			var4 = monster.get_target_angle() or var4
			var4 = helper_28452e16(vm.f32(var4 + vm.f32(3.1415927)))
			monster.set_motion("歩き", -1.0, 0)
			helper_a4ff7523(2.0, 5.0, var4, 60.0, 300.0, 60)
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1.0, 0)
				helper_890ee63a(5.0)
				monster.set_motion("歩き右", -1, 4)
				helper_9fcc(2.0, 30.0, 200.0, 30)
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_890ee63a(5.0)
				monster.set_motion("歩き左", -1, 4)
				helper_9fcc(2.0, -30.0, 200.0, 30)
			end
		end
	end
end

--- Helper function.
local function helper_114e0()
	monster.set_motion("避け攻撃", -1, 6)
	helper_56d63eae()
end

--- Helper function.
local function helper_133d0()
	local argc: s32 = 0
	local var1: f32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local argc_2: s32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var12: s32 = 0
	local var13: f32 = 0
	monster.get_life()
	var1 = monster.get_target_distance() or var1
	argc = monster.get_random(100) or argc
	if argc < 30 then
		argc = monster.get_random(100) or argc
		if argc < 85 then
			if var1 < 80.0 then
				monster.set_motion("歩き", -1.0, 0)
				helper_890ee63a(7.5)
				helper_114e0()
				monster.set_motion("立ち", -1, 0)
				helper_c3e8ae39(3)
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_890ee63a(5.0)
				helper_1109c(15)
			end
		else
			monster.set_motion("歩き", -1.0, 0)
			helper_890ee63a(5.0)
			helper_1109c(30)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			value = monster.get_variable(0) or value
			value_2 = monster.get_variable(1) or value_2
			if value == 1 or value_2 > 5 then
				monster.get_target_distance()
				argc_2 = monster.get_random(100) or argc_2
				if argc_2 < 50 then
					var7 = 120.0
				else
					var7 = -120.0
				end
				target, target_2, target_3 = helper_1487c2ae(var7, 200.0, target, target_2, target_3)
				var8 = monster.get_angle_to_position(target, target_2, target_3) or var8
				monster.set_rotation(0.0, var8, 0.0)
				monster.set_motion("走り")
				monster.move_toward_position(target, target_2 - 20.0, target_3, 6.4, 6.4)
				helper_b0ab6794(60)
				monster.set_variable(0, 0)
				monster.set_variable(1, 0)
			else
				argc = monster.get_random(100) or argc
				if argc < 25 then
					monster.set_motion("歩き", -1.0, 0)
					helper_890ee63a(5.0)
					helper_115dc(vm.f32(3.8400002))
					helper_1109c(20)
				else
					monster.get_random(100, argc)
					monster.get_random_whole_number(30.0, var13)
					if argc < 50 then
						var13 = vm.f32(-var13 - 30.0)
					else
						var13 = vm.f32(var13 + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					var12 = helper_a6f4(2.0, 5.0, var13, 60.0, 30.0, 40)
					helper_890ee63a(5.0)
					if var12 == 1 then
						monster.set_motion("歩き", -1.0, 0)
						helper_890ee63a(5.0)
						helper_114e0()
						monster.set_motion("立ち", -1, 0)
						helper_c3e8ae39(3)
					end
				end
			end
		end
	end
end

--- Helper function.
local function helper_158e4()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		helper_f1703059()
		var3 = monster.get_target_distance() or var3
		if var3 > 300.0 then
			vm.wait()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_15464()
			continue
		end
		if var3 < 300.0 and var3 >= 200.0 then
			helper_14dd8()
		elseif var3 < 200.0 and var3 >= 80.0 then
			helper_143bc()
		else
			helper_133d0()
		end
	end
end

--- Helper function.
local function helper_db34()
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
	helper_0ba23e4e()
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
		helper_595cbf61(var7, 3.0)
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 30.0)
		if var17 > 0.0 then
			helper_a4ff7523(3.0, vm.f32(1.8), var7, var17, 30.0, 30)
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
				helper_80832373(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.8), 3.0, var5, var18, 30.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_595cbf61(var19, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(200.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			helper_7e925497(200.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			helper_595cbf61(var7, 3.0)
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
					var1 = helper_a6f4(vm.f32(1.8), 3.0, var20, var21, 30.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_595cbf61(var23, 3.0)
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
					helper_e7936dab(vm.f32(1.8), var7, 1000.0, 30.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(200.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			helper_dc78fc76(vm.f32(1.8), 3.0, var5, 360.0, 40.0, 30.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_b80c(arg0: s32)
	monster.stop_moving()
	monster.reset_motion()
	monster.set_motion("立ち", -1, 4)
	helper_b8f0234c(arg0)
end

--- Helper function.
local function helper_12428()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		var3 = monster.get_target_distance() or var3
		if var3 > 300.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1.0, 0)
				helper_890ee63a(2.0)
				helper_e7936dab(2.0, 2.52e-43, 200.0, 30.0, 90) -- retail: the integer 180 is passed where the callee reads a float, so it reads its bits
			else
				helper_b80c(30)
			end
			continue
		end
		if var3 < 300.0 and var3 >= 80.0 then
			argc = monster.get_random(100) or argc
			if argc < 75 then
				helper_1109c(25)
			else
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_motion("歩き", -1.0, 0)
					helper_890ee63a(5.0)
					monster.set_motion("歩き右", -1, 0)
					helper_9fcc(vm.f32(2.4), 5.0, 200.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					helper_890ee63a(5.0)
					monster.set_motion("歩き左", -1, 0)
					helper_9fcc(vm.f32(2.4), 5.0, 200.0, 30)
					monster.set_motion("立ち", -1, 0)
				end
			end
		else
			if var3 < 75.0 then
				monster.set_motion("歩き", -1.0, 0)
				helper_890ee63a(5.0)
				helper_114e0()
				monster.set_motion("立ち", -1, 0)
				helper_c3e8ae39(3)
			end
			argc = monster.get_random(100) or argc
			if argc < 20 then
				monster.get_target_distance()
				argc_2 = monster.get_random(100) or argc_2
				if argc_2 < 50 then
					var9 = 120.0
				else
					var9 = -120.0
				end
				target, target_2, target_3 = helper_1487c2ae(var9, 200.0, target, target_2, target_3)
				var10 = monster.get_angle_to_position(target, target_2, target_3) or var10
				monster.set_rotation(0.0, var10, 0.0)
				monster.set_motion("走り")
				monster.move_toward_position(target, target_2 - 20.0, target_3, 6.4, 6.4)
				helper_b0ab6794(60)
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_890ee63a(6.0)
				helper_115dc(vm.f32(3.8400002))
				monster.set_motion("立ち", -1, 0)
				helper_1109c(15)
			end
		end
		vm.wait()
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
	monster.register_damage_hit("吹っ飛び攻撃", 5.0, "避け攻撃", 0.4, 0.7, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 7.0, "避け攻撃", 0.4, 0.7, 1)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("fox_銃弾", get_not_used_texb) or var1
		var2 = monster.load_effect_script("マズルフラッシュ", get_not_used_texb) or var2
		if (if var1 ~= 0 then 1 else var2) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	helper_1c5c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local gekirin: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			helper_f1703059()
			var0 = monster.get_target_distance() or var0
			if var0 < 300.0 then
				helper_158e4()
			else
				helper_db34()
			end
		else
			helper_12428()
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
		vm.wait()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	local argc: s32 = 0
	local value: s32 = 0
	helper_5d37e9f4()
	argc = monster.get_random(100) or argc
	if argc < 95 then
		monster.set_motion("ダメージ", -1, 6)
		monster.start_knockback(4.0, 0.0, 3)
		helper_56d63eae()
		helper_c3e8ae39(16)
		value = monster.get_variable(1) or value
		value = vm.i32(value + 1)
		monster.set_variable(1, value)
	else
		monster.set_motion("歩き", -1.0, 0)
		helper_890ee63a(5.0)
		helper_115dc(vm.f32(3.8400002))
		helper_1109c(5)
	end
	monster.set_motion("立ち", -1, 0)
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d8cf1050()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_56d63eae()
	monster.set_action_status(1)
	helper_c3e8ae39(15)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_motion("立ち")
	monster.set_variable(0, 1)
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	local var0: f32 = 0
	local argc: s32 = 0
	helper_ab4b367a()
	var0 = monster.get_target_distance() or var0
	if var0 > 80.0 then
		argc = monster.get_random(100) or argc
		if argc < 5 then
			monster.set_monster_attributes(32, 1)
			monster.set_mask_flags(2, 1)
			monster.set_motion("避けin", -1, 2)
			helper_c3e8ae39(helper_9df6409a(10))
			monster.set_monster_attributes(32, 0)
			monster.set_mask_flags(2, 0)
			helper_93495fdf()
			vm.wait()
			helper_56d63eae()
			monster.set_motion("避け攻撃", -1, 6)
			helper_56d63eae()
		end
	end
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	helper_56d63eae()
	helper_c3e8ae39(8)
	monster.set_motion("立ち")
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local argc: s32 = 0
	helper_49610f43()
	monster.stop_moving()
	helper_442b9962()
	monster.set_monster_attributes(32, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("避けin", -1, 2)
	helper_c3e8ae39(helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	helper_93495fdf()
	vm.wait()
	helper_56d63eae()
	argc = monster.get_random(100) or argc
	if argc > 5 then
		monster.set_motion("避け攻撃", -1, 6)
		helper_56d63eae()
	else
		monster.set_motion("避け戻り", -1, 6)
		helper_56d63eae()
	end
	monster.set_mask_flags(2, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.stop_moving()
	helper_442b9962()
	monster.set_monster_attributes(32, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("避けin", -1, 2)
	helper_c3e8ae39(helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	helper_93495fdf()
	vm.wait()
	helper_56d63eae()
	monster.set_motion("避け戻り", -1, 6)
	helper_56d63eae()
	monster.set_mask_flags(2, 0)
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
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_0fd3af5e()
	monster.stop_moving()
	monster.end_throw()
	helper_c3e8ae39(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_e05438b5()
end

return script
