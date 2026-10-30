--!strict
-- dungeon/monster/b214an.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1aaed117 = require("@lib/monster/helper_1aaed117")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_48852a90 = require("@lib/monster/helper_48852a90")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")
local helper_97663440 = require("@lib/monster/helper_97663440")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_b273522a = require("@lib/monster/helper_b273522a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

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
local function helper_117ec()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 130.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = helper_8be991f0(vm.f32(2.6), 3.0, var3, var4, 69.0, 30)
		helper_890ee63a(3.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(69.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_106e4()
	if helper_b273522a(90, 180) ~= 0 then
		monster.set_motion("回転右", -1.0, 0)
	else
		monster.set_motion("回転左", -1.0, 0)
	end
	helper_890ee63a(3.0)
end

--- Helper function.
local function helper_10888(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var6: f32 = 0
	local pos_y: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: s32 = 0
	helper_890ee63a(rot_speed)
	rot_speed = helper_787df986(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	var15 = 0
	while var15 < arg3 do
		if helper_b273522a(0, 20) ~= 0 then
			monster.set_motion("歩き")
		elseif helper_b273522a(90, 180) ~= 0 then
			monster.set_motion("回転右")
		else
			monster.set_motion("回転左")
		end
		var13 = monster.get_target_distance() or var13
		if var13 < arg2 then
			helper_442b9962()
			monster.stop_moving()
			return
		end
		var14 = monster.get_target_angle() or var14
		monster.turn_toward_angle(var14, rot_speed)
		do
			local out1, _, out3 = monster.get_target_position()
			var4 = out1 or var4
			var6 = out3 or var6
		end
		do
			local _, out2, _ = monster.get_position_3()
			pos_y = out2 or pos_y
		end
		monster.get_rotation()
		monster.move_toward_position(var4, pos_y - 20.0, var6, arg0, arg0)
		helper_0ba23e4e()
		var15 = var15 + 1
		monster.stop_moving()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_12e58()
	local argc: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	var2 = monster.get_target_distance() or var2
	argc = monster.get_random(100) or argc
	if argc < 90 then
		helper_106e4()
		monster.set_motion("歩き", -1, 0)
		helper_10888(vm.f32(2.6), 3.0, 130.0, 90)
		monster.set_motion("立ち", -1, 0)
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var4 = -30.0
			else
				var4 = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			helper_106e4()
			monster.set_motion("歩き", -1, 0)
			helper_8be991f0(vm.f32(2.6), 3.0, var4, var2, 130.0, 45)
			monster.set_motion("歩き", -1, 0)
			helper_106e4()
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(69.0, 45.0, 30)
		end
	end
end

--- Helper function.
local function helper_11364()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.set_variable(1, 2)
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃２", -1, 6)
	helper_48852a90(3.0, 0.5, vm.f32(0.01))
	do
		local out1, out2, out3 = monster.get_point_from_facing(0.0, 16.0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	attack = monster.get_attack_power_1() or attack
	monster.set_effect_value(-1, 0, attack)
	helper_56d63eae()
	monster.set_motion("立ち", -1, 0)
	helper_97663440(9)
end

--- Helper function.
local function helper_126d0()
	local argc: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	var2 = monster.get_target_distance() or var2
	argc = monster.get_random(100) or argc
	if argc < 10 then
		helper_11364()
	else
		argc = monster.get_random(100) or argc
		if argc < 90 then
			monster.set_motion("歩き", -1, 0)
			helper_106e4()
			monster.set_motion("歩き", -1, 0)
			helper_10888(vm.f32(2.6), 6.0, 69.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var4 = -30.0
				else
					var4 = 30.0
				end
				monster.set_motion("歩き", -1, 0)
				helper_106e4()
				monster.set_motion("歩き", -1, 0)
				helper_8be991f0(vm.f32(2.6), 3.0, var4, var2, 1.0, 45)
				monster.set_motion("歩き", -1, 0)
				helper_106e4()
				monster.set_motion("立ち", -1, 0)
				helper_7ca8a12f(69.0, 45.0, 30)
			end
		end
	end
end

--- Helper function.
local function helper_110c0()
	monster.set_variable(1, 1)
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃１", -1, 6)
	helper_48852a90(3.0, vm.f32(0.267), -1.0)
	helper_56d63eae()
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_11cfc()
	local argc: s32 = 0
	local var4: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 90 then
		argc = monster.get_random(100) or argc
		if argc < 40 then
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("走り", -1, 0)
			helper_10888(vm.f32(3.2), 6.0, 69.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
		monster.get_target_distance()
		argc = monster.get_random(100) or argc
		if argc < 70 then
			helper_110c0()
		else
			helper_11364()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("走り", -1, 0)
			helper_10888(vm.f32(3.2), 6.0, 69.0, 60)
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
			helper_8be991f0(vm.f32(2.6), 3.0, var4, 138.0, 1.0, 25)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(9)
		end
	end
end

--- Helper function.
local function helper_134a4()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		monster.get_life()
		var0 = monster.get_target_distance() or var0
		if var0 > 280.0 then
			vm.wait()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			helper_117ec()
			continue
		end
		if var0 < 280.0 and var0 >= 210.0 then
			helper_12e58()
		elseif var0 < 210.0 and var0 >= 130.0 then
			helper_126d0()
		else
			helper_11cfc()
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local get_not_used_texb: s32 = 0
	local var1: s32 = 0
	monster.register_damage_hit("弱連続", 8.0, "攻撃１", 0.217, 0.256, 0)
	monster.register_damage_hit("吹っ飛び弱", 8.0, "攻撃１", 0.486, 0.524, 0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("ヴァンガード衝撃波", get_not_used_texb) or var1
		if var1 ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(1, 0)
	helper_1c5c()
	monster.set_clip_distance(999999.9)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("立ち", -1, 0)
	while true do
		vm.wait()
		var0 = monster.get_target_distance() or var0
		if var0 < 280.0 then
			helper_134a4()
		else
			monster.set_motion("歩き", -1, 0)
			helper_106e4()
			monster.set_motion("歩き", -1, 0)
			helper_10888(vm.f32(2.6), 3.0, 69.0, 60)
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
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	monster.set_motion("死に", -1, 2)
	helper_56d63eae()
	monster.spawn_death_effects()
	helper_c3e8ae39(30)
	helper_1aaed117()
	monster.request_event_script(500)
	while true do
		vm.wait()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_aa93a1aa()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("ダメージ", -1, 6)
	helper_56d63eae()
	helper_e05438b5()
end

return script
