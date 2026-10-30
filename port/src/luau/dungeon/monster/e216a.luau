--!strict
-- dungeon/monster/e216a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0a773d51 = require("@lib/monster/helper_0a773d51")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_20ea05b8 = require("@lib/monster/helper_20ea05b8")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_37e24389 = require("@lib/monster/helper_37e24389")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_4a39d2ab = require("@lib/monster/helper_4a39d2ab")
local helper_54469cb2 = require("@lib/monster/helper_54469cb2")
local helper_549e2b35 = require("@lib/monster/helper_549e2b35")
local helper_56a4eab4 = require("@lib/monster/helper_56a4eab4")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57db7062 = require("@lib/monster/helper_57db7062")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_97d8f861 = require("@lib/monster/helper_97d8f861")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_cd4ea219 = require("@lib/monster/helper_cd4ea219")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d375874f = require("@lib/monster/helper_d375874f")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_e8739558 = require("@lib/monster/helper_e8739558")
local helper_fd16d93e = require("@lib/monster/helper_fd16d93e")

--- Helper function.
local function helper_2f8c()
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
local function helper_16224()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 70.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = helper_bfbcfc9f(vm.f32(1.8), 4.0, var3, var4, 38.0, 30)
		helper_83e135e0(4.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(38.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_15cc4()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1.0, 0)
			helper_83e135e0(4.0)
			monster.set_motion("歩き", -1.0, 0)
			helper_e1c3e640(vm.f32(1.8), 4.0, 70.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1.0, 0)
			helper_83e135e0(4.0)
			monster.set_motion("走り", -1.0, 0)
			helper_e1c3e640(5.0, 4.0, 38.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(70.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_11b08()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	helper_4a39d2ab(vm.f32(0.372), vm.f32(0.02))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol01")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	monster.create_effect_1("ねばねばＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var4, var5, var6)
	monster.set_effect_value(-1, 0, attack)
	helper_cbe4d8e2()
end

--- Helper function.
local function helper_13188()
	local argc: s32 = 0
	local target: f32 = 0
	local var2: f32 = 0
	local target_3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local pos_y: f32 = 0
	var4 = monster.get_target_distance() or var4
	monster.set_monster_attributes(32, 1)
	monster.reset_motion()
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("ステップ右", -1, 6)
		var5 = 30.0
	else
		monster.set_motion("ステップ左", -1, 6)
		var5 = -30.0
	end
	target, var2, target_3 = helper_125e5305(var5, var4, target, var2, target_3)
	helper_20ea05b8(7)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(target, pos_y - 20.0, target_3, 2.8799999, 2.8799999)
	helper_20ea05b8(3)
	helper_20ea05b8(6)
	monster.set_monster_attributes(32, 0)
	helper_cbe4d8e2()
	monster.stop_moving()
end

--- Helper function.
local function helper_152d4()
	local var0: f32 = 0
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 45 then
		monster.set_motion("歩き", -1.0, 0)
		helper_83e135e0(4.0)
		helper_11b08()
		monster.set_motion("立ち", -1, 0)
		helper_20ea05b8(8)
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(4.0)
				monster.set_motion("歩き", -1.0, 0)
				helper_e1c3e640(vm.f32(1.8), 4.0, 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(4.0)
				monster.set_motion("走り", -1.0, 0)
				helper_e1c3e640(5.0, 4.0, 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 30 then
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(4.0)
				helper_13188()
				monster.set_motion("立ち", -1, 0)
			else
				var0 = monster.get_target_distance() or var0
				argc = monster.get_random(15) or argc
				monster.set_motion("歩き", -1.0, 0)
				helper_97d8f861(vm.f32(1.8), 4.0, var0, 360.0, 40.0, 38.0, vm.i32(45 + argc))
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
	helper_b9fff8e1()
end

--- Helper function.
local function helper_12eb0()
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１in", -1, 2)
	helper_cbe4d8e2()
	monster.create_effect_1("ヒマーラ回転攻撃")
	monster.set_effect_value(-1, 0, attack)
	monster.set_motion("攻撃１", -1, 4)
	helper_20ea05b8(30)
	monster.set_motion("攻撃１out", -1, 6)
	helper_cbe4d8e2()
end

--- Helper function.
local function helper_14758()
	local argc: s32 = 0
	local life: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	life = 0.0
	life = monster.get_life() or life
	argc = monster.get_random(100) or argc
	if argc < 45 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_motion("歩き", -1.0, 0)
			helper_83e135e0(4.0)
			monster.set_motion("歩き", -1.0, 0)
			helper_e1c3e640(vm.f32(1.8), 4.0, 58.0, 30)
			helper_12eb0()
			monster.set_motion("立ち", -1, 0)
			helper_20ea05b8(8)
		else
			monster.set_motion("歩き", -1.0, 0)
			helper_83e135e0(4.0)
			helper_11b08()
			monster.set_motion("立ち", -1, 0)
			helper_20ea05b8(8)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			if life > vm.f32(0.23) then
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(4.0)
				monster.set_motion("歩き", -1.0, 0)
				helper_e1c3e640(vm.f32(1.8), 4.0, 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(4.0)
				helper_13188()
				monster.set_motion("立ち", -1, 0)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var3 = -30.0
			else
				var3 = 30.0
			end
			argc = monster.get_random(100) or argc
			monster.set_motion("歩き", -1.0, 0)
			helper_bfbcfc9f(vm.f32(1.8), 4.0, var3, var2, 38.0, vm.i32(45 + argc))
			monster.set_motion("立ち", -1, 0)
			helper_e62edeb2(38.0, 45.0, 30)
		end
	end
	helper_b9fff8e1()
end

--- Helper function.
local function helper_16734()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		helper_37e24389()
		var3 = monster.get_target_distance() or var3
		if var3 > 310.0 then
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin <= 0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_16224()
			continue
		end
		if var3 < 310.0 and var3 >= 200.0 then
			helper_15cc4()
		elseif var3 < 200.0 and var3 >= 70.0 then
			helper_152d4()
		else
			helper_14758()
		end
		helper_b9fff8e1()
	end
end

--- Helper function.
local function helper_efa8()
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
		helper_179581d3(var7, 4.0)
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 38.0)
		if var17 > 0.0 then
			helper_54469cb2(4.0, vm.f32(1.4), var7, var17, 38.0, 30)
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
				helper_549e2b35(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.4), 4.0, var5, var18, 38.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_179581d3(var19, 4.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_57db7062(100.0, 50.0, 33.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.get_random(100, argc)
			return
		end
	end
	argc = monster.get_random(100) or argc
	if argc < 65 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			helper_57db7062(100.0, 50.0, 33.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			helper_179581d3(var7, 4.0)
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
					var1 = helper_bfbcfc9f(vm.f32(1.4), 4.0, var20, var21, 38.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_179581d3(var23, 4.0)
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
					helper_cd4ea219(vm.f32(1.4), var7, 1000.0, 38.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_57db7062(100.0, 50.0, 33.0, vm.f32(1.2), 30)
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
			helper_97d8f861(vm.f32(1.4), 4.0, var5, 360.0, 40.0, 38.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_185b8()
	local argc: s32 = 0
	monster.set_motion("歩き", -1.0, 0)
	helper_83e135e0(4.0)
	monster.set_motion("走り", -1, 0)
	helper_e1c3e640(5.0, 4.0, 70.0, 60)
	monster.set_motion("立ち", -1, 0)
	argc = monster.get_random(100) or argc
	if argc < 70 then
		helper_11b08()
	end
end

--- Helper function.
local function helper_13708()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	print("start gekirn----------------------\n")
	while true do
		helper_b9fff8e1()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(vm.f32(1.8))
				monster.set_motion("歩き", -1.0, 0)
				helper_cd4ea219(vm.f32(1.8), 180.0, 200.0, 38.0, 90)
				monster.set_motion("立ち", -1, 0)
			else
				helper_56a4eab4(30)
			end
			continue
		end
		if var3 < 310.0 and var3 >= 200.0 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1.0, 0)
				helper_e8739558(8.0, 30.0, 15)
				helper_11b08()
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_e1c3e640(vm.f32(3.6), 4.0, 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			var7 = monster.get_target_distance() or var7
			if var7 < 70.0 then
				argc = monster.get_random(100) or argc
				if argc < 60 then
					monster.set_motion("歩き", -1.0, 0)
					helper_83e135e0(4.0)
					helper_11b08()
				end
			end
			argc = monster.get_random(100) or argc
			if argc < 65 then
				argc = monster.get_random(100) or argc
				if argc < 40 then
					monster.set_motion("歩き", -1.0, 0)
					helper_83e135e0(4.0)
					helper_11b08()
				else
					monster.set_motion("歩き", -1.0, 0)
					helper_83e135e0(4.0)
					helper_12eb0()
				end
			else
				argc = monster.get_random(100) or argc
				if argc < 70 then
					monster.set_motion("歩き", -1.0, 0)
					helper_83e135e0(4.0)
					var8 = monster.get_target_angle() or var8
					helper_cd4ea219(vm.f32(2.6999998), var8, 100.0, 38.0, 45)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1.0, 0)
					helper_83e135e0(4.0)
					monster.set_motion("歩き", -1.0, 0)
					helper_e1c3e640(vm.f32(2.6999998), 4.0, 38.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
		monster.set_motion("走り", -1, 0)
		helper_e1c3e640(5.0, 4.0, 38.0, 60)
		helper_b9fff8e1()
	end
end

--- Helper function.
local function helper_18834()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		helper_37e24389()
		var0 = monster.get_target_distance() or var0
		if helper_a25c5b2e() == 0 then
			if var0 < 310.0 then
				helper_16734()
			else
				helper_efa8()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 200.0 then
					helper_65eb2b74(0)
					helper_16734()
				else
					helper_185b8()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_13708()
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
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("ヒマーラ回転攻撃", get_not_used_texb) or var1
		var2 = monster.load_effect_script("ねばねばＬ", get_not_used_texb) or var2
		var3 = monster.load_effect_script("ねばねばＨ", get_not_used_texb) or var3
		if (if (if var1 ~= 0 then 1 else var2) ~= 0 then 1 else var3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	helper_2f8c()
	helper_0a773d51(150)
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.stop_sound(5)
	while true do
		helper_b9fff8e1()
		helper_18834()
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
	helper_20ea05b8(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_fd16d93e()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_cbe4d8e2()
	monster.set_action_status(1)
	helper_20ea05b8(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("ガードin", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_20ea05b8(8)
	monster.set_motion("ガードout", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち")
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(4.0)
	helper_13188()
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(4.0)
	helper_13188()
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
	helper_d375874f()
	monster.stop_moving()
	monster.end_throw()
	helper_20ea05b8(10)
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
