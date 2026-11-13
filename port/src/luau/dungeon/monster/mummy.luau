--!strict
--- Controls the Mummy monster family, an undead enemy that swings, spits poison mist and taunts.

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

--- Sets the guard, clip distance and secondary-variable defaults for the monster.
local function setup_defaults()
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

--- Plays the taunt motion a number of times, optionally stopping early when the target is in front.
local function play_taunt(repeat_count: s32, watch_target: s32, sight_range: f32)
	local sight_result: s32 = 0
	for i = 0, repeat_count - 1 do
		monster.reset_motion()
		monster.set_motion("遊び", -1, 6)
		if watch_target == 1 then
			sight_result = sense.wait_until_target_in_front(vm.f32(sight_range + 10.0), 180.0, calc.pass_through(40))
			if sight_result ~= 0 then
				return sight_result
			end
		else
			timer.wait_frames(calc.pass_through(40))
		end
	end
	return 0
end

--- Spits a poison mist effect from the mouth whose damage uses the monster's attack power.
local function spit_poison_mist()
	local attack: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	movement.turn_until_motion_progress(4.5, vm.f32(0.42), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol2")
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
	monster.create_effect_1("毒霧Ｌ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished()
end

--- Circles the target, waits for it to face the monster or taunts and spits poison mist.
local function circle_or_taunt()
	local random_value: s32 = 0
	local taunt_result: s32 = 0
	local side_angle: f32 = 0
	local orbit_distance: f32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			random_value = monster.get_random(100) or random_value
			side_angle = monster.get_random_whole_number(30.0) or side_angle
			orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
			orbit_distance = vm.f32(orbit_distance + 85.0)
			if random_value < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			taunt_result = movement.walk_to_point_near_target(vm.f32(1.4), 4.5, side_angle, orbit_distance, 34.0, 30)
			movement.turn_toward_target_and_wait_guarded(4.5)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(34.0, 45.0, 30)
		end
	else
		random_value = monster.get_random(3) or random_value
		taunt_result = play_taunt(vm.i32(1 + random_value), 1, 68.0)
		if taunt_result ~= 0 then
			movement.turn_toward_target_and_wait_guarded(18.0)
			spit_poison_mist()
		end
	end
end

--- Closes the distance to the target by running, walking or waiting when it is far away.
local function approach_from_far()
	local random_value: s32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 75 then
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(vm.f32(1.4), 4.5, 34.0, 60)
		else
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(4.0, 4.5, 34.0, 45)
			random_value = monster.get_random(2) or random_value
			play_taunt(vm.i32(1 + random_value), 1, 68.0)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(4.5)
			spit_poison_mist()
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 10 then
			monster.set_motion("歩き", -1, 0)
			movement.wander(vm.f32(1.4), 4.5, 30.0, 180.0, 30.0, 85.0, 25)
		end
	end
end

--- Performs the swing attack while tracking the target.
local function swing_attack()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target_guarded(4.5, calc.pass_through(16))
	motion.wait_until_finished()
end

--- Picks an attack, taunt or approach when the target is at middle range.
local function act_at_mid_range()
	local random_value: s32 = 0
	local walk_result: s32 = 0
	local side_angle: f32 = 0
	local orbit_distance: f32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 80 then
		random_value = monster.get_random(100) or random_value
		if random_value < 65 then
			random_value = monster.get_random(100) or random_value
			side_angle = monster.get_random_whole_number(30.0) or side_angle
			orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
			orbit_distance = vm.f32(orbit_distance + 85.0)
			if random_value < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			walk_result = movement.walk_to_point_near_target(vm.f32(1.4), 4.5, side_angle, orbit_distance, 34.0, 30)
			if walk_result == 0 then
				random_value = monster.get_random(3) or random_value
				walk_result = play_taunt(vm.i32(1 + random_value), 1, 68.0)
				if walk_result ~= 0 then
					movement.turn_toward_target_and_wait_guarded(18.0)
					spit_poison_mist()
				end
			else
				movement.turn_toward_target_and_wait_guarded(18.0)
				swing_attack()
			end
		else
			random_value = monster.get_random(3) or random_value
			walk_result = play_taunt(vm.i32(1 + random_value), 1, 68.0)
			if walk_result ~= 0 then
				movement.turn_toward_target_and_wait_guarded(18.0)
				spit_poison_mist()
			end
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(vm.f32(1.4), 4.5, 34.0, 60)
	end
end

--- Steps backward to a point away from the target at the given speed.
local function step_back_away(move_speed: f32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local target_distance: f32 = 0
	local distance_jitter: f32 = 0
	local position_y: f32 = 0
	monster.set_monster_attributes(32, 1)
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		approach_x = out1 or approach_x
		approach_z = out3 or approach_z
	end
	distance_jitter = monster.get_random_whole_number(10.0) or distance_jitter
	target_distance = vm.f32(target_distance + vm.f32(30.0 + distance_jitter))
	approach_x, approach_y, approach_z = movement.get_approach_point(0.0, target_distance, approach_x, approach_y, approach_z)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames(calc.pass_through(6))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(approach_x, position_y, approach_z, move_speed, move_speed + 1.0)
	timer.wait_frames(calc.pass_through(3))
	monster.set_monster_attributes(32, 0)
	timer.wait_frames(calc.pass_through(17))
	monster.stop_moving()
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Picks a swing, poison spit or backstep when the target is close.
local function act_at_close_range()
	local random_value: s32 = 0
	local target_distance: f32 = 0
	monster.get_life_int()
	random_value = monster.get_random(100) or random_value
	if random_value < 70 then
		if random_value < 50 then
			target_distance = monster.get_target_distance() or target_distance
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(13.5)
			if target_distance > 40.0 then
				movement.chase_target_guarded(vm.f32(1.4), 4.5, 34.0, 60)
			end
			swing_attack()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(3)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(13.5)
			spit_poison_mist()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(3)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(4.5)
			step_back_away(vm.f32(2.1))
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Fights the target while it stays in range and rage hits remain, choosing behaviour by distance.
local function fight_while_rage_remaining()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		behavior.try_face_transformed_player_speed_4_5()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 230.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			circle_or_taunt()
			continue
		end
		if target_distance < 230.0 and target_distance >= 140.0 then
			approach_from_far()
		elseif target_distance < 140.0 and target_distance >= 85.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
		vm.wait()
	end
end

--- Wanders around its home position by orbiting, turning, walking or waiting for the target.
local function wander_near_home()
	local random_value: s32 = 0
	local wait_result: s32 = 0
	local unset_mode: s32 = 0
	local home_distance: f32 = 0
	local heading: f32 = 0
	local home_position_x: f32 = 0
	local home_position_y: f32 = 0
	local home_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle: f32 = 0
	local final_turn_angle: f32 = 0
	local target_orbit_angle: f32 = 0
	local target_orbit_radius: f32 = 0
	local target_distance: f32 = 0
	local target_final_turn_angle: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		home_position_x = out1 or home_position_x
		home_position_y = out2 or home_position_y
		home_position_z = out3 or home_position_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	home_distance = monster.get_distance_between(position_x, position_y, position_z, home_position_x, home_position_y, home_position_z) or home_distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 34.0 then
		heading = monster.get_random_whole_number(360.0) or heading
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(heading, 4.5)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 34.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(4.5, vm.f32(1.4), heading, clear_distance, 34.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if home_distance > 300.0 then
		random_value = monster.get_random(100) or random_value
		if random_value < 90 then
			if home_distance > 800.0 then
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
				orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if random_value < 50 then
					orbit_angle = vm.f32(-orbit_angle - 30.0)
				else
					orbit_angle = vm.f32(orbit_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(home_position_x, home_position_y, home_position_z, vm.f32(1.4), 4.5, home_distance, orbit_angle, 34.0, 60)
				final_turn_angle = monster.get_random_whole_number(180.0) or final_turn_angle
				random_value = monster.get_random(100) or random_value
				if random_value < 50 then
					final_turn_angle = vm.f32(final_turn_angle * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_angle, 4.5)
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
	if random_value < 75 then
		random_value = monster.get_random(100) or random_value
		if random_value < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			heading = monster.get_random_whole_number(180.0) or heading
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				heading = vm.f32(heading * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(heading, 4.5)
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
					target_orbit_angle = monster.get_random_whole_number(180.0) or target_orbit_angle
					target_orbit_radius = monster.get_random_whole_number(30.0) or target_orbit_radius
					target_distance = monster.get_target_distance() or target_distance
					target_orbit_radius = vm.f32(target_orbit_radius + target_distance)
					if random_value < 50 then
						target_orbit_angle = vm.f32(target_orbit_angle * -1.0)
					end
					random_value = monster.get_random(100) or random_value
					if random_value < 50 then
						target_orbit_angle = vm.f32(-target_orbit_angle - 30.0)
					else
						target_orbit_angle = vm.f32(target_orbit_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(vm.f32(1.4), 4.5, target_orbit_angle, target_orbit_radius, 34.0, 60)
					target_final_turn_angle = monster.get_random_whole_number(360.0) or target_final_turn_angle
					random_value = monster.get_random(100) or random_value
					if random_value < 50 then
						target_final_turn_angle = vm.f32(target_final_turn_angle * -1.0)
					end
					movement.turn_to_angle_and_wait(target_final_turn_angle, 4.5)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					heading = calc.radians_to_degrees(rotation_y)
					if heading > vm.f32(3.1415927) then
						heading = vm.f32(heading - vm.f32(6.2831855))
					end
					if heading <= vm.f32(-3.1415927) then
						heading = vm.f32(heading + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(vm.f32(1.4), heading, 1000.0, 34.0, 60)
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
		elseif unset_mode == 8 then
			monster.set_variable(0, 1)
			random_value = monster.get_random(120) or random_value
			home_distance = monster.get_target_distance() or home_distance
			random_value = vm.i32(random_value + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.4), 4.5, home_distance, 360.0, 40.0, 34.0, random_value)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs at the target, taunts and spits poison mist.
local function charge_and_taunt()
	local random_value: s32 = 0
	local taunt_result: s32 = 0
	monster.set_motion("歩き", -1.0, 0)
	movement.turn_toward_target_and_wait_guarded(4.5)
	monster.set_motion("走り", -1.0, 0)
	movement.chase_target_guarded(4.0, 4.5, 34.0, 75)
	random_value = monster.get_random(3) or random_value
	taunt_result = play_taunt(vm.i32(1 + random_value), 1, 68.0)
	if taunt_result ~= 0 then
		movement.turn_toward_target_and_wait_guarded(18.0)
		spit_poison_mist()
	end
	monster.set_motion("立ち", -1, 0)
end

--- Fights the target once no rage hits remain, attacking when close and chasing otherwise.
local function fight_without_rage()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local random_value: s32 = 0
	local rage_hits_left: s32 = 0
	local close_distance: f32 = 0
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 230.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			circle_or_taunt()
			continue
		end
		if target_distance < 85.0 then
			random_value = monster.get_random(100) or random_value
			if random_value < 65 then
				close_distance = monster.get_target_distance() or close_distance
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(13.5)
				if close_distance > 40.0 then
					movement.chase_target_guarded(vm.f32(1.4), 4.5, 34.0, 60)
				end
				swing_attack()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(3)
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(13.5)
				spit_poison_mist()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(3)
			end
		else
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(13.5)
				spit_poison_mist()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(3)
			else
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(4.0, 4.5, 34.0, 60)
			end
		end
	end
end

--- Chooses between fighting, wandering and guard-breaking behaviour from the target distance and guard state.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_range: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.try_face_transformed_player_speed_4_5()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 230.0 then
				fight_while_rage_remaining()
			else
				wander_near_home()
			end
		else
			guard_range = state.get_secondary_float(guard_range)
			if target_distance < guard_range then
				if target_distance < 85.0 then
					reaction.set_guard_active(0)
					fight_while_rage_remaining()
				else
					charge_and_taunt()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage()
	end
end

--- Steps sideways around the target with the dodge motion.
local function sidestep_dodge()
	local random_value: s32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local position_y: f32 = 0
	local target_distance: f32 = 0
	local sidestep_offset: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	monster.set_monster_attributes(32, 1)
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		sidestep_offset = 30.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		sidestep_offset = -30.0
	end
	approach_x, approach_y, approach_z = movement.get_approach_point(sidestep_offset, target_distance, approach_x, approach_y, approach_z)
	sense.wait_until_target_in_front(34.0, 45.0, calc.pass_through(7))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(approach_x, position_y - 10.0, approach_z, 1.4, 1.4)
	sense.wait_until_target_in_front(34.0, 45.0, calc.pass_through(5))
	monster.set_monster_attributes(32, 0)
	sense.wait_until_target_in_front(34.0, 45.0, calc.pass_through(9))
	monster.stop_moving()
	motion.wait_until_finished()
	monster.stop_moving()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the monster's attack hits and loads its resources when it is placed.
function script.init()
	local texture_block: s32 = 0
	local poison_mist_l_loaded: s32 = 0
	local poison_mist_h_loaded: s32 = 0
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃１", 0.5, 0.65, 0)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		poison_mist_l_loaded = monster.load_effect_script("毒霧Ｌ", texture_block) or poison_mist_l_loaded
		poison_mist_h_loaded = monster.load_effect_script("毒霧Ｈ", texture_block) or poison_mist_h_loaded
		if (if poison_mist_l_loaded ~= 0 then 1 else poison_mist_h_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	setup_defaults()
end

--- Runs the monster's normal behaviour each frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		choose_behavior()
	end
end

--- Stands staggered while a status ailment lasts after being hit.
function script.on_status_hit()
	local ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailments = 1
	while ailments ~= 0 do
		ailments = monster.get_status_ailments(40) or ailments
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Reacts to a hit that staggers the monster.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Reacts to a hit that knocks the monster over and gets it back up.
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

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.get_random(100)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local random_value: s32 = 0
	state.lock_and_reset_motion()
	random_value = monster.get_random(20) or random_value
	if random_value < 20 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(4.5)
		sidestep_dodge()
	else
		monster.set_motion("ステップ後", -1, 0)
		step_back_away(vm.f32(2.1))
	end
	state.unlock()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(18.0)
	sidestep_dodge()
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays the monster's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while caught by a frame that lifts it.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Gets the monster back up after it has been thrown and lands.
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
