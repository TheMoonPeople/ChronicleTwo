--!strict
--- Controls the Jaming boss, which floats around the arena center swaying and launching attacks, getting faster as it takes damage.

local vm = require("@lib/vm")
local death = require("@lib/monster/death")
local state = require("@lib/monster/state")

--- Stores the angle of the boss orbit.
local function set_orbit_angle(angle: f32)
	monster.set_variable_float(0, angle)
end

--- Stores the last attack type and the damage just taken.
local function record_last_attack(current_life: s32, previous_life: s32)
	local attack_type: s32 = 0
	attack_type = monster.get_last_attack_type() or attack_type
	monster.set_variable(6, attack_type)
	monster.set_variable(7, vm.i32(previous_life - current_life))
end

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

--- Counts the hits the boss has taken and records the last attack.
local function track_damage_count()
	local life: s32 = 0
	local previous_life: s32 = 0
	local damage_count: s32 = 0
	previous_life = monster.get_variable(9) or previous_life
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		monster.set_variable(9, life)
		return
	end
	if vm.i32(life - previous_life) < 0 then
		monster.set_variable(9, life)
		record_last_attack(life, previous_life)
		damage_count = monster.get_variable(8) or damage_count
		monster.set_variable(8, vm.i32(damage_count + 1))
		print("dmg_cnt = ", vm.i32(damage_count + 1), "--------------------\n")
		return
	end
	monster.set_variable(9, life)
end

--- Returns the stored orbit angle.
local function get_orbit_angle(orbit_angle: f32)
	local stored_angle: f32 = 0
	stored_angle = monster.get_variable_float(0) or stored_angle
	orbit_angle = stored_angle
	return orbit_angle
end

--- Places the boss on its swaying orbit around a point, facing the point.
local function orbit_around_point()
	local pivot_x: f32 = 0
	local pivot_y: f32 = 0
	local pivot_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local orbit_angle: f32 = 0
	local facing_angle: f32 = 0
	local sway_angle: f32 = 0
	local sway_velocity: f32 = 0
	local sway_limit: f32 = 0
	monster.get_monster_life_fraction(-1)
	pivot_x = 250.0
	pivot_y = 0.0
	pivot_z = 250.0
	facing_angle = monster.get_angle_to_position(pivot_x, pivot_y, pivot_z) or facing_angle
	orbit_angle = get_orbit_angle(orbit_angle)
	x = vm.f32(pivot_x + vm.f32(vm.sin(orbit_angle) * 180.0))
	y = vm.f32(pivot_y + 105.0)
	z = vm.f32(pivot_z + vm.f32(vm.cos(orbit_angle) * 180.0))
	monster.set_position(x, y, z)
	monster.set_rotation(0.0, facing_angle, 0.0)
	sway_velocity = monster.get_variable_float(1) or sway_velocity
	sway_angle = monster.get_variable_float(2) or sway_angle
	sway_limit = monster.get_variable_float(3) or sway_limit
	if sway_angle > sway_limit or sway_angle < -sway_limit then
		sway_limit = monster.get_random_whole_number(0.011635529) or sway_limit
		if sway_angle > vm.f32(0.023271058) then
			sway_limit = vm.f32(-sway_limit + vm.f32(0.023271058))
			sway_angle = sway_limit
		else
			sway_limit = vm.f32(sway_limit + vm.f32(0.023271058))
			sway_angle = -sway_limit
		end
		sway_velocity = vm.f32(sway_velocity * -1.0)
		monster.set_variable_float(1, sway_velocity)
		monster.set_variable_float(3, sway_limit)
	end
	sway_angle = vm.f32(sway_angle + sway_velocity)
	monster.set_variable_float(2, sway_angle)
	set_orbit_angle(vm.f32(orbit_angle + sway_angle))
end

--- Tracks damage, speeds up the sway at higher damage counts and moves the boss along its orbit.
local function update_boss()
	local damage_count: s32 = 0
	track_damage_count()
	damage_count = monster.get_variable(8) or damage_count
	if damage_count >= 3 then
		if damage_count == 3 then
			monster.set_variable_float(10, 0.004363323)
			monster.set_variable_float(1, 9.3499795e-05)
			print("3\n")
		end
		if damage_count == 4 then
			monster.set_variable_float(10, 0.0058177644)
			monster.set_variable_float(1, 0.00012466639)
		end
		if damage_count == 5 then
			monster.set_variable_float(10, 0.008726646)
			monster.set_variable_float(1, 0.00018699959)
		end
	end
	orbit_around_point()
end

--- Updates the boss and waits one frame.
local function update_and_wait_frame()
	update_boss()
	vm.wait()
end

--- Updates the boss each frame until the current motion finishes.
local function wait_until_motion_finished()
	local is_finished: s32 = 0
	while true do
		update_and_wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			return
		end
	end
end

--- Raises the flag of a numbered attack slot.
local function raise_attack_slot(slot_index: s32)
	monster.set_variable(vm.i32(slot_index + 20), 1)
end

--- Plays the attack motion and raises a random number of attack slots.
local function perform_attack()
	local random_value: s32 = 0
	local slot_count: s32 = 0
	local slot_index: s32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		monster.play_sound(4)
	else
		monster.play_sound(5)
	end
	monster.set_motion("攻撃１", -1, 6)
	wait_until_motion_finished()
	random_value = monster.get_random(120) or random_value
	slot_count = vm.imod(random_value, 6)
	slot_index = 0
	while slot_index < vm.i32(slot_count + 1) do
		random_value = monster.get_random(120) or random_value
		raise_attack_slot(vm.imod(random_value, 6))
		slot_index = slot_index + 1
	end
end

--- Updates the boss for a number of frames.
local function wait_frames(frame_count: any)
	local frame_index: s32 = 0
	frame_index = 0
	while frame_index < frame_count do
		update_and_wait_frame()
		frame_index = vm.i32(frame_index + 1)
	end
end

--- Plays the death effects and updates the boss every frame without returning.
local function play_death_effects_forever()
	monster.spawn_death_effects()
	while true do
		update_and_wait_frame()
	end
end

local script = {}

--- Does nothing.
function script.setup() end

--- Initialises the sway and damage state and shows the boss map parts.
function script.init()
	local character_type: s32 = 0
	local life: s32 = 0
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(4, 1)
	monster.set_camera_mode(4)
	character_type = monster.get_character_number() or character_type
	monster.set_variable(30, character_type)
	monster.set_variable(5, 0)
	set_orbit_angle(0.0)
	monster.set_variable_float(1, 6.2333194e-05)
	monster.set_variable_float(2, 0.011635529)
	monster.set_variable_float(3, 0.034906585)
	life = monster.get_monster_life(-1) or life
	monster.set_variable(9, life)
	monster.set_variable(8, 0)
	monster.set_variable_float(10, 0.0)
	record_last_attack(life, life)
	monster.set_map_part_visible("p01_boss", "boss02-a0", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a1", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a2", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a3", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a4", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a5", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c0", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c1", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c2", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c3", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c4", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c5", 1)
	monster.set_photo_opportunity(1027)
	set_clip_distance_for_boss()
end

--- Starts the boss sound once, then plays the idle motion and launches an attack every 90 frames.
function script.loop()
	local sound_started: s32 = 0
	local frame_counter: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	sound_started = monster.get_variable(5) or sound_started
	if sound_started == 0 then
		monster.play_sound(2)
		monster.set_variable(5, 1)
	end
	monster.reset_motion()
	while true do
		monster.set_motion("あそび", -1, 0)
		if vm.imod(frame_counter, 90) == 0 then
			perform_attack()
		end
		update_and_wait_frame()
		frame_counter = vm.i32(frame_counter + 1)
	end
end

--- Plays the damage motion and waits until the status ailments clear.
function script.on_status_hit()
	local has_status: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status = 1
	while has_status ~= 0 do
		has_status = monster.get_status_ailments(40) or has_status
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage motion with a small knockback.
function script.on_damage()
	state.stop_and_clear_action()
	print("damage action-----------\n")
	monster.reset_motion()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	wait_until_motion_finished()
	wait_frames(12)
	monster.set_motion("あそび")
	state.do_nothing()
end

--- Prints a debug message and does nothing else.
function script.on_knockdown()
	print("blow damage----------\n")
end

--- Prints a debug message and does nothing else.
function script.on_guard()
	print("guard-----------\n")
end

--- Prints a debug message and does nothing else.
function script.on_dodge_1()
	print("sword escape-----------\n")
end

--- Prints a debug message and does nothing else.
function script.on_dodge_2()
	print("shot escape------------\n")
end

--- Hides the boss map parts, plays the death motion and requests the defeat event.
function script.on_death()
	monster.set_map_part_visible("p01_boss", "boss02-a0", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a1", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a2", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a3", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a4", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a5", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c0", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c1", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c2", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c3", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c4", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c5", 0)
	vm.wait()
	death.begin()
	monster.play_sound(23)
	monster.stop_sound(2)
	monster.request_event_script(501)
	monster.set_motion("死に", -1, 2)
	wait_until_motion_finished()
	monster.spawn_death_effects()
	while true do
		update_and_wait_frame()
	end
	play_death_effects_forever()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default caught reaction.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default landing reaction.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default stun reaction.
function script.on_stun() end

return script
