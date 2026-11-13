--!strict
--- Controls the Pumpkinhead family of monsters, which throw bombs and back step around the target.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the monster's guard threshold, behavior parameters and clip distance.
local function configure_guard_and_clip()
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

--- Plays the idle animation a number of times, optionally stopping early when the target is in front.
local function play_idle_animation(repeat_count: s32, should_watch_target: s32)
	local iteration: s32 = 0
	local target_in_front: s32 = 0
	iteration = 0
	monster.set_motion("あそび", -1, 0)
	while iteration < repeat_count do
		if should_watch_target == 1 then
			target_in_front = sense.wait_until_target_in_front(29.0, 45.0, calc.pass_through(58))
			if target_in_front == 1 then
				return
			end
		else
			target_in_front = 0
			timer.wait_frames(calc.pass_through(58))
		end
		iteration = iteration + 1
	end
end

--- Plays the idle animation, strafes to a random point near the target or watches it.
local function idle_or_reposition()
	local random_value: s32 = 0
	local side_angle_degrees: f32 = 0
	local distance: f32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		random_value = monster.get_random(3) or random_value
		play_idle_animation(vm.i32(random_value + 1), 1)
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			random_value = monster.get_random(100) or random_value
			side_angle_degrees = monster.get_random_whole_number(30.0) or side_angle_degrees
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 60.0)
			if random_value < 50 then
				side_angle_degrees = vm.f32(-side_angle_degrees - 30.0)
			else
				side_angle_degrees = vm.f32(side_angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_to_point_near_target(2.0, 5.0, side_angle_degrees, distance, 29.0, 30)
			movement.turn_toward_target_and_wait_guarded(5.0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(29.0, 45.0, 30)
		end
	end
end

--- Steps sideways around the target toward the chosen side.
local function sidestep_toward_side(step_right: s32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local position_y: f32 = 0
	local target_distance: f32 = 0
	local step_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if step_right == 1 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		step_angle_degrees = 20.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		step_angle_degrees = -20.0
	end
	approach_x, approach_y, approach_z = movement.get_approach_point(step_angle_degrees, target_distance, approach_x, approach_y, approach_z)
	sense.wait_until_target_in_front(29.0, 45.0, calc.pass_through(7))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(approach_x, position_y - 10.0, approach_z, 2.0, 2.0)
	sense.wait_until_target_in_front(29.0, 45.0, calc.pass_through(14))
	monster.stop_moving()
	motion.wait_until_finished()
end

--- Throws the given number of bombs at the target, using the bomb type that matches the monster's grade.
local function throw_bombs(throw_count: s32)
	local throw_index: s32 = 0
	local attack: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local grade: s32 = 0
	while throw_index < throw_count do
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(5.0)
		monster.set_motion("攻撃２", -1, 6)
		movement.turn_until_motion_progress(5.0, vm.f32(0.733), -1.0)
		do
			local out1, out2, out3 = monster.get_frame_position("kabo")
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
		attack = monster.get_attack_power_1() or attack
		grade = monster.get_monster_grade_2(-1) or grade
		if grade == 0 then
			monster.create_effect_1("かぼちゃ爆弾")
		end
		if grade == 1 then
			monster.create_effect_1("ねばピーチＬ")
		end
		if grade == 2 then
			monster.create_effect_1("ストーンベリー")
		end
		if grade == 3 then
			monster.create_effect_1("ファイナルボム")
		end
		monster.set_effect_first_vector(-1, position_x, position_y, position_z)
		monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
		monster.set_effect_value(-1, 0, attack)
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames(3)
		throw_index = throw_index + 1
	end
end

--- Picks a sidestep, idle animation or bomb throw when the target is at far range.
local function act_at_far_range()
	local random_value: s32 = 0
	local step_right: s32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				step_right = 1
			else
				step_right = 0
			end
			random_value = monster.get_random(2) or random_value
			random_value = vm.i32(random_value + 1)
			for index = 0, random_value - 1 do
				sidestep_toward_side(step_right)
			end
		else
			random_value = monster.get_random(3) or random_value
			play_idle_animation(vm.i32(random_value + 1), 1)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(29.0, 45.0, 30)
		else
			random_value = monster.get_random(1) or random_value
			throw_bombs(vm.i32(1 + random_value))
			timer.wait_frames(3)
		end
	end
end

--- Hops backward away from the target by a slightly randomized distance.
local function back_step(move_speed: f32)
	local position_x: f32 = 0
	local start_y: f32 = 0
	local position_z: f32 = 0
	local target_distance: f32 = 0
	local distance_jitter: f32 = 0
	local current_y: f32 = 0
	monster.set_monster_attributes(32, 1)
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	distance_jitter = monster.get_random_whole_number(10.0) or distance_jitter
	target_distance = vm.f32(target_distance + vm.f32(30.0 + distance_jitter))
	position_x, start_y, position_z = movement.get_approach_point(0.0, target_distance, position_x, start_y, position_z)
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames(calc.pass_through(8))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(position_x, current_y, position_z, move_speed, move_speed + 1.0)
	timer.wait_frames(calc.pass_through(3))
	monster.set_monster_attributes(32, 0)
	timer.wait_frames(calc.pass_through(12))
	monster.stop_moving()
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Waits up to the given number of frames for the current movement to finish.
local function wait_until_move_finished(max_frames: s32)
	local arrived: s32 = 0
	for frame = 0, max_frames - 1 do
		arrived = monster.is_move_finished() or arrived
		if arrived == 0 then
			reaction.update_and_wait_frame()
		else
			return
		end
	end
end

--- Dashes toward and past the target, then stops moving.
local function charge_through_target(max_frames: s32)
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local position_y: f32 = 0
	local target_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, out2, out3 = monster.get_position_3()
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, start_x, start_y, start_z)
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
		local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, target_distance * 3.0)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.add_vectors(start_x, start_y, start_z, direction_x, direction_y, direction_z)
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(start_x, position_y - 30.0, start_z, 4.8, 4.8)
	wait_until_move_finished(max_frames)
	monster.stop_moving()
end

--- Picks a bomb throw, back steps or a charge when the target is at medium range.
local function act_at_medium_range()
	local random_value: s32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 70 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(5.0)
		random_value = monster.get_random(1) or random_value
		throw_bombs(vm.i32(1 + random_value))
		timer.wait_frames(3)
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 80 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			random_value = monster.get_random(2) or random_value
			random_value = vm.i32(random_value + 1)
			for index = 0, random_value - 1 do
				back_step(2.0)
			end
		else
			monster.set_motion("走り", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			charge_through_target(80)
			monster.set_motion("気絶", -1, 0)
			timer.wait_frames(90)
		end
	end
	vm.wait()
end

--- Picks an attack or back step when the target is at melee range.
local function act_at_melee_range()
	local random_value: s32 = 0
	monster.get_life()
	random_value = monster.get_random(100) or random_value
	if random_value < 60 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(5.0)
		combat.play_primary_attack()
		timer.wait_frames(3)
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			monster.set_motion("ステップ後", -1, 0)
			back_step(2.0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			movement.chase_target_guarded(2.0, 5.0, 29.0, 20)
			combat.play_primary_attack()
			timer.wait_frames(3)
		end
	end
end

--- Repeatedly chooses an attack by target distance until the target leaves range or the rage hits run out.
local function fight_target_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		behavior.try_face_transformed_player_speed_5()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 300.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left <= 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			idle_or_reposition()
			continue
		end
		if target_distance < 300.0 and target_distance >= 160.0 then
			act_at_far_range()
		elseif target_distance < 160.0 and target_distance >= 60.0 then
			act_at_medium_range()
		else
			act_at_melee_range()
		end
		vm.wait()
	end
end

--- Wanders, turns or waits near the monster's home position while the target is far away.
local function roam_around_home()
	local random_value: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local post_orbit_turn_degrees: f32 = 0
	local offset_angle_degrees: f32 = 0
	local offset_distance: f32 = 0
	local target_distance: f32 = 0
	local post_walk_turn_degrees: f32 = 0
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
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	distance = monster.get_distance_between(position_x, position_y, position_z, place_pos_x, place_pos_y, place_pos_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 29.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle_degrees, 5.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 29.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(5.0, 2.0, turn_angle_degrees, clear_distance, 29.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		random_value = monster.get_random(100) or random_value
		if random_value < 90 then
			if distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				monster.set_place_position(position_x, position_y, position_z)
			end
			random_value = monster.get_random(100) or random_value
			if random_value < 30 then
				monster.set_variable(0, 4)
				random_value = monster.get_random(100) or random_value
				orbit_angle_degrees = monster.get_random_whole_number(360.0) or orbit_angle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if random_value < 50 then
					orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
				else
					orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, 2.0, 5.0, distance, orbit_angle_degrees, 29.0, 60)
				post_orbit_turn_degrees = monster.get_random_whole_number(180.0) or post_orbit_turn_degrees
				random_value = monster.get_random(100) or random_value
				if random_value < 50 then
					post_orbit_turn_degrees = vm.f32(post_orbit_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(post_orbit_turn_degrees, 5.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, random_value)
			return
		end
	end
	random_value = monster.get_random(100) or random_value
	if random_value < 70 then
		random_value = monster.get_random(100) or random_value
		if random_value < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle_degrees, 5.0)
			monster.set_motion("立ち", -1, 0)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				random_value = monster.get_random(100) or random_value
				if random_value < 50 then
					monster.set_variable(0, 4)
					random_value = monster.get_random(100) or random_value
					offset_angle_degrees = monster.get_random_whole_number(180.0) or offset_angle_degrees
					offset_distance = monster.get_random_whole_number(30.0) or offset_distance
					target_distance = monster.get_target_distance() or target_distance
					offset_distance = vm.f32(offset_distance + target_distance)
					if random_value < 50 then
						offset_angle_degrees = vm.f32(offset_angle_degrees * -1.0)
					end
					random_value = monster.get_random(100) or random_value
					if random_value < 50 then
						offset_angle_degrees = vm.f32(-offset_angle_degrees - 30.0)
					else
						offset_angle_degrees = vm.f32(offset_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(2.0, 5.0, offset_angle_degrees, offset_distance, 29.0, 60)
					post_walk_turn_degrees = monster.get_random_whole_number(360.0) or post_walk_turn_degrees
					random_value = monster.get_random(100) or random_value
					if random_value < 50 then
						post_walk_turn_degrees = vm.f32(post_walk_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(post_walk_turn_degrees, 5.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					turn_angle_degrees = calc.radians_to_degrees(rotation_y)
					if turn_angle_degrees > vm.f32(3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees - vm.f32(6.2831855))
					end
					if turn_angle_degrees <= vm.f32(-3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(2.0, turn_angle_degrees, 1000.0, 29.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			random_value = monster.get_random(120) or random_value
			distance = monster.get_target_distance() or distance
			random_value = vm.i32(random_value + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(2.0, 5.0, distance, 360.0, 40.0, 29.0, random_value)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Throws bombs or chases the target while the monster is guarding.
local function approach_while_guarding()
	local random_value: s32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 75 then
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			throw_bombs(2)
		else
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(2.0, 5.0, 29.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	else
		monster.set_motion("走り", -1, 0)
		movement.chase_target_guarded(4.0, 5.0, 29.0, 90)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Fights the target with a different attack mix once no rage hits are left.
local function fight_without_rage_hits()
	local target_distance: f32 = 0
	local rage_hits_left: s32 = 0
	local random_value: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		return
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 60.0 then
		random_value = monster.get_random(100) or random_value
		if random_value < 85 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			movement.chase_target_guarded(2.0, 5.0, 29.0, 30)
			combat.play_primary_attack()
			timer.wait_frames(3)
		else
			monster.set_motion("ステップ後", -1, 0)
			back_step(2.0)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 85 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			random_value = monster.get_random(1) or random_value
			throw_bombs(vm.i32(1 + random_value))
			timer.wait_frames(3)
		else
			random_value = monster.get_random(100) or random_value
			if random_value < 75 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(5.0)
				random_value = monster.get_random(2) or random_value
				random_value = vm.i32(random_value + 1)
				for index = 0, random_value - 1 do
					back_step(2.0)
				end
			else
				monster.set_motion("走り", -1, 0)
				movement.turn_toward_target_and_wait_guarded(5.0)
				charge_through_target(80)
				monster.set_motion("気絶", -1, 0)
				timer.wait_frames(90)
			end
		end
	end
end

--- Picks the monster's behavior from its guard state and the distance to the target.
local function choose_action()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.try_face_transformed_player_speed_5()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 300.0 then
				fight_target_in_range()
			else
				roam_around_home()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 160.0 then
					reaction.set_guard_active(0)
					fight_target_in_range()
				else
					approach_while_guarding()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage_hits()
	end
end

--- Steps sideways around the target in a random direction while briefly ignoring collisions.
local function sidestep_random_direction()
	local random_value: s32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local position_y: f32 = 0
	local target_distance: f32 = 0
	local step_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	monster.set_monster_attributes(32, 1)
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		step_angle_degrees = 20.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		step_angle_degrees = -20.0
	end
	approach_x, approach_y, approach_z = movement.get_approach_point(step_angle_degrees, target_distance, approach_x, approach_y, approach_z)
	sense.wait_until_target_in_front(29.0, 45.0, calc.pass_through(7))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(approach_x, position_y - 10.0, approach_z, 2.0, 4.0)
	sense.wait_until_target_in_front(29.0, 45.0, calc.pass_through(5))
	monster.set_monster_attributes(32, 0)
	sense.wait_until_target_in_front(29.0, 45.0, calc.pass_through(9))
	monster.stop_moving()
	motion.wait_until_finished()
	monster.stop_moving()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the Pumpkinhead hit boxes, loads its effect scripts and applies its default settings.
function script.init()
	local grade: s32 = 0
	local texture_block: s32 = 0
	local bomb_loaded: s32 = 0
	local explosion_loaded: s32 = 0
	local texture_block_2: s32 = 0
	local peach_loaded: s32 = 0
	local explosion_loaded_2: s32 = 0
	local texture_block_3: s32 = 0
	local stone_berry_loaded: s32 = 0
	local explosion_loaded_3: s32 = 0
	local texture_block_4: s32 = 0
	local final_bomb_loaded: s32 = 0
	local final_bomb_large_loaded: s32 = 0
	monster.register_damage_hit("通常攻撃", 4.0, "攻撃１", 0.3, 0.8, 0)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		texture_block = monster.get_free_texture_block() or texture_block
		if texture_block ~= -1 then
			bomb_loaded = monster.load_effect_script("かぼちゃ爆弾", texture_block) or bomb_loaded
			explosion_loaded = monster.load_effect_script("Ｍ小爆発", texture_block) or explosion_loaded
			if (if bomb_loaded ~= 0 then 1 else explosion_loaded) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if grade == 1 then
		texture_block_2 = monster.get_free_texture_block() or texture_block_2
		if texture_block_2 ~= -1 then
			peach_loaded = monster.load_effect_script("ねばピーチＬ", texture_block_2) or peach_loaded
			explosion_loaded_2 = monster.load_effect_script("Ｍ小爆発", texture_block_2) or explosion_loaded_2
			if (if peach_loaded ~= 0 then 1 else explosion_loaded_2) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if grade == 2 then
		texture_block_3 = monster.get_free_texture_block() or texture_block_3
		if texture_block_3 ~= -1 then
			stone_berry_loaded = monster.load_effect_script("ストーンベリー", texture_block_3) or stone_berry_loaded
			explosion_loaded_3 = monster.load_effect_script("Ｍ小爆発", texture_block_3) or explosion_loaded_3
			if (if stone_berry_loaded ~= 0 then 1 else explosion_loaded_3) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if grade == 3 then
		texture_block_4 = monster.get_free_texture_block() or texture_block_4
		if texture_block_4 ~= -1 then
			final_bomb_loaded = monster.load_effect_script("ファイナルボム", texture_block_4) or final_bomb_loaded
			final_bomb_large_loaded = monster.load_effect_script("ファイナルボムＨ", texture_block_4) or final_bomb_large_loaded
			if (if final_bomb_loaded ~= 0 then 1 else final_bomb_large_loaded) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("あそび", 0.0, 1.0, 1007)
	end
	configure_guard_and_clip()
end

--- Runs the Pumpkinhead fighting and roaming behavior every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		choose_action()
	end
end

--- Freezes the monster in a damage pose until its status ailments clear.
function script.on_status_hit()
	local has_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_ailment = 1
	while has_ailment ~= 0 do
		has_ailment = monster.get_status_ailments(40) or has_ailment
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the flinch reaction when the monster takes a staggering hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knock-down and get-up sequence when the monster is blown over.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Plays the guard reaction when the monster blocks a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(25.0)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(30)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち", 0)
	state.unlock()
end

--- Is intentionally empty so the monster has no first dodge reaction.
function script.on_dodge_1()
	local argc: s32 = 0
	state.lock_and_reset_motion()
	argc = monster.get_random(20) or argc
	if argc < 20 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(5.0)
		sidestep_random_direction()
	else
		monster.set_motion("ステップ後", -1, 0)
		back_step(3.0)
	end
	state.unlock()
end

--- Is intentionally empty so the monster has no second dodge reaction.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays the death motion and the death effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Plays the struggling motion while the monster is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers the monster and stands it back up after it lands from a throw.
function script.on_land()
	reaction.recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	state.do_nothing_hook()
	return 1
end

--- Knocks the monster down and keeps it stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
