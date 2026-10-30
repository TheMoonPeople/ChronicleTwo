--!strict
-- dungeon/monster/e209a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0a773d51 = require("@lib/monster/helper_0a773d51")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_54469cb2 = require("@lib/monster/helper_54469cb2")
local helper_549e2b35 = require("@lib/monster/helper_549e2b35")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57db7062 = require("@lib/monster/helper_57db7062")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_661d392d = require("@lib/monster/helper_661d392d")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_97d8f861 = require("@lib/monster/helper_97d8f861")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_cd4ea219 = require("@lib/monster/helper_cd4ea219")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")
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
local function helper_113a8(arg0: any)
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		helper_b9fff8e1()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(0.75)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_11678()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_113a8(monster_id)
	end
end

--- Helper function.
local function helper_11d50()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: s32 = 0
	var0 = 0
	var2 = helper_661d392d(0, 200.0)
	if var2 == 1 then
		var0 = vm.i32(bit32.bor(var0, 4))
	end
	if var2 == 0 then
		var0 = vm.i32(bit32.bor(var0, 8))
	end
	var1 = monster.get_target_distance() or var1
	if var1 <= 240.0 then
		var0 = vm.i32(bit32.bor(var0, 1))
	end
	if var1 > 240.0 then
		var0 = vm.i32(bit32.bor(var0, 2))
	end
	if helper_661d392d(0, 45.0) ~= 0 and var1 <= 50.0 then
		var0 = vm.i32(bit32.bor(var0, 16))
	end
	return var0
end

--- Helper function.
local function helper_128f8()
	local var0: f32 = 0
	var0 = monster.get_target_distance() or var0
	if var0 < 30.0 then
		monster.reset_motion()
		monster.set_motion("攻撃１", -1, 6)
	else
		monster.reset_motion()
		monster.set_motion("攻撃２", -1, 6)
	end
	helper_cbe4d8e2()
	monster.set_motion("立ち")
	helper_ee5b84d4(3)
end

--- Helper function.
local function helper_125a4()
	local var1: f32 = 0
	local var3: f32 = 0
	while true do
		if helper_661d392d(90, 180) ~= 0 then
			monster.set_motion("回転右")
		else
			monster.set_motion("回転左")
		end
		helper_82cb5588(vm.f32(0.02617994))
		do
			local _, out2, _ = monster.get_rotation()
			var1 = out2 or var1
		end
		var3 = monster.get_target_angle() or var3
		if helper_8971d3b6(var3, var1, vm.f32(0.02617994)) == 0 then
			helper_442b9962()
			break
		else
			helper_b9fff8e1()
		end
	end
end

--- Helper function.
local function helper_12178()
	local var0: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	while true do
		if helper_661d392d(0, 200.0) == 0 then
			return 1
		end
		var0 = monster.get_target_distance() or var0
		if var0 <= 50.0 then
			helper_442b9962()
			monster.stop_moving()
			return 0
		end
		if var0 > 240.0 then
			helper_442b9962()
			monster.stop_moving()
			return 1
		end
		monster.set_motion("歩き")
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 3.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		helper_82cb5588(vm.f32(0.01308997))
		monster.move_toward_position(pos_x, pos_y, pos_z, 0.4, 1.0)
		helper_b9fff8e1()
	end
	return 0
end

--- Helper function.
local function helper_12bb4(arg0: s32)
	local argc: s32 = 0
	helper_11678()
	if bit32.band(arg0, 16) ~= 0 then
		helper_128f8()
		return
	end
	if bit32.band(arg0, 2) ~= 0 then
		if helper_661d392d(0, 45.0) == 0 then
			argc = monster.get_random(100) or argc
			if argc < 2 then
				helper_125a4()
			end
		end
		return
	end
	if (if bit32.band(arg0, 1) ~= 0 then bit32.band(arg0, 8) else 0) ~= 0 then
		helper_125a4()
		return
	end
	if (if bit32.band(arg0, 1) ~= 0 then bit32.band(arg0, 4) else 0) ~= 0 then
		if helper_12178() ~= 0 then
			return
		else
			helper_125a4()
		end
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
		helper_179581d3(var7, 0.75)
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 30.0)
		if var17 > 0.0 then
			helper_54469cb2(0.75, vm.f32(0.4), var7, var17, 30.0, 30)
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
				helper_549e2b35(place_pos_x, place_pos_y, place_pos_z, vm.f32(0.4), 0.75, var5, var18, 30.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_179581d3(var19, 0.75)
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
			helper_179581d3(var7, 0.75)
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
					var1 = helper_bfbcfc9f(vm.f32(0.4), 0.75, var20, var21, 30.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_179581d3(var23, 0.75)
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
					helper_cd4ea219(vm.f32(0.4), var7, 1000.0, 30.0, 60)
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
			helper_97d8f861(vm.f32(0.4), 0.75, var5, 360.0, 40.0, 30.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_13f50()
	monster.set_motion("歩き", -1, 0)
	helper_e1c3e640(vm.f32(0.4), 1.0, 30.0, 90)
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(60)
end

--- Helper function.
local function helper_140e8()
	local var0: f32 = 0
	local var1: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	var0 = monster.get_target_distance() or var0
	if helper_a25c5b2e() == 0 then
		helper_11678()
		if var0 < 100.0 then
			monster.set_motion("立ち")
			var3 = helper_11d50()
			helper_12bb4(var3)
		else
			helper_efa8()
		end
	else
		var1 = helper_243517f2(var1)
		if var0 < var1 then
			if var0 < 75.0 then
				monster.set_monster_guard_rate(-1, 1.0)
				helper_65eb2b74(0)
				monster.set_motion("立ち")
				var4 = helper_11d50()
				helper_12bb4(var4)
			else
				monster.set_monster_guard_rate(-1, 4.0)
				helper_13f50()
			end
		else
			monster.set_monster_guard_rate(-1, 1.0)
			helper_65eb2b74(0)
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃１", 0.554, 0.677, 0)
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃２", 0.343, 0.486, 0)
	helper_0a773d51(300)
	helper_2f8c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_b9fff8e1()
		helper_140e8()
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
	local argc: s32 = 0
	helper_5d37e9f4()
	argc = monster.get_random(100) or argc
	if argc < 35 then
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(vm.f32(helper_28452e16(vm.f32(0.01308997)) * 1.5))
		monster.reset_motion()
		monster.set_motion("攻撃１", -1, 6)
		helper_cbe4d8e2()
		monster.set_motion("立ち", -1, 4)
		helper_ee5b84d4(3)
	else
		monster.stop_moving()
		helper_442b9962()
		monster.set_motion("ダメージ", -1, 6)
		monster.start_knockback(4.0, 0.0, 3)
		helper_ee5b84d4(16)
	end
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	local argc: s32 = 0
	helper_fd16d93e()
	argc = monster.get_random(100) or argc
	if argc < 40 then
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(vm.f32(helper_28452e16(vm.f32(0.01308997)) * 1.5))
		monster.reset_motion()
		monster.set_motion("攻撃２", -1, 6)
		helper_cbe4d8e2()
		monster.set_motion("立ち", -1, 4)
		helper_ee5b84d4(3)
	else
		monster.stop_moving()
		helper_442b9962()
		monster.set_motion("ダメージ", -1, 6)
		monster.start_knockback(4.0, 0.0, 3)
		helper_cbe4d8e2()
		helper_ee5b84d4(16)
	end
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
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

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
	monster.set_motion("ダメージ", -1, 6)
	helper_cbe4d8e2()
	helper_ee5b84d4(8)
	helper_e05438b5()
end

return script
