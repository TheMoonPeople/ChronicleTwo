--!strict
-- dungeon/monster/e207a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_211db10d = require("@lib/monster/helper_211db10d")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_54469cb2 = require("@lib/monster/helper_54469cb2")
local helper_549e2b35 = require("@lib/monster/helper_549e2b35")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57db7062 = require("@lib/monster/helper_57db7062")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_6eaf9360 = require("@lib/monster/helper_6eaf9360")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8566bb6e = require("@lib/monster/helper_8566bb6e")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_97d8f861 = require("@lib/monster/helper_97d8f861")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_ba87ea88 = require("@lib/monster/helper_ba87ea88")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_cd4ea219 = require("@lib/monster/helper_cd4ea219")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d742309a = require("@lib/monster/helper_d742309a")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")
local helper_f3e7a0aa = require("@lib/monster/helper_f3e7a0aa")
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
local function helper_11abc()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: s32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	var0 = 0
	var2 = helper_6eaf9360(0, 180.0)
	if var2 == 1 then
		var0 = vm.i32(bit32.bor(var0, 4))
	end
	if var2 == 0 then
		var0 = vm.i32(bit32.bor(var0, 8))
	end
	var1 = monster.get_target_distance() or var1
	if var1 <= 320.0 then
		var0 = vm.i32(bit32.bor(var0, 1))
	end
	if var1 > 320.0 then
		var0 = vm.i32(bit32.bor(var0, 2))
		monster.set_variable(0, 0)
	end
	if helper_6eaf9360(0, 60.0) ~= 0 and var1 <= 40.0 then
		var0 = vm.i32(bit32.bor(var0, 16))
	end
	priority = monster.get_priority() or priority
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if priority <= 3 or gekirin == 0 then
		var0 = vm.i32(bit32.bor(var0, 32))
	end
	return var0
end

--- Helper function.
local function helper_12ee0()
	local var0: f32 = 0
	var0 = monster.get_target_distance() or var0
	if var0 < 30.0 then
		monster.set_motion("攻撃１", -1, 2)
	else
		monster.set_motion("攻撃２", -1, 2)
	end
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(15)
end

--- Helper function.
local function helper_127c0()
	local argc: s32 = 0
	local gekirin: s32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	argc = monster.get_random(90) or argc
	argc = vm.i32(argc + 150)
	while true do
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			helper_f3e7a0aa()
		end
		var2 = monster.get_target_distance() or var2
		if var2 <= 320.0 then
			break
		else
			monster.set_motion("歩き")
			do
				local out1, out2, out3 = monster.get_point_from_facing(0.0, 3.0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			helper_82cb5588(vm.f32(0.024543693))
			monster.move_toward_position(pos_x, pos_y, pos_z, 0.9, 1.0)
			argc = vm.i32(argc - 1)
			if argc < 0 then
				break
			else
				helper_b9fff8e1()
			end
		end
	end
end

--- Helper function.
local function helper_13160(arg0: any)
	local var1: f32 = 0
	while true do
		var1 = monster.get_target_distance() or var1
		if var1 <= 320.0 then
			break
		else
			arg0 = vm.wrap(arg0 - 1)
			if arg0 < 0 then
				break
			else
				helper_b9fff8e1()
			end
		end
	end
end

--- Helper function.
local function helper_12c4c()
	local var1: f32 = 0
	local var3: f32 = 0
	monster.set_motion("歩き")
	while true do
		helper_82cb5588(vm.f32(0.049087387))
		do
			local _, out2, _ = monster.get_rotation()
			var1 = out2 or var1
		end
		var3 = monster.get_target_angle() or var3
		if helper_8971d3b6(var3, var1, vm.f32(0.049087387)) == 0 then
			helper_442b9962()
			break
		else
			helper_b9fff8e1()
		end
	end
end

--- Helper function.
local function helper_12094(arg0: s32)
	local var1: f32 = 0
	local value: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	while true do
		if helper_6eaf9360(0, 180.0) == 0 then
			return 1
		end
		var1 = monster.get_target_distance() or var1
		if bit32.band(arg0, 32) ~= 0 then
			if var1 <= 40.0 then
				return 0
			end
		elseif var1 <= 160.0 then
			return 0
		end
		value = monster.get_variable(0) or value
		if value == 0 then
			var3 = 100
		else
			var3 = 1
		end
		argc = monster.get_random(100) or argc
		if (if argc < var3 and var1 < 120.0 then helper_6eaf9360(0, 60.0) else 0) ~= 0 then
			monster.set_variable(0, 1)
			monster.set_variable(1, 1)
			return 0
		end
		if var1 > 320.0 then
			return 1
		end
		monster.set_motion("走り")
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 3.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		helper_82cb5588(vm.f32(0.049087387))
		monster.move_toward_position(pos_x, pos_y, pos_z, 1.8, 1.0)
		helper_b9fff8e1()
	end
	return 0
end

--- Helper function.
local function helper_1333c(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local value: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local argc_3: s32 = 0
	if (if bit32.band(arg0, 16) ~= 0 then bit32.band(arg0, 32) else 0) ~= 0 then
		helper_12ee0()
		return
	end
	if bit32.band(arg0, 2) ~= 0 then
		if helper_6eaf9360(0, 60.0) ~= 0 then
			argc = monster.get_random(400) or argc
			if argc < 1 then
				helper_127c0()
				argc = monster.get_random(60) or argc
				argc = vm.i32(argc + 60)
				monster.set_motion("立ち")
				helper_13160(argc)
			end
		else
			argc_2 = monster.get_random(100) or argc_2
			if argc_2 < 2 then
				helper_12c4c()
				argc_2 = monster.get_random(60) or argc_2
				argc_2 = vm.i32(argc_2 + 60)
				monster.set_motion("立ち")
				helper_13160(argc_2)
			end
		end
		return
	end
	if (if bit32.band(arg0, 1) ~= 0 then bit32.band(arg0, 8) else 0) ~= 0 then
		helper_12c4c()
		return
	end
	if (if bit32.band(arg0, 1) ~= 0 then bit32.band(arg0, 4) else 0) ~= 0 then
		if bit32.band(arg0, 32) ~= 0 then
			value = monster.get_variable(1) or value
			if value == 1 then
				var4 = monster.get_target_distance() or var4
				do
					local out1, out2, out3 = monster.get_target_position()
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				monster.move_toward_position(var5, var6, var7, var4 / 12.0, var4 / 12.0)
				monster.set_motion("攻撃１", -1, 2)
				helper_82cb5588(vm.f32(0.09817477))
				helper_8566bb6e(18)
				helper_cbe4d8e2()
				monster.set_motion("立ち")
				monster.set_variable(1, 0)
				return
			end
		end
		if helper_12094(arg0) ~= 0 then
			return
		else
			helper_12c4c()
		end
		if bit32.band(arg0, 32) == 0 then
			argc_3 = monster.get_random(100) or argc_3
			if argc_3 < 2 then
				helper_12c4c()
			end
		end
		return
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
	if var17 < 30.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1.0, 0)
		helper_179581d3(var7, vm.f32(2.8))
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 30.0)
		if var17 > 0.0 then
			helper_54469cb2(vm.f32(2.8), vm.f32(1.8), var7, var17, 30.0, 30)
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
				helper_549e2b35(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.8), vm.f32(2.8), var5, var18, 30.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_179581d3(var19, vm.f32(2.8))
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
	if argc < 70 then
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
			helper_179581d3(var7, vm.f32(2.8))
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
					var1 = helper_bfbcfc9f(vm.f32(1.8), vm.f32(2.8), var20, var21, 30.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_179581d3(var23, vm.f32(2.8))
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
					helper_cd4ea219(vm.f32(1.8), var7, 1000.0, 30.0, 60)
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
			helper_97d8f861(vm.f32(1.8), vm.f32(2.8), var5, 360.0, 40.0, 30.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_15950()
	monster.set_motion("走り", -1, 0)
	helper_e1c3e640(vm.f32(4.8), 4.0, 30.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_15ac4()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		helper_f3e7a0aa()
	end
	var0 = monster.get_target_distance() or var0
	if helper_a25c5b2e() == 0 then
		if var0 < 200.0 then
			monster.set_motion("立ち")
			var4 = helper_11abc()
			helper_1333c(var4)
		else
			helper_efa8()
		end
	else
		var1 = helper_243517f2(var1)
		if var0 < var1 then
			if var0 < 200.0 then
				helper_65eb2b74(0)
				monster.set_motion("立ち")
				var5 = helper_11abc()
				helper_1333c(var5)
			else
				helper_15950()
			end
		else
			helper_65eb2b74(0)
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃２", 0.2, 0.8, 0)
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃１", 0.4, 0.8, 1)
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃１", 0.4, 0.8, 2)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "避け攻撃", 0.25, 0.5, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "避け攻撃", 0.25, 0.5, 2)
	helper_2f8c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_b9fff8e1()
		helper_15ac4()
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
	helper_ee5b84d4(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_ee5b84d4(8)
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local gekirin: s32 = 0
	local var5: s32 = 0
	local argc: s32 = 0
	helper_49610f43()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("避け", -1, 2)
	var0 = monster.get_target_angle() or var0
	monster.set_rotation(0.0, var0, 0.0)
	monster.set_invulnerable_time(6)
	helper_ee5b84d4(6)
	do
		local out1, out2, out3 = monster.get_point_from_facing(3.1415927, 35.0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.move_toward_position(pos_x, pos_y, pos_z, 5.0, 5.0)
	helper_cbe4d8e2()
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin == 0 then
		var5 = 80
	else
		var5 = 30
	end
	argc = monster.get_random(100) or argc
	if argc < var5 then
		monster.set_motion("避け攻撃", -1, 6)
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 30.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.move_toward_position(pos_x, pos_y, pos_z, 5.0, 5.0)
		helper_cbe4d8e2()
	else
		monster.set_motion("避け戻り", -1, 6)
		helper_cbe4d8e2()
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local argc: s32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	monster.set_rotation(0.0, var0, 0.0)
	helper_b9fff8e1()
	argc = monster.get_random(100) or argc
	if argc > 50 then
		monster.set_motion("ダメージ左", -1, 2)
		do
			local out1, out2, out3 = monster.get_point_from_facing(1.5707964, 20)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.move_toward_position(pos_x, pos_y, pos_z, 3.0, 5.0)
	else
		monster.set_motion("ダメージ右", -1, 2)
		do
			local out1, out2, out3 = monster.get_point_from_facing(-1.5707964, 20)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.move_toward_position(pos_x, pos_y, pos_z, 3.0, 5.0)
	end
	helper_8566bb6e(15)
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
	helper_d742309a()
	monster.set_motion("じたばた", -1, 4)
	helper_211db10d()
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
