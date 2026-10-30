--!strict
-- dungeon/monster/b117a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_1558de1f = require("@lib/monster/helper_1558de1f")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_20ea05b8 = require("@lib/monster/helper_20ea05b8")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_319fc0f3 = require("@lib/monster/helper_319fc0f3")
local helper_46dd3e0a = require("@lib/monster/helper_46dd3e0a")
local helper_49286904 = require("@lib/monster/helper_49286904")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_6f4b5976 = require("@lib/monster/helper_6f4b5976")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_97d8f861 = require("@lib/monster/helper_97d8f861")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b765e6cd = require("@lib/monster/helper_b765e6cd")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d375874f = require("@lib/monster/helper_d375874f")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_e8739558 = require("@lib/monster/helper_e8739558")
local helper_f4599faf = require("@lib/monster/helper_f4599faf")
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
local function helper_135e8(arg0: s32)
	local var1: s32 = 0
	local argc: s32 = 0
	for var2 = 0, arg0 - 1 do
		helper_b9fff8e1()
		monster.reset_motion()
		monster.set_motion("遊び", -1, 2)
		var1 = helper_e62edeb2(49.0, 90.0, helper_9df6409a(56))
		if var1 == 1 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", 0.65, 0)
				helper_83e135e0(4.0)
				helper_f4599faf()
				monster.set_motion("歩き", 0.65, 0)
				helper_83e135e0(4.0)
				monster.set_motion("立ち", -1, 0)
			end
		end
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(49.0, 90.0, 30)
	end
end

--- Helper function.
local function helper_160b0()
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(49.0, 90.0, 30)
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			var2 = monster.get_random_whole_number(30.0) or var2
			var3 = monster.get_random_whole_number(30.0) or var3
			var3 = vm.f32(var3 + 85.0)
			if argc < 50 then
				var2 = vm.f32(-var2 - 30.0)
			else
				var2 = vm.f32(var2 + 30.0)
			end
			monster.set_motion("歩き", 0.6, 0)
			local _ = helper_bfbcfc9f(vm.f32(2.4), 4.0, var2, var3, 49.0, 40)
			helper_83e135e0(4.0)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			argc = monster.get_random(2) or argc
			helper_135e8(argc)
		end
	end
end

--- Helper function.
local function helper_12908()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local height: f32 = 0
	local vector_2: f32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１", -1, 6)
	helper_b765e6cd(4.0, helper_9df6409a(24))
	height = monster.get_height_above_ground() or height
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	vector_2 = vm.f32(pos_y - height)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
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
	monster.create_effect_1("ＳＷ赤Ｌ")
	monster.set_effect_first_vector(-1, pos_x, vector_2, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.set_effect_value(-1, 0, attack)
	helper_cbe4d8e2()
	monster.set_motion("歩き", -1, 0)
	helper_20ea05b8(3)
end

--- Helper function.
local function helper_15b18()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 95 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			monster.set_motion("歩き", 0.6, 0)
			helper_e1c3e640(vm.f32(2.4), 4.0, 85.0, 75)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			helper_12908()
			monster.set_motion("立ち", -1, 0)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 10 then
			monster.set_motion("歩き", 0.6, 0)
			helper_97d8f861(vm.f32(2.4), 4.0, 30.0, 180.0, 30.0, 85.0, 45)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			argc = monster.get_random(2) or argc
			helper_135e8(argc)
		end
	end
end

--- Helper function.
local function helper_154f8()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 65 then
		argc = monster.get_random(100) or argc
		if argc < 5 then
			monster.set_motion("歩き", 0.65, 0)
			helper_e8739558(4.0, 20.0, 15)
			helper_1558de1f()
			monster.set_motion("立ち", -1, 0)
			helper_20ea05b8(3)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			helper_12908()
			monster.set_motion("立ち", -1, 0)
			helper_20ea05b8(3)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			monster.set_motion("歩き", 0.6, 0)
			helper_e1c3e640(vm.f32(2.4), 4.0, 49.0, 60)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			helper_135e8(1)
		end
	end
end

--- Helper function.
local function helper_14750()
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 85 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			if argc < 30 then
				monster.set_motion("歩き", 0.65, 0)
				helper_e8739558(4.0, 20.0, 15)
				helper_1558de1f()
				monster.set_motion("立ち", -1, 0)
				helper_20ea05b8(3)
			else
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_motion("歩き", 0.65, 0)
					helper_83e135e0(4.0)
					helper_12908()
					monster.set_motion("立ち", -1, 0)
					helper_20ea05b8(3)
				else
					monster.set_motion("歩き", 0.65, 0)
					helper_83e135e0(4.0)
					helper_319fc0f3()
					monster.set_motion("立ち", -1, 0)
					helper_20ea05b8(3)
				end
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 60 then
				monster.set_motion("歩き", 0.65, 0)
				helper_e8739558(4.0, 20.0, 25)
				helper_6f4b5976()
				monster.set_motion("立ち", -1, 0)
				helper_20ea05b8(3)
			else
				monster.set_motion("歩き", 0.65, 0)
				helper_83e135e0(4.0)
				helper_49286904()
				monster.set_motion("立ち", -1, 0)
				helper_20ea05b8(3)
			end
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 40 then
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			helper_f4599faf()
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			var3 = monster.get_random_whole_number(30.0) or var3
			var2 = monster.get_random_whole_number(10.0) or var2
			if argc < 50 then
				var3 = vm.f32(-var3 - 30.0)
			else
				var3 = vm.f32(var3 + var3)
			end
			var2 = monster.get_target_distance() or var2
			monster.set_motion("歩き", 0.65, 0)
			helper_bfbcfc9f(vm.f32(2.4), 4.0, helper_28452e16(var3), var2, 1.0, 15)
		end
	end
end

--- Helper function.
local function helper_166a4()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		var3 = monster.get_target_distance() or var3
		if var3 > 240.0 then
			helper_b9fff8e1()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 0 then
			helper_160b0()
			continue
		end
		if var3 < 240.0 and var3 >= 140.0 then
			helper_15b18()
		elseif var3 < 140.0 and var3 >= 85.0 then
			helper_154f8()
		else
			helper_14750()
		end
		helper_b9fff8e1()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("インフェ攻撃２", 2.5, "攻撃１", 0.5, 0.75, 0)
	monster.register_damage_hit("インフェ攻撃", 3.0, "攻撃１", 0.5, 0.75, 1)
	monster.register_damage_hit("インフェ攻撃２", 2.5, "攻撃２", 0.5, 0.8, 0)
	monster.register_damage_hit("インフェ攻撃", 3.0, "攻撃２", 0.5, 0.8, 1)
	monster.register_damage_hit("インフェ攻撃２", 6.0, "攻撃２", 0.15, 0.8, 2)
	monster.add_sword_trail(0, "攻撃１", 0.32, 0.37, "dcol1", "dcol0", 77, 20, 20)
	monster.add_sword_trail(0, "攻撃２", 0.5, 0.53, "dcol1", "dcol0", 77, 20, 20)
	monster.load_effect_script("ＳＷ赤Ｌ")
	monster.set_variable(0, 0)
	helper_3048()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local value: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	value = monster.get_variable(0) or value
	if value == 0 then
		monster.set_motion("立ち", -1, 0)
		while true do
			var0 = monster.get_target_distance() or var0
			if var0 < 500.0 then
				break
			elseif helper_a25c5b2e() ~= 0 then
				break
			else
				helper_b9fff8e1()
			end
		end
		monster.set_variable(0, 1)
	end
	while true do
		helper_b9fff8e1()
		var0 = monster.get_target_distance() or var0
		if var0 < 240.0 then
			helper_166a4()
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_83e135e0(4.0)
			monster.set_motion("歩き", 0.6, 0)
			helper_e1c3e640(vm.f32(2.4), 4.0, 49.0, 90)
			monster.set_motion("立ち", -1, 0)
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
	local var0: f32 = 0
	local argc: s32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	monster.set_rotation(0.0, var0, 0.0)
	helper_b9fff8e1()
	argc = monster.get_random(20) or argc
	if argc < 20 then
		monster.set_motion("歩き", 0.65, 0)
		helper_83e135e0(4.0)
		helper_46dd3e0a()
		monster.set_motion("歩き", 0.65, 0)
		helper_83e135e0(4.0)
		monster.set_motion("立ち", -1, 0)
	else
		var0 = monster.get_target_angle() or var0
		monster.set_rotation(0.0, var0, 0.0)
		helper_b9fff8e1()
		helper_f4599faf()
		monster.set_motion("歩き", 0.65, 0)
		helper_83e135e0(4.0)
		monster.set_motion("立ち", -1, 0)
	end
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
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

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	monster.set_motion("死に", -1, 2)
	helper_cbe4d8e2()
	monster.spawn_death_effects()
	while true do
		helper_b9fff8e1()
	end
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
