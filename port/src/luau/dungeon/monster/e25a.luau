--!strict
-- dungeon/monster/e25a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0682d2de = require("@lib/monster/helper_0682d2de")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_19658e9b = require("@lib/monster/helper_19658e9b")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1e395517 = require("@lib/monster/helper_1e395517")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57db7062 = require("@lib/monster/helper_57db7062")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ade2dbe2 = require("@lib/monster/helper_ade2dbe2")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_ba87ea88 = require("@lib/monster/helper_ba87ea88")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")

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
local function helper_14cc0()
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
		local _ = helper_bfbcfc9f(1.75, vm.f32(4.8), var3, var4, 30.0, 30)
		helper_83e135e0(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(30.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_11d20(arg0: f32)
	local var1: f32 = 0
	var1 = monster.get_target_angle() or var1
	if var1 > vm.f32(3.1415927) then
		var1 = vm.f32(var1 - vm.f32(6.2831855))
	end
	if var1 <= vm.f32(-3.1415927) then
		var1 = vm.f32(var1 + vm.f32(6.2831855))
	end
	if var1 < 0.0 then
		monster.set_motion("歩き右", -1, 0)
	else
		monster.set_motion("歩き左", -1, 0)
	end
	helper_83e135e0(arg0)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_14628(arg0: f32)
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local grade: s32 = 0
	argc = monster.get_monster_count() or argc
	if argc >= 20 then
		return
	end
	helper_11d20(vm.f32(4.8))
	monster.set_motion("攻撃２in", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("攻撃２", -1, 0)
	helper_ee5b84d4(arg0)
	monster.set_motion("攻撃２out", -1, 6)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var6 = out2 or var6
	end
	monster.create_effect_1("Ｍ煙")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_value_float(-1, 0, 1.0)
	grade = monster.get_monster_grade_2(-1) or grade
	monster.create_monster(vm.i32(1002 + grade), pos_x, pos_y, pos_z, var6)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(9)
end

--- Helper function.
local function helper_1628c()
	local argc: s32 = 0
	local var1: s32 = 0
	local var5: f32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 45 then
		helper_14628(4.2e-44) -- retail: the integer 30 is passed where the callee reads a float, so it reads its bits
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			var5 = monster.get_random_whole_number(60.0) or var5
			if argc < 50 then
				var5 = vm.f32(-var5 - 30.0)
			else
				var5 = vm.f32(var5 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			helper_bfbcfc9f(1.75, vm.f32(4.8), var5, 60.0, 1.0, 25)
			helper_83e135e0(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			helper_ee5b84d4(9)
		else
			monster.set_motion("立ち", -1, 0)
			var1 = helper_57db7062(270.0, 60.0, 100.0, vm.f32(1.2), 60)
			if var1 == 1 then
				helper_11d20(vm.f32(4.8))
				helper_14628(8.4e-44) -- retail: the integer 60 is passed where the callee reads a float, so it reads its bits
			end
		end
	end
end

--- Helper function.
local function helper_13eec()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	local var9: f32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_variable(0, 1)
	helper_11d20(vm.f32(4.8))
	monster.set_motion("攻撃１", -1, 6)
	helper_19658e9b(vm.f32(4.8), vm.f32(0.09), -1.0)
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var9 = out2 or var9
	end
	do
		local out1, out2, out3 = monster.copy_vector(vm.sin(var9), 0.0, vm.cos(var9))
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var3, var4, var5)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("高速弾")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, 10.0)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(9)
end

--- Helper function.
local function helper_12bb0(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var8 = out2 or var8
	end
	var14 = vm.f32(var8 + vm.f32(3.1415927))
	if var14 > vm.f32(3.1415927) then
		var14 = vm.f32(var14 - vm.f32(6.2831855))
	end
	if var14 <= vm.f32(-3.1415927) then
		var14 = vm.f32(var14 + vm.f32(6.2831855))
	end
	var13 = monster.get_clear_distance(80.0, 3.1415927) or var13
	if var13 < 80.0 then
		arg1 = vm.f32(arg1 - var13)
		if arg1 < arg2 then
			return -1
		end
	end
	target = vm.f32(pos_x + vm.f32(vm.sin(var14) * arg1))
	target_2 = vm.f32(pos_y - 20.0)
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(var14) * arg1))
	monster.set_motion("歩き後", -1, 0)
	monster.move_toward_position(target, target_2, target_3, arg0, arg0)
	helper_0682d2de(arg2, arg3)
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
	return 0
end

--- Helper function.
local function helper_120b4(arg0: f32, arg1: f32)
	local var3: f32 = 0
	local var5: f32 = 0
	do
		local _, out2, _ = monster.get_rotation()
		var3 = out2 or var3
	end
	arg0 = helper_787df986(arg0)
	var5 = vm.f32(arg0 - var3)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	if var5 < 0.0 then
		monster.set_motion("歩き右", -1, 0)
	else
		monster.set_motion("歩き左", -1, 0)
	end
	helper_179581d3(arg0, arg1)
	helper_442b9962()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_15e0c()
	local argc: s32 = 0
	local var1: s32 = 0
	local var6: f32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 60 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			helper_13eec()
		else
			helper_14628(4.2e-44) -- retail: the integer 30 is passed where the callee reads a float, so it reads its bits
		end
	else
		var1 = helper_12bb0(1.75, 80.0, 30.0, 60)
		if var1 == -1 then
			argc = monster.get_random(100) or argc
			if argc < 40 then
				var6 = monster.get_random_whole_number(360.0) or var6
				helper_120b4(var6, vm.f32(4.8))
				helper_12bb0(1.75, 80.0, 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				helper_13eec()
			end
		end
	end
end

--- Helper function.
local function helper_15a64()
	local argc: s32 = 0
	local var1: s32 = 0
	local var4: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 25 then
		helper_13eec()
	else
		var1 = helper_12bb0(1.75, 80.0, 30.0, 60)
		if var1 == -1 then
			if argc < 60 then
				var4 = monster.get_random_whole_number(360.0) or var4
				helper_120b4(var4, vm.f32(4.8))
				helper_12bb0(1.75, 80.0, 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				helper_13eec()
			end
		end
	end
end

--- Helper function.
local function helper_168e0()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		monster.get_life()
		helper_ade2dbe2()
		var0 = monster.get_target_distance() or var0
		if var0 > 270.0 then
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
			helper_14cc0()
			continue
		end
		if var0 < 270.0 and var0 >= 160.0 then
			helper_1628c()
		elseif var0 < 160.0 and var0 >= 90.0 then
			helper_15e0c()
		else
			helper_15a64()
		end
	end
end

--- Helper function.
local function helper_178a4()
	monster.set_motion("歩き", -1, 0)
	helper_e1c3e640(1.75, vm.f32(4.8), 30.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_151a0()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local var6: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	monster.get_life()
	while true do
		helper_b9fff8e1()
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_14cc0()
			continue
		end
		if var3 < 90.0 then
			argc = monster.get_random(100) or argc
			if argc < 60 then
				helper_13eec()
			else
				var6 = helper_12bb0(1.75, 80.0, 30.0, 60)
				if var6 == -1 then
					if argc < 60 then
						var8 = monster.get_random_whole_number(360.0) or var8
						helper_120b4(var8, vm.f32(4.8))
						helper_12bb0(1.75, 80.0, 30.0, 60)
						monster.set_motion("立ち", -1, 0)
					else
						helper_13eec()
					end
				end
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 90 then
				argc = monster.get_random(100) or argc
				if argc < 50 then
					helper_13eec()
				else
					helper_14628(4.2e-44) -- retail: the integer 30 is passed where the callee reads a float, so it reads its bits
				end
			else
				var6 = helper_12bb0(1.75, 80.0, 30.0, 60)
				if var6 == -1 then
					argc = monster.get_random(100) or argc
					if argc < 40 then
						var9 = monster.get_random_whole_number(360.0) or var9
						helper_120b4(var9, vm.f32(4.8))
						helper_12bb0(1.75, 80.0, 30.0, 60)
						monster.set_motion("立ち", -1, 0)
					else
						helper_13eec()
					end
				end
			end
		end
	end
end

--- Helper function.
local function helper_17a18()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		helper_ade2dbe2()
		var0 = monster.get_target_distance() or var0
		if helper_a25c5b2e() == 0 then
			if var0 < 270.0 then
				helper_168e0()
			else
				helper_1e395517()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 270.0 then
					helper_65eb2b74(0)
					helper_168e0()
				else
					helper_178a4()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_151a0()
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
	monster.set_variable(0, 0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("高速弾", get_not_used_texb) or var1
		var2 = monster.load_effect_script("海賊爆弾爆発", get_not_used_texb) or var2
		monster.load_effect_script("Ｍ煙", get_not_used_texb) -- retail: output 1 points past the frame, at the operand stack, so the value is lost
		if (if var1 ~= 0 then 1 else var2) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	helper_2f8c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		helper_b9fff8e1()
		helper_17a18()
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
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

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
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_b9fff8e1()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_ba87ea88()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("ダメージ", -1, 6)
	helper_cbe4d8e2()
	helper_e05438b5()
end

return script
