--!strict
-- dungeon/monster/b08a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_adcbef14 = require("@lib/monster/helper_adcbef14")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

local global3: s32 = 0

--- Helper function.
local function helper_224c()
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
local function helper_18c8()
	local life: f32 = 0
	local value_4: s32 = 0
	local value_5: s32 = 0
	local value_6: s32 = 0
	local value_7: s32 = 0
	local argc: s32 = 0
	life = 1.0
	monster.get_variable(27)
	monster.get_variable(28)
	monster.get_variable(29)
	value_4 = monster.get_variable(24) or value_4
	value_5 = monster.get_variable(25) or value_5
	value_6 = monster.get_variable(26) or value_6
	value_7 = monster.get_variable(7) or value_7
	life = monster.get_life() or life
	argc = monster.get_monster_count() or argc
	if (argc <= 1 or life < vm.f32(0.67)) and value_7 == 0 then
		monster.set_variable(7, 1)
		monster.finish_effect(value_4)
		monster.finish_effect(value_5)
		monster.finish_effect(value_6)
		monster.set_monster_attributes(32, 1)
		monster.stop_sound(8)
		monster.request_event_script(500)
	end
end

--- Helper function.
local function helper_1e34()
	helper_18c8()
end

--- Helper function.
local function helper_1f64()
	helper_1e34()
	vm.wait()
end

--- Helper function.
local function helper_3108(arg0: f32, arg1: f32, arg2: f32)
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
			helper_1f64()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_5460(next_rot: f32, rot_speed: f32)
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
	local _ = helper_3108(
		helper_28452e16(next_rot),
		helper_28452e16(rot_speed),
		vm.f32(vm.fdiv(360.0, helper_28452e16(rot_speed)))
	)
	helper_442b9962()
end

--- Helper function.
local function helper_19a58(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: any)
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local scale: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var11, var12, var13, var8, var9, var10)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var11, var12, var13)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	var21 = monster.get_distance_between(arg0, arg1, arg2, var8, var9, var10) or var21
	var22 = helper_adcbef14(var21, arg3, vm.f32(vm.fdiv(vm.f32(vm.f32(var21 + arg5) * arg6), arg3)), var22)
	scale = arg3
	var23 = 0
	while var23 < arg7 do
		do
			local out1, out2, out3 = monster.get_position_3()
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		scale = vm.f32(scale + var22)
		do
			local out1, out2, out3 = monster.copy_vector(var11, var12, var13)
			var14 = out1 or var14
			var15 = out2 or var15
			var16 = out3 or var16
		end
		do
			local out1, out2, out3 = monster.scale_vector(var14, var15, var16, scale)
			var14 = out1 or var14
			var15 = out2 or var15
			var16 = out3 or var16
		end
		do
			local out1, out2, out3 = monster.add_vectors(var8, var9, var10, var14, var15, var16)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		if var9 > 70.0 then
			var9 = 70.0
		end
		if scale < 0.0 then
			return
		end
		var21 = monster.get_distance_between(arg0, arg1, arg2, var8, var9, var10) or var21
		if var21 < arg4 then
			return
		end
		var21 = monster.get_distance_between(0.0, 0.0, 0.0, var8, 0.0, var10) or var21
		if var21 > 500.0 then
			return
		end
		monster.set_position(var8, var9, var10)
		monster.copy_vector(var8, var9, var10)
		helper_1f64()
		var23 = vm.i32(var23 + 1)
	end
end

--- Helper function.
local function helper_1bdf4(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: s32)
	local pos_y: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local height: f32 = 0
	local var12: f32 = 0
	local argc: s32 = 0
	argc = monster.get_random(5) or argc
	if argc == 0 then
		target = vm.f32(-31.76)
		target_2 = 60.0
		target_3 = vm.f32(367.74)
	end
	if argc == 1 then
		target = vm.f32(362.27)
		target_2 = 60.0
		target_3 = vm.f32(2.72)
	end
	if argc == 2 then
		target = vm.f32(2.86)
		target_2 = 60.0
		target_3 = vm.f32(-380.83)
	end
	if argc == 3 then
		target = vm.f32(-383.43)
		target_2 = 60.0
		target_3 = vm.f32(-1.28)
	end
	if argc == 4 then
		target = vm.f32(388.58)
		target_2 = 60.0
		target_3 = vm.f32(5.07)
	end
	height = monster.get_height_above_ground() or height
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	height = vm.f32(pos_y - height)
	var12 = monster.get_angle_to_position(target, target_2, target_3) or var12
	helper_5460(helper_28452e16(var12), vm.f32(4.2))
	helper_19a58(target, vm.f32(height + arg2), target_3, arg0, arg0, arg3, vm.f32(1.9), arg4)
end

--- Helper function.
local function helper_6030(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.get_target_angle() or var5
	local _ = helper_3108(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_1b8ac(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: s32)
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local height: f32 = 0
	local pos_y: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	do
		local out1, _, out3 = monster.get_target_position()
		var12 = out1 or var12
		var14 = out3 or var14
	end
	var15 = vm.bits_float(monster.get_random(360.0)) or var15
	target = vm.f32(var12 + vm.f32(vm.sin(vm.f32(vm.f32(var15 / 180.0) * vm.f32(3.1415927))) * 125.0))
	target_3 = vm.f32(var14 + vm.f32(vm.cos(vm.f32(vm.f32(var15 / 180.0) * vm.f32(3.1415927))) * 125.0))
	height = monster.get_height_above_ground() or height
	height = vm.f32(pos_y - height)
	target_2 = vm.f32(height + arg2)
	var15 = monster.get_angle_to_position(target, target_2, target_3) or var15
	helper_5460(helper_28452e16(var15), vm.f32(4.2))
	helper_19a58(target, target_2, target_3, arg0, arg0, arg3, vm.f32(1.9), arg4)
	helper_6030(vm.f32(4.2))
end

--- Helper function.
local function helper_2124()
	local var0: s32 = 0
	while true do
		helper_1f64()
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_4fb8(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	if arg1 == -1.0 then
		arg1 = vm.f32(0.03)
	end
	var3 = 0
	while true do
		helper_1f64()
		var2 = monster.get_motion_progress() or var2
		if var2 < vm.f32(arg0 + arg1) and var2 > vm.f32(arg0 - arg1) then
			break
		else
			var4 = monster.is_motion_finished() or var4
			if var4 ~= 0 then
				break
			else
				var3 = vm.i32(var3 + 1)
			end
		end
	end
end

--- Helper function.
local function helper_c368(rot_speed: f32, arg1: s32)
	local var2: f32 = 0
	local _ = helper_787df986(rot_speed)
	for var4 = 0, arg1 - 1 do
		var2 = monster.get_target_angle() or var2
		monster.turn_toward_angle(var2, rot_speed)
		helper_1f64()
	end
	helper_442b9962()
end

--- Helper function.
local function helper_1c5d0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local attack: s32 = 0
	local var19: s32 = 0
	monster.set_variable(30, 1)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１in", -1, 2)
	helper_2124()
	monster.set_motion("攻撃１", -1, 6)
	helper_4fb8(vm.f32(0.262), -1.0)
	var19 = 0
	var16 = 0
	while var19 < 4 do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var9, var10, var11, pos_x, pos_y, pos_z)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var9, var10, var11)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var9, var10, var11)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var9, var10, var11)
		monster.set_effect_value(-1, 0, attack)
		helper_c368(vm.f32(4.2), helper_9df6409a(6))
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var9, var10, var11, pos_x, pos_y, pos_z)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var9, var10, var11)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(1.5707964)) * 20.0)
		)
		monster.set_effect_second_vector(-1, var9, var10, var11)
		monster.set_effect_value(-1, 0, attack)
		helper_c368(vm.f32(4.2), helper_9df6409a(6))
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var9, var10, var11, pos_x, pos_y, pos_z)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var9, var10, var11)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(-1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(-1.5707964)) * 20.0)
		)
		monster.set_effect_second_vector(-1, var9, var10, var11)
		monster.set_effect_value(-1, 0, attack)
		helper_c368(vm.f32(4.2), helper_9df6409a(6))
		var17 = monster.is_motion_finished() or var17
		if var17 ~= 0 then
			if var16 == 1 then
				monster.set_motion("飛び", -1, 0)
				var16 = var16 + 1
			end
			if var16 == 0 then
				monster.set_motion("攻撃１out", -1, 2)
				var16 = var16 + 1
			end
		end
		var19 = var19 + 1
	end
	if var16 == 0 then
		helper_2124()
		monster.set_motion("攻撃１out", -1, 2)
		helper_2124()
	end
end

--- Helper function.
local function helper_1fe4(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_1f64()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_1dbe4()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local attack: s32 = 0
	local var19: s32 = 0
	monster.set_variable(30, 1)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１in", -1, 2)
	helper_2124()
	monster.set_motion("攻撃１", -1, 6)
	helper_4fb8(vm.f32(0.262), -1.0)
	var19 = 0
	var16 = 0
	while var19 < 4 do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var9, var10, var11, pos_x, pos_y, pos_z)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var9, var10, var11)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var9, var10, var11)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var9, var10, var11)
		monster.set_effect_value(-1, 0, attack)
		helper_c368(vm.f32(4.2), 1)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var9, var10, var11, pos_x, pos_y, pos_z)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var9, var10, var11)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(1.5707964)) * 20.0)
		)
		monster.set_effect_second_vector(-1, var9, var10, var11)
		monster.set_effect_value(-1, 0, attack)
		helper_c368(vm.f32(4.2), 1)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var9, var10, var11, pos_x, pos_y, pos_z)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.normalize_vector(var9, var10, var11)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(-1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(-1.5707964)) * 20.0)
		)
		monster.set_effect_second_vector(-1, var9, var10, var11)
		monster.set_effect_value(-1, 0, attack)
		helper_c368(vm.f32(4.2), 6)
		var17 = monster.is_motion_finished() or var17
		if var17 ~= 0 then
			if var16 == 1 then
				monster.set_motion("飛び", -1, 0)
				var16 = var16 + 1
			end
			if var16 == 0 then
				monster.set_motion("攻撃１out", -1, 2)
				var16 = var16 + 1
			end
		end
		var19 = var19 + 1
	end
	if var16 == 0 then
		helper_2124()
		monster.set_motion("攻撃１out", -1, 2)
		helper_2124()
	end
end

--- Helper function.
local function helper_194ec()
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	local var3: s32 = 0
	var3 = 0
	while true do
		helper_18c8()
		value = monster.get_variable(27) or value
		value_2 = monster.get_variable(28) or value_2
		value_3 = monster.get_variable(29) or value_3
		if value == 32 and value_2 == 32 and value_3 == 32 then
			monster.set_invulnerable_time(9999)
			monster.set_model_lighting(0)
			if vm.imod(var3, 9) == 0 then
				monster.set_model_color(132, 132, 132, 128)
			end
			if vm.imod(var3, 9) == 2 then
				monster.set_model_color(128, 128, 128, 128)
			end
			if vm.imod(var3, 9) == 5 then
				monster.set_model_color(112, 112, 112, 128)
			end
		else
			break
		end
		helper_1f64()
		var3 = vm.i32(var3 + 1)
	end
end

--- Helper function.
local function helper_21014()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, pos_y, pos_z)
	monster.stop_moving()
	helper_1f64()
	monster.set_variable(30, 4)
	monster.set_motion("エネルギー吸収in", -1, 2)
	helper_2124()
	monster.set_motion("エネルギー吸収", -1, 0)
	helper_194ec()
	monster.set_model_lighting(1)
	monster.set_model_color(128, 128, 128, 128)
	monster.set_motion("エネルギー吸収out", 2)
	helper_2124()
	monster.set_invulnerable_time(0)
end

--- Helper function.
local function helper_18ae8()
	if vm.imod(global3, 6) == 0 then
		monster.set_model_color(164, 164, 164, 164)
	end
	if vm.imod(global3, 6) == 2 then
		monster.set_model_color(132, 132, 132, 132)
	end
	if vm.imod(global3, 6) == 4 then
		monster.set_model_color(112, 112, 112, 128)
	end
	global3 = vm.i32(global3 + 1)
end

--- Helper function.
local function helper_18da8(rot_speed: f32, arg1: s32)
	local var2: f32 = 0
	local _ = helper_787df986(rot_speed)
	for var4 = 0, arg1 - 1 do
		var2 = monster.get_target_angle() or var2
		monster.turn_toward_angle(var2, rot_speed)
		helper_18ae8()
		helper_1f64()
	end
	helper_442b9962()
end

--- Helper function.
local function helper_1f1d4()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local vector: f32 = 0
	local vector_2: f32 = 0
	local vector_3: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local argc: s32 = 0
	local var16: s32 = 0
	local attack: s32 = 0
	local var19: s32 = 0
	local argc_2: s32 = 0
	monster.set_variable(30, 2)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１in", -1, 2)
	helper_2124()
	monster.set_motion("攻撃１", 0.45, 0)
	helper_4fb8(vm.f32(0.262), -1.0)
	var19 = 0
	var16 = 0
	monster.set_model_lighting(0)
	argc_2 = 0
	argc_2 = monster.get_monster_count() or argc_2
	while var19 < vm.i32(vm.i32(vm.i32(argc_2 - 1) * 5) + 1) do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_l00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var12 = monster.get_random_whole_number(10.0) or var12
		var13 = monster.get_random_whole_number(0.2) or var13
		var14 = monster.get_random_whole_number(180.0) or var14
		argc = monster.get_random(2) or argc
		var12 = 12.0
		var12 = vm.f32(var12 + 6.0)
		var13 = vm.f32(var13 + vm.f32(0.15))
		var14 = vm.f32(var14 * -1.0)
		var14 = vm.f32(var14 - 90.0)
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, vector, vector_2, vector_3)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var12, var13, var14)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value(-1, 1, argc)
		helper_18da8(vm.f32(4.2), 2)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_l01")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var12 = monster.get_random_whole_number(10.0) or var12
		var13 = monster.get_random_whole_number(0.2) or var13
		var14 = monster.get_random_whole_number(180.0) or var14
		argc = monster.get_random(2) or argc
		var12 = 12.0
		var12 = vm.f32(var12 + 6.0)
		var13 = vm.f32(var13 + vm.f32(0.15))
		var14 = vm.f32(var14 * -1.0)
		var14 = vm.f32(var14 - 90.0)
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, vector, vector_2, vector_3)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var12, var13, var14)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value(-1, 1, argc)
		helper_18da8(vm.f32(4.2), 3)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_r00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var12 = monster.get_random_whole_number(10.0) or var12
		var13 = monster.get_random_whole_number(0.2) or var13
		var14 = monster.get_random_whole_number(180.0) or var14
		argc = monster.get_random(2) or argc
		var12 = 12.0
		var12 = vm.f32(var12 + 6.0)
		var13 = vm.f32(var13 + vm.f32(0.15))
		var14 = vm.f32(var14 - 90.0)
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, vector, vector_2, vector_3)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var12, var13, var14)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value(-1, 1, argc)
		helper_18da8(vm.f32(4.2), 2)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_r01")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var12 = monster.get_random_whole_number(10.0) or var12
		var13 = monster.get_random_whole_number(0.2) or var13
		var14 = monster.get_random_whole_number(180.0) or var14
		argc = monster.get_random(2) or argc
		var12 = 12.0
		var12 = vm.f32(var12 + 6.0)
		var13 = vm.f32(var13 + vm.f32(0.15))
		var14 = vm.f32(var14 - 90.0)
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, vector, vector_2, vector_3)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var12, var13, var14)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value(-1, 1, argc)
		helper_18da8(vm.f32(4.2), 3)
		helper_18da8(vm.f32(4.2), helper_9df6409a(9))
		var19 = var19 + 1
	end
	monster.set_model_lighting(1)
	if var16 == 0 then
		monster.set_motion("攻撃１out", -1, 2)
		helper_2124()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local chara_type: s32 = 0
	local get_not_used_texb: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	helper_224c()
	monster.set_visible_monster_limit(15)
	monster.set_monster_attributes(512, 1)
	monster.set_clip_distance(999999.9)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_camera_mode(4)
	chara_type = monster.get_character_number() or chara_type
	monster.set_variable(30, 0)
	monster.set_variable(31, chara_type)
	monster.create_monster(618, 0.0, 0.0, 0.0, 0.0)
	monster.create_monster(619, 0.0, 0.0, 0.0, 0.0)
	monster.create_monster(620, 0.0, 0.0, 0.0, 0.0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var2 = monster.load_effect_script("グリ羽根Ｌ１", get_not_used_texb) or var2
		var3 = monster.load_effect_script("グリ羽根Ｌ２", get_not_used_texb) or var3
		var4 = monster.load_effect_script("グリ羽根Ｈ", get_not_used_texb) or var4
		if (if (if var2 ~= 0 then 1 else var3) ~= 0 then 1 else var4) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(7, 0)
	global3 = 0
end

--- Runs the monster's normal behaviour.
function script.loop()
	local argc: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	while true do
		helper_1f64()
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("飛び", -1, 0)
			helper_1bdf4(4.0, vm.f32(4.2), 60.0, 35.0, 90)
		else
			monster.set_motion("飛び", -1, 0)
			helper_1b8ac(4.0, vm.f32(4.2), 60.0, 35.0, 90)
		end
		monster.set_motion("飛び", -1, 0)
		helper_6030(vm.f32(4.2))
		helper_1c5d0()
		monster.set_variable(30, 8)
		monster.set_motion("飛び", -1, 0)
		helper_1fe4(60)
		monster.set_motion("飛び", -1, 0)
		helper_6030(vm.f32(4.2))
		helper_1dbe4()
		monster.set_variable(30, 8)
		monster.set_motion("飛び", -1, 0)
		helper_1fe4(60)
		monster.set_motion("飛び", -1, 0)
		helper_6030(vm.f32(4.2))
		helper_21014()
		monster.set_variable(30, 8)
		monster.set_motion("飛び", -1, 0)
		helper_6030(vm.f32(4.2))
		helper_1f1d4()
		monster.set_variable(30, 8)
		monster.set_motion("飛び", -1, 0)
		helper_1fe4(60)
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

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
	helper_18c8()
	monster.set_life(0.67)
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_1f64()
	end
end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_2124()
	monster.set_motion("起き上がり", -1, 6)
	helper_2124()
	helper_e05438b5()
end

return script
