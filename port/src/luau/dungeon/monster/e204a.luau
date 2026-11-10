--!strict
-- dungeon/monster/e204a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_27edc45c = require("@lib/monster/helper_27edc45c")
local helper_27f80314 = require("@lib/monster/helper_27f80314")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_5af194a0 = require("@lib/monster/helper_5af194a0")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6d5002db = require("@lib/monster/helper_6d5002db")
local helper_7e925497 = require("@lib/monster/helper_7e925497")
local helper_80832373 = require("@lib/monster/helper_80832373")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_a4ff7523 = require("@lib/monster/helper_a4ff7523")
local helper_b9b0f992 = require("@lib/monster/helper_b9b0f992")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d2a0b202 = require("@lib/monster/helper_d2a0b202")
local helper_dc78fc76 = require("@lib/monster/helper_dc78fc76")
local helper_e7936dab = require("@lib/monster/helper_e7936dab")

--- Helper function.
local function helper_1ba0()
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
local function helper_da78()
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
		monster.set_motion("攻撃１", -1.0, 0)
		helper_595cbf61(var7, vm.f32(4.8))
		var17 = monster.get_clear_distance(100.0, 0.0) or var17
		var17 = vm.f32(var17 - 60.0)
		if var17 > 0.0 then
			helper_a4ff7523(vm.f32(4.8), 1.75, var7, var17, 60.0, 30)
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
				monster.set_motion("攻撃１", -1.0, 0)
				helper_80832373(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), var5, var18, 60.0, 60)
				var19 = monster.get_random_whole_number(180.0) or var19
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var19 = vm.f32(var19 * -1.0)
				end
				helper_595cbf61(var19, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 80.0, 50.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.get_random(100, argc)
			return
		end
	end
	argc = monster.get_random(100) or argc
	if argc < 5 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			helper_7e925497(100.0, 80.0, 50.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("攻撃１", -1.0, 0)
			helper_595cbf61(var7, vm.f32(4.8))
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
					monster.set_motion("攻撃１", -1.0, 0)
					var1 = helper_8be991f0(1.75, vm.f32(4.8), var20, var21, 60.0, 60)
					var23 = monster.get_random_whole_number(360.0) or var23
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var23 = vm.f32(var23 * -1.0)
					end
					helper_595cbf61(var23, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("攻撃１", -1.0, 0)
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
					helper_e7936dab(1.75, var7, 1000.0, 60.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 80.0, 50.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
		elseif var2 == 8 then
			monster.set_variable(0, 1)
			argc = monster.get_random(120) or argc
			var5 = monster.get_target_distance() or var5
			argc = vm.i32(argc + 15)
			monster.set_motion("攻撃１", -1.0, 0)
			helper_dc78fc76(1.75, vm.f32(4.8), var5, 360.0, 40.0, 60.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_10f38()
	local var4: f32 = 0
	local value: s32 = 0
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	if helper_d2a0b202() > 300 then
		monster.stop_moving()
		helper_442b9962()
		monster.start_death()
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.create_effect_1("Ｍ小爆発")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_value(-1, 0, attack)
		monster.set_motion("死に", -1, 6)
		helper_56d63eae()
		monster.spawn_death_effects()
		while true do
			vm.wait()
		end
	end
	attack = monster.get_attack_power_1() or attack
	vm.wait()
	value = monster.get_variable(0) or value
	if value == 0 then
		helper_442b9962()
		monster.reset_motion()
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(4.5)
		monster.reset_motion()
		monster.set_motion("攻撃１out", -1, 6)
		helper_56d63eae()
		monster.set_motion("攻撃１", -1, 0)
		var12 = monster.get_random_whole_number(3.0) or var12
		helper_b9b0f992(vm.f32(var12 + 2.0), 4.5, 22.0, 30)
		monster.set_motion("立ち", -1, 0)
		monster.set_variable(0, 1)
	end
	monster.get_random(100)
	if helper_5af194a0(100.0, 80.0, 50.0, vm.f32(1.2)) ~= 0 then
		monster.set_motion("攻撃１", -1, 0)
		helper_6d5002db(4.5, 4.5, 22.0, 100)
		var4 = monster.get_target_distance() or var4
		if var4 < 42.0 then
			monster.stop_moving()
			helper_442b9962()
			monster.start_death()
			do
				local out1, out2, out3 = monster.get_position_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			monster.create_effect_1("Ｍ小爆発")
			monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
			monster.set_effect_value(-1, 0, attack)
			monster.set_motion("死に", -1, 6)
			helper_56d63eae()
			monster.spawn_death_effects()
			while true do
				vm.wait()
			end
		end
		monster.reset_motion()
		monster.set_motion("攻撃１out", -1, 6)
		helper_56d63eae()
		monster.set_motion("立ち", -1, 0)
	else
		helper_da78()
	end
	vm.wait()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.reset_dungeon_timer()
	helper_27edc45c()
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	helper_1ba0()
	monster.set_monster_attributes(16, 1)
	monster.set_clip_distance(10000000.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		helper_10f38()
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
	monster.stop_moving()
	helper_442b9962()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("立ち")
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.start_death()
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

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
	monster.stop_moving()
	helper_442b9962()
	monster.start_death()
	monster.set_motion("死に", -1, 2)
	helper_56d63eae()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	helper_c3e8ae39(10)
	return 1
end

--- Stuns the monster.
function script.on_stun()
	monster.set_motion("ダメージ", -1, 6)
	helper_c3e8ae39(12)
	monster.set_motion("気絶", -1)
	helper_27f80314()
end

return script
