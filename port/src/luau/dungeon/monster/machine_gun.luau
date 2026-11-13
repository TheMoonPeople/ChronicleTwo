--!strict
--- Controls a machine gun turret on the Death Ark, which tracks the target, fires bursts and drains the ship life pool when destroyed.

local vm = require("@lib/vm")
local sense = require("@lib/monster/sense")

local turret_character_number: s32 = 0

--- Limits how far away the monster stays active unless it is a boss.
local function set_clip_distance_for_boss()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Turns the turret toward the target, limited to the side the turret covers.
local function aim_at_target()
	local rotation_y: f32 = 0
	local relative_angle: f32 = 0
	do
		local _, out2, _ = monster.get_rotation()
		relative_angle = out2 or relative_angle
	end
	do
		local _, out2, _ = monster.get_rotation(0)
		rotation_y = out2 or rotation_y
	end
	relative_angle = monster.get_target_angle() or relative_angle
	relative_angle = vm.f32(relative_angle - rotation_y)
	if relative_angle > vm.f32(3.1415927) then
		relative_angle = vm.f32(relative_angle - vm.f32(6.2831855))
	end
	if relative_angle < vm.f32(-3.1415927) then
		relative_angle = vm.f32(relative_angle + vm.f32(6.2831855))
	end
	if turret_character_number == 27 then
		if relative_angle < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if turret_character_number == 28 then
		if relative_angle < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if turret_character_number == 29 then
		if relative_angle < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if turret_character_number == 30 then
		if relative_angle < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if turret_character_number == 31 then
		if relative_angle > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	if turret_character_number == 32 then
		if relative_angle > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	if turret_character_number == 33 then
		if relative_angle > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	if turret_character_number == 34 then
		if relative_angle > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	monster.turn_toward_angle(relative_angle, 0.09817477)
end

--- Ends the running gunfire effect and clears its stored slot.
local function stop_gunfire_effect()
	local effect_slot: s32 = 0
	effect_slot = monster.get_variable(3) or effect_slot
	if effect_slot ~= -9999 then
		monster.finish_effect(effect_slot)
		monster.set_variable(3, -9999)
	end
end

--- Fires a burst at the target and keeps aiming while it lasts.
local function fire_burst()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local attack_power: s32 = 0
	local ship_character_number: s32 = 0
	local character_type: s32 = 0
	local effect_slot: s32 = 0
	local aim_roll: s32 = 0
	local burst_frames_left: s32 = 0
	local is_broadside: s32 = 0
	attack_power = monster.get_attack_power_1() or attack_power
	do
		local out1, out2, out3 = monster.get_linked_piece_frame_position("shot")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	direction_y = vm.f32(direction_y + 20.0)
	character_type = monster.get_character_number() or character_type
	ship_character_number = monster.get_variable(67) or ship_character_number
	monster.keep_monster_loop_sound_3(ship_character_number, 4, 45)
	stop_gunfire_effect()
	effect_slot = monster.create_effect_2("機関銃（小）") or effect_slot
	monster.set_variable(3, effect_slot)
	monster.set_effect_value(effect_slot, 0, 0)
	monster.set_effect_value(effect_slot, 1, character_type)
	monster.create_effect_1("機銃")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_value(-1, 0, attack_power)
	monster.set_effect_value(-1, 1, ship_character_number)
	aim_roll = monster.get_random(100) or aim_roll
	if aim_roll < 50 then
		direction_y = vm.f32(direction_y - 20.0)
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, 70)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
	is_broadside = monster.get_variable(8) or is_broadside
	if is_broadside ~= 1 then
		burst_frames_left = 20
	else
		burst_frames_left = 5
	end
	while burst_frames_left > 0 do
		aim_at_target()
		burst_frames_left = burst_frames_left - 1
		vm.wait()
	end
	ship_character_number = monster.get_variable(67) or ship_character_number
	stop_gunfire_effect()
end

local script = {}

--- Does nothing.
function script.setup() end

--- Mounts the turret on its battleship map piece and adds its life to the shared pool.
function script.init()
	local turret_life: s32 = 0
	local shared_life: s32 = 0
	monster.set_monster_attributes(4, 1)
	turret_character_number = 0
	turret_character_number = monster.get_character_number() or turret_character_number
	if turret_character_number == 27 then
		monster.ride_map_piece("p01_battleship", "kikan-m0")
	end
	if turret_character_number == 28 then
		monster.ride_map_piece("p01_battleship", "kikan-m1")
	end
	if turret_character_number == 29 then
		monster.ride_map_piece("p01_battleship", "kikan-m2")
	end
	if turret_character_number == 30 then
		monster.ride_map_piece("p01_battleship", "kikan-m3")
	end
	if turret_character_number == 31 then
		monster.ride_map_piece("p01_battleship", "kikan-m04")
	end
	if turret_character_number == 32 then
		monster.ride_map_piece("p01_battleship", "kikan-m05")
	end
	if turret_character_number == 33 then
		monster.ride_map_piece("p01_battleship", "kikan-m06")
	end
	if turret_character_number == 34 then
		monster.ride_map_piece("p01_battleship", "kikan-m07")
	end
	shared_life = monster.get_variable(64) or shared_life
	turret_life = monster.get_monster_life(-1) or turret_life
	monster.set_variable(4, turret_life)
	monster.set_variable(64, vm.i32(shared_life + turret_life))
	monster.set_variable(65, vm.i32(shared_life + turret_life))
	monster.set_variable(66, 0)
	monster.set_variable(3, -9999)
	monster.set_position(0, 0, 0)
	monster.set_rotation(0, 0, 0)
	monster.load_effect_script("機銃")
	set_clip_distance_for_boss()
	monster.set_clip_distance(999999.0)
end

--- Keeps aiming at the target and fires bursts when the target is in line.
function script.loop()
	local is_broadside: s32 = 0
	local first_bank_alignment: f32 = 0
	local first_bank_roll: s32 = 0
	local second_bank_alignment: f32 = 0
	local second_bank_roll: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_rotation(0.0, 0.0, 0.0)
	while true do
		aim_at_target()
		if turret_character_number == 27 or turret_character_number == 28 or turret_character_number == 29 or turret_character_number == 30 then
			first_bank_alignment = sense.get_facing_alignment()
			if first_bank_alignment < vm.f32(-0.98) then
				is_broadside = monster.get_variable(8) or is_broadside
				if is_broadside == 1 then
					first_bank_roll = monster.get_random(100) or first_bank_roll
					if first_bank_roll < 5 then
						fire_burst()
					end
				else
					first_bank_roll = monster.get_random(100) or first_bank_roll
					if first_bank_roll < 5 then
						fire_burst()
					end
				end
			end
		end
		if turret_character_number == 31 or turret_character_number == 32 or turret_character_number == 33 or turret_character_number == 34 then
			second_bank_alignment = sense.get_facing_alignment()
			if second_bank_alignment < vm.f32(-0.98) then
				is_broadside = monster.get_variable(8) or is_broadside
				if is_broadside == 1 then
					second_bank_roll = monster.get_random(100) or second_bank_roll
					if second_bank_roll < 5 then
						fire_burst()
					end
				else
					second_bank_roll = monster.get_random(100) or second_bank_roll
					if second_bank_roll < 5 then
						fire_burst()
					end
				end
			end
		end
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default damage reaction.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default knockdown reaction.
function script.on_knockdown() end

--- Plays the destruction effects, subtracts 700 life from the ship and idles forever.
function script.on_death()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local character_type: s32 = 0
	local ship_character_number: s32 = 0
	monster.start_death()
	stop_gunfire_effect()
	monster.get_variable(67)
	character_type = monster.get_character_number() or character_type
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	monster.create_effect_1("軍艦ダメージ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.create_effect_1("Ｍ汎用煙")
	monster.set_effect_owner(-1, character_type)
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(32, 1)
	ship_character_number = monster.get_variable(67) or ship_character_number
	monster.add_monster_life(ship_character_number, -700)
	while true do
		vm.wait()
	end
end

return script
