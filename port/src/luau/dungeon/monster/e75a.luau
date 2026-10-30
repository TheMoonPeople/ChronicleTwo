--!strict
-- dungeon/monster/e75a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_19658e9b = require("@lib/monster/helper_19658e9b")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_58087289 = require("@lib/monster/helper_58087289")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_8c937d2b = require("@lib/monster/helper_8c937d2b")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_ba87ea88 = require("@lib/monster/helper_ba87ea88")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")
local helper_f007f1e4 = require("@lib/monster/helper_f007f1e4")
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
local function helper_133e4()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 90.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = helper_bfbcfc9f(3.0, 3.5, var3, var4, 45.0, 30)
		helper_83e135e0(3.5)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(45.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_12e20()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(3.5)
	monster.set_motion("攻撃２", -1, 6)
	helper_19658e9b(3.5, vm.f32(0.42), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol01")
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
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("毒霧Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.set_effect_value(-1, 0, attack)
	helper_ee5b84d4(helper_9df6409a(18))
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(9)
end

--- Helper function.
local function helper_14fc8()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	var1 = monster.get_target_distance() or var1
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			if argc < 80 then
				monster.set_motion("歩き", -1, 0)
				helper_8c937d2b(3.0, 3.5, 45.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				helper_e62edeb2(45.0, 45.0, 75)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var2 = -30.0
			else
				var2 = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(3.5)
			monster.set_motion("歩き", -1, 0)
			helper_bfbcfc9f(3.0, 3.5, var2, var1, 90.0, 45)
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(3.5)
			monster.set_motion("立ち", -1, 0)
			helper_e62edeb2(45.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(3.5)
		helper_12e20()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_14994()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	var1 = monster.get_target_distance() or var1
	argc = monster.get_random(100) or argc
	if argc < 60 then
		helper_12e20()
	else
		argc = monster.get_random(100) or argc
		if argc < 55 then
			monster.set_motion("歩き", -1, 0)
			helper_8c937d2b(3.0, 3.5, 45.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var2 = -30.0
			else
				var2 = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(3.5)
			monster.set_motion("歩き", -1, 0)
			helper_bfbcfc9f(3.0, 3.5, var2, var1, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(3.5)
			monster.set_motion("立ち", -1, 0)
			helper_e62edeb2(45.0, 45.0, 30)
		end
	end
end

--- Helper function.
local function helper_12bf4()
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(7.0)
	monster.set_motion("攻撃１", -1, 2)
	helper_ee5b84d4(helper_9df6409a(45))
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(9)
end

--- Helper function.
local function helper_1289c()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("ステップ右", -1, 6)
	else
		monster.set_motion("ステップ左", -1, 6)
	end
	helper_ee5b84d4(helper_9df6409a(5))
	monster.set_monster_attributes(32, 1)
	helper_ee5b84d4(helper_9df6409a(15))
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_120ac()
	monster.set_motion("ステップ後", -1, 6)
	helper_ee5b84d4(helper_9df6409a(6))
	monster.set_monster_attributes(32, 1)
	helper_ee5b84d4(helper_9df6409a(14))
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_142bc()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 50 then
		var3 = monster.get_target_distance() or var3
		argc = monster.get_random(100) or argc
		if var3 < 60.0 then
			helper_12bf4()
		else
			helper_12e20()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			var3 = monster.get_target_distance() or var3
			if var3 < 55.0 then
				helper_1289c()
			else
				helper_120ac()
			end
			helper_12bf4()
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			var4 = monster.get_random_whole_number(60.0) or var4
			if argc < 50 then
				var4 = vm.f32(-var4 - 30.0)
			else
				var4 = vm.f32(var4 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			helper_bfbcfc9f(3.0, 3.5, var4, 90.0, 1.0, 25)
			helper_83e135e0(3.5)
			monster.set_motion("立ち", -1, 0)
			helper_ee5b84d4(9)
		end
	end
end

--- Helper function.
local function helper_15810()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		helper_58087289()
		var0 = monster.get_target_distance() or var0
		if var0 > 220.0 then
			helper_b9fff8e1()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_133e4()
			continue
		end
		if var0 < 220.0 and var0 >= 140.0 then
			helper_14fc8()
		elseif var0 < 140.0 and var0 >= 90.0 then
			helper_14994()
		else
			helper_142bc()
		end
	end
end

--- Helper function.
local function helper_1781c()
	monster.set_motion("歩き", -1, 0)
	helper_8c937d2b(vm.f32(3.6000001), 3.5, 45.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_138c4()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	local var9: f32 = 0
	monster.get_life_int()
	while true do
		helper_b9fff8e1()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 5 then
			helper_133e4()
			continue
		end
		var3 = monster.get_target_distance() or var3
		if var3 < 90.0 then
			if var3 < 75.0 then
				monster.set_motion("歩き", -1, 0)
				helper_8c937d2b(vm.f32(3.6000001), 3.5, 45.0, 30)
				helper_12bf4()
			else
				helper_12e20()
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 70 then
				helper_12e20()
			else
				argc = monster.get_random(100) or argc
				if argc < 90 then
					monster.set_motion("歩き", -1, 0)
					helper_8c937d2b(vm.f32(3.6000001), 3.5, 45.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var9 = -30.0
					else
						var9 = 30.0
					end
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(3.5)
					monster.set_motion("歩き", -1, 0)
					helper_bfbcfc9f(vm.f32(3.6000001), 3.5, var9, var3, 1.0, 45)
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(3.5)
					monster.set_motion("立ち", -1, 0)
					helper_e62edeb2(45.0, 45.0, 30)
				end
			end
		end
	end
end

--- Helper function.
local function helper_179a8()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		helper_58087289()
		var0 = monster.get_target_distance() or var0
		if helper_a25c5b2e() == 0 then
			if var0 < 220.0 then
				helper_15810()
			else
				helper_f007f1e4()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 90.0 then
					helper_65eb2b74(0)
					helper_15810()
				else
					helper_1781c()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_138c4()
	end
end

--- Helper function.
local function helper_11b78(move_speed: f32)
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
	var5 = vm.f32(var5 + vm.f32(40.0 + var7))
	pos_x, var3, pos_z = helper_125e5305(0.0, var5, pos_x, var3, pos_z)
	monster.set_motion("ステップ後", -1, 6)
	helper_ee5b84d4(helper_9df6409a(6))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2, pos_z, move_speed, move_speed + 1.0)
	helper_ee5b84d4(helper_9df6409a(17))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_cbe4d8e2()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Helper function.
local function helper_122f8(arg0: f32)
	local argc: s32 = 0
	local target: f32 = 0
	local var3: f32 = 0
	local target_3: f32 = 0
	local pos_y: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	var8 = monster.get_target_distance() or var8
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		var9 = 30.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		var9 = -30.0
	end
	target, var3, target_3 = helper_125e5305(var9, var8, target, var3, target_3)
	helper_e62edeb2(45.0, 45.0, helper_9df6409a(5))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(target, pos_y - 10.0, target_3, arg0, arg0)
	monster.set_monster_attributes(32, 1)
	helper_e62edeb2(45.0, 45.0, helper_9df6409a(15))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_cbe4d8e2()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local grade: s32 = 0
	local get_not_used_texb: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	grade = monster.get_monster_grade_2(-1) or grade
	if grade ~= 2 then
		monster.register_damage_hit("通常攻撃", 4.0, "攻撃１", 0.378, 0.556, 0, 2)
	else
		monster.register_damage_hit("通常攻撃", 6.0, "攻撃１", 0.378, 0.556, 0)
		monster.register_damage_hit("通常攻撃", 8.8, "攻撃１", 0.378, 0.556, 2)
	end
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var2 = monster.load_effect_script("毒霧Ｌ", get_not_used_texb) or var2
		var3 = monster.load_effect_script("毒霧Ｈ", get_not_used_texb) or var3
		if (if var2 ~= 0 then 1 else var3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	helper_3048()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_b9fff8e1()
		helper_179a8()
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
	local argc: s32 = 0
	helper_ab4b367a()
	argc = monster.get_random(100) or argc
	if argc < 65 then
		monster.reset_motion()
		monster.set_motion("ガードin", -1, 6)
		helper_cbe4d8e2()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		helper_ee5b84d4(8)
		monster.set_motion("ガードout", -1, 6)
		helper_cbe4d8e2()
		monster.set_motion("立ち")
	else
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(17.5)
		monster.reset_motion()
		monster.set_motion("ガードin", -1, 6)
		helper_cbe4d8e2()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		helper_ee5b84d4(60)
		monster.set_motion("ガードout", -1, 6)
		helper_cbe4d8e2()
		monster.set_motion("立ち")
	end
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_11b78(3.0)
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	helper_122f8(3.0)
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
