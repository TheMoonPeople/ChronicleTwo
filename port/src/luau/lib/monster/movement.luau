--!strict
--- Moving, turning, chasing and stepping helpers for monster scripts.

local vm = require("@lib/vm")
local calc = vm.module("@lib/monster/calc")
local motion = vm.module("@lib/monster/motion")
local reaction = vm.module("@lib/monster/reaction")
local sense = vm.module("@lib/monster/sense")
local timer = vm.module("@lib/monster/timer")

local movement = {}

--- Faces the target and steps toward its position, stopping on arrival or when an obstacle is hit.
function movement.approach_target(speed: f32, turn_speed_degrees: f32, arrival_distance: f32, height_offset: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_angle: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_y: f32 = 0
	local distance: f32 = 0
	local height_above_ground: f32 = 0
	local obstacle_result: s32 = 0
	distance = monster.get_target_distance() or distance
	movement.turn_toward_target_until_facing_updating_lighting(turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_y = out3 or position_y
	end
	ground_y = sense.get_ground_height(ground_y)
	target_y = vm.f32(ground_y + height_offset)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, position_x, position_y, position_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, speed)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	for i = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		height_above_ground = monster.get_height_above_ground_at(position_x, position_y, position_z) or height_above_ground
		if height_above_ground >= 30.0 or height_above_ground <= 0.0 then
			position_y = vm.f32(position_y - step_y)
			step_y = 0.0
		end
		distance = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance
		if distance < vm.f32(speed + arrival_distance) then
			return
		end
		obstacle_result = sense.check_flight_destination(position_x, position_y, position_z, speed, facing_angle)
		if obstacle_result ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(position_x, position_y, position_z)
		timer.wait_frame()
	end
end

--- Turns by a random angle, then advances along the new facing by a random distance.
function movement.approach_with_random_turn(
	speed: f32,
	turn_speed_degrees: f32,
	base_distance: f32,
	turn_range_degrees: f32,
	distance_range: f32,
	arrival_distance: f32,
	height_offset: f32,
	max_frames: s32
)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_angle: f32 = 0
	local distance: f32 = 0
	local turn_degrees: f32 = 0
	distance = monster.get_random_whole_number(distance_range) or distance
	turn_degrees = monster.get_random_whole_number(turn_range_degrees) or turn_degrees
	distance = vm.f32(distance + base_distance)
	movement.turn_to_heading(turn_degrees, turn_speed_degrees)
	movement.stop_turning()
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
	position_x = vm.f32(position_x + vm.f32(vm.sin(facing_angle) * distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(facing_angle) * distance))
	local _ = movement.move_toward_position(position_x, position_y, position_z, speed, arrival_distance, height_offset, max_frames)
end

--- Turns to a random heading, then runs after the target if it comes in front of the monster.
function movement.chase_if_target_ahead()
	local detected: s32 = 0
	local turn_angle_degrees: f32 = 0
	turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
	monster.set_motion("歩き", -1, 0)
	movement.turn_to_heading(turn_angle_degrees, vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_updating_lighting(9)
	detected = sense.wait_until_target_in_front_updating_lighting(190.0, 45.0, 45)
	if detected == 1 then
		monster.set_motion("走り", -1, 0)
		movement.chase_target_stopping_at_obstacle(3.0, vm.f32(4.8), 30.0, 5.0, 0, 150)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Turns toward the target and then repeatedly steps toward it until within a stop distance or out of frames.
function movement.chase_target(speed: f32, turn_speed_degrees: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local frame: s32 = 0
	movement.turn_toward_target_and_wait(turn_speed_degrees)
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed_degrees > vm.f32(3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees - vm.f32(6.2831855))
	end
	if turn_speed_degrees <= vm.f32(-3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees + vm.f32(6.2831855))
	end
	frame = 0
	while frame < max_frames do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed_degrees)
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.get_rotation()
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_target_position()
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(destination_x, destination_y, destination_z, position_x, position_y, position_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(destination_x, destination_y, destination_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(destination_x, destination_y, destination_z, speed + stop_distance)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(destination_x, destination_y, destination_z, position_x, position_y, position_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		monster.move_toward_position(destination_x, position_y - 20.0, destination_z, speed, speed)
		timer.wait_one_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Turns toward the target, then steps toward it along the ground until it is near, blocked or the step limit is reached.
function movement.chase_target_after_turning(step_length: f32, turn_speed_degrees: f32, stop_margin: f32, height_offset: f32, max_steps: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local heading: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_y: f32 = 0
	local target_distance: f32 = 0
	local ground_height: f32 = 0
	local obstacle_result: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	movement.turn_toward_target_and_wait(turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_y = out3 or position_y
	end
	ground_y = sense.get_ground_height(ground_y)
	target_y = vm.f32(ground_y + height_offset)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, position_x, position_y, position_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_length)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	for i = 0, max_steps - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		ground_height = monster.get_height_above_ground_at(position_x, position_y, position_z) or ground_height
		if ground_height >= 25.0 or ground_height <= 0.0 then
			position_y = vm.f32(position_y - step_y)
			step_y = 0.0
		end
		target_distance = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or target_distance
		if target_distance < vm.f32(step_length + stop_margin) then
			return
		end
		obstacle_result = sense.check_flight_destination(position_x, position_y, position_z, step_length, heading)
		if obstacle_result ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(position_x, position_y, position_z)
		timer.wait_one_frame()
	end
end

--- Turns toward the target and moves toward it frame by frame until it is within the stop distance or the frame limit passes.
function movement.chase_target_by_moving(move_speed: f32, turn_speed: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local goal_x: f32 = 0
	local goal_y: f32 = 0
	local goal_z: f32 = 0
	local frame: s32 = 0
	movement.turn_toward_target_until_facing(turn_speed)
	turn_speed = calc.degrees_to_radians(turn_speed)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	frame = 0
	while frame < max_frames do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.get_rotation()
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_target_position()
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(goal_x, goal_y, goal_z, position_x, position_y, position_z)
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(goal_x, goal_y, goal_z)
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(goal_x, goal_y, goal_z, move_speed + stop_distance)
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(goal_x, goal_y, goal_z, position_x, position_y, position_z)
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		monster.move_toward_position(goal_x, position_y - 20.0, goal_z, move_speed, move_speed)
		timer.wait_frame_with_reaction()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Chases the target frame by frame, returning -1 when it is near, -2 when the way is blocked or the number of frames spent when the limit passes.
function movement.chase_target_checking_clearance(move_speed: f32, turn_speed: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local goal_x: f32 = 0
	local goal_y: f32 = 0
	local goal_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local origin_x: f32 = 0
	local origin_y: f32 = 0
	local origin_z: f32 = 0
	local probe_x: f32 = 0
	local probe_y: f32 = 0
	local probe_z: f32 = 0
	local clear_distance: f32 = 0
	local frame: s32 = 0
	movement.turn_toward_target_and_wait_guarded(turn_speed)
	turn_speed = calc.degrees_to_radians(turn_speed)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	frame = 0
	while frame < max_frames do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return -1
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			origin_x = out1 or origin_x
			origin_y = out2 or origin_y
			origin_z = out3 or origin_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		origin_y = vm.f32(origin_y + 25.0)
		probe_y = vm.f32(probe_y + 25.0)
		do
			local out1, out2, out3 = monster.subtract_vectors(probe_x, probe_y, probe_z, origin_x, origin_y, origin_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(probe_x, probe_y, probe_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(probe_x, probe_y, probe_z, move_speed + stop_distance)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(probe_x, probe_y, probe_z, origin_x, origin_y, origin_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		clear_distance = monster.get_clear_distance_between(origin_x, origin_y, origin_z, probe_x, probe_y, probe_z) or clear_distance
		if clear_distance < vm.f32(vm.f32(move_speed + stop_distance) - 1.0) then
			movement.stop_turning()
			monster.stop_moving()
			return -2
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.get_rotation()
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_target_position()
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(goal_x, goal_y, goal_z, position_x, position_y, position_z)
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(goal_x, goal_y, goal_z)
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(goal_x, goal_y, goal_z, move_speed * 10.0)
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(goal_x, goal_y, goal_z, position_x, position_y, position_z)
			goal_x = out1 or goal_x
			goal_y = out2 or goal_y
			goal_z = out3 or goal_z
		end
		monster.move_toward_position(goal_x, position_y - 20.0, goal_z, move_speed, move_speed)
		reaction.update_and_wait_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
	return frame
end

--- Turns toward the target and moves straight at its position each frame until within a stop distance or out of frames, without first waiting to face it.
function movement.chase_target_directly(speed: f32, turn_speed_degrees: f32, stop_distance: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local frame: s32 = 0
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed_degrees > vm.f32(3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees - vm.f32(6.2831855))
	end
	if turn_speed_degrees <= vm.f32(-3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees + vm.f32(6.2831855))
	end
	frame = 0
	while frame < max_frames do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed_degrees)
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		monster.get_rotation()
		monster.move_toward_position(target_x, target_y - 20.0, target_z, speed, speed)
		timer.wait_one_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Turns toward the target and steps toward it while updating the guard state, returning -1 when within the stop distance.
function movement.chase_target_guarded(speed: f32, turn_speed_degrees: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local frame: s32 = 0
	movement.turn_toward_target_and_wait_guarded(turn_speed_degrees)
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed_degrees > vm.f32(3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees - vm.f32(6.2831855))
	end
	if turn_speed_degrees <= vm.f32(-3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees + vm.f32(6.2831855))
	end
	frame = 0
	while frame < max_frames do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return -1
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed_degrees)
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.get_rotation()
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_target_position()
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(destination_x, destination_y, destination_z, position_x, position_y, position_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(destination_x, destination_y, destination_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(destination_x, destination_y, destination_z, speed + stop_distance)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(destination_x, destination_y, destination_z, position_x, position_y, position_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		monster.move_toward_position(destination_x, position_y - 20.0, destination_z, speed, speed)
		reaction.update_and_wait_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
	return frame
end

--- Steps the monster toward the target's position each frame, optionally rotating to face its movement, until it arrives or hits an obstacle. It stops at obstacles.
function movement.chase_target_stopping_at_obstacle(speed: f32, unused_turn_speed: any, arrival_distance: f32, height_offset: f32, face_movement: s32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local distance: f32 = 0
	local ground_y: f32 = 0
	local height_above_ground: f32 = 0
	local obstacle_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	for i = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		ground_y = sense.get_ground_height(ground_y)
		target_y = vm.f32(ground_y + height_offset)
		do
			local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, position_x, position_y, position_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, speed)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = monster.get_rotation_toward_6(position_x, position_y, position_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		height_above_ground = monster.get_height_above_ground_at(position_x, position_y, position_z) or height_above_ground
		if height_above_ground >= 30.0 or height_above_ground <= 0.0 then
			position_y = vm.f32(position_y - step_y)
			step_y = 0.0
		end
		distance = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance
		if distance < vm.f32(speed + arrival_distance) then
			return
		end
		obstacle_result = sense.check_flight_destination(position_x, position_y, position_z, speed, rotation_y)
		if obstacle_result ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(position_x, position_y, position_z)
		if face_movement ~= 0 then
			monster.set_rotation(rotation_x, rotation_y, rotation_z)
		else
			monster.set_rotation(0.0, rotation_y, 0.0)
		end
		timer.wait_frame()
	end
end

--- Steps toward the moving target while rotating to face it, until it is near, blocked or the step limit is reached.
function movement.chase_target_with_rotation(step_length: f32, unused: any, stop_margin: f32, height_offset: f32, tilt_toward_target: s32, max_steps: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local target_distance: f32 = 0
	local ground_y: f32 = 0
	local ground_height: f32 = 0
	local obstacle_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	for i = 0, max_steps - 1 do
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		ground_y = sense.get_ground_height(ground_y)
		target_y = vm.f32(ground_y + height_offset)
		do
			local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, position_x, position_y, position_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_length)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = monster.get_rotation_toward_6(position_x, position_y, position_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		ground_height = monster.get_height_above_ground_at(position_x, position_y, position_z) or ground_height
		if ground_height >= 25.0 or ground_height <= 0.0 then
			position_y = vm.f32(position_y - step_y)
			step_y = 0.0
		end
		target_distance = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or target_distance
		if target_distance < vm.f32(step_length + stop_margin) then
			return
		end
		obstacle_result = sense.check_flight_destination(position_x, position_y, position_z, step_length, rotation_y)
		if obstacle_result ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(position_x, position_y, position_z)
		if tilt_toward_target ~= 0 then
			monster.set_rotation(rotation_x, rotation_y, rotation_z)
		else
			monster.set_rotation(0.0, rotation_y, 0.0)
		end
		timer.wait_one_frame()
	end
end

--- Randomly stands idle, walks to a point near the target, or walks and plays a few idle motions.
function movement.choose_idle_action()
	local roll: s32 = 0
	local offset_degrees: f32 = 0
	local point_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(49.0, 90.0, 30)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			offset_degrees = monster.get_random_whole_number(30.0) or offset_degrees
			point_distance = monster.get_random_whole_number(30.0) or point_distance
			point_distance = vm.f32(point_distance + 85.0)
			if roll < 50 then
				offset_degrees = vm.f32(-offset_degrees - 30.0)
			else
				offset_degrees = vm.f32(offset_degrees + 30.0)
			end
			monster.set_motion("歩き", 0.6, 0)
			local _ = movement.walk_around_target(vm.f32(2.4), 4.0, offset_degrees, point_distance, 49.0, 40)
			movement.turn_toward_target_and_wait(4.0)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			roll = monster.get_random(2) or roll
			movement.play_idle_wander(roll)
		end
	end
end

--- Moves toward a point at an angle offset around the target, shortened to the clear distance, and waits until it arrives.
function movement.circle_target(speed: f32, angle_degrees: f32, arrival_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local distance: f32 = 0
	distance = monster.get_target_distance() or distance
	point_x, point_y, point_z = movement.get_approach_point(angle_degrees, distance, point_x, point_y, point_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(point_x, point_y, point_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
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
	distance = monster.get_clear_distance(100.0, 0.0) or distance
	if distance < 100.0 then
		point_x = vm.f32(position_x + vm.f32(direction_x * distance))
		point_y = position_y
		point_z = vm.f32(position_z + vm.f32(direction_z * distance))
		distance = vm.f32(distance - arrival_distance)
		if distance < arrival_distance then
			return
		end
	end
	monster.move_toward_position(point_x, position_y, point_z, speed, speed)
	local _ = movement.wait_until_arrived_unguarded(arrival_distance, max_frames)
	monster.stop_moving()
end

--- Faces the target, then dashes forward by the target's distance and waits until the monster arrives or gets close.
function movement.dash_toward_target(speed: f32, turn_speed_degrees: f32, arrival_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local dash_x: f32 = 0
	local dash_z: f32 = 0
	local facing_angle: f32 = 0
	local target_distance: f32 = 0
	local clear_distance: f32 = 0
	movement.turn_toward_target_until_facing_updating_lighting(turn_speed_degrees)
	movement.stop_turning()
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	target_distance = monster.get_target_distance() or target_distance
	clear_distance = monster.get_clear_distance(speed + arrival_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(speed + arrival_distance) then
		return
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	dash_x = vm.f32(position_x + vm.f32(vm.sin(facing_angle) * target_distance))
	dash_z = vm.f32(position_z + vm.f32(vm.cos(facing_angle) * target_distance))
	monster.move_toward_position(dash_x, position_y - 20.0, dash_z, speed, arrival_distance + speed)
	local _ = movement.wait_for_move(arrival_distance, max_frames)
	monster.stop_moving()
end

--- Sets the monster's rotation to face the target immediately.
function movement.face_target_instantly()
	local target_angle: f32 = 0
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
end

--- Sets the monster's rotation to face the target immediately for monsters using the alternative command set.
function movement.face_target_instantly_variant()
	local target_angle: f32 = 0
	monster.call_command(75, target_angle) -- retail: the handler rejects 1 arguments
	monster.call_command(68, 0.0, target_angle, 0.0) -- retail: command 68 is not registered
end

--- Moves the monster toward the target position in fixed steps, stopping when close or blocked.
function movement.fly_toward_target(step_length: f32, unused: any, stop_margin: f32, height_offset: f32, should_pitch: s32, max_steps: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local facing_x: f32 = 0
	local facing_y: f32 = 0
	local facing_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local distance: f32 = 0
	local target_height: f32 = 0
	local ground_height: f32 = 0
	local blocked: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	for i = 0, max_steps - 1 do
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		target_height = sense.get_ground_height(target_height)
		target_y = vm.f32(target_height + height_offset)
		do
			local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, x, y, z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_length)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(x, y, z, step_x, step_y, step_z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.get_rotation_toward_6(x, y, z)
			facing_x = out1 or facing_x
			facing_y = out2 or facing_y
			facing_z = out3 or facing_z
		end
		ground_height = monster.get_height_above_ground_at(x, y, z) or ground_height
		if ground_height >= 50.0 or ground_height <= 0.0 then
			y = vm.f32(y - step_y)
			step_y = 0.0
		end
		distance = monster.get_distance_between(x, y, z, target_x, target_y, target_z) or distance
		if distance < vm.f32(step_length + stop_margin) then
			return
		end
		blocked = sense.check_flight_destination(x, y, z, step_length, facing_y)
		if blocked ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(x, y, z)
		if should_pitch ~= 0 then
			monster.set_rotation(facing_x, facing_y, facing_z)
		else
			monster.set_rotation(0.0, facing_y, 0.0)
		end
		timer.wait_one_frame()
	end
end

--- Returns the constant acceleration that covers a distance in a duration from an initial speed, or 0 when the duration is 0.
function movement.get_acceleration(distance: f32, initial_speed: f32, duration: f32, acceleration: f32)
	if duration == 0.0 then
		acceleration = 0.0
	else
		acceleration = vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(distance - vm.f32(initial_speed * duration)) * 2.0), duration)), duration))
	end
	return acceleration
end

--- Returns a point at a distance from the target, rotated by an angle around it from the line toward the monster.
function movement.get_approach_point(offset_degrees: f32, distance: f32, x: f32, y: f32, z: f32)
	local offset_angle: f32 = 0
	local point_angle: f32 = 0
	offset_angle = vm.f32(offset_degrees * vm.f32(0.017453292))
	point_angle = monster.get_target_angle() or point_angle
	point_angle = vm.f32(point_angle - vm.f32(3.1415927))
	point_angle = vm.f32(point_angle + offset_angle)
	if point_angle > vm.f32(3.1415927) then
		point_angle = vm.f32(point_angle - vm.f32(6.2831855))
	end
	if point_angle <= vm.f32(-3.1415927) then
		point_angle = vm.f32(point_angle + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_point_around_target(point_angle, distance)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	return x, y, z
end

--- Returns the point at a distance from the target in a direction rotated by an angle in degrees from the line running from the target back toward the monster.
function movement.get_point_around_target(angle_degrees: f32, distance: f32, x: f32, y: f32, z: f32)
	local angle_offset: f32 = 0
	local angle: f32 = 0
	angle_offset = vm.f32(angle_degrees * vm.f32(0.017453292))
	angle = monster.get_target_angle() or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = vm.f32(angle + angle_offset)
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_point_around_target(angle, distance)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	return x, y, z
end

--- Returns a point at a distance from the target, rotated by an angle around it from the line toward the monster.
function movement.get_point_near_target(offset_degrees: s32, distance: f32, x: f32, y: f32, z: f32)
	local offset_angle: f32 = 0
	local point_angle: f32 = 0
	offset_angle = vm.f32(offset_degrees * vm.f32(0.017453292))
	point_angle = monster.get_target_angle() or point_angle
	point_angle = vm.f32(point_angle - vm.f32(3.1415927))
	point_angle = vm.f32(point_angle + offset_angle)
	if point_angle > vm.f32(3.1415927) then
		point_angle = vm.f32(point_angle - vm.f32(6.2831855))
	end
	if point_angle <= vm.f32(-3.1415927) then
		point_angle = vm.f32(point_angle + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_point_around_target(point_angle, distance)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	return x, y, z
end

--- Returns the number of frames needed to reach a position at a given speed.
function movement.get_travel_frames(result: f32, target_x: f32, target_y: f32, target_z: f32, speed: f32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local distance: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	distance = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance
	result = vm.f32(vm.fdiv(distance, speed))
	return result
end

--- Holds the monster's current facing angle for monsters using the alternative command set.
function movement.hold_current_facing_variant()
	local rotation_x: f32 = 0
	local current_angle: f32 = 0
	local rotation_z: f32 = 0
	monster.call_command(67, rotation_x, current_angle, rotation_z) -- retail: command 67 is not registered
	monster.call_command(69, current_angle, 0) -- retail: command 69 is not registered
end

--- Raises the monster to one unit above the ground when it is level with or below it.
function movement.lift_above_ground()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local height: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	height = monster.get_height_above_ground() or height
	if height < 0.0 then
		height = vm.f32(height * -1.0)
		height = vm.f32(height + 1.0)
		position_y = vm.f32(position_y + height)
	end
	if height == 0.0 then
		position_y = vm.f32(position_y + 1.0)
	end
	monster.set_position(position_x, position_y, position_z)
end

--- Moves forward a distance along a heading and waits for the move to end or the target to be near.
function movement.move_along_heading(move_speed: f32, heading_degrees: f32, distance: f32, near_distance: f32, max_frames: s32)
	local position_y: f32 = 0
	local goal_x: f32 = 0
	local goal_y: f32 = 0
	local goal_z: f32 = 0
	if distance < move_speed then
		distance = vm.f32(move_speed + 1.0)
	end
	heading_degrees = calc.degrees_to_radians(heading_degrees)
	if heading_degrees > vm.f32(3.1415927) then
		heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
	end
	if heading_degrees <= vm.f32(-3.1415927) then
		heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		goal_x = out1 or goal_x
		goal_y = out2 or goal_y
		goal_z = out3 or goal_z
	end
	goal_x = vm.f32(goal_x + vm.f32(vm.sin(heading_degrees) * distance))
	goal_z = vm.f32(goal_z + vm.f32(vm.cos(heading_degrees) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(goal_x, position_y, goal_z, move_speed, move_speed + 1.0)
	movement.wait_for_move_or_target_near(near_distance, max_frames)
	monster.stop_moving()
end

--- Turns to a heading, moves forward a distance along it and waits for the move to end or the target to be near.
function movement.move_along_heading_turning(turn_speed_degrees: f32, move_speed: f32, heading_degrees: f32, distance: f32, near_distance: f32, max_frames: s32)
	local position_y: f32 = 0
	local goal_x: f32 = 0
	local goal_y: f32 = 0
	local goal_z: f32 = 0
	heading_degrees = calc.degrees_to_radians(heading_degrees)
	if heading_degrees < calc.degrees_to_radians(turn_speed_degrees) then
		heading_degrees = vm.f32(heading_degrees + calc.degrees_to_radians(turn_speed_degrees))
	end
	movement.turn_to_heading_with_reaction(calc.radians_to_degrees(heading_degrees), turn_speed_degrees)
	movement.stop_turning()
	if distance < move_speed then
		distance = vm.f32(move_speed + 1.0)
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		goal_x = out1 or goal_x
		goal_y = out2 or goal_y
		goal_z = out3 or goal_z
	end
	goal_x = vm.f32(goal_x + vm.f32(vm.sin(heading_degrees) * distance))
	goal_z = vm.f32(goal_z + vm.f32(vm.cos(heading_degrees) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(goal_x, position_y - 20.0, goal_z, move_speed, move_speed + 1.0)
	local _ = movement.wait_for_move_or_target_near(near_distance, max_frames)
	monster.stop_moving()
end

--- Moves the monster the given distance along a heading in degrees without turning first. It reports obstacle collisions.
function movement.move_along_heading_with_obstacle_check(speed: f32, heading_degrees: f32, distance: f32, arrival_distance: f32, height_offset: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	heading_degrees = calc.degrees_to_radians(heading_degrees)
	if heading_degrees > vm.f32(3.1415927) then
		heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
	end
	if heading_degrees <= vm.f32(-3.1415927) then
		heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(heading_degrees) * distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(heading_degrees) * distance))
	local _ = movement.move_toward_position(position_x, position_y, position_z, speed, arrival_distance, height_offset, max_frames)
end

--- Turns toward a point at a radius and angle around a position and moves to it, waiting for the move to end or the target to be near.
function movement.move_around_position(
	center_x: f32,
	center_y: f32,
	center_z: f32,
	move_speed: f32,
	turn_speed_degrees: f32,
	radius: f32,
	angle_offset_degrees: f32,
	near_distance: f32,
	max_frames: s32
)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local position_y: f32 = 0
	local offset_radians: f32 = 0
	local angle: f32 = 0
	offset_radians = vm.f32(angle_offset_degrees * vm.f32(0.017453292))
	angle = monster.get_angle_to_position(center_x, center_y, center_z) or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = vm.f32(angle + offset_radians)
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	point_x = vm.f32(center_x + vm.f32(radius * vm.sin(angle)))
	point_y = center_y
	point_z = vm.f32(center_z + vm.f32(radius * vm.cos(angle)))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	angle_offset_degrees = monster.get_angle_to_position(point_x, point_y, point_z) or angle_offset_degrees
	movement.turn_to_heading_with_reaction(calc.radians_to_degrees(angle_offset_degrees), turn_speed_degrees)
	movement.stop_turning()
	monster.move_toward_position(point_x, position_y - 20.0, point_z, move_speed, move_speed)
	local _ = movement.wait_for_move_or_target_near(near_distance, max_frames)
	monster.stop_moving()
end

--- Turns toward a point at an angle offset and distance around a position and moves there. It reports obstacle collisions.
function movement.move_around_position_with_obstacle_check(
	center_x: f32,
	center_y: f32,
	center_z: f32,
	speed: f32,
	turn_speed_degrees: f32,
	distance: f32,
	angle_degrees: f32,
	arrival_distance: f32,
	height_offset: f32,
	max_frames: s32
)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local offset_radians: f32 = 0
	local point_angle: f32 = 0
	offset_radians = vm.f32(angle_degrees * vm.f32(0.017453292))
	point_angle = monster.get_angle_to_position(center_x, center_y, center_z) or point_angle
	point_angle = vm.f32(point_angle - vm.f32(3.1415927))
	point_angle = vm.f32(point_angle + offset_radians)
	if point_angle > vm.f32(3.1415927) then
		point_angle = vm.f32(point_angle - vm.f32(6.2831855))
	end
	if point_angle <= vm.f32(-3.1415927) then
		point_angle = vm.f32(point_angle + vm.f32(6.2831855))
	end
	point_x = vm.f32(center_x + vm.f32(distance * vm.sin(point_angle)))
	point_y = 0.0
	point_z = vm.f32(center_z + vm.f32(distance * vm.cos(point_angle)))
	angle_degrees = monster.get_angle_to_position(point_x, point_y, point_z) or angle_degrees
	movement.turn_to_heading(calc.radians_to_degrees(angle_degrees), turn_speed_degrees)
	movement.stop_turning()
	local _ = movement.move_toward_position(point_x, point_y, point_z, speed, arrival_distance, height_offset, max_frames)
end

--- Turns toward a point at an angle offset and distance around the target and moves there, returning the move result.
function movement.move_around_target(speed: f32, turn_speed_degrees: f32, angle_degrees: f32, distance: f32, arrival_distance: f32, height_offset: f32, max_frames: s32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local result: s32 = 0
	point_x, point_y, point_z = movement.get_approach_point(angle_degrees, distance, point_x, point_y, point_z)
	angle_degrees = monster.get_angle_to_position(point_x, point_y, point_z) or angle_degrees
	if angle_degrees > vm.f32(3.1415927) then
		angle_degrees = vm.f32(angle_degrees - vm.f32(6.2831855))
	end
	if angle_degrees <= vm.f32(-3.1415927) then
		angle_degrees = vm.f32(angle_degrees + vm.f32(6.2831855))
	end
	movement.turn_to_heading(calc.radians_to_degrees(angle_degrees), turn_speed_degrees)
	movement.stop_turning()
	result = movement.move_toward_position(point_x, point_y, point_z, speed, arrival_distance, height_offset, max_frames)
	return result
end

--- Moves the monster toward a point behind its facing.
function movement.move_backward(speed: f32, arrival_distance: f32, height_offset: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_angle: f32 = 0
	local back_angle: f32 = 0
	local distance: f32 = 0
	monster.get_target_position()
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
	back_angle = vm.f32(facing_angle + vm.f32(3.1415927))
	if back_angle > vm.f32(3.1415927) then
		back_angle = vm.f32(back_angle - vm.f32(6.2831855))
	end
	if back_angle <= vm.f32(-3.1415927) then
		back_angle = vm.f32(back_angle + vm.f32(6.2831855))
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(back_angle) * distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(back_angle) * distance))
	movement.move_toward_position(position_x, position_y, position_z, speed, arrival_distance, height_offset, max_frames)
end

--- Moves a distance in a direction given in degrees at the current height until arrival or the frame limit.
function movement.move_in_direction(move_speed: f32, angle_degrees: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local destination_y: f32 = 0
	local destination_x: f32 = 0
	local current_y: f32 = 0
	local destination_z: f32 = 0
	if distance < move_speed then
		distance = vm.f32(move_speed + 1.0)
	end
	angle_degrees = calc.degrees_to_radians(angle_degrees)
	if angle_degrees > vm.f32(3.1415927) then
		angle_degrees = vm.f32(angle_degrees - vm.f32(6.2831855))
	end
	if angle_degrees <= vm.f32(-3.1415927) then
		angle_degrees = vm.f32(angle_degrees + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		current_y = out2 or current_y
		destination_z = out3 or destination_z
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(angle_degrees) * distance))
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(angle_degrees) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		destination_y = out2 or destination_y
	end
	monster.move_toward_position(destination_x, destination_y, destination_z, move_speed, move_speed + 1.0)
	movement.wait_until_arrived_unguarded(stop_distance, max_frames)
	monster.stop_moving()
end

--- Moves a distance in a direction given in degrees and waits until the target is near, the move ends or the frame limit passes, updating the guard state.
function movement.move_in_direction_guarded(move_speed: f32, angle_degrees: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local destination_y: f32 = 0
	local destination_x: f32 = 0
	local current_y: f32 = 0
	local destination_z: f32 = 0
	if distance < move_speed then
		distance = vm.f32(move_speed + 1.0)
	end
	angle_degrees = calc.degrees_to_radians(angle_degrees)
	if angle_degrees > vm.f32(3.1415927) then
		angle_degrees = vm.f32(angle_degrees - vm.f32(6.2831855))
	end
	if angle_degrees <= vm.f32(-3.1415927) then
		angle_degrees = vm.f32(angle_degrees + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		current_y = out2 or current_y
		destination_z = out3 or destination_z
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(angle_degrees) * distance))
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(angle_degrees) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		destination_y = out2 or destination_y
	end
	monster.move_toward_position(destination_x, destination_y, destination_z, move_speed, move_speed + 1.0)
	movement.wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
end

--- Turns by a random angle and moves forward a random distance, limited by the clear distance ahead.
function movement.move_in_random_direction(move_speed: f32, turn_speed_degrees: f32, base_distance: f32, turn_range_degrees: f32, distance_range: f32, margin: f32, max_frames: s32)
	local position_y: f32 = 0
	local heading: f32 = 0
	local goal_x: f32 = 0
	local goal_z: f32 = 0
	local distance: f32 = 0
	local turn_degrees: f32 = 0
	local target_heading: f32 = 0
	local clear_distance: f32 = 0
	turn_range_degrees = calc.degrees_to_radians(turn_range_degrees)
	distance = monster.get_random_whole_number(distance_range) or distance
	turn_degrees = monster.get_random_whole_number(turn_range_degrees) or turn_degrees
	do
		local out1, _, out3 = monster.get_position_3()
		goal_x = out1 or goal_x
		goal_z = out3 or goal_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		target_heading = out2 or target_heading
	end
	target_heading = vm.f32(target_heading + calc.degrees_to_radians(turn_degrees))
	movement.turn_to_heading_with_reaction(calc.radians_to_degrees(target_heading), turn_speed_degrees)
	movement.stop_turning()
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance == 100.0 then
		distance = vm.f32(distance + vm.f32(base_distance + move_speed))
		goal_x = vm.f32(goal_x + vm.f32(distance * vm.sin(heading)))
		goal_z = vm.f32(goal_z + vm.f32(distance * vm.cos(heading)))
	else
		clear_distance = vm.f32(clear_distance - margin)
		if clear_distance > 0.0 then
			goal_x = vm.f32(goal_x + vm.f32(distance * vm.sin(heading)))
			goal_z = vm.f32(goal_z + vm.f32(distance * vm.cos(heading)))
		else
			return
		end
	end
	if distance < move_speed then
		distance = vm.f32(distance + move_speed)
	end
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(goal_x, position_y - 20.0, goal_z, move_speed, move_speed)
	local _ = movement.wait_for_move_or_target_near(margin, max_frames)
	monster.stop_moving()
end

--- Turns toward a point around the target and moves to it, returning -1 when blocked.
function movement.move_to_point_around_target(move_speed: f32, turn_speed_degrees: f32, angle_offset_degrees: f32, distance: f32, near_distance: f32, max_frames: s32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local clear_distance: f32 = 0
	local result: s32 = 0
	point_x, point_y, point_z = movement.get_approach_point(angle_offset_degrees, distance, point_x, point_y, point_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	angle_offset_degrees = monster.get_angle_to_position(point_x, point_y, point_z) or angle_offset_degrees
	if angle_offset_degrees > vm.f32(3.1415927) then
		angle_offset_degrees = vm.f32(angle_offset_degrees - vm.f32(6.2831855))
	end
	if angle_offset_degrees <= vm.f32(-3.1415927) then
		angle_offset_degrees = vm.f32(angle_offset_degrees + vm.f32(6.2831855))
	end
	movement.turn_to_heading_with_reaction(calc.radians_to_degrees(angle_offset_degrees), turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.copy_vector(point_x, point_y, point_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
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
	clear_distance = monster.get_clear_distance(move_speed + near_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(move_speed + near_distance) then
		point_x = vm.f32(position_x + vm.f32(vm.sin(angle_offset_degrees) * clear_distance))
		point_y = position_y
		point_z = vm.f32(position_z + vm.f32(vm.cos(angle_offset_degrees) * clear_distance))
		clear_distance = vm.f32(clear_distance - near_distance)
		if clear_distance < near_distance then
			return -1
		end
	end
	monster.move_toward_position(point_x, position_y - 20.0, point_z, move_speed, move_speed)
	result = movement.wait_for_move_or_target_near(near_distance, max_frames)
	monster.stop_moving()
	return result
end

--- Moves to a point around the target without turning, stopping short where the way is blocked.
function movement.move_to_point_around_target_keeping_facing(move_speed: f32, angle_offset_degrees: f32, near_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local distance: f32 = 0
	distance = monster.get_target_distance() or distance
	point_x, point_y, point_z = movement.get_approach_point(angle_offset_degrees, distance, point_x, point_y, point_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(point_x, point_y, point_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
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
	distance = monster.get_clear_distance(100.0, 0.0) or distance
	if distance < 100.0 then
		point_x = vm.f32(position_x + vm.f32(direction_x * distance))
		point_y = position_y
		point_z = vm.f32(position_z + vm.f32(direction_z * distance))
		distance = vm.f32(distance - near_distance)
		if distance < near_distance then
			return
		end
	end
	monster.move_toward_position(point_x, position_y, point_z, move_speed, move_speed)
	local _ = movement.wait_until_arrived(near_distance, max_frames)
	monster.stop_moving()
end

--- Moves the monster step by step toward a position at the ground height under the monster plus an offset, returning 1 on arrival, a nonzero obstacle code on collision, or 0 on timeout.
function movement.move_toward_position(target_x: f32, unused_target_y: f32, target_z: f32, speed: f32, arrival_distance: f32, height_offset: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_angle: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_y: f32 = 0
	local distance_to_target: f32 = 0
	local height_above_ground: f32 = 0
	local obstacle_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	ground_y = sense.get_ground_height(ground_y)
	unused_target_y = vm.f32(ground_y + height_offset)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, unused_target_y, target_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, position_x, position_y, position_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, speed)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	monster.copy_vector(target_x, unused_target_y, target_z)
	target_angle = monster.get_angle_to_position(position_x + step_x, position_y + step_y, position_z + step_z) or target_angle
	for i = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		height_above_ground = monster.get_height_above_ground_at(position_x, position_y, position_z) or height_above_ground
		if height_above_ground >= 30.0 or height_above_ground <= 0.0 then
			position_y = vm.f32(position_y - step_y)
			step_y = 0.0
		end
		distance_to_target = monster.get_distance_between(position_x, position_y, position_z, target_x, unused_target_y, target_z) or distance_to_target
		if distance_to_target < vm.f32(speed + arrival_distance) then
			return 1
		end
		obstacle_result = sense.check_flight_destination(position_x, position_y, position_z, speed, target_angle)
		if obstacle_result ~= 0 then
			return obstacle_result
		end
		monster.set_position(position_x, position_y, position_z)
		monster.copy_vector(position_x, position_y, position_z)
		timer.wait_frame()
	end
	return 0
end

--- Repeats an idle play motion with chances to walk and turn toward the target.
function movement.play_idle_wander(count: s32)
	local result: s32 = 0
	local roll: s32 = 0
	for i = 0, count - 1 do
		vm.wait()
		monster.reset_motion()
		monster.set_motion("遊び", -1, 2)
		result = sense.wait_until_target_in_arc(49.0, 90.0, calc.pass_through(56))
		if result == 1 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait(4.0)
				movement.step_backward_by_progress()
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait(4.0)
				monster.set_motion("立ち", -1, 0)
			end
		end
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(49.0, 90.0, 30)
	end
end

--- Repeatedly turns toward and moves to the target until it is within a stop distance or the frame limit passes, updating the guard state.
function movement.pursue_target_guarded(speed: f32, turn_speed_degrees: f32, stop_distance: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local frame: s32 = 0
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed_degrees > vm.f32(3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees - vm.f32(6.2831855))
	end
	if turn_speed_degrees <= vm.f32(-3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees + vm.f32(6.2831855))
	end
	frame = 0
	while frame < max_frames do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed_degrees)
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		monster.get_rotation()
		monster.move_toward_position(target_x, target_y - 20.0, target_z, speed, speed)
		reaction.update_and_wait_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Raises the monster one unit.
function movement.raise_one_unit()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_position(position_x, position_y + 1.0, position_z)
end

--- Plays the step-back motion and walks to a point farther from the target, then waits for the motion to finish.
function movement.retreat_from_target(step_length: f32)
	local position_y: f32 = 0
	local retreat_x: f32 = 0
	local retreat_y: f32 = 0
	local retreat_z: f32 = 0
	local retreat_distance: f32 = 0
	local random_distance: f32 = 0
	monster.set_monster_attributes(32, 1)
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		retreat_x = out1 or retreat_x
		retreat_z = out3 or retreat_z
	end
	random_distance = monster.get_random_whole_number(10.0) or random_distance
	retreat_distance = vm.f32(retreat_distance + vm.f32(30.0 + random_distance))
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	retreat_x, retreat_y, retreat_z = movement.get_approach_point(0.0, retreat_distance, retreat_x, retreat_y, retreat_z)
	timer.wait_frames(4)
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	movement.walk_to_position(retreat_x, position_y, retreat_z, step_length, vm.f32(step_length + 1.0), 25.0, 10)
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished()
	monster.stop_moving()
end

--- Backs away from the target to a point well beyond its current distance while invulnerable.
function movement.retreat_long(speed: f32)
	local retreat_x: f32 = 0
	local retreat_y: f32 = 0
	local retreat_z: f32 = 0
	local distance: f32 = 0
	local random_extra: f32 = 0
	local current_y: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	monster.set_monster_attributes(32, 1)
	distance = monster.get_target_distance() or distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		retreat_x = out1 or retreat_x
		retreat_z = out3 or retreat_z
	end
	random_extra = monster.get_random_whole_number(10.0) or random_extra
	distance = vm.f32(distance + vm.f32(100.0 + random_extra))
	retreat_x, retreat_y, retreat_z = movement.get_approach_point(0.0, distance, retreat_x, retreat_y, retreat_z)
	monster.set_motion("歩き後", -1, 6)
	timer.wait_frames(17)
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(retreat_x, current_y, retreat_z, speed, speed + 1.0)
	timer.wait_frames(7)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Backs away from the target to a point slightly farther than its current distance while invulnerable.
function movement.retreat_short(speed: f32)
	local retreat_x: f32 = 0
	local retreat_y: f32 = 0
	local retreat_z: f32 = 0
	local distance: f32 = 0
	local random_extra: f32 = 0
	local current_y: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	monster.set_monster_attributes(32, 1)
	distance = monster.get_target_distance() or distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		retreat_x = out1 or retreat_x
		retreat_z = out3 or retreat_z
	end
	random_extra = monster.get_random_whole_number(10.0) or random_extra
	distance = vm.f32(distance + vm.f32(40.0 + random_extra))
	retreat_x, retreat_y, retreat_z = movement.get_approach_point(0.0, distance, retreat_x, retreat_y, retreat_z)
	monster.set_motion("歩き後", -1, 6)
	timer.wait_frames(8)
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(retreat_x, current_y, retreat_z, speed, speed + 1.0)
	timer.wait_frames(8)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Plays the walk motion and moves straight up or down toward 38 units above the ground.
function movement.rise_to_hover_height()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local ground_y: f32 = 0
	monster.set_motion("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	ground_y = sense.get_ground_height(ground_y)
	movement.walk_to_position(position_x, position_y, position_z, 2.0, 35.0, 38.0, 120)
end

--- Plays the run motion while moving between speeds 3.2 and 4.2 for 120 frames, then returns to standing.
function movement.run_in_place_range()
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(vm.f32(3.2), vm.f32(4.2), 40.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Turns to face the target and moves forward by the target distance if the path is clear.
function movement.rush_forward(move_speed: f32, turn_speed_degrees: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local destination_x: f32 = 0
	local destination_z: f32 = 0
	local heading: f32 = 0
	local target_distance: f32 = 0
	local clear_distance: f32 = 0
	movement.turn_toward_target_and_wait(turn_speed_degrees)
	movement.stop_turning()
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	target_distance = monster.get_target_distance() or target_distance
	clear_distance = monster.get_clear_distance(move_speed + stop_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(move_speed + stop_distance) then
		return
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	destination_x = vm.f32(position_x + vm.f32(vm.sin(heading) * target_distance))
	destination_z = vm.f32(position_z + vm.f32(vm.cos(heading) * target_distance))
	monster.move_toward_position(destination_x, position_y - 20.0, destination_z, move_speed, stop_distance + move_speed)
	local _ = movement.wait_until_arrived_unguarded(stop_distance, max_frames)
	monster.stop_moving()
end

--- Turns to face the target and moves forward by the target distance if the path is clear, updating the guard state.
function movement.rush_forward_guarded(move_speed: f32, turn_speed_degrees: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local destination_x: f32 = 0
	local destination_z: f32 = 0
	local heading: f32 = 0
	local target_distance: f32 = 0
	local clear_distance: f32 = 0
	movement.turn_toward_target_and_wait_guarded(turn_speed_degrees)
	movement.stop_turning()
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	target_distance = monster.get_target_distance() or target_distance
	clear_distance = monster.get_clear_distance(move_speed + stop_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(move_speed + stop_distance) then
		return
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	destination_x = vm.f32(position_x + vm.f32(vm.sin(heading) * target_distance))
	destination_z = vm.f32(position_z + vm.f32(vm.cos(heading) * target_distance))
	monster.move_toward_position(destination_x, position_y - 20.0, destination_z, move_speed, stop_distance + move_speed)
	local _ = movement.wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
end

--- Turns to face the target and moves forward by the target distance if the path is clear, updating model lighting.
function movement.rush_forward_with_lighting(move_speed: f32, turn_speed_degrees: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local destination_x: f32 = 0
	local destination_z: f32 = 0
	local heading: f32 = 0
	local target_distance: f32 = 0
	local clear_distance: f32 = 0
	movement.turn_toward_target_and_wait_with_lighting(turn_speed_degrees)
	movement.stop_turning()
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	target_distance = monster.get_target_distance() or target_distance
	clear_distance = monster.get_clear_distance(move_speed + stop_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(move_speed + stop_distance) then
		return
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	destination_x = vm.f32(position_x + vm.f32(vm.sin(heading) * target_distance))
	destination_z = vm.f32(position_z + vm.f32(vm.cos(heading) * target_distance))
	monster.move_toward_position(destination_x, position_y - 20.0, destination_z, move_speed, stop_distance + move_speed)
	local _ = movement.wait_until_arrived_with_lighting(stop_distance, max_frames)
	monster.stop_moving()
end

--- Steps sideways to a random side.
function movement.sidestep()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local heading: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
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
		heading = out2 or heading
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ左", -1, 2)
		heading = vm.f32(heading + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 2)
		heading = vm.f32(heading - vm.f32(1.5707964))
	end
	step_distance = 100.0
	target_x = vm.f32(position_x + vm.f32(vm.sin(heading) * step_distance))
	target_y = vm.f32(position_y - 20.0)
	target_z = vm.f32(position_z + vm.f32(vm.cos(heading) * step_distance))
	motion.wait_until_progress_reached(vm.f32(0.27), -1.0)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target_x, target_y, target_z, 2.25, 2.25)
	motion.wait_until_progress_reached(vm.f32(0.63), -1.0)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Steps sideways to a random side while updating the guard state.
function movement.sidestep_guarded()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local heading: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
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
		heading = out2 or heading
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ左", -1, 2)
		heading = vm.f32(heading + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 2)
		heading = vm.f32(heading - vm.f32(1.5707964))
	end
	step_distance = 100.0
	target_x = vm.f32(position_x + vm.f32(vm.sin(heading) * step_distance))
	target_y = vm.f32(position_y - 20.0)
	target_z = vm.f32(position_z + vm.f32(vm.cos(heading) * step_distance))
	motion.wait_until_progress(vm.f32(0.27), -1.0)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target_x, target_y, target_z, 2.25, 2.25)
	motion.wait_until_progress(vm.f32(0.63), -1.0)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

--- Moves sideways relative to the monster's facing, to the right or left, toward a point 300 units away. The side is chosen by an argument.
function movement.sidestep_toward_side(speed: f32, arrival_distance: f32, height_offset: f32, step_right: s32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_angle: f32 = 0
	local step_angle: f32 = 0
	local step_distance: f32 = 0
	step_distance = 300.0
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
	if step_right ~= 0 then
		step_angle = vm.f32(facing_angle - vm.f32(1.5707964))
	else
		step_angle = vm.f32(facing_angle + vm.f32(1.5707964))
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(step_angle) * step_distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(step_angle) * step_distance))
	movement.move_toward_position(position_x, position_y, position_z, speed, arrival_distance, height_offset, max_frames)
end

--- Steps backward from the monster's facing while updating the guard state, then returns to the standing motion.
function movement.step_back_guarded()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local heading: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	heading = vm.f32(heading + vm.f32(3.1415927))
	position_x = vm.f32(position_x + vm.f32(100.0 * vm.sin(heading)))
	position_z = vm.f32(position_z + vm.f32(100.0 * vm.cos(heading)))
	monster.set_motion("ステップ後", -1, 2)
	motion.wait_until_progress(vm.f32(0.28), -1.0)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(position_x, position_y, position_z, 2.5, 2.5)
	motion.wait_until_progress(vm.f32(0.8), -1.0)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

--- Steps backward 100 units while invulnerable and returns to standing.
function movement.step_backward()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local back_angle: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		back_angle = out2 or back_angle
	end
	back_angle = vm.f32(back_angle + vm.f32(3.1415927))
	position_x = vm.f32(position_x + vm.f32(100.0 * vm.sin(back_angle)))
	position_z = vm.f32(position_z + vm.f32(100.0 * vm.cos(back_angle)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(7))
	monster.move_toward_position(position_x, position_y, position_z, 3.7, 3.7)
	timer.wait_frames_with_guard_update(calc.pass_through(9))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

--- Steps 100 units backward with the step-back motion while attribute bit 32 is set.
function movement.step_backward_by_progress()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local back_angle: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		back_angle = out2 or back_angle
	end
	back_angle = vm.f32(back_angle + vm.f32(3.1415927))
	position_x = vm.f32(position_x + vm.f32(100.0 * vm.sin(back_angle)))
	position_z = vm.f32(position_z + vm.f32(100.0 * vm.cos(back_angle)))
	monster.set_motion("ステップ後", -1, 2)
	motion.wait_until_progress_reached(vm.f32(0.28), -1.0)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(position_x, position_y, position_z, 2.5, 2.5)
	motion.wait_until_progress_reached(vm.f32(0.8), -1.0)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Steps 100 units backward with the step-back motion while attribute bit 32 is set, updating the guard state while waiting.
function movement.step_backward_guarded()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local back_angle: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	back_angle = vm.f32(rotation_y + vm.f32(3.1415927))
	if back_angle > vm.f32(3.1415927) then
		back_angle = vm.f32(back_angle - vm.f32(6.2831855))
	end
	if back_angle <= vm.f32(-3.1415927) then
		back_angle = vm.f32(back_angle + vm.f32(6.2831855))
	end
	position_x = vm.f32(position_x + vm.f32(100.0 * vm.sin(back_angle)))
	position_z = vm.f32(position_z + vm.f32(100.0 * vm.cos(back_angle)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 2)
	monster.move_toward_position(position_x, position_y, position_z, 6.0, 6.0)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Steps 100 units to a random side while invulnerable and returns to standing.
function movement.step_sideways()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local step_angle: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
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
	step_x = vm.f32(position_x + vm.f32(vm.sin(step_angle) * step_distance))
	step_y = vm.f32(position_y - 20.0)
	step_z = vm.f32(position_z + vm.f32(vm.cos(step_angle) * step_distance))
	timer.wait_frames_with_guard_update(calc.pass_through(8))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(step_x, step_y, step_z, 3.7, 3.7)
	timer.wait_frames_with_guard_update(calc.pass_through(8))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

--- Steps 100 units to a random side with the matching left or right step motion while attribute bit 32 is set, updating the guard state while waiting.
function movement.step_sideways_guarded()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local distance: f32 = 0
	local step_angle: f32 = 0
	local roll: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ左", -1, 6)
		step_angle = vm.f32(rotation_y + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 6)
		step_angle = vm.f32(rotation_y - vm.f32(1.5707964))
	end
	distance = 100.0
	if step_angle > vm.f32(3.1415927) then
		step_angle = vm.f32(step_angle - vm.f32(6.2831855))
	end
	if step_angle <= vm.f32(-3.1415927) then
		step_angle = vm.f32(step_angle + vm.f32(6.2831855))
	end
	destination_x = vm.f32(position_x + vm.f32(vm.sin(step_angle) * distance))
	destination_y = vm.f32(position_y - 20.0)
	destination_z = vm.f32(position_z + vm.f32(vm.cos(step_angle) * distance))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(destination_x, destination_y, destination_z, 6.0, 6.0)
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
end

--- Stops moving and turning and resets the motion.
function movement.stop_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.reset_motion()
end

--- Moves the monster to its own position and stops it there.
function movement.stop_at_current_position()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.move_toward_position(position_x, position_y, position_z, 0.0, 0.0)
	monster.stop_moving()
end

--- Stops the monster turning by turning toward its current facing angle.
function movement.stop_turning()
	local current_angle: f32 = 0
	do
		local _, out2, _ = monster.get_rotation()
		current_angle = out2 or current_angle
	end
	monster.turn_toward_angle(current_angle, 0)
end

--- Either walks along a randomly offset path or stands still for 30 frames.
function movement.strafe_or_stand()
	local roll: s32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		offset_angle = monster.get_random_whole_number(30.0) or offset_angle
		offset_distance = monster.get_random_whole_number(30.0) or offset_distance
		offset_distance = vm.f32(offset_distance + 90.0)
		if roll < 50 then
			offset_angle = vm.f32(-offset_angle - 30.0)
		else
			offset_angle = vm.f32(offset_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(1.75, vm.f32(4.2), offset_angle, offset_distance, 40.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(40.0, 45.0, 30)
	end
end

--- Either strafes around the target and faces it, or stands and waits for the target to come in front.
function movement.strafe_or_wait()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	local unused_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		strafe_angle_degrees = monster.get_random_whole_number(30.0) or strafe_angle_degrees
		unused_distance = monster.get_random_whole_number(30.0) or unused_distance
		unused_distance = vm.f32(unused_distance + 90.0)
		if roll < 50 then
			strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
		else
			strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.move_around_target(1.75, vm.f32(4.8), strafe_angle_degrees, 60.0, 1.0, 30.0, 50)
		movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front_updating_lighting(30.0, 45.0, 30)
	end
end

--- Either strafes around the target at a fast speed and faces it, or stands and waits for the target to come in front.
function movement.strafe_or_wait_fast()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	local unused_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		strafe_angle_degrees = monster.get_random_whole_number(30.0) or strafe_angle_degrees
		unused_distance = monster.get_random_whole_number(30.0) or unused_distance
		unused_distance = vm.f32(unused_distance + 120.0)
		if roll < 50 then
			strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
		else
			strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.move_around_target(2.0, vm.f32(4.8), strafe_angle_degrees, 60.0, 1.0, 30.0, 50)
		movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front_updating_lighting(30.0, 45.0, 30)
	end
end

--- Turns toward the target every frame for a number of frames and then stops turning.
function movement.track_target(turn_speed: f32, frames: s32)
	local target_angle: f32 = 0
	local _ = calc.degrees_to_radians(turn_speed)
	for i = 0, frames - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
		timer.wait_one_frame()
	end
	movement.stop_turning()
	return 0
end

--- Turns toward the target every frame for the given number of frames, then stops turning.
function movement.track_target_for_frames(turn_speed_degrees: f32, frames: s32)
	local target_angle: f32 = 0
	local _ = calc.degrees_to_radians(turn_speed_degrees)
	for i = 0, frames - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed_degrees)
		timer.wait_frame_with_reaction()
	end
	movement.stop_turning()
	return 0
end

--- Turns toward the target every frame for a number of frames while updating the guard state.
function movement.track_target_guarded(turn_speed: f32, frames: s32)
	local target_angle: f32 = 0
	local _ = calc.degrees_to_radians(turn_speed)
	for i = 0, frames - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
		reaction.update_and_wait_frame()
	end
	movement.stop_turning()
	return 0
end

--- Turns toward the target each frame until the current motion's progress is within a tolerance of the given value.
function movement.track_target_until_progress(turn_speed_degrees: f32, progress: f32, tolerance: f32)
	local target_angle: f32 = 0
	local current_progress: f32 = 0
	local turn_speed: f32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.05)
	end
	turn_speed = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
		current_progress = monster.get_motion_progress() or current_progress
		if current_progress < vm.f32(progress + tolerance) and current_progress > vm.f32(progress - tolerance) then
			break
		else
			timer.wait_frame()
		end
	end
	movement.stop_turning()
end

--- Turns to an angle in degrees and moves a distance in that direction until arrival or the frame limit.
function movement.turn_and_move_in_direction(turn_speed_degrees: f32, move_speed: f32, angle_degrees: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local destination_y: f32 = 0
	local destination_x: f32 = 0
	local current_y: f32 = 0
	local destination_z: f32 = 0
	angle_degrees = calc.degrees_to_radians(angle_degrees)
	if angle_degrees < calc.degrees_to_radians(turn_speed_degrees) then
		angle_degrees = vm.f32(angle_degrees + calc.degrees_to_radians(turn_speed_degrees))
	end
	movement.turn_to_angle(calc.radians_to_degrees(angle_degrees), turn_speed_degrees)
	movement.stop_turning()
	if distance < move_speed then
		distance = vm.f32(move_speed + 1.0)
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		current_y = out2 or current_y
		destination_z = out3 or destination_z
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(angle_degrees) * distance))
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(angle_degrees) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		destination_y = out2 or destination_y
	end
	monster.move_toward_position(destination_x, destination_y - 20.0, destination_z, move_speed, move_speed + 1.0)
	local _ = movement.wait_until_arrived_unguarded(stop_distance, max_frames)
	monster.stop_moving()
end

--- Turns to an angle in degrees and moves a distance in that direction until arrival or the frame limit, updating the guard state.
function movement.turn_and_move_in_direction_guarded(turn_speed_degrees: f32, move_speed: f32, angle_degrees: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local destination_y: f32 = 0
	local destination_x: f32 = 0
	local current_y: f32 = 0
	local destination_z: f32 = 0
	angle_degrees = calc.degrees_to_radians(angle_degrees)
	if angle_degrees < calc.degrees_to_radians(turn_speed_degrees) then
		angle_degrees = vm.f32(angle_degrees + calc.degrees_to_radians(turn_speed_degrees))
	end
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(angle_degrees), turn_speed_degrees)
	movement.stop_turning()
	if distance < move_speed then
		distance = vm.f32(move_speed + 1.0)
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		current_y = out2 or current_y
		destination_z = out3 or destination_z
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(angle_degrees) * distance))
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(angle_degrees) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		destination_y = out2 or destination_y
	end
	monster.move_toward_position(destination_x, destination_y - 20.0, destination_z, move_speed, move_speed + 1.0)
	local _ = movement.wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
end

--- Turns to a heading in degrees, then moves the given distance along that heading.
function movement.turn_and_move_straight(turn_speed_degrees: f32, speed: f32, heading_degrees: f32, distance: f32, arrival_distance: f32, height_offset: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	movement.turn_to_heading(heading_degrees, turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(vm.f32(heading_degrees * vm.f32(0.017453292))) * distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(vm.f32(heading_degrees * vm.f32(0.017453292))) * distance))
	local _ = movement.move_toward_position(position_x, position_y, position_z, speed, arrival_distance, height_offset, max_frames)
end

--- Turns the monster to a target angle in degrees at a given speed and waits until the turn finishes.
function movement.turn_to_angle(target_angle_degrees: f32, speed_degrees: f32)
	target_angle_degrees = calc.degrees_to_radians(target_angle_degrees)
	if target_angle_degrees > vm.f32(3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees - vm.f32(6.2831855))
	end
	if target_angle_degrees <= vm.f32(-3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees + vm.f32(6.2831855))
	end
	speed_degrees = calc.degrees_to_radians(speed_degrees)
	if speed_degrees > vm.f32(3.1415927) then
		speed_degrees = vm.f32(speed_degrees - vm.f32(6.2831855))
	end
	if speed_degrees <= vm.f32(-3.1415927) then
		speed_degrees = vm.f32(speed_degrees + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(target_angle_degrees, speed_degrees)
	local _ = movement.wait_until_facing(
		calc.radians_to_degrees(target_angle_degrees),
		calc.radians_to_degrees(speed_degrees),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(speed_degrees)))
	)
	movement.stop_turning()
end

--- Turns to a heading given in degrees at a rotation speed and waits until facing it.
function movement.turn_to_angle_and_wait(target_degrees: f32, turn_speed_degrees: f32)
	target_degrees = calc.degrees_to_radians(target_degrees)
	if target_degrees > vm.f32(3.1415927) then
		target_degrees = vm.f32(target_degrees - vm.f32(6.2831855))
	end
	if target_degrees <= vm.f32(-3.1415927) then
		target_degrees = vm.f32(target_degrees + vm.f32(6.2831855))
	end
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed_degrees > vm.f32(3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees - vm.f32(6.2831855))
	end
	if turn_speed_degrees <= vm.f32(-3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(target_degrees, turn_speed_degrees)
	local _ = movement.wait_until_facing_guarded(
		calc.radians_to_degrees(target_degrees),
		calc.radians_to_degrees(turn_speed_degrees),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(turn_speed_degrees)))
	)
	movement.stop_turning()
end

--- Turns the monster to a target angle in degrees at a given speed, updating model lighting while waiting.
function movement.turn_to_angle_with_lighting(target_angle_degrees: f32, speed_degrees: f32)
	target_angle_degrees = calc.degrees_to_radians(target_angle_degrees)
	if target_angle_degrees > vm.f32(3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees - vm.f32(6.2831855))
	end
	if target_angle_degrees <= vm.f32(-3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees + vm.f32(6.2831855))
	end
	speed_degrees = calc.degrees_to_radians(speed_degrees)
	if speed_degrees > vm.f32(3.1415927) then
		speed_degrees = vm.f32(speed_degrees - vm.f32(6.2831855))
	end
	if speed_degrees <= vm.f32(-3.1415927) then
		speed_degrees = vm.f32(speed_degrees + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(target_angle_degrees, speed_degrees)
	local _ = movement.wait_until_facing_with_lighting(
		calc.radians_to_degrees(target_angle_degrees),
		calc.radians_to_degrees(speed_degrees),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(speed_degrees)))
	)
	movement.stop_turning()
end

--- Turns the monster to an angle given in degrees at a turn speed given in degrees per frame and waits until the rotation is reached.
function movement.turn_to_heading(angle_degrees: f32, turn_speed_degrees: f32)
	angle_degrees = calc.degrees_to_radians(angle_degrees)
	if angle_degrees > vm.f32(3.1415927) then
		angle_degrees = vm.f32(angle_degrees - vm.f32(6.2831855))
	end
	if angle_degrees <= vm.f32(-3.1415927) then
		angle_degrees = vm.f32(angle_degrees + vm.f32(6.2831855))
	end
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed_degrees > vm.f32(3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees - vm.f32(6.2831855))
	end
	if turn_speed_degrees <= vm.f32(-3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(angle_degrees, turn_speed_degrees)
	local _ = movement.wait_until_facing_updating_lighting(
		calc.radians_to_degrees(angle_degrees),
		calc.radians_to_degrees(turn_speed_degrees),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(turn_speed_degrees)))
	)
	movement.stop_turning()
end

--- Turns to a heading at a speed and waits until the turn is done while reactions keep running.
function movement.turn_to_heading_with_reaction(heading_degrees: f32, turn_speed_degrees: f32)
	heading_degrees = calc.degrees_to_radians(heading_degrees)
	if heading_degrees > vm.f32(3.1415927) then
		heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
	end
	if heading_degrees <= vm.f32(-3.1415927) then
		heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
	end
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed_degrees > vm.f32(3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees - vm.f32(6.2831855))
	end
	if turn_speed_degrees <= vm.f32(-3.1415927) then
		turn_speed_degrees = vm.f32(turn_speed_degrees + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(heading_degrees, turn_speed_degrees)
	local _ = movement.wait_until_facing_with_reaction(
		calc.radians_to_degrees(heading_degrees),
		calc.radians_to_degrees(turn_speed_degrees),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(turn_speed_degrees)))
	)
	movement.stop_turning()
end

--- Turns toward another monster for a number of frames.
function movement.turn_toward_monster(monster_index: s32, turn_speed: f32, max_frames: s32)
	local other_x: f32 = 0
	local other_y: f32 = 0
	local other_z: f32 = 0
	local angle_to_monster: f32 = 0
	turn_speed = calc.degrees_to_radians(turn_speed)
	for i = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.get_monster_position(monster_index)
			other_x = out1 or other_x
			other_y = out2 or other_y
			other_z = out3 or other_z
		end
		angle_to_monster = monster.get_angle_to_position(other_x, other_y, other_z) or angle_to_monster
		monster.turn_toward_angle(angle_to_monster, turn_speed)
		timer.wait_frame_with_reaction()
	end
	movement.stop_turning()
end

--- Turns the monster toward the target at the given rotation speed.
function movement.turn_toward_target(turn_speed: f32)
	local target_angle: f32 = 0
	target_angle = monster.get_target_angle() or target_angle
	monster.turn_toward_angle(target_angle, turn_speed)
end

--- Turns toward the target and waits until facing it, returning the frames waited.
function movement.turn_toward_target_and_wait(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	local frames_waited: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	frames_waited = movement.wait_until_facing(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
	return frames_waited
end

--- Turns toward the target and waits until facing it while updating the guard state.
function movement.turn_toward_target_and_wait_guarded(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = movement.wait_until_facing_guarded(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Turns toward the target and waits until facing it for monsters using the alternative command set.
function movement.turn_toward_target_and_wait_variant(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target_variant(calc.degrees_to_radians(turn_speed_degrees))
	monster.call_command(75, target_angle) -- retail: the handler rejects 1 arguments
	local _ = movement.wait_until_facing_variant(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.hold_current_facing_variant()
end

--- Turns toward the target at a speed in degrees and waits until facing it, updating model lighting.
function movement.turn_toward_target_and_wait_with_lighting(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = movement.wait_until_facing_with_lighting(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Turns toward the target at a speed and waits until it is facing it. It keeps reactions running while waiting.
function movement.turn_toward_target_until_facing(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = movement.wait_until_facing_with_reaction(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Turns the monster toward the target and waits until it is facing it. It updates the lighting each frame.
function movement.turn_toward_target_until_facing_updating_lighting(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = movement.wait_until_facing_updating_lighting(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Turns the monster toward the target at a rotation speed for monsters using the alternative command set.
function movement.turn_toward_target_variant(turn_speed: f32)
	local target_angle: f32 = 0
	monster.call_command(75, target_angle) -- retail: the handler rejects 1 arguments
	monster.call_command(69, target_angle, turn_speed) -- retail: command 69 is not registered
end

--- Turns toward the target, sometimes offset to a random side, and waits until facing.
function movement.turn_toward_target_with_offset(turn_speed_degrees: f32, offset_degrees: f32, offset_chance: s32)
	local turn_angle: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	turn_angle = monster.get_target_angle() or turn_angle
	offset_degrees = calc.degrees_to_radians(offset_degrees)
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	if roll < offset_chance then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			turn_angle = vm.f32(turn_angle + offset_degrees)
		else
			turn_angle = vm.f32(turn_angle - offset_degrees)
		end
	end
	monster.turn_toward_angle(turn_angle, turn_speed_degrees)
	local _ = movement.wait_until_facing(calc.radians_to_degrees(turn_angle), calc.radians_to_degrees(turn_speed_degrees), 360.0)
	movement.stop_turning()
end

--- Turns toward the target, sometimes offset to a random side, and waits until facing while updating the guard state.
function movement.turn_toward_target_with_offset_guarded(turn_speed_degrees: f32, offset_degrees: f32, offset_chance: s32)
	local turn_angle: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	turn_angle = monster.get_target_angle() or turn_angle
	offset_degrees = calc.degrees_to_radians(offset_degrees)
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	if roll < offset_chance then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			turn_angle = vm.f32(turn_angle + offset_degrees)
		else
			turn_angle = vm.f32(turn_angle - offset_degrees)
		end
	end
	monster.turn_toward_angle(turn_angle, turn_speed_degrees)
	local _ = movement.wait_until_facing_guarded(calc.radians_to_degrees(turn_angle), calc.radians_to_degrees(turn_speed_degrees), 360.0)
	movement.stop_turning()
end

--- Turns toward the target until the current motion reaches the given progress within a tolerance, then stops turning.
function movement.turn_until_motion_progress(turn_speed_degrees: f32, progress: f32, tolerance: f32)
	local target_angle: f32 = 0
	local motion_progress: f32 = 0
	local turn_speed_radians: f32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.05)
	end
	turn_speed_radians = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed_radians > vm.f32(3.1415927) then
		turn_speed_radians = vm.f32(turn_speed_radians - vm.f32(6.2831855))
	end
	if turn_speed_radians <= vm.f32(-3.1415927) then
		turn_speed_radians = vm.f32(turn_speed_radians + vm.f32(6.2831855))
	end
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed_radians)
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress < vm.f32(progress + tolerance) and motion_progress > vm.f32(progress - tolerance) then
			break
		else
			reaction.update_and_wait_frame()
		end
	end
	movement.stop_turning()
end

--- Waits up to the given frames and returns 1 when the target is within range, 2 when the move finishes, or 0 on timeout.
function movement.wait_for_move(target_range: f32, max_frames: any)
	local i: s32 = 0
	local arrived: s32 = 0
	local target_distance: f32 = 0
	i = 0
	while i < max_frames do
		arrived = monster.is_move_finished() or arrived
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < target_range then
			monster.stop_moving()
			return 1
		end
		if arrived == 0 then
			timer.wait_frame()
		else
			monster.stop_moving()
			return 2
		end
		if arrived == 1 then
			monster.stop_moving()
			return 1
		end
		i = vm.i32(i + 1)
	end
	return 0
end

--- Waits until the move finishes or the target comes near, returning 1 for near, 2 for finished and 0 on timeout.
function movement.wait_for_move_or_target_near(near_distance: f32, max_frames: any)
	local frame: s32 = 0
	local arrived: s32 = 0
	local target_distance: f32 = 0
	frame = 0
	while frame < max_frames do
		arrived = monster.is_move_finished() or arrived
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < near_distance then
			monster.stop_moving()
			return 1
		end
		if arrived == 0 then
			timer.wait_frame_with_reaction()
		else
			monster.stop_moving()
			return 2
		end
		if arrived == 1 then
			monster.stop_moving()
			return 1
		end
		frame = vm.i32(frame + 1)
	end
	return 0
end

--- Waits for the current move to end, returning 1 when near the target, 2 when the move finished and 0 on timeout.
function movement.wait_until_arrived(stop_distance: f32, max_frames: any)
	local i: s32 = 0
	local arrived: s32 = 0
	local target_distance: f32 = 0
	i = 0
	while i < max_frames do
		arrived = monster.is_move_finished() or arrived
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			monster.stop_moving()
			return 1
		end
		if arrived == 0 then
			reaction.update_and_wait_frame()
		else
			monster.stop_moving()
			return 2
		end
		if arrived == 1 then
			monster.stop_moving()
			return 1
		end
		i = vm.i32(i + 1)
	end
	return 0
end

--- Waits up to a frame limit for the current move, returning 1 when the target comes within a distance, 2 when the move finishes first and 0 on timeout.
function movement.wait_until_arrived_unguarded(stop_distance: f32, max_frames: any)
	local frame: s32 = 0
	local arrived: s32 = 0
	local target_distance: f32 = 0
	frame = 0
	while frame < max_frames do
		arrived = monster.is_move_finished() or arrived
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			monster.stop_moving()
			return 1
		end
		if arrived == 0 then
			timer.wait_one_frame()
		else
			monster.stop_moving()
			return 2
		end
		if arrived == 1 then
			monster.stop_moving()
			return 1
		end
		frame = vm.i32(frame + 1)
	end
	return 0
end

--- Waits up to a frame limit for the current move, returning 1 when the target comes within a distance, 2 when the move finishes first and 0 on timeout, updating model lighting.
function movement.wait_until_arrived_with_lighting(stop_distance: f32, max_frames: any)
	local frame: s32 = 0
	local arrived: s32 = 0
	local target_distance: f32 = 0
	frame = 0
	while frame < max_frames do
		arrived = monster.is_move_finished() or arrived
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			monster.stop_moving()
			return 1
		end
		if arrived == 0 then
			timer.wait_frame_with_lighting()
		else
			monster.stop_moving()
			return 2
		end
		if arrived == 1 then
			monster.stop_moving()
			return 1
		end
		frame = vm.i32(frame + 1)
	end
	return 0
end

--- Waits until the monster faces a heading within a tolerance and returns the frames waited.
function movement.wait_until_facing(target_angle_degrees: f32, tolerance_degrees: f32, max_frames: f32)
	local current_angle: f32 = 0
	local frames_waited: f32 = 0
	local frame_limit: f32 = 0
	local widened_tolerance: f32 = 0
	target_angle_degrees = calc.degrees_to_radians(target_angle_degrees)
	if target_angle_degrees > vm.f32(3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees - vm.f32(6.2831855))
	end
	if target_angle_degrees <= vm.f32(-3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees + vm.f32(6.2831855))
	end
	tolerance_degrees = calc.degrees_to_radians(tolerance_degrees)
	frame_limit = max_frames
	if tolerance_degrees < 3.0 then
		widened_tolerance = calc.degrees_to_radians(3.0)
	else
		widened_tolerance = tolerance_degrees
	end
	frames_waited = 0.0
	while frames_waited < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_angle = out2 or current_angle
		end
		if current_angle > vm.f32(target_angle_degrees - widened_tolerance) and current_angle < vm.f32(target_angle_degrees + widened_tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle_degrees, current_angle, tolerance_degrees) == 0 then
			movement.stop_turning()
			break
		elseif frames_waited >= max_frames then
			movement.stop_turning()
			break
		else
			timer.wait_one_frame()
			frames_waited = vm.f32(frames_waited + 1.0)
		end
	end
	movement.stop_turning()
	return frames_waited
end

--- Waits until the monster faces a heading within a tolerance while updating the guard state, returning the frames waited.
function movement.wait_until_facing_guarded(target_angle_degrees: f32, tolerance_degrees: f32, max_frames: f32)
	local current_angle: f32 = 0
	local frames_waited: f32 = 0
	local frame_limit: f32 = 0
	local widened_tolerance: f32 = 0
	target_angle_degrees = calc.degrees_to_radians(target_angle_degrees)
	if target_angle_degrees > vm.f32(3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees - vm.f32(6.2831855))
	end
	if target_angle_degrees <= vm.f32(-3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees + vm.f32(6.2831855))
	end
	tolerance_degrees = calc.degrees_to_radians(tolerance_degrees)
	frame_limit = max_frames
	if tolerance_degrees < 3.0 then
		widened_tolerance = calc.degrees_to_radians(3.0)
	else
		widened_tolerance = tolerance_degrees
	end
	frames_waited = 0.0
	while frames_waited < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_angle = out2 or current_angle
		end
		if current_angle > vm.f32(target_angle_degrees - widened_tolerance) and current_angle < vm.f32(target_angle_degrees + widened_tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle_degrees, current_angle, tolerance_degrees) == 0 then
			movement.stop_turning()
			break
		elseif frames_waited >= max_frames then
			movement.stop_turning()
			break
		else
			reaction.update_and_wait_frame()
			frames_waited = vm.f32(frames_waited + 1.0)
		end
	end
	movement.stop_turning()
	return frames_waited
end

--- Waits until the monster's rotation is within a tolerance of an angle or the frame limit passes, and returns the frames waited. It updates the lighting each frame.
function movement.wait_until_facing_updating_lighting(angle_degrees: f32, tolerance_degrees: f32, max_frames: f32)
	local facing_angle: f32 = 0
	local frame_count: f32 = 0
	local frame_limit: f32 = 0
	local tolerance_radians: f32 = 0
	angle_degrees = calc.degrees_to_radians(angle_degrees)
	if angle_degrees > vm.f32(3.1415927) then
		angle_degrees = vm.f32(angle_degrees - vm.f32(6.2831855))
	end
	if angle_degrees <= vm.f32(-3.1415927) then
		angle_degrees = vm.f32(angle_degrees + vm.f32(6.2831855))
	end
	tolerance_degrees = calc.degrees_to_radians(tolerance_degrees)
	frame_limit = max_frames
	if tolerance_degrees < 3.0 then
		tolerance_radians = calc.degrees_to_radians(3.0)
	else
		tolerance_radians = tolerance_degrees
	end
	frame_count = 0.0
	while frame_count < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			facing_angle = out2 or facing_angle
		end
		if facing_angle > vm.f32(angle_degrees - tolerance_radians) and facing_angle < vm.f32(angle_degrees + tolerance_radians) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(angle_degrees, facing_angle, tolerance_degrees) == 0 then
			movement.stop_turning()
			break
		elseif frame_count >= max_frames then
			movement.stop_turning()
			break
		else
			timer.wait_frame()
			frame_count = vm.f32(frame_count + 1.0)
		end
	end
	movement.stop_turning()
	return frame_count
end

--- Waits until the monster faces a heading within a tolerance and returns the frames waited for monsters using the alternative command set.
function movement.wait_until_facing_variant(target_angle_degrees: f32, tolerance_degrees: f32, max_frames: f32)
	local rotation_x: f32 = 0
	local current_angle: f32 = 0
	local rotation_z: f32 = 0
	local frames_waited: f32 = 0
	local frame_limit: f32 = 0
	target_angle_degrees = calc.degrees_to_radians(target_angle_degrees)
	if target_angle_degrees > vm.f32(3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees - vm.f32(6.2831855))
	end
	if target_angle_degrees <= vm.f32(-3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees + vm.f32(6.2831855))
	end
	tolerance_degrees = calc.degrees_to_radians(tolerance_degrees)
	frame_limit = max_frames
	frames_waited = 0.0
	while frames_waited < frame_limit do
		monster.call_command(67, rotation_x, current_angle, rotation_z) -- retail: command 67 is not registered
		if current_angle > vm.f32(target_angle_degrees - tolerance_degrees) and current_angle < vm.f32(target_angle_degrees + tolerance_degrees) then
			movement.hold_current_facing_variant()
			break
		elseif calc.compare_angles(target_angle_degrees, current_angle, tolerance_degrees) == 0 then
			movement.hold_current_facing_variant()
			break
		elseif frames_waited >= max_frames then
			movement.hold_current_facing_variant()
			break
		else
			vm.wait()
			frames_waited = vm.f32(frames_waited + 1.0)
		end
	end
	movement.hold_current_facing_variant()
	return frames_waited
end

--- Waits until the monster faces a heading in degrees within a tolerance, updating model lighting, and returns the frames waited.
function movement.wait_until_facing_with_lighting(target_angle_degrees: f32, speed_degrees: f32, max_frames: f32)
	local current_angle: f32 = 0
	local frame: f32 = 0
	local frame_limit: f32 = 0
	local tolerance: f32 = 0
	target_angle_degrees = calc.degrees_to_radians(target_angle_degrees)
	if target_angle_degrees > vm.f32(3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees - vm.f32(6.2831855))
	end
	if target_angle_degrees <= vm.f32(-3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees + vm.f32(6.2831855))
	end
	speed_degrees = calc.degrees_to_radians(speed_degrees)
	frame_limit = max_frames
	if speed_degrees < 3.0 then
		tolerance = calc.degrees_to_radians(3.0)
	else
		tolerance = speed_degrees
	end
	frame = 0.0
	while frame < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_angle = out2 or current_angle
		end
		if current_angle > vm.f32(target_angle_degrees - tolerance) and current_angle < vm.f32(target_angle_degrees + tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle_degrees, current_angle, speed_degrees) == 0 then
			movement.stop_turning()
			break
		elseif frame >= max_frames then
			movement.stop_turning()
			break
		else
			timer.wait_frame_with_lighting()
			frame = vm.f32(frame + 1.0)
		end
	end
	movement.stop_turning()
	return frame
end

--- Waits until the monster faces a heading or the frame limit passes, and returns the frames waited. It keeps reactions running while waiting.
function movement.wait_until_facing_with_reaction(heading_degrees: f32, turn_speed_degrees: f32, max_frames: f32)
	local current_heading: f32 = 0
	local frame: f32 = 0
	local frame_limit: f32 = 0
	local tolerance: f32 = 0
	heading_degrees = calc.degrees_to_radians(heading_degrees)
	if heading_degrees > vm.f32(3.1415927) then
		heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
	end
	if heading_degrees <= vm.f32(-3.1415927) then
		heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
	end
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	frame_limit = max_frames
	if turn_speed_degrees < 3.0 then
		tolerance = calc.degrees_to_radians(3.0)
	else
		tolerance = turn_speed_degrees
	end
	frame = 0.0
	while frame < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_heading = out2 or current_heading
		end
		if current_heading > vm.f32(heading_degrees - tolerance) and current_heading < vm.f32(heading_degrees + tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(heading_degrees, current_heading, turn_speed_degrees) == 0 then
			movement.stop_turning()
			break
		elseif frame >= max_frames then
			movement.stop_turning()
			break
		else
			timer.wait_frame_with_reaction()
			frame = vm.f32(frame + 1.0)
		end
	end
	movement.stop_turning()
	return frame
end

--- Waits until the current move finishes or the frame limit expires, then stops moving.
function movement.wait_until_move_finished(max_frames: any)
	local arrived: s32 = 0
	arrived = monster.is_move_finished() or arrived
	while arrived == 0 do
		vm.wait()
		arrived = monster.is_move_finished() or arrived
		max_frames = vm.wrap(max_frames - 1)
		if max_frames <= 0 then
			monster.stop_moving()
			return
		end
	end
	monster.stop_moving()
end

--- Waits up to a number of frames for the current move to finish. It does not stop the monster afterwards.
function movement.wait_until_move_finished_without_stopping(max_frames: s32)
	local arrived: s32 = 0
	for i = 0, max_frames - 1 do
		arrived = monster.is_move_finished() or arrived
		if arrived == 0 then
			timer.wait_one_frame()
		else
			return
		end
	end
end

--- Walks forward a distance along a heading without turning first.
function movement.walk_along_heading(step_length: f32, heading_degrees: f32, distance: f32, arrive_distance: f32, height_offset: f32, max_steps: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	heading_degrees = calc.degrees_to_radians(heading_degrees)
	if heading_degrees > vm.f32(3.1415927) then
		heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
	end
	if heading_degrees <= vm.f32(-3.1415927) then
		heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(heading_degrees) * distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(heading_degrees) * distance))
	local _ = movement.walk_to_position(position_x, position_y, position_z, step_length, arrive_distance, height_offset, max_steps)
end

--- Turns toward a point at a radius and angle around a position and walks to it.
function movement.walk_around_position(
	center_x: f32,
	center_y: f32,
	center_z: f32,
	step_length: f32,
	turn_speed_degrees: f32,
	radius: f32,
	angle_offset_degrees: f32,
	arrive_distance: f32,
	height_offset: f32,
	max_steps: s32
)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local offset_radians: f32 = 0
	local angle: f32 = 0
	offset_radians = vm.f32(angle_offset_degrees * vm.f32(0.017453292))
	angle = monster.get_angle_to_position(center_x, center_y, center_z) or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = vm.f32(angle + offset_radians)
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	point_x = vm.f32(center_x + vm.f32(radius * vm.sin(angle)))
	point_y = 0.0
	point_z = vm.f32(center_z + vm.f32(radius * vm.cos(angle)))
	angle_offset_degrees = monster.get_angle_to_position(point_x, point_y, point_z) or angle_offset_degrees
	movement.turn_to_angle(calc.radians_to_degrees(angle_offset_degrees), turn_speed_degrees)
	movement.stop_turning()
	local _ = movement.walk_to_position(point_x, point_y, point_z, step_length, arrive_distance, height_offset, max_steps)
end

--- Walks to a point at a radius and angle around a position until arrival or the frame limit, updating the guard state.
function movement.walk_around_position_guarded(
	center_x: f32,
	center_y: f32,
	center_z: f32,
	speed: f32,
	turn_speed_degrees: f32,
	radius: f32,
	angle_degrees: f32,
	stop_distance: f32,
	max_frames: s32
)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local current_y: f32 = 0
	local offset_radians: f32 = 0
	local angle: f32 = 0
	offset_radians = vm.f32(angle_degrees * vm.f32(0.017453292))
	angle = monster.get_angle_to_position(center_x, center_y, center_z) or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = vm.f32(angle + offset_radians)
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	destination_x = vm.f32(center_x + vm.f32(radius * vm.sin(angle)))
	destination_y = center_y
	destination_z = vm.f32(center_z + vm.f32(radius * vm.cos(angle)))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	angle_degrees = monster.get_angle_to_position(destination_x, destination_y, destination_z) or angle_degrees
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(angle_degrees), turn_speed_degrees)
	movement.stop_turning()
	monster.move_toward_position(destination_x, current_y - 20.0, destination_z, speed, speed)
	local _ = movement.wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
end

--- Walks to a point at a radius and angle around a position and waits until arrival or the frame limit.
function movement.walk_around_position_unguarded(
	center_x: f32,
	center_y: f32,
	center_z: f32,
	speed: f32,
	turn_speed_degrees: f32,
	radius: f32,
	angle_degrees: f32,
	stop_distance: f32,
	max_frames: s32
)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local current_y: f32 = 0
	local offset_radians: f32 = 0
	local angle: f32 = 0
	offset_radians = vm.f32(angle_degrees * vm.f32(0.017453292))
	angle = monster.get_angle_to_position(center_x, center_y, center_z) or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = vm.f32(angle + offset_radians)
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	destination_x = vm.f32(center_x + vm.f32(radius * vm.sin(angle)))
	destination_y = center_y
	destination_z = vm.f32(center_z + vm.f32(radius * vm.cos(angle)))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	angle_degrees = monster.get_angle_to_position(destination_x, destination_y, destination_z) or angle_degrees
	movement.turn_to_angle(calc.radians_to_degrees(angle_degrees), turn_speed_degrees)
	movement.stop_turning()
	monster.move_toward_position(destination_x, current_y - 20.0, destination_z, speed, speed)
	local _ = movement.wait_until_arrived_unguarded(stop_distance, max_frames)
	monster.stop_moving()
end

--- Turns toward and walks to a point at an angle and distance around the target, returning the arrival result or -1 when blocked.
function movement.walk_around_target(speed: f32, turn_speed_degrees: f32, angle_degrees: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local clear_distance: f32 = 0
	local arrival_result: s32 = 0
	destination_x, destination_y, destination_z = movement.get_approach_point(angle_degrees, distance, destination_x, destination_y, destination_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	angle_degrees = monster.get_angle_to_position(destination_x, destination_y, destination_z) or angle_degrees
	if angle_degrees > vm.f32(3.1415927) then
		angle_degrees = vm.f32(angle_degrees - vm.f32(6.2831855))
	end
	if angle_degrees <= vm.f32(-3.1415927) then
		angle_degrees = vm.f32(angle_degrees + vm.f32(6.2831855))
	end
	movement.turn_to_angle(calc.radians_to_degrees(angle_degrees), turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.copy_vector(destination_x, destination_y, destination_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
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
	clear_distance = monster.get_clear_distance(speed + stop_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(speed + stop_distance) then
		destination_x = vm.f32(position_x + vm.f32(vm.sin(angle_degrees) * clear_distance))
		destination_y = position_y
		destination_z = vm.f32(position_z + vm.f32(vm.cos(angle_degrees) * clear_distance))
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance < stop_distance then
			return -1
		end
	end
	monster.move_toward_position(destination_x, position_y - 20.0, destination_z, speed, speed)
	arrival_result = movement.wait_until_arrived_unguarded(stop_distance, max_frames)
	monster.stop_moving()
	return arrival_result
end

--- Turns to a random heading and walks forward a random distance.
function movement.walk_random_heading(
	step_length: f32,
	turn_speed_degrees: f32,
	base_distance: f32,
	heading_range_degrees: f32,
	distance_range: f32,
	arrive_distance: f32,
	height_offset: f32,
	max_steps: s32
)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local heading: f32 = 0
	local distance: f32 = 0
	local heading_degrees: f32 = 0
	distance = monster.get_random_whole_number(distance_range) or distance
	heading_degrees = monster.get_random_whole_number(heading_range_degrees) or heading_degrees
	distance = vm.f32(distance + base_distance)
	movement.turn_to_angle(heading_degrees, turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(heading) * distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(heading) * distance))
	local _ = movement.walk_to_position(position_x, position_y, position_z, step_length, arrive_distance, height_offset, max_steps)
end

--- Turns toward a point at an angle and distance around the target, walks to it and returns the walk result.
function movement.walk_to_point_around_target(step_length: f32, turn_speed_degrees: f32, angle_offset_degrees: f32, distance: f32, arrive_distance: f32, height_offset: f32, max_steps: s32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local result: s32 = 0
	point_x, point_y, point_z = movement.get_approach_point(angle_offset_degrees, distance, point_x, point_y, point_z)
	angle_offset_degrees = monster.get_angle_to_position(point_x, point_y, point_z) or angle_offset_degrees
	if angle_offset_degrees > vm.f32(3.1415927) then
		angle_offset_degrees = vm.f32(angle_offset_degrees - vm.f32(6.2831855))
	end
	if angle_offset_degrees <= vm.f32(-3.1415927) then
		angle_offset_degrees = vm.f32(angle_offset_degrees + vm.f32(6.2831855))
	end
	movement.turn_to_angle(calc.radians_to_degrees(angle_offset_degrees), turn_speed_degrees)
	movement.stop_turning()
	result = movement.walk_to_position(point_x, point_y, point_z, step_length, arrive_distance, height_offset, max_steps)
	return result
end

--- Turns toward a point near the target and walks to it, returning the arrival result or -1 when blocked.
function movement.walk_to_point_near_target(speed: f32, turn_speed_degrees: f32, offset_degrees: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local dest_x: f32 = 0
	local dest_y: f32 = 0
	local dest_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local clear_distance: f32 = 0
	local result: s32 = 0
	dest_x, dest_y, dest_z = movement.get_approach_point(offset_degrees, distance, dest_x, dest_y, dest_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	offset_degrees = monster.get_angle_to_position(dest_x, dest_y, dest_z) or offset_degrees
	if offset_degrees > vm.f32(3.1415927) then
		offset_degrees = vm.f32(offset_degrees - vm.f32(6.2831855))
	end
	if offset_degrees <= vm.f32(-3.1415927) then
		offset_degrees = vm.f32(offset_degrees + vm.f32(6.2831855))
	end
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(offset_degrees), turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.copy_vector(dest_x, dest_y, dest_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
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
	clear_distance = monster.get_clear_distance(speed + stop_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(speed + stop_distance) then
		dest_x = vm.f32(position_x + vm.f32(vm.sin(offset_degrees) * clear_distance))
		dest_y = position_y
		dest_z = vm.f32(position_z + vm.f32(vm.cos(offset_degrees) * clear_distance))
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance < stop_distance then
			return -1
		end
	end
	monster.move_toward_position(dest_x, position_y - 20.0, dest_z, speed, speed)
	result = movement.wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
	return result
end

--- Steps toward a position over the ground and returns 1 on arrival, a negative value when blocked or 0 when the step limit runs out.
function movement.walk_to_position(goal_x: f32, goal_y: f32, goal_z: f32, step_length: f32, arrive_distance: f32, height_offset: f32, max_steps: any)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local heading: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_y: f32 = 0
	local goal_distance: f32 = 0
	local ground_height: f32 = 0
	local step_count: s32 = 0
	local obstacle_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	ground_y = sense.get_ground_height(ground_y)
	goal_y = vm.f32(ground_y + height_offset)
	do
		local out1, out2, out3 = monster.copy_vector(goal_x, goal_y, goal_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, position_x, position_y, position_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_length)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	monster.copy_vector(goal_x, goal_y, goal_z)
	heading = monster.get_angle_to_position(position_x + step_x, position_y + step_y, position_z + step_z) or heading
	step_count = 0
	while step_count < max_steps do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		ground_height = monster.get_height_above_ground_at(position_x, position_y, position_z) or ground_height
		if ground_height >= 25.0 or ground_height <= 0.0 then
			position_y = vm.f32(position_y - step_y)
			step_y = 0.0
		end
		goal_distance = monster.get_distance_between(position_x, position_y, position_z, goal_x, goal_y, goal_z) or goal_distance
		if goal_distance < vm.f32(step_length + arrive_distance) then
			return 1
		end
		obstacle_result = sense.check_flight_destination(position_x, position_y, position_z, step_length, heading)
		if obstacle_result ~= 0 then
			return obstacle_result
		end
		monster.set_position(position_x, position_y, position_z)
		monster.copy_vector(position_x, position_y, position_z)
		timer.wait_one_frame()
		step_count = vm.i32(step_count + 1)
	end
	return 0
end

--- Turns to a heading and walks forward a distance along it.
function movement.walk_toward_heading(turn_speed_degrees: f32, step_length: f32, heading_degrees: f32, distance: f32, arrive_distance: f32, height_offset: f32, max_steps: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	movement.turn_to_angle(heading_degrees, turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(vm.f32(heading_degrees * vm.f32(0.017453292))) * distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(vm.f32(heading_degrees * vm.f32(0.017453292))) * distance))
	local _ = movement.walk_to_position(position_x, position_y, position_z, step_length, arrive_distance, height_offset, max_steps)
end

--- Turns a random amount and walks a random distance if the way is clear.
function movement.wander(speed: f32, turn_speed_degrees: f32, base_distance: f32, turn_range_degrees: f32, distance_range: f32, stop_distance: f32, max_frames: s32)
	local position_y: f32 = 0
	local heading: f32 = 0
	local position_x: f32 = 0
	local position_z: f32 = 0
	local distance: f32 = 0
	local turn_offset: f32 = 0
	local new_angle: f32 = 0
	local clear_distance: f32 = 0
	turn_range_degrees = calc.degrees_to_radians(turn_range_degrees)
	distance = monster.get_random_whole_number(distance_range) or distance
	turn_offset = monster.get_random_whole_number(turn_range_degrees) or turn_offset
	do
		local out1, _, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		new_angle = out2 or new_angle
	end
	new_angle = vm.f32(new_angle + calc.degrees_to_radians(turn_offset))
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(new_angle), turn_speed_degrees)
	movement.stop_turning()
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance == 100.0 then
		distance = vm.f32(distance + vm.f32(base_distance + speed))
		position_x = vm.f32(position_x + vm.f32(distance * vm.sin(heading)))
		position_z = vm.f32(position_z + vm.f32(distance * vm.cos(heading)))
	else
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance > 0.0 then
			position_x = vm.f32(position_x + vm.f32(distance * vm.sin(heading)))
			position_z = vm.f32(position_z + vm.f32(distance * vm.cos(heading)))
		else
			return
		end
	end
	if distance < speed then
		distance = vm.f32(distance + speed)
	end
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(position_x, position_y - 20.0, position_z, speed, speed)
	local _ = movement.wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
end

--- Picks a random walking, turning or waiting behavior that keeps the monster around its home position and near the target.
function movement.wander_around_home()
	local roll: s32 = 0
	local result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle_degrees: f32 = 0
	local home_x: f32 = 0
	local home_y: f32 = 0
	local home_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_angle: f32 = 0
	local clear_distance: f32 = 0
	local arc_angle_degrees: f32 = 0
	local exit_turn_degrees: f32 = 0
	local strafe_angle_degrees: f32 = 0
	local strafe_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
	timer.wait_one_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		home_x = out1 or home_x
		home_y = out2 or home_y
		home_z = out3 or home_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	distance = monster.get_distance_between(position_x, position_y, position_z, home_x, home_y, home_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 64.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", 0.45, 0)
		movement.turn_to_angle(turn_angle_degrees, vm.f32(4.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 64.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction(vm.f32(4.2), 1.75, turn_angle_degrees, clear_distance, 64.0, 30)
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
				arc_angle_degrees = monster.get_random_whole_number(360.0) or arc_angle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					arc_angle_degrees = vm.f32(-arc_angle_degrees - 30.0)
				else
					arc_angle_degrees = vm.f32(arc_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_unguarded(home_x, home_y, home_z, 1.75, vm.f32(4.2), distance, arc_angle_degrees, 64.0, 60)
				exit_turn_degrees = monster.get_random_whole_number(180.0) or exit_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					exit_turn_degrees = vm.f32(exit_turn_degrees * -1.0)
				end
				movement.turn_to_angle(exit_turn_degrees, vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 40 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", 0.45, 0)
			movement.turn_to_angle(turn_angle_degrees, vm.f32(4.2))
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
					strafe_angle_degrees = monster.get_random_whole_number(180.0) or strafe_angle_degrees
					strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
					target_distance = monster.get_target_distance() or target_distance
					strafe_distance = vm.f32(strafe_distance + target_distance)
					if roll < 50 then
						strafe_angle_degrees = vm.f32(strafe_angle_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
					else
						strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					result = movement.walk_around_target(1.75, vm.f32(4.2), strafe_angle_degrees, strafe_distance, 64.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_angle(final_turn_degrees, vm.f32(4.2))
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
					movement.move_in_direction(1.75, turn_angle_degrees, 1000.0, 64.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			movement.wander_unguarded(1.75, vm.f32(4.2), distance, 360.0, 40.0, 64.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Picks a random flying, turning or waiting behavior that keeps the monster around its home position and near the target.
function movement.wander_flying_around_home()
	local roll: s32 = 0
	local result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle: f32 = 0
	local home_x: f32 = 0
	local home_y: f32 = 0
	local home_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_angle: f32 = 0
	local clear_distance: f32 = 0
	local target_y: f32 = 0
	local arc_angle_degrees: f32 = 0
	local exit_turn_degrees: f32 = 0
	local strafe_angle_degrees: f32 = 0
	local strafe_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
	timer.wait_frame()
	roll = monster.get_random(100) or roll
	if roll < 10 then
	else
	end
	monster.set_secondary_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		home_x = out1 or home_x
		home_y = out2 or home_y
		home_z = out3 or home_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	distance = monster.get_distance_between(position_x, position_y, position_z, home_x, home_y, home_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 30.0 then
		print("1------------------------------------------------\n")
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1, 0)
		movement.turn_to_heading(turn_angle, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 30.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_straight(vm.f32(4.8), 1.75, turn_angle, clear_distance, 30.0, 30.0, 30)
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
				do
					local _, out2, _ = monster.get_target_position()
					target_y = out2 or target_y
				end
				monster.set_place_position(position_x, target_y + 30.0, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				print("2------------------------------------------------\n")
				monster.set_secondary_variable(0, 4)
				roll = monster.get_random(100) or roll
				arc_angle_degrees = monster.get_random_whole_number(360.0) or arc_angle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					arc_angle_degrees = vm.f32(-arc_angle_degrees - 30.0)
				else
					arc_angle_degrees = vm.f32(arc_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.move_around_position_with_obstacle_check(home_x, home_y, home_z, 1.75, vm.f32(4.8), distance, arc_angle_degrees, 30.0, 30.0, 60)
				exit_turn_degrees = monster.get_random_whole_number(180.0) or exit_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					exit_turn_degrees = vm.f32(exit_turn_degrees * -1.0)
				end
				movement.turn_to_heading(exit_turn_degrees, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_for_target_engagement(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 40 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_secondary_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_for_target_engagement(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.set_secondary_variable(0, 16)
			turn_angle = monster.get_random_whole_number(180.0) or turn_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle = vm.f32(turn_angle * -1.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_to_heading(turn_angle, vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					print("5------------------------------------------------\n")
					monster.set_secondary_variable(0, 4)
					roll = monster.get_random(100) or roll
					strafe_angle_degrees = monster.get_random_whole_number(180.0) or strafe_angle_degrees
					strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
					target_distance = monster.get_target_distance() or target_distance
					strafe_distance = vm.f32(strafe_distance + target_distance)
					if roll < 50 then
						strafe_angle_degrees = vm.f32(strafe_angle_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
					else
						strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					result = movement.move_around_target(1.75, vm.f32(4.8), strafe_angle_degrees, strafe_distance, 30.0, 30.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_heading(final_turn_degrees, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.set_secondary_variable(0, 32)
					monster.set_motion("歩き", -1, 0)
					do
						local _, out2, _ = monster.get_rotation()
						facing_angle = out2 or facing_angle
					end
					turn_angle = calc.radians_to_degrees(facing_angle)
					if turn_angle > vm.f32(3.1415927) then
						turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
					end
					if turn_angle <= vm.f32(-3.1415927) then
						turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
					end
					movement.move_along_heading_with_obstacle_check(1.75, turn_angle, 1000.0, 30.0, 30.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_for_target_engagement(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			print("7------------------------------------------------\n")
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1, 0)
			movement.approach_with_random_turn(1.75, vm.f32(4.8), distance, 360.0, 40.0, 30.0, 30.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Picks a random wander, turn, orbit or guard behavior near the monster's home position at walking speed 4.2.
function movement.wander_near_home_fast()
	local roll: s32 = 0
	local result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle: f32 = 0
	local home_x: f32 = 0
	local home_y: f32 = 0
	local home_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local yaw: f32 = 0
	local clear_distance: f32 = 0
	local arc_angle: f32 = 0
	local turn_angle_2: f32 = 0
	local orbit_angle: f32 = 0
	local orbit_distance: f32 = 0
	local target_distance: f32 = 0
	local turn_angle_3: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		home_x = out1 or home_x
		home_y = out2 or home_y
		home_z = out3 or home_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	distance = monster.get_distance_between(x, y, z, home_x, home_y, home_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 40.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, vm.f32(4.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 40.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.2), 1.75, turn_angle, clear_distance, 40.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				monster.set_place_position(x, y, z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				arc_angle = monster.get_random_whole_number(360.0) or arc_angle
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					arc_angle = vm.f32(-arc_angle - 30.0)
				else
					arc_angle = vm.f32(arc_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(home_x, home_y, home_z, 1.75, vm.f32(4.2), distance, arc_angle, 40.0, 60)
				turn_angle_2 = monster.get_random_whole_number(180.0) or turn_angle_2
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_angle_2 = vm.f32(turn_angle_2 * -1.0)
				end
				movement.turn_to_angle_and_wait(turn_angle_2, vm.f32(4.2))
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
	if roll < 75 then
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
			movement.turn_to_angle_and_wait(turn_angle, vm.f32(4.2))
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
					orbit_angle = monster.get_random_whole_number(180.0) or orbit_angle
					orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
					target_distance = monster.get_target_distance() or target_distance
					orbit_distance = vm.f32(orbit_distance + target_distance)
					if roll < 50 then
						orbit_angle = vm.f32(orbit_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						orbit_angle = vm.f32(-orbit_angle - 30.0)
					else
						orbit_angle = vm.f32(orbit_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					result = movement.walk_to_point_near_target(1.75, vm.f32(4.2), orbit_angle, orbit_distance, 40.0, 60)
					turn_angle_3 = monster.get_random_whole_number(360.0) or turn_angle_3
					roll = monster.get_random(100) or roll
					if roll < 50 then
						turn_angle_3 = vm.f32(turn_angle_3 * -1.0)
					end
					movement.turn_to_angle_and_wait(turn_angle_3, vm.f32(4.2))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						yaw = out2 or yaw
					end
					turn_angle = calc.radians_to_degrees(yaw)
					if turn_angle > vm.f32(3.1415927) then
						turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
					end
					if turn_angle <= vm.f32(-3.1415927) then
						turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(1.75, turn_angle, 1000.0, 40.0, 60)
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
			movement.wander(1.75, vm.f32(4.2), distance, 360.0, 40.0, 40.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Picks a random wander, turn, orbit or guard behavior near the monster's home position at walking speed 3.0.
function movement.wander_near_home_slow()
	local roll: s32 = 0
	local result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle: f32 = 0
	local home_x: f32 = 0
	local home_y: f32 = 0
	local home_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local yaw: f32 = 0
	local clear_distance: f32 = 0
	local arc_angle: f32 = 0
	local turn_angle_2: f32 = 0
	local orbit_angle: f32 = 0
	local orbit_distance: f32 = 0
	local target_distance: f32 = 0
	local turn_angle_3: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		home_x = out1 or home_x
		home_y = out2 or home_y
		home_z = out3 or home_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	distance = monster.get_distance_between(x, y, z, home_x, home_y, home_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 45.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 45.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.0, 2.0, turn_angle, clear_distance, 45.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				monster.set_place_position(x, y, z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				arc_angle = monster.get_random_whole_number(360.0) or arc_angle
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					arc_angle = vm.f32(-arc_angle - 30.0)
				else
					arc_angle = vm.f32(arc_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(home_x, home_y, home_z, 2.0, 3.0, distance, arc_angle, 45.0, 60)
				turn_angle_2 = monster.get_random_whole_number(180.0) or turn_angle_2
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_angle_2 = vm.f32(turn_angle_2 * -1.0)
				end
				movement.turn_to_angle_and_wait(turn_angle_2, 3.0)
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
	if roll < 70 then
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
			movement.turn_to_angle_and_wait(turn_angle, 3.0)
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
					orbit_angle = monster.get_random_whole_number(180.0) or orbit_angle
					orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
					target_distance = monster.get_target_distance() or target_distance
					orbit_distance = vm.f32(orbit_distance + target_distance)
					if roll < 50 then
						orbit_angle = vm.f32(orbit_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						orbit_angle = vm.f32(-orbit_angle - 30.0)
					else
						orbit_angle = vm.f32(orbit_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					result = movement.walk_to_point_near_target(2.0, 3.0, orbit_angle, orbit_distance, 45.0, 60)
					turn_angle_3 = monster.get_random_whole_number(360.0) or turn_angle_3
					roll = monster.get_random(100) or roll
					if roll < 50 then
						turn_angle_3 = vm.f32(turn_angle_3 * -1.0)
					end
					movement.turn_to_angle_and_wait(turn_angle_3, 3.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						yaw = out2 or yaw
					end
					turn_angle = calc.radians_to_degrees(yaw)
					if turn_angle > vm.f32(3.1415927) then
						turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
					end
					if turn_angle <= vm.f32(-3.1415927) then
						turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(2.0, turn_angle, 1000.0, 45.0, 60)
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
			movement.wander(2.0, 3.0, distance, 360.0, 40.0, 45.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Randomly strafes around the target, watches for it, or plays the idle animation.
function movement.wander_step()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			strafe_angle_degrees = monster.get_random_whole_number(30.0) or strafe_angle_degrees
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 90.0)
			if roll < 50 then
				strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
			else
				strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_around_target(2.0, 3.0, strafe_angle_degrees, distance, 40.0, 30)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(40.0, 45.0, 30)
		end
	else
		motion.play_idle_and_watch_near()
	end
end

--- Randomly strafes around the target slowly, watches for it, or plays the idle animation.
function movement.wander_step_slow()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			strafe_angle_degrees = monster.get_random_whole_number(30.0) or strafe_angle_degrees
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 100.0)
			if roll < 50 then
				strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
			else
				strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_around_target(vm.f32(1.7), 3.0, strafe_angle_degrees, distance, 60.0, 30)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(60.0, 45.0, 30)
		end
	else
		motion.play_idle_and_watch_far()
	end
end

--- Turns a random amount and walks a random distance forward if the path is clear.
function movement.wander_unguarded(speed: f32, turn_speed_degrees: f32, base_distance: f32, turn_range_degrees: f32, distance_range: f32, stop_distance: f32, max_frames: s32)
	local destination_y: f32 = 0
	local heading: f32 = 0
	local destination_x: f32 = 0
	local destination_z: f32 = 0
	local distance: f32 = 0
	local turn_offset: f32 = 0
	local turn_angle: f32 = 0
	local clear_distance: f32 = 0
	turn_range_degrees = calc.degrees_to_radians(turn_range_degrees)
	distance = monster.get_random_whole_number(distance_range) or distance
	turn_offset = monster.get_random_whole_number(turn_range_degrees) or turn_offset
	do
		local out1, _, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		destination_z = out3 or destination_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		turn_angle = out2 or turn_angle
	end
	turn_angle = vm.f32(turn_angle + calc.degrees_to_radians(turn_offset))
	movement.turn_to_angle(calc.radians_to_degrees(turn_angle), turn_speed_degrees)
	movement.stop_turning()
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance == 100.0 then
		distance = vm.f32(distance + vm.f32(base_distance + speed))
		destination_x = vm.f32(destination_x + vm.f32(distance * vm.sin(heading)))
		destination_z = vm.f32(destination_z + vm.f32(distance * vm.cos(heading)))
	else
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance > 0.0 then
			destination_x = vm.f32(destination_x + vm.f32(distance * vm.sin(heading)))
			destination_z = vm.f32(destination_z + vm.f32(distance * vm.cos(heading)))
		else
			return
		end
	end
	if distance < speed then
		distance = vm.f32(distance + speed)
	end
	do
		local _, out2, _ = monster.get_position_3()
		destination_y = out2 or destination_y
	end
	monster.move_toward_position(destination_x, destination_y - 20.0, destination_z, speed, speed)
	local _ = movement.wait_until_arrived_unguarded(stop_distance, max_frames)
	monster.stop_moving()
end

--- Repeats slow wander steps until the target is within 200 units.
function movement.wander_until_target_in_range()
	local target_distance: f32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 200.0 then
			vm.wait()
			return
		end
		movement.wander_step_slow()
	end
end

--- Repeats wander steps until the target is within 175 units.
function movement.wander_until_target_near()
	local target_distance: f32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 175.0 then
			vm.wait()
			return
		end
		movement.wander_step()
	end
end

--- Idles and walks toward the player in a loop until the player is no longer transformed.
function movement.wander_while_player_transformed(unused: any)
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		reaction.update_and_wait_frame()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

return movement
