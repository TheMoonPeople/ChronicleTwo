--!strict
-- dungeon/monster/b02a1.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_14c68180 = require("@lib/monster/helper_14c68180")
local helper_327ff876 = require("@lib/monster/helper_327ff876")
local helper_bf1b4ec0 = require("@lib/monster/helper_bf1b4ec0")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_f683d690 = require("@lib/monster/helper_f683d690")

local global0: s32 = 0

--- Helper function.
local function helper_58d8()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local value: s32 = 0
	monster.set_motion("飛行")
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, 0.0, pos_z)
	while true do
		value = monster.get_variable(8) or value
		if value ~= 0 and value ~= 8 and value ~= 16 then
			break
		else
			vm.wait()
		end
	end
end

--- Helper function.
local function helper_2c14(arg0: s32, arg1: f32, arg2: f32, arg3: f32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	var4 = vm.f32(vm.f32(vm.f32(3.1415927) * vm.i32(arg0 - 1)) * 0.25)
	var5 = 625.0
	var6, var7 = helper_327ff876(var4, var5, var6, var7)
	var8 = vm.f32(268.8)
	var9 = 812.5
	var10 = vm.f32(-322.4)
	var8 = vm.f32(var8 + var6)
	var10 = vm.f32(var10 + var7)
	arg1 = var8
	arg2 = var9
	arg3 = var10
	return arg1, arg2, arg3
end

--- Helper function.
local function helper_18c0(arg0: s32, value: s32)
	monster.set_variable(vm.i32(vm.i32(9 + arg0) - 1), value)
end

--- Helper function.
local function helper_3ce0(target: f32, target_2: f32, target_3: f32, arg3: s32, arg4: s32)
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var22: f32 = 0
	local var24: f32 = 0
	local y_2: f32 = 0
	local value: s32 = 0
	local var27: f32 = 0
	var6 = 0
	var7 = 1
	while var7 ~= 0 do
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.get_rotation()
			var12 = out2 or var12
		end
		var15 = helper_14c68180(pos_x, pos_z, var12, target, target_3)
		if true then
			if 0 < var15 then
				var14 = var15
				if vm.f32(0.05) < var14 then
					var14 = vm.f32(0.05)
				end
			else
				var14 = var15
				if var14 < vm.f32(-0.05) then
					var14 = vm.f32(-0.05)
				end
			end
		else
			var14 = 0.0
		end
		var16, var17 = helper_327ff876(vm.f32(var12 + var14), 5.0, var16, var17)
		if pos_y == target_2 then
			var18 = 0.0
		else
			var18 = vm.f32(target_2 - pos_y)
			if pos_y < target_2 then
				if var18 > 1.0 then
					var18 = 1.0
				end
			elseif var18 < -1.0 then
				var18 = -1.0
			end
		end
		x = vm.f32(pos_x + var16)
		y = vm.f32(pos_y + var18)
		z = vm.f32(pos_z + var17)
		monster.set_position(x, y, z)
		do
			local out1, _, out3 = monster.get_rotation()
			var22 = out1 or var22
			var24 = out3 or var24
		end
		y_2 = vm.f32(var12 + var14)
		if y_2 > vm.f32(3.1415927) then
			y_2 = vm.f32(y_2 - vm.f32(6.2831855))
		end
		if y_2 <= vm.f32(-3.1415927) then
			y_2 = vm.f32(y_2 + vm.f32(6.2831855))
		end
		monster.set_rotation(var22, y_2, var24)
		vm.wait()
		var6 = vm.i32(var6 + 1)
		if var6 == arg4 then
			monster.set_scene_character_status(32, 0)
		end
		value = monster.get_variable(8) or value
		if value == 0 then
			var7 = 0
			var5 = 1
		end
		if value == 8 then
			var7 = 0
			var5 = 0
		end
		if value == 9 and arg3 ~= 1 then
			var7 = 0
			var5 = 3
		end
		var27 = monster.get_distance_to_position(target, target_2, target_3) or var27
		if var27 <= 10.0 then
			var7 = 0
			var5 = 6
		end
	end
	monster.set_scene_character_status(32, 0)
	return var5
end

--- Helper function.
local function helper_4b58()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local monster_id: s32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	monster.set_motion("飛行")
	monster.set_monster_attributes(1, 0)
	monster.set_monster_attributes(32, 0)
	do
		local out1, _, out3 = monster.get_kind_position_4(501)
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	x = pos_x
	y = 1050.0
	z = pos_z
	monster.set_position(x, y, z)
	monster_id = monster.get_monster_kind() or monster_id
	var7, var8, var9 = helper_2c14(vm.i32(monster_id - 501), var7, var8, var9)
	helper_18c0(vm.i32(monster_id - 501), vm.i32(monster_id - 501))
	do
		local out1, out2, out3 = monster.get_rotation()
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	var11 = monster.get_arc_tangent(var7 - x, var9 - z) or var11
	var11 = vm.f32(var11 + vm.f32(3.1415927))
	if vm.f32(3.1415927) < var11 then
		var11 = vm.f32(var11 - vm.f32(6.2831855))
	end
	monster.set_rotation(var10, var11, var12)
	return helper_3ce0(var7, var8, var9, 0, 0)
end

--- Helper function.
local function helper_31d0(to: f32, to_2: f32, to_3: f32, arg3: s32)
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local y: f32 = 0
	local value_2: s32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local next_x: f32 = 0
	local next_y: f32 = 0
	local next_z: f32 = 0
	local result: s32 = 0
	monster.set_motion("飛行")
	while true do
		value = monster.get_variable(8) or value
		if value == 0 then
			return 1
		end
		if value == 8 then
			return 0
		end
		if value == 9 and arg3 ~= 1 then
			return 3
		end
		do
			local out1, _, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_rotation()
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		var12 = helper_14c68180(pos_x, pos_z, var9, to, to_3)
		if vm.f32(0.01) < var12 or var12 < vm.f32(-0.01) then
			if 0 < var12 then
				var11 = var12
				if vm.f32(0.05) < var11 then
					var11 = vm.f32(0.05)
				end
			else
				var11 = var12
				if var11 < vm.f32(-0.05) then
					var11 = vm.f32(-0.05)
				end
			end
		else
			break
		end
		y = vm.f32(var9 + var11)
		if y > vm.f32(3.1415927) then
			y = vm.f32(y - vm.f32(6.2831855))
		end
		if y <= vm.f32(-3.1415927) then
			y = vm.f32(y + vm.f32(6.2831855))
		end
		monster.set_rotation(var8, y, var10)
		vm.wait()
	end
	while true do
		value_2 = monster.get_variable(8) or value_2
		if value_2 == 0 then
			return 1
		end
		if value_2 == 8 then
			return 0
		end
		if value_2 == 9 and arg3 ~= 1 then
			return 3
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		do
			local out1, out2, out3, out4 = monster.get_next_move_position(pos_x_2, pos_y_2, pos_z_2, to, to_2, to_3, 5.0)
			next_x = out1 or next_x
			next_y = out2 or next_y
			next_z = out3 or next_z
			result = out4 or result
		end
		monster.set_position(next_x, next_y, next_z)
		vm.wait()
		if result ~= 0 then
			return 6
		end
	end
	return 0
end

--- Helper function.
local function helper_5134()
	local monster_id: s32 = 0
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local value: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	helper_18c0(vm.i32(monster_id - 501), 0)
	monster.set_motion("飛行")
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(32, 1)
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var5 = monster.get_target_angle() or var5
	monster.create_effect_1("蝶ねばＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, 0.0, var5, 0.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, 1)
	var6 = helper_31d0(vm.f32(268.8), 1050.0, vm.f32(-322.4), 1)
	if var6 == 0 then
		return 0
	end
	if var6 == 1 then
		return 1
	end
	value = monster.get_variable(8) or value
	if value == 15 then
		monster.set_variable(8, 0)
	else
		monster.set_variable(8, vm.i32(value + 1))
		while value ~= 0 do
			vm.wait()
			value = monster.get_variable(8) or value
		end
	end
	return 1
end

--- Helper function.
local function helper_5f24()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local monster_id: s32 = 0
	local index: s32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var8: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster_id = monster.get_monster_kind() or monster_id
	index = 502
	while index <= 508 do
		if index == monster_id then
			index = index + 1
			continue
		end
		do
			local out1, out2, out3 = monster.get_kind_position_4(index)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		var8 = monster.get_distance_between(pos_x, pos_y, pos_z, pos_x_2, pos_y_2, pos_z_2) or var8
		if var8 < 50.0 then
			return 1
		end
		index = index + 1
	end
	return 0
end

--- Helper function.
local function helper_62bc()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local value: s32 = 0
	var0 = helper_5f24()
	if var0 ~= 0 then
		return 5
	end
	monster.set_motion("飛行", -1, 1)
	while true do
		var1 = monster.get_target_distance() or var1
		if var1 < 200.0 then
			var2 = monster.get_target_speed() or var2
			if 3.0 < var2 then
				return 5
			end
		end
		value = monster.get_variable(8) or value
		if value == 8 then
			return 0
		end
		if value == 9 then
			return 3
		end
		vm.wait()
	end
	return 0
end

--- Helper function.
local function helper_1994(arg0: s32)
	local value: s32 = 0
	value = monster.get_variable(vm.i32(vm.i32(9 + arg0) - 1)) or value
	return value
end

--- Helper function.
local function helper_1a80(arg0: any)
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { s32 } = table.create(12, 0)
	frame[1] = arg0
	frame[10] = 0
	while frame[10] < 8 do
		frame[vm.index(vm.i32(frame[10] + 1), 12)] = 0
		frame[10] = vm.i32(frame[10] + 1)
	end
	frame[12] = 1
	while frame[12] <= 7 do
		frame[11] = helper_1994(frame[12])
		frame[vm.index(frame[11], 12)] = frame[12]
		frame[12] = vm.i32(frame[12] + 1)
	end
	frame[10] = 0
	while frame[10] < 8 do
		if frame[vm.index(vm.i32(frame[10] + 1), 12)] == 0 then
			if frame[1] == 0 then
				return vm.i32(frame[10] + 1)
			end
			if frame[1] ~= vm.i32(frame[10] + 1) then
				return vm.i32(frame[10] + 1)
			end
		end
		frame[10] = vm.i32(frame[10] + 1)
	end
	return 0
end

--- Helper function.
local function helper_6634()
	local value: s32 = 0
	local monster_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	value = monster.get_variable(18) or value
	if value == 1 then
		monster.set_variable(18, 2)
		monster.request_event_script(503)
		vm.wait()
	end
	monster.set_scene_character_status(32, 1)
	monster.set_motion("急ぎ飛行")
	monster_id = monster.get_monster_kind() or monster_id
	var2 = helper_1994(vm.i32(monster_id - 501))
	var3 = helper_1a80(var2)
	helper_18c0(vm.i32(monster_id - 501), var3)
	var4, var5, var6 = helper_2c14(var3, var4, var5, var6)
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var11 = monster.get_target_angle() or var11
	monster.create_effect_1("蝶ねばＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, 0.0, var11, 0.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, 0)
	return helper_3ce0(var4, var5, var6, 0, 30)
end

--- Helper function.
local function helper_23f8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ダメージ", -1, 6)
	monster.play_sound(11)
	helper_f683d690()
	monster.set_motion("急ぎ飛行")
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var3 = 0
	while var3 < 120 do
		x = pos_x
		y = helper_bf1b4ec0(pos_y, 1050.0, vm.f32(vm.fdiv(var3, 120)))
		z = pos_z
		monster.set_position(x, y, z)
		var3 = var3 + 1
		vm.wait()
	end
end

--- Helper function.
local function helper_2870()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local value: s32 = 0
	monster.set_motion("飛行")
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, 1050.0, pos_z)
	while true do
		value = monster.get_variable(8) or value
		if value == 8 then
			return 0
		end
		if value == 9 then
			return 1
		end
		vm.wait()
	end
	return 0
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(32, 1)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_clip_distance(9999.9)
	monster.set_monster_attributes(4, 1)
	monster.register_entry_object(0, "bcol00")
	monster.set_body(0, 6.0)
	global0 = 1
end

--- Runs the monster's normal behaviour.
function script.loop()
	while true do
		if global0 == 1 then
			helper_58d8()
			global0 = 2
			monster.set_life(1.0)
		end
		if global0 == 2 then
			global0 = helper_4b58()
		end
		if global0 == 3 then
			global0 = helper_5134()
		end
		if global0 == 6 then
			global0 = helper_62bc()
		end
		if global0 == 5 then
			global0 = helper_6634()
		end
		if global0 == 0 then
			return
		end
		monster.get_monster_kind()
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
function script.on_dodge_2()
	global0 = helper_6634()
end

--- Runs the monster's death.
function script.on_death()
	local monster_id: s32 = 0
	local var1: s32 = 0
	local value: s32 = 0
	local var3: s32 = 0
	local value_2: s32 = 0
	monster.set_motion("飛行")
	monster.set_scene_character_status(32, 0)
	monster_id = monster.get_monster_kind() or monster_id
	var1 = vm.i32(monster_id - 501)
	value = monster.get_variable(8) or value
	if value == var1 then
		monster.call_command(20, 1) -- retail: command 20 is not registered
		monster.set_variable(8, vm.i32(value + 1))
		if var1 == 7 then
			monster.request_event_script(501)
			monster.set_camera_mode(0)
			while true do
				vm.wait()
			end
		else
			helper_18c0(vm.i32(monster_id - 501), 0)
			helper_23f8()
			var3 = helper_2870()
			if var3 == 1 then
				monster.set_life(1.0)
				global0 = 3
			else
				while true do
					vm.wait()
				end
			end
		end
	else
		monster.call_command(20, 5) -- retail: command 20 is not registered
		monster.set_variable(8, 9)
		value_2 = monster.get_variable(18) or value_2
		if value_2 == 3 then
			monster.set_variable(18, 4)
			monster.request_event_script(505)
			vm.wait()
		end
		if value_2 == 2 then
			monster.set_variable(18, 3)
			monster.request_event_script(504)
			vm.wait()
		end
		global0 = 3
	end
end

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
