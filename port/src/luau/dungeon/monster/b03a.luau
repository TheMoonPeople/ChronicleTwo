--!strict
-- dungeon/monster/b03a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31139918 = require("@lib/monster/helper_31139918")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_661d392d = require("@lib/monster/helper_661d392d")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8566bb6e = require("@lib/monster/helper_8566bb6e")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_3c98()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	local life: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_motion("魔法", -1, 2)
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
	attack = monster.get_attack_power_1() or attack
	attack = vm.i32(attack + 10)
	life = 1.0
	life = monster.get_life() or life
	if life < vm.f32(0.4) then
		var4 = vm.f32(var4 - vm.f32(0.62831855))
		monster.create_effect_1("ギルトーニ魔法")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var3, var4, var5)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_target(-1, 0)
		var4 = vm.f32(var4 + vm.f32(1.2566371))
		monster.create_effect_1("ギルトーニ魔法")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var3, var4, var5)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_target(-1, 0)
	else
		monster.create_effect_1("ギルトーニ魔法")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, var3, var4, var5)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_target(-1, 0)
	end
	monster.set_monster_attributes(32, 1)
	helper_c3e8ae39(48)
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("立ち")
	helper_c3e8ae39(30)
end

--- Helper function.
local function helper_4fb8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local yaw: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local life: f32 = 0
	local angle: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	local yaw_2: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var7 = monster.get_distance_between(var4, var5, var6, -2195.0, 488.0, -475.0) or var7
	var3 = monster.get_distance_between(pos_x, pos_y, pos_z, -2195.0, 488.0, -475.0) or var3
	var9 = monster.get_angle_between_positions(-2195.0, 488.0, -475.0, pos_x, pos_y, pos_z) or var9
	yaw = monster.get_angle_between_positions(-2195.0, 488.0, -475.0, var4, var5, var6) or yaw
	life = 1.0
	life = monster.get_life() or life
	if life < vm.f32(0.4) then
		angle = vm.f32(var9 - vm.f32(3.1415927))
		angle = monster.wrap_angle(angle) or angle
		var16 = vm.f32(340.0 - var3)
		if var16 > 270.0 then
			var16 = 270.0
		end
		var11 = vm.f32(vm.f32(vm.sin(angle) * var16) + -2195.0)
		var12 = 488.0
		var13 = vm.f32(vm.f32(vm.cos(angle) * var16) + -475.0)
		var18 = 0
		monster.reset_motion()
		monster.set_motion("ムーンサルト", -1, 2)
		helper_c3e8ae39(8)
		monster.set_monster_attributes(53, 1)
		monster.turn_toward_angle(var9, 0.19634955)
		while var18 < 24 do
			var22 = vm.f32(vm.f32(vm.f32(vm.f32(var12 - pos_y) * 2.0) - -62.5) / 50.0)
			y = pos_y
			var17 = 0
			while var17 < var18 do
				var22 = vm.f32(var22 + vm.f32(-0.1))
				y = vm.f32(y + var22)
				var17 = vm.f32(var17 + 1)
			end
			if y < var12 then
				y = var12
			end
			x = vm.f32(vm.f32(vm.f32(var11 - pos_x) * vm.f32(var18 / 24.0)) + pos_x)
			z = vm.f32(vm.f32(vm.f32(var13 - pos_z) * vm.f32(var18 / 24.0)) + pos_z)
			monster.set_position(x, y, z)
			var18 = var18 + 1
			vm.wait()
		end
		helper_c3e8ae39(28)
		monster.set_monster_attributes(53, 0)
		helper_c3e8ae39(10)
		monster.set_motion("立ち", -1, 4)
		vm.wait()
	else
		monster.set_motion("走り")
		if var7 < var3 then
			var8 = vm.f32(vm.f32(300.0 - var3) / 60.0)
			yaw = vm.f32(yaw - var9)
			var23 = 0
			while var23 < 60 do
				if yaw >= 0.0 then
					var9 = vm.f32(var9 - vm.f32(0.05235988))
				else
					var9 = vm.f32(var9 + vm.f32(0.05235988))
				end
				var9 = monster.wrap_angle(var9) or var9
				var3 = vm.f32(var3 + var8)
				var11 = vm.f32(vm.f32(vm.sin(var9) * var3) + -2195.0)
				var12 = 488.0
				var13 = vm.f32(vm.f32(vm.cos(var9) * var3) + -475.0)
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				yaw_2 = monster.get_angle_between_positions(pos_x, pos_y, pos_z, var11, var12, var13) or yaw_2
				if var23 < 56 then
					monster.turn_toward_angle(yaw_2, 0.19634955)
				else
					helper_82cb5588(vm.f32(0.19634955))
				end
				monster.move_toward_position(var11, var12, var13, 6.8, 6.8)
				var23 = var23 + 1
				vm.wait()
			end
			helper_c3e8ae39(6)
			monster.stop_moving()
		else
			if helper_8971d3b6(var9, yaw, vm.f32(1.5707964)) == 0 then
				var9 = vm.f32(var9 - vm.f32(3.1415927))
			end
			var9 = monster.wrap_angle(var9) or var9
			var11 = vm.f32(vm.f32(vm.sin(var9) * 300.0) + -2195.0)
			var12 = 488.0
			var13 = vm.f32(vm.f32(vm.cos(var9) * 300.0) + -475.0)
			var3 = monster.get_distance_between(pos_x, pos_y, pos_z, var11, var12, var13) or var3
			var9 = monster.get_angle_between_positions(pos_x, pos_y, pos_z, var11, var12, var13) or var9
			monster.turn_toward_angle(var9, 0.19634955)
			monster.move_toward_position(var11, var12, var13, 6.8, 6.8)
			helper_8566bb6e(vm.f32(vm.f32(var3 / vm.f32(6.8)) - 10.0))
			helper_82cb5588(vm.f32(0.19634955))
			helper_c3e8ae39(16)
			monster.stop_moving()
		end
	end
	helper_442b9962()
	helper_3c98()
end

--- Helper function.
local function helper_2578()
	local var0: s32 = 0
	monster.set_motion("2連続攻撃", -1, 2)
	var0 = 0
	while var0 < 18 do
		helper_82cb5588(vm.f32(0.19634955))
		var0 = var0 + 1
		vm.wait()
	end
	helper_56d63eae()
	monster.stop_moving()
	monster.set_motion("立ち")
	helper_c3e8ae39(8)
end

--- Helper function.
local function helper_2818()
	local var0: f32 = 0
	local var1: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	monster.set_motion("中距離攻撃", -1, 2)
	helper_c3e8ae39(14)
	var5 = 0
	while var5 < 6 do
		var0 = monster.get_target_distance() or var0
		var0 = vm.f32(var0 - 12.0)
		if var0 > 60.0 then
			var0 = 60.0
		end
		var1 = vm.f32(var0 / 10.0)
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, var0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.move_toward_position(pos_x, pos_y, pos_z, var1, var1)
		helper_82cb5588(vm.f32(0.19634955))
		var0 = vm.f32(var0 - var1)
		var5 = var5 + 1
		vm.wait()
	end
	helper_c3e8ae39(4)
	monster.stop_moving()
	helper_442b9962()
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_c3e8ae39(8)
end

--- Helper function.
local function helper_2d70()
	local var0: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var7: f32 = 0
	local angle: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.stop_moving()
	helper_442b9962()
	vm.wait()
	var0 = monster.get_target_distance() or var0
	if var0 < 40.0 then
		monster.reset_motion()
		monster.set_motion("ムーンサルト", -1, 2)
		helper_c3e8ae39(8)
		monster.set_monster_attributes(49, 1)
		var7 = monster.get_target_angle() or var7
		angle = vm.f32(var7 - vm.f32(3.1415927))
		angle = monster.wrap_angle(angle) or angle
		monster.turn_toward_angle(angle, 0.1308997)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var0 = vm.f32(var0 * 2.5)
		target = vm.f32(vm.f32(vm.sin(var7) * var0) + pos_x)
		target_2 = vm.f32(0.0 + pos_y)
		target_3 = vm.f32(vm.f32(vm.cos(var7) * var0) + pos_z)
		var0 = vm.f32(var0 / 24.0)
		monster.move_toward_position(target, target_2, target_3, var0, var0)
		helper_c3e8ae39(28)
		monster.set_monster_attributes(49, 0)
		helper_c3e8ae39(10)
		monster.set_motion("立ち", -1, 4)
		vm.wait()
		var0 = monster.get_target_distance() or var0
		if (if var0 < 80.0 then helper_661d392d(0, 45.0) else 0) ~= 0 then
			if var0 < 50.0 then
				helper_2578()
			else
				helper_2818()
			end
			helper_c3e8ae39(8)
		end
	end
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
end

--- Helper function.
local function helper_7e58()
	local var0: f32 = 0
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local argc_2: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	var0 = monster.get_target_distance() or var0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc_2 = monster.get_random(100) or argc_2
		if argc_2 < 50 then
			var7 = 90
			monster.reset_motion()
			monster.set_motion("ステップ右", -1, 2)
		else
			var7 = -90
			monster.reset_motion()
			monster.set_motion("ステップ左", -1, 2)
		end
		if var0 < 30.0 then
			var0 = 30.0
		end
		var2, var3, var4 = helper_31139918(var7, var0, var2, var3, var4)
		helper_c3e8ae39(8)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var5 = monster.get_distance_between(var2, var3, var4, pos_x, pos_y, pos_z) or var5
		var5 = vm.f32(var5 / 10.0)
		monster.move_toward_position(var2, var3, var4, var5, var5)
		var8 = 0
		while var8 < 13 do
			helper_82cb5588(vm.f32(0.19634955))
			var8 = var8 + 1
			vm.wait()
		end
		monster.stop_moving()
		helper_442b9962()
	end
	if var0 < 60.0 then
		if helper_661d392d(0, 45.0) ~= 0 then
			if var0 < 50.0 then
				helper_2578()
			else
				helper_2818()
			end
			helper_c3e8ae39(16)
		else
			helper_2d70()
		end
	end
end

--- Helper function.
local function helper_191c()
	local var0: s32 = 0
	local value: s32 = 0
	local life: f32 = 0
	local var3: f32 = 0
	var0 = 0
	value = 0
	value = monster.get_variable(0) or value
	life = 0.0
	life = monster.get_life() or life
	if life < vm.f32(0.4) and value == 1 then
		monster.request_event_script(510)
		monster.set_variable(0, 2)
		var0 = 1
	elseif life < vm.f32(0.7) and value <= 0 then
		monster.request_event_script(510)
		monster.set_variable(0, 1)
		var0 = 1
		monster.create_monster(513, 0.0, -100.0, 0.0)
		monster.create_monster(513, 0.0, -100.0, 0.0)
		monster.create_monster(513, 0.0, -100.0, 0.0)
		monster.create_monster(513, 0.0, -100.0, 0.0)
		monster.create_monster(513, 0.0, -100.0, 0.0)
	end
	if var0 == 1 then
		monster.set_monster_attributes(1, 1)
		monster.set_motion("立ち")
		helper_c3e8ae39(60)
		while true do
			var3 = monster.get_target_distance() or var3
			if var3 <= 400.0 then
				break
			else
				vm.wait()
			end
		end
		monster.set_monster_attributes(1, 0)
	end
end

--- Helper function.
local function helper_6e88()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local yaw: f32 = 0
	local arrived: s32 = 0
	local var17: f32 = 0
	while true do
		helper_191c()
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.get_rotation()
			var11 = out2 or var11
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var13 = monster.get_angle_between_positions(var7, var8, var9, -2195.0, 488.0, -475.0) or var13
		yaw = monster.get_angle_between_positions(pos_x, pos_y, pos_z, -2195.0, 488.0, -475.0) or yaw
		if helper_8971d3b6(var13, yaw, vm.f32(0.3926991)) == 0 then
			monster.stop_moving()
			helper_442b9962()
			return 0
		end
		var14 = monster.get_target_distance() or var14
		if var14 > 160.0 then
			return 1
		end
		var4 = vm.f32(vm.f32(vm.sin(var13) * 140.0) + var7)
		var5 = vm.f32(0.0 + var8)
		var6 = vm.f32(vm.f32(vm.cos(var13) * 140.0) + var9)
		var14 = monster.get_distance_between(pos_x, pos_y, pos_z, var4, var5, var6) or var14
		if var14 <= 22.0 then
			arrived = monster.is_move_finished() or arrived
			if arrived ~= 0 then
				monster.set_motion("立ち")
			end
			if var0 > 90 then
				return 0
			end
			var0 = var0 + 1
			vm.wait()
			continue
		end
		var0 = 0
		var17 = vm.f32(var14 / 30.0)
		if var17 > 1.5 then
			var17 = 1.5
		end
		monster.move_toward_position(var4, var5, var6, var17, var17)
		helper_82cb5588(vm.f32(0.19634955))
		var13 = monster.get_angle_between_positions(pos_x, pos_y, pos_z, var4, var5, var6) or var13
		var13 = monster.wrap_angle(var13) or var13
		if helper_8971d3b6(vm.f32(var11 + vm.f32(1.5707964)), var13, vm.f32(0.7853982)) == 0 then
			monster.set_motion("バトル歩き(左)")
			vm.wait()
			continue
		end
		if helper_8971d3b6(vm.f32(var11 - vm.f32(1.5707964)), var13, vm.f32(0.7853982)) == 0 then
			monster.set_motion("バトル歩き(右)")
			vm.wait()
			continue
		end
		if helper_8971d3b6(var11, var13, vm.f32(1.5707964)) == 0 then
			monster.set_motion("バトル歩き(前)")
			vm.wait()
			continue
		end
		if helper_8971d3b6(vm.f32(var11 + vm.f32(3.1415927)), var13, vm.f32(1.5707964)) == 0 then
			monster.set_motion("バトル歩き(後)")
			vm.wait()
			continue
		end
	end
	return 0
end

--- Helper function.
local function helper_3794()
	local var0: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local arrived: s32 = 0
	local argc: s32 = 0
	local var10: f32 = 0
	var0 = monster.get_target_distance() or var0
	if var0 > 80.0 then
		monster.set_motion("走り")
		while true do
			do
				local out1, out2, out3 = monster.get_target_position()
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			monster.move_toward_position(var4, var5, var6, 6.8, 40.0)
			helper_82cb5588(vm.f32(0.19634955))
			arrived = monster.is_move_finished() or arrived
			if arrived ~= 0 then
				monster.set_motion("立ち")
				break
			end
			vm.wait()
		end
	end
	argc = monster.get_random(100) or argc
	if argc > 95 then
		var10 = monster.get_target_distance() or var10
		if var10 < 50.0 then
			helper_2578()
		else
			helper_2818()
		end
	else
		helper_2d70()
	end
	helper_c3e8ae39(8)
end

--- Helper function.
local function helper_4904()
	local var0: f32 = 0
	local var1: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: s32 = 0
	var0 = monster.get_target_distance() or var0
	if var0 < 180.0 then
		var1 = monster.get_target_angle() or var1
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var1 = vm.f32(var1 - vm.f32(3.1415927))
		var1 = monster.wrap_angle(var1) or var1
		target = vm.f32(vm.f32(vm.sin(var1) * 80.0) + pos_x)
		target_2 = vm.f32(0.0 + pos_y)
		target_3 = vm.f32(vm.f32(vm.cos(var1) * 80.0) + pos_z)
		monster.set_motion("ステップ後", -1, 2)
		helper_c3e8ae39(10)
		monster.move_toward_position(target, target_2, target_3, 8.0, 8.0)
		var8 = 0
		while var8 < 20 do
			helper_82cb5588(vm.f32(0.19634955))
			var8 = var8 + 1
			vm.wait()
		end
		monster.stop_moving()
		helper_442b9962()
	elseif helper_661d392d(0, 90) == 0 then
		helper_3794()
		return
	end
	helper_3c98()
end

--- Helper function.
local function helper_8690(arg0: any)
	local var1: f32 = 0
	local life: f32 = 0
	local var5: s32 = 0
	var1 = monster.get_target_distance() or var1
	if var1 < 60.0 then
		life = 1.0
		life = monster.get_life() or life
		monster.get_random_whole_number(100.0)
		if life < vm.f32(0.4) then
		else
		end
		if false then
			helper_4fb8()
		else
			helper_7e58()
		end
		return
	end
	var5 = helper_6e88()
	if var5 == 0 then
		helper_3794()
	end
	if var5 == 1 then
		helper_4904()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_entry_object(1, "ken")
	monster.register_entry_object(2, "obj86")
	monster.register_damage_hit("通常攻撃", 6.0, "2連続攻撃", 0.283, 0.391, 0)
	monster.register_damage_hit("通常攻撃", 6.0, "2連続攻撃", 0.609, 0.696, 0)
	monster.register_damage_hit("通常攻撃", 6.0, "中距離攻撃", 0.5, 0.611, 0)
	monster.add_sword_trail(0, "2連続攻撃", 0.2, 0.26, "ken01", "ken00", 77, 20, 20)
	monster.add_sword_trail(0, "2連続攻撃", 0.58, 0.6, "ken01", "ken00", 77, 20, 20)
	monster.add_sword_trail(0, "中距離攻撃", 0.41, 0.45, "ken01", "ken00", 77, 20, 20)
	monster.add_sword_trail(0, "ムーンサルト", 0.1, 0.3, "ken01", "ken00", 77, 40, 20)
	monster.set_variable(0, 0)
	monster.load_effect_script("ギルトーニシールド")
	monster.load_effect_script("ギルトーニ魔法")
	monster.load_effect_script("ギルトーニ魔法サブ")
	monster.set_clip_distance(60.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_8690(var0)
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_c3e8ae39(16)
	helper_191c()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(5.0, 0.05, 20)
	helper_56d63eae()
	monster.set_action_status(1)
	helper_c3e8ae39(30)
	monster.set_action_status(0)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_monster_attributes(32, 1)
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_monster_attributes(32, 0)
	helper_191c()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
end

--- Guards against a hit.
function script.on_guard()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
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
	monster.create_effect_1("ギルトーニシールド")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	helper_56d63eae()
	helper_c3e8ae39(8)
	monster.set_motion("立ち")
end

--- Dodges the target's first kind of attack.
script.on_dodge_1 = helper_2d70

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
function script.on_death()
	monster.stop_moving()
	helper_442b9962()
	monster.set_monster_attributes(2, 1)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.start_death()
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
	helper_c3e8ae39(30)
	monster.request_event_script(501)
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

return script
