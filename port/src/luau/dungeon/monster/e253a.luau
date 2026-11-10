--!strict
-- dungeon/monster/e253a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_211db10d = require("@lib/monster/helper_211db10d")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
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
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
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
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")
local helper_f5b67d57 = require("@lib/monster/helper_f5b67d57")
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
local function helper_12684()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 160.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = helper_bfbcfc9f(6.0, vm.f32(4.2), var3, var4, 78.0, 30)
		helper_83e135e0(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(78.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_1395c()
	monster.set_motion("歩き", 0.45, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("歩き", -1.0, 0)
	helper_e1c3e640(6.0, vm.f32(4.2), 78.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_136ec()
	monster.get_life()
	monster.set_motion("歩き", 0.45, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("歩き", -1.0, 0)
	helper_e1c3e640(6.0, vm.f32(4.2), 78.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_11b40()
	monster.set_motion("歩き", 0.45, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("攻撃１", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(3)
end

--- Helper function.
local function helper_11d30()
	monster.set_motion("歩き", 0.45, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(3)
end

--- Helper function.
local function helper_11f20(arg0: any)
	local chara_type: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	monster.set_motion("歩き", 0.45, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("攻撃３in", -1, 6)
	helper_cbe4d8e2()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var6 = out2 or var6
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var6) * 300.0))
	pos_y = vm.f32(pos_y - 20.0)
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var6) * 300.0))
	monster.set_motion("攻撃３loop", -1, 4)
	monster.move_toward_position(pos_x, pos_y, pos_z, 7.4, 7.4)
	chara_type = monster.get_character_number() or chara_type
	monster.create_effect_1("スピン")
	monster.set_effect_owner(-1, chara_type)
	monster.set_effect_value(-1, 1, 45)
	monster.set_effect_value_float(-1, 2, 1.0)
	helper_ee5b84d4(45)
	monster.stop_moving()
	monster.set_motion("攻撃３out", -1, 6)
	helper_cbe4d8e2()
end

--- Helper function.
local function helper_13308()
	local argc: s32 = 0
	local var3: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 70 then
		argc = monster.get_random(100) or argc
		if argc < 70 then
			var3 = monster.get_target_distance() or var3
			if var3 < 60.0 then
				helper_11b40()
			else
				helper_11d30()
			end
		else
			helper_11f20(45)
		end
	else
		monster.set_motion("歩き", -1, 0)
		helper_e1c3e640(6.0, vm.f32(4.2), 78.0, 90)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_13b90()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		monster.get_life()
		helper_f5b67d57()
		var0 = monster.get_target_distance() or var0
		if var0 > 290.0 then
			helper_b9fff8e1()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin <= 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_12684()
			continue
		end
		if var0 < 290.0 and var0 >= 200.0 then
			helper_1395c()
		elseif var0 < 200.0 and var0 >= 160.0 then
			helper_136ec()
		else
			helper_13308()
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
	if var17 < 78.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", 0.45, 0)
		helper_179581d3(var7, vm.f32(4.2))
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 78.0)
		if var17 > 0.0 then
			helper_54469cb2(vm.f32(4.2), 1.75, var7, var17, 78.0, 30)
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
				helper_549e2b35(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.2), var5, var18, 78.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_179581d3(var19, vm.f32(4.2))
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
	if argc < 40 then
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
			monster.set_motion("歩き", 0.45, 0)
			helper_179581d3(var7, vm.f32(4.2))
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
					var1 = helper_bfbcfc9f(1.75, vm.f32(4.2), var20, var21, 78.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_179581d3(var23, vm.f32(4.2))
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
					helper_cd4ea219(1.75, var7, 1000.0, 78.0, 60)
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
			helper_97d8f861(1.75, vm.f32(4.2), var5, 360.0, 40.0, 78.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_14ed4()
	monster.set_motion("歩き", -1, 0)
	helper_e1c3e640(6.0, vm.f32(4.2), 78.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_12b94()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	local var9: f32 = 0
	monster.get_life()
	while true do
		helper_b9fff8e1()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		var3 = monster.get_target_distance() or var3
		if var3 > 290.0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_12684()
			continue
		end
		if var3 < 160.0 then
			var9 = monster.get_target_distance() or var9
			if var9 < 156.0 then
				argc = monster.get_random(100) or argc
				if argc < 70 then
					var9 = monster.get_target_distance() or var9
					if var9 < 60.0 then
						helper_11b40()
					else
						helper_11d30()
					end
				else
					helper_11f20(45)
				end
			else
				helper_11f20(45)
			end
		else
			monster.set_motion("歩き", 0.45, 0)
			helper_83e135e0(vm.f32(4.2))
			monster.set_motion("歩き", 0.55, 0)
			helper_e1c3e640(vm.f32(3.2), vm.f32(4.2), 78.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_15060()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		helper_f5b67d57()
		var0 = monster.get_target_distance() or var0
		if helper_a25c5b2e() == 0 then
			if var0 < 290.0 then
				helper_13b90()
			else
				helper_efa8()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 160.0 then
					helper_65eb2b74(0)
					helper_13b90()
				else
					helper_14ed4()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_12b94()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local max_life: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃１", 0.325, 0.375, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃２", 0.319, 0.421, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃３loop", 0.0, 0.5, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃３loop", 0.5, 1.0, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃３loop", 0.0, 0.5, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃３loop", 0.0, 1.0, 1)
	monster.load_effect_script("スピン")
	monster.set_variable(0, 0)
	helper_2f8c()
	max_life = monster.get_monster_max_life(-1) or max_life
	helper_5a759074(vm.ftoi(vm.f32(max_life * vm.f32(0.05))))
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_b9fff8e1()
		helper_15060()
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
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
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
function script.on_caught()
	helper_d742309a()
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_b9fff8e1()
	end
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
	monster.set_motion("ダメージ", -1, 6)
	helper_ee5b84d4(12)
	helper_e05438b5()
end

return script
