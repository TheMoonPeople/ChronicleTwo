--!strict
--- Controls the Dragon family, ground dragons that claw, breathe fireballs and taunt.

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

--- Sets the guard thresholds and the clip distance used by the dragon.
local function configure_defense_and_clipping()
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

--- Waits until the current motion finishes or the target steps in front of the monster.
local function wait_for_motion_or_target_in_front(front_distance: f32, front_angle: f32)
	local motion_finished: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		motion_finished = monster.is_motion_finished() or motion_finished
		if motion_finished ~= 0 then
			return
		end
		if sense.is_target_in_front(front_distance, front_angle) == 1 then
			return
		end
	end
end

--- Plays its taunting motion until it ends or the target is in front.
local function play_taunt()
	local taunt_result: s32 = 0
	monster.set_variable(1, 32)
	monster.set_motion("遊び", -1, 6)
	wait_for_motion_or_target_in_front(49.0, 45.0)
	return taunt_result
end

--- Strafes beside the target, waits for the target to line up or taunts.
local function reposition_or_taunt()
	local roll: s32 = 0
	local side_angle: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			side_angle = monster.get_random_whole_number(30.0) or side_angle
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 120.0)
			if roll < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_to_point_near_target(vm.f32(1.7), 3.0, side_angle, distance, 49.0, 30)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(49.0, 45.0, 30)
		end
	else
		play_taunt()
	end
end

--- Turns to the target and swipes with its claws.
local function claw_attack()
	monster.set_variable(1, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("攻撃１", -1, 2)
	movement.turn_until_motion_progress(3.0, vm.f32(0.267), -1.0)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Turns to the target and breathes a fireball at it.
local function breathe_fireball()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local fire_direction_x: f32 = 0
	local fire_direction_y: f32 = 0
	local fire_direction_z: f32 = 0
	local value: f32 = 0
	local attack: s32 = 0
	monster.set_variable(1, 2)
	value = 10.0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("攻撃２", -1, 6)
	movement.turn_until_motion_progress(3.0, vm.f32(0.431), vm.f32(0.02))
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_frame_position("dcol_00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		fire_direction_x = out1 or fire_direction_x
		fire_direction_y = out2 or fire_direction_y
		fire_direction_z = out3 or fire_direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(fire_direction_x, fire_direction_y, fire_direction_z, pos_x, pos_y, pos_z)
		fire_direction_x = out1 or fire_direction_x
		fire_direction_y = out2 or fire_direction_y
		fire_direction_z = out3 or fire_direction_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	monster.create_effect_1("ドラゴン火弾Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y - 10.0, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	motion.wait_until_progress(vm.f32(0.583), vm.f32(0.02))
	monster.create_effect_1("ドラゴン火弾Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y - 5.0, pos_z)
	monster.set_effect_second_vector(-1, fire_direction_x, fire_direction_y, fire_direction_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks an attack or approach for when the target is far away.
local function act_at_long_range()
	local roll: s32 = 0
	local taunt_result: s32 = 0
	local target_distance: f32 = 0
	local life: f32 = 0
	local side_angle: f32 = 0
	life = 0.0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 75 then
		roll = monster.get_random(100) or roll
		if roll < 75 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				life = monster.get_life() or life
				if life < 0.5 then
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(4.0, 6.0, 120.0, 75)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(vm.f32(1.7), 3.0, 120.0, 90)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(49.0, 45.0, 75)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					side_angle = -30.0
				else
					side_angle = 30.0
				end
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(3.0)
				monster.set_motion("歩き", -1, 0)
				movement.walk_to_point_near_target(vm.f32(1.7), 3.0, side_angle, target_distance, 120.0, 45)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(3.0)
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(49.0, 45.0, 30)
			else
				taunt_result = play_taunt()
				if taunt_result == 1 then
					claw_attack()
				end
			end
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		breathe_fireball()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Picks an attack or approach for when the target is at medium distance.
local function act_at_medium_range()
	local roll: s32 = 0
	local taunt_result: s32 = 0
	local target_distance: f32 = 0
	local life: f32 = 0
	local side_angle: f32 = 0
	life = 0.0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 60 then
		monster.get_random(100, roll)
		if roll < 75 then
			breathe_fireball()
		else
			taunt_result = play_taunt()
			if taunt_result == 1 then
				claw_attack()
			else
				breathe_fireball()
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 70 then
			life = monster.get_life() or life
			if life < vm.f32(0.3) then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(3.0)
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(4.0, 6.0, 49.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(vm.f32(1.7), 3.0, 49.0, 90)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					side_angle = -30.0
				else
					side_angle = 30.0
				end
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(3.0)
				monster.set_motion("歩き", -1, 0)
				movement.walk_to_point_near_target(vm.f32(1.7), 3.0, side_angle, target_distance, 1.0, 45)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(3.0)
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(49.0, 45.0, 30)
			else
				play_taunt()
			end
		end
	end
end

--- Picks an attack or approach for when the target is close.
local function act_at_short_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		target_distance = monster.get_target_distance() or target_distance
		roll = monster.get_random(100) or roll
		if target_distance < 70.0 then
			claw_attack()
		else
			breathe_fireball()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 65 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(4.0, 6.0, 49.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			side_angle = monster.get_random_whole_number(60.0) or side_angle
			if roll < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.7), 3.0, side_angle, 98.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Chooses attacks by target distance for as long as the monster has rage hits left.
local function fight_with_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 300.0 then
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
			reposition_or_taunt()
			continue
		end
		if target_distance < 300.0 and target_distance >= 200.0 then
			act_at_long_range()
		elseif target_distance < 200.0 and target_distance >= 120.0 then
			act_at_medium_range()
		else
			act_at_short_range()
		end
	end
end

--- Wanders, waits or returns toward its home position while the target is out of range.
local function wander_near_home()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local home_distance: f32 = 0
	local random_angle: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle: f32 = 0
	local facing_angle: f32 = 0
	local strafe_angle: f32 = 0
	local strafe_distance: f32 = 0
	local target_distance: f32 = 0
	local final_angle: f32 = 0
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
	home_distance = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or home_distance
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 49.0 then
		random_angle = monster.get_random_whole_number(360.0) or random_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(random_angle, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 49.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.0, vm.f32(1.7), random_angle, clear_distance, 49.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if home_distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if home_distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if roll < 50 then
					orbit_angle = vm.f32(-orbit_angle - 30.0)
				else
					orbit_angle = vm.f32(orbit_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.7), 3.0, home_distance, orbit_angle, 49.0, 60)
				facing_angle = monster.get_random_whole_number(180.0) or facing_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					facing_angle = vm.f32(facing_angle * -1.0)
				end
				movement.turn_to_angle_and_wait(facing_angle, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 64 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			random_angle = monster.get_random_whole_number(180.0) or random_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				random_angle = vm.f32(random_angle * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(random_angle, 3.0)
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_variable(0, 4)
					roll = monster.get_random(100) or roll
					strafe_angle = monster.get_random_whole_number(180.0) or strafe_angle
					strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
					target_distance = monster.get_target_distance() or target_distance
					strafe_distance = vm.f32(strafe_distance + target_distance)
					if roll < 50 then
						strafe_angle = vm.f32(strafe_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_angle = vm.f32(-strafe_angle - 30.0)
					else
						strafe_angle = vm.f32(strafe_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(vm.f32(1.7), 3.0, strafe_angle, strafe_distance, 49.0, 60)
					final_angle = monster.get_random_whole_number(360.0) or final_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_angle = vm.f32(final_angle * -1.0)
					end
					movement.turn_to_angle_and_wait(final_angle, 3.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						heading = out2 or heading
					end
					random_angle = calc.radians_to_degrees(heading)
					if random_angle > vm.f32(3.1415927) then
						random_angle = vm.f32(random_angle - vm.f32(6.2831855))
					end
					if random_angle <= vm.f32(-3.1415927) then
						random_angle = vm.f32(random_angle + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(vm.f32(1.7), random_angle, 1000.0, 49.0, 60)
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
			roll = monster.get_random(120) or roll
			home_distance = monster.get_target_distance() or home_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.7), 3.0, home_distance, 360.0, 40.0, 49.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs at the target and sometimes follows with a fireball.
local function rush_target()
	local roll: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(4.0, 6.0, 49.0, 60)
	monster.set_motion("立ち", -1, 0)
	roll = monster.get_random(100) or roll
	if roll < 40 then
		breathe_fireball()
	end
end

--- Chooses attacks by target distance once the monster has no rage hits left.
local function fight_without_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local gekirin: s32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			reposition_or_taunt()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 120.0 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				if target_distance < 75.0 then
					claw_attack()
				else
					breathe_fireball()
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(3.0)
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(4.0, 6.0, 49.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 65 then
				breathe_fireball()
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(3.0)
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(4.0, 3.0, 49.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(vm.f32(1.7), 3.0, 49.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
	end
end

--- Decides between fighting, wandering and guarding based on rage hits, guard state and target distance.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			monster.set_defense_rate(1.0)
			if target_distance < 300.0 then
				fight_with_rage_hits()
			else
				wander_near_home()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 200.0 then
					monster.set_defense_rate(1.2)
					reaction.set_guard_active(0)
					fight_with_rage_hits()
				else
					monster.set_defense_rate(1.0)
					rush_target()
				end
			else
				monster.set_defense_rate(1.0)
				reaction.set_guard_active(0)
			end
		end
	else
		monster.set_defense_rate(1.2)
		fight_without_rage_hits()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers claw hits, fireball effects and sword trails and configures defense.
function script.init()
	local get_not_used_texb: s32 = 0
	local texture_reserve_flag_1: s32 = 0
	local texture_reserve_flag_2: s32 = 0
	local texture_reserve_flag_3: s32 = 0
	local grade: s32 = 0
	monster.register_damage_hit("ドラゴン爪", 3.5, "攻撃１", 0.267, 0.333, 1, 2)
	monster.register_damage_hit("ドラゴン爪", 3.5, "攻撃１", 0.644, 0.689, 3, 4)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		texture_reserve_flag_1 = monster.load_effect_script("ドラゴン火弾Ｆ", get_not_used_texb) or texture_reserve_flag_1
		texture_reserve_flag_2 = monster.load_effect_script("ドラゴン火弾Ｌ", get_not_used_texb) or texture_reserve_flag_2
		texture_reserve_flag_3 = monster.load_effect_script("ドラゴン火弾Ｈ", get_not_used_texb) or texture_reserve_flag_3
		if (if (if texture_reserve_flag_1 ~= 0 then 1 else texture_reserve_flag_2) ~= 0 then 1 else texture_reserve_flag_3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.add_sword_trail(0, "攻撃１", 0.222, 0.226, "kiseki0", "kiseki1", 45, 20, 45)
	monster.add_sword_trail(1, "攻撃１", 0.622, 0.626, "kiseki2", "kiseki3", 45, 20, 45)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("攻撃２", 0.431, 0.625, 1000)
	end
	monster.set_variable(1, 0)
	configure_defense_and_clipping()
end

--- Repeatedly chooses the dragon's next behavior.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
end

--- Staggers in place while a status ailment lasts.
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

--- Staggers back after a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ後", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Is knocked back and recovers.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("ダメージ後", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	state.unlock()
end

--- Does nothing when dodging.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Does nothing when dodging.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the death sequence.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Has no special behavior while caught.
function script.on_caught() end

--- Recovers after a throw without further action.
function script.on_land()
	reaction.recover_from_throw()
	state.do_nothing_hook()
	return 1
end

--- Is stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ後", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
