--!strict
-- dungeon/monster/b02a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_14c68180 = require("@lib/monster/helper_14c68180")
local helper_327ff876 = require("@lib/monster/helper_327ff876")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_bf1b4ec0 = require("@lib/monster/helper_bf1b4ec0")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_f683d690 = require("@lib/monster/helper_f683d690")

local global0: s32 = 0

--- Helper function.
local function helper_398c()
	local value: s32 = 0
	local no_damage_cnt: s32 = 0
	value = monster.get_variable(18) or value
	if value == 0 then
		no_damage_cnt = monster.get_no_damage_hit_count() or no_damage_cnt
		if 1 <= no_damage_cnt then
			monster.set_variable(18, 1)
			monster.request_event_script(507)
		end
	end
end

--- Helper function.
local function helper_23a8(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32)
	local var6: f32 = 0
	local var7: f32 = 0
	var6 = vm.f32(vm.sin(arg2) * arg3)
	var7 = vm.f32(vm.cos(arg2) * arg3)
	var6 = vm.f32(var6 + arg0)
	var7 = vm.f32(var7 + arg1)
	arg4 = var6
	arg5 = var7
	return arg4, arg5
end

--- Helper function.
local function helper_25b4()
	local var0: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local x: f32 = 0
	local z: f32 = 0
	if global0 == 0 then
		return
	end
	do
		local out1, _, out3 = monster.get_target_position()
		var0 = out1 or var0
		var2 = out3 or var2
	end
	var3 = monster.get_arc_tangent(var0 - vm.f32(268.8), var2 - vm.f32(-322.4)) or var3
	if var3 > vm.f32(3.1415927) then
		var3 = vm.f32(var3 - vm.f32(6.2831855))
	end
	if var3 <= vm.f32(-3.1415927) then
		var3 = vm.f32(var3 + vm.f32(6.2831855))
	end
	x, z = helper_23a8(vm.f32(268.8), vm.f32(-322.4), var3, 800.0, x, z)
	monster.set_camera_position(x, 850.0, z)
	monster.set_camera_look_at(268.8, 1050.0, -322.4)
end

--- Helper function.
local function helper_3b5c(arg0: f32, arg1: f32, arg2: s32)
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	monster.set_motion("歩き")
	while true do
		helper_398c()
		if arg2 ~= 0 then
			value = monster.get_variable(8) or value
			if value == 16 then
				return 5
			end
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_rotation()
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		if pos_y == arg0 and var8 == arg1 then
			return 0
		end
		var10 = vm.f32(arg0 - pos_y)
		if var10 < -2.0 then
			pos_y = vm.f32(pos_y - 2.0)
		elseif var10 < 2.0 then
			pos_y = arg0
		else
			pos_y = vm.f32(pos_y + 2.0)
		end
		monster.set_position(pos_x, pos_y, pos_z)
		var11 = vm.f32(arg1 - var8)
		if var11 > vm.f32(3.1415927) then
			var11 = vm.f32(var11 - vm.f32(6.2831855))
		end
		if var11 <= vm.f32(-3.1415927) then
			var11 = vm.f32(var11 + vm.f32(6.2831855))
		end
		if var11 < vm.f32(-0.05) then
			var8 = vm.f32(var8 - vm.f32(0.05))
		elseif var11 < vm.f32(0.05) then
			var8 = arg1
		else
			var8 = vm.f32(var8 + vm.f32(0.05))
		end
		if var8 > vm.f32(3.1415927) then
			var8 = vm.f32(var8 - vm.f32(6.2831855))
		end
		if var8 <= vm.f32(-3.1415927) then
			var8 = vm.f32(var8 + vm.f32(6.2831855))
		end
		monster.set_rotation(var7, var8, var9)
		helper_25b4()
		vm.wait()
	end
	return 0
end

--- Helper function.
local function helper_451c(arg0: f32)
	local pos_y: f32 = 0
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	helper_3b5c(pos_y, arg0, 1)
	return 0
end

--- Helper function.
local function helper_37cc(sound: s32)
	local chara_type: s32 = 0
	chara_type = monster.get_character_number() or chara_type
	monster.play_monster_sound(chara_type, sound)
end

--- Helper function.
local function helper_38ac(sound: s32)
	local chara_type: s32 = 0
	chara_type = monster.get_character_number() or chara_type
	monster.stop_monster_sound(chara_type, sound)
end

--- Helper function.
local function helper_57c0()
	local var0: f32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	do
		local out1, _, out3 = monster.get_target_position()
		var0 = out1 or var0
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, _, out3 = monster.get_rotation()
		var6 = out1 or var6
		var8 = out3 or var8
	end
	var9 = monster.get_arc_tangent(var0 - pos_x, var2 - pos_z) or var9
	var10 = helper_451c(var9)
	if var10 == 5 then
		return 5
	end
	monster.set_motion("りんぷん")
	monster.set_positional_sound(1)
	helper_37cc(6)
	var11 = 0
	while var11 < 120 do
		if vm.imod(var11, 60) == 0 then
			monster.create_effect_1("蝶りんぷん")
			monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
			monster.set_effect_second_vector(-1, var6, var9, var8)
			monster.set_effect_value(-1, 0, 24)
			monster.set_effect_target(-1, 0)
		end
		var11 = var11 + 1
		vm.wait()
	end
	helper_f683d690()
	helper_38ac(6)
	monster.set_positional_sound(2)
	return 2
end

--- Helper function.
local function helper_4638()
	local var0: f32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local slot: s32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	local attack: s32 = 0
	local value: s32 = 0
	local vector: f32 = 0
	local vector_2: f32 = 0
	local vector_3: f32 = 0
	local pos_x_3: f32 = 0
	local pos_z_3: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	do
		local out1, _, out3 = monster.get_target_position()
		var0 = out1 or var0
		var2 = out3 or var2
	end
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var6 = monster.get_arc_tangent(var0 - pos_x, var2 - pos_z) or var6
	var7 = helper_3b5c(1050.0, var6, 1)
	if var7 == 5 then
		return 5
	end
	monster.set_motion("ビーム構え", -1, 2)
	helper_56d63eae()
	do
		local out1, out2, out3 = monster.get_target_position()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	monster.set_motion("ビーム", -1, 4)
	monster.set_positional_sound(1)
	helper_37cc(8)
	var14 = pos_x_2
	var15 = var9
	var16 = pos_z_2
	var17 = var8
	var18 = var9
	var19 = var10
	slot = monster.create_effect_2("蝶ビーム") or slot
	do
		local out1, out2, out3 = monster.get_object_position("obj17")
		var24 = out1 or var24
		var25 = out2 or var25
		var26 = out3 or var26
	end
	monster.set_effect_first_vector(slot, var24, var25, var26)
	attack = monster.get_attack_power_1() or attack
	var27 = 0
	while var27 < 60 do
		value = monster.get_variable(8) or value
		if value == 16 then
			monster.finish_effect(slot)
			helper_38ac(8)
			monster.set_positional_sound(2)
			return 5
		end
		vector = helper_bf1b4ec0(var14, var17, vm.f32(vm.fdiv(var27, 60)))
		vector_2 = helper_bf1b4ec0(var15, var18, vm.f32(vm.fdiv(var27, 60)))
		vector_3 = helper_bf1b4ec0(var16, var19, vm.f32(vm.fdiv(var27, 60)))
		monster.set_effect_second_vector(slot, vector, vector_2, vector_3)
		var27 = var27 + 1
		if vm.imod(var27, 3) == 0 then
			monster.create_effect_1("七色蝶の火柱")
			monster.set_effect_first_vector(-1, vector, vector_2, vector_3)
			monster.set_effect_value(-1, 0, attack)
		end
		if var27 == 44 then
			monster.finish_effect(slot)
		end
		vm.wait()
	end
	helper_38ac(8)
	monster.set_positional_sound(2)
	monster.set_motion("ビーム戻り", -1, 6)
	helper_56d63eae()
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x_3 = out1 or pos_x_3
		pos_z_3 = out3 or pos_z_3
	end
	var36 = monster.get_arc_tangent(pos_x_3 - vm.f32(268.8), pos_z_3 - vm.f32(-322.4)) or var36
	var37 = vm.f32(var36 + vm.f32(1.5707964))
	if var37 > vm.f32(3.1415927) then
		var37 = vm.f32(var37 - vm.f32(6.2831855))
	end
	if var37 <= vm.f32(-3.1415927) then
		var37 = vm.f32(var37 + vm.f32(6.2831855))
	end
	local _ = helper_3b5c(850.0, var37, 1)
	if var7 == 5 then
		return 5
	end
	return 1
end

--- Helper function.
local function helper_69d8()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local y: f32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local x: f32 = 0
	local z: f32 = 0
	local value: s32 = 0
	local var13: f32 = 0
	monster.set_motion("歩き")
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var3 = monster.get_arc_tangent(pos_x - vm.f32(268.8), pos_z - vm.f32(-322.4)) or var3
	y = vm.f32(var3 + vm.f32(1.5707964))
	if y > vm.f32(3.1415927) then
		y = vm.f32(y - vm.f32(6.2831855))
	end
	if y <= vm.f32(-3.1415927) then
		y = vm.f32(y + vm.f32(6.2831855))
	end
	var5 = helper_451c(y)
	if var5 == 5 then
		return 5
	end
	var6 = 90
	var7 = 0
	var8 = 0.0
	var9 = 1
	while true do
		helper_398c()
		value = monster.get_variable(8) or value
		if value == 16 then
			return 5
		end
		if var6 < var7 then
			var9 = 0
			if var8 <= 0.0 then
				var13 = monster.get_target_distance() or var13
				if var13 < 1000.0 then
					return 6
				else
					return 2
				end
			end
		end
		x, z = helper_23a8(vm.f32(268.8), vm.f32(-322.4), var3, 800.0, x, z)
		monster.set_position(x, 850.0, z)
		monster.set_rotation(0.0, y, 0.0)
		if var9 ~= 0 then
			if var8 < vm.f32(0.02) then
				var8 = vm.f32(var8 + vm.f32(0.0005))
			end
		elseif 0 < var8 then
			var8 = vm.f32(var8 - vm.f32(0.0005))
		end
		var3 = vm.f32(var3 + var8)
		if var3 > vm.f32(3.1415927) then
			var3 = vm.f32(var3 - vm.f32(6.2831855))
		end
		if var3 <= vm.f32(-3.1415927) then
			var3 = vm.f32(var3 + vm.f32(6.2831855))
		end
		y = vm.f32(var3 + vm.f32(1.5707964))
		if y > vm.f32(3.1415927) then
			y = vm.f32(y - vm.f32(6.2831855))
		end
		if y <= vm.f32(-3.1415927) then
			y = vm.f32(y + vm.f32(6.2831855))
		end
		vm.wait()
		var7 = vm.i32(var7 + 1)
	end
	return 0
end

--- Helper function.
local function helper_83b8()
	local value: s32 = 0
	monster.set_alpha(0.0)
	while true do
		vm.wait()
		value = monster.get_variable(8) or value
		if value == 9 then
			return 3
		end
	end
	return 0
end

--- Helper function.
local function helper_8534(arg0: s32)
	if arg0 ~= 0 then
		monster.set_pause_flags(6, 1)
		global0 = 1
	else
		monster.set_camera_follow(1)
		monster.set_pause_flags(6, 0)
		global0 = 0
	end
end

--- Helper function.
local function helper_5f44(to: f32, to_3: f32)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local x: f32 = 0
	local y_2: f32 = 0
	local z: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	while true do
		helper_398c()
		do
			local out1, _, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_rotation()
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		var9 = helper_14c68180(pos_x, pos_z, var6, to, to_3)
		if vm.f32(0.01) < var9 or var9 < vm.f32(-0.01) then
			if 0 < var9 then
				var8 = var9
				if vm.f32(0.05) < var8 then
					var8 = vm.f32(0.05)
				end
			else
				var8 = var9
				if var8 < vm.f32(-0.05) then
					var8 = vm.f32(-0.05)
				end
			end
		else
			break
		end
		y = vm.f32(var6 + var8)
		if y > vm.f32(3.1415927) then
			y = vm.f32(y - vm.f32(6.2831855))
		end
		if y <= vm.f32(-3.1415927) then
			y = vm.f32(y + vm.f32(6.2831855))
		end
		monster.set_rotation(var5, y, var7)
		helper_25b4()
		vm.wait()
	end
	while true do
		helper_398c()
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		var17 = monster.get_distance_between(pos_x_2, pos_y_2, pos_z_2, to, pos_y_2, to_3) or var17
		if vm.f32(0.01) < var17 then
			if 5.0 <= var17 then
				var18 = monster.get_arc_tangent(to - pos_x_2, to_3 - pos_z_2) or var18
				var19, var20 = helper_327ff876(var18, 5.0, var19, var20)
				x = vm.f32(pos_x_2 + var19)
				y_2 = pos_y_2
				z = vm.f32(pos_z_2 + var20)
			else
				x = to
				y_2 = pos_y_2
				z = to_3
			end
		else
			return
		end
		monster.set_position(x, y_2, z)
		helper_25b4()
		vm.wait()
	end
end

--- Helper function.
local function helper_91f4()
	local var0: s32 = 0
	local value: s32 = 0
	local slot: s32 = 0
	local value_2: f32 = 0
	local var4: f32 = 0
	helper_c3e8ae39(120)
	helper_8534(1)
	monster.set_pause_flags(65536, 1)
	while true do
		value = monster.get_variable(8) or value
		if value == 0 then
			break
		else
			helper_25b4()
			vm.wait()
		end
	end
	helper_8534(0)
	monster.set_pause_flags(65536, 0)
	slot = monster.create_effect_2("蝶合体") or slot
	monster.set_effect_first_vector(slot, 268.8, 1050.0, -322.4)
	monster.request_event_script(513)
	monster.set_positional_sound(1)
	helper_37cc(10)
	var0 = 0
	while var0 < 60 do
		helper_25b4()
		vm.wait()
		var0 = var0 + 1
	end
	monster.set_position(268.8, 1050.0, -322.4)
	monster.set_alpha(0.0)
	monster.set_motion("合体")
	var0 = 0
	while var0 < 90 do
		value_2 = helper_bf1b4ec0(0.0, 1.0, vm.f32(vm.fdiv(var0, 90)))
		monster.set_alpha(value_2)
		helper_25b4()
		vm.wait()
		var0 = var0 + 1
	end
	monster.set_alpha(1.0)
	monster.set_monster_attributes(1, 0)
	monster.finish_effect(slot)
	monster.request_event_script(510)
	helper_5f44(vm.f32(268.8), vm.f32(477.6))
	var4 = vm.f32(1.5707964)
	helper_3b5c(850.0, var4, 1)
	return 1
end

--- Helper function.
local function helper_8728()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local slot: s32 = 0
	local var5: s32 = 0
	local value: f32 = 0
	local value_2: s32 = 0
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	helper_8534(1)
	monster.set_pause_flags(65536, 1)
	var3 = monster.get_arc_tangent(pos_x - vm.f32(268.8), pos_z - vm.f32(-322.4)) or var3
	monster.set_position(pos_x, 1050.0, pos_z)
	monster.set_rotation(0.0, var3, 0.0)
	monster.set_motion("歩き")
	helper_5f44(vm.f32(268.8), vm.f32(-322.4))
	slot = monster.create_effect_2("蝶合体") or slot
	monster.set_effect_first_vector(slot, 268.8, 1050.0, -322.4)
	monster.request_event_script(512)
	monster.set_positional_sound(1)
	helper_37cc(9)
	var5 = 0
	while var5 < 90 do
		var5 = var5 + 1
		value = helper_bf1b4ec0(1.0, 0.0, vm.f32(vm.fdiv(var5, 90)))
		monster.set_alpha(value)
		helper_25b4()
		vm.wait()
	end
	monster.set_monster_attributes(1, 1)
	monster.set_alpha(0.0)
	monster.set_motion("歩き", -1, 1)
	monster.finish_effect(slot)
	monster.set_variable(8, 17)
	monster.request_event_script(511)
	var5 = 0
	while var5 < 60 do
		helper_25b4()
		vm.wait()
		var5 = var5 + 1
	end
	monster.set_variable(8, 1)
	value_2 = monster.get_variable(18) or value_2
	if value_2 == 0 then
		helper_25b4()
		monster.set_variable(18, 1)
		monster.request_event_script(502)
		vm.wait()
	end
	helper_8534(0)
	monster.set_pause_flags(65536, 0)
	return 4
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.set_visible_monster_limit(15)
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_clip_distance(999999.9)
	monster.set_monster_attributes(4, 1)
	monster.set_position(260.0, 850.0, -320.0)
	monster.load_effect_script("蝶ビーム")
	monster.load_effect_script("七色蝶の火柱")
	monster.load_effect_script("蝶合体")
	monster.load_effect_script("蝶りんぷん")
	monster.load_effect_script("蝶りんぷんＨ")
	monster.load_effect_script("蝶ねばＬ")
	monster.load_effect_script("ねばねばＨ")
	monster.set_photo_opportunity("合体", 0.0, 1.0, 1015)
	monster.register_entry_object(0, "body2--a40")
	monster.set_body(0, 12.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: s32 = 0
	local chara_type: s32 = 0
	monster.set_positional_sound(2)
	var0 = 1
	while true do
		global0 = 0
		if var0 == 6 then
			var0 = helper_57c0()
		end
		if var0 == 2 then
			var0 = helper_4638()
		end
		if var0 == 1 then
			var0 = helper_69d8()
		end
		if var0 == 4 then
			var0 = helper_83b8()
		end
		if var0 == 3 then
			var0 = helper_91f4()
		end
		if var0 == 5 then
			chara_type = monster.get_character_number() or chara_type
			monster.clear_character_effects(chara_type)
			var0 = helper_8728()
		end
		if var0 == 0 then
			monster.set_positional_sound(0)
			return
		end
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
-- Defined empty, so the engine runs this instead of its default.
function script.on_death() end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	local height: f32 = 0
	while true do
		height = monster.get_height_above_ground() or height
		if height < vm.f32(0.1) then
			helper_c3e8ae39(3)
			monster.end_throw()
			monster.stop_moving()
			helper_c3e8ae39(30)
			return 1
		end
		vm.wait()
	end
end

return script
