--!strict
-- dungeon/monster/b10a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_754712d9 = require("@lib/monster/helper_754712d9")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_b9b0f992 = require("@lib/monster/helper_b9b0f992")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_f2cf0297 = require("@lib/monster/helper_f2cf0297")

--- Helper function.
local function helper_1c54()
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
local function helper_11da8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	monster.set_motion("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	monster.set_motion("攻撃４", -1, 6)
	do
		local out1, out2, out3 = monster.get_position_3()
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
	monster.create_effect_1("グリコンボ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	helper_c3e8ae39(helper_9df6409a(119))
	monster.shake_camera(3.0, 45)
	helper_56d63eae()
	monster.set_motion("構え立ち", -1, 0)
	helper_c3e8ae39(helper_9df6409a(15))
end

--- Helper function.
local function helper_1229c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local argument_count: s32 = 0
	monster.set_motion("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	monster.set_motion("攻撃３", -1, 6)
	helper_c3e8ae39(helper_9df6409a(33))
	var6 = monster.get_target_distance() or var6
	do
		local out1, out2, out3 = monster.get_position_3()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	monster.get_rotation()
	do
		local out1, out2, out3 = monster.get_target_position()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var7 = vm.f32(vm.fdiv(var6, 31))
	monster.move_toward_position(var0, var1, var2, var7, var7)
	helper_c3e8ae39(helper_9df6409a(31))
	monster.stop_moving()
	monster.shake_camera(3.0, 45)
	helper_56d63eae()
	argument_count = monster.get_player_status_attribute() or argument_count
	if argument_count == 8 then
		helper_11da8()
	end
end

--- Helper function.
local function helper_1283c(arg0: s32)
	local var1: s32 = 0
	local argument_count: s32 = 0
	local value: s32 = 0
	value = monster.get_variable(5) or value
	var1 = 0
	while var1 < arg0 do
		argument_count = monster.get_player_status_attribute() or argument_count
		if argument_count == 8 and value <= 0 then
			helper_1229c()
			value = 90
		end
		vm.wait()
		var1 = var1 + 1
		value = vm.i32(value - 1)
	end
	value = 0
	monster.set_variable(5, value)
end

--- Helper function.
local function helper_142c4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	monster.set_motion("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	helper_1283c(1)
	monster.set_motion("攻撃３", -1, 6)
	helper_c3e8ae39(helper_9df6409a(33))
	do
		local out1, out2, out3 = monster.get_position_3()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	monster.get_rotation()
	var8 = monster.get_target_angle() or var8
	monster.set_rotation(0.0, var8, 0.0)
	var7 = 3.0
	do
		local out1, out2, out3 = monster.get_target_position()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var6 = monster.get_target_distance() or var6
	var7 = vm.f32(vm.fdiv(var6, helper_9df6409a(30)))
	monster.move_toward_position(var0, var1, var2, var7, var7)
	helper_c3e8ae39(helper_9df6409a(31))
	monster.stop_moving()
	monster.shake_camera(3.0, 45)
	helper_56d63eae()
	monster.set_motion("構え立ち", -1, 0)
end

--- Helper function.
local function helper_1311c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local value: s32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	monster.set_motion("構え立ち", -1, 0)
	helper_1283c(1)
	monster.set_motion("攻撃２", -1, 6)
	helper_754712d9(vm.f32(4.2), helper_9df6409a(23))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol_r")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	pos_y = 0.0
	value = 0
	monster.get_random(100)
	value = 1
	var9 = monster.get_random_whole_number(0.25) or var9
	var9 = vm.f32(var9 + vm.f32(0.2))
	monster.create_effect_1("グリＳＷＦ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7, var8)
	monster.create_effect_1("グリＳＷＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7, var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, var9)
	monster.set_effect_value(-1, 2, value)
	monster.set_effect_value(-1, 3, 0)
	monster.set_effect_value_float(-1, 4, -1.5707964)
	helper_754712d9(vm.f32(4.2), helper_9df6409a(24))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol_l")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	pos_y = 0.0
	value = 0
	monster.get_random(100)
	value = 1
	var9 = monster.get_random_whole_number(0.25) or var9
	var9 = vm.f32(var9 + vm.f32(0.2))
	monster.create_effect_1("グリＳＷＦ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7, var8)
	monster.create_effect_1("グリＳＷＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7, var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, var9)
	monster.set_effect_value(-1, 2, value)
	monster.set_effect_value(-1, 3, 0)
	monster.set_effect_value_float(-1, 4, 1.5707964)
	helper_56d63eae()
	monster.set_motion("構え立ち", -1, 0)
	helper_1283c(9)
end

--- Helper function.
local function helper_15448()
	local var0: f32 = 0
	local argc: s32 = 0
	print("far range--------------------\n")
	var0 = monster.get_target_distance() or var0
	if var0 > 650.0 then
		monster.set_motion("構え歩き", -1, 0)
		helper_890ee63a(vm.f32(4.2))
		helper_142c4()
	end
	argc = monster.get_random(100) or argc
	if argc < 85 then
		monster.set_motion("構え歩き", -1, 0)
		helper_890ee63a(vm.f32(4.2))
		helper_1311c()
	else
		monster.set_motion("構え歩き", -1, 0)
		helper_b9b0f992(2.0, vm.f32(4.2), 55.0, 90)
		monster.set_motion("構え立ち", -1, 0)
	end
end

--- Helper function.
local function helper_12b74()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	helper_1283c(1)
	monster.set_motion("攻撃１", -1, 6)
	helper_754712d9(vm.f32(4.2), helper_9df6409a(38))
	monster.shake_camera(3.0, helper_9df6409a(45))
	do
		local out1, out2, out3 = monster.get_position_3()
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
	monster.create_effect_1("グリ衝撃波")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.set_effect_value(-1, 0, attack)
	helper_56d63eae()
	monster.set_motion("構え立ち", -1, 0)
	helper_1283c(9)
end

--- Helper function.
local function helper_14cf0()
	local argc: s32 = 0
	print("mid range---------------------\n")
	argc = monster.get_random(100) or argc
	if argc < 65 then
		argc = monster.get_random(100) or argc
		if argc < 15 then
			helper_12b74()
		else
			argc = monster.get_random(100) or argc
			if argc < 70 then
				monster.set_motion("構え歩き", -1, 0)
				helper_890ee63a(vm.f32(4.2))
				helper_1311c()
			else
				helper_142c4()
			end
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 70 then
			monster.set_motion("構え歩き", -1, 0)
			helper_f2cf0297(2.0, vm.f32(4.2), 55.0, 90)
			monster.set_motion("構え立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 30 then
				monster.set_motion("構え歩き", -1, 0)
				helper_890ee63a(vm.f32(4.2))
				helper_1311c()
			elseif argc > 30 and argc < 65 then
				monster.set_motion("構え歩き", -1, 0)
				helper_f2cf0297(2.0, vm.f32(4.2), 55.0, 90)
				monster.set_motion("構え立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_11738()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.set_motion("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(vm.f32(var4 + vm.f32(3.1415927))) * 200.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(vm.f32(var4 + vm.f32(3.1415927))) * 200.0))
	monster.set_motion("ステップ後", -1, 6)
	helper_c3e8ae39(helper_9df6409a(9))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	helper_c3e8ae39(helper_9df6409a(15))
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	helper_56d63eae()
	monster.set_motion("構え立ち", -1, 0)
end

--- Helper function.
local function helper_103c8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	monster.set_motion("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	var6 = monster.get_target_distance() or var6
	if var6 < 110.0 then
		var8 = 1
		var7 = vm.f32(3.6000001)
		do
			local _, out2, _ = monster.get_rotation()
			var4 = out2 or var4
		end
		var4 = vm.f32(var4 - vm.f32(1.5707964))
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(pos_x + vm.f32(vm.sin(var4) * 200.0))
		pos_z = vm.f32(pos_z + vm.f32(vm.cos(var4) * 200.0))
	else
		var8 = 0
		var6 = 85.0
		var7 = vm.f32(vm.fdiv(var6, helper_9df6409a(14)))
		pos_x, pos_y, pos_z = helper_125e5305(30.0, var6, pos_x, pos_y, pos_z)
	end
	monster.set_motion("ステップ右", -1, 6)
	helper_c3e8ae39(helper_9df6409a(10))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, var7, var7)
	if var8 ~= 0 then
		helper_c3e8ae39(helper_9df6409a(14))
	else
		helper_754712d9(vm.f32(4.2), helper_9df6409a(14))
	end
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_56d63eae()
	monster.set_motion("構え立ち", -1, 0)
end

--- Helper function.
local function helper_10d68()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var8: s32 = 0
	monster.set_motion("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	var6 = monster.get_target_distance() or var6
	if var6 < 110.0 then
		var8 = 1
		do
			local _, out2, _ = monster.get_rotation()
			var4 = out2 or var4
		end
		var4 = vm.f32(var4 + vm.f32(1.5707964))
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(pos_x + vm.f32(vm.sin(var4) * 200.0))
		pos_z = vm.f32(pos_z + vm.f32(vm.cos(var4) * 200.0))
	else
		var8 = 0
		var6 = 85.0
		pos_x, pos_y, pos_z = helper_125e5305(-30.0, var6, pos_x, pos_y, pos_z)
	end
	monster.set_motion("ステップ左", -1, 6)
	helper_c3e8ae39(helper_9df6409a(10))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	if var8 ~= 0 then
		helper_c3e8ae39(helper_9df6409a(14))
	else
		helper_754712d9(vm.f32(4.2), helper_9df6409a(14))
	end
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_56d63eae()
	monster.set_motion("構え立ち", -1, 0)
end

--- Helper function.
local function helper_14934()
	local var0: f32 = 0
	local var1: f32 = 0
	local argc: s32 = 0
	print("near range---------------------\n")
	argc = monster.get_random(100) or argc
	if argc < 70 then
		argc = monster.get_random(100) or argc
		if argc < 85 then
			helper_12b74()
		else
			argc = monster.get_random(100) or argc
			if argc < 90 then
				helper_1311c()
			else
				helper_142c4()
			end
		end
	elseif var0 < 110.0 then
		helper_11738()
	else
		monster.get_target_angle(var1)
		if var1 < 0.0 then
			helper_103c8()
		else
			helper_10d68()
		end
	end
end

--- Helper function.
local function helper_15848()
	local var0: f32 = 0
	var0 = monster.get_target_distance() or var0
	if var0 < 9999.0 and var0 >= 300.0 then
		helper_15448()
	elseif var0 < 300.0 and var0 >= 120.0 then
		helper_14cf0()
	else
		helper_14934()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local chara_type: s32 = 0
	local slot: s32 = 0
	monster.register_damage_hit("吹っ飛び強", 7.4, "攻撃３", 0.578, 0.627, 0)
	monster.register_damage_hit("吹っ飛び強", 7.4, "攻撃３", 0.578, 0.627, 1)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.107, 0.214, 0)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.221, 0.279, 1)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.286, 0.336, 0)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.343, 0.4, 1)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.407, 0.457, 0)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.464, 0.543, 1)
	monster.register_damage_hit("グリコンボ２", 20.0, "攻撃４", 0.636, 0.707, 0)
	monster.load_effect_script("グリコンボ")
	monster.load_effect_script("グリＳＷＦ")
	monster.load_effect_script("グリＳＷＬ")
	monster.load_effect_script("グリ衝撃波")
	monster.load_effect_script("グリ炎")
	chara_type = monster.get_character_number() or chara_type
	slot = monster.create_effect_2("グリ炎") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_variable(6, slot)
	monster.set_clip_distance(9999.9)
	monster.set_camera_mode(4)
	monster.set_life(0.34)
	monster.set_variable(5, 0)
	monster.set_variable(7, 0)
	helper_1c54()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("構え立ち", -1, 4)
	while true do
		vm.wait()
		helper_15848()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(helper_9df6409a(12))
	monster.set_motion("構え立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d8cf1050()
	helper_6a21fe95()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local argc: s32 = 0
	local var1: f32 = 0
	helper_49610f43()
	vm.wait()
	argc = monster.get_random(100) or argc
	if argc < 70 then
		helper_11738()
	else
		var1 = monster.get_target_angle() or var1
		if var1 < 0.0 then
			helper_103c8()
		else
			helper_10d68()
		end
	end
	monster.set_motion("構え立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local argc: s32 = 0
	local var1: f32 = 0
	helper_49610f43()
	argc = monster.get_random(100) or argc
	if argc < 70 then
		monster.set_motion("構え歩き", -1, 0)
		helper_890ee63a(vm.f32(4.2))
		helper_1311c()
	else
		var1 = monster.get_target_angle() or var1
		if var1 > vm.f32(3.1415927) then
			var1 = vm.f32(var1 - vm.f32(6.2831855))
		end
		if var1 <= vm.f32(-3.1415927) then
			var1 = vm.f32(var1 + vm.f32(6.2831855))
		end
		if var1 < 0.0 then
			helper_103c8()
		else
			helper_10d68()
		end
		helper_1311c()
	end
	monster.set_motion("構え立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	local value: s32 = 0
	helper_02ce7891()
	monster.stop_sound(2)
	monster.stop_sound(3)
	monster.stop_sound(4)
	monster.stop_sound(5)
	monster.stop_sound(6)
	monster.stop_sound(7)
	monster.stop_sound(23)
	value = monster.get_variable(6) or value
	monster.finish_effect(value)
	monster.request_event_script(502)
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
