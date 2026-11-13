--!strict
--- Drives the Master Jacket family: a sword-wielding monster that fights by distance, guards and dodges.

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

--- Sets the guard threshold, secondary parameters and clip distance shared by this monster's variants.
local function set_default_parameters()
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

--- Hovers near the target at a random offset or waits for it to face the monster while another monster holds the attack priority.
local function wait_for_turn()
	local roll: s32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		offset_angle = monster.get_random_whole_number(30.0) or offset_angle
		offset_distance = monster.get_random_whole_number(30.0) or offset_distance
		offset_distance = vm.f32(offset_distance + 110.0)
		if roll < 50 then
			offset_angle = vm.f32(-offset_angle - 30.0)
		else
			offset_angle = vm.f32(offset_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(1.85), vm.f32(4.8), offset_angle, offset_distance, 38.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(38.0, 45.0, 30)
	end
end

--- Chases the target or wanders when it is far away.
local function close_in_on_target()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 75 then
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(vm.f32(1.85), vm.f32(4.8), 110.0, 45)
	else
		roll = monster.get_random(100) or roll
		if roll < 10 then
			monster.set_motion("歩き", -1, 0)
			movement.wander(vm.f32(1.85), vm.f32(4.8), 30.0, 180.0, 30.0, 110.0, 25)
		end
	end
end

--- Plays the second attack motion to its end.
local function perform_attack_2()
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	motion.wait_until_finished()
end

--- Plays the first attack motion while turning to follow the target.
local function perform_tracking_attack_1()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target_guarded(vm.f32(4.8), calc.pass_through(11))
	motion.wait_until_finished()
end

--- Steps to the left or right and returns to standing.
local function sidestep()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local step_angle: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local step_distance: f32 = 0
	local roll: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		step_angle = out2 or step_angle
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ左", -1, 6)
		step_angle = vm.f32(step_angle + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 6)
		step_angle = vm.f32(step_angle - vm.f32(1.5707964))
	end
	step_distance = 100.0
	destination_x = vm.f32(position_x + vm.f32(vm.sin(step_angle) * step_distance))
	destination_y = vm.f32(position_y - 20.0)
	destination_z = vm.f32(position_z + vm.f32(vm.cos(step_angle) * step_distance))
	monster.set_monster_attributes(32, 1)
	motion.wait_until_progress(vm.f32(0.3), -1.0)
	monster.move_toward_position(destination_x, destination_y, destination_z, 2.96, 2.96)
	motion.wait_until_progress(vm.f32(0.6), -1.0)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Steps away from the target by a randomised distance at the given speed.
local function step_backward(move_speed: f32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local retreat_distance: f32 = 0
	local random_extra: f32 = 0
	local current_y: f32 = 0
	monster.set_monster_attributes(32, 1)
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		point_x = out1 or point_x
		point_z = out3 or point_z
	end
	random_extra = monster.get_random_whole_number(10.0) or random_extra
	retreat_distance = vm.f32(retreat_distance + vm.f32(30.0 + random_extra))
	point_x, point_y, point_z = movement.get_approach_point(0.0, retreat_distance, point_x, point_y, point_z)
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames(calc.pass_through(6))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(point_x, current_y, point_z, move_speed, move_speed + 1.0)
	timer.wait_frames(calc.pass_through(3))
	monster.set_monster_attributes(32, 0)
	timer.wait_frames(calc.pass_through(17))
	monster.stop_moving()
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Picks a mid-range action: a running attack, a flanking walk, sidesteps or a backward step.
local function act_at_mid_range()
	local roll: s32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 90 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(4.0, vm.f32(4.8), 38.0, 30)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			perform_attack_2()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(3)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(4.0, vm.f32(4.8), 38.0, 30)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			perform_tracking_attack_1()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 90 then
			roll = monster.get_random(100) or roll
			offset_angle = monster.get_random_whole_number(30.0) or offset_angle
			offset_distance = monster.get_random_whole_number(30.0) or offset_distance
			offset_distance = vm.f32(offset_distance + 55.0)
			if roll < 50 then
				offset_angle = vm.f32(-offset_angle - 30.0)
			else
				offset_angle = vm.f32(offset_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.85), vm.f32(4.8), offset_angle, offset_distance, 38.0, 30)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
		else
			roll = monster.get_random(100) or roll
			if roll < 10 then
				for i = 0, 2 do
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					sidestep()
					monster.set_motion("立ち", -1, 0)
					sense.wait_until_target_in_front(38.0, 45.0, 15)
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				step_backward(vm.f32(2.22))
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			end
		end
	end
end

--- Plays the first attack motion and follows with the second after a short delay.
local function perform_combo_attack()
	monster.set_motion("攻撃１", -1, 4)
	timer.wait_frames(calc.pass_through(18))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished()
end

--- Plays the first attack motion, waits longer, and follows with the second.
local function perform_slow_combo_attack()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	timer.wait_frames(calc.pass_through(22))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished()
end

--- Picks a close-range action: one of the attacks, a sidestep, a backward step or a walk around the target.
local function act_at_close_range()
	local roll: s32 = 0
	local first_angle: f32 = 0
	local second_angle: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 30 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(vm.f32(1.85), vm.f32(4.8), 38.0, 30)
				movement.turn_toward_target_with_offset_guarded(vm.f32(4.8), 20.0, 5)
				perform_attack_2()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(3)
			else
				roll = monster.get_random(100) or roll
				if roll < 85 then
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(vm.f32(1.85), vm.f32(4.8), 38.0, 30)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					perform_tracking_attack_1()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames(3)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					perform_combo_attack()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames(3)
				end
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(vm.f32(1.85), vm.f32(4.8), 38.0, 30)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			perform_slow_combo_attack()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 10 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				step_backward(vm.f32(2.22))
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(4.0, vm.f32(4.8), 38.0, 30)
					perform_tracking_attack_1()
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				sidestep()
				monster.set_motion("立ち", -1, 0)
			end
		else
			monster.set_motion("歩き", -1, 0)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				first_angle = 270.0
				second_angle = 180.0
			else
				first_angle = 90.0
				second_angle = 270.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.85), vm.f32(4.8), first_angle, 76.0, 38.0, 30)
			movement.walk_to_point_near_target(vm.f32(1.85), vm.f32(4.8), second_angle, 76.0, 38.0, 30)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			perform_tracking_attack_1()
		end
	end
end

--- Fights the target by distance until it leaves range or the rage counter runs out.
local function fight_target_cautiously()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 250.0 then
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
			wait_for_turn()
			continue
		end
		if target_distance < 250.0 and target_distance >= 170.0 then
			close_in_on_target()
		elseif target_distance < 170.0 and target_distance >= 110.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
		vm.wait()
	end
end

--- Roams around the placement position by circling it, wandering or waiting for the target to threaten.
local function roam()
	local roll: s32 = 0
	local result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local circle_angle: f32 = 0
	local turn_after_walk: f32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	local target_distance: f32 = 0
	local turn_after_approach: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_position_x = out1 or place_position_x
		place_position_y = out2 or place_position_y
		place_position_z = out3 or place_position_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 38.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 38.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.8), vm.f32(1.85), turn_angle, clear_distance, 38.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				monster.set_place_position(position_x, position_y, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				circle_angle = monster.get_random_whole_number(360.0) or circle_angle
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					circle_angle = vm.f32(-circle_angle - 30.0)
				else
					circle_angle = vm.f32(circle_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, vm.f32(1.85), vm.f32(4.8), distance, circle_angle, 38.0, 60)
				turn_after_walk = monster.get_random_whole_number(180.0) or turn_after_walk
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_after_walk = vm.f32(turn_after_walk * -1.0)
				end
				movement.turn_to_angle_and_wait(turn_after_walk, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 20 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle = monster.get_random_whole_number(180.0) or turn_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle = vm.f32(turn_angle * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle, vm.f32(4.8))
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
					offset_angle = monster.get_random_whole_number(180.0) or offset_angle
					offset_distance = monster.get_random_whole_number(30.0) or offset_distance
					target_distance = monster.get_target_distance() or target_distance
					offset_distance = vm.f32(offset_distance + target_distance)
					if roll < 50 then
						offset_angle = vm.f32(offset_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						offset_angle = vm.f32(-offset_angle - 30.0)
					else
						offset_angle = vm.f32(offset_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					result = movement.walk_to_point_near_target(vm.f32(1.85), vm.f32(4.8), offset_angle, offset_distance, 38.0, 60)
					turn_after_approach = monster.get_random_whole_number(360.0) or turn_after_approach
					roll = monster.get_random(100) or roll
					if roll < 50 then
						turn_after_approach = vm.f32(turn_after_approach * -1.0)
					end
					movement.turn_to_angle_and_wait(turn_after_approach, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					turn_angle = calc.radians_to_degrees(rotation_y)
					if turn_angle > vm.f32(3.1415927) then
						turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
					end
					if turn_angle <= vm.f32(-3.1415927) then
						turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(vm.f32(1.85), turn_angle, 1000.0, 38.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.85), vm.f32(4.8), distance, 360.0, 40.0, 38.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Turns to the target and runs after it.
local function chase_target()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(4.0, vm.f32(4.8), 38.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Fights the target aggressively once the rage counter has run out.
local function fight_target_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 250.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			wait_for_turn()
			continue
		end
		if target_distance < 110.0 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 30 then
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(vm.f32(1.85), vm.f32(4.8), 38.0, 60)
					movement.turn_toward_target_with_offset_guarded(vm.f32(4.8), 20.0, 15)
					perform_attack_2()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames(2)
				else
					roll = monster.get_random(100) or roll
					if roll < 85 then
						monster.set_motion("歩き", -1, 0)
						movement.chase_target_guarded(vm.f32(1.85), vm.f32(4.8), 38.0, 60)
						movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
						perform_tracking_attack_1()
						monster.set_motion("立ち", -1, 0)
						timer.wait_frames(2)
					else
						monster.set_motion("歩き", -1, 0)
						movement.chase_target_guarded(vm.f32(1.85), vm.f32(4.8), 38.0, 60)
						monster.set_motion("歩き", -1, 0)
						movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
						perform_combo_attack()
						monster.set_motion("立ち", -1, 0)
						timer.wait_frames(2)
					end
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(vm.f32(1.85), vm.f32(4.8), 38.0, 60)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				perform_slow_combo_attack()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(2)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 70 then
				roll = monster.get_random(100) or roll
				if roll < 30 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(4.0, vm.f32(4.8), 38.0, 60)
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					perform_attack_2()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames(3)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(4.0, vm.f32(4.8), 38.0, 60)
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					perform_tracking_attack_1()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames(3)
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(4.0, vm.f32(4.8), 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Chooses between fighting, roaming and chasing from the target distance, the guard state and the rage counter.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 250.0 then
				fight_target_cautiously()
			else
				roam()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 170.0 then
					reaction.set_guard_active(0)
					fight_target_cautiously()
				else
					chase_target()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_target_enraged()
	end
end

local script = {}

--- Runs once when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the monster's attack hits and applies its default parameters when it is placed.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("Ｍ連撃１", 3.0, "攻撃１", 0.36, 0.5, 0, 1)
	monster.register_damage_hit("Ｍ連撃１", 4.0, "攻撃２", 0.1, 0.5, 0, 1)
	monster.add_sword_trail(0, "攻撃１", 0.25, 0.27, "dcol0", "dcol1", 77, 20, 40)
	monster.add_sword_trail(0, "攻撃２", 0.3, 0.32, "dcol0", "dcol1", 77, 20, 40)
	set_default_parameters()
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 3 then
		monster.set_clip_distance(99999.9)
	end
end

--- Runs the monster's main behaviour loop.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
end

--- Holds the monster in its damage pose until its status ailment ends.
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

--- Staggers the monster back and recovers when it takes a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Knocks the monster down, then lets it get back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Plays the guard motions when the monster blocks a hit.
function script.on_guard()
	local roll: s32 = 0
	state.lock_and_stop_moving()
	roll = monster.get_random(100) or roll
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	if roll < 30 then
		perform_attack_2()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames(3)
	else
		monster.set_motion("ガードout", -1, 2)
		motion.wait_until_finished()
	end
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges the first kind of attack by sidestepping or stepping backward.
function script.on_dodge_1()
	local roll: s32 = 0
	state.lock_and_reset_motion()
	roll = monster.get_random(20) or roll
	if roll < 20 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
		sidestep()
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("ステップ後", -1, 0)
		step_backward(vm.f32(2.775))
	end
	state.unlock()
end

--- Blocks the second kind of attack with the guard motions.
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

--- Plays the death, with a small chance to get back up with part of its life.
function script.on_death()
	local revived_life: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 10 then
		monster.stop_moving()
		movement.stop_turning()
		monster.set_mask_flags(1, 1)
		monster.set_mask_flags(2, 1)
		monster.set_monster_attributes(32, 1)
		monster.set_motion("死に", -1, 2)
		motion.wait_until_finished()
		revived_life = monster.get_random_whole_number(0.3) or revived_life
		revived_life = vm.f32(revived_life + vm.f32(0.2))
		monster.set_life(revived_life)
		timer.wait_frames(45)
		monster.set_motion("起き上がり", -1, 2)
		motion.wait_until_finished()
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
		monster.set_monster_attributes(32, 0)
		return
	end
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles in place while the monster is held.
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

--- Knocks the monster over and holds it until the stun ends.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
