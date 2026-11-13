--!strict
--- Controls the Gyumo family of monsters that punch, charge and step back.

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

--- Turns to the target and plays an idle play animation while waiting for it to come in front.
local function play_in_place()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(5.0)
	monster.set_motion("遊び", -1, 2)
	sense.wait_until_target_in_front(44.0, 45.0, calc.pass_through(102))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(3)
end

--- Strafes around the target, waits for it to come in front or plays in place, chosen at random.
local function strafe_or_play()
	local random_roll: s32 = 0
	local angle_degrees: f32 = 0
	local distance: f32 = 0
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 50 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			random_roll = monster.get_random(100) or random_roll
			angle_degrees = monster.get_random_whole_number(30.0) or angle_degrees
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 85.0)
			if random_roll < 50 then
				angle_degrees = vm.f32(-angle_degrees - 30.0)
			else
				angle_degrees = vm.f32(angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_to_point_near_target(2.0, 5.0, angle_degrees, distance, 44.0, 30)
			movement.turn_toward_target_and_wait_guarded(5.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(44.0, 45.0, 30)
		end
	else
		play_in_place()
	end
end

--- Winds up, chases the target while charging and finishes with a strike.
local function charge_attack(charge_speed: f32, max_frames: s32)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(5.0)
	monster.set_motion("攻撃２in", -1, 6)
	motion.wait_until_finished_facing_target_guarded(5.0)
	monster.set_motion("攻撃２loop", -1, 4)
	movement.chase_target_guarded(charge_speed, 15.0, 44.0, max_frames)
	monster.set_motion("攻撃２", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(3)
end

--- Walks, runs or charges toward the target when it is far away.
local function act_at_far_range()
	local random_roll: s32 = 0
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 80 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(2.0, 5.0, 44.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(44.0, 45.0, 75)
			end
		else
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(3.0, 5.0, 44.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(5.0)
		charge_attack(9.0, 75)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Charges at the target, walks toward it or plays in place when it is at medium range.
local function act_at_mid_range()
	local random_roll: s32 = 0
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 60 then
		charge_attack(9.0, 60)
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(2.0, 5.0, 44.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			play_in_place()
		end
	end
end

--- Turns to the target and performs the punch.
local function punch_attack()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(5.0)
	monster.set_motion("攻撃１", -1, 2)
	local _ = movement.track_target_guarded(5.0, calc.pass_through(22))
	movement.turn_until_motion_progress(5.0, vm.f32(0.518), -1.0)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(3)
end

--- Steps backward away from the target.
local function step_back(move_speed: f32)
	local pos_x: f32 = 0
	local approach_y: f32 = 0
	local pos_z: f32 = 0
	local retreat_distance: f32 = 0
	local random_extra_distance: f32 = 0
	local pos_y_2: f32 = 0
	monster.set_monster_attributes(32, 1)
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	random_extra_distance = monster.get_random_whole_number(10.0) or random_extra_distance
	retreat_distance = vm.f32(retreat_distance + vm.f32(30.0 + random_extra_distance))
	pos_x, approach_y, pos_z = movement.get_approach_point(0.0, retreat_distance, pos_x, approach_y, pos_z)
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(7))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2, pos_z, move_speed, move_speed + 1.0)
	timer.wait_frames_with_guard_update(calc.pass_through(3))
	monster.set_monster_attributes(32, 0)
	timer.wait_frames_with_guard_update(calc.pass_through(12))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Punches, advances or steps back when the target is close.
local function act_at_near_range()
	local random_roll: s32 = 0
	monster.get_life_int()
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 60 then
		punch_attack()
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(2.0, 5.0, 44.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			step_back(6.0)
		end
	end
end

--- Repeatedly picks a behaviour by target distance until the target is far away.
local function engage_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.try_face_transformed_player_speed_5()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 270.0 then
			reaction.update_and_wait_frame()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			strafe_or_play()
			continue
		end
		if target_distance < 270.0 and target_distance >= 160.0 then
			act_at_far_range()
		elseif target_distance < 160.0 and target_distance >= 85.0 then
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
	if clear_distance < 44.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle_degrees, 5.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 44.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(5.0, vm.f32(1.8), turn_angle_degrees, clear_distance, 44.0, 30)
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
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.8), 5.0, distance, orbit_angle_degrees, 44.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, 5.0)
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
	if random_roll < 70 then
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
			movement.turn_to_angle_and_wait(turn_angle_degrees, 5.0)
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
					action_result = movement.walk_to_point_near_target(vm.f32(1.8), 5.0, approach_angle_degrees, approach_distance, 44.0, 60)
					end_turn_degrees = monster.get_random_whole_number(360.0) or end_turn_degrees
					random_roll = monster.get_random(100) or random_roll
					if random_roll < 50 then
						end_turn_degrees = vm.f32(end_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(end_turn_degrees, 5.0)
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
					movement.move_in_direction_guarded(vm.f32(1.8), turn_angle_degrees, 1000.0, 44.0, 60)
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
			movement.wander(vm.f32(1.8), 5.0, distance, 360.0, 40.0, 44.0, random_roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs or charges toward the target after the guard ends.
local function approach_after_guard()
	local target_distance: f32 = 0
	local random_roll: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 270.0 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(3.0, 5.0, 44.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			charge_attack(9.0, 75)
		end
	else
		monster.set_motion("走り", -1, 0)
		movement.chase_target_guarded(3.0, 5.0, 44.0, 90)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Fights aggressively with punches, charges and step backs once the rage hits are used up.
local function act_when_no_rage_hits_left()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local random_roll: s32 = 0
	local gekirin: s32 = 0
	monster.get_life_int()
	while true do
		reaction.update_and_wait_frame()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			strafe_or_play()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 85.0 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 75 then
				monster.set_motion("走り", 0)
				movement.chase_target_guarded(3.0, 5.0, 44.0, 30)
				punch_attack()
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(5.0)
				step_back(6.0)
			end
		else
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 75 then
				charge_attack(9.0, 75)
			else
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 70 then
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(3.0, 5.0, 44.0, 60)
					monster.set_motion("立ち", -1, 0)
				else
					play_in_place()
				end
			end
		end
	end
end

--- Chooses between engaging, wandering and the aggressive behaviour from the rage and guard state.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	target_distance = monster.get_target_distance() or target_distance
	if gekirin > 0 then
		behavior.try_face_transformed_player_speed_5()
		if reaction.is_guard_active() == 0 then
			if target_distance < 270.0 then
				engage_target()
			else
				wander_when_far()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 160.0 then
					reaction.set_guard_active(0)
					engage_target()
				else
					approach_after_guard()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		act_when_no_rage_hits_left()
	end
end

local script = {}

--- Runs once when the script is loaded, before any program.
function script.setup() end

--- Registers the monster's hit data, effects and starting state when it is placed.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("Ｍ連撃８", 4.0, "攻撃１", 0.54, 0.65, 0)
	monster.register_damage_hit("Ｍ連撃４", 6.0, "攻撃２loop", 0.0, 0.5, 0)
	monster.register_damage_hit("Ｍ連撃４", 6.0, "攻撃２loop", 0.5, 1.0, 0)
	monster.register_damage_hit("ＭＢ連撃１", 6.0, "攻撃２", 0.15, 0.28, 0)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("遊び", 0.225, 0.745, 1011)
	end
	initialize_behavior_defaults()
end

--- Each frame chooses the monster's behaviour from its rage, guard state and target distance.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
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

--- Plays the flinch reaction when the monster is hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown reaction when the monster is knocked over.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	monster.set_action_status(1)
	timer.wait_frames_with_guard_update(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Plays the guard reaction when the monster blocks a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("立ち")
	state.unlock()
end

--- Steps back from the attack.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(5.0)
	step_back(6.0)
	state.unlock()
end

--- Plays the guard pose in place of a dodge.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.reset_motion()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("立ち")
	state.unlock()
end

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

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster has no landing reaction.
function script.on_land() end

--- Plays the stun reaction until the monster recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
