--!strict
-- dungeon/monster/e55a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_754712d9 = require("@lib/monster/helper_754712d9")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_7e925497 = require("@lib/monster/helper_7e925497")
local helper_80832373 = require("@lib/monster/helper_80832373")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a4ff7523 = require("@lib/monster/helper_a4ff7523")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9b0f992 = require("@lib/monster/helper_b9b0f992")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_db9d7a2b = require("@lib/monster/helper_db9d7a2b")
local helper_dc78fc76 = require("@lib/monster/helper_dc78fc76")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e7936dab = require("@lib/monster/helper_e7936dab")
local helper_f2f4e524 = require("@lib/monster/helper_f2f4e524")

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
local function helper_ffdc(arg0: any)
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		helper_0ba23e4e()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				helper_890ee63a(vm.f32(2.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_102ac()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_ffdc(monster_id)
	end
end

--- Helper function.
local function helper_10b18()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 95.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = helper_8be991f0(vm.f32(1.2), vm.f32(2.8), var3, var4, 49.0, 30)
		helper_890ee63a(vm.f32(2.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(49.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_12188()
	local argc: s32 = 0
	local var2: f32 = 0
	local life: f32 = 0
	local var4: f32 = 0
	life = 0.0
	var2 = monster.get_target_distance() or var2
	argc = monster.get_random(100) or argc
	if argc < 60 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("立ち", -1, 0)
			helper_7e925497(100.0, 60.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 55 then
			life = monster.get_life() or life
			if life < vm.f32(0.3) then
				monster.set_motion("歩き", -1, 0)
				helper_b9b0f992(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1, 0)
				helper_b9b0f992(vm.f32(1.2), vm.f32(2.8), 49.0, 90)
				monster.set_motion("立ち", -1, 0)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var4 = -30.0
			else
				var4 = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(2.8))
			monster.set_motion("歩き", -1, 0)
			helper_8be991f0(vm.f32(1.2), vm.f32(2.8), var4, var2, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(49.0, 45.0, 30)
		end
	end
end

--- Helper function.
local function helper_106e4()
	monster.set_variable(0, 1)
	monster.set_motion("攻撃１", -1, 6)
	helper_f2f4e524(vm.f32(2.8))
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_108b8()
	monster.set_variable(0, 2)
	monster.set_motion("攻撃２", -1, 6)
	helper_754712d9(vm.f32(2.8), helper_9df6409a(38))
	helper_56d63eae()
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_118e4()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	monster.get_life()
	var3 = monster.get_target_distance() or var3
	argc = monster.get_random(100) or argc
	if argc < 65 then
		if var3 < 50.0 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				helper_106e4()
			else
				helper_108b8()
			end
		else
			monster.set_motion("歩き", -1, 0)
			helper_b9b0f992(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1, 0)
			helper_b9b0f992(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
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
			helper_8be991f0(vm.f32(1.2), vm.f32(2.8), var4, 98.0, 1.0, 25)
			helper_890ee63a(vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(9)
		end
	end
end

--- Helper function.
local function helper_12d00()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		monster.get_life()
		helper_102ac()
		var0 = monster.get_target_distance() or var0
		if var0 > 225.0 then
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
			helper_10b18()
			continue
		end
		if var0 < 225.0 and var0 >= 145.0 then
			helper_db9d7a2b()
		elseif var0 < 145.0 and var0 >= 95.0 then
			helper_12188()
		else
			helper_118e4()
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
	if var17 < 49.0 then
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1.0, 0)
		helper_595cbf61(var7, vm.f32(2.8))
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 49.0)
		if var17 > 0.0 then
			helper_a4ff7523(vm.f32(2.8), vm.f32(1.3), var7, var17, 49.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if var5 > 250.0 then
		argc = monster.get_random(100) or argc
		if argc < 90 then
			if var5 > 550.0 then
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
				helper_80832373(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.3), vm.f32(2.8), var5, var18, 49.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_595cbf61(var19, vm.f32(2.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 60.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.get_random(100, argc)
			return
		end
	end
	argc = monster.get_random(100) or argc
	if argc < 93 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			helper_7e925497(100.0, 60.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			helper_595cbf61(var7, vm.f32(2.8))
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
					var1 = helper_8be991f0(vm.f32(1.3), vm.f32(2.8), var20, var21, 49.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_595cbf61(var23, vm.f32(2.8))
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
					helper_e7936dab(vm.f32(1.3), var7, 1000.0, 49.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 60.0, 35.0, vm.f32(1.2), 30)
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
			helper_dc78fc76(vm.f32(1.3), vm.f32(2.8), var5, 360.0, 40.0, 49.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_11028()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	monster.get_life()
	while true do
		vm.wait()
		var3 = monster.get_target_distance() or var3
		if var3 > 225.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			helper_10b18()
			continue
		end
		if var3 < 95.0 then
			argc = monster.get_random(100) or argc
			if argc < 80 then
				if var3 < 75.0 then
					helper_106e4()
				else
					helper_108b8()
				end
			else
				monster.set_motion("歩き", -1, 0)
				helper_b9b0f992(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 65 then
				helper_108b8()
			else
				argc = monster.get_random(100) or argc
				if argc < 90 then
					monster.set_motion("歩き", -1, 0)
					helper_b9b0f992(vm.f32(1.2), vm.f32(2.8), 49.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					helper_b9b0f992(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
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
	monster.register_damage_hit("吹っ飛び弱", 5.0, "攻撃１", 0.279, 0.414, 0, 1)
	monster.register_damage_hit("中攻撃", 5.0, "攻撃２", 0.6, 0.7, 0, 1)
	monster.add_sword_trail(0, "攻撃１", 0.31, 0.315, "dcol0", "dcol1", 45, 10, 45)
	monster.add_sword_trail(0, "攻撃２", 0.3, 0.305, "dcol0", "dcol1", 45, 10, 45)
	monster.set_variable(0, 0)
	helper_1c5c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local gekirin: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			helper_102ac()
			var0 = monster.get_target_distance() or var0
			if var0 < 225.0 then
				helper_12d00()
			else
				helper_db34()
			end
		else
			helper_11028()
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
function script.on_knockdown()
	helper_d8cf1050()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("起き上がり")
	helper_56d63eae()
	monster.set_motion("立ち", -1, 0)
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	helper_56d63eae()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_c3e8ae39(8)
	monster.set_motion("ガードout", -1, 6)
	helper_56d63eae()
	monster.set_motion("立ち")
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
	monster.set_motion("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_e05438b5()
end

return script
