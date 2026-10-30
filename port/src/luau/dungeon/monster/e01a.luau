--!strict
-- dungeon/monster/e01a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
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
local helper_57db7062 = require("@lib/monster/helper_57db7062")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_97d8f861 = require("@lib/monster/helper_97d8f861")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ade2dbe2 = require("@lib/monster/helper_ade2dbe2")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b765e6cd = require("@lib/monster/helper_b765e6cd")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_ba87ea88 = require("@lib/monster/helper_ba87ea88")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_cd4ea219 = require("@lib/monster/helper_cd4ea219")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_e8739558 = require("@lib/monster/helper_e8739558")
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
local function helper_138d0()
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
		local _ = helper_bfbcfc9f(vm.f32(1.85), vm.f32(4.8), var3, var4, 38.0, 30)
		helper_83e135e0(vm.f32(4.8))
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(38.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_16e48()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 75 then
		monster.set_motion("歩き", -1, 0)
		helper_e1c3e640(vm.f32(1.85), vm.f32(4.8), 110.0, 45)
	else
		argc = monster.get_random(100) or argc
		if argc < 10 then
			monster.set_motion("歩き", -1, 0)
			helper_97d8f861(vm.f32(1.85), vm.f32(4.8), 30.0, 180.0, 30.0, 110.0, 25)
		end
	end
end

--- Helper function.
local function helper_13158()
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	helper_56d63eae()
end

--- Helper function.
local function helper_13008()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	helper_b765e6cd(vm.f32(4.8), helper_9df6409a(11))
	helper_56d63eae()
end

--- Helper function.
local function helper_1229c()
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
	monster.set_monster_attributes(32, 1)
	helper_4a39d2ab(vm.f32(0.3), -1.0)
	monster.move_toward_position(target, target_2, target_3, 2.96, 2.96)
	helper_4a39d2ab(vm.f32(0.6), -1.0)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_56d63eae()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_12a8c(move_speed: f32)
	local pos_x: f32 = 0
	local var3: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local pos_y_2: f32 = 0
	monster.set_monster_attributes(32, 1)
	var5 = monster.get_target_distance() or var5
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var7 = monster.get_random_whole_number(10.0) or var7
	var5 = vm.f32(var5 + vm.f32(30.0 + var7))
	pos_x, var3, pos_z = helper_125e5305(0.0, var5, pos_x, var3, pos_z)
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	helper_c3e8ae39(helper_9df6409a(6))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2, pos_z, move_speed, move_speed + 1.0)
	helper_c3e8ae39(helper_9df6409a(3))
	monster.set_monster_attributes(32, 0)
	helper_c3e8ae39(helper_9df6409a(17))
	monster.stop_moving()
	helper_56d63eae()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Helper function.
local function helper_16058()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 90 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(vm.f32(4.8))
			monster.set_motion("走り", -1, 0)
			helper_e1c3e640(4.0, vm.f32(4.8), 38.0, 30)
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(vm.f32(4.8))
			helper_13158()
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(3)
		else
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(vm.f32(4.8))
			monster.set_motion("走り", -1, 0)
			helper_e1c3e640(4.0, vm.f32(4.8), 38.0, 30)
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(vm.f32(4.8))
			helper_13008()
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(3)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 90 then
			argc = monster.get_random(100) or argc
			var1 = monster.get_random_whole_number(30.0) or var1
			var2 = monster.get_random_whole_number(30.0) or var2
			var2 = vm.f32(var2 + 55.0)
			if argc < 50 then
				var1 = vm.f32(-var1 - 30.0)
			else
				var1 = vm.f32(var1 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			helper_bfbcfc9f(vm.f32(1.85), vm.f32(4.8), var1, var2, 38.0, 30)
			helper_83e135e0(vm.f32(4.8))
		else
			argc = monster.get_random(100) or argc
			if argc < 10 then
				for var3 = 0, 2 do
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(vm.f32(4.8))
					helper_1229c()
					monster.set_motion("立ち", -1, 0)
					helper_e62edeb2(38.0, 45.0, 15)
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
				helper_12a8c(vm.f32(2.22))
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
			end
		end
	end
end

--- Helper function.
local function helper_1375c()
	monster.set_motion("攻撃１", -1, 4)
	helper_c3e8ae39(helper_9df6409a(18))
	monster.set_motion("攻撃２", -1, 2)
	helper_56d63eae()
end

--- Helper function.
local function helper_1326c()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	helper_c3e8ae39(helper_9df6409a(22))
	monster.set_motion("攻撃２", -1, 2)
	helper_56d63eae()
end

--- Helper function.
local function helper_14fe0()
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 30 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1, 0)
				helper_e1c3e640(vm.f32(1.85), vm.f32(4.8), 38.0, 30)
				helper_e8739558(vm.f32(4.8), 20.0, 5)
				helper_13158()
				monster.set_motion("立ち", -1, 0)
				helper_c3e8ae39(3)
			else
				argc = monster.get_random(100) or argc
				if argc < 85 then
					monster.set_motion("歩き", -1, 0)
					helper_e1c3e640(vm.f32(1.85), vm.f32(4.8), 38.0, 30)
					helper_83e135e0(vm.f32(4.8))
					helper_13008()
					monster.set_motion("立ち", -1, 0)
					helper_c3e8ae39(3)
				else
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(vm.f32(4.8))
					helper_1375c()
					monster.set_motion("立ち", -1, 0)
					helper_c3e8ae39(3)
				end
			end
		else
			monster.set_motion("歩き", -1, 0)
			helper_e1c3e640(vm.f32(1.85), vm.f32(4.8), 38.0, 30)
			helper_83e135e0(vm.f32(4.8))
			helper_1326c()
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(3)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 10 then
			argc = monster.get_random(100) or argc
			if argc < 60 then
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
				helper_12a8c(vm.f32(2.22))
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_motion("走り", -1, 0)
					helper_e1c3e640(4.0, vm.f32(4.8), 38.0, 30)
					helper_13008()
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
				helper_1229c()
				monster.set_motion("立ち", -1, 0)
			end
		else
			monster.set_motion("歩き", -1, 0)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var2 = 270.0
				var3 = 180.0
			else
				var2 = 90.0
				var3 = 270.0
			end
			monster.set_motion("歩き", -1, 0)
			helper_bfbcfc9f(vm.f32(1.85), vm.f32(4.8), var2, 76.0, 38.0, 30)
			helper_bfbcfc9f(vm.f32(1.85), vm.f32(4.8), var3, 76.0, 38.0, 30)
			helper_83e135e0(vm.f32(4.8))
			helper_13008()
		end
	end
end

--- Helper function.
local function helper_17118()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		helper_ade2dbe2()
		var3 = monster.get_target_distance() or var3
		if var3 > 250.0 then
			vm.wait()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_138d0()
			continue
		end
		if var3 < 250.0 and var3 >= 170.0 then
			helper_16e48()
		elseif var3 < 170.0 and var3 >= 110.0 then
			helper_16058()
		else
			helper_14fe0()
		end
		vm.wait()
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
	if var17 < 38.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1.0, 0)
		helper_179581d3(var7, vm.f32(4.8))
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 38.0)
		if var17 > 0.0 then
			helper_54469cb2(vm.f32(4.8), vm.f32(1.85), var7, var17, 38.0, 30)
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
				helper_549e2b35(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.85), vm.f32(4.8), var5, var18, 38.0, 60)
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
					var1 = helper_bfbcfc9f(vm.f32(1.85), vm.f32(4.8), var20, var21, 38.0, 60)
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
					helper_cd4ea219(vm.f32(1.85), var7, 1000.0, 38.0, 60)
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
			helper_97d8f861(vm.f32(1.85), vm.f32(4.8), var5, 360.0, 40.0, 38.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_194ec()
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(4.8))
	monster.set_motion("走り", -1, 0)
	helper_e1c3e640(4.0, vm.f32(4.8), 38.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_13d80()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	while true do
		vm.wait()
		var3 = monster.get_target_distance() or var3
		if var3 > 250.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_138d0()
			continue
		end
		if var3 < 110.0 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				argc = monster.get_random(100) or argc
				if argc < 30 then
					monster.set_motion("歩き", -1, 0)
					helper_e1c3e640(vm.f32(1.85), vm.f32(4.8), 38.0, 60)
					helper_e8739558(vm.f32(4.8), 20.0, 15)
					helper_13158()
					monster.set_motion("立ち", -1, 0)
					helper_c3e8ae39(2)
				else
					argc = monster.get_random(100) or argc
					if argc < 85 then
						monster.set_motion("歩き", -1, 0)
						helper_e1c3e640(vm.f32(1.85), vm.f32(4.8), 38.0, 60)
						helper_83e135e0(vm.f32(4.8))
						helper_13008()
						monster.set_motion("立ち", -1, 0)
						helper_c3e8ae39(2)
					else
						monster.set_motion("歩き", -1, 0)
						helper_e1c3e640(vm.f32(1.85), vm.f32(4.8), 38.0, 60)
						monster.set_motion("歩き", -1, 0)
						helper_83e135e0(vm.f32(4.8))
						helper_1375c()
						monster.set_motion("立ち", -1, 0)
						helper_c3e8ae39(2)
					end
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_e1c3e640(vm.f32(1.85), vm.f32(4.8), 38.0, 60)
				helper_83e135e0(vm.f32(4.8))
				helper_1326c()
				monster.set_motion("立ち", -1, 0)
				helper_c3e8ae39(2)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 70 then
				argc = monster.get_random(100) or argc
				if argc < 30 then
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(vm.f32(4.8))
					monster.set_motion("走り", -1, 0)
					helper_e1c3e640(4.0, vm.f32(4.8), 38.0, 60)
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(vm.f32(4.8))
					helper_13158()
					monster.set_motion("立ち", -1, 0)
					helper_c3e8ae39(3)
				else
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(vm.f32(4.8))
					monster.set_motion("走り", -1, 0)
					helper_e1c3e640(4.0, vm.f32(4.8), 38.0, 60)
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(vm.f32(4.8))
					helper_13008()
					monster.set_motion("立ち", -1, 0)
					helper_c3e8ae39(3)
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
				monster.set_motion("走り", -1, 0)
				helper_e1c3e640(4.0, vm.f32(4.8), 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_196fc()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		helper_ade2dbe2()
		var0 = monster.get_target_distance() or var0
		if helper_a25c5b2e() == 0 then
			if var0 < 250.0 then
				helper_17118()
			else
				helper_f064()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 170.0 then
					helper_65eb2b74(0)
					helper_17118()
				else
					helper_194ec()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_13d80()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("Ｍ連撃１", 3.0, "攻撃１", 0.36, 0.5, 0, 1)
	monster.register_damage_hit("Ｍ連撃１", 4.0, "攻撃２", 0.1, 0.5, 0, 1)
	monster.add_sword_trail(0, "攻撃１", 0.25, 0.27, "dcol0", "dcol1", 77, 20, 40)
	monster.add_sword_trail(0, "攻撃２", 0.3, 0.32, "dcol0", "dcol1", 77, 20, 40)
	helper_3048()
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 3 then
		monster.set_clip_distance(99999.9)
	end
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_b9fff8e1()
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
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_fd16d93e()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_56d63eae()
	monster.set_action_status(1)
	helper_c3e8ae39(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	local argc: s32 = 0
	helper_ab4b367a()
	argc = monster.get_random(100) or argc
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	helper_56d63eae()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_c3e8ae39(8)
	if argc < 30 then
		helper_13158()
		monster.set_motion("立ち", -1, 0)
		helper_c3e8ae39(3)
	else
		monster.set_motion("ガードout", -1, 2)
		helper_56d63eae()
	end
	monster.set_motion("立ち")
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local argc: s32 = 0
	helper_49610f43()
	argc = monster.get_random(20) or argc
	if argc < 20 then
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(vm.f32(4.8))
		helper_1229c()
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("ステップ後", -1, 0)
		helper_12a8c(vm.f32(2.775))
	end
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.set_motion("ガードin", -1, 6)
	helper_56d63eae()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_c3e8ae39(8)
	monster.set_motion("ガードout", -1, 2)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	local var0: f32 = 0
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 10 then
		monster.stop_moving()
		helper_442b9962()
		monster.set_mask_flags(1, 1)
		monster.set_mask_flags(2, 1)
		monster.set_monster_attributes(32, 1)
		monster.set_motion("死に", -1, 2)
		helper_56d63eae()
		var0 = monster.get_random_whole_number(0.3) or var0
		var0 = vm.f32(var0 + vm.f32(0.2))
		monster.set_life(var0)
		helper_c3e8ae39(45)
		monster.set_motion("起き上がり", -1, 2)
		helper_56d63eae()
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
		monster.set_monster_attributes(32, 0)
		return
	end
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
	helper_ba87ea88()
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
