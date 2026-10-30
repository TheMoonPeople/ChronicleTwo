--!strict
-- dungeon/monster/b11a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_07b5f915 = require("@lib/monster/helper_07b5f915")
local helper_1029a353 = require("@lib/monster/helper_1029a353")
local helper_13320956 = require("@lib/monster/helper_13320956")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_84a6a4c4 = require("@lib/monster/helper_84a6a4c4")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_9821a9e1 = require("@lib/monster/helper_9821a9e1")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_af712f29 = require("@lib/monster/helper_af712f29")
local helper_b937768e = require("@lib/monster/helper_b937768e")
local helper_cea0e31f = require("@lib/monster/helper_cea0e31f")
local helper_de1504df = require("@lib/monster/helper_de1504df")

--- Helper function.
local function helper_19ee0(value: f32, value_2: f32, value_3: f32, value_4: f32)
	monster.set_variable_float(11, value)
	monster.set_variable_float(10, value_2)
	monster.set_variable_float(12, value_3)
	monster.set_variable_float(13, value_4)
end

--- Helper function.
local function helper_1a584(value: f32)
	monster.set_variable_float(9, value)
end

--- Helper function.
local function helper_18c8()
	monster.reset_dungeon_timer()
end

--- Helper function.
local function helper_19c90(value: f32, value_2: f32)
	monster.set_variable_float(0, value)
	monster.set_variable_float(1, value_2)
end

--- Helper function.
local function helper_19a40(value: f32, value_2: f32)
	monster.set_variable_float(2, value)
	monster.set_variable_float(3, value_2)
end

--- Helper function.
local function helper_14744()
	helper_ac26cdde(vm.f32(999.9))
	helper_07b5f915(39.0)
	monster.set_clip_distance(600.0)
	helper_317bfc18(1)
end

--- Helper function.
local function helper_2af8()
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
local function helper_197e4(arg0: s32)
	local value: s32 = 0
	value = monster.get_variable(6) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_198c4(arg0: s32, arg1: s32)
	local value: s32 = 0
	value = helper_197e4(value)
	if arg1 ~= 0 then
		value = vm.i32(bit32.bor(arg0, value))
	else
		value = helper_af712f29(value, arg0)
	end
	monster.set_variable(6, value)
end

--- Helper function.
local function helper_1ba4(arg0: s32, arg1: s32)
	local att_type: s32 = 0
	att_type = monster.get_last_attack_type() or att_type
	monster.set_variable(16, att_type)
	monster.set_variable(17, vm.i32(arg1 - arg0))
end

--- Helper function.
local function helper_20dc()
	local life: s32 = 0
	local value: s32 = 0
	value = monster.get_variable(15) or value
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		monster.set_variable(15, life)
		return 1
	end
	if vm.i32(life - value) < 0 then
		monster.set_variable(15, life)
		helper_1ba4(life, value)
		return 2
	end
	monster.set_variable(15, life)
	return 0
end

--- Helper function.
local function helper_1fd8()
	local value: s32 = 0
	value = monster.get_variable(18) or value
	monster.set_variable(18, vm.i32(value + 1))
end

--- Helper function.
local function helper_1f34(value: s32)
	monster.set_variable(18, value)
end

--- Helper function.
local function helper_1e78()
	local value: s32 = 0
	value = monster.get_variable(18) or value
	return value
end

--- Helper function.
local function helper_2410()
	local var0: s32 = 0
	var0 = helper_20dc()
	if var0 == 2 then
		if helper_b937768e(2) < 100 then
			helper_1fd8()
		else
			helper_cea0e31f(2)
			helper_1f34(0)
		end
	end
	if helper_1e78() > 3 then
		helper_1ef0d4b2()
	end
	if helper_b937768e(0) > 600 then
		monster.set_variable(22, 1)
		helper_cea0e31f(0)
	end
	if helper_b937768e(1) > 1500 then
		monster.set_variable(23, 1)
		helper_cea0e31f(1)
	end
end

--- Helper function.
local function helper_2810()
	helper_2410()
	vm.wait()
end

--- Helper function.
local function helper_1eb14(arg0: s32)
	local value: s32 = 0
	local value_2: s32 = 0
	value = monster.get_variable(4) or value
	value_2 = monster.get_variable(5) or value_2
	if bit32.band(arg0, 1) ~= 0 then
		monster.set_effect_value(value, 0, 1)
		monster.set_effect_value_float(value, 1, 1.0)
		monster.set_effect_value(value_2, 0, 0)
		monster.set_effect_value_float(value_2, 1, 1.0)
		helper_198c4(1, 1)
		helper_198c4(2, 0)
		monster.apply_reserved_image(0)
	end
	if bit32.band(arg0, 2) ~= 0 then
		monster.set_effect_value(value, 0, 0)
		monster.set_effect_value_float(value, 1, 1.0)
		monster.set_effect_value(value_2, 0, 1)
		monster.set_effect_value_float(value_2, 1, 1.0)
		helper_198c4(2, 1)
		helper_198c4(1, 0)
		monster.apply_reserved_image(1)
	end
end

--- Helper function.
local function helper_1fcdc()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	monster.play_sound(12)
	do
		local out1, out2, out3 = monster.copy_vector(128.0, 128.0, 128.0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var4 = 128.0
	monster.set_motion("立ち", -1, 0)
	monster.set_model_lighting(0)
	var5 = 0
	while var5 < 32 do
		var1 = vm.f32(var1 - 4.0)
		var2 = vm.f32(var2 - 4.0)
		var3 = vm.f32(var3 - 4.0)
		var4 = vm.f32(var4 - 2.0)
		monster.set_model_color(var1, var2, var3, var4)
		helper_2810()
		var5 = var5 + 1
	end
	var0 = helper_197e4(var0)
	if bit32.band(var0, 1) ~= 0 then
		var0 = 2
		monster.set_monster_damage_rates(-1, 48, 1.0)
		monster.set_monster_damage_rates(-1, 4047, 0.0)
	else
		var0 = 1
		monster.set_monster_damage_rates(-1, 15, 1.0)
		monster.set_monster_damage_rates(-1, 4080, 0.0)
	end
	helper_1eb14(var0)
	var5 = 0
	while var5 < 32 do
		var1 = vm.f32(var1 + 4.0)
		var2 = vm.f32(var2 + 4.0)
		var3 = vm.f32(var3 + 4.0)
		var4 = vm.f32(var4 + 2.0)
		monster.set_model_color(var1, var2, var3, var4)
		helper_2810()
		var5 = var5 + 1
	end
	monster.set_model_color(1)
end

--- Helper function.
local function helper_20960()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local value: s32 = 0
	local value_2: f32 = 0
	local var17: f32 = 0
	monster.get_character_number()
	do
		local out1, _, _ = monster.get_scale()
		var7 = out1 or var7
	end
	do
		local out1, out2, out3 = monster.copy_vector(128.0, 128.0, 128.0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var6 = 128.0
	monster.set_camera_mode(4)
	value = monster.get_variable(4) or value
	monster.set_effect_value(value, 2, 1)
	value = monster.get_variable(5) or value
	monster.set_effect_value(value, 2, 1)
	monster.set_model_color(0)
	var13 = 0
	while var13 < 96 do
		var3 = vm.f32(var3 - 1.0)
		var4 = vm.f32(var4 - 1.0)
		var5 = vm.f32(var5 - 1.0)
		var6 = vm.f32(var6 - 1.0)
		monster.set_model_color(var3, var4, var5, var6)
		vm.wait()
		var13 = var13 + 1
	end
	monster.set_model_color(1)
	value_2 = monster.get_variable_float(21) or value_2
	monster.set_entry_object_size(0, value_2)
	monster.set_variable(14, 1)
	var17 = monster.get_random_whole_number(6.2831855) or var17
	x = vm.f32(vm.f32(vm.sin(var17) * 500.0) - 50.0)
	y = 15.0
	z = vm.f32(vm.f32(vm.cos(var17) * 500.0) - 50.0)
	monster.set_position(x, y, z)
	helper_19ee0(1.0, 0.0, vm.f32(999.9), 1.0)
	monster.set_scale(1.0, 1.0, 1.0)
	monster.set_variable(14, 0)
	value = monster.get_variable(4) or value
	monster.set_effect_value(value, 2, 2)
	value = monster.get_variable(5) or value
	monster.set_effect_value(value, 2, 2)
	monster.set_model_color(0)
	var13 = 0
	while var13 < 96 do
		var3 = vm.f32(var3 + 1.0)
		var4 = vm.f32(var4 + 1.0)
		var5 = vm.f32(var5 + 1.0)
		var6 = vm.f32(var6 + 1.0)
		monster.set_model_color(var3, var4, var5, var6)
		vm.wait()
		var13 = var13 + 1
	end
	monster.set_model_color(1)
	value = monster.get_variable(4) or value
	monster.set_effect_value_float(value, 1, 1.0)
	value = monster.get_variable(5) or value
	monster.set_effect_value_float(value, 1, 1.0)
	var14 = helper_197e4(var14)
	if bit32.band(var14, 1) ~= 0 then
		monster.set_monster_damage_rates(-1, 15, 1.0)
		monster.set_monster_damage_rates(-1, 4080, 0.0)
	else
		monster.set_monster_damage_rates(-1, 48, 1.0)
		monster.set_monster_damage_rates(-1, 4047, 0.0)
	end
	monster.set_model_color(1)
	helper_19a40(500.0, 0.0)
	helper_19c90(50.0, 0.0)
end

--- Helper function.
local function helper_1aedc()
	local argc: s32 = 0
	local var1: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		var1 = vm.f32(1.5707964)
	else
		var1 = vm.f32(-1.5707964)
	end
	return var1
end

--- Helper function.
local function helper_39b4(arg0: f32, arg1: f32, arg2: f32)
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
			helper_2810()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_68dc(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.get_target_angle() or var5
	local _ = helper_39b4(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_1a628(arg0: f32)
	local var1: f32 = 0
	-- retail: monster.set_variable(9, var1) does nothing, since its handler stores only an integer or a float
	arg0 = var1
	return arg0
end

--- Helper function.
local function helper_1a974(arg0: f32)
	local var1: f32 = 0
	var1 = helper_1a628(var1)
	arg0 = vm.f32(arg0 + var1)
	return arg0
end

--- Helper function.
local function helper_19b2c(arg0: f32, arg1: f32)
	local value: f32 = 0
	local value_2: f32 = 0
	value = monster.get_variable_float(2) or value
	value_2 = monster.get_variable_float(3) or value_2
	arg0 = value
	arg1 = value_2
	return arg0, arg1
end

--- Helper function.
local function helper_19d7c(arg0: f32, arg1: f32)
	local value: f32 = 0
	local value_2: f32 = 0
	value = monster.get_variable_float(0) or value
	value_2 = monster.get_variable_float(1) or value_2
	arg0 = value
	arg1 = value_2
	return arg0, arg1
end

--- Helper function.
local function helper_1aa54(arg0: f32, arg1: f32, arg2: f32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local value: s32 = 0
	local var12: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var16: f32 = 0
	var8, var9 = helper_19b2c(var8, var9)
	var6, var7 = helper_19d7c(var6, var7)
	value = monster.get_variable(14) or value
	if value == 0 then
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var12 = monster.get_distance_between(pos_x, pos_y, pos_z, arg0, arg1, arg2) or var12
		monster.get_angle_to_position(arg0, arg1, arg2, var16)
		if helper_de1504df(arg0, arg1, arg2, var12, var16) ~= 0 then
			return 0
		end
	end
	if arg1 < var7 or arg1 > var6 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_1a05c(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local value: f32 = 0
	do
		local out1, out2, out3 = monster.copy_vector(0.0, 0.0, 0.0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	value = 0.0
	var4 = monster.get_variable_float(11) or var4
	var5 = monster.get_variable_float(10) or var5
	var6 = monster.get_variable_float(12) or var6
	value = monster.get_variable_float(13) or value
	arg0 = var4
	arg1 = var5
	arg2 = var6
	arg3 = value
	return arg0, arg1, arg2, arg3
end

--- Helper function.
local function helper_1a708()
	local var0: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	var4, var3, var5, var6 = helper_1a05c(var4, var3, var5, var6)
	var0 = vm.f32(var4 + var3)
	if var0 < var5 and var0 > var6 then
		var4 = vm.f32(var4 + var3)
	end
	monster.set_scale(var4, var4, var4)
	monster.set_variable_float(11, var4)
end

--- Helper function.
local function helper_1b070(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: any, arg5: f32, arg6: f32, arg7: s32)
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local scale: f32 = 0
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
	var20 = helper_9821a9e1(var21, arg3, vm.f32(vm.f32(vm.fdiv(vm.f32(var21 + arg5), arg3)) * arg6), var20)
	scale = arg3
	var23 = 0
	while var23 < arg7 do
		scale = vm.f32(scale + var20)
		scale = helper_1a974(scale)
		do
			local out1, out2, out3 = monster.get_position_3()
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
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
		if scale < 0.0 then
			break
		else
			var21 = monster.get_distance_between(arg0, arg1, arg2, var8, var9, var10) or var21
			if var21 < scale then
				break
			elseif helper_1aa54(var8, var9, var10) == 0 then
				break
			else
				monster.set_position(var8, var9, var10)
				helper_1a708()
				helper_2810()
				var23 = var23 + 1
			end
		end
	end
	helper_442b9962()
end

--- Helper function.
local function helper_1bac8(
	arg0: f32,
	arg1: f32,
	arg2: f32,
	arg3: f32,
	arg4: f32,
	arg5: f32,
	scale: f32,
	arg7: s32,
	arg8: s32
)
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var22: f32 = 0
	local scale_2: f32 = 0
	local var24: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var12, var13, var14, var9, var10, var11)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var12, var13, var14)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	x = vm.f32(vm.f32(var12 * vm.cos(arg5)) + vm.f32(var14 * vm.sin(arg5)))
	y = var13
	z = vm.f32(vm.f32(var12 * -vm.sin(arg5)) + vm.f32(var14 * vm.cos(arg5)))
	do
		local out1, out2, out3 = monster.normalize_vector(x, y, z)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	scale_2 = arg3
	var24 = 0
	while var24 < arg8 do
		if arg7 ~= 0 then
			do
				local out1, out2, out3 = monster.get_target_position()
				arg0 = out1 or arg0
				arg1 = out2 or arg1
				arg2 = out3 or arg2
			end
		end
		scale_2 = helper_1a974(scale_2)
		var12 = vm.f32(arg0 - var9)
		var13 = vm.f32(arg1 - var10)
		var14 = vm.f32(arg2 - var11)
		do
			local out1, out2, out3 = monster.normalize_vector(var12, var13, var14)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = monster.scale_vector(var12, var13, var14, scale)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = monster.scale_vector(x, y, z, 1.0 - scale)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.add_vectors(x, y, z, var12, var13, var14)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(x, y, z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.copy_vector(x, y, z)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = monster.scale_vector(var18, var19, var20, scale_2)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = monster.add_vectors(var9, var10, var11, var18, var19, var20)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		arg5 = monster.get_angle_to_position(var9, var10, var11) or arg5
		if scale_2 <= 0.0 then
			break
		else
			var22 = monster.get_distance_between(arg0, arg1, arg2, var9, var10, var11) or var22
			if var22 < arg4 or var22 < scale_2 then
				break
			elseif helper_1aa54(var9, var10, var11) == 0 then
				break
			else
				monster.set_position(var9, var10, var11)
				monster.turn_toward_angle(arg5, helper_787df986(vm.f32(4.2)))
				helper_1a708()
				helper_2810()
				var24 = var24 + 1
			end
		end
	end
	helper_442b9962()
end

--- Helper function.
local function helper_1f41c(arg0: f32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	var13 = 10000000.0
	do
		local out1, out2, out3 = monster.get_target_position()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	for var14 = 0, 3 do
		if var14 == 0 then
			var9 = vm.f32(-670.84)
			var10 = vm.f32(-162.23)
			var11 = vm.f32(-742.89)
		end
		if var14 == 1 then
			var9 = 637.25
			var10 = vm.f32(-178.53)
			var11 = vm.f32(677.62)
		end
		if var14 == 2 then
			var9 = vm.f32(-877.66)
			var10 = vm.f32(-178.53)
			var11 = vm.f32(883.13)
		end
		if var14 == 3 then
			var9 = vm.f32(632.59)
			var10 = vm.f32(-178.53)
			var11 = vm.f32(-728.83)
		end
		var12 = monster.get_distance_between(var9, var10, var11, var6, var7, var8) or var12
		if var12 < var13 then
			var13 = var12
			do
				local out1, out2, out3 = monster.copy_vector(var9, var10, var11)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
		end
	end
	arg0 = var3
	arg1 = var4
	arg2 = var5
	return arg0, arg1, arg2
end

--- Helper function.
local function helper_21e5c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local chara_type: s32 = 0
	local value: s32 = 0
	monster.set_monster_attributes(1, 1)
	helper_19a40(9999999.0, 0.0)
	helper_19c90(9999999.0, -999999.0)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	chara_type = monster.get_character_number() or chara_type
	do
		local out1, out2, _ = monster.get_scale()
		var7 = out1 or var7
		var8 = out2 or var8
	end
	var10 = var7
	monster.copy_vector(128.0, 128.0, 128.0)
	var11 = helper_1aedc()
	monster.play_sound(5)
	helper_68dc(vm.f32(1.68))
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("サンワープ２")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_owner(-1, chara_type)
	monster.set_camera_mode(4)
	helper_1b070(pos_x, 500.0, pos_z, 24.0, 24.0, 39.0, vm.f32(1.8), 600)
	helper_68dc(vm.f32(4.2))
	helper_19ee0(var10, vm.f32(-0.1), vm.f32(999.9), 0.0)
	helper_1a584(1.0)
	helper_1bac8(vm.f32(2268.62), 160.0, vm.f32(2031.08), 16.0, 39.0, var11, vm.f32(0.1), 0, 600)
	helper_1a584(0.0)
	do
		local out1, out2, _ = monster.get_scale()
		var7 = out1 or var7
		var8 = out2 or var8
	end
	monster.set_variable_float(20, var7)
	value = monster.get_variable(4) or value
	monster.set_effect_value_float(value, 1, var7)
	value = monster.get_variable(5) or value
	monster.set_effect_value_float(value, 1, var8)
	monster.set_monster_damage_rates(-1, 4095, 1.0)
	monster.play_sound(6)
	var11 = monster.get_target_angle() or var11
	monster.set_rotation(0.0, var11, 0.0)
	helper_68dc(vm.f32(4.2))
	value = monster.get_variable(4) or value
	monster.set_effect_value_float(value, 1, 10.0)
	value = monster.get_variable(5) or value
	monster.set_effect_value_float(value, 1, 10.0)
	pos_x, pos_y, pos_z = helper_1f41c(pos_x, pos_y, pos_z)
	print("pos[0] =", vm.float(pos_x), "----------\n")
	print("pos[1] =", vm.float(pos_y), "----------\n")
	print("pos[2] =", vm.float(pos_z), "----------\n")
	helper_19ee0(10.0, 0.0, 10.0, 0.0)
	monster.set_position(pos_x, -1000.0, pos_z)
	monster.set_variable(14, 1)
	helper_1b070(pos_x, -100.0, pos_z, 8.0, 8.0, 39.0, vm.f32(1.8), 600)
	monster.set_variable(14, 0)
	monster.set_monster_attributes(1, 0)
end

--- Helper function.
local function helper_22f88(value: s32)
	local value_3: f32 = 0
	local var3: f32 = 0
	if bit32.band(value, 4) == 0 then
		helper_20960()
		monster.get_variable_float(20)
		value_3 = monster.get_variable_float(21) or value_3
		monster.set_entry_object_size(0, value_3)
	end
	if bit32.band(value, 4) ~= 0 then
		helper_21e5c()
		monster.get_variable_float(20)
		do
			local out1, _, _ = monster.get_scale()
			var3 = out1 or var3
		end
		value_3 = monster.get_variable_float(21) or value_3
		monster.set_entry_object_size(0, value_3 * var3)
	end
	monster.set_variable(6, value)
end

--- Helper function.
local function helper_5d0c(next_rot: f32, rot_speed: f32)
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
	local _ = helper_39b4(
		helper_28452e16(next_rot),
		helper_28452e16(rot_speed),
		vm.f32(vm.fdiv(360.0, helper_28452e16(rot_speed)))
	)
	helper_442b9962()
end

--- Helper function.
local function helper_29d0()
	local var0: s32 = 0
	while true do
		helper_2810()
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_2890(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_2810()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_24340()
	local chara_type: s32 = 0
	local slot: s32 = 0
	local attack: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local scale: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local chara_type_2: s32 = 0
	print("attack2--------------------------------\n")
	monster.set_motion("歩き", -1, 0)
	helper_68dc(vm.f32(4.2))
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.8)))
	chara_type = monster.get_character_number() or chara_type
	do
		local out1, _, _ = monster.get_scale()
		var7 = out1 or var7
	end
	var10 = monster.get_random_whole_number(6.2831855) or var10
	var14 = vm.f32(vm.sin(var10) * 500.0)
	var15 = 0.0
	var16 = vm.f32(vm.cos(var10) * 500.0)
	do
		local out1, out2, out3 = monster.get_target_position()
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	do
		local out1, out2, out3 = monster.copy_vector(var17, var18, var19)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var20, var21, var22, var14, var15, var16)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var20, var21, var22)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	var11 = 1000.0
	scale = vm.f32(var11 / 90.0)
	do
		local out1, out2, out3 = monster.scale_vector(var20, var21, var22, scale)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.copy_vector(var14, var15, var16)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var13 = monster.get_angle_to_position(var14, var15, var16) or var13
	helper_5d0c(helper_28452e16(var13), vm.f32(4.2))
	chara_type_2 = monster.get_character_number() or chara_type_2
	monster.play_monster_sound(chara_type_2, 7)
	monster.set_motion("攻撃２入り", -1, 6)
	slot = monster.create_effect_2("ＤＥビームＦ") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value_float(slot, 0, var7)
	monster.set_effect_first_vector(slot, var14, var15, var16)
	helper_29d0()
	monster.set_motion("攻撃２ループ", -1, 0)
	slot = monster.create_effect_2("ＤＥビームＬ") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, attack)
	monster.set_effect_value_float(slot, 2, var7)
	monster.set_effect_value(slot, 1, 1)
	for var2 = 0, 89 do
		do
			local out1, out2, out3 = monster.add_vectors(var4, var5, var6, var20, var21, var22)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		var13 = monster.get_angle_to_position(var4, var5, var6) or var13
		monster.set_effect_first_vector(slot, var4, var5, var6)
		monster.set_rotation(0.0, var13, 0.0)
		helper_2810()
	end
	monster.set_motion("攻撃２戻り", -1, 6)
	monster.set_effect_value(slot, 1, 2)
	helper_29d0()
	helper_2890(60)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_285e0()
	local life: f32 = 0
	local var1: s32 = 0
	life = 0.0
	helper_24340()
	life = monster.get_life() or life
	if life < vm.f32(0.1) then
		helper_24340()
	end
	helper_198c4(4, 0)
	var1 = helper_197e4(var1)
	helper_22f88(var1)
end

--- Helper function.
local function helper_19424(arg0: f32)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	do
		local out1, _, out3 = monster.get_target_position()
		var4 = out1 or var4
		var6 = out3 or var6
	end
	var7 = monster.get_distance_between(pos_x, 0.0, pos_z, var4, 0.0, var6) or var7
	arg0 = var7
	return arg0
end

--- Helper function.
local function helper_1e478()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local argc: s32 = 0
	do
		local out1, out2, out3 = monster.get_target_position()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	monster.set_motion("歩き", -1, 0)
	helper_68dc(vm.f32(4.2))
	argc = monster.get_random(100) or argc
	if argc < 50 then
		var3 = vm.f32(1.5707964)
	else
		var3 = vm.f32(-1.5707964)
	end
	monster.set_motion("走り", -1, 0)
	helper_1bac8(var0, var1, var2, 8.0, 39.0, var3, vm.f32(0.12), 1, 600)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_cc14(rot_speed: f32, arg1: s32)
	local var2: f32 = 0
	local _ = helper_787df986(rot_speed)
	for var4 = 0, arg1 - 1 do
		var2 = monster.get_target_angle() or var2
		monster.turn_toward_angle(var2, rot_speed)
		helper_2810()
	end
	helper_442b9962()
end

--- Helper function.
local function helper_23af0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local chara_type: s32 = 0
	local slot: s32 = 0
	local attack: s32 = 0
	print("attack1--------------------------------\n")
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1, 0)
	helper_68dc(vm.f32(4.2))
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	chara_type = monster.get_character_number() or chara_type
	slot = monster.create_effect_2("ＤＥ矢３") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, attack)
	monster.set_effect_value(slot, 1, 0)
	monster.set_effect_value_float(slot, 2, 15.0)
	monster.set_effect_value_float(slot, 3, 0.01)
	monster.set_effect_value_float(slot, 4, 0.3)
	monster.set_effect_value(slot, 5, 5)
	monster.set_effect_value(slot, 6, 25)
	helper_cc14(vm.f32(4.2), helper_9df6409a(31))
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.get_frame_position("arrow")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var3, var4, var5, pos_x, pos_y, pos_z)
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
	monster.set_effect_value(slot, 1, 1)
	helper_29d0()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_ce2c(rot_speed: f32)
	local var1: f32 = 0
	local var2: s32 = 0
	rot_speed = helper_787df986(rot_speed)
	while true do
		var1 = monster.get_target_angle() or var1
		monster.turn_toward_angle(var1, rot_speed)
		helper_2810()
		var2 = monster.is_motion_finished() or var2
		if var2 ~= 0 then
			helper_442b9962()
			break
		end
	end
end

--- Helper function.
local function helper_2551c()
	print("attack3--------------------------------\n")
	monster.set_motion("歩き", -1, 0)
	helper_68dc(vm.f32(4.2))
	monster.set_motion("攻撃３", -1, 2)
	helper_ce2c(vm.f32(4.2))
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_26d68(arg0: s32)
	local argument_count: s32 = 0
	local argc: s32 = 0
	for var1 = 0, arg0 - 1 do
		if vm.imod(var1, 3) == 0 then
			argc = monster.get_random(100) or argc
			argument_count = monster.get_player_status_attribute() or argument_count
			if argument_count == 8 then
				if argc < 25 then
					helper_198c4(4, 1)
					argument_count = helper_197e4(argument_count)
					helper_22f88(argument_count)
					helper_84a6a4c4(0)
				end
				return 1
			end
			if argument_count == 2 then
				if argc > 50 then
					helper_1e478()
					helper_2551c()
				end
				return 2
			end
		end
		helper_2810()
	end
	return 0
end

--- Helper function.
local function helper_1d218(slot: s32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: any)
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local scale: f32 = 0
	local var23: f32 = 0
	local var25: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.copy_vector(arg1, arg2, arg3)
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
	var21 = monster.get_distance_between(arg1, arg2, arg3, var8, var9, var10) or var21
	var20 = helper_9821a9e1(var21, arg4, vm.f32(vm.f32(vm.fdiv(vm.f32(var21 + arg5), arg4)) * arg6), var20)
	scale = arg4
	monster.reset_motion()
	monster.set_motion("攻撃１", -1.0, 6)
	var25 = 0
	while var25 < 60 do
		scale = vm.f32(scale + var20)
		scale = helper_1a974(scale)
		do
			local out1, out2, out3 = monster.get_position_3()
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
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
		if var25 == 31 then
			monster.set_effect_value(slot, 1, 1)
		end
		if scale < 0.0 then
			break
		end
		var21 = monster.get_distance_between(arg1, arg2, arg3, var8, var9, var10) or var21
		if var21 < scale then
			break
		end
		if helper_1aa54(var8, var9, var10) == 0 then
			do
				local out1, out2, out3 = monster.copy_vector(0.0, 0.0, 0.0)
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
		end
		var23 = monster.get_target_angle() or var23
		monster.set_position(var8, var9, var10)
		monster.turn_toward_angle(var23, helper_787df986(vm.f32(4.2)))
		helper_1a708()
		helper_2810()
		var25 = var25 + 1
	end
	while var25 < 60 do
		if var25 == 31 then
			monster.set_effect_value(slot, 1, 1)
		end
		helper_2810()
		var25 = var25 + 1
	end
	helper_442b9962()
end

--- Helper function.
local function helper_25738()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local chara_type: s32 = 0
	local slot: s32 = 0
	local attack: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var3 = monster.get_arc_tangent(pos_x, pos_z) or var3
	monster.get_target_angle(var4)
	if var4 < 0.0 then
		var3 = vm.f32(var3 + vm.f32(0.7853982))
	else
		var3 = vm.f32(var3 - vm.f32(0.7853982))
	end
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(0.4)))
	chara_type = monster.get_character_number() or chara_type
	attack = monster.get_attack_power_1() or attack
	slot = monster.create_effect_2("ＤＥ矢３") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, attack)
	monster.set_effect_value(slot, 1, 0)
	monster.set_effect_value_float(slot, 2, 15.0)
	monster.set_effect_value_float(slot, 3, 0.01)
	monster.set_effect_value_float(slot, 4, 0.3)
	monster.set_effect_value(slot, 5, 5)
	monster.set_effect_value(slot, 6, 25)
	var5 = monster.get_distance_between(0.0, pos_y, 0.0, pos_x, pos_y, pos_z) or var5
	pos_x = vm.f32(vm.sin(var3) * var5)
	pos_z = vm.f32(vm.cos(var3) * var5)
	helper_1d218(slot, pos_x, pos_y, pos_z, 8.0, 39.0, vm.f32(1.8), 60)
end

--- Helper function.
local function helper_27b2c()
	local var0: f32 = 0
	local argc: s32 = 0
	local var3: s32 = 0
	var0 = helper_19424(var0)
	argc = monster.get_random(100) or argc
	if argc < 10 then
		helper_1e478()
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1, 0)
			helper_68dc(vm.f32(4.2))
			helper_23af0()
			monster.set_motion("立ち", -1, 0)
			var3 = helper_26d68(9)
			if var3 == 1 then
				return 1
			end
		else
			argc = monster.get_random(2) or argc
			argc = vm.i32(argc + 1)
			for var2 = 0, argc - 1 do
				helper_25738()
			end
			monster.set_motion("立ち", -1, 0)
			var3 = helper_26d68(9)
			if var3 == 1 then
				return 1
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_1cad8(arg0: f32, arg1: f32, arg2: f32, arg3: any, arg4: f32, arg5: s32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var15: f32 = 0
	local scale: f32 = 0
	local var18: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var9, var10, var11, var6, var7, var8)
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
	do
		local out1, out2, out3 = monster.scale_vector(var9, var10, var11, scale)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var18 = 0
	while var18 < arg5 do
		do
			local out1, out2, out3 = monster.add_vectors(var6, var7, var8, var9, var10, var11)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		if scale <= 0.0 then
			break
		else
			var15 = monster.get_distance_between(arg0, arg1, arg2, var6, var7, var8) or var15
			if var15 < arg4 or var15 < scale then
				break
			elseif helper_1aa54(var6, var7, var8) == 0 then
				break
			else
				monster.set_position(var6, var7, var8) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
				helper_2810()
				var18 = var18 + 1
			end
		end
	end
end

--- Helper function.
local function helper_1e868()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	monster.set_motion("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.get_target_position()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	helper_68dc(vm.f32(4.2))
	monster.set_motion("走り", -1, 0)
	helper_1cad8(var0, var1, var2, 8.0, 39.0, 300)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_27568()
	local var0: f32 = 0
	local argc: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	argc = monster.get_random(100) or argc
	var0 = helper_19424(var0)
	if var0 < 303.0 then
		argc = monster.get_random(100) or argc
		if argc < 20 then
			helper_1e868()
		else
			var2 = 0
			argc = monster.get_random(3) or argc
			while var2 < argc do
				helper_25738()
				var2 = var2 + 1
			end
			var3 = helper_26d68(9)
			if var3 == 1 then
				return 1
			end
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 10 then
			helper_1e478()
		else
			monster.set_motion("歩き", -1, 0)
			helper_68dc(vm.f32(4.2))
			helper_23af0()
			monster.set_motion("立ち", -1, 0)
			var3 = helper_26d68(9)
			if var3 == 1 then
				return 1
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_1e1b4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	do
		local out1, out2, out3 = monster.get_target_position()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	monster.set_motion("歩き", -1, 0)
	helper_68dc(vm.f32(4.2))
	monster.set_motion("走り", -1, 0)
	helper_1b070(var0, var1, var2, 8.0, 8.0, 39.0, vm.f32(1.8), 600)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_26924(arg0: f32)
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var4: f32 = 0
	var4 = monster.get_random_whole_number(6.2831855) or var4
	target = vm.f32(vm.sin(var4) * 500.0)
	target_2 = arg0
	target_3 = vm.f32(vm.cos(var4) * 500.0)
	monster.set_motion("歩き", -1, 0)
	var4 = monster.get_angle_to_position(target, target_2, target_3) or var4
	helper_5d0c(helper_28452e16(var4), vm.f32(4.2))
	monster.set_motion("走り", -1, 0)
	helper_1b070(target, target_2, target_3, 8.0, 8.0, 39.0, vm.f32(1.8), 150)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_2716c()
	local var0: f32 = 0
	local argc: s32 = 0
	var0 = helper_19424(var0)
	argc = monster.get_random(100) or argc
	if argc < 65 then
		helper_1e1b4()
		helper_2551c()
	else
		argc = monster.get_random(100) or argc
		if argc < 55 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("走り", -1, 0)
				helper_26924(80.0)
				monster.set_motion("歩き", -1, 0)
				helper_68dc(vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
			else
				helper_25738()
			end
		else
			helper_1e478()
		end
	end
	return 0
end

--- Helper function.
local function helper_28380()
	local var0: f32 = 0
	local var3: s32 = 0
	var0 = helper_19424(var0)
	if var0 > 450.0 then
		local _ = helper_27b2c()
	elseif var0 > 225.0 then
		local _ = helper_27568()
	else
		local _ = helper_2716c()
	end
	var3 = helper_13320956(var3)
	var3 = vm.i32(var3 + 1)
	helper_84a6a4c4(var3)
end

--- Helper function.
local function helper_db04()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	helper_2810()
	monster.set_action_status(1)
end

--- Helper function.
local function helper_2332c(arg0: f32, arg1: f32, arg2: s32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
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
	if arg2 == 1 then
		monster.set_motion("ステップ後", -1, 0)
		var10 = vm.f32(var8 + vm.f32(3.1415927))
	end
	if arg2 == 2 then
		monster.set_motion("ステップ左", -1, 0)
		var10 = vm.f32(var8 + vm.f32(1.5707964))
	end
	if arg2 == 4 then
		monster.set_motion("ステップ右", -1, 0)
		var10 = vm.f32(var8 - vm.f32(1.5707964))
	end
	if var10 > vm.f32(3.1415927) then
		var10 = vm.f32(var10 - vm.f32(6.2831855))
	end
	if var10 <= vm.f32(-3.1415927) then
		var10 = vm.f32(var10 + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var10) * arg1))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var10) * arg1))
	helper_1b070(pos_x, pos_y, pos_z, arg0, arg0, 39.0, vm.f32(1.8), arg3)
	monster.set_motion("立ち", -1, 0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local chara_type: s32 = 0
	local slot: s32 = 0
	local slot_2: s32 = 0
	local size: f32 = 0
	monster.register_damage_hit("通常攻撃", 7.8, "攻撃３", 0.195, 0.24, 1)
	monster.register_damage_hit("通常攻撃", 7.8, "攻撃３", 0.42, 0.465, 1)
	monster.register_damage_hit("吹っ飛び強", 7.8, "攻撃３", 0.705, 0.75, 1)
	chara_type = monster.get_character_number() or chara_type
	monster.load_effect_script("ＤＥ光青")
	slot = monster.create_effect_2("ＤＥ光青") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, 1)
	monster.set_effect_value_float(slot, 1, 1.0)
	monster.set_variable(4, slot)
	monster.load_effect_script("ＤＥ光赤")
	slot_2 = monster.create_effect_2("ＤＥ光赤") or slot_2
	monster.set_effect_owner(slot_2, chara_type)
	monster.set_effect_value(slot_2, 0, 0)
	monster.set_effect_value_float(slot_2, 1, 1.0)
	monster.set_variable(5, slot_2)
	monster.load_effect_script("ＤＥ矢")
	monster.load_effect_script("ＤＥ矢２")
	monster.load_effect_script("ＤＥ矢３")
	monster.load_effect_script("ＤＥ矢Ｈ")
	monster.load_effect_script("ＤＥビームＦ")
	monster.load_effect_script("ＤＥビームＬ")
	monster.load_effect_script("ＤＥビームＨ")
	monster.load_effect_script("サンワープ２")
	monster.set_camera_mode(4)
	size = monster.get_entry_object_size(0) or size
	monster.set_variable(6, 1)
	monster.set_variable_float(20, 1.0)
	monster.set_variable_float(21, size)
	monster.set_position(0.0, 45.0, 0.0)
	monster.set_variable_float(8, 0.0)
	monster.set_variable_float(9, 0.0)
	monster.set_variable_float(10, 0.0)
	monster.set_variable_float(11, 0.0)
	helper_19ee0(1.0, 0.0, 1.0, 0.0)
	helper_1a584(0.0)
	monster.set_variable(20, 0)
	monster.set_variable(19, 0)
	monster.set_variable(22, 0)
	monster.set_variable(23, 0)
	monster.load_reserved_image(0, "textures/dungeon/monster/b11a_g.json")
	monster.load_reserved_image(1, "textures/dungeon/monster/b11a_r.json")
	monster.set_variable(14, 0)
	helper_18c8()
	helper_cea0e31f(0)
	helper_cea0e31f(1)
	helper_cea0e31f(2)
	helper_1029a353()
	helper_19c90(50.0, 0.0)
	helper_19a40(500.0, 0.0)
	helper_14744()
	helper_2af8()
	monster.set_clip_distance(999999.9)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	local value_2: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	value = monster.get_variable(19) or value
	if value == 0 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			helper_198c4(1, 1)
		else
			helper_198c4(2, 1)
		end
		monster.set_variable(19, 1)
		helper_1fcdc()
	end
	while true do
		helper_2810()
		value_2 = monster.get_variable(22) or value_2
		if value_2 ~= 0 then
			monster.set_variable(22, 0)
			var1 = helper_197e4(var1)
			if bit32.band(var1, 4) == 0 then
				helper_1fcdc()
			end
		else
			value_2 = monster.get_variable(23) or value_2
			if value_2 ~= 0 then
				monster.set_variable(23, 0)
				helper_198c4(4, 1)
				var1 = helper_197e4(var1)
				helper_22f88(var1)
			end
		end
		var1 = helper_197e4(var1)
		if bit32.band(var1, 4) ~= 0 then
			helper_285e0()
		else
			helper_28380()
		end
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_db04()
	helper_6a21fe95()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	monster.set_rotation(0.0, var0, 0.0)
	helper_2810()
	helper_2332c(12.0, 30.0, 1, 30)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	local var1: s32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	monster.set_rotation(0.0, var0, 0.0)
	helper_2810()
	if var0 < 0.0 then
		var1 = 4
	else
		var1 = 2
	end
	helper_2332c(vm.f32(13.6), 30.0, var1, 30)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	local value: s32 = 0
	local value_2: s32 = 0
	helper_02ce7891()
	monster.set_monster_attributes(2, 1)
	monster.set_monster_attributes(64, 1)
	monster.set_camera_mode(0)
	value = monster.get_variable(4) or value
	value_2 = monster.get_variable(5) or value_2
	monster.finish_effect(value)
	monster.finish_effect(value_2)
	monster.set_motion("死に", -1, 6)
	helper_29d0()
	monster.request_event_script(500)
	while true do
		helper_2810()
	end
	while true do
		helper_2810()
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
