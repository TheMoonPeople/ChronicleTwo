--!strict
--- Controls the Mimic, a chest monster that circles the target and bites or lunges.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

local spawn_x: f32 = 0
local ground_y: f32 = 0
local spawn_z: f32 = 0

--- Stores the Mimic's spawn position and resets its ground height.
local function record_spawn_position()
	monster.call_command(50, spawn_x, ground_y, spawn_z) -- retail: the handler rejects 3 arguments
	ground_y = 0.0
end

--- Computes the point at an angle offset from the target at the given distance.
local function get_point_around_target(offset_degrees: f32, distance: f32, x: f32, y: f32, z: f32)
	local offset_radians: f32 = 0
	local angle: f32 = 0
	offset_radians = vm.f32(offset_degrees * vm.f32(0.017453292))
	monster.call_command(60, angle) -- retail: the handler rejects 1 arguments
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = vm.f32(angle + offset_radians)
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	monster.call_command(61, angle, distance, x, y, z) -- retail: the handler rejects 5 arguments
	return x, y, z
end

--- Returns the absolute value of a number.
local function get_absolute_value(value: f32)
	if value < 0.0 then
		value = vm.f32(value * -1.0)
	end
	return value
end

--- Returns how many turn steps are needed to rotate from the current heading to a target heading.
local function get_turn_step_count(target_radians: f32, step_radians: f32)
	local unused_yaw: f32 = 0
	local angle_difference: f32 = 0
	local step_count: f32 = 0
	do
		local out1, _ = monster.get_pause_flags(unused_yaw) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		angle_difference = vm.bits_float(out1) or angle_difference
	end
	angle_difference = get_absolute_value(vm.f32(calc.radians_to_degrees(target_radians) - calc.radians_to_degrees(angle_difference)))
	if calc.radians_to_degrees(step_radians) == 0.0 then
		step_count = 0.0
	else
		step_count = vm.f32(vm.fdiv(angle_difference, calc.radians_to_degrees(step_radians)))
	end
	if step_count < 1.0 then
		step_count = 0.0
	end
	return step_count
end

--- Stops the Mimic's current turn at its present heading.
local function stop_turning()
	local unused_yaw: f32 = 0
	local current_yaw: f32 = 0
	do
		local out1, _ = monster.get_pause_flags(unused_yaw) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		current_yaw = vm.bits_float(out1) or current_yaw
	end
	monster.set_save_flag(current_yaw, 0)
end

--- Waits until the Mimic faces the target heading or the frame limit passes and returns the frames waited.
local function wait_for_turn(target_degrees: f32, turn_speed_degrees: f32, max_frames: f32)
	local unused_yaw: f32 = 0
	local current_yaw: f32 = 0
	local elapsed_frames: f32 = 0
	local expected_frames: f32 = 0
	target_degrees = calc.degrees_to_radians(target_degrees)
	if target_degrees > vm.f32(3.1415927) then
		target_degrees = vm.f32(target_degrees - vm.f32(6.2831855))
	end
	if target_degrees <= vm.f32(-3.1415927) then
		target_degrees = vm.f32(target_degrees + vm.f32(6.2831855))
	end
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	expected_frames = get_turn_step_count(target_degrees, turn_speed_degrees)
	elapsed_frames = 0.0
	while elapsed_frames < expected_frames do
		do
			local out1, _ = monster.get_pause_flags(unused_yaw) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
			current_yaw = vm.bits_float(out1) or current_yaw
		end
		if calc.compare_angles(target_degrees, current_yaw, turn_speed_degrees) == 0 then
			stop_turning()
			break
		elseif elapsed_frames >= max_frames then
			break
		else
			vm.wait()
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
	end
	monster.apply_reserved_image()
	return elapsed_frames
end

--- Starts a turn toward a heading in degrees and waits for it to finish.
local function turn_to_heading_and_wait(target_degrees: f32, turn_speed_degrees: f32)
	monster.set_save_flag(calc.degrees_to_radians(target_degrees), calc.degrees_to_radians(turn_speed_degrees))
	local _ = wait_for_turn(target_degrees, turn_speed_degrees, 360.0)
end

--- Waits until the target is within a distance, returning 1 when near, 2 when interrupted and 0 when time runs out.
local function wait_until_near_or_interrupted(near_distance: f32, max_frames: any)
	local frame: s32 = 0
	local player_status: s32 = 0
	local target_distance: f32 = 0
	frame = 0
	while frame < max_frames do
		player_status = monster.get_player_status_attribute() or player_status
		monster.call_command(59, target_distance) -- retail: the handler rejects 1 arguments
		if target_distance < near_distance then
			monster.apply_reserved_image()
			return 1
		end
		if player_status == 0 then
			vm.wait()
		else
			monster.apply_reserved_image()
			return 2
		end
		frame = vm.i32(frame + 1)
	end
	monster.apply_reserved_image()
	return 0
end

--- Turns toward a point offset around the target and walks to it until near or interrupted.
local function move_around_target(speed: f32, turn_speed_degrees: f32, offset_degrees: f32, distance: f32, near_distance: f32, max_frames: s32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local wait_result: s32 = 0
	approach_x, approach_y, approach_z = get_point_around_target(offset_degrees, distance, approach_x, approach_y, approach_z)
	monster.call_command(50, position_x, position_y, position_z) -- retail: the handler rejects 3 arguments
	offset_degrees = monster.keep_monster_loop_sound_4(approach_x, approach_y, approach_z) or offset_degrees
	turn_to_heading_and_wait(calc.radians_to_degrees(offset_degrees), turn_speed_degrees)
	monster.get_last_attack_type(approach_x, position_y, approach_z, speed, speed)
	wait_result = wait_until_near_or_interrupted(near_distance, max_frames)
	return wait_result
end

--- Starts a turn toward the given angle in radians.
local function start_turn_to_angle(target_radians: f32)
	local current_yaw: f32 = 0
	monster.call_command(60, current_yaw) -- retail: the handler rejects 1 arguments
	monster.set_save_flag(current_yaw, target_radians)
end

--- Turns toward the target at the given speed and waits for the turn to finish.
local function turn_toward_target_and_wait(turn_speed_degrees: f32)
	local current_yaw: f32 = 0
	start_turn_to_angle(calc.degrees_to_radians(turn_speed_degrees))
	monster.call_command(60, current_yaw) -- retail: the handler rejects 1 arguments
	local _ = wait_for_turn(calc.radians_to_degrees(current_yaw), turn_speed_degrees, 360.0)
end

--- Idles for up to a number of frames, stopping early once the target is within a distance.
local function idle_until_target_near(near_distance: f32, unused_angle: any, max_frames: s32)
	local target_distance: f32 = 0
	local unused_yaw: f32 = 0
	local unused_rotation: f32 = 0
	for frame = 0, max_frames - 1 do
		monster.get_pause_flags(unused_yaw) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		monster.call_command(59, target_distance) -- retail: the handler rejects 1 arguments
		monster.call_command(60, unused_rotation) -- retail: the handler rejects 1 arguments
		if target_distance < near_distance then
			return
		end
		vm.wait()
	end
end

--- Plays the idle animation while waiting for the target to come near.
local function play_idle_animation()
	monster.call_command(100, "あそび", -1, 6) -- retail: the handler rejects 3 arguments
	idle_until_target_near(40.0, 45.0, 35)
end

--- Randomly strafes around the target, plays the idle animation or waits in place.
local function strafe_or_idle()
	local roll: s32 = 0
	local offset_degrees: f32 = 0
	local distance: f32 = 0
	roll = monster.test_no_op(100) or roll
	if roll < 50 then
		roll = monster.test_no_op(100) or roll
		if roll < 50 then
			roll = monster.test_no_op(100) or roll
			offset_degrees = monster.get_vector_length(30.0) or offset_degrees
			distance = monster.get_vector_length(30.0) or distance
			distance = vm.f32(distance + 90.0)
			if roll < 50 then
				offset_degrees = vm.f32(-offset_degrees - 30.0)
			else
				offset_degrees = vm.f32(offset_degrees + 30.0)
			end
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			local _ = move_around_target(2.0, 3.0, offset_degrees, distance, 40.0, 30)
			turn_toward_target_and_wait(3.0)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
		else
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
			idle_until_target_near(40.0, 45.0, 30)
		end
	else
		play_idle_animation()
	end
end

--- Keeps strafing or idling until the target comes within range.
local function strafe_while_target_far()
	local target_distance: f32 = 0
	while true do
		vm.wait()
		monster.call_command(59, target_distance) -- retail: the handler rejects 1 arguments
		if target_distance < 175.0 then
			vm.wait()
			return
		end
		strafe_or_idle()
	end
end

--- Turns toward the target and walks toward it until near or the frame limit passes.
local function advance_on_target(speed: f32, turn_speed_degrees: f32, near_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_x: f32 = 0
	local target_z: f32 = 0
	do
		local out1, _, out3 = monster.get_status_ailments()
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	turn_toward_target_and_wait(turn_speed_degrees)
	monster.call_command(50, position_x, position_y, position_z) -- retail: the handler rejects 3 arguments
	monster.get_last_attack_type(target_x, position_y, target_z, speed, near_distance + speed)
	local _ = wait_until_near_or_interrupted(near_distance, max_frames)
	monster.apply_reserved_image()
end

--- Turns toward the target and plays the second attack motion, advancing as it strikes.
local function perform_attack_2()
	monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
	turn_toward_target_and_wait(3.0)
	monster.call_command(100, "攻撃２", -1, 2) -- retail: the handler rejects 3 arguments
	timer.wait_frames(8)
	advance_on_target(4.5, 6.0, 1.0, 17)
	timer.wait_frames(9)
	monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	timer.wait_frames(9)
end

--- Picks a random advance, circling move or attack for a target at mid range.
local function choose_mid_range_move()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	monster.call_command(59, target_distance) -- retail: the handler rejects 1 arguments
	roll = monster.test_no_op(100) or roll
	if roll < 80 then
		roll = monster.test_no_op(100) or roll
		if roll < 30 then
			roll = monster.test_no_op(100) or roll
			if roll < 80 then
				monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
				advance_on_target(2.0, 3.0, 40.0, 60)
				monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
			else
				monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
				idle_until_target_near(40.0, 45.0, 75)
			end
		else
			roll = monster.test_no_op(100) or roll
			if roll < 50 then
				strafe_degrees = -30.0
			else
				strafe_degrees = 30.0
			end
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			turn_toward_target_and_wait(3.0)
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			move_around_target(2.0, 3.0, strafe_degrees, target_distance, 90.0, 45)
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			turn_toward_target_and_wait(3.0)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
			idle_until_target_near(40.0, 45.0, 30)
		end
	else
		monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
		turn_toward_target_and_wait(3.0)
		perform_attack_2()
		monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	end
end

--- Walks to a point offset around the target until near or the frame limit passes.
local function strafe_around_target(speed: f32, offset_degrees: f32, near_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local target_distance: f32 = 0
	monster.call_command(59, target_distance) -- retail: the handler rejects 1 arguments
	approach_x, approach_y, approach_z = get_point_around_target(offset_degrees, target_distance, approach_x, approach_y, approach_z)
	monster.call_command(50, position_x, position_y, position_z) -- retail: the handler rejects 3 arguments
	monster.get_last_attack_type(approach_x, position_y, approach_z, speed, speed)
	local _ = wait_until_near_or_interrupted(near_distance, max_frames)
end

--- Picks a random attack, advance or circling move for a target at close range.
local function choose_close_range_move()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	monster.call_command(59, target_distance) -- retail: the handler rejects 1 arguments
	roll = monster.test_no_op(100) or roll
	if roll < 60 then
		perform_attack_2()
	else
		roll = monster.test_no_op(100) or roll
		if roll < 55 then
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			advance_on_target(2.0, 3.0, 40.0, 90)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
		else
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			turn_toward_target_and_wait(3.0)
			roll = monster.test_no_op(100) or roll
			if roll < 50 then
				strafe_degrees = -30.0
				monster.call_command(100, "歩き左", -1, 0) -- retail: the handler rejects 3 arguments
			else
				strafe_degrees = 30.0
				monster.call_command(100, "歩き右", -1, 0) -- retail: the handler rejects 3 arguments
			end
			strafe_around_target(2.0, strafe_degrees, 3.0, 60)
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			turn_toward_target_and_wait(3.0)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
			idle_until_target_near(40.0, 45.0, 30)
		end
	end
end

--- Turns toward the target and lunges forward with the first attack motion.
local function perform_attack_1()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local unused_yaw: f32 = 0
	local yaw: f32 = 0
	monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
	turn_toward_target_and_wait(6.0)
	monster.call_command(100, "攻撃１", -1, 2) -- retail: the handler rejects 3 arguments
	timer.wait_frames(12)
	monster.call_command(50, position_x, position_y, position_z) -- retail: the handler rejects 3 arguments
	do
		local out1, _ = monster.get_pause_flags(unused_yaw) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		yaw = vm.bits_float(out1) or yaw
	end
	position_x = vm.f32(position_x + vm.f32(100.0 * vm.sin(yaw)))
	position_z = vm.f32(position_z + vm.f32(100.0 * vm.cos(yaw)))
	monster.get_last_attack_type(position_x, position_y, position_z, 2.8, 2.8)
	timer.wait_frames(28)
	monster.apply_reserved_image()
	monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	timer.wait_frames(9)
end

--- Waits each frame until the current motion has finished.
local function wait_until_motion_finished()
	local is_finished: s32 = 0
	while true do
		vm.wait()
		monster.call_command(101, is_finished) -- retail: the handler rejects 1 arguments
		if is_finished ~= 0 then
			return
		end
	end
end

--- Turns to the target and steps sideways to dodge.
local function dodge_sideways(speed: f32)
	local roll: s32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local target_distance: f32 = 0
	local offset_degrees: f32 = 0
	monster.call_command(59, target_distance) -- retail: the handler rejects 1 arguments
	monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
	turn_toward_target_and_wait(6.0)
	roll = monster.test_no_op(100) or roll
	if roll < 50 then
		monster.set_camera_mode()
		monster.call_command(100, "歩き右", -1, 6) -- retail: the handler rejects 3 arguments
		offset_degrees = 30.0
	else
		monster.set_camera_mode()
		monster.call_command(100, "歩き左", -1, 6) -- retail: the handler rejects 3 arguments
		offset_degrees = -30.0
	end
	approach_x, approach_y, approach_z = get_point_around_target(offset_degrees, target_distance, approach_x, approach_y, approach_z)
	idle_until_target_near(40.0, 45.0, 7)
	monster.get_last_attack_type(approach_x, ground_y, approach_z, speed, speed)
	monster.call_command(67, 32, 1) -- retail: command 67 is not registered
	idle_until_target_near(40.0, 45.0, 9)
	monster.call_command(67, 32, 0) -- retail: command 67 is not registered
	monster.apply_reserved_image()
	wait_until_motion_finished()
end

--- Steps backward away from the target to dodge.
local function retreat_backward(speed: f32)
	local retreat_x: f32 = 0
	local retreat_y: f32 = 0
	local retreat_z: f32 = 0
	local retreat_distance: f32 = 0
	local extra_distance: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
	turn_toward_target_and_wait(6.0)
	monster.call_command(67, 32, 1) -- retail: command 67 is not registered
	monster.call_command(59, retreat_distance) -- retail: the handler rejects 1 arguments
	do
		local _, out2 = monster.get_event_info_3(retreat_x) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		retreat_z = out2 or retreat_z
	end
	extra_distance = monster.get_vector_length(10.0) or extra_distance
	retreat_distance = vm.f32(retreat_distance + vm.f32(40.0 + extra_distance))
	retreat_x, retreat_y, retreat_z = get_point_around_target(0.0, retreat_distance, retreat_x, retreat_y, retreat_z)
	monster.call_command(100, "歩き後", -1, 6) -- retail: the handler rejects 3 arguments
	timer.wait_frames(8)
	monster.call_command(50, position_x, position_y, position_z) -- retail: the handler rejects 3 arguments
	monster.get_last_attack_type(retreat_x, position_y, retreat_z, speed, speed + 1.0)
	timer.wait_frames(8)
	monster.call_command(67, 32, 0) -- retail: command 67 is not registered
	monster.apply_reserved_image()
	wait_until_motion_finished()
	monster.apply_reserved_image()
	-- retail: monster.get_monster_yaw("立ち", -1) does nothing, since its handler ignores a string as argument 1
end

--- Picks a random attack, dodge or circling move for a target at far range.
local function choose_far_range_move()
	local roll: s32 = 0
	local strafe_degrees: f32 = 0
	monster.get_object_position()
	roll = monster.test_no_op(100) or roll
	if roll < 50 then
		perform_attack_1()
	else
		roll = monster.test_no_op(100) or roll
		if roll < 40 then
			roll = monster.test_no_op(100) or roll
			if roll < 50 then
				dodge_sideways(3.0)
			else
				retreat_backward(3.0)
			end
		else
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			turn_toward_target_and_wait(3.0)
			roll = monster.test_no_op(100) or roll
			if roll < 50 then
				strafe_degrees = -30.0
				monster.call_command(100, "歩き左", -1, 0) -- retail: the handler rejects 3 arguments
			else
				strafe_degrees = 30.0
				monster.call_command(100, "歩き右", -1, 0) -- retail: the handler rejects 3 arguments
			end
			strafe_around_target(2.0, strafe_degrees, 3.0, 45)
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			turn_toward_target_and_wait(3.0)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
		end
	end
end

--- Loops choosing moves by target distance until the target leaves range or rage hits run out.
local function fight_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		monster.call_command(59, target_distance) -- retail: the handler rejects 1 arguments
		if target_distance > 175.0 then
			vm.wait()
			return
		end
		monster.call_command(157, rage_hits_left) -- retail: command 157 is not registered
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		monster.call_command(159, priority) -- retail: command 159 is not registered
		if priority > 1 then
			strafe_or_idle()
			continue
		end
		if target_distance < 175.0 and target_distance >= 140.0 then
			choose_mid_range_move()
		elseif target_distance < 140.0 and target_distance >= 90.0 then
			choose_close_range_move()
		else
			choose_far_range_move()
		end
	end
end

--- Clears the pending motion and stops turning before the damage reaction.
local function begin_damage_reaction()
	monster.apply_reserved_image()
	stop_turning()
end

--- Locks the Mimic's facing to its current heading.
local function hold_current_facing()
	local yaw: f32 = 0
	monster.call_command(60, yaw) -- retail: the handler rejects 1 arguments
	monster.is_save_flag_set(0.0, yaw, 0.0)
end

--- Stops turning and locks the Mimic's heading before the knockdown reaction.
local function begin_knockdown_reaction()
	monster.apply_reserved_image()
	stop_turning()
	hold_current_facing()
	vm.wait()
end

--- Clears the pending motion and stops turning before the guard reaction.
local function begin_guard_reaction()
	monster.apply_reserved_image()
	stop_turning()
end

--- Clears the pending motion, stops turning and ends any throw before the death animation.
local function begin_death()
	monster.apply_reserved_image()
	stop_turning()
	monster.end_throw()
end

--- Spawns the death effects and idles forever.
local function play_death_effects()
	monster.call_command(154) -- retail: command 154 is not registered
	while true do
		vm.wait()
	end
end

--- Clears the pending motion and pauses briefly before the landing recovery.
local function begin_landing()
	monster.apply_reserved_image()
	monster.call_command(155) -- retail: command 155 is not registered
	timer.wait_frames(10)
	monster.set_camera_mode()
end

--- Applies the stun attributes and resets the camera mode.
local function begin_stun()
	monster.call_command(152, 1, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(152, 2, 1) -- retail: the handler rejects 2 arguments
	monster.set_camera_mode()
end

--- Waits each frame until the Mimic's current movement has finished.
local function wait_until_move_finished()
	local steps_remaining: s32 = 0
	monster.call_command(79) -- retail: the handler rejects 0 arguments
	steps_remaining = monster.move_toward_position() or steps_remaining
	while steps_remaining > 0 do
		steps_remaining = monster.move_toward_position() or steps_remaining
		vm.wait()
	end
end

--- Waits for movement to finish and clears the stun attributes.
local function end_stun()
	-- retail: monster.get_monster_yaw("気絶", -1) does nothing, since its handler ignores a string as argument 1
	wait_until_move_finished()
	monster.call_command(152, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(152, 2, 0) -- retail: the handler rejects 2 arguments
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the Mimic's attack hits and records its spawn position when it is placed.
function script.init()
	monster.get_no_damage_hit_count("通常攻撃", 5.0, "攻撃１", 0.382, 0.697, 0)
	monster.get_no_damage_hit_count("吹っ飛び攻撃", 6.0, "攻撃２", 0.522, 0.652, 1)
	record_spawn_position()
end

--- Runs the Mimic's normal combat behaviour.
function script.loop()
	local rage_hits_left: s32 = 0
	monster.call_command(152, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(152, 2, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(151, 0) -- retail: the handler rejects 1 arguments
	monster.call_command(157, rage_hits_left) -- retail: command 157 is not registered
	while true do
		strafe_while_target_far()
		fight_target()
		vm.wait()
	end
end

--- Plays the Mimic's stagger reaction to a normal hit.
function script.on_damage()
	begin_damage_reaction()
	monster.call_command(100, "ダメージ", -1, 6) -- retail: the handler rejects 3 arguments
	monster.start_knockback(4.0, 0.0, 3)
	wait_until_motion_finished()
	timer.wait_frames(12)
	monster.call_command(100, "立ち") -- retail: the handler rejects 1 arguments
	state.do_nothing()
end

--- Handles the Mimic being knocked down.
function script.on_knockdown()
	begin_knockdown_reaction()
	monster.call_command(100, "吹っ飛び", -1, 6) -- retail: the handler rejects 3 arguments
	monster.start_knockback(3.0, 0.05, 20)
	wait_until_motion_finished()
	monster.call_command(151, 1) -- retail: the handler rejects 1 arguments
	timer.wait_frames(30)
	monster.call_command(151, 0) -- retail: the handler rejects 1 arguments
	monster.call_command(100, "起き上がり", -1, 6) -- retail: the handler rejects 3 arguments
	wait_until_motion_finished()
	monster.call_command(100, "立ち") -- retail: the handler rejects 1 arguments
	state.do_nothing()
end

--- Handles the Mimic guarding against a hit.
function script.on_guard()
	local roll: s32 = 0
	begin_guard_reaction()
	roll = monster.test_no_op(100) or roll
	if roll < 65 then
		monster.set_camera_mode()
		monster.call_command(100, "ガード入り", -1, 6) -- retail: the handler rejects 3 arguments
		wait_until_motion_finished()
		monster.call_command(100, "ガード", -1, 0) -- retail: the handler rejects 3 arguments
		monster.start_knockback(3.0, 0.0, 2)
		timer.wait_frames(8)
		monster.call_command(100, "ガード戻り", -1, 6) -- retail: the handler rejects 3 arguments
		wait_until_motion_finished()
		monster.call_command(100, "立ち") -- retail: the handler rejects 1 arguments
	else
		monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
		turn_toward_target_and_wait(15.0)
		monster.set_camera_mode()
		monster.call_command(100, "ガード入り", -1, 6) -- retail: the handler rejects 3 arguments
		wait_until_motion_finished()
		monster.call_command(100, "ガード", -1, 0) -- retail: the handler rejects 3 arguments
		monster.start_knockback(3.0, 0.0, 2)
		timer.wait_frames(60)
		monster.call_command(100, "ガード戻り", -1, 6) -- retail: the handler rejects 3 arguments
		wait_until_motion_finished()
		monster.call_command(100, "立ち") -- retail: the handler rejects 1 arguments
	end
	state.do_nothing()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	state.do_nothing()
	retreat_backward(3.0)
	monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	state.do_nothing()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	state.do_nothing()
	dodge_sideways(3.0)
	monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	state.do_nothing()
end

--- Plays the Mimic's death.
function script.on_death()
	begin_death()
	monster.call_command(100, "死に", -1, 2) -- retail: the handler rejects 3 arguments
	wait_until_motion_finished()
	monster.call_command(154) -- retail: command 154 is not registered
	while true do
		vm.wait()
	end
	play_death_effects()
end

--- Handles the Mimic being caught and lifted.
function script.on_caught()
	monster.call_command(100, "じたばた", -1, 4) -- retail: the handler rejects 3 arguments
	while true do
		vm.wait()
	end
end

--- Recovers the Mimic after it lands from a throw.
function script.on_land()
	begin_landing()
	monster.apply_reserved_image()
	monster.call_command(155) -- retail: command 155 is not registered
	timer.wait_frames(10)
	monster.set_camera_mode()
	monster.call_command(100, "起き上がり", -1, 6) -- retail: the handler rejects 3 arguments
	wait_until_motion_finished()
	state.do_nothing_hook()
	return 1
end

--- Stuns the Mimic until it recovers.
function script.on_stun()
	begin_stun()
	monster.call_command(100, "吹っ飛び", -1, 6) -- retail: the handler rejects 3 arguments
	wait_until_motion_finished()
	monster.call_command(100, "起き上がり", -1, 6) -- retail: the handler rejects 3 arguments
	wait_until_motion_finished()
	end_stun()
end

return script
