--!strict
--- Attack and throw sequence helpers for monster scripts.

local vm = require("@lib/vm")
local behavior = vm.module("@lib/monster/behavior")
local calc = vm.module("@lib/monster/calc")
local motion = vm.module("@lib/monster/motion")
local movement = vm.module("@lib/monster/movement")
local sense = vm.module("@lib/monster/sense")
local timer = vm.module("@lib/monster/timer")

local combat = {}

--- Faces the target, plays the first attack motion partway, then the second attack motion to its end.
function combat.approach_and_combo()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(7.2000003))
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress(vm.f32(0.595), -1.0)
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Faces the target, plays the second attack motion to its end and returns to standing.
function combat.approach_and_strike()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(7.2000003))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Randomly performs a dash strike, advances on the target, or strafes and watches for the target.
function combat.choose_dash_or_move()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 60 then
		combat.dash_strike()
	else
		roll = monster.get_random(100) or roll
		if roll < 55 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward(2.0, 3.0, 40.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_angle_degrees = -30.0
				monster.set_motion("歩き左", -1, 0)
			else
				strafe_angle_degrees = 30.0
				monster.set_motion("歩き右", -1, 0)
			end
			movement.circle_target(2.0, strafe_angle_degrees, 3.0, 60)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(40.0, 45.0, 30)
		end
	end
end

--- Randomly advances on the target, strafes around it and watches, or performs a dash strike.
function combat.choose_move_or_dash()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 30 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward(2.0, 3.0, 40.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(40.0, 45.0, 75)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_angle_degrees = -30.0
			else
				strafe_angle_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(2.0, 3.0, strafe_angle_degrees, target_distance, 90.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(40.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(3.0)
		combat.dash_strike()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Randomly performs the third attack motion, advances on the target, or side-walks in short bursts.
function combat.choose_move_or_slam()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 25 then
		combat.perform_strike_3()
	else
		roll = monster.get_random(100) or roll
		if roll < 65 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward(vm.f32(1.7), 3.0, 60.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_angle_degrees = -30.0
				monster.set_motion("歩き左", -1, 4)
			else
				strafe_angle_degrees = 30.0
				monster.set_motion("歩き右", -1, 4)
			end
			for i = 0, 2 do
				timer.wait_frames(13)
				movement.circle_target(vm.f32(2.5500002), strafe_angle_degrees, 3.0, 9)
				monster.stop_moving()
				timer.wait_frames(3)
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(60.0, 45.0, 30)
		end
	end
end

--- Randomly advances on the target, strafes around it and watches, or performs the second attack motion.
function combat.choose_move_or_swing()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 30 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward(vm.f32(1.7), 3.0, 60.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(60.0, 45.0, 75)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_angle_degrees = -30.0
			else
				strafe_angle_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(1.7), 3.0, strafe_angle_degrees, target_distance, 100.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(60.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(3.0)
		combat.perform_strike_2()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Moves the queued attacks forward or picks a new attack from the monster flags.
function combat.choose_next_attack()
	local next_attack: s32 = 0
	local following_attack: s32 = 0
	local last_attack: s32 = 0
	local state_flags: s32 = 0
	next_attack = monster.get_variable(2) or next_attack
	if next_attack ~= -1 then
		following_attack = monster.get_variable(3) or following_attack
		last_attack = monster.get_variable(4) or last_attack
		monster.set_variable(1, next_attack)
		monster.set_variable(2, following_attack)
		monster.set_variable(3, last_attack)
		monster.set_variable(4, -1)
		return
	end
	state_flags = monster.get_variable(0) or state_flags
	if bit32.band(state_flags, 2) ~= 0 then
		if bit32.band(state_flags, 192) == 192 then
			monster.set_variable(1, 2)
			monster.set_variable(2, 7)
			return
		end
		if bit32.band(state_flags, 48) == 48 then
			monster.set_variable(1, 1)
			monster.set_variable(2, 7)
			return
		end
		return
	end
	if bit32.band(state_flags, 4) ~= 0 then
		if sense.is_facing_target_degrees(180, 200) ~= 0 then
			monster.set_variable(1, 9)
		else
			monster.set_variable(1, 8)
		end
		return
	end
	monster.set_variable(1, 7)
end

--- Faces the target, plays the second attack motion and dashes toward the target.
function combat.dash_strike()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃２", -1, 2)
	timer.wait_frames(8)
	movement.rush_forward(4.5, 6.0, 1.0, 17)
	timer.wait_frames(9)
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Randomly approaches and lunges at the target, strafes around it, or sidesteps and steps backward.
function combat.engage_target()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	local step_right: s32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		monster.set_motion("歩き", -1, 0)
		movement.approach_target(1.75, vm.f32(4.8), 30.0, 30.0, 60)
		combat.lunge_at_target()
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 15 then
			roll = monster.get_random(100) or roll
			strafe_angle_degrees = monster.get_random_whole_number(60.0) or strafe_angle_degrees
			if roll < 50 then
				strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
			else
				strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.move_around_target(1.75, vm.f32(4.8), strafe_angle_degrees, 60.0, 1.0, 30.0, 50)
			movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_updating_lighting(9)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
			roll = monster.get_random(100) or roll
			if roll < 67 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					step_right = 1
					monster.set_motion("ステップ右", -1, 0)
				else
					step_right = 0
					monster.set_motion("ステップ左", -1, 0)
				end
				movement.sidestep_toward_side(1.75, 30.0, 30.0, step_right, 60)
				monster.set_motion("立ち", -1, 0)
			else
				movement.move_backward(1.75, 30.0, 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Clears an attribute, stops the monster, ends a throw, waits ten frames and resets the motion.
function combat.finish_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_counted(10)
	monster.reset_motion()
end

--- Ends a throw like finish_throw, waiting ten frames with a plain counting loop.
function combat.finish_throw_delayed()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	timer.wait_for_frames(10)
	monster.reset_motion()
end

--- Ends a throw like finish_throw while updating the guard state during the wait.
function combat.finish_throw_guarded()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_guarded(10)
	monster.reset_motion()
end

--- Ends a throw, waits ten frames and resets the motion for monsters using the alternative command set.
function combat.finish_throw_variant()
	monster.set_photo_opportunity(32, 0)
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	monster.call_command(143) -- retail: command 143 is not registered
	timer.wait_frames(10)
	monster.get_attack_power_0()
end

--- Faces the target, plays the first attack motion and rushes to the target's position.
function combat.lunge_at_target()
	local unused_x: f32 = 0
	local unused_y: f32 = 0
	local unused_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local ground_offset: f32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_until_facing_updating_lighting(vm.f32(7.2000003))
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	monster.get_target_position(unused_x, unused_y, unused_z)
	ground_offset = sense.get_ground_offset_at(unused_x, unused_y, unused_z, ground_offset)
	movement.move_toward_position(target_x, target_y, target_z, 12.0, 6.0, 5.0, 27)
	motion.wait_until_finished_updating_lighting()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_updating_lighting(9)
end

--- Faces the target, plays the first attack motion and lunges 100 units forward.
function combat.lunge_forward()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_angle: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	monster.set_motion("攻撃１", -1, 2)
	timer.wait_frames(12)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	position_x = vm.f32(position_x + vm.f32(100.0 * vm.sin(facing_angle)))
	position_z = vm.f32(position_z + vm.f32(100.0 * vm.cos(facing_angle)))
	monster.move_toward_position(position_x, position_y, position_z, 2.8, 2.8)
	timer.wait_frames(28)
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Faces the target, plays the first attack motion and lunges 100 units forward for a short time.
function combat.lunge_forward_short()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_angle: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	monster.set_motion("攻撃１", -1, 2)
	timer.wait_frames(12)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	position_x = vm.f32(position_x + vm.f32(100.0 * vm.sin(facing_angle)))
	position_z = vm.f32(position_z + vm.f32(100.0 * vm.cos(facing_angle)))
	monster.move_toward_position(position_x, position_y, position_z, 2.5500002, 2.5500002)
	timer.wait_frames(15)
	monster.stop_moving()
	timer.wait_frames(4)
end

--- Plays the first attack motion, then stands and waits 12 frames.
function combat.perform_primary_attack_and_recover()
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(12)
end

--- Turns toward the target, strikes the ground and spawns a shockwave effect ahead of the monster.
function combat.perform_shockwave()
	local attack_power: s32 = 0
	local facing_angle: f32 = 0
	local angle_difference: f32 = 0
	local shockwave_x: f32 = 0
	local shockwave_y: f32 = 0
	local shockwave_z: f32 = 0
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("攻撃２", -1, 2)
	timer.wait_frames(calc.pass_through(30))
	angle_difference = monster.get_target_angle() or angle_difference
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	angle_difference = vm.f32(angle_difference - facing_angle)
	if angle_difference < 0.0 then
		angle_difference = -angle_difference
	end
	angle_difference = vm.f32(angle_difference / 30.0)
	movement.turn_toward_target(angle_difference)
	timer.wait_frames(calc.pass_through(26))
	do
		local out1, out2, out3 = monster.get_point_from_facing(0.0, 16.0)
		shockwave_x = out1 or shockwave_x
		shockwave_y = out2 or shockwave_y
		shockwave_z = out3 or shockwave_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, shockwave_x, shockwave_y, shockwave_z)
	attack_power = monster.get_attack_power_1() or attack_power
	monster.set_effect_value(-1, 0, attack_power)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(12)
end

--- Faces the target and plays the second attack motion.
function combat.perform_strike_2()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃２", -1, 2)
	timer.wait_frames(28)
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Faces the target and plays the third attack motion.
function combat.perform_strike_3()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃３", -1, 2)
	timer.wait_frames(28)
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Plays the first attack motion up to a progress point, then plays the second attack motion and waits for it to finish.
function combat.play_double_attack()
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress_reached(vm.f32(0.55), -1.0)
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished()
end

--- Plays the first attack motion and waits for it to finish.
function combat.play_primary_attack()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_finished()
end

--- Plays the first attack and repeats it up to twice while the target stays close.
function combat.play_repeating_attack()
	local target_distance: f32 = 0
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress_reached(vm.f32(0.6), -1.0)
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 70.0 then
		monster.set_motion("攻撃１", -1, 0)
		motion.wait_until_progress_reached(vm.f32(0.6), -1.0)
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 70.0 then
		monster.set_motion("攻撃１", -1, 0)
		motion.wait_until_progress_reached(vm.f32(0.6), -1.0)
	end
	motion.wait_until_finished()
end

--- Plays the first attack and repeats it up to twice while the target stays close, updating the guard state.
function combat.play_repeating_attack_guarded()
	local target_distance: f32 = 0
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress(vm.f32(0.6), -1.0)
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 70.0 then
		monster.set_motion("攻撃１", -1, 0)
		motion.wait_until_progress(vm.f32(0.6), -1.0)
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 70.0 then
		monster.set_motion("攻撃１", -1, 0)
		motion.wait_until_progress(vm.f32(0.6), -1.0)
	end
	motion.wait_until_finished_guarded()
end

--- Plays the second attack motion and waits for it to finish.
function combat.play_second_attack()
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished()
end

--- Plays the second attack motion and waits for it to finish while updating the guard state.
function combat.play_second_attack_guarded()
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
end

--- Plays the first attack motion, spawns a ground shockwave effect at the collision frame position and waits for the motion to finish.
function combat.play_shockwave()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local ground_height: f32 = 0
	local ground_y: f32 = 0
	local attack_power: s32 = 0
	attack_power = monster.get_attack_power_1() or attack_power
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress_reached(vm.f32(0.6), -1.0)
	ground_height = monster.get_height_above_ground() or ground_height
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	ground_y = vm.f32(position_y - ground_height)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
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
	monster.create_effect_1("ＳウェーブＬ")
	monster.set_effect_first_vector(-1, position_x, ground_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	motion.wait_until_finished()
	monster.set_motion("歩き", -1, 0)
	timer.wait_frames(3)
end

--- Plays the first attack up to a later motion point and then the second attack while updating the guard state.
function combat.play_slow_two_hit_combo_guarded()
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress(vm.f32(0.55), -1.0)
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
end

--- Plays the first attack up to a motion point and then the second attack.
function combat.play_two_hit_combo()
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress_reached(vm.f32(0.45), -1.0)
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished()
end

--- Plays the first attack up to a motion point and then the second attack while updating the guard state.
function combat.play_two_hit_combo_guarded()
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress(vm.f32(0.45), -1.0)
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
end

--- Plays the first attack motion the given number of times while turning toward the target, then plays the stun motion for 20 frames per attack if it attacked more than once.
function combat.repeat_attack_then_tire(attack_count: s32)
	local attacks_done: s32 = 0
	attacks_done = 0
	while attacks_done < attack_count do
		monster.reset_motion()
		monster.set_motion("攻撃１", -1, 6)
		movement.track_target(10.0, calc.pass_through(42))
		attacks_done = attacks_done + 1
	end
	if attacks_done > 1 then
		monster.reset_motion()
		monster.set_motion("気絶", -1, 0)
		timer.wait_frames(vm.i32(attacks_done * 20))
	end
end

--- Runs the attack chosen by the attack variable.
function combat.run_selected_attack()
	local attack_id: s32 = 0
	attack_id = monster.get_variable(1) or attack_id
	if attack_id == 8 then
		behavior.wander_until_near_target()
	end
	if attack_id == 9 then
		combat.run_shockwave()
	end
	if attack_id == 1 then
		combat.perform_primary_attack_and_recover()
	end
	if attack_id == 2 then
		combat.perform_shockwave()
	end
	if attack_id == 7 then
		monster.set_motion("立ち")
		timer.wait_cooldown_and_reset()
	end
end

--- Runs the shockwave attack.
function combat.run_shockwave()
	combat.perform_shockwave()
end

--- Plays the second attack motion and fires a nose bullet effect every fourth frame for 60 frames while mask flags 1 and 2 are cleared.
function combat.shoot_nose_bullets()
	local nose_x: f32 = 0
	local nose_y: f32 = 0
	local nose_z: f32 = 0
	local tip_x: f32 = 0
	local tip_y: f32 = 0
	local tip_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local frame: s32 = 0
	local attack_power: s32 = 0
	monster.set_variable(0, 2)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃２", -1, 6)
	timer.wait_frames(calc.pass_through(32))
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_variable(0, 4)
	attack_power = monster.get_attack_power_1() or attack_power
	frame = 0
	while frame < calc.pass_through(60) do
		if vm.imod(frame, 4) == 0 then
			do
				local out1, out2, out3 = monster.get_frame_position("_nose_1")
				nose_x = out1 or nose_x
				nose_y = out2 or nose_y
				nose_z = out3 or nose_z
			end
			do
				local out1, out2, out3 = monster.get_frame_position("chn123")
				tip_x = out1 or tip_x
				tip_y = out2 or tip_y
				tip_z = out3 or tip_z
			end
			do
				local out1, out2, out3 = monster.copy_vector(tip_x, tip_y, tip_z)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			do
				local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, nose_x, nose_y, nose_z)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			direction_y = vm.f32(direction_y / 3.0)
			do
				local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			monster.create_effect_1("鼻弾Ｌ")
			monster.set_effect_first_vector(-1, tip_x, tip_y, tip_z)
			monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
			monster.set_effect_value(-1, 0, attack_power)
		end
		vm.wait()
		frame = frame + 1
	end
	timer.wait_frames(calc.pass_through(8))
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(12)
end

--- Plays the second attack motion, turns toward the target until the motion reaches the spit frame and spits a poison projectile using the given effect vector.
function combat.spit_poison(effect_vector_x: f32, effect_vector_y: f32, effect_vector_z: f32, unused: any)
	local mouth_x: f32 = 0
	local mouth_y: f32 = 0
	local mouth_z: f32 = 0
	local character_number: s32 = 0
	local attack_power: s32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	motion.wait_until_progress_facing_target(10.0, vm.f32(0.538), vm.f32(0.01))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol2")
		mouth_x = out1 or mouth_x
		mouth_y = out2 or mouth_y
		mouth_z = out3 or mouth_z
	end
	character_number = monster.get_character_number() or character_number
	attack_power = monster.get_attack_power_1() or attack_power
	monster.create_effect_1("毒液2L")
	monster.set_effect_target(-1, character_number)
	monster.set_effect_first_vector(-1, mouth_x, mouth_y, mouth_z)
	monster.set_effect_second_vector(-1, effect_vector_x, effect_vector_y, effect_vector_z)
	monster.set_effect_value(-1, 0, attack_power)
	motion.wait_until_finished()
end

--- Turns to face the target, plays the first attack motion, waits for it to finish and idles for nine frames.
function combat.turn_and_play_first_attack()
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(8.4))
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Turns to face the target, plays the second attack motion, waits for it to finish and idles for nine frames.
function combat.turn_and_play_second_attack()
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(8.4))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

return combat
