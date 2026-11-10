--!strict
-- dungeon/monster/b13b.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d742309a = require("@lib/monster/helper_d742309a")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

--- Helper function.
local function helper_1fb0()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Runs the monster's death.
local function on_death()
	monster.stop_moving()
	helper_442b9962()
	monster.start_death()
	monster.set_monster_attributes(2, 1)
	monster.set_motion("死亡", 6)
	helper_56d63eae()
	monster.set_motion("死亡とめ", 0)
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Helper function.
local function helper_1b2c()
	local value: s32 = 0
	value = monster.get_variable(64) or value
	if value ~= 0 then
		on_death()
	end
end

--- Helper function.
local function helper_1cc8()
	helper_1b2c()
	vm.wait()
end

--- Helper function.
local function helper_2e6c(arg0: f32, arg1: f32, arg2: f32)
	local var4: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	var8 = arg2
	if arg1 < 3.0 then
		var9 = helper_787df986(3.0)
	else
		var9 = arg1
	end
	var7 = 0.0
	while var7 < var8 do
		do
			local _, out2, _ = monster.get_rotation()
			var4 = out2 or var4
		end
		if var4 > vm.f32(arg0 - var9) and var4 < vm.f32(arg0 + var9) then
			helper_442b9962()
			break
		elseif helper_8971d3b6(arg0, var4, arg1) == 0 then
			helper_442b9962()
			break
		elseif var7 >= arg2 then
			helper_442b9962()
			break
		else
			helper_1cc8()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_5d94(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.get_target_angle() or var5
	local _ = helper_2e6c(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_7670(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	helper_5d94(rot_speed)
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
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.get_rotation()
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_target_position()
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
		do
			local out1, out2, out3 = monster.scale_vector(var15, var16, var17, arg0 + arg2)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.add_vectors(var15, var16, var17, pos_x, pos_y, pos_z)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		monster.move_toward_position(var15, pos_y - 20.0, var17, arg0, arg0)
		helper_1cc8()
		var18 = var18 + 1
		monster.stop_moving()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_c2e4(rot_speed: f32)
	local var1: f32 = 0
	local var2: s32 = 0
	rot_speed = helper_787df986(rot_speed)
	while true do
		var1 = monster.get_target_angle() or var1
		monster.turn_toward_angle(var1, rot_speed)
		helper_1cc8()
		var2 = monster.is_motion_finished() or var2
		if var2 ~= 0 then
			helper_442b9962()
			break
		end
	end
end

--- Helper function.
local function helper_1131c()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("遊び", -1, 0)
		helper_c2e4(4.0)
	end
end

--- Helper function.
local function helper_1d48(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_1cc8()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_119fc()
	monster.set_motion("攻撃２", -1, 2)
	helper_c2e4(4.0)
	monster.set_motion("歩き", -1, 0)
	helper_5d94(4.0)
	helper_1131c()
	monster.set_motion("立ち", -1, 0)
	helper_1d48(9)
end

--- Helper function.
local function helper_1e88()
	local var0: s32 = 0
	while true do
		helper_1cc8()
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_10c80()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
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
	var6 = vm.f32(var4 + vm.f32(3.1415927))
	if var6 > vm.f32(3.1415927) then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if var6 <= vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var6) * 200.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var6) * 200.0))
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y - 30.0, pos_z, 4.2, 4.2)
	helper_1d48(helper_9df6409a(15))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_1e88()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_1079c(arg0: f32, arg1: s32)
	local target: f32 = 0
	local var3: f32 = 0
	local target_3: f32 = 0
	local var5: f32 = 0
	if arg1 ~= 0 then
		monster.set_motion("ステップ右", -1, 6)
		var5 = -45.0
	else
		monster.set_motion("ステップ左", -1, 6)
		var5 = 45.0
	end
	target, var3, target_3 = helper_125e5305(var5, arg0, target, var3, target_3)
	helper_1d48(helper_9df6409a(4))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target, var3 - 30.0, target_3, 4.2, 4.2)
	helper_1d48(helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_1e88()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_12ce4()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 90 then
		monster.set_motion("走り", -1, 0)
		helper_7670(vm.f32(7.4), 4.0, 39.0, 60)
		helper_119fc()
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			helper_10c80()
		else
			var2 = 1
			var1 = monster.get_target_distance() or var1
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var2 = 0
			end
			helper_1079c(vm.f32(var1 + 30.0), var2)
		end
	end
end

--- Helper function.
local function helper_bc98(arg0: f32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local var4: f32 = 0
	local rot_speed: f32 = 0
	if arg2 == -1.0 then
		arg2 = vm.f32(0.05)
	end
	rot_speed = helper_787df986(arg0)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	while true do
		var3 = monster.get_target_angle() or var3
		monster.turn_toward_angle(var3, rot_speed)
		var4 = monster.get_motion_progress() or var4
		if var4 < vm.f32(arg1 + arg2) and var4 > vm.f32(arg1 - arg2) then
			break
		else
			helper_1cc8()
		end
	end
	helper_442b9962()
end

--- Helper function.
local function helper_11478()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.reset_motion()
	monster.set_motion("攻撃1", -1, 6)
	helper_bc98(4.0, vm.f32(0.63), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	monster.create_effect_1("ねばねばＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var4, var5, var6)
	monster.set_effect_value(-1, 0, attack)
	helper_c2e4(4.0)
	monster.set_motion("歩き", -1, 0)
	helper_5d94(4.0)
	helper_1131c()
	monster.set_motion("立ち", -1, 0)
	helper_1d48(9)
end

--- Helper function.
local function helper_13098()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 70 then
		monster.set_motion("歩き", -1, 0)
		helper_5d94(4.0)
		helper_11478()
	else
		monster.set_motion("走り", -1, 0)
		helper_7670(vm.f32(7.4), 4.0, 39.0, 60)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_51c4(next_rot: f32, rot_speed: f32)
	next_rot = helper_787df986(next_rot)
	if next_rot > vm.f32(3.1415927) then
		next_rot = vm.f32(next_rot - vm.f32(6.2831855))
	end
	if next_rot <= vm.f32(-3.1415927) then
		next_rot = vm.f32(next_rot + vm.f32(6.2831855))
	end
	rot_speed = helper_787df986(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(next_rot, rot_speed)
	local _ = helper_2e6c(
		helper_28452e16(next_rot),
		helper_28452e16(rot_speed),
		vm.f32(vm.fdiv(360.0, helper_28452e16(rot_speed)))
	)
	helper_442b9962()
end

--- Helper function.
local function helper_4354(arg0: f32, arg1: any)
	local var2: s32 = 0
	local arrived: s32 = 0
	local var4: f32 = 0
	var2 = 0
	while var2 < arg1 do
		arrived = monster.is_move_finished() or arrived
		var4 = monster.get_target_distance() or var4
		if var4 < arg0 then
			monster.stop_moving()
			return 1
		end
		if arrived == 0 then
			helper_1cc8()
		else
			monster.stop_moving()
			return 2
		end
		if arrived == 1 then
			monster.stop_moving()
			return 1
		end
		var2 = vm.i32(var2 + 1)
	end
	return 0
end

--- Helper function.
local function helper_aa48(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
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
	helper_51c4(helper_28452e16(arg2), arg1)
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
	var18 = monster.get_clear_distance(arg0 + arg4, 0.0) or var18
	if var18 < vm.f32(arg0 + arg4) then
		var6 = vm.f32(pos_x + vm.f32(vm.sin(arg2) * var18))
		target_2 = pos_y
		target_3 = vm.f32(pos_z + vm.f32(vm.cos(arg2) * var18))
		var18 = vm.f32(var18 - arg4)
		if var18 < arg4 then
			return
		end
	end
	monster.move_toward_position(var6, pos_y - 20.0, target_3, arg0, arg0)
	local _ = helper_4354(arg4, arg5)
	monster.stop_moving()
end

--- Helper function.
local function helper_13344()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 70 then
		monster.set_motion("走り", -1, 0)
		helper_7670(vm.f32(7.4), 4.0, 39.0, 60)
		monster.set_motion("立ち", -1, 0)
	else
		argc = monster.get_random(100) or argc
		var1 = monster.get_random_whole_number(30.0) or var1
		var2 = monster.get_random_whole_number(30.0) or var2
		var2 = monster.get_target_distance() or var2
		if argc < 50 then
			var1 = vm.f32(-var1 - 30.0)
		else
			var1 = vm.f32(var1 + 30.0)
		end
		monster.set_motion("走り", -1, 0)
		helper_aa48(vm.f32(7.4), 4.0, var1, var2, 39.0, 45)
		helper_5d94(4.0)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_138ac()
	local var0: f32 = 0
	var0 = monster.get_target_distance() or var0
	if var0 < 120.0 then
		helper_12ce4()
	elseif var0 < 300.0 then
		helper_13098()
	else
		helper_13344()
	end
end

--- Helper function.
local function helper_cfbc()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	helper_1cc8()
	monster.set_action_status(1)
end

--- Helper function.
local function helper_dc24()
	while true do
		helper_1cc8()
	end
end

--- Helper function.
local function helper_dcd4()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_1d48(10)
	monster.reset_motion()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("吹っ飛び中", 5.0, "攻撃２", 0.64, 0.72, 0)
	monster.set_monster_attributes(1, 1)
	monster.set_variable(0, 0)
	monster.set_model_lighting(0)
	monster.set_model_color(128.0, 128.0, 128.0, 0.0)
	monster.set_model_lighting(1)
	helper_1fb0()
	monster.set_clip_distance(999999.9)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local height: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(32, 0)
	monster.set_invulnerable_time(0)
	value = monster.get_variable(0) or value
	if value == 0 then
		monster.set_motion("落下", -1, 0)
		monster.set_mask_flags(1, 1)
		monster.set_mask_flags(2, 1)
		for var1 = 0, 119 do
			if var1 > 9 then
				height = monster.get_height_above_ground() or height
				if height < 30.0 then
					monster.set_motion("着地", -1, 6)
					helper_56d63eae()
					break
				end
			end
			helper_1cc8()
		end
		monster.set_motion("立ち", -1, 0)
		monster.get_height_above_ground(height)
		monster.set_variable(0, 1)
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
	end
	monster.set_motion("立ち", -1, 0)
	monster.set_monster_attributes(16, 0)
	while true do
		helper_1cc8()
		helper_138ac()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.set_motion("ダメージ正", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_1e88()
	helper_1d48(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_cfbc()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(6.0, 0.05, 30)
	helper_1e88()
	monster.set_action_status(1)
	helper_1d48(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_1e88()
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	local var0: f32 = 0
	helper_ab4b367a()
	var0 = monster.get_target_angle() or var0
	monster.set_rotation(0.0, var0, 0.0)
	monster.reset_motion()
	monster.set_motion("ガード入り", -1, 6)
	helper_1e88()
	monster.set_motion("ガードループ", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_1d48(30)
	monster.set_motion("ガード戻り", -1, 6)
	helper_1e88()
	monster.set_motion("立ち", 0)
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

script.on_death = on_death

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_d742309a()
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_1cc8()
	end
	helper_dc24()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_dcd4()
	monster.stop_moving()
	monster.end_throw()
	helper_1d48(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_1e88()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_1e88()
	monster.set_motion("起き上がり", -1, 6)
	helper_1e88()
	helper_e05438b5()
end

return script
