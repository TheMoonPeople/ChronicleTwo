--!strict
--- Controls the Goyone, a slime that charges the target and spits sticky goo.

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

--- Sets the monster's default guard and clip-distance settings, with unlimited clip distance for bosses.
local function apply_default_settings()
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

--- Plays the idle motion until the target is in front, then stands.
local function idle_and_watch_target()
	monster.set_motion("遊び", 2)
	sense.wait_until_target_in_front(55.0, 45.0, calc.pass_through(56))
	monster.set_motion("立ち", 0)
end

--- Strafes around the target at a fixed distance or idles in place while waiting for an opening.
local function keep_distance_while_waiting()
	local roll: s32 = 0
	local offset_degrees: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			offset_degrees = monster.get_random_whole_number(30.0) or offset_degrees
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 115.0)
			if roll < 50 then
				offset_degrees = vm.f32(-offset_degrees - 30.0)
			else
				offset_degrees = vm.f32(offset_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_to_point_near_target(2.0, 3.0, offset_degrees, distance, 55.0, 30)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(55.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		idle_and_watch_target()
	end
end

--- Turns to the target and charges at it with the first attack motion for a number of seconds.
local function charge_at_target(speed: f32, duration_seconds: s32)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(6.0)
	monster.set_motion("攻撃１", -1, 0)
	movement.chase_target_guarded(vm.f32(speed * 2.0), 4.5, 55.0, vm.i32(30 * duration_seconds))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks a random advance, circling move or charge for a target at long range.
local function choose_long_range_move()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(2.0, 3.0, 55.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				idle_and_watch_target()
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_degrees = -30.0
			else
				strafe_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.0, 3.0, strafe_degrees, target_distance, 115.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(55.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		charge_at_target(vm.f32(3.6), 4)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Turns to the target and spits a sticky goo projectile with the second attack motion.
local function spit_sticky_goo()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("攻撃２", -1, 6)
	movement.turn_until_motion_progress(3.0, vm.f32(0.72), vm.f32(0.02))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("ねばねばＬ２")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks a random goo spit, charge, advance or circling move for a target at mid range.
local function choose_mid_range_move()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 75 then
		roll = monster.get_random(100) or roll
		if roll < 30 then
			spit_sticky_goo()
		else
			charge_at_target(vm.f32(3.6), 3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 75 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(2.0, 3.0, 55.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_degrees = -30.0
			else
				strafe_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.0, 3.0, strafe_degrees, target_distance, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(55.0, 45.0, 30)
		end
	end
end

--- Turns to the target and plays the third attack motion.
local function perform_attack_3()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("攻撃３", -1, 2)
	timer.wait_frames_with_guard_update(calc.pass_through(36))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Charges at the target several times and finishes with the third attack motion.
local function charge_repeatedly_then_strike(speed: f32, charge_count: s32)
	local charge_index: s32 = 0
	local hit_result: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(6.0)
	charge_index = 0
	while charge_index < charge_count do
		monster.set_motion("攻撃１", -1, 0)
		movement.rush_forward_guarded(speed, 15.0, 1.0, 20)
		if hit_result == 1 or hit_result == 2 then
			break
		else
			charge_index = charge_index + 1
		end
	end
	monster.set_motion("攻撃３", -1, 2)
	timer.wait_frames_with_guard_update(calc.pass_through(36))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Sidesteps left or right around the target at the given speed to dodge.
local function sidestep_around_target(speed: f32)
	local roll: s32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local pos_y: f32 = 0
	local target_distance: f32 = 0
	local offset_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		offset_degrees = 30.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		offset_degrees = -30.0
	end
	approach_x, approach_y, approach_z = movement.get_approach_point(offset_degrees, target_distance, approach_x, approach_y, approach_z)
	sense.wait_until_target_in_front(55.0, 45.0, calc.pass_through(5))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(approach_x, pos_y - 10.0, approach_z, speed, speed)
	monster.set_monster_attributes(32, 1)
	sense.wait_until_target_in_front(55.0, 45.0, calc.pass_through(15))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
end

--- Steps backward away from the target at the given speed to dodge.
local function step_backward(move_speed: f32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local retreat_distance: f32 = 0
	local extra_distance: f32 = 0
	local position_y: f32 = 0
	monster.set_monster_attributes(32, 1)
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		approach_x = out1 or approach_x
		approach_z = out3 or approach_z
	end
	extra_distance = monster.get_random_whole_number(10.0) or extra_distance
	retreat_distance = vm.f32(retreat_distance + vm.f32(40.0 + extra_distance))
	approach_x, approach_y, approach_z = movement.get_approach_point(0.0, retreat_distance, approach_x, approach_y, approach_z)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(approach_x, position_y, approach_z, move_speed, move_speed + 1.0)
	timer.wait_frames_with_guard_update(calc.pass_through(12))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Picks a random attack, dodge or circling move for a target at close range.
local function choose_close_range_move()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 75 then
		if roll < 85 then
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 70.0 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					perform_attack_3()
				else
					spit_sticky_goo()
				end
			else
				charge_at_target(vm.f32(3.6), 3)
			end
		else
			charge_repeatedly_then_strike(vm.f32(3.6), 2)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 55 then
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 65.0 then
				sidestep_around_target(vm.f32(3.6))
			else
				step_backward(vm.f32(3.6))
			end
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			strafe_degrees = monster.get_random_whole_number(60.0) or strafe_degrees
			if roll < 50 then
				strafe_degrees = vm.f32(-strafe_degrees - 30.0)
			else
				strafe_degrees = vm.f32(strafe_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.0, 3.0, strafe_degrees, 110.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Loops choosing moves by target distance until the target leaves range or rage hits run out.
local function fight_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 245.0 then
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
			keep_distance_while_waiting()
			continue
		end
		if target_distance < 245.0 and target_distance >= 180.0 then
			choose_long_range_move()
		elseif target_distance < 180.0 and target_distance >= 115.0 then
			choose_mid_range_move()
		else
			choose_close_range_move()
		end
	end
end

--- Idles, turns, circles or wanders near its spawn point while the target is out of combat range.
local function wander_idle()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unknown_mode: s32 = 0
	local home_distance: f32 = 0
	local turn_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local clear_distance: f32 = 0
	local orbit_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local offset_degrees: f32 = 0
	local walk_distance: f32 = 0
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
	home_distance = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or home_distance
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 55.0 then
		turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_degrees, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 55.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.0, 2.0, turn_degrees, clear_distance, 55.0, 30)
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
				orbit_degrees = monster.get_random_whole_number(360.0) or orbit_degrees
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if roll < 50 then
					orbit_degrees = vm.f32(-orbit_degrees - 30.0)
				else
					orbit_degrees = vm.f32(orbit_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, 2.0, 3.0, home_distance, orbit_degrees, 55.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, 3.0)
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
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_degrees = vm.f32(turn_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_degrees, 3.0)
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
					offset_degrees = monster.get_random_whole_number(180.0) or offset_degrees
					walk_distance = monster.get_random_whole_number(30.0) or walk_distance
					target_distance = monster.get_target_distance() or target_distance
					walk_distance = vm.f32(walk_distance + target_distance)
					if roll < 50 then
						offset_degrees = vm.f32(offset_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						offset_degrees = vm.f32(-offset_degrees - 30.0)
					else
						offset_degrees = vm.f32(offset_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(2.0, 3.0, offset_degrees, walk_distance, 55.0, 60)
					end_turn_degrees = monster.get_random_whole_number(360.0) or end_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						end_turn_degrees = vm.f32(end_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(end_turn_degrees, 3.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						yaw = out2 or yaw
					end
					turn_degrees = calc.radians_to_degrees(yaw)
					if turn_degrees > vm.f32(3.1415927) then
						turn_degrees = vm.f32(turn_degrees - vm.f32(6.2831855))
					end
					if turn_degrees <= vm.f32(-3.1415927) then
						turn_degrees = vm.f32(turn_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(2.0, turn_degrees, 1000.0, 55.0, 60)
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
		elseif unknown_mode == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			home_distance = monster.get_target_distance() or home_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(2.0, 3.0, home_distance, 360.0, 40.0, 55.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Chases the target or charges at it while the guard state is active.
local function chase_target_while_guarded()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		monster.set_motion("走り", -1, 0)
		movement.chase_target_guarded(vm.f32(3.6), 3.0, 55.0, 120)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		charge_at_target(vm.f32(3.6), 4)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Fights the target with faster attacks once its rage hits are used up.
local function fight_when_rage_exhausted()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local gekirin: s32 = 0
	local strafe_degrees: f32 = 0
	monster.get_life_int()
	while true do
		reaction.update_and_wait_frame()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			keep_distance_while_waiting()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 115.0 then
			roll = monster.get_random(100) or roll
			if roll < 70 then
				charge_repeatedly_then_strike(vm.f32(4.32), 4)
			else
				perform_attack_3()
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 85 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					charge_at_target(vm.f32(5.04), 4)
				else
					spit_sticky_goo()
				end
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.rush_forward_guarded(vm.f32(2.4), 3.0, 55.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_degrees = -30.0
					else
						strafe_degrees = 30.0
					end
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(3.0)
					monster.set_motion("歩き", -1, 0)
					movement.walk_to_point_near_target(vm.f32(2.4), 3.0, strafe_degrees, target_distance, 1.0, 45)
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(3.0)
					monster.set_motion("立ち", -1, 0)
					sense.wait_until_target_in_front(55.0, 45.0, 30)
				end
			end
		end
	end
end

--- Chooses between fighting, wandering and guard handling for each frame.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 245.0 then
				fight_target()
			else
				wander_idle()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 180.0 then
					reaction.set_guard_active(0)
					fight_target()
				else
					chase_target_while_guarded()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_when_rage_exhausted()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the Goyone's attack hits, loads its goo effects and applies its default settings when it is placed.
function script.init()
	local texture_block: s32 = 0
	local goo_low_loaded: s32 = 0
	local goo_high_loaded: s32 = 0
	monster.register_damage_hit("通常攻撃", 2.5, "攻撃１", 0.0, 1.0, 0, 2)
	monster.register_damage_hit("通常攻撃", 2.5, "攻撃３", 0.346, 0.448, 0, 2)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		goo_low_loaded = monster.load_effect_script("ねばねばＬ２", texture_block) or goo_low_loaded
		goo_high_loaded = monster.load_effect_script("ねばねばＨ", texture_block) or goo_high_loaded
		if (if goo_low_loaded ~= 0 then 1 else goo_high_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	apply_default_settings()
end

--- Runs the Goyone's normal combat behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		update_behavior()
	end
end

--- Holds the Goyone in its damage pose while a status ailment is active.
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

--- Plays the Goyone's stagger reaction to a normal hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Handles the Goyone being knocked down.
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

--- Handles the Goyone guarding against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	step_backward(vm.f32(3.6))
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	sidestep_around_target(vm.f32(3.6))
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the Goyone's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Handles the Goyone being caught and lifted.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Recovers the Goyone after it lands from a throw.
function script.on_land()
	reaction.recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_guard_update(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	state.do_nothing_hook()
	return 1
end

--- Stuns the Goyone until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
