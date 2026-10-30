--!strict
-- dungeon/monster/e229a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6d5002db = require("@lib/monster/helper_6d5002db")
local helper_72fec261 = require("@lib/monster/helper_72fec261")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_7e925497 = require("@lib/monster/helper_7e925497")
local helper_80832373 = require("@lib/monster/helper_80832373")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")
local helper_95b679db = require("@lib/monster/helper_95b679db")
local helper_96e38b97 = require("@lib/monster/helper_96e38b97")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a4ff7523 = require("@lib/monster/helper_a4ff7523")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_dc78fc76 = require("@lib/monster/helper_dc78fc76")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e7936dab = require("@lib/monster/helper_e7936dab")
local helper_f1703059 = require("@lib/monster/helper_f1703059")

--- Helper function.
local function helper_1c5c()
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
local function helper_12048()
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
			var4 = vm.f32(var4 + 120.0)
			if argc < 50 then
				var3 = vm.f32(-var3 - 30.0)
			else
				var3 = vm.f32(var3 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = helper_8be991f0(vm.f32(1.8), 3.0, var3, var4, 60.0, 30)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(60.0, 45.0, 30)
		end
	else
		helper_96e38b97()
	end
end

--- Helper function.
local function helper_143f8()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	var1 = monster.get_target_distance() or var1
	argc = monster.get_random(100) or argc
	if argc < 90 then
		argc = monster.get_random(100) or argc
		if argc < 95 then
			monster.set_motion("歩き", -1, 0)
			helper_6d5002db(vm.f32(1.8), 3.0, 60.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(60.0, 45.0, 75)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			var2 = -30.0
		else
			var2 = 30.0
		end
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(3.0)
		monster.set_motion("歩き", -1, 0)
		helper_8be991f0(vm.f32(1.8), 3.0, var2, var1, 120.0, 45)
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(3.0)
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(60.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_11cb8()
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃３", -1, 2)
	helper_c3e8ae39(helper_9df6409a(28))
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_13c88()
	local argc: s32 = 0
	local var3: f32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 50 then
		helper_11cb8()
	else
		argc = monster.get_random(100) or argc
		if argc < 90 then
			monster.set_motion("歩き", -1, 0)
			helper_6d5002db(vm.f32(1.8), 3.0, 60.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var3 = -30.0
				monster.set_motion("歩き左", -1, 0)
			else
				var3 = 30.0
				monster.set_motion("歩き右", -1, 0)
			end
			helper_c3e8ae39(helper_9df6409a(13))
			helper_95b679db(vm.f32(2.6999998), var3, 3.0, helper_9df6409a(9))
			monster.stop_moving()
			helper_c3e8ae39(helper_9df6409a(3))
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(60.0, 45.0, 30)
		end
	end
end

--- Helper function.
local function helper_11aa4()
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃２", -1, 2)
	helper_c3e8ae39(helper_9df6409a(28))
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_11564()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(6.0)
	monster.set_motion("攻撃１", -1, 2)
	helper_c3e8ae39(helper_9df6409a(12))
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
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(var4)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(var4)))
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.6999998, 2.6999998)
	helper_c3e8ae39(helper_9df6409a(15))
	monster.stop_moving()
	helper_c3e8ae39(helper_9df6409a(4))
end

--- Helper function.
local function helper_10ccc(arg0: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local argc: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("歩き左", -1, 6)
		var11 = vm.f32(var5 + vm.f32(1.5707964))
	else
		monster.set_motion("歩き右", -1, 6)
		var11 = vm.f32(var5 - vm.f32(1.5707964))
	end
	var10 = 100.0
	if var11 > vm.f32(3.1415927) then
		var11 = vm.f32(var11 - vm.f32(6.2831855))
	end
	if var11 <= vm.f32(-3.1415927) then
		var11 = vm.f32(var11 + vm.f32(6.2831855))
	end
	target = vm.f32(pos_x + vm.f32(vm.sin(var11) * var10))
	target_2 = vm.f32(pos_y - 20.0)
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(var11) * var10))
	helper_72fec261(vm.f32(0.444), -1.0)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target, target_2, target_3, arg0, arg0)
	helper_56d63eae()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_1063c(arg0: any)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	var7 = vm.f32(var5 + vm.f32(3.1415927))
	if var7 > vm.f32(3.1415927) then
		var7 = vm.f32(var7 - vm.f32(6.2831855))
	end
	if var7 <= vm.f32(-3.1415927) then
		var7 = vm.f32(var7 + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(var7)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(var7)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("歩き後", -1, 2)
	helper_72fec261(vm.f32(0.52), -1.0)
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.6999998, 2.6999998)
	helper_56d63eae()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_13148()
	local argc: s32 = 0
	local var2: s32 = 0
	local var5: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 65 then
		argc = monster.get_random(100) or argc
		if argc < 75 then
			monster.set_motion("歩き", -1, 0)
			helper_6d5002db(vm.f32(1.8), 3.0, 60.0, 45)
			helper_11cb8()
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 75 then
				helper_11aa4()
			else
				helper_11564()
			end
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_motion("歩き", -1, 0)
			helper_6d5002db(vm.f32(1.8), 3.0, 60.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 25 then
				argc = monster.get_random(100) or argc
				if argc < 50 then
					helper_10ccc(3.0)
				else
					helper_1063c(3.0)
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_890ee63a(3.0)
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var5 = -30.0
					monster.set_motion("歩き左", -1, 0)
				else
					var5 = 30.0
					monster.set_motion("歩き右", -1, 0)
				end
				var2 = 0
				helper_c3e8ae39(helper_9df6409a(13))
				helper_95b679db(vm.f32(2.6999998), var5, 3.0, 9)
				monster.stop_moving()
				helper_c3e8ae39(helper_9df6409a(3))
				var2 = var2 + 1
				monster.set_motion("歩き", -1, 0)
				helper_890ee63a(3.0)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_14ac0()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		helper_f1703059()
		var0 = monster.get_target_distance() or var0
		if var0 > 400.0 then
			vm.wait()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_12048()
			continue
		end
		if var0 < 400.0 and var0 >= 180.0 then
			helper_143f8()
		elseif var0 < 180.0 and var0 >= 120.0 then
			helper_13c88()
		else
			helper_13148()
		end
	end
end

--- Helper function.
local function helper_db34()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var15: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	helper_0ba23e4e()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var5 = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or var5
	do
		local _, out2, _ = monster.get_rotation()
		var15 = out2 or var15
	end
	var17 = monster.get_clear_distance(100.0, 0.0) or var17
	if var17 < 60.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1.0, 0)
		helper_595cbf61(var7, 3.0)
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 60.0)
		if var17 > 0.0 then
			helper_a4ff7523(3.0, vm.f32(1.8), var7, var17, 60.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if var5 > 300.0 then
		argc = monster.get_random(100) or argc
		if argc < 90 then
			if var5 > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			argc = monster.get_random(100) or argc
			if argc < 30 then
				monster.set_variable(0, 4)
				argc = monster.get_random(100) or argc
				var18 = monster.get_random_whole_number(360.0) or var18
				var5 = monster.get_random_whole_number(150.0) or var5
				if argc < 50 then
					var18 = vm.f32(-var18 - 30.0)
				else
					var18 = vm.f32(var18 + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				helper_80832373(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.8), 3.0, var5, var18, 60.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_595cbf61(var19, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.get_random(100, argc)
			return
		end
	end
	argc = monster.get_random(100) or argc
	if argc < 75 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			helper_7e925497(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			helper_595cbf61(var7, 3.0)
			monster.set_motion("立ち", -1, 0)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_variable(0, 4)
					argc = monster.get_random(100) or argc
					var20 = monster.get_random_whole_number(180.0) or var20
					var21 = monster.get_random_whole_number(30.0) or var21
					var22 = monster.get_target_distance() or var22
					var21 = vm.f32(var21 + var22)
					if argc < 50 then
						var20 = vm.f32(var20 * -1.0)
					end
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var20 = vm.f32(-var20 - 30.0)
					else
						var20 = vm.f32(var20 + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					var1 = helper_8be991f0(vm.f32(1.8), 3.0, var20, var21, 60.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_595cbf61(var23, 3.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						var15 = out2 or var15
					end
					var7 = helper_28452e16(var15)
					if var7 > vm.f32(3.1415927) then
						var7 = vm.f32(var7 - vm.f32(6.2831855))
					end
					if var7 <= vm.f32(-3.1415927) then
						var7 = vm.f32(var7 + vm.f32(6.2831855))
					end
					helper_e7936dab(vm.f32(1.8), var7, 1000.0, 60.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
		elseif var2 == 8 then
			monster.set_variable(0, 1)
			argc = monster.get_random(120) or argc
			var5 = monster.get_target_distance() or var5
			argc = vm.i32(argc + 15)
			monster.set_motion("歩き", -1.0, 0)
			helper_dc78fc76(vm.f32(1.8), 3.0, var5, 360.0, 40.0, 60.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_125c4()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local gekirin: s32 = 0
	local var9: f32 = 0
	monster.get_life_int()
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_12048()
			continue
		end
		var3 = monster.get_target_distance() or var3
		if var3 < 120.0 then
			argc = monster.get_random(100) or argc
			if argc < 34 then
				helper_11564()
			else
				argc = monster.get_random(100) or argc
				if argc < 50 then
					helper_11aa4()
				else
					helper_11cb8()
				end
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 15 then
				helper_11cb8()
			else
				argc = monster.get_random(100) or argc
				if argc < 90 then
					monster.set_motion("歩き", -1, 0)
					helper_6d5002db(vm.f32(2.16), 3.0, 60.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					helper_890ee63a(3.0)
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var9 = -30.0
						monster.set_motion("歩き左", -1, 4)
					else
						var9 = 30.0
						monster.set_motion("歩き右", -1, 4)
					end
					for var10 = 0, 2 do
						helper_c3e8ae39(helper_9df6409a(13))
						helper_95b679db(vm.f32(1.8), var9, 3.0, helper_9df6409a(9))
						monster.stop_moving()
						helper_c3e8ae39(helper_9df6409a(3))
					end
					monster.set_motion("歩き", -1, 0)
					helper_890ee63a(3.0)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("通常毒", 8.0, "攻撃１", 0.353, 0.42, 0)
	monster.register_damage_hit("通常乾き", 6.0, "攻撃２", 0.321, 0.536, 1)
	monster.register_damage_hit("Ｋミミック", 8.0, "攻撃３", 0.5, 0.607, 2)
	helper_1c5c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local gekirin: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			helper_f1703059()
			var0 = monster.get_target_distance() or var0
			if var0 < 400.0 then
				helper_14ac0()
			else
				helper_db34()
			end
		else
			helper_125c4()
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
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_1063c(3.0)
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	helper_10ccc(3.0)
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
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
	monster.set_motion("ダメージ", -1, 6)
	helper_c3e8ae39(3)
	helper_e05438b5()
end

return script
