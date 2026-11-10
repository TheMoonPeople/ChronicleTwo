--!strict
-- dungeon/monster/b253a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0682d2de = require("@lib/monster/helper_0682d2de")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_211db10d = require("@lib/monster/helper_211db10d")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_ba87ea88 = require("@lib/monster/helper_ba87ea88")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d742309a = require("@lib/monster/helper_d742309a")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
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
local function helper_b7d8(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
	local var6: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: s32 = 0
	var6, target_2, target_3 = helper_125e5305(arg2, arg3, var6, target_2, target_3)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	arg2 = monster.get_angle_to_position(var6, target_2, target_3) or arg2
	if arg2 > vm.f32(3.1415927) then
		arg2 = vm.f32(arg2 - vm.f32(6.2831855))
	end
	if arg2 <= vm.f32(-3.1415927) then
		arg2 = vm.f32(arg2 + vm.f32(6.2831855))
	end
	helper_179581d3(helper_28452e16(arg2), arg1)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.copy_vector(var6, target_2, target_3) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var15, var16, var17, pos_x, pos_y, pos_z)
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var15, var16, var17)
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	var18 = monster.get_clear_distance(100.0, 0.0) or var18
	if var18 < 100.0 then
		var6 = vm.f32(pos_x + vm.f32(vm.sin(arg2) * var18))
		target_2 = pos_y
		target_3 = vm.f32(pos_z + vm.f32(vm.cos(arg2) * var18))
		var18 = vm.f32(var18 - arg4)
		if var18 < arg4 then
			return -1
		end
	end
	monster.move_toward_position(var6, pos_y - 20.0, target_3, arg0, arg0)
	var19 = helper_0682d2de(arg4, arg5)
	monster.stop_moving()
	return var19
end

--- Helper function.
local function helper_12288()
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
		local _ = helper_b7d8(6.0, vm.f32(4.2), var3, var4, 60.0, 30)
		helper_83e135e0(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(60.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_8784(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var6: f32 = 0
	local pos_y: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var18: s32 = 0
	helper_83e135e0(rot_speed)
	rot_speed = helper_787df986(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	var18 = 0
	while var18 < arg3 do
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
		helper_b9fff8e1()
		var18 = var18 + 1
		monster.stop_moving()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_133f8()
	monster.set_motion("歩き", 0.45, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("歩き", -1.0, 0)
	helper_8784(6.0, vm.f32(4.2), 60.0, 45)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_131a0()
	monster.get_life()
	monster.set_motion("歩き", 0.45, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("歩き", -1.0, 0)
	helper_8784(6.0, vm.f32(4.2), 60.0, 45)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_116d8()
	monster.set_motion("歩き", 0.45, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("攻撃１", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(3)
end

--- Helper function.
local function helper_118e0()
	monster.set_motion("歩き", 0.45, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 6)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(3)
end

--- Helper function.
local function helper_11ae8(arg0: any)
	local chara_type: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	monster.set_motion("歩き", -1, 0)
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
	monster.move_toward_position(pos_x, pos_y, pos_z, 6.4, 6.4)
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
local function helper_12dd4()
	local argc: s32 = 0
	local var3: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 70 then
		argc = monster.get_random(100) or argc
		if argc < 70 then
			var3 = monster.get_target_distance() or var3
			if var3 < 60.0 then
				helper_116d8()
			else
				helper_118e0()
			end
		else
			helper_11ae8(45)
		end
	else
		monster.set_motion("歩き", -1, 0)
		helper_8784(6.0, vm.f32(4.2), 60.0, 90)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_13614()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		monster.get_life()
		var0 = monster.get_target_distance() or var0
		if var0 > 800.0 then
			helper_b9fff8e1()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			helper_12288()
			continue
		end
		if var0 < 800.0 and var0 >= 280.0 then
			helper_133f8()
		elseif var0 < 280.0 and var0 >= 160.0 then
			helper_131a0()
		else
			helper_12dd4()
		end
	end
end

--- Helper function.
local function helper_14838()
	monster.set_motion("歩き", -1, 0)
	helper_8784(6.0, vm.f32(4.2), 60.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_149ac()
	local var0: f32 = 0
	local var1: f32 = 0
	var0 = monster.get_target_distance() or var0
	if helper_a25c5b2e() == 0 then
		if var0 < 800.0 then
			helper_13614()
		else
			monster.set_motion("歩き", -1, 0)
			helper_8784(6.0, vm.f32(4.2), 60.0, 90)
			monster.set_motion("立ち", -1, 0)
		end
	else
		var1 = helper_243517f2(var1)
		if var0 < var1 then
			if var0 < 280.0 then
				helper_65eb2b74(0)
				helper_13614()
			else
				helper_14838()
			end
		else
			helper_65eb2b74(0)
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("吹っ飛び弱", 7.4, "攻撃１", 0.325, 0.375, 1)
	monster.register_damage_hit("吹っ飛び弱", 7.4, "攻撃２", 0.319, 0.421, 0)
	monster.register_damage_hit("吹っ飛び弱", 7.4, "攻撃３loop", 0.0, 1.0, 0)
	monster.register_damage_hit("吹っ飛び弱", 7.4, "攻撃３loop", 0.0, 1.0, 1)
	monster.load_effect_script("スピン")
	monster.set_variable(0, 0)
	monster.set_variable(0, 0)
	helper_2f8c()
	monster.set_clip_distance(999999.9)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local var4: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	value = monster.get_variable(0) or value
	if value == 0 then
		monster.set_motion("立ち", -1, 0)
		while true do
			var4 = monster.get_target_distance() or var4
			if var4 < 500.0 then
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
		helper_149ac()
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
