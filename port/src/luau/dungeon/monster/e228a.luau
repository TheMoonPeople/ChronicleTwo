--!strict
-- dungeon/monster/e228a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_6d5002db = require("@lib/monster/helper_6d5002db")
local helper_754712d9 = require("@lib/monster/helper_754712d9")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")
local helper_95b679db = require("@lib/monster/helper_95b679db")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
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
local function helper_11e64()
	monster.set_motion("遊び", -1, 6)
	helper_7ca8a12f(40.0, 45.0, helper_9df6409a(35))
end

--- Helper function.
local function helper_11fec()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
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
			local _ = helper_8be991f0(vm.f32(2.2), 3.0, var3, var4, 40.0, 30)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(40.0, 45.0, 30)
		end
	else
		helper_11e64()
	end
end

--- Helper function.
local function helper_117d0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃２", -1, 6)
	helper_754712d9(3.0, helper_9df6409a(8))
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var4) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var4) * 100.0))
	monster.move_toward_position(pos_x, pos_y - 10.0, pos_z, 4.5, 4.5)
	helper_c3e8ae39(helper_9df6409a(17))
	monster.stop_moving()
	monster.get_attack_power_1()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	helper_c3e8ae39(helper_9df6409a(9))
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_13aac()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	var1 = monster.get_target_distance() or var1
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 30 then
			argc = monster.get_random(100) or argc
			if argc < 80 then
				monster.set_motion("歩き", -1, 0)
				helper_6d5002db(vm.f32(2.2), 3.0, 40.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				helper_7ca8a12f(40.0, 45.0, 75)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var2 = -30.0
			else
				var2 = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("歩き", -1, 0)
			helper_8be991f0(vm.f32(2.2), 3.0, var2, var1, 90.0, 45)
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(40.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(3.0)
		helper_117d0()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_13420()
	local argc: s32 = 0
	local var2: f32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 60 then
		helper_117d0()
	else
		argc = monster.get_random(100) or argc
		if argc < 55 then
			monster.set_motion("歩き", -1, 0)
			helper_6d5002db(vm.f32(2.2), 3.0, 40.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var2 = -30.0
				monster.set_motion("歩き左", -1, 0)
			else
				var2 = 30.0
				monster.set_motion("歩き右", -1, 0)
			end
			helper_95b679db(vm.f32(2.2), var2, 3.0, 60)
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(40.0, 45.0, 30)
		end
	end
end

--- Helper function.
local function helper_11244()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(6.0)
	monster.set_motion("攻撃１", -1, 6)
	helper_c3e8ae39(helper_9df6409a(12))
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
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(var4)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(var4)))
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.08, 3.08)
	helper_c3e8ae39(helper_9df6409a(28))
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_10c34(arg0: f32)
	local argc: s32 = 0
	local target: f32 = 0
	local var3: f32 = 0
	local target_3: f32 = 0
	local pos_y: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	var8 = monster.get_target_distance() or var8
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(6.0)
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.reset_motion()
		monster.set_motion("歩き右", -1, 6)
		var9 = 30.0
	else
		monster.reset_motion()
		monster.set_motion("歩き左", -1, 6)
		var9 = -30.0
	end
	target, var3, target_3 = helper_125e5305(var9, var8, target, var3, target_3)
	helper_c3e8ae39(helper_9df6409a(7))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(target, pos_y - 10.0, target_3, arg0, arg0)
	monster.set_monster_attributes(32, 1)
	helper_c3e8ae39(helper_9df6409a(9))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_56d63eae()
end

--- Helper function.
local function helper_1063c(move_speed: f32)
	local pos_x: f32 = 0
	local var3: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local pos_y_2: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(6.0)
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
	monster.set_motion("歩き後", -1, 6)
	helper_c3e8ae39(helper_9df6409a(8))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2, pos_z, move_speed, move_speed + 1.0)
	helper_c3e8ae39(helper_9df6409a(8))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_56d63eae()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Helper function.
local function helper_12e1c()
	local argc: s32 = 0
	local var4: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 50 then
		helper_11244()
	else
		argc = monster.get_random(100) or argc
		if argc < 40 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				helper_10c34(3.0)
			else
				helper_1063c(3.0)
			end
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var4 = -30.0
				monster.set_motion("歩き左", -1, 0)
			else
				var4 = 30.0
				monster.set_motion("歩き右", -1, 0)
			end
			helper_95b679db(vm.f32(2.2), var4, 3.0, 45)
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_142f4()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		helper_f1703059()
		var0 = monster.get_target_distance() or var0
		if var0 > 225.0 then
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
			helper_11fec()
			continue
		end
		if var0 < 225.0 and var0 >= 140.0 then
			helper_13aac()
		elseif var0 < 140.0 and var0 >= 90.0 then
			helper_13420()
		else
			helper_12e1c()
		end
	end
end

--- Helper function.
local function helper_14734()
	local var3: f32 = 0
	while true do
		vm.wait()
		var3 = monster.get_target_distance() or var3
		if var3 < 225.0 then
			vm.wait()
			return
		end
		helper_11fec()
	end
end

--- Helper function.
local function helper_12568()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	local var9: f32 = 0
	monster.get_life_int()
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_11fec()
			continue
		end
		var3 = monster.get_target_distance() or var3
		if var3 < 90.0 then
			helper_11244()
		else
			argc = monster.get_random(100) or argc
			if argc < 60 then
				helper_117d0()
			else
				argc = monster.get_random(100) or argc
				if argc < 90 then
					monster.set_motion("歩き", -1, 0)
					helper_6d5002db(vm.f32(2.64), 3.0, 40.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					helper_890ee63a(3.0)
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var9 = -30.0
						monster.set_motion("歩き左", -1, 0)
					else
						var9 = 30.0
						monster.set_motion("歩き右", -1, 0)
					end
					helper_95b679db(vm.f32(2.2), var9, 3.0, 45)
					monster.set_motion("歩き", -1, 0)
					helper_890ee63a(3.0)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("通常毒", 5.0, "攻撃１", 0.382, 0.697, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "攻撃２", 0.522, 0.652, 1)
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
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			helper_f1703059()
			var0 = monster.get_target_distance() or var0
			if var0 < 225.0 then
				helper_142f4()
			else
				helper_14734()
			end
		else
			helper_12568()
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
	helper_d8cf1050()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_56d63eae()
	monster.set_action_status(1)
	helper_c3e8ae39(30)
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
	if argc < 65 then
		monster.reset_motion()
		monster.set_motion("ガードin", -1, 6)
		helper_56d63eae()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		helper_c3e8ae39(helper_9df6409a(8))
		monster.set_motion("ガードout", -1, 6)
		helper_56d63eae()
		monster.set_motion("立ち")
	else
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(15.0)
		monster.reset_motion()
		monster.set_motion("ガードin", -1, 6)
		helper_56d63eae()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		helper_c3e8ae39(60)
		monster.set_motion("ガードout", -1, 6)
		helper_56d63eae()
		monster.set_motion("立ち")
	end
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_1063c(3.0)
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	helper_10c34(3.0)
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
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_aa93a1aa()
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
