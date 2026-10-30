--!strict
-- dungeon/monster/e28a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_04a561a4 = require("@lib/monster/helper_04a561a4")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_19658e9b = require("@lib/monster/helper_19658e9b")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1e395517 = require("@lib/monster/helper_1e395517")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_211db10d = require("@lib/monster/helper_211db10d")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_3403c83a = require("@lib/monster/helper_3403c83a")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_4a39d2ab = require("@lib/monster/helper_4a39d2ab")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_9845a57a = require("@lib/monster/helper_9845a57a")
local helper_9bf4b719 = require("@lib/monster/helper_9bf4b719")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ade2dbe2 = require("@lib/monster/helper_ade2dbe2")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b765e6cd = require("@lib/monster/helper_b765e6cd")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_ba87ea88 = require("@lib/monster/helper_ba87ea88")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d742309a = require("@lib/monster/helper_d742309a")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")
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
local function helper_14008()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 75.0)
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
local function helper_13640()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(7.2000003))
	monster.set_motion("走り", -1, 0)
	helper_e1c3e640(vm.f32(7.8), vm.f32(7.2000003), 30.0, 75)
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.775, 2.775)
	monster.set_motion("攻撃１", -1, 2)
	helper_19658e9b(vm.f32(4.8), vm.f32(0.315), -1.0)
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
	monster.move_toward_position(pos_x, pos_y - 20.0, pos_z, 5.55, 5.55)
	helper_4a39d2ab(vm.f32(0.595), -1.0)
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(9)
end

--- Helper function.
local function helper_12eb0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(7.2000003))
	monster.set_motion("走り", -1, 0)
	helper_e1c3e640(vm.f32(7.8), vm.f32(7.2000003), 30.0, 75)
	monster.set_motion("攻撃１", -1, 2)
	helper_19658e9b(vm.f32(4.8), vm.f32(0.315), -1.0)
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
	monster.move_toward_position(pos_x, pos_y - 20.0, pos_z, 5.55, 5.55)
	helper_4a39d2ab(vm.f32(0.595), -1.0)
	monster.stop_moving()
	var6 = monster.get_target_angle() or var6
	monster.turn_toward_angle(var6, helper_787df986(vm.f32(7.2000003)))
	monster.set_motion("攻撃２", -1, 2)
	helper_cbe4d8e2()
	helper_442b9962()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(9)
end

--- Helper function.
local function helper_15e3c()
	local argc: s32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			helper_13640()
		else
			helper_12eb0()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 25 then
			monster.set_motion("歩き", -1, 0)
			helper_e1c3e640(1.75, vm.f32(4.8), 75.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			helper_e62edeb2(30.0, 45.0, 75)
		end
	end
end

--- Helper function.
local function helper_157a8()
	local argc: s32 = 0
	local var6: f32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 40 then
		argc = monster.get_random(100) or argc
		if argc < 60 then
			helper_13640()
		else
			helper_12eb0()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 30 then
			monster.set_motion("歩き", -1, 0)
			helper_e1c3e640(1.75, vm.f32(4.8), 30.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			var6 = monster.get_random_whole_number(60.0) or var6
			if argc < 50 then
				var6 = vm.f32(-var6 - 30.0)
			else
				var6 = vm.f32(var6 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			helper_bfbcfc9f(1.75, vm.f32(4.8), var6, 60.0, 1.0, 25)
			helper_83e135e0(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			helper_ee5b84d4(9)
		end
	end
end

--- Helper function.
local function helper_128cc()
	local var3: s32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	helper_e1c3e640(1.75, vm.f32(7.2000003), 30.0, 75)
	helper_83e135e0(vm.f32(9.6))
	monster.set_motion("攻撃１", -1, 2)
	var3 = helper_b765e6cd(vm.f32(9.6), helper_9df6409a(9))
	if var3 < helper_9df6409a(15) then
		helper_ee5b84d4(helper_9df6409a(vm.i32(15 - var3)))
	end
	helper_442b9962()
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(9)
end

--- Helper function.
local function helper_14d44()
	local argc: s32 = 0
	local var4: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 70 then
		argc = monster.get_random(100) or argc
		if argc < 85 then
			monster.set_motion("歩き", -1, 0)
			helper_e1c3e640(1.75, vm.f32(4.8), 30.0, 60)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				helper_128cc()
			else
				helper_04a561a4()
			end
			monster.set_motion("立ち", -1, 0)
		else
			helper_3403c83a()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 60 then
			argc = monster.get_random(100) or argc
			var4 = monster.get_random_whole_number(60.0) or var4
			if argc < 50 then
				var4 = vm.f32(-var4 - 30.0)
			else
				var4 = vm.f32(var4 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			helper_bfbcfc9f(1.75, vm.f32(4.8), var4, 60.0, 1.0, 25)
			helper_83e135e0(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			helper_ee5b84d4(9)
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
				helper_9845a57a()
				monster.set_motion("立ち", -1, 0)
				helper_ee5b84d4(9)
			else
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
				helper_9bf4b719()
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_16274()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		monster.get_life()
		helper_ade2dbe2()
		var0 = monster.get_target_distance() or var0
		if var0 > 280.0 then
			helper_b9fff8e1()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin <= 0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_14008()
			continue
		end
		if var0 < 280.0 and var0 >= 180.0 then
			helper_15e3c()
		elseif var0 < 180.0 and var0 >= 75.0 then
			helper_157a8()
		else
			helper_14d44()
		end
	end
end

--- Helper function.
local function helper_17f30()
	local var0: s32 = 0
	monster.set_motion("走り", -1, 0)
	var0 = helper_e1c3e640(vm.f32(7.8), vm.f32(4.8), 30.0, 120)
	if var0 == -1 then
		helper_128cc()
	end
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_144e8()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	monster.get_life()
	while true do
		helper_b9fff8e1()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 5 then
			helper_14008()
			continue
		end
		var3 = monster.get_target_distance() or var3
		if var3 < 75.0 then
			argc = monster.get_random(100) or argc
			if argc < 80 then
				argc = monster.get_random(100) or argc
				if argc < 80 then
					helper_3403c83a()
				else
					helper_12eb0()
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_e1c3e640(1.75, vm.f32(9.6), 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 80 then
				argc = monster.get_random(100) or argc
				if argc < 70 then
					helper_12eb0()
				else
					helper_13640()
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_83e135e0(vm.f32(7.2000003))
				monster.set_motion("走り", -1, 0)
				helper_e1c3e640(vm.f32(7.8), vm.f32(4.8), 30.0, 75)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_1811c()
	local var0: f32 = 0
	local var1: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		helper_ade2dbe2()
		var0 = monster.get_target_distance() or var0
		if helper_a25c5b2e() == 0 then
			if var0 < 280.0 then
				helper_16274()
			else
				helper_1e395517()
			end
		else
			var1 = helper_243517f2(var1)
			if var0 < var1 then
				if var0 < 180.0 then
					helper_65eb2b74(0)
					helper_16274()
				else
					helper_17f30()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_144e8()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.505, 0.675, 0, 3)
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.505, 0.675, 1, 2)
	monster.register_damage_hit("Ｍ連撃２", 2.0, "攻撃２", 0.222, 0.335, 1, 2)
	monster.register_damage_hit("Ｍ連撃２", 2.0, "攻撃２", 0.467, 0.578, 0, 3)
	monster.set_variable(0, 0)
	helper_3048()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_b9fff8e1()
		helper_1811c()
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
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(24.0)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_ee5b84d4(60)
	monster.set_motion("ガードout", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("立ち")
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, var0, 0.0)
	helper_b9fff8e1()
	helper_9845a57a()
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, var0, 0.0)
	helper_b9fff8e1()
	helper_9bf4b719()
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	monster.set_motion("死に", -1, 6)
	helper_cbe4d8e2()
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
	monster.set_motion("吹っ飛び", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("起き上がり", -1, 6)
	helper_cbe4d8e2()
	helper_e05438b5()
end

return script
