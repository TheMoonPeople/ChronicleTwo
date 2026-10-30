--!strict
-- dungeon/monster/e201a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0682d2de = require("@lib/monster/helper_0682d2de")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_54469cb2 = require("@lib/monster/helper_54469cb2")
local helper_549e2b35 = require("@lib/monster/helper_549e2b35")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57db7062 = require("@lib/monster/helper_57db7062")
local helper_58087289 = require("@lib/monster/helper_58087289")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_97d8f861 = require("@lib/monster/helper_97d8f861")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b765e6cd = require("@lib/monster/helper_b765e6cd")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_ba87ea88 = require("@lib/monster/helper_ba87ea88")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_cd4ea219 = require("@lib/monster/helper_cd4ea219")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")
local helper_fd16d93e = require("@lib/monster/helper_fd16d93e")

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
local function helper_1324(arg0: f32, distance: f32, arg2: f32, arg3: f32, arg4: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	var5 = vm.f32(arg0 * vm.f32(0.017453292))
	var6 = monster.get_target_angle() or var6
	var6 = vm.f32(var6 - vm.f32(3.1415927))
	var6 = vm.f32(var6 + var5)
	if var6 > vm.f32(3.1415927) then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if var6 <= vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_point_around_target(var6, distance)
		arg2 = out1 or arg2
		arg3 = out2 or arg3
		arg4 = out3 or arg4
	end
	return arg2, arg3, arg4
end

--- Helper function.
local function helper_bc24(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
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
	var6, target_2, target_3 = helper_1324(arg2, arg3, var6, target_2, target_3)
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
	helper_179581d3(helper_28452e16(arg2), arg1)
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
	var19 = helper_0682d2de(arg4, arg5)
	monster.stop_moving()
	return var19
end

--- Helper function.
local function helper_11eac()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 145.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = helper_bc24(vm.f32(1.8), 4.0, var3, var4, 37.0, 30)
		helper_83e135e0(4.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(37.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_12ed0()
	monster.set_motion("攻撃１", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち")
	helper_ee5b84d4(8)
end

--- Helper function.
local function helper_12d8c()
	monster.set_motion("避け攻撃", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち")
	helper_ee5b84d4(8)
end

--- Helper function.
local function helper_14820()
	local var0: f32 = 0
	local var1: f32 = 0
	local target: f32 = 0
	local var3: f32 = 0
	local target_3: f32 = 0
	local argc: s32 = 0
	local pos_y: f32 = 0
	local argc_2: s32 = 0
	var1 = monster.get_target_distance() or var1
	argc = monster.get_random(100) or argc
	if argc < 50 then
		var0 = 20.0
		monster.set_motion("ステップ右", -1, 2)
	else
		var0 = -20.0
		monster.set_motion("ステップ左", -1, 2)
	end
	helper_ee5b84d4(helper_9df6409a(10))
	target, var3, target_3 = helper_1324(var0, var1, target, var3, target_3)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(target, pos_y - 20.0, target_3, 4.0, 5.0)
	helper_cbe4d8e2()
	monster.stop_moving()
	monster.set_motion("立ち")
	argc_2 = monster.get_random(50) or argc_2
	while true do
		helper_82cb5588(4.0)
		if argc_2 > 50 then
			break
		else
			argc_2 = argc_2 + 1
			helper_b9fff8e1()
		end
	end
end

--- Helper function.
local function helper_15bfc()
	local var0: f32 = 0
	local life: f32 = 0
	local argc: s32 = 0
	local var3: f32 = 0
	life = 1.0
	var0 = monster.get_target_distance() or var0
	life = monster.get_life() or life
	if var0 < 150.0 and life > 0.25 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1.0, 0)
			helper_83e135e0(4.0)
			monster.set_motion("歩き", -1.0, 0)
			helper_e1c3e640(vm.f32(1.8), 4.0, 37.0, 45)
		else
			monster.set_motion("歩き", -1.0, 0)
			helper_83e135e0(4.0)
			monster.set_motion("走り", -1.0, 0)
			helper_e1c3e640(4.0, 8.0, 37.0, 30)
			argc = monster.get_random(100) or argc
			if argc < 85 then
				helper_12ed0()
			else
				helper_12d8c()
			end
		end
		monster.set_motion("立ち", -1, 0)
		return
	end
	argc = monster.get_random(100) or argc
	if argc < 40 then
		monster.set_motion("歩き", -1.0, 0)
		helper_83e135e0(4.0)
		helper_b765e6cd(4.0, 30)
		monster.set_motion("立ち", -1, 0)
		helper_57db7062(100.0, 50.0, 35.0, vm.f32(1.2), 30)
	else
		argc = monster.get_random(100) or argc
		if argc < 60 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var3 = -30.0
			else
				var3 = 30.0
			end
			monster.set_motion("歩き", -1.0, 0)
			helper_83e135e0(4.0)
			argc = monster.get_random(100) or argc
			monster.set_motion("歩き", -1.0, 0)
			helper_bc24(vm.f32(1.8), 4.0, var3, var0, 37.0, vm.i32(45 + argc))
			monster.set_motion("立ち", -1, 0)
			helper_57db7062(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.call_command(35, argc) -- retail: the handler rejects 1 arguments
				if argc < 30 then
					monster.set_motion("歩き", -1.0, 0)
					helper_83e135e0(8.0)
					helper_14820()
					monster.set_motion("立ち", -1, 0)
				else
					argc = monster.get_random(15) or argc
					monster.set_motion("歩き", -1.0, 0)
					helper_97d8f861(vm.f32(1.8), 3.0, var0, 360.0, 40.0, 37.0, vm.i32(45 + argc))
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(4.0)
				monster.set_motion("走り", -1.0, 0)
				helper_e1c3e640(4.0, 8.0, 37.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_13650()
	monster.set_motion("避け戻り", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 4)
	helper_b9fff8e1()
	monster.set_motion("避け戻り", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 4)
	helper_b9fff8e1()
	monster.set_motion("避け戻り", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち")
	helper_ee5b84d4(8)
end

--- Helper function.
local function helper_14544()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local pos_y_2: f32 = 0
	monster.set_motion("ステップ後", -1, 2)
	helper_ee5b84d4(helper_9df6409a(12))
	do
		local out1, _, out3 = monster.get_point_from_facing(3.1415927, 40.0)
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2 + -26.0, pos_z, 4.0, 5.0)
	helper_cbe4d8e2()
	monster.stop_moving()
end

--- Helper function.
local function helper_14dd0()
	local var0: f32 = 0
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 65 then
		argc = monster.get_random(100) or argc
		monster.set_motion("歩き", -1.0, 0)
		helper_83e135e0(8.0)
		var0 = monster.get_target_distance() or var0
		if var0 < 45.0 then
			monster.set_motion("走り", -1.0, 0)
			helper_e1c3e640(4.0, 4.0, 37.0, 30)
		elseif var0 > vm.f32(51.8) then
			monster.set_motion("歩き", -1.0, 0)
			helper_e1c3e640(vm.f32(1.8), 4.0, 37.0, 30)
		end
		argc = monster.get_random(100) or argc
		if argc < 85 then
			helper_12ed0()
		else
			helper_12d8c()
		end
		monster.set_motion("立ち", -1, 0)
		helper_ee5b84d4(9)
	else
		argc = monster.get_random(100) or argc
		if argc < 70 then
			argc = monster.get_random(100) or argc
			if argc < 30 then
				if var0 < 45.0 then
					monster.set_motion("歩き", -1.0, 0)
					helper_83e135e0(4.0)
					monster.set_motion("歩き", -1.0, 0)
					helper_e1c3e640(vm.f32(1.8), 4.0, 37.0, 45)
				else
					monster.set_motion("歩き", -1.0, 0)
					helper_83e135e0(4.0)
					monster.set_motion("走り", -1.0, 0)
					helper_e1c3e640(8.0, 4.0, 37.0, 30)
				end
				helper_83e135e0(8.0)
				helper_12ed0()
				monster.set_motion("立ち", -1, 0)
				helper_ee5b84d4(9)
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(4.0)
				helper_13650()
				monster.set_motion("立ち", -1, 0)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(8.0)
				helper_14544()
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(8.0)
				helper_14820()
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_16d38()
	local var0: f32 = 0
	local priority: s32 = 0
	while true do
		helper_b9fff8e1()
		helper_58087289()
		monster.get_life()
		var0 = monster.get_target_distance() or var0
		if var0 > 300.0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_11eac()
			continue
		end
		if var0 < 300.0 and var0 >= 145.0 then
			helper_15bfc()
		else
			helper_14dd0()
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
	if var17 < 37.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1.0, 0)
		helper_179581d3(var7, 3.0)
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 37.0)
		if var17 > 0.0 then
			helper_54469cb2(3.0, vm.f32(1.8), var7, var17, 37.0, 30)
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
				helper_549e2b35(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.8), 3.0, var5, var18, 37.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_179581d3(var19, 3.0)
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
	if argc < 75 then
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
			helper_179581d3(var7, 3.0)
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
					var1 = helper_bc24(vm.f32(1.8), 3.0, var20, var21, 37.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_179581d3(var23, 3.0)
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
					helper_cd4ea219(vm.f32(1.8), var7, 1000.0, 37.0, 60)
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
			helper_97d8f861(vm.f32(1.8), 3.0, var5, 360.0, 40.0, 37.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_11978()
	monster.set_motion("走り", -1, 0)
	helper_e1c3e640(4.0, 4.0, 37.0, 180)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_1a26c()
	local gekirin: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		helper_58087289()
		var1 = monster.get_target_distance() or var1
		if helper_a25c5b2e() == 0 then
			if var1 < 300.0 then
				helper_16d38()
			else
				monster.set_mask_flags(1, 1)
				monster.set_mask_flags(2, 1)
				helper_f064()
				monster.set_mask_flags(1, 0)
				monster.set_mask_flags(2, 0)
			end
		else
			var2 = helper_243517f2(var2)
			if var1 < var2 then
				if var1 < 145.0 then
					helper_65eb2b74(0)
					helper_16d38()
				else
					helper_11978()
				end
			end
		end
	else
		helper_16d38()
	end
end

--- Helper function.
local function helper_13014()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local pos_y_2: f32 = 0
	monster.set_motion("避け", -1, 2)
	monster.set_monster_attributes(32, 1)
	helper_ee5b84d4(helper_9df6409a(6))
	monster.set_monster_attributes(32, 0)
	do
		local out1, _, out3 = monster.get_point_from_facing(3.1415927, 30.0)
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2 + -26.0, pos_z, 5.0, 5.0)
	helper_cbe4d8e2()
	monster.stop_moving()
	monster.set_motion("避け攻撃", -1, 6)
	helper_ee5b84d4(4)
	monster.set_monster_attributes(32, 1)
	do
		local out1, _, out3 = monster.get_point_from_facing(0.0, 40.0)
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2 + -26.0, pos_z, 5.0, 5.0)
	helper_cbe4d8e2()
	monster.set_monster_attributes(32, 0)
	helper_ee5b84d4(8)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_entry_object(0, "bcol00")
	monster.register_entry_object(1, "dcol00")
	monster.register_entry_object(2, "dcol01")
	monster.register_damage_hit("通常攻撃", 5.0, "攻撃１", 0.3, 0.6, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 4.5, "避け攻撃", 0.3, 0.45, 1)
	monster.get_position_3()
	helper_3048()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		helper_1a26c()
	end
end

--- Reacts to a hit while greyed out, or to a hit that greys it out.
function script.on_status_hit()
	local var0: s32 = 0
	helper_5d37e9f4()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ後", -1, 6)
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
	monster.set_motion("ダメージ後", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_cbe4d8e2()
	helper_ee5b84d4(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	local var0: s32 = 0
	helper_fd16d93e()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(5.0, 0.05, 10)
	while true do
		var0 = 0
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			monster.set_action_status(1)
			helper_ee5b84d4(45)
			monster.set_action_status(0)
			monster.set_motion("起き上がり", -1, 6)
			while true do
				helper_b9fff8e1()
				var0 = monster.is_motion_finished() or var0
				if var0 ~= 0 then
					return 1
				end
			end
		end
		helper_b9fff8e1()
	end
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("ガード", -1, 4)
	monster.start_knockback(3.0, 0.0, 2)
	helper_ee5b84d4(8)
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local gekirin: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local pos_y_2: f32 = 0
	helper_49610f43()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	helper_442b9962()
	helper_b9fff8e1()
	helper_93495fdf()
	helper_b9fff8e1()
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin == 0 then
		var1 = 80
	else
		var1 = 40
	end
	argc = monster.get_random(100) or argc
	if argc < var1 then
		helper_13014()
	else
		monster.set_motion("避け", -1, 6)
		monster.set_monster_attributes(32, 1)
		helper_ee5b84d4(helper_9df6409a(6))
		monster.set_monster_attributes(32, 0)
		do
			local out1, _, out3 = monster.get_point_from_facing(3.1415927, 30.0)
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.get_position_3()
			pos_y_2 = out2 or pos_y_2
		end
		monster.move_toward_position(pos_x, pos_y_2 + -26.0, pos_z, 5.0, 5.0)
		helper_cbe4d8e2()
		monster.stop_moving()
		monster.set_motion("避け戻り", -1, 6)
		do
			local out1, _, out3 = monster.get_point_from_facing(3.1415927, 20.0)
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.get_position_3()
			pos_y_2 = out2 or pos_y_2
		end
		monster.move_toward_position(pos_x, pos_y_2 + -26.0, pos_z, 5.0, 5.0)
		helper_cbe4d8e2()
		monster.stop_moving()
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local argc: s32 = 0
	local pos_y_2: f32 = 0
	helper_49610f43()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	helper_b9fff8e1()
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("ステップ左", -1, 2)
		do
			local out1, _, out3 = monster.get_point_from_facing(1.5707964, 20.0)
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
	else
		monster.set_motion("ステップ右", -1, 2)
		do
			local out1, _, out3 = monster.get_point_from_facing(-1.5707964, 20.0)
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
	end
	monster.set_monster_attributes(32, 1)
	helper_ee5b84d4(helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2 + -26.0, pos_z, 4.0, 5.0)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 4)
	monster.stop_moving()
	monster.set_mask_flags(1, 0)
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
