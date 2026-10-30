--!strict
-- dungeon/monster/e103a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_8c937d2b = require("@lib/monster/helper_8c937d2b")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ade2dbe2 = require("@lib/monster/helper_ade2dbe2")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_ba87ea88 = require("@lib/monster/helper_ba87ea88")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_cd4ea219 = require("@lib/monster/helper_cd4ea219")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_e8739558 = require("@lib/monster/helper_e8739558")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")
local helper_fd16d93e = require("@lib/monster/helper_fd16d93e")

local global1: f32 = 0

--- Helper function.
local function helper_2f8c()
	local boss: s32 = 0
	helper_1adea708(500.0)
	helper_6911bbcd(80.0)
	helper_5a759074(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	global1 = 0.0
	boss = monster.is_boss() or boss
	if boss == 0 then
		do
			local _, out2, _ = monster.get_position_3()
			global1 = out2 or global1
		end
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
	global1 = 0.0
end

--- Helper function.
local function helper_12904()
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
		local _ = helper_bfbcfc9f(vm.f32(1.6), 4.0, var3, var4, 50.0, 30)
		helper_83e135e0(4.0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(50.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_14d48()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 20 then
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(vm.f32(1.6))
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(100.0, 45.0, 30)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(100.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_11abc()
	local pos_x: f32 = 0
	local var2: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	var4 = monster.get_target_distance() or var4
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var6 = monster.get_random_whole_number(15.0) or var6
	var4 = vm.f32(var4 + vm.f32(25.0 + var6))
	pos_x, var2, pos_z = helper_125e5305(0.0, var4, pos_x, var2, pos_z)
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	monster.move_toward_position(pos_x, global1, pos_z, 1.6, 1.6)
	helper_cbe4d8e2()
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_11e58(arg0: s32)
	monster.set_motion("攻撃１", -1, 0)
	helper_8c937d2b(5.25, 4.0, 1.0, arg0)
	monster.stop_moving()
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(4.0)
	helper_11abc()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_14500()
	local argc: s32 = 0
	local var1: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 25 then
		monster.set_motion("歩き", -1, 0)
		helper_e8739558(4.0, 50.0, 15)
		helper_11e58(30)
		monster.set_motion("立ち", -1, 0)
		helper_ee5b84d4(17)
	else
		argc = monster.get_random(100) or argc
		if argc < 10 then
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(4.0)
			helper_8c937d2b(vm.f32(1.6), 4.0, vm.f32(60.000004), 30)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 75 then
				argc = monster.get_random(100) or argc
				if argc < 70 then
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(vm.f32(1.6))
					monster.set_motion("立ち", -1, 0)
					helper_e62edeb2(50.0, 45.0, 30)
				else
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(4.0)
					var1 = monster.get_target_angle() or var1
					helper_cd4ea219(
						vm.f32(1.2800001),
						helper_28452e16(vm.f32(var1 + vm.f32(3.1415927))),
						100.0,
						50.0,
						30
					)
				end
			else
				monster.set_motion("立ち", -1, 0)
				helper_e62edeb2(50.0, 45.0, 30)
			end
		end
	end
end

--- Helper function.
local function helper_13e50()
	local argc: s32 = 0
	local var2: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 40 then
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(4.0)
		helper_11e58(30)
		monster.set_motion("立ち", -1, 0)
		helper_ee5b84d4(17)
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(4.0)
			helper_11abc()
			monster.set_motion("立ち", -1, 0)
			argc = monster.get_random(100) or argc
			if argc < 30 then
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(4.0)
				helper_11e58(30)
				monster.set_motion("立ち", -1, 0)
				helper_ee5b84d4(17)
			end
		else
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(4.0)
			var2 = monster.get_target_angle() or var2
			helper_cd4ea219(vm.f32(1.6), helper_28452e16(var2), 100.0, 1.0, 45)
		end
	end
end

--- Helper function.
local function helper_1503c()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		helper_ade2dbe2()
		var3 = monster.get_target_distance() or var3
		if var3 > 250.0 then
			monster.set_variable(5, 1)
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			helper_12904()
			continue
		end
		if var3 < 250.0 and var3 >= 165.0 then
			helper_14d48()
		elseif var3 < 165.0 and var3 >= 90.0 then
			helper_14500()
		else
			helper_13e50()
		end
	end
end

--- Helper function.
local function helper_154b8()
	local var3: f32 = 0
	local var4: f32 = 0
	local value: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		helper_ade2dbe2()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if helper_a25c5b2e() ~= 0 or gekirin <= 0 then
			return
		end
		value = monster.get_variable(5) or value
		var3 = monster.get_target_distance() or var3
		var4 = monster.get_target_speed() or var4
		if var3 < 90.0 and var4 > vm.f32(1.8) then
			monster.set_variable(5, 1)
			monster.set_motion("ガードout", -1, 6)
			helper_cbe4d8e2()
			argc = monster.get_random(100) or argc
			if argc < 70 then
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(4.0)
				helper_11e58(30)
				monster.set_motion("立ち", -1, 0)
				helper_ee5b84d4(17)
			end
			return
		end
		if value == 1 then
			monster.set_motion("ガードin", -1, 6)
			helper_cbe4d8e2()
			monster.set_motion("ガード", -1, 0)
			monster.set_variable(5, 0)
		end
	end
end

--- Helper function.
local function helper_17230()
	local value: s32 = 0
	value = monster.get_variable(5) or value
	if value == 0 then
		monster.set_variable(5, 1)
		monster.set_motion("ガードout", -1, 6)
		helper_cbe4d8e2()
	end
	monster.set_motion("攻撃１", -1, 0)
	helper_e1c3e640(7.0, 4.0, 50.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_12d84()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	while true do
		helper_b9fff8e1()
		var3 = monster.get_target_distance() or var3
		if var3 > 250.0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_12904()
			continue
		end
		if var3 < 90.0 then
			argc = monster.get_random(100) or argc
			if argc < 70 then
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(4.0)
				helper_11e58(30)
				monster.set_motion("立ち", -1, 0)
				helper_ee5b84d4(12)
			else
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(4.0)
					helper_11abc()
					monster.set_motion("立ち", -1, 0)
					argc = monster.get_random(100) or argc
					if argc < 30 then
						monster.set_motion("歩き", -1, 0)
						helper_83e135e0(4.0)
						helper_11e58(30)
						monster.set_motion("立ち", -1, 0)
						helper_ee5b84d4(12)
					end
				else
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(4.0)
					var6 = monster.get_target_angle() or var6
					helper_cd4ea219(vm.f32(1.6), helper_28452e16(var6), 100.0, 1.0, 45)
				end
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 70 then
				monster.set_motion("歩き", -1, 0)
				helper_e8739558(4.0, 50.0, 15)
				helper_11e58(30)
				monster.set_motion("立ち", -1, 0)
				helper_ee5b84d4(12)
			else
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_motion("歩き", -1, 0)
					helper_83e135e0(4.0)
					helper_8c937d2b(vm.f32(1.6), 4.0, vm.f32(60.000004), 30)
					monster.set_motion("立ち", -1, 0)
				else
					argc = monster.get_random(100) or argc
					if argc < 75 then
						argc = monster.get_random(100) or argc
						if argc < 70 then
							monster.set_motion("歩き", -1, 0)
							helper_83e135e0(vm.f32(1.6))
							monster.set_motion("立ち", -1, 0)
							helper_e62edeb2(50.0, 45.0, 30)
						else
							monster.set_motion("歩き", -1, 0)
							helper_83e135e0(4.0)
							var7 = monster.get_target_angle() or var7
							helper_cd4ea219(
								vm.f32(1.2800001),
								helper_28452e16(vm.f32(var7 + vm.f32(3.1415927))),
								100.0,
								50.0,
								30
							)
						end
					else
						monster.set_motion("立ち", -1, 0)
						helper_e62edeb2(50.0, 45.0, 30)
					end
				end
			end
		end
	end
end

--- Helper function.
local function helper_1751c()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		var0 = monster.get_target_distance() or var0
		if helper_a25c5b2e() == 0 then
			if var0 < 250.0 then
				helper_65eb2b74(0)
				helper_1503c()
			else
				helper_154b8()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 90.0 then
					helper_65eb2b74(0)
					helper_1503c()
				else
					helper_17230()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_12d84()
	end
end

--- Helper function.
local function helper_120c0()
	local argc: s32 = 0
	local target: f32 = 0
	local var2: f32 = 0
	local target_3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	var4 = monster.get_target_distance() or var4
	monster.set_monster_attributes(32, 1)
	argc = monster.get_random(100) or argc
	monster.reset_motion()
	if argc < 50 then
		monster.set_motion("ステップ右", -1, 6)
		var5 = 30.0
	else
		monster.set_motion("ステップ左", -1, 6)
		var5 = -30.0
	end
	target, var2, target_3 = helper_125e5305(var5, var4, target, var2, target_3)
	monster.set_monster_attributes(32, 0)
	monster.move_toward_position(target, global1, target_3, 1.9200001, 1.9200001)
	helper_cbe4d8e2()
	monster.stop_moving()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 7.0, "攻撃１", 0.2, 0.8, 0)
	monster.set_variable(5, 0)
	monster.set_motion("ガード", -1, 0)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("ガードout", 0.0, 0.52, 1004)
	end
	helper_2f8c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_b9fff8e1()
		helper_1751c()
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
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_cbe4d8e2()
	helper_ee5b84d4(12)
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
	helper_ee5b84d4(8)
	monster.set_motion("ガードout", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち")
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: s32 = 0
	helper_49610f43()
	monster.call_command(35, var0) -- retail: the handler rejects 1 arguments
	if var0 < 50 then
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(4.0)
		helper_11abc()
	else
		monster.set_motion("歩き", -1, 0)
		helper_83e135e0(4.0)
		helper_120c0()
	end
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.stop_moving()
	helper_442b9962()
	monster.set_motion("ガードin", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_ee5b84d4(8)
	monster.set_motion("ガードout", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち")
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
	local var0: f32 = 0
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("起き上がり", -1, 6)
	helper_cbe4d8e2()
	helper_e05438b5()
	helper_b9fff8e1()
	var0 = monster.get_target_distance() or var0
	if var0 > 90.0 then
		monster.set_motion("ガードin", -1, 6)
		helper_cbe4d8e2()
		monster.set_motion("ガード", -1, 0)
		monster.set_variable(5, 0)
	else
		monster.set_motion("立ち", -1, 0)
	end
	helper_b9fff8e1()
end

return script
