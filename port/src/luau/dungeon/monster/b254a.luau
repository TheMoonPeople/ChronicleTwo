--!strict
-- dungeon/monster/b254a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_206033b2 = require("@lib/monster/helper_206033b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57d45e2e = require("@lib/monster/helper_57d45e2e")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_754712d9 = require("@lib/monster/helper_754712d9")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_7e925497 = require("@lib/monster/helper_7e925497")
local helper_80832373 = require("@lib/monster/helper_80832373")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a4ff7523 = require("@lib/monster/helper_a4ff7523")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9b0f992 = require("@lib/monster/helper_b9b0f992")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d742309a = require("@lib/monster/helper_d742309a")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_dc78fc76 = require("@lib/monster/helper_dc78fc76")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e7936dab = require("@lib/monster/helper_e7936dab")
local helper_f2cf0297 = require("@lib/monster/helper_f2cf0297")
local helper_f2f4e524 = require("@lib/monster/helper_f2f4e524")

--- Helper function.
local function helper_1c54()
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
local function helper_11a90()
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
		local _ = helper_8be991f0(1.75, vm.f32(4.2), var3, var4, 44.0, 30)
		helper_890ee63a(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(44.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_13264()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", 0.45, 0)
			helper_890ee63a(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(160.0, 75.0, 75)
		else
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(160.0, 75.0, 30)
		end
	else
		monster.set_motion("歩き", 0.45, 0)
		helper_890ee63a(vm.f32(4.2))
		monster.set_motion("歩き", -1.0, 0)
		helper_b9b0f992(1.75, vm.f32(4.2), 44.0, 45)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_12d2c()
	local argc: s32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", 0.45, 0)
			helper_890ee63a(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(160.0, 75.0, 45)
		else
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(160.0, 75.0, 30)
		end
	else
		monster.set_motion("歩き", 0.45, 0)
		helper_890ee63a(vm.f32(4.2))
		monster.set_motion("歩き", -1.0, 0)
		helper_b9b0f992(1.75, vm.f32(4.2), 44.0, 75)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_10d94()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.set_motion("歩き", 0.45, 0)
	helper_890ee63a(vm.f32(4.2))
	monster.set_motion("攻撃１", -1, 6)
	helper_754712d9(vm.f32(4.2), helper_9df6409a(24))
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var4) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var4) * 100.0))
	monster.move_toward_position(pos_x, pos_y - 20.0, pos_z, 1.75, 1.75)
	helper_c3e8ae39(helper_9df6409a(7))
	monster.stop_moving()
	helper_56d63eae()
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_11504()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.set_motion("歩き", 0.45, 0)
	helper_890ee63a(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 6)
	helper_754712d9(vm.f32(4.2), helper_9df6409a(12))
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var4) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var4) * 100.0))
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.625, 2.625)
	helper_c3e8ae39(helper_9df6409a(17))
	monster.stop_moving()
	helper_56d63eae()
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_11308()
	monster.set_motion("歩き", 0.45, 0)
	helper_890ee63a(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 2)
	helper_f2f4e524(vm.f32(4.2))
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_1041c()
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var6) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var6) * 100.0))
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	helper_c3e8ae39(helper_9df6409a(12))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y - 20.0, pos_z, 4.2, 4.2)
	helper_c3e8ae39(helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_56d63eae()
end

--- Helper function.
local function helper_1095c(arg0: s32)
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	var5 = monster.get_target_distance() or var5
	if arg0 ~= 0 then
		monster.set_motion("歩き右", -1, 0)
		var4 = -45.0
	else
		monster.set_motion("歩き左", -1, 0)
		var4 = 45.0
	end
	if var5 < 88.0 then
		var5 = vm.f32(var5 + 30.0)
	end
	target, target_2, target_3 = helper_125e5305(var4, var5, target, target_2, target_3)
	monster.move_toward_position(target, target_2, target_3, 1.75, 1.75)
	helper_754712d9(vm.f32(4.2), helper_9df6409a(40))
	monster.stop_moving()
end

--- Helper function.
local function helper_12654()
	local argc: s32 = 0
	local var3: f32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 70 then
		argc = monster.get_random(100) or argc
		if argc < 70 then
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(4.2))
			monster.set_motion("走り", -1, 0)
			helper_f2cf0297(vm.f32(4.2), vm.f32(4.2), 44.0, 75)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				helper_10d94()
			else
				helper_11504()
			end
		else
			monster.set_motion("歩き", -1, 0)
			helper_b9b0f992(1.75, vm.f32(4.2), 44.0, 90)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				helper_10d94()
			else
				helper_11308()
			end
		end
	else
		var3 = monster.get_target_distance() or var3
		if var3 < 66.0 then
			helper_1041c()
		end
		argc = monster.get_random(100) or argc
		if argc < 50 then
			helper_1095c(1)
		else
			helper_1095c(0)
		end
	end
end

--- Helper function.
local function helper_13760()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		monster.get_life()
		helper_57d45e2e()
		var0 = monster.get_target_distance() or var0
		if var0 > 300.0 then
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
			helper_11a90()
			continue
		end
		if var0 < 300.0 and var0 >= 240.0 then
			helper_13264()
		elseif var0 < 240.0 and var0 >= 160.0 then
			helper_12d2c()
		else
			helper_12654()
		end
	end
end

--- Helper function.
local function helper_db2c()
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
	if var17 < 44.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", 0.45, 0)
		helper_595cbf61(var7, vm.f32(4.2))
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 44.0)
		if var17 > 0.0 then
			helper_a4ff7523(vm.f32(4.2), 1.75, var7, var17, 44.0, 30)
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
				helper_80832373(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.2), var5, var18, 44.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_595cbf61(var19, vm.f32(4.2))
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
	if argc < 40 then
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
			monster.set_motion("歩き", 0.45, 0)
			helper_595cbf61(var7, vm.f32(4.2))
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
					var1 = helper_8be991f0(1.75, vm.f32(4.2), var20, var21, 44.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_595cbf61(var23, vm.f32(4.2))
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
					helper_e7936dab(1.75, var7, 1000.0, 44.0, 60)
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
			helper_dc78fc76(1.75, vm.f32(4.2), var5, 360.0, 40.0, 44.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_11fa0()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	local var9: f32 = 0
	local argc: s32 = 0
	monster.get_life()
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		var3 = monster.get_target_distance() or var3
		if var3 > 300.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 2 then
			helper_11a90()
			continue
		end
		if var3 < 160.0 then
			monster.set_motion("走り", -1, 0)
			helper_b9b0f992(vm.f32(4.2), vm.f32(4.2), 44.0, 90)
			var9 = monster.get_target_distance() or var9
			if var9 < 110.0 then
				argc = monster.get_random(100) or argc
				if argc < 50 then
					helper_10d94()
				elseif var9 < 44.0 then
					helper_11308()
				else
					helper_11504()
				end
			end
		else
			monster.set_motion("走り", -1, 0)
			helper_b9b0f992(vm.f32(4.2), vm.f32(4.2), 44.0, 90)
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃１", 0.316, 0.409, 2, 3)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃１", 0.54, 0.595, 0, 1)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２", 0.544, 0.583, 2, 3)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２", 0.544, 0.583, 0, 1)
	monster.set_variable(0, 0)
	monster.set_variable(127, 0)
	helper_1c54()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local gekirin: s32 = 0
	local var2: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			helper_57d45e2e()
			var2 = monster.get_target_distance() or var2
			if var2 < 300.0 then
				helper_13760()
			else
				helper_db2c()
			end
		else
			helper_11fa0()
		end
	end
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
function script.on_knockdown()
	helper_d8cf1050()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_56d63eae()
	monster.set_action_status(1)
	helper_c3e8ae39(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(21.0)
	monster.reset_motion()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_c3e8ae39(12)
	monster.set_motion("立ち", 0)
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, var0, 0.0)
	vm.wait()
	helper_1041c()
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	local value: s32 = 0
	helper_02ce7891()
	value = monster.get_variable(127) or value
	value = vm.i32(value + 1)
	monster.set_variable(127, value)
	monster.set_motion("死に", -1, 2)
	helper_56d63eae()
	monster.spawn_death_effects()
	if value == 4 then
		monster.request_event_script(510)
	end
	while true do
		vm.wait()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_d742309a()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
	helper_206033b2()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_aa93a1aa()
	monster.stop_moving()
	monster.end_throw()
	helper_c3e8ae39(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("ダメージ", -1, 6)
	helper_c3e8ae39(12)
	helper_e05438b5()
end

return script
