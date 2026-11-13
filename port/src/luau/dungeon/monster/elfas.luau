--!strict
--- Controls the Elfas family of monsters that swing and release ground shockwaves.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard, clip distance and secondary variable defaults shared by this monster's behaviour.
local function initialize_behavior_defaults()
	local boss: s32 = 0
	state.set_unknown_float_8(500.0)
	state.set_unknown_float_9(80.0)
	reaction.set_guard_damage_threshold(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Either strafes around the target or waits for it to come in front, chosen at random.
local function strafe_or_wait()
	local random_roll: s32 = 0
	local angle_degrees: f32 = 0
	local distance: f32 = 0
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 50 then
		random_roll = monster.get_random(100) or random_roll
		angle_degrees = monster.get_random_whole_number(30.0) or angle_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 130.0)
		if random_roll < 50 then
			angle_degrees = vm.f32(-angle_degrees - 30.0)
		else
			angle_degrees = vm.f32(angle_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(1.8), vm.f32(2.4), angle_degrees, distance, 56.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(2.4))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(56.0, 45.0, 30)
	end
end

--- Plays the turn animation matching the target's side and turns toward it.
local function turn_to_face_target()
	if sense.is_facing_target_with_whole_offset(90, 180) ~= 0 then
		monster.set_motion("回転右", -1.0, 0)
	else
		monster.set_motion("回転左", -1.0, 0)
	end
	movement.turn_toward_target_and_wait_guarded(vm.f32(2.4))
end

--- Walks toward the target until within a stop distance or out of frames.
local function walk_toward_target(move_speed: f32, rot_speed: f32, stop_distance: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_z: f32 = 0
	local pos_y: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local frame: s32 = 0
	movement.turn_toward_target_and_wait_guarded(rot_speed)
	rot_speed = calc.degrees_to_radians(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	frame = 0
	while frame < max_frames do
		if sense.is_facing_target_with_whole_offset(0, 20) ~= 0 then
			monster.set_motion("歩き")
		elseif sense.is_facing_target_with_whole_offset(90, 180) ~= 0 then
			monster.set_motion("回転右")
		else
			monster.set_motion("回転左")
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		do
			local out1, _, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_z = out3 or target_z
		end
		do
			local _, out2, _ = monster.get_position_3()
			pos_y = out2 or pos_y
		end
		monster.get_rotation()
		monster.move_toward_position(target_x, pos_y - 20.0, target_z, move_speed, move_speed)
		reaction.update_and_wait_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Closes in on the target or sidesteps when it is far away.
local function act_at_far_range()
	local random_roll: s32 = 0
	local target_distance: f32 = 0
	local angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 90 then
		turn_to_face_target()
		monster.set_motion("歩き", -1, 0)
		walk_toward_target(vm.f32(1.8), vm.f32(2.4), 130.0, 90)
		monster.set_motion("立ち", -1, 0)
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				angle_degrees = -30.0
			else
				angle_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			turn_to_face_target()
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.8), vm.f32(2.4), angle_degrees, target_distance, 130.0, 45)
			monster.set_motion("歩き", -1, 0)
			turn_to_face_target()
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(56.0, 45.0, 30)
		end
	end
end

--- Slams the ground to release a shockwave in front of it.
local function shockwave_attack()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.set_variable(1, 2)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(2.4))
	monster.set_motion("攻撃２", -1, 6)
	movement.turn_until_motion_progress(vm.f32(4.8), 0.5, vm.f32(0.01))
	do
		local out1, out2, out3 = monster.get_point_from_facing(0.0, 16.0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	attack = monster.get_attack_power_1() or attack
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, 1)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Closes in, sidesteps or slams the ground when the target is at medium range.
local function act_at_mid_range()
	local random_roll: s32 = 0
	local target_distance: f32 = 0
	local angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 10 then
		shockwave_attack()
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 90 then
			monster.set_motion("歩き", -1, 0)
			turn_to_face_target()
			monster.set_motion("歩き", -1, 0)
			walk_toward_target(vm.f32(1.8), vm.f32(4.8), 56.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 50 then
					angle_degrees = -30.0
				else
					angle_degrees = 30.0
				end
				monster.set_motion("歩き", -1, 0)
				turn_to_face_target()
				monster.set_motion("歩き", -1, 0)
				movement.walk_to_point_near_target(vm.f32(1.8), vm.f32(2.4), angle_degrees, target_distance, 1.0, 45)
				monster.set_motion("歩き", -1, 0)
				turn_to_face_target()
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(56.0, 45.0, 30)
			end
		end
	end
end

--- Turns to the target and performs the melee swing.
local function swing_attack()
	monster.set_variable(1, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(2.4))
	monster.set_motion("攻撃１", -1, 6)
	movement.turn_until_motion_progress(vm.f32(2.4), vm.f32(0.267), -1.0)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Attacks, advances or circles when the target is close.
local function act_at_near_range()
	local random_roll: s32 = 0
	local angle_degrees: f32 = 0
	monster.get_life()
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 90 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 40 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(2.4))
			monster.set_motion("歩き", -1, 0)
			walk_toward_target(vm.f32(1.8), vm.f32(4.8), 56.0, 30)
			monster.set_motion("立ち", -1, 0)
		end
		monster.get_target_distance()
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 70 then
			swing_attack()
		else
			shockwave_attack()
		end
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 80 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(2.4))
			monster.set_motion("走り", -1, 0)
			walk_toward_target(vm.f32(1.8), vm.f32(4.8), 56.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			random_roll = monster.get_random(100) or random_roll
			angle_degrees = monster.get_random_whole_number(60.0) or angle_degrees
			if random_roll < 50 then
				angle_degrees = vm.f32(-angle_degrees - 30.0)
			else
				angle_degrees = vm.f32(angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.8), vm.f32(2.4), angle_degrees, 112.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(2.4))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Repeatedly picks a behaviour by target distance until the target is far away.
local function engage_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 330.0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			strafe_or_wait()
			continue
		end
		if target_distance < 330.0 and target_distance >= 210.0 then
			act_at_far_range()
		elseif target_distance < 210.0 and target_distance >= 130.0 then
			act_at_mid_range()
		else
			act_at_near_range()
		end
	end
end

--- Wanders around or waits for the target while it is far away.
local function wander_when_far()
	local random_roll: s32 = 0
	local action_result: s32 = 0
	local wander_state: s32 = 0
	local distance: f32 = 0
	local turn_angle_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local approach_angle_degrees: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local end_turn_degrees: f32 = 0
	reaction.update_and_wait_frame()
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
	distance = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 56.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle_degrees, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 56.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.0, vm.f32(1.7), turn_angle_degrees, clear_distance, 56.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 90 then
			if distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 30 then
				monster.set_variable(0, 4)
				random_roll = monster.get_random(100) or random_roll
				orbit_angle_degrees = monster.get_random_whole_number(360.0) or orbit_angle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if random_roll < 50 then
					orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
				else
					orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.7), 3.0, distance, orbit_angle_degrees, 56.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				action_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if action_result == 1 then
					return
				end
			end
			monster.get_random(100, random_roll)
			return
		end
	end
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 64 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle_degrees, 3.0)
			monster.set_motion("立ち", -1, 0)
		end
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 50 then
					monster.set_variable(0, 4)
					random_roll = monster.get_random(100) or random_roll
					approach_angle_degrees = monster.get_random_whole_number(180.0) or approach_angle_degrees
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if random_roll < 50 then
						approach_angle_degrees = vm.f32(approach_angle_degrees * -1.0)
					end
					random_roll = monster.get_random(100) or random_roll
					if random_roll < 50 then
						approach_angle_degrees = vm.f32(-approach_angle_degrees - 30.0)
					else
						approach_angle_degrees = vm.f32(approach_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					action_result = movement.walk_to_point_near_target(vm.f32(1.7), 3.0, approach_angle_degrees, approach_distance, 56.0, 60)
					end_turn_degrees = monster.get_random_whole_number(360.0) or end_turn_degrees
					random_roll = monster.get_random(100) or random_roll
					if random_roll < 50 then
						end_turn_degrees = vm.f32(end_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(end_turn_degrees, 3.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						facing_angle = out2 or facing_angle
					end
					turn_angle_degrees = calc.radians_to_degrees(facing_angle)
					if turn_angle_degrees > vm.f32(3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees - vm.f32(6.2831855))
					end
					if turn_angle_degrees <= vm.f32(-3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(vm.f32(1.7), turn_angle_degrees, 1000.0, 56.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				action_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if action_result == 1 then
					return
				end
			end
		elseif wander_state == 8 then
			monster.set_variable(0, 1)
			random_roll = monster.get_random(120) or random_roll
			distance = monster.get_target_distance() or distance
			random_roll = vm.i32(random_roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.7), 3.0, distance, 360.0, 40.0, 56.0, random_roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Turns to the target and walks up to it.
local function approach_target()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(2.4))
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(vm.f32(1.8), vm.f32(4.8), 56.0, 60)
	monster.set_motion("立ち", -1, 0)
end

--- Chooses between engaging, wandering and approaching based on guard state and target distance.
local function run_combat_step()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	behavior.face_target_if_transformed_medium()
	target_distance = monster.get_target_distance() or target_distance
	if reaction.is_guard_active() == 0 then
		monster.set_defense_rate(1.0)
		if target_distance < 330.0 then
			engage_target()
		else
			wander_when_far()
		end
	else
		guard_distance = state.get_secondary_float(guard_distance)
		if target_distance < guard_distance then
			if target_distance < 210.0 then
				monster.set_defense_rate(1.2)
				reaction.set_guard_active(0)
				engage_target()
			else
				monster.set_defense_rate(1.0)
				approach_target()
			end
		else
			monster.set_defense_rate(1.0)
			reaction.set_guard_active(0)
		end
	end
end

local script = {}

--- Runs once when the script is loaded, before any program.
function script.setup() end

--- Registers the damage hits, loads the shockwave effect and applies the shared defaults.
function script.init()
	local get_not_used_texb: s32 = 0
	local effect_loaded: s32 = 0
	monster.register_damage_hit("弱連続", 8.0, "攻撃１", 0.217, 0.256, 0)
	monster.register_damage_hit("弱連続", 8.0, "攻撃１", 0.486, 0.524, 0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		effect_loaded = monster.load_effect_script("ヴァンガード衝撃波", get_not_used_texb) or effect_loaded
		if effect_loaded ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(1, 0)
	initialize_behavior_defaults()
end

--- Runs one combat step chosen by guard state and target distance.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	run_combat_step()
end

--- Stops the monster in a hurt pose until its status ailments clear.
function script.on_status_hit()
	local ailment_flags: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailment_flags = 1
	while ailment_flags ~= 0 do
		ailment_flags = monster.get_status_ailments(40) or ailment_flags
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the flinch reaction with a knockback.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Faces the target and plays the flinch reaction with a knockback.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster has no guard reaction.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster has no first dodge.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster has no second dodge.
function script.on_dodge_2() end

--- Plays the monster's death sequence.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster has no held reaction.
function script.on_caught() end

--- Recovers the monster after a throw lands.
function script.on_land()
	reaction.recover_from_throw()
	state.do_nothing_hook()
	return 1
end

--- Plays the stun reaction until the monster recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
