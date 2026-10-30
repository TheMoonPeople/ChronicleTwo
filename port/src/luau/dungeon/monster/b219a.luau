--!strict
-- dungeon/monster/b219a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1aaed117 = require("@lib/monster/helper_1aaed117")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_3c99e866 = require("@lib/monster/helper_3c99e866")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_48852a90 = require("@lib/monster/helper_48852a90")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5743cba3 = require("@lib/monster/helper_5743cba3")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_7863d8b6 = require("@lib/monster/helper_7863d8b6")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_97663440 = require("@lib/monster/helper_97663440")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

--- Helper function.
local function helper_1ba0()
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
local function helper_a224(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
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
	helper_595cbf61(helper_28452e16(arg2), arg1)
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
	var19 = helper_7863d8b6(arg4, arg5)
	monster.stop_moving()
	return var19
end

--- Helper function.
local function helper_4b90(arg0: f32, arg1: f32)
	local var2: s32 = 0
	while true do
		helper_0ba23e4e()
		var2 = monster.is_motion_finished() or var2
		if var2 ~= 0 then
			return
		end
		if helper_5743cba3(arg0, arg1) == 1 then
			return
		end
	end
end

--- Helper function.
local function helper_101e4()
	local var0: s32 = 0
	monster.set_variable(1, 32)
	monster.set_motion("遊び", -1, 6)
	helper_4b90(49.0, 45.0)
	return var0
end

--- Helper function.
local function helper_10f40()
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
			var4 = vm.f32(var4 + 130.0)
			if argc < 50 then
				var3 = vm.f32(-var3 - 30.0)
			else
				var3 = vm.f32(var3 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = helper_a224(vm.f32(1.9), 3.0, var3, var4, 49.0, 30)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(49.0, 45.0, 30)
		end
	else
		helper_101e4()
	end
end

--- Helper function.
local function helper_71d0(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var6: f32 = 0
	local pos_y: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var18: s32 = 0
	helper_890ee63a(rot_speed)
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
		helper_0ba23e4e()
		var18 = var18 + 1
		monster.stop_moving()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_10370()
	monster.set_variable(1, 1)
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃１", -1, 2)
	helper_48852a90(3.0, vm.f32(0.267), -1.0)
	helper_56d63eae()
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_105fc()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local value: f32 = 0
	local attack: s32 = 0
	monster.set_variable(1, 2)
	value = 10.0
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃２", -1, 6)
	helper_48852a90(3.0, vm.f32(0.431), vm.f32(0.02))
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_frame_position("dcol_00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var6, var7, var8, pos_x, pos_y, pos_z)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("ドラゴン火弾Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y - 10.0, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.create_effect_1("ドラゴン火弾Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y - 5.0, pos_z)
	monster.set_effect_second_vector(-1, var6, var7, var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value)
	helper_3c99e866()
	monster.set_motion("立ち", -1, 0)
	helper_97663440(9)
end

--- Helper function.
local function helper_13310()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local life: f32 = 0
	local var4: f32 = 0
	life = 0.0
	var2 = monster.get_target_distance() or var2
	argc = monster.get_random(100) or argc
	if argc < 85 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			argc = monster.get_random(100) or argc
			if argc < 95 then
				life = monster.get_life() or life
				if life < 0.5 then
					monster.set_motion("走り", -1, 0)
					helper_71d0(4.5, 6.0, 130.0, 75)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					helper_71d0(vm.f32(1.9), 3.0, 130.0, 90)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_motion("立ち", -1, 0)
				helper_7ca8a12f(49.0, 45.0, 75)
			end
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
				helper_890ee63a(3.0)
				monster.set_motion("歩き", -1, 0)
				helper_a224(vm.f32(1.9), 3.0, var4, var2, 130.0, 45)
				monster.set_motion("歩き", -1, 0)
				helper_890ee63a(3.0)
				monster.set_motion("立ち", -1, 0)
				helper_7ca8a12f(49.0, 45.0, 30)
			else
				var1 = helper_101e4()
				if var1 == 1 then
					helper_10370()
				end
			end
		end
	else
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(3.0)
		helper_105fc()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_1284c()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local life: f32 = 0
	local var4: f32 = 0
	life = 0.0
	var2 = monster.get_target_distance() or var2
	argc = monster.get_random(100) or argc
	if argc < 70 then
		monster.get_random(100, argc)
		if argc < 75 then
			helper_105fc()
		else
			var1 = helper_101e4()
			if var1 == 1 then
				helper_10370()
			else
				helper_105fc()
			end
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 80 then
			life = monster.get_life() or life
			if life < vm.f32(0.3) then
				monster.set_motion("歩き", -1, 0)
				helper_890ee63a(3.0)
				monster.set_motion("走り", -1, 0)
				helper_71d0(4.5, 6.0, 49.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1, 0)
				helper_71d0(vm.f32(1.9), 3.0, 49.0, 90)
				monster.set_motion("立ち", -1, 0)
			end
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
				helper_890ee63a(3.0)
				monster.set_motion("歩き", -1, 0)
				helper_a224(vm.f32(1.9), 3.0, var4, var2, 1.0, 45)
				monster.set_motion("歩き", -1, 0)
				helper_890ee63a(3.0)
				monster.set_motion("立ち", -1, 0)
				helper_7ca8a12f(49.0, 45.0, 30)
			else
				helper_101e4()
			end
		end
	end
end

--- Helper function.
local function helper_11e78()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 40 then
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("走り", -1, 0)
			helper_71d0(4.5, 6.0, 49.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
		var3 = monster.get_target_distance() or var3
		argc = monster.get_random(100) or argc
		if var3 < 70.0 then
			helper_10370()
		else
			helper_105fc()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("走り", -1, 0)
			helper_71d0(4.5, 6.0, 49.0, 60)
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
			helper_a224(vm.f32(1.9), 3.0, var4, 98.0, 1.0, 25)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(9)
		end
	end
end

--- Helper function.
local function helper_13e80()
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
			helper_10f40()
			continue
		end
		if var0 < 280.0 and var0 >= 210.0 then
			helper_13310()
		elseif var0 < 210.0 and var0 >= 130.0 then
			helper_1284c()
		else
			helper_11e78()
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
	local var2: s32 = 0
	local var3: s32 = 0
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.267, 0.333, 1, 2)
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.644, 0.689, 3, 4)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("ドラゴン火弾Ｆ", get_not_used_texb) or var1
		var2 = monster.load_effect_script("ドラゴン火弾Ｌ", get_not_used_texb) or var2
		var3 = monster.load_effect_script("ドラゴン火弾Ｈ", get_not_used_texb) or var3
		if (if (if var1 ~= 0 then 1 else var2) ~= 0 then 1 else var3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.add_sword_trail(0, "攻撃１", 0.222, 0.226, "kiseki0", "kiseki1", 45, 20, 45)
	monster.add_sword_trail(1, "攻撃１", 0.622, 0.626, "kiseki2", "kiseki3", 45, 20, 45)
	monster.set_variable(1, 0)
	helper_1ba0()
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
			helper_13e80()
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("走り", -1, 0)
			helper_71d0(4.5, 6.0, 49.0, 60)
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
	monster.set_motion("ダメージ後", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d8cf1050()
	monster.set_motion("ダメージ後", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_c3e8ae39(8)
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
	helper_56d63eae()
	monster.spawn_death_effects()
	helper_c3e8ae39(30)
	helper_1aaed117()
	monster.request_event_script(502)
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
	monster.set_motion("ダメージ後", -1, 6)
	helper_56d63eae()
	helper_e05438b5()
end

return script
