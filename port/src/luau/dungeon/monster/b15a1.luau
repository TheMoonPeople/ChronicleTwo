--!strict
-- dungeon/monster/b15a1.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8700c9e2 = require("@lib/monster/helper_8700c9e2")

local global3: s32 = 0

--- Helper function.
local function helper_24b4()
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
local function helper_eb2c()
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
	if global3 == 25 then
		if var4 < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if global3 == 26 then
		if var4 > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	monster.turn_toward_angle(var4, 0.09817477)
end

--- Runs the monster's death.
local function on_death()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local chara_type: s32 = 0
	local value: s32 = 0
	monster.start_death()
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
	value = monster.get_variable(67) or value
	monster.add_monster_life(value, -900)
	while true do
		vm.wait()
	end
end

--- Helper function.
local function helper_1dd8()
	local value: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local life: s32 = 0
	value = monster.get_variable(4) or value
	var1 = monster.get_monster_life(-1) or var1
	monster.set_variable(4, var1)
	var2 = vm.i32(value - var1)
	var1 = monster.get_variable(64) or var1
	var1 = vm.i32(var1 - var2)
	monster.set_variable(64, var1)
	if var1 <= 6000 then
		monster.get_variable(66)
	end
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		print("dead---------------\n")
		on_death()
	end
end

--- Helper function.
local function helper_21cc()
	helper_1dd8()
	vm.wait()
end

--- Helper function.
local function helper_f0b0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local value: s32 = 0
	local attack: s32 = 0
	local var8: s32 = 0
	local value_2: s32 = 0
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
	value = monster.get_variable(67) or value
	monster.play_monster_sound(value, 6)
	monster.play_monster_sound(value, 8)
	monster.create_effect_1("マズルフラッシュ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("砲弾")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, value)
	value_2 = monster.get_variable(8) or value_2
	if value_2 ~= 1 then
		var8 = 60
	else
		var8 = 30
	end
	while var8 > 0 do
		helper_eb2c()
		var8 = var8 - 1
		helper_21cc()
	end
end

--- Helper function.
local function helper_224c(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_21cc()
		var1 = vm.i32(var1 + 1)
	end
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
	if global3 == 25 then
		monster.ride_map_piece("p01_battleship", "tbig-m0")
	end
	if global3 == 26 then
		monster.ride_map_piece("p01_battleship", "tbig-m1")
	end
	monster.set_position(0, 0, 0)
	monster.set_rotation(0, 0, 0)
	value = monster.get_variable(64) or value
	life = monster.get_monster_life(-1) or life
	monster.set_variable(4, life)
	monster.set_variable(64, vm.i32(value + life))
	monster.set_variable(65, vm.i32(value + life))
	helper_24b4()
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
	monster.set_rotation(-0.3926991, 0.0, 0.0)
	while true do
		helper_eb2c()
		if global3 == 25 then
			var1 = helper_8700c9e2()
			if var1 < vm.f32(-0.98) then
				argc = monster.get_random(100) or argc
				if argc < 30 then
					helper_f0b0()
				end
			end
		end
		if global3 == 26 then
			var3 = helper_8700c9e2()
			if var3 < vm.f32(-0.98) then
				argc_2 = monster.get_random(100) or argc_2
				if argc_2 < 30 then
					helper_f0b0()
				end
			end
		end
		value = monster.get_variable(8) or value
		if value ~= 1 then
			helper_224c(5)
		end
		helper_224c(10)
		helper_21cc()
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

script.on_death = on_death

return script
