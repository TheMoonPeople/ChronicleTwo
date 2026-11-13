--!strict
--- Controls a large deck cannon on the Death Ark, which tracks the target, fires shells and drains the ship life pool when destroyed.

local vm = require("@lib/vm")
local sense = require("@lib/monster/sense")

local cannon_character_number: s32 = 0

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

--- Turns the cannon toward the target, limited to the side the cannon covers.
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
	if cannon_character_number == 25 then
		if relative_angle < 0.0 then
			monster.turn_toward_angle(1.5707964, 0.049087387)
			return
		end
	end
	if cannon_character_number == 26 then
		if relative_angle > 0.0 then
			monster.turn_toward_angle(-1.5707964, 0.049087387)
			return
		end
	end
	monster.turn_toward_angle(relative_angle, 0.09817477)
end

--- Plays the destruction effects, subtracts 900 life from the ship and idles forever.
local function on_death()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local character_type: s32 = 0
	local ship_character_number: s32 = 0
	monster.start_death()
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
	monster.add_monster_life(ship_character_number, -900)
	while true do
		vm.wait()
	end
end

--- Subtracts damage taken from the shared life pool and starts the death sequence when the cannon is destroyed.
local function track_damage_and_check_death()
	local previous_life: s32 = 0
	local current_life: s32 = 0
	local damage_taken: s32 = 0
	local life: s32 = 0
	previous_life = monster.get_variable(4) or previous_life
	current_life = monster.get_monster_life(-1) or current_life
	monster.set_variable(4, current_life)
	damage_taken = vm.i32(previous_life - current_life)
	current_life = monster.get_variable(64) or current_life
	current_life = vm.i32(current_life - damage_taken)
	monster.set_variable(64, current_life)
	if current_life <= 6000 then
		monster.get_variable(66)
	end
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		print("dead---------------\n")
		on_death()
	end
end

--- Checks the monster state and waits one frame.
local function update_and_wait_frame()
	track_damage_and_check_death()
	vm.wait()
end

--- Fires a shell at the target and keeps aiming while the cannon recoils.
local function fire_cannon()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local ship_character_number: s32 = 0
	local attack_power: s32 = 0
	local recoil_frames_left: s32 = 0
	local is_broadside: s32 = 0
	do
		local out1, out2, out3 = monster.get_linked_piece_frame_position("shot")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	ship_character_number = monster.get_variable(67) or ship_character_number
	monster.play_monster_sound(ship_character_number, 6)
	monster.play_monster_sound(ship_character_number, 8)
	monster.create_effect_1("マズルフラッシュ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	attack_power = monster.get_attack_power_1() or attack_power
	monster.create_effect_1("砲弾")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, target_x, target_y, target_z)
	monster.set_effect_value(-1, 0, attack_power)
	monster.set_effect_value(-1, 1, ship_character_number)
	is_broadside = monster.get_variable(8) or is_broadside
	if is_broadside ~= 1 then
		recoil_frames_left = 60
	else
		recoil_frames_left = 30
	end
	while recoil_frames_left > 0 do
		aim_at_target()
		recoil_frames_left = recoil_frames_left - 1
		update_and_wait_frame()
	end
end

--- Waits for a number of frames.
local function wait_frames(frame_count: any)
	local frame_index: s32 = 0
	frame_index = 0
	while frame_index < frame_count do
		update_and_wait_frame()
		frame_index = vm.i32(frame_index + 1)
	end
end

local script = {}

--- Does nothing.
function script.setup() end

--- Mounts the cannon on the battleship map piece and adds its life to the shared pool.
function script.init()
	local cannon_life: s32 = 0
	local shared_life: s32 = 0
	monster.set_monster_attributes(4, 1)
	cannon_character_number = 0
	cannon_character_number = monster.get_character_number() or cannon_character_number
	if cannon_character_number == 25 then
		monster.ride_map_piece("p01_battleship", "tbig-m0")
	end
	if cannon_character_number == 26 then
		monster.ride_map_piece("p01_battleship", "tbig-m1")
	end
	monster.set_position(0, 0, 0)
	monster.set_rotation(0, 0, 0)
	shared_life = monster.get_variable(64) or shared_life
	cannon_life = monster.get_monster_life(-1) or cannon_life
	monster.set_variable(4, cannon_life)
	monster.set_variable(64, vm.i32(shared_life + cannon_life))
	monster.set_variable(65, vm.i32(shared_life + cannon_life))
	set_clip_distance_for_boss()
	monster.set_clip_distance(999999.0)
end

--- Keeps aiming at the target and fires when the target is in line.
function script.loop()
	local is_broadside: s32 = 0
	local first_cannon_alignment: f32 = 0
	local first_cannon_roll: s32 = 0
	local second_cannon_alignment: f32 = 0
	local second_cannon_roll: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_rotation(-0.3926991, 0.0, 0.0)
	while true do
		aim_at_target()
		if cannon_character_number == 25 then
			first_cannon_alignment = sense.get_facing_alignment()
			if first_cannon_alignment < vm.f32(-0.98) then
				first_cannon_roll = monster.get_random(100) or first_cannon_roll
				if first_cannon_roll < 30 then
					fire_cannon()
				end
			end
		end
		if cannon_character_number == 26 then
			second_cannon_alignment = sense.get_facing_alignment()
			if second_cannon_alignment < vm.f32(-0.98) then
				second_cannon_roll = monster.get_random(100) or second_cannon_roll
				if second_cannon_roll < 30 then
					fire_cannon()
				end
			end
		end
		is_broadside = monster.get_variable(8) or is_broadside
		if is_broadside ~= 1 then
			wait_frames(5)
		end
		wait_frames(10)
		update_and_wait_frame()
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

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default guard reaction.
function script.on_guard() end

script.on_death = on_death

return script
