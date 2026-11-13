--!strict
--- Controls the Masked Tribesman family, melee fighters that guard, charge and dodge.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")

--- Sets the guard and defense variables and how far away the monster stays active.
local function configure_guard_and_clip_distance()
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

--- Returns 1 when the monster faces the target within the given cone half-angle.
local function is_facing_target_within_cone(cone_degrees: f32)
	local rotation_y: f32 = 0
	local target_angle: f32 = 0
	target_angle = monster.get_target_angle() or target_angle
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	if
		rotation_y < vm.f32(target_angle + vm.f32(cone_degrees * vm.f32(0.017453292)))
		and rotation_y > vm.f32(target_angle + vm.f32(-cone_degrees * vm.f32(0.017453292)))
	then
		return 1
	end
	return 0
end

--- Raises the defense rate while the monster faces the target.
local function update_defense_rate_by_facing()
	if is_facing_target_within_cone(80.0) == 0 then
		monster.set_defense_rate(0.5)
	else
		monster.set_defense_rate(10.0)
	end
end

--- Updates the guard timer and defense rate, then waits one frame.
local function tick_guard_and_wait_frame()
	reaction.update_guard_state()
	if reaction.is_guard_active() ~= 0 then
		if reaction.tick_guard_timer() ~= 0 then
			reaction.set_guard_active(0)
		end
	end
	update_defense_rate_by_facing()
	vm.wait()
end

--- Waits until the monster's heading matches the requested heading or the frame limit passes, returning the frames used.
local function turn_until_facing_heading(target_heading: f32, tolerance: f32, max_frames: f32)
	local rotation_y: f32 = 0
	local frames_elapsed: f32 = 0
	local frame_limit: f32 = 0
	local tolerance_radians: f32 = 0
	target_heading = calc.degrees_to_radians(target_heading)
	if target_heading > vm.f32(3.1415927) then
		target_heading = vm.f32(target_heading - vm.f32(6.2831855))
	end
	if target_heading <= vm.f32(-3.1415927) then
		target_heading = vm.f32(target_heading + vm.f32(6.2831855))
	end
	tolerance = calc.degrees_to_radians(tolerance)
	frame_limit = max_frames
	if tolerance < 3.0 then
		tolerance_radians = calc.degrees_to_radians(3.0)
	else
		tolerance_radians = tolerance
	end
	frames_elapsed = 0.0
	while frames_elapsed < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		if rotation_y > vm.f32(target_heading - tolerance_radians) and rotation_y < vm.f32(target_heading + tolerance_radians) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_heading, rotation_y, tolerance) == 0 then
			movement.stop_turning()
			break
		elseif frames_elapsed >= max_frames then
			movement.stop_turning()
			break
		else
			tick_guard_and_wait_frame()
			frames_elapsed = vm.f32(frames_elapsed + 1.0)
		end
	end
	movement.stop_turning()
	return frames_elapsed
end

--- Turns toward the target at the given speed until facing it.
local function turn_toward_target(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = turn_until_facing_heading(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Keeps facing the target for as long as the player stays transformed.
local function face_target_while_player_transformed(monster_id: any)
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		tick_guard_and_wait_frame()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				turn_toward_target(vm.f32(4.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Starts watching the target when the player is transformed.
local function react_to_player_transformation()
	local transform_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		face_target_while_player_transformed(monster_id)
	end
end

--- Turns toward the target for up to a number of frames, returning 1 once facing it.
local function turn_until_facing_target(turn_speed_degrees: f32, max_frames: s32)
	local rot_speed: f32 = 0
	local target_angle: f32 = 0
	rot_speed = vm.f32(turn_speed_degrees * vm.f32(0.017453292))
	for i = 0, max_frames - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		if sense.is_facing_target_within_angle(5.0) ~= 0 then
			return 1
		end
		tick_guard_and_wait_frame()
	end
	movement.stop_turning()
	return 0
end

--- Waits the given number of frames while updating the guard state.
local function wait_frames(frame_count: any)
	local frame: s32 = 0
	frame = 0
	while frame < frame_count do
		tick_guard_and_wait_frame()
		frame = vm.i32(frame + 1)
	end
end

--- Walks toward a point ahead of the target until close enough or out of frames.
local function chase_target_leading(move_speed: f32, rot_speed: f32, stop_distance: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local frame: s32 = 0
	turn_toward_target(rot_speed)
	rot_speed = calc.degrees_to_radians(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
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
		monster.turn_toward_angle(target_angle, rot_speed)
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
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
			local out1, out2, out3 = monster.subtract_vectors(destination_x, destination_y, destination_z, pos_x, pos_y, pos_z)
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
			local out1, out2, out3 = monster.scale_vector(destination_x, destination_y, destination_z, move_speed + stop_distance)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(destination_x, destination_y, destination_z, pos_x, pos_y, pos_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		monster.move_toward_position(destination_x, pos_y - 20.0, destination_z, move_speed, move_speed)
		tick_guard_and_wait_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Waits until the current motion finishes.
local function wait_until_motion_finished()
	local is_finished: s32 = 0
	while true do
		tick_guard_and_wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			return
		end
	end
end

--- Walks up to the target and performs the light attack.
local function perform_light_attack()
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	chase_target_leading(1.75, 6.0, 60.0, 75)
	turn_toward_target(8.0)
	monster.set_motion("攻撃１", -1, 2)
	wait_until_motion_finished()
	monster.set_motion("立ち", -1, 0)
	wait_frames(9)
end

--- Walks straight toward the target until close enough or out of frames.
local function chase_target_directly(move_speed: f32, rot_speed: f32, stop_distance: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local frame: s32 = 0
	rot_speed = calc.degrees_to_radians(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
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
		monster.turn_toward_angle(target_angle, rot_speed)
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		monster.get_rotation()
		monster.move_toward_position(target_x, target_y - 20.0, target_z, move_speed, move_speed)
		tick_guard_and_wait_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Winds up, charges the target with the knockdown attack and recovers.
local function perform_charging_attack()
	monster.set_motion("歩き", -1, 0)
	turn_toward_target(6.0)
	monster.set_motion("攻撃２in", -1, 2)
	wait_until_motion_finished()
	monster.set_motion("攻撃２loop", -1, 0)
	chase_target_directly(vm.f32(3.7), 4.0, 45.0, 90)
	monster.stop_moving()
	monster.set_motion("攻撃２out", -1, 6)
	wait_until_motion_finished()
	monster.set_motion("攻撃２end", -1, 2)
	wait_until_motion_finished()
	monster.set_motion("立ち", -1, 0)
	wait_frames(9)
end

--- Picks an attack or approach depending on how far the target is.
local function choose_attack_by_distance()
	local roll: s32 = 0
	local target_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 75.0 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			if sense.is_facing_target_within_angle(80.0) == 0 then
				monster.set_defense_rate(0.5)
			else
				monster.set_defense_rate(10.0)
			end
			monster.set_motion("歩き", -1, 0)
			if turn_until_facing_target(4.0, 70) ~= 0 then
				monster.set_motion("立ち", -1, 0)
				wait_frames(10)
			end
		else
			perform_light_attack()
		end
		return
	end
	if target_distance >= 75.0 and target_distance < 230.0 then
		roll = monster.get_random(100) or roll
		if roll < 95 then
			monster.set_motion("歩き", -1, 0)
			turn_until_facing_target(4.0, 70)
		else
			monster.set_defense_rate(1.0)
			perform_charging_attack()
		end
	end
end

--- Turns to the given heading at the given speed and waits until facing it.
local function turn_to_heading(next_rot: f32, rot_speed: f32)
	next_rot = calc.degrees_to_radians(next_rot)
	if next_rot > vm.f32(3.1415927) then
		next_rot = vm.f32(next_rot - vm.f32(6.2831855))
	end
	if next_rot <= vm.f32(-3.1415927) then
		next_rot = vm.f32(next_rot + vm.f32(6.2831855))
	end
	rot_speed = calc.degrees_to_radians(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(next_rot, rot_speed)
	local _ = turn_until_facing_heading(
		calc.radians_to_degrees(next_rot),
		calc.radians_to_degrees(rot_speed),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(rot_speed)))
	)
	movement.stop_turning()
end

--- Waits for the move to end, returning 1 when the target is close, 2 when it arrived and 0 on timeout.
local function wait_until_move_finished(stop_distance: f32, max_frames: any)
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
			tick_guard_and_wait_frame()
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

--- Turns to a heading and walks a distance along it.
local function turn_and_walk_in_direction(turn_speed_degrees: f32, move_speed: f32, heading: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local pos_y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	heading = calc.degrees_to_radians(heading)
	if heading < calc.degrees_to_radians(turn_speed_degrees) then
		heading = vm.f32(heading + calc.degrees_to_radians(turn_speed_degrees))
	end
	turn_to_heading(calc.radians_to_degrees(heading), turn_speed_degrees)
	movement.stop_turning()
	if distance < move_speed then
		distance = vm.f32(move_speed + 1.0)
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_x_2 = vm.f32(pos_x_2 + vm.f32(vm.sin(heading) * distance))
	pos_z_2 = vm.f32(pos_z_2 + vm.f32(vm.cos(heading) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(pos_x_2, pos_y - 20.0, pos_z_2, move_speed, move_speed + 1.0)
	local _ = wait_until_move_finished(stop_distance, max_frames)
	monster.stop_moving()
end

--- Walks to a point on a circle around a position.
local function walk_around_position(
	target: f32,
	target_2: f32,
	target_3: f32,
	move_speed: f32,
	turn_speed_degrees: f32,
	radius: f32,
	offset_degrees: f32,
	stop_distance: f32,
	max_frames: s32
)
	local target_4: f32 = 0
	local target_2_2: f32 = 0
	local target_3_2: f32 = 0
	local pos_y: f32 = 0
	local offset_radians: f32 = 0
	local angle: f32 = 0
	offset_radians = vm.f32(offset_degrees * vm.f32(0.017453292))
	angle = monster.get_angle_to_position(target, target_2, target_3) or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = vm.f32(angle + offset_radians)
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	target_4 = vm.f32(target + vm.f32(radius * vm.sin(angle)))
	target_2_2 = target_2
	target_3_2 = vm.f32(target_3 + vm.f32(radius * vm.cos(angle)))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	offset_degrees = monster.get_angle_to_position(target_4, target_2_2, target_3_2) or offset_degrees
	turn_to_heading(calc.radians_to_degrees(offset_degrees), turn_speed_degrees)
	movement.stop_turning()
	monster.move_toward_position(target_4, pos_y - 20.0, target_3_2, move_speed, move_speed)
	local _ = wait_until_move_finished(stop_distance, max_frames)
	monster.stop_moving()
end

--- Waits up to a number of frames until the target threatens the monster, returning 1 when it does.
local function wait_for_target_engagement(attack_range: f32, half_angle_degrees: f32, close_range: f32, min_target_speed: f32, max_frames: s32)
	for i = 0, max_frames - 1 do
		tick_guard_and_wait_frame()
		if sense.is_target_threatening(attack_range, half_angle_degrees, close_range, min_target_speed) == 1 then
			return 1
		end
	end
	return 0
end

--- Walks to a point at an angle around the target, stopping short if a wall is in the way.
local function walk_around_target(move_speed: f32, turn_speed_degrees: f32, approach_angle: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local approach_x: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local clear_distance: f32 = 0
	local move_result: s32 = 0
	approach_x, target_2, target_3 = movement.get_approach_point(approach_angle, distance, approach_x, target_2, target_3)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	approach_angle = monster.get_angle_to_position(approach_x, target_2, target_3) or approach_angle
	if approach_angle > vm.f32(3.1415927) then
		approach_angle = vm.f32(approach_angle - vm.f32(6.2831855))
	end
	if approach_angle <= vm.f32(-3.1415927) then
		approach_angle = vm.f32(approach_angle + vm.f32(6.2831855))
	end
	turn_to_heading(calc.radians_to_degrees(approach_angle), turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.copy_vector(approach_x, target_2, target_3) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, pos_x, pos_y, pos_z)
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
	clear_distance = monster.get_clear_distance(move_speed + stop_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(move_speed + stop_distance) then
		approach_x = vm.f32(pos_x + vm.f32(vm.sin(approach_angle) * clear_distance))
		target_2 = pos_y
		target_3 = vm.f32(pos_z + vm.f32(vm.cos(approach_angle) * clear_distance))
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance < stop_distance then
			return -1
		end
	end
	monster.move_toward_position(approach_x, pos_y - 20.0, target_3, move_speed, move_speed)
	move_result = wait_until_move_finished(stop_distance, max_frames)
	monster.stop_moving()
	return move_result
end

--- Walks a distance along a heading.
local function walk_in_direction(move_speed: f32, heading_degrees: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local pos_y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
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
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_x_2 = vm.f32(pos_x_2 + vm.f32(vm.sin(heading_degrees) * distance))
	pos_z_2 = vm.f32(pos_z_2 + vm.f32(vm.cos(heading_degrees) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(pos_x_2, pos_y, pos_z_2, move_speed, move_speed + 1.0)
	wait_until_move_finished(stop_distance, max_frames)
	monster.stop_moving()
end

--- Walks a random distance along a randomly turned heading unless a wall is close.
local function wander_randomly(move_speed: f32, turn_speed_degrees: f32, base_distance: f32, range: f32, range_2: f32, stop_distance: f32, max_frames: s32)
	local pos_y: f32 = 0
	local final_rotation_y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local distance: f32 = 0
	local angle_offset: f32 = 0
	local heading: f32 = 0
	local clear_distance: f32 = 0
	range = calc.degrees_to_radians(range)
	distance = monster.get_random_whole_number(range_2) or distance
	angle_offset = monster.get_random_whole_number(range) or angle_offset
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x_2 = out1 or pos_x_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	heading = vm.f32(heading + calc.degrees_to_radians(angle_offset))
	turn_to_heading(calc.radians_to_degrees(heading), turn_speed_degrees)
	movement.stop_turning()
	do
		local _, out2, _ = monster.get_rotation()
		final_rotation_y = out2 or final_rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance == 100.0 then
		distance = vm.f32(distance + vm.f32(base_distance + move_speed))
		pos_x_2 = vm.f32(pos_x_2 + vm.f32(distance * vm.sin(final_rotation_y)))
		pos_z_2 = vm.f32(pos_z_2 + vm.f32(distance * vm.cos(final_rotation_y)))
	else
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance > 0.0 then
			pos_x_2 = vm.f32(pos_x_2 + vm.f32(distance * vm.sin(final_rotation_y)))
			pos_z_2 = vm.f32(pos_z_2 + vm.f32(distance * vm.cos(final_rotation_y)))
		else
			return
		end
	end
	if distance < move_speed then
		distance = vm.f32(distance + move_speed)
	end
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(pos_x_2, pos_y - 20.0, pos_z_2, move_speed, move_speed)
	local _ = wait_until_move_finished(stop_distance, max_frames)
	monster.stop_moving()
end

--- Picks a wandering, waiting or turning behavior while the target is far away.
local function choose_idle_behavior()
	local roll: s32 = 0
	local engagement_result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local heading_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local circle_degrees: f32 = 0
	local turn_degrees: f32 = 0
	local side_degrees: f32 = 0
	local orbit_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
	tick_guard_and_wait_frame()
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
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 60.0 then
		heading_degrees = monster.get_random_whole_number(360.0) or heading_degrees
		monster.set_motion("歩き", -1.0, 0)
		turn_to_heading(heading_degrees, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 60.0)
		if clear_distance > 0.0 then
			turn_and_walk_in_direction(vm.f32(4.8), 1.75, heading_degrees, clear_distance, 60.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 800.0 then
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
				circle_degrees = monster.get_random_whole_number(360.0) or circle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					circle_degrees = vm.f32(-circle_degrees - 30.0)
				else
					circle_degrees = vm.f32(circle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				walk_around_position(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), distance, circle_degrees, 60.0, 60)
				turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_degrees = vm.f32(turn_degrees * -1.0)
				end
				turn_to_heading(turn_degrees, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				engagement_result = wait_for_target_engagement(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if engagement_result == 1 then
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
			wait_for_target_engagement(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			heading_degrees = monster.get_random_whole_number(180.0) or heading_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				heading_degrees = vm.f32(heading_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			turn_to_heading(heading_degrees, vm.f32(4.8))
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
					side_degrees = monster.get_random_whole_number(180.0) or side_degrees
					orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
					target_distance = monster.get_target_distance() or target_distance
					orbit_distance = vm.f32(orbit_distance + target_distance)
					if roll < 50 then
						side_degrees = vm.f32(side_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						side_degrees = vm.f32(-side_degrees - 30.0)
					else
						side_degrees = vm.f32(side_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					engagement_result = walk_around_target(1.75, vm.f32(4.8), side_degrees, orbit_distance, 60.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					turn_to_heading(final_turn_degrees, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					heading_degrees = calc.radians_to_degrees(rotation_y)
					if heading_degrees > vm.f32(3.1415927) then
						heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
					end
					if heading_degrees <= vm.f32(-3.1415927) then
						heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
					end
					walk_in_direction(1.75, heading_degrees, 1000.0, 60.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				engagement_result = wait_for_target_engagement(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if engagement_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			wander_randomly(1.75, vm.f32(4.8), distance, 360.0, 40.0, 60.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Turns toward the target and walks closer while keeping the guard up.
local function reposition_while_guarding()
	monster.set_motion("歩き", -1, 0)
	turn_until_facing_target(4.0, 90)
	monster.set_motion("歩き", -1, 0)
	chase_target_directly(1.75, 4.0, 45.0, 30)
	monster.set_motion("立ち", -1, 0)
end

--- Picks an attack or approach depending on guard state and target distance.
local function choose_action()
	local target_distance: f32 = 0
	local guard_range: f32 = 0
	react_to_player_transformation()
	target_distance = monster.get_target_distance() or target_distance
	if reaction.is_guard_active() == 0 then
		if target_distance < 230.0 then
			choose_attack_by_distance()
		else
			monster.set_defense_rate(1.0)
			choose_idle_behavior()
		end
	else
		guard_range = state.get_secondary_float(guard_range)
		if target_distance < guard_range then
			if target_distance < 135.0 then
				reaction.set_guard_active(0)
				choose_attack_by_distance()
			else
				reposition_while_guarding()
			end
		else
			reaction.set_guard_active(0)
		end
	end
end

--- Locks the monster, stops it and snaps it to face the target.
local function lock_and_face_target()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	tick_guard_and_wait_frame()
	monster.set_action_status(1)
end

--- Steps backward away from the target with collision disabled.
local function dodge_backward()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	rotation_y = vm.f32(rotation_y + vm.f32(3.1415927))
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(rotation_y)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(rotation_y)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 6)
	wait_frames(calc.pass_through(8))
	monster.move_toward_position(pos_x, pos_y, pos_z, 1.75, 1.75)
	wait_frames(calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	wait_until_motion_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Steps to a random side with collision disabled.
local function dodge_sideways()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local step_distance: f32 = 0
	local roll: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ左", -1, 6)
		rotation_y = vm.f32(rotation_y + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 6)
		rotation_y = vm.f32(rotation_y - vm.f32(1.5707964))
	end
	step_distance = 100.0
	target = vm.f32(pos_x + vm.f32(vm.sin(rotation_y) * step_distance))
	target_2 = vm.f32(pos_y - 20.0)
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(rotation_y) * step_distance))
	wait_frames(calc.pass_through(8))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target, target_2, target_3, 1.75, 1.75)
	wait_frames(calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	wait_until_motion_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Waits forever while updating the guard state.
local function wait_forever()
	while true do
		tick_guard_and_wait_frame()
	end
end

--- Clears collision flags and ends a throw.
local function finish_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	wait_frames(10)
	monster.reset_motion()
end

local script = {}

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Registers the weak and knockdown attack hits and sets the monster up.
function script.init()
	local monster_grade: s32 = 0
	monster.register_damage_hit("弱攻撃", 8.0, "攻撃１", 0.365, 0.487, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 10.0, "攻撃２loop", 0.0, 1.0, 1)
	monster.set_variable(0, 0)
	monster_grade = monster.get_monster_grade_2(-1) or monster_grade
	if monster_grade == 0 then
		monster.set_photo_opportunity("攻撃１", 0.122, 0.457, 1021)
	end
	configure_guard_and_clip_distance()
end

--- Repeatedly chooses an action based on the target.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		tick_guard_and_wait_frame()
		choose_action()
	end
end

--- Freezes the monster in a damage pose until its status ailment wears off.
function script.on_status_hit()
	local has_status_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status_ailment = 1
	while has_status_ailment ~= 0 do
		has_status_ailment = monster.get_status_ailments(40) or has_status_ailment
		tick_guard_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage reaction and recovers.
function script.on_damage()
	state.stop_and_clear_action()
	if sense.is_facing_target_within_angle(60.0) == 0 then
		monster.set_defense_rate(0.5)
	else
		monster.set_defense_rate(10.0)
	end
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	monster.set_monster_attributes(32, 1)
	wait_until_motion_finished()
	wait_frames(6)
	monster.set_monster_attributes(32, 0)
	wait_frames(6)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown, lies on the ground and gets back up.
function script.on_knockdown()
	lock_and_face_target()
	monster.set_defense_rate(1.0)
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	wait_until_motion_finished()
	monster.set_action_status(1)
	wait_frames(10)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	wait_until_motion_finished()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Turns to the target and holds the guard pose briefly.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("歩き", -1, 0)
	turn_toward_target(20.0)
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	wait_frames(8)
	state.unlock()
end

--- Faces the target and steps backward.
function script.on_dodge_1()
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, target_angle, 0.0)
	tick_guard_and_wait_frame()
	dodge_backward()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Faces the target and steps to the side.
function script.on_dodge_2()
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, target_angle, 0.0)
	tick_guard_and_wait_frame()
	dodge_sideways()
	monster.set_motion("歩き", -1, 0)
	turn_toward_target(4.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the death animation and death effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while held.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		tick_guard_and_wait_frame()
	end
	wait_forever()
end

--- Recovers after landing from a throw.
function script.on_land()
	finish_throw()
	monster.stop_moving()
	monster.end_throw()
	wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	wait_until_motion_finished()
	state.do_nothing_hook()
	return 1
end

--- Falls, recovers and stays stunned until the stun ends.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_defense_rate(1.0)
	monster.set_motion("吹っ飛び", -1, 6)
	wait_until_motion_finished()
	monster.set_motion("起き上がり", -1, 6)
	wait_until_motion_finished()
	reaction.stun_until_recovered()
end

return script
