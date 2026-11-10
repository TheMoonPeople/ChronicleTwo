--!strict
-- dungeon/monster/b15a2.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8700c9e2 = require("@lib/monster/helper_8700c9e2")

local global3: s32 = 0

--- Helper function.
local function helper_2010()
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
local function helper_f0e4()
	local rot_y: f32 = 0
	local var4: f32 = 0
	do
		local _, out2, _ = monster.get_rotation()
		var4 = out2 or var4
	end
	do
		local _, out2, _ = monster.get_rotation(0)
		rot_y = out2 or rot_y
	end
	var4 = monster.get_target_angle() or var4
	var4 = vm.f32(var4 - rot_y)
	if var4 > vm.f32(3.1415927) then
		var4 = vm.f32(var4 - vm.f32(6.2831855))
	end
	if var4 < vm.f32(-3.1415927) then
		var4 = vm.f32(var4 + vm.f32(6.2831855))
	end
	if global3 == 27 then
		if var4 < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if global3 == 28 then
		if var4 < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if global3 == 29 then
		if var4 < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if global3 == 30 then
		if var4 < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if global3 == 31 then
		if var4 > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	if global3 == 32 then
		if var4 > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	if global3 == 33 then
		if var4 > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	if global3 == 34 then
		if var4 > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	monster.turn_toward_angle(var4, 0.09817477)
end

--- Helper function.
local function helper_1898()
	local value: s32 = 0
	value = monster.get_variable(3) or value
	if value ~= -9999 then
		monster.finish_effect(value)
		monster.set_variable(3, -9999)
	end
end

--- Helper function.
local function helper_fd4c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	local value: s32 = 0
	local chara_type: s32 = 0
	local slot: s32 = 0
	local argc: s32 = 0
	local var12: s32 = 0
	local value_2: s32 = 0
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_linked_piece_frame_position("shot")
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
	var4 = vm.f32(var4 + 20.0)
	chara_type = monster.get_character_number() or chara_type
	value = monster.get_variable(67) or value
	monster.keep_monster_loop_sound_3(value, 4, 45)
	helper_1898()
	slot = monster.create_effect_2("機関銃（小）") or slot
	monster.set_variable(3, slot)
	monster.set_effect_value(slot, 0, 0)
	monster.set_effect_value(slot, 1, chara_type)
	monster.create_effect_1("機銃")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, value)
	argc = monster.get_random(100) or argc
	if argc < 50 then
		var4 = vm.f32(var4 - 20.0)
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
	do
		local out1, out2, out3 = monster.scale_vector(var3, var4, var5, 70)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.set_effect_second_vector(-1, var3, var4, var5)
	value_2 = monster.get_variable(8) or value_2
	if value_2 ~= 1 then
		var12 = 20
	else
		var12 = 5
	end
	while var12 > 0 do
		helper_f0e4()
		var12 = var12 - 1
		vm.wait()
	end
	value = monster.get_variable(67) or value
	helper_1898()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local life: s32 = 0
	local value: s32 = 0
	monster.set_monster_attributes(4, 1)
	global3 = 0
	global3 = monster.get_character_number() or global3
	if global3 == 27 then
		monster.ride_map_piece("p01_battleship", "kikan-m0")
	end
	if global3 == 28 then
		monster.ride_map_piece("p01_battleship", "kikan-m1")
	end
	if global3 == 29 then
		monster.ride_map_piece("p01_battleship", "kikan-m2")
	end
	if global3 == 30 then
		monster.ride_map_piece("p01_battleship", "kikan-m3")
	end
	if global3 == 31 then
		monster.ride_map_piece("p01_battleship", "kikan-m04")
	end
	if global3 == 32 then
		monster.ride_map_piece("p01_battleship", "kikan-m05")
	end
	if global3 == 33 then
		monster.ride_map_piece("p01_battleship", "kikan-m06")
	end
	if global3 == 34 then
		monster.ride_map_piece("p01_battleship", "kikan-m07")
	end
	value = monster.get_variable(64) or value
	life = monster.get_monster_life(-1) or life
	monster.set_variable(4, life)
	monster.set_variable(64, vm.i32(value + life))
	monster.set_variable(65, vm.i32(value + life))
	monster.set_variable(66, 0)
	monster.set_variable(3, -9999)
	monster.set_position(0, 0, 0)
	monster.set_rotation(0, 0, 0)
	monster.load_effect_script("機銃")
	helper_2010()
	monster.set_clip_distance(999999.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local var1: f32 = 0
	local argc: s32 = 0
	local var3: f32 = 0
	local argc_2: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_rotation(0.0, 0.0, 0.0)
	while true do
		helper_f0e4()
		if global3 == 27 or global3 == 28 or global3 == 29 or global3 == 30 then
			var1 = helper_8700c9e2()
			if var1 < vm.f32(-0.98) then
				value = monster.get_variable(8) or value
				if value == 1 then
					argc = monster.get_random(100) or argc
					if argc < 5 then
						helper_fd4c()
					end
				else
					argc = monster.get_random(100) or argc
					if argc < 5 then
						helper_fd4c()
					end
				end
			end
		end
		if global3 == 31 or global3 == 32 or global3 == 33 or global3 == 34 then
			var3 = helper_8700c9e2()
			if var3 < vm.f32(-0.98) then
				value = monster.get_variable(8) or value
				if value == 1 then
					argc_2 = monster.get_random(100) or argc_2
					if argc_2 < 5 then
						helper_fd4c()
					end
				else
					argc_2 = monster.get_random(100) or argc_2
					if argc_2 < 5 then
						helper_fd4c()
					end
				end
			end
		end
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Runs the monster's death.
function script.on_death()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local chara_type: s32 = 0
	local value_2: s32 = 0
	monster.start_death()
	helper_1898()
	monster.get_variable(67)
	chara_type = monster.get_character_number() or chara_type
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
	monster.create_effect_1("軍艦ダメージ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.create_effect_1("Ｍ汎用煙")
	monster.set_effect_owner(-1, chara_type)
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(32, 1)
	value_2 = monster.get_variable(67) or value_2
	monster.add_monster_life(value_2, -700)
	while true do
		vm.wait()
	end
end

return script
