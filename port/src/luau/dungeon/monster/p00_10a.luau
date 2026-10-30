--!strict
-- dungeon/monster/p00_10a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_6eaf9360 = require("@lib/monster/helper_6eaf9360")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_9ded5535 = require("@lib/monster/helper_9ded5535")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_79dc()
	local value: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	value = 0
	var1 = monster.get_target_distance() or var1
	if var1 <= 50.0 then
		value = vm.i32(bit32.bor(value, 1))
	elseif var1 <= 240.0 then
		value = vm.i32(bit32.bor(value, 2))
	elseif var1 <= 760.0 then
		value = vm.i32(bit32.bor(value, 4))
	else
		value = vm.i32(bit32.bor(value, 8))
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	var5 = monster.get_vector_length(var2, var3, var4) or var5
	if var5 >= 600.0 then
		value = vm.i32(bit32.bor(value, 4096))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	var5 = monster.get_vector_length(var2, var3, var4) or var5
	if var5 >= 600.0 then
		value = vm.i32(bit32.bor(value, 8192))
	end
	if var1 <= 240.0 then
		value = vm.i32(bit32.bor(value, 16))
	end
	if helper_6eaf9360(0, 45.0) ~= 0 then
		value = vm.i32(bit32.bor(value, 32))
	end
	if var1 <= 90.0 then
		value = vm.i32(bit32.bor(value, 64))
	end
	if helper_6eaf9360(0, 80.0) ~= 0 then
		value = vm.i32(bit32.bor(value, 128))
	end
	if var1 <= 4000.0 then
		value = vm.i32(bit32.bor(value, 256))
	end
	if helper_6eaf9360(0, 60.0) ~= 0 then
		value = vm.i32(bit32.bor(value, 512))
	end
	if var1 <= 4000.0 then
		value = vm.i32(bit32.bor(value, 1024))
	end
	if helper_6eaf9360(0, 360.0) ~= 0 then
		value = vm.i32(bit32.bor(value, 2048))
	end
	monster.set_variable(0, value)
end

--- Helper function.
local function helper_84d0()
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	local value_4: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local value_5: s32 = 0
	value = monster.get_variable(2) or value
	if value ~= -1 then
		value_2 = monster.get_variable(3) or value_2
		value_3 = monster.get_variable(4) or value_3
		monster.set_variable(1, value)
		monster.set_variable(2, value_2)
		monster.set_variable(3, value_3)
		monster.set_variable(4, -1)
		return
	end
	value_4 = monster.get_variable(0) or value_4
	if bit32.band(value_4, 8192) ~= 0 then
		monster.set_variable(1, 10)
		monster.set_variable(4, 7)
	end
	if bit32.band(value_4, 2) == 0 then
		if bit32.band(value_4, 4096) ~= 0 then
			monster.set_variable(1, 5)
			argc = monster.get_random(100) or argc
			if argc < 55 then
				monster.set_variable(2, 12)
				monster.set_variable(3, 1)
				monster.set_variable(4, 7)
			else
				monster.set_variable(2, 3)
				monster.set_variable(3, 12)
			end
			return
		end
	end
	if bit32.band(value_4, 1) ~= 0 then
		monster.set_variable(1, 10)
		argc = monster.get_random(100) or argc
		if vm.imod(argc, 2) == 0 then
			monster.set_variable(2, 8)
			monster.set_variable(3, 11)
			monster.set_variable(4, 7)
		else
			monster.set_variable(2, 6)
			monster.set_variable(3, 8)
		end
		return
	end
	if bit32.band(value_4, 2) ~= 0 then
		if bit32.band(value_4, 192) == 192 then
			monster.set_variable(1, 2)
			monster.set_variable(2, 7)
			return
		end
		if bit32.band(value_4, 48) == 48 then
			monster.set_variable(1, 1)
			argc = monster.get_random(100) or argc
			if vm.imod(argc, 3) == 0 then
				monster.set_variable(2, 2)
				monster.set_variable(3, 7)
			else
				monster.set_variable(2, 7)
			end
			return
		end
		argc = monster.get_random(30) or argc
		argc = vm.i32(argc + 30)
		monster.set_variable(1, 9)
		monster.set_variable(2, 11)
		monster.set_variable(3, 7)
		monster.set_variable(5, argc)
		return
	end
	if bit32.band(value_4, 4) ~= 0 then
		argc_2 = 0
		argc_2 = monster.get_random(100) or argc_2
		value_5 = monster.get_variable(7) or value_5
		if bit32.band(value_5, 4) == 0 and argc_2 < 20 then
			monster.set_variable(7, vm.i32(bit32.bor(value_5, 4)))
			monster.set_variable(1, 10)
			monster.set_variable(2, 4)
		else
			argc_2 = monster.get_random(100) or argc_2
			if vm.imod(argc_2, 4) == 0 then
				if bit32.band(value_4, 512) == 0 then
					monster.set_variable(1, 9)
					monster.set_variable(2, 3)
					monster.set_variable(3, 7)
					argc_2 = monster.get_random(100) or argc_2
					if argc_2 < 50 then
						monster.set_variable(4, 8)
					end
				else
					monster.set_variable(1, 3)
					monster.set_variable(2, 7)
					argc_2 = monster.get_random(100) or argc_2
					if argc_2 < 50 then
						monster.set_variable(3, 8)
					end
				end
			elseif bit32.band(value_4, 32) == 0 then
				monster.set_variable(1, 9)
				monster.set_variable(2, 1)
				monster.set_variable(3, 7)
			else
				monster.set_variable(2, 1)
				monster.set_variable(3, 7)
			end
		end
		return
	end
	if bit32.band(value_4, 8) ~= 0 then
		monster.set_variable(1, 5)
		monster.set_variable(2, 7)
		return
	end
	monster.set_variable(1, 7)
end

--- Helper function.
local function helper_5e08()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	argc = monster.get_random(60) or argc
	argc = vm.i32(argc + 90)
	while true do
		argc = vm.i32(argc - 1)
		if argc <= 0 then
			monster.set_motion("立ち")
			return
		end
		var1 = monster.get_target_distance() or var1
		if var1 <= 90.0 then
			monster.set_motion("立ち")
			helper_442b9962()
			monster.stop_moving()
			return
		end
		if var1 > 880.0 then
			monster.set_motion("立ち")
			helper_442b9962()
			monster.stop_moving()
			return
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		var5 = monster.get_vector_length(var2, var3, var4) or var5
		if var5 >= 600.0 then
			monster.set_motion("立ち")
			helper_442b9962()
			monster.stop_moving()
			return
		end
		monster.set_motion("歩き")
		do
			local out1, _, out3 = monster.get_point_from_facing(0.0, 8.0)
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		helper_82cb5588(vm.f32(0.05235988))
		monster.move_toward_position(pos_x, 0.0, pos_z, 8.0, 1.0)
		vm.wait()
	end
end

--- Helper function.
local function helper_65bc()
	local argc: s32 = 0
	local var1: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	argc = monster.get_random(90) or argc
	argc = vm.i32(argc + 90)
	while true do
		argc = vm.i32(argc - 1)
		if argc <= 0 then
			monster.set_motion("立ち")
			return
		end
		var1 = monster.get_target_distance() or var1
		if var1 <= 240.0 then
			monster.set_motion("立ち")
			helper_442b9962()
			monster.stop_moving()
			return
		end
		monster.set_motion("歩き")
		do
			local out1, _, out3 = monster.get_point_from_facing(0.0, 8.0)
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		helper_82cb5588(vm.f32(0.05235988))
		monster.move_toward_position(pos_x, 0.0, pos_z, 8.0, 1.0)
		vm.wait()
	end
end

--- Helper function.
local function helper_6b94()
	local var0: f32 = 0
	local var2: f32 = 0
	local yaw: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: f32 = 0
	local muteki_time: s32 = 0
	local var12: s32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local var17: f32 = 0
	do
		local out1, _, out3 = monster.get_target_position()
		var0 = out1 or var0
		var2 = out3 or var2
	end
	yaw = monster.get_angle_between_positions(var0, 0.0, var2, 0.0, 0.0, 0.0) or yaw
	x = vm.f32(vm.sin(yaw) * 400.0)
	y = 0.0
	z = vm.f32(vm.cos(yaw) * 400.0)
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ジャンプ上昇", -1, 2)
	monster.set_monster_attributes(20, 1)
	helper_c3e8ae39(17)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var10 = vm.f32(-0.7)
	muteki_time = 50
	monster.set_invulnerable_time(muteki_time)
	var12 = 0
	while var12 <= muteki_time do
		helper_82cb5588(vm.f32(0.06981317))
		var17 = vm.f32(
			vm.fdiv(
				vm.f32(vm.f32(vm.f32(y - pos_y) * 2.0) - vm.f32(vm.f32(var10 * (muteki_time + 1)) * (muteki_time + 1))),
				vm.f32((muteki_time + 1) * 2.0)
			)
		)
		y_2 = pos_y
		for var13 = 0, var12 - 1 do
			var17 = vm.f32(var17 + var10)
			y_2 = vm.f32(y_2 + var17)
		end
		x_2 = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(x - pos_x) * var12), muteki_time)) + pos_x)
		z_2 = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(z - pos_z) * var12), muteki_time)) + pos_z)
		if y_2 < y then
			y_2 = y
		end
		monster.set_position(x_2, y_2, z_2)
		if var12 == 7 then
			monster.set_motion("ジャンプＬ")
		end
		if var12 == muteki_time - 16 + 6 then
			monster.set_motion("ジャンプ下降", -1, 2)
		end
		var12 = var12 + 1
		vm.wait()
	end
	monster.shake_camera(6.0, 20)
	monster.set_position(x, y, z)
	helper_442b9962()
	monster.set_monster_attributes(52, 0)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_c3e8ae39(16)
end

--- Helper function.
local function helper_1ad0()
	local var1: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	while true do
		do
			local _, out2, _ = monster.get_rotation()
			var1 = out2 or var1
		end
		var3 = monster.get_target_angle() or var3
		if helper_8971d3b6(var3, var1, vm.f32(0.034906585)) == 0 then
			helper_442b9962()
			break
		else
			var4 = monster.get_target_distance() or var4
			if var4 < 50.0 then
				helper_9ded5535()
				helper_442b9962()
				break
			else
				monster.set_motion("旋回")
				helper_82cb5588(vm.f32(0.034906585))
				vm.wait()
			end
		end
	end
	monster.set_motion("立ち")
end

--- Helper function.
local function helper_5384()
	local argc: s32 = 0
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 0.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
	else
		do
			local out1, out2, out3 = monster.get_point_from_facing(1.5707964, 20.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
	end
	monster.set_motion("ミサイル発射", -1, 2)
	helper_c3e8ae39(28)
	do
		local _, out2, _ = monster.get_rotation()
		var6 = out2 or var6
	end
	pos_y = vm.f32(pos_y + 60.0)
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("ロボミサイル")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, 0.0, var6, 0.0)
	monster.set_effect_target(-1, 0)
	monster.set_effect_value(-1, 0, attack)
	helper_56d63eae()
	monster.set_motion("立ち", -1)
	helper_c3e8ae39(30)
end

--- Helper function.
local function helper_4e28()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local attack: s32 = 0
	monster.set_motion("叩き潰し", -1, 2)
	helper_c3e8ae39(18)
	do
		local out1, _, out3 = monster.get_frame_position("col_LH1")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	do
		local out1, _, out3 = monster.get_frame_position("col_RH1")
		pos_x_2 = out1 or pos_x_2
		pos_z_2 = out3 or pos_z_2
	end
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x, 0.0, pos_z)
	monster.set_effect_value(-1, 0, attack)
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x_2, 0.0, pos_z_2)
	monster.set_effect_value(-1, 0, attack)
	monster.shake_camera(4.0, 20)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_c3e8ae39(8)
end

--- Helper function.
local function helper_4a38()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local value: s32 = 0
	monster.set_motion("鼻爆弾", -1, 2)
	helper_c3e8ae39(10)
	do
		local out1, out2, out3 = monster.get_point_from_facing(0.24, 25.0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_y = vm.f32(pos_y + 30.0)
	var4 = monster.get_target_angle() or var4
	monster.create_monster(1000, pos_x, pos_y, pos_z, var4)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_c3e8ae39(8)
	value = monster.get_variable(7) or value
	if bit32.band(value, 2) == 0 then
		monster.set_variable(7, vm.i32(bit32.bor(value, 2)))
		monster.request_event_script(540)
	end
end

--- Helper function.
local function helper_1e60()
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
	local var10: f32 = 0
	local var11: f32 = 0
	local muteki_time: s32 = 0
	local var13: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	monster.set_monster_attributes(52, 1)
	monster.set_motion("ジャンプ上昇", -1, 2)
	helper_c3e8ae39(17)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var7 = monster.get_vector_length(var3, var4, var5) or var7
	if var7 >= 600.0 then
		var3 = 0.0
		var4 = 0.0
		var5 = 0.0
	end
	var6 = monster.get_target_angle() or var6
	do
		local out1, out2, out3 = monster.get_rotation()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var8 = vm.f32(0.0 - var8)
	var9 = vm.f32(var6 - var9)
	var10 = vm.f32(0.0 - var10)
	var8 = monster.wrap_angle(var8) or var8
	var9 = monster.wrap_angle(var9) or var9
	var10 = monster.wrap_angle(var10) or var10
	var8 = vm.f32(var8 / 20.0)
	var9 = vm.f32(var9 / 20.0)
	var10 = vm.f32(var10 / 20.0)
	var11 = vm.f32(-0.7)
	muteki_time = 50
	monster.set_invulnerable_time(muteki_time)
	var13 = 0
	while var13 <= muteki_time do
		var18 = vm.f32(
			vm.fdiv(
				vm.f32(
					vm.f32(vm.f32(var4 - pos_y) * 2.0) - vm.f32(vm.f32(var11 * (muteki_time + 1)) * (muteki_time + 1))
				),
				vm.f32((muteki_time + 1) * 2.0)
			)
		)
		y = pos_y
		for var14 = 0, var13 - 1 do
			var18 = vm.f32(var18 + var11)
			y = vm.f32(y + var18)
		end
		x = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(var3 - pos_x) * var13), muteki_time)) + pos_x)
		z = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(var5 - pos_z) * var13), muteki_time)) + pos_z)
		if y <= var4 then
			y = var4
		end
		monster.set_position(x, y, z)
		if var13 == 7 then
			monster.set_motion("ジャンプＬ")
		end
		if var13 == muteki_time - 16 + 6 then
			monster.set_motion("ジャンプ下降", -1, 2)
		end
		if var13 >= 10 and var13 < 30 then
			do
				local out1, out2, out3 = monster.get_rotation()
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			var19 = vm.f32(var19 + var8)
			var20 = vm.f32(var20 + var9)
			var21 = vm.f32(var21 + var10)
			var19 = monster.wrap_angle(var19) or var19
			var20 = monster.wrap_angle(var20) or var20
			var21 = monster.wrap_angle(var21) or var21
			monster.set_rotation(var19, var20, var21)
		end
		var13 = var13 + 1
		vm.wait()
	end
	monster.shake_camera(6.0, 20)
	monster.set_position(var3, var4, var5)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_c3e8ae39(16)
	monster.set_monster_attributes(52, 0)
end

--- Helper function.
local function helper_3038()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: f32 = 0
	local muteki_time: s32 = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local angle: f32 = 0
	local angle_2: f32 = 0
	local angle_3: f32 = 0
	local argc: s32 = 0
	monster.set_monster_attributes(53, 1)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var6 = monster.get_target_angle() or var6
	x = vm.f32(vm.sin(var6) * 980.0)
	y = 400.0
	z = vm.f32(vm.cos(var6) * 980.0)
	do
		local out1, out2, out3 = monster.get_rotation()
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	var10 = 1
	if var10 == 1 then
		var7 = vm.f32(vm.f32(var6 - vm.f32(1.5707964)) - var7)
		var8 = vm.f32(0.0 - var8)
		var9 = vm.f32(vm.f32(1.5707964) - var9)
	else
		var7 = vm.f32(vm.f32(var6 + vm.f32(1.5707964)) - var7)
		var8 = vm.f32(0.0 - var8)
		var9 = vm.f32(vm.f32(-1.5707964) - var9)
	end
	var7 = monster.wrap_angle(var7) or var7
	var8 = monster.wrap_angle(var8) or var8
	var9 = monster.wrap_angle(var9) or var9
	var7 = vm.f32(var7 / 20.0)
	var8 = vm.f32(var8 / 20.0)
	var9 = vm.f32(var9 / 20.0)
	monster.set_motion("ジャンプ上昇", -1, 2)
	helper_c3e8ae39(17)
	var11 = vm.f32(-0.7)
	muteki_time = 50
	monster.set_invulnerable_time(muteki_time)
	var14 = 0
	var13 = 0
	while var13 <= muteki_time do
		var19 = vm.f32(
			vm.fdiv(
				vm.f32(vm.f32(vm.f32(y - pos_y) * 2.0) - vm.f32(vm.f32(var11 * (muteki_time + 1)) * (muteki_time + 1))),
				vm.f32((muteki_time + 1) * 2.0)
			)
		)
		y_2 = pos_y
		for var15 = 0, var13 - 1 do
			var19 = vm.f32(var19 + var11)
			y_2 = vm.f32(y_2 + var19)
		end
		x_2 = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(x - pos_x) * var13), muteki_time)) + pos_x)
		z_2 = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(z - pos_z) * var13), muteki_time)) + pos_z)
		if y_2 > y then
			var14 = 1
		end
		if var14 == 1 and y_2 < y then
			y_2 = y
		end
		monster.set_position(x_2, y_2, z_2)
		if var13 == 7 then
			monster.set_motion("ジャンプＬ")
		end
		if var13 == muteki_time - 16 then
			monster.set_motion("ジャンプ下降", -1, 2)
		end
		if var13 >= 30 then
			do
				local out1, out2, out3 = monster.get_rotation()
				var20 = out1 or var20
				var21 = out2 or var21
				var22 = out3 or var22
			end
			var20 = vm.f32(var20 + var7)
			var21 = vm.f32(var21 + var8)
			var22 = vm.f32(var22 + var9)
			var20 = monster.wrap_angle(var20) or var20
			var21 = monster.wrap_angle(var21) or var21
			var22 = monster.wrap_angle(var22) or var22
			monster.set_rotation(var20, var21, var22)
		end
		var13 = var13 + 1
		vm.wait()
	end
	angle = vm.f32(var6 - vm.f32(1.5707964))
	angle = monster.wrap_angle(angle) or angle
	if var10 == 1 then
		monster.set_rotation(angle, 0.0, 1.57)
	else
		monster.set_rotation(angle, 0.0, 1.57)
	end
	helper_56d63eae()
	monster.set_motion("歩き")
	while true do
		x = vm.f32(vm.sin(var6) * 980.0)
		y = 400.0
		z = vm.f32(vm.cos(var6) * 980.0)
		monster.set_position(x, y, z)
		if var10 == 1 then
			angle_2 = vm.f32(var6 - vm.f32(1.5707964))
			angle_2 = monster.wrap_angle(angle_2) or angle_2
			monster.set_rotation(angle_2, 0.0, 1.57)
			var6 = vm.f32(var6 - vm.f32(0.01))
		else
			angle_3 = vm.f32(var6 - vm.f32(1.5707964))
			angle_3 = monster.wrap_angle(angle_3) or angle_3
			monster.set_rotation(angle_3, 0.0, 1.57)
			var6 = vm.f32(var6 + vm.f32(0.01))
		end
		var6 = monster.wrap_angle(var6) or var6
		argc = monster.get_monster_count() or argc
		if argc <= 1 then
			break
		else
			monster.set_invulnerable_time(1)
			vm.wait()
		end
	end
	helper_1e60()
	monster.set_monster_attributes(53, 0)
end

--- Helper function.
local function helper_59c4()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.set_monster_attributes(32, 1)
	monster.set_motion("産み落とし", -1, 2)
	helper_c3e8ae39(10)
	do
		local out1, out2, out3 = monster.get_point_from_facing(3.1415927, 32.0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_y = vm.f32(pos_y + 135.0)
	for var3 = 0, 5 do
		helper_c3e8ae39(5)
		monster.create_monster(25, pos_x, pos_y, pos_z)
	end
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_c3e8ae39(8)
	monster.set_camera_mode(0)
	helper_3038()
	monster.set_camera_mode(1)
end

--- Helper function.
local function helper_6a84()
	local value: s32 = 0
	value = monster.get_variable(5) or value
	helper_c3e8ae39(value)
	monster.set_variable(5, 40)
end

--- Helper function.
local function helper_9ccc()
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	value = monster.get_variable(1) or value
	if value == 8 then
		helper_5e08()
	end
	if value == 12 then
		helper_65bc()
	end
	if value == 10 then
		helper_6b94()
	end
	if value == 9 then
		helper_1ad0()
	end
	if value == 6 then
		value_2 = monster.get_variable(0) or value_2
		if bit32.band(value_2, 4096) ~= 0 then
			helper_5384()
			return
		end
		if bit32.band(value_2, 192) == 192 then
			helper_4e28()
			return
		end
		if bit32.band(value_2, 48) == 48 then
			helper_4a38()
			return
		end
		if bit32.band(value_2, 768) == 768 then
			helper_5384()
			return
		end
		helper_1e60()
	end
	if value == 11 then
		value_3 = monster.get_variable(0) or value_3
		if bit32.band(value_3, 48) == 48 then
			helper_4a38()
			return
		end
		if bit32.band(value_3, 192) == 192 then
			helper_4e28()
			return
		end
	end
	if value == 1 then
		helper_4a38()
	end
	if value == 2 then
		helper_4e28()
	end
	if value == 3 then
		helper_5384()
	end
	if value == 4 then
		helper_59c4()
	end
	if value == 5 then
		helper_1e60()
	end
	if value == 7 then
		monster.set_motion("立ち")
		helper_6a84()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_entry_object(0, "col_head")
	monster.register_entry_object(1, "col_LF1")
	monster.register_entry_object(2, "col_LH2")
	monster.register_entry_object(3, "col_LH1")
	monster.register_entry_object(4, "col_RF1")
	monster.register_entry_object(5, "col_RH1")
	monster.register_entry_object(6, "col_RH2")
	monster.register_damage_hit("通常攻撃", 15.0, "叩き潰し", 0.332, 0.545, 2)
	monster.register_damage_hit("通常攻撃", 15.0, "叩き潰し", 0.332, 0.545, 4)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 2)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 3)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 4)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 5)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 2)
	monster.set_variable(3, 7)
	monster.set_variable(4, -1)
	monster.set_variable(5, 40)
	monster.set_variable(6, 0)
	monster.set_variable(7, 0)
	monster.load_effect_script("ロボミサイル")
	monster.load_effect_script("ロボミサイル爆発")
	monster.load_effect_script("ロボミサイル煙")
	monster.load_effect_script("ヴァンガード衝撃波")
	monster.set_photo_opportunity("ミサイル発射", 0.3, 0.6, 1014)
	monster.set_motion("", -1, 2)
	monster.set_clip_distance(120.0)
	monster.set_motion("立ち", -1, 4)
	monster.set_camera_mode(4)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local value_2: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	value = monster.get_variable(6) or value
	if value ~= 0 then
		if value == 120 then
			monster.stop_moving()
			helper_442b9962()
			monster.set_invulnerable_time(38)
			monster.set_motion("倒れ", -1, 2)
			helper_56d63eae()
			value_2 = monster.get_variable(7) or value_2
			if bit32.band(value_2, 1) == 0 then
				monster.set_variable(7, vm.i32(bit32.bor(value_2, 1)))
				monster.request_event_script(530)
			end
		end
		while value > 0 do
			value = value - 1
			monster.set_variable(6, value)
			vm.wait()
		end
		monster.set_invulnerable_time(35)
		monster.set_motion("立ち戻り", -1, 6)
		helper_56d63eae()
		monster.set_motion("立ち")
	end
	monster.set_motion("立ち")
	while true do
		helper_79dc()
		helper_84d0()
		helper_9ccc()
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.set_monster_attributes(52, 0)
	helper_9ded5535()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.set_monster_attributes(52, 0)
	helper_9ded5535()
end

--- Guards against a hit.
function script.on_guard()
	monster.set_monster_attributes(52, 0)
	helper_9ded5535()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	monster.set_monster_attributes(52, 0)
	helper_9ded5535()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	monster.set_monster_attributes(52, 0)
	helper_9ded5535()
end

--- Runs the monster's death.
function script.on_death()
	monster.reset_camera_limits()
	monster.set_camera_mode(0)
	monster.stop_moving()
	helper_442b9962()
	monster.set_monster_attributes(2, 1)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.start_death()
	monster.set_motion("倒れ", -1, 2)
	helper_56d63eae()
	helper_c3e8ae39(30)
	monster.request_event_script(520)
	monster.set_camera_mode(0)
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

--- Stuns the monster.
function script.on_stun()
	local value: s32 = 0
	value = monster.get_variable(6) or value
	if value == 0 then
		monster.set_variable(6, 120)
	end
	monster.set_monster_attributes(52, 0)
	helper_9ded5535()
end

return script
