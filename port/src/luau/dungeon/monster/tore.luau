--!strict
--- Drives the Tore family of tree monsters that slash at the player and summon small trees.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")

--- Stores the current dungeon time in a numbered slot.
local function mark_time(slot: s32)
	local timestamp: s32 = 0
	timestamp = monster.get_dungeon_timer() or timestamp
	monster.set_variable(vm.i32(3 + slot), timestamp)
end

--- Sets the monster's guard, secondary variables and clip distance.
local function initialize_monster_settings()
	local is_boss: s32 = 0
	state.set_unknown_float_8(500.0)
	state.set_unknown_float_9(80.0)
	reaction.set_guard_damage_threshold(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	is_boss = monster.is_boss() or is_boss
	if is_boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Updates the guard state and waits one frame.
local function update_guard_and_wait_frame()
	reaction.update_guard_state()
	if reaction.is_guard_active() ~= 0 then
		if reaction.tick_guard_timer() ~= 0 then
			reaction.set_guard_active(0)
		end
	end
	state.do_nothing()
	vm.wait()
end

--- Waits until the monster faces the given rotation or runs out of frames and returns the frames used.
local function wait_until_facing(target_rotation: f32, tolerance: f32, max_frames: f32)
	local current_rotation: f32 = 0
	local frame_count: f32 = 0
	local frame_limit: f32 = 0
	local tolerance_limit: f32 = 0
	target_rotation = calc.degrees_to_radians(target_rotation)
	if target_rotation > vm.f32(3.1415927) then
		target_rotation = vm.f32(target_rotation - vm.f32(6.2831855))
	end
	if target_rotation <= vm.f32(-3.1415927) then
		target_rotation = vm.f32(target_rotation + vm.f32(6.2831855))
	end
	tolerance = calc.degrees_to_radians(tolerance)
	frame_limit = max_frames
	if tolerance < 3.0 then
		tolerance_limit = calc.degrees_to_radians(3.0)
	else
		tolerance_limit = tolerance
	end
	frame_count = 0.0
	while frame_count < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_rotation = out2 or current_rotation
		end
		if current_rotation > vm.f32(target_rotation - tolerance_limit) and current_rotation < vm.f32(target_rotation + tolerance_limit) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_rotation, current_rotation, tolerance) == 0 then
			movement.stop_turning()
			break
		elseif frame_count >= max_frames then
			movement.stop_turning()
			break
		else
			update_guard_and_wait_frame()
			frame_count = vm.f32(frame_count + 1.0)
		end
	end
	movement.stop_turning()
	return frame_count
end

--- Turns toward the target and waits until it faces it.
local function turn_toward_target_and_wait(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Keeps facing the player while the player stays transformed.
local function face_transformed_player(monster_kind: any)
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		update_guard_and_wait_frame()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				turn_toward_target_and_wait(3.5)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Turns to face the player while the player is transformed.
local function watch_transformed_player()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		face_transformed_player(monster_kind)
	end
end

--- Turns to the given rotation at the given speed and waits until it arrives.
local function turn_to_rotation_and_wait(target_rotation: f32, turn_speed: f32)
	target_rotation = calc.degrees_to_radians(target_rotation)
	if target_rotation > vm.f32(3.1415927) then
		target_rotation = vm.f32(target_rotation - vm.f32(6.2831855))
	end
	if target_rotation <= vm.f32(-3.1415927) then
		target_rotation = vm.f32(target_rotation + vm.f32(6.2831855))
	end
	turn_speed = calc.degrees_to_radians(turn_speed)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(target_rotation, turn_speed)
	local _ = wait_until_facing(
		calc.radians_to_degrees(target_rotation),
		calc.radians_to_degrees(turn_speed),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(turn_speed)))
	)
	movement.stop_turning()
end

--- Waits until the monster arrives or comes within the stop distance of the target and returns why it stopped.
local function wait_until_arrived(stop_distance: f32, max_frames: any)
	local frame_count: s32 = 0
	local has_arrived: s32 = 0
	local target_distance: f32 = 0
	frame_count = 0
	while frame_count < max_frames do
		has_arrived = monster.is_move_finished() or has_arrived
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			monster.stop_moving()
			return 1
		end
		if has_arrived == 0 then
			update_guard_and_wait_frame()
		else
			monster.stop_moving()
			return 2
		end
		if has_arrived == 1 then
			monster.stop_moving()
			return 1
		end
		frame_count = vm.i32(frame_count + 1)
	end
	return 0
end

--- Turns toward and walks to a point around the target, stopping early when blocked.
local function walk_to_point_near_target(move_speed: f32, turn_speed: f32, angle: f32, distance: f32, stop_distance: f32, max_frames: s32)
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
	local result: s32 = 0
	destination_x, destination_y, destination_z = movement.get_approach_point(angle, distance, destination_x, destination_y, destination_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	angle = monster.get_angle_to_position(destination_x, destination_y, destination_z) or angle
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	turn_to_rotation_and_wait(calc.radians_to_degrees(angle), turn_speed)
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
	clear_distance = monster.get_clear_distance(move_speed + stop_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(move_speed + stop_distance) then
		destination_x = vm.f32(position_x + vm.f32(vm.sin(angle) * clear_distance))
		destination_y = position_y
		destination_z = vm.f32(position_z + vm.f32(vm.cos(angle) * clear_distance))
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance < stop_distance then
			return -1
		end
	end
	monster.move_toward_position(destination_x, position_y - 20.0, destination_z, move_speed, move_speed)
	result = wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
	return result
end

--- Waits until the target is in front of the monster and returns whether it was.
local function wait_until_target_in_front(distance: f32, angle_degrees: f32, max_frames: s32)
	for frame = 0, max_frames - 1 do
		monster.get_rotation()
		monster.get_target_distance()
		monster.get_target_angle()
		update_guard_and_wait_frame()
		if sense.is_target_in_front(distance, angle_degrees) == 1 then
			return 1
		end
	end
	return 0
end

--- Walks to a point beside the target or waits for it to come in front.
local function sidestep_or_wait()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance_offset: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_offset = monster.get_random_whole_number(30.0) or side_offset
		distance_offset = monster.get_random_whole_number(30.0) or distance_offset
		distance_offset = vm.f32(distance_offset + 120.0)
		if roll < 50 then
			side_offset = vm.f32(-side_offset - 30.0)
		else
			side_offset = vm.f32(side_offset + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = walk_to_point_near_target(vm.f32(1.8), 3.5, side_offset, distance_offset, 80.0, 30)
		turn_toward_target_and_wait(3.5)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		wait_until_target_in_front(80.0, 45.0, 30)
	end
end

--- Sweeps left and right looking for the target.
local function look_around_for_target(sweep_degrees: f32, turn_speed: f32, watch_frames: s32, watch_distance: f32)
	local current_rotation: f32 = 0
	local sweep_rotation: f32 = 0
	sweep_degrees = calc.degrees_to_radians(sweep_degrees)
	do
		local _, out2, _ = monster.get_rotation()
		current_rotation = out2 or current_rotation
	end
	monster.set_motion("歩き", -1.0, 0)
	sweep_rotation = vm.f32(current_rotation + sweep_degrees)
	turn_to_rotation_and_wait(calc.radians_to_degrees(sweep_rotation), turn_speed)
	monster.set_motion("立ち", -1, 0)
	if wait_until_target_in_front(watch_distance, 80.0, watch_frames) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		current_rotation = out2 or current_rotation
	end
	monster.set_motion("歩き", -1.0, 0)
	sweep_rotation = vm.f32(current_rotation - sweep_degrees)
	turn_to_rotation_and_wait(calc.radians_to_degrees(sweep_rotation), turn_speed)
	monster.set_motion("立ち", -1, 0)
	if wait_until_target_in_front(watch_distance, 80.0, watch_frames) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		current_rotation = out2 or current_rotation
	end
	monster.set_motion("歩き", -1.0, 0)
	sweep_rotation = vm.f32(current_rotation - sweep_degrees)
	turn_to_rotation_and_wait(calc.radians_to_degrees(sweep_rotation), turn_speed)
	monster.set_motion("立ち", -1, 0)
	if wait_until_target_in_front(watch_distance, 80.0, watch_frames) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		current_rotation = out2 or current_rotation
	end
	monster.set_motion("歩き", -1.0, 0)
	sweep_rotation = vm.f32(current_rotation + sweep_degrees)
	turn_to_rotation_and_wait(calc.radians_to_degrees(sweep_rotation), turn_speed)
	monster.set_motion("立ち", -1, 0)
	if wait_until_target_in_front(watch_distance, 80.0, watch_frames) == 1 then
		return 0
	end
	return 0
end

--- Walks toward the target while turning to follow it until it is within the stop distance.
local function chase_target(move_speed: f32, turn_speed: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local frame_count: s32 = 0
	turn_toward_target_and_wait(turn_speed)
	turn_speed = calc.degrees_to_radians(turn_speed)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	frame_count = 0
	while frame_count < max_frames do
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
		do
			local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, move_speed + stop_distance)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		monster.move_toward_position(direction_x, position_y - 20.0, direction_z, move_speed, move_speed)
		update_guard_and_wait_frame()
		frame_count = frame_count + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Waits the given number of frames.
local function wait_frames(frames: s32)
	for frame = 0, frames - 1 do
		update_guard_and_wait_frame()
	end
end

--- Stops and stands still for the given number of frames.
local function stand_still(frames: s32)
	monster.stop_moving()
	monster.reset_motion()
	monster.set_motion("立ち", -1, 4)
	wait_frames(frames)
end

--- Looks around, waits or approaches when the target is at long range.
local function act_at_long_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 40 then
		if look_around_for_target(45.0, 3.5, 60, 200.0) == 1 then
			monster.set_motion("歩き", -1.0, 0)
			turn_toward_target_and_wait(3.5)
			monster.set_motion("歩き", -1.0, 0)
			chase_target(vm.f32(1.8), 3.5, 80.0, 45)
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("待機", -1, 0)
			if wait_until_target_in_front(310.0, 45.0, 75) == 1 then
				monster.set_motion("歩き", -1.0, 0)
				turn_toward_target_and_wait(3.5)
				monster.set_motion("歩き", -1.0, 0)
				chase_target(vm.f32(1.8), 3.5, 80.0, 45)
				monster.set_motion("立ち", -1, 0)
			end
		else
			stand_still(30)
		end
	end
	update_guard_and_wait_frame()
end

--- Turns toward the target, sometimes offset to one side.
local function turn_toward_target_with_offset(turn_speed: f32, offset_degrees: f32, offset_chance: s32)
	local target_angle: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	target_angle = monster.get_target_angle() or target_angle
	offset_degrees = calc.degrees_to_radians(offset_degrees)
	turn_speed = calc.degrees_to_radians(turn_speed)
	if roll < offset_chance then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			target_angle = vm.f32(target_angle + offset_degrees)
		else
			target_angle = vm.f32(target_angle - offset_degrees)
		end
	end
	monster.turn_toward_angle(target_angle, turn_speed)
	local _ = wait_until_facing(calc.radians_to_degrees(target_angle), calc.radians_to_degrees(turn_speed), 360.0)
	movement.stop_turning()
end

--- Returns the dungeon time elapsed since the numbered slot was marked.
local function get_time_since_mark(slot: s32)
	local current_time: s32 = 0
	local marked_time: s32 = 0
	current_time = monster.get_dungeon_timer() or current_time
	marked_time = monster.get_variable(vm.i32(3 + slot)) or marked_time
	current_time = vm.i32(current_time - marked_time)
	return current_time
end

--- Waits until the current motion finishes.
local function wait_until_motion_finished()
	local is_finished: s32 = 0
	while true do
		update_guard_and_wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			return
		end
	end
end

--- Performs the first attack and returns to standing.
local function slash_attack()
	monster.set_motion("攻撃１", -1, 2)
	wait_until_motion_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Waits until the motion reaches the given progress or finishes.
local function wait_until_motion_progress(target_progress: f32, tolerance: f32)
	local progress: f32 = 0
	local frame_count: s32 = 0
	local is_finished: s32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.03)
	end
	frame_count = 0
	while true do
		update_guard_and_wait_frame()
		progress = monster.get_motion_progress() or progress
		if progress < vm.f32(target_progress + tolerance) and progress > vm.f32(target_progress - tolerance) then
			break
		else
			is_finished = monster.is_motion_finished() or is_finished
			if is_finished ~= 0 then
				break
			else
				frame_count = vm.i32(frame_count + 1)
			end
		end
	end
end

--- Calls out a puff of smoke and spawns small tree monsters around itself.
local function summon_kotores()
	local roll: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local spawn_index: s32 = 0
	local monster_count: s32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
	local spawn_rotation: f32 = 0
	local grade: s32 = 0
	if get_time_since_mark(0) < 300 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("立ち", -1, 0)
			wait_frames(15)
		else
			monster.set_motion("歩き", -1, 0)
			chase_target(vm.f32(1.8), 7.0, 80.0, 90)
			turn_toward_target_and_wait(3.5)
			slash_attack()
		end
	end
	mark_time(0)
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	wait_until_motion_progress(vm.f32(0.412), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol00")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.create_effect_1("トーレの煙")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	wait_frames(11)
	monster_count = monster.get_monster_count() or monster_count
	if monster_count < 18 then
		monster.get_random(3, roll)
		spawn_index = 0
		roll = vm.i32(roll + 1)
		while spawn_index < 3 do
			monster.set_monster_attributes(16, 1)
			do
				local out1, out2, out3 = monster.get_position_3()
				position_x_2 = out1 or position_x_2
				position_y_2 = out2 or position_y_2
				position_z_2 = out3 or position_z_2
			end
			do
				local _, out2, _ = monster.get_rotation()
				spawn_rotation = out2 or spawn_rotation
			end
			do
				local out1, out2, out3 = monster.get_point_from_facing(0.0, 10.0)
				position_x_2 = out1 or position_x_2
				position_y_2 = out2 or position_y_2
				position_z_2 = out3 or position_z_2
			end
			grade = monster.get_monster_grade_2(-1) or grade
			monster.create_monster(vm.i32(16 + grade), position_x_2, position_y_2, position_z_2, spawn_rotation)
			update_guard_and_wait_frame()
			spawn_index = spawn_index + 1
		end
	end
	wait_until_motion_finished()
	wait_frames(15)
	monster.set_monster_attributes(16, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Turns toward the target and walks straight toward it until it is within the stop distance.
local function walk_toward_target(move_speed: f32, turn_speed: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local destination_x: f32 = 0
	local destination_z: f32 = 0
	local current_rotation: f32 = 0
	local target_distance: f32 = 0
	local clear_distance: f32 = 0
	turn_toward_target_and_wait(turn_speed)
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
		current_rotation = out2 or current_rotation
	end
	destination_x = vm.f32(position_x + vm.f32(vm.sin(current_rotation) * target_distance))
	destination_z = vm.f32(position_z + vm.f32(vm.cos(current_rotation) * target_distance))
	monster.move_toward_position(destination_x, position_y - 20.0, destination_z, move_speed, stop_distance + move_speed)
	local _ = wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
end

--- Turns by a random angle and walks a random distance if the way is clear.
local function wander_randomly(move_speed: f32, turn_speed: f32, base_distance: f32, turn_range: f32, distance_range: f32, stop_distance: f32, max_frames: s32)
	local position_y: f32 = 0
	local current_rotation: f32 = 0
	local position_x_2: f32 = 0
	local position_z_2: f32 = 0
	local move_distance: f32 = 0
	local turn_offset: f32 = 0
	local target_rotation: f32 = 0
	local clear_distance: f32 = 0
	turn_range = calc.degrees_to_radians(turn_range)
	move_distance = monster.get_random_whole_number(distance_range) or move_distance
	turn_offset = monster.get_random_whole_number(turn_range) or turn_offset
	do
		local out1, _, out3 = monster.get_position_3()
		position_x_2 = out1 or position_x_2
		position_z_2 = out3 or position_z_2
	end
	do
		local _, out2, _ = monster.get_rotation()
		target_rotation = out2 or target_rotation
	end
	target_rotation = vm.f32(target_rotation + calc.degrees_to_radians(turn_offset))
	turn_to_rotation_and_wait(calc.radians_to_degrees(target_rotation), turn_speed)
	movement.stop_turning()
	do
		local _, out2, _ = monster.get_rotation()
		current_rotation = out2 or current_rotation
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance == 100.0 then
		move_distance = vm.f32(move_distance + vm.f32(base_distance + move_speed))
		position_x_2 = vm.f32(position_x_2 + vm.f32(move_distance * vm.sin(current_rotation)))
		position_z_2 = vm.f32(position_z_2 + vm.f32(move_distance * vm.cos(current_rotation)))
	else
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance > 0.0 then
			position_x_2 = vm.f32(position_x_2 + vm.f32(move_distance * vm.sin(current_rotation)))
			position_z_2 = vm.f32(position_z_2 + vm.f32(move_distance * vm.cos(current_rotation)))
		else
			return
		end
	end
	if move_distance < move_speed then
		move_distance = vm.f32(move_distance + move_speed)
	end
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(position_x_2, position_y - 20.0, position_z_2, move_speed, move_speed)
	local _ = wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
end

--- Summons, approaches or wanders when the target is at medium range.
local function act_at_medium_range()
	local roll: s32 = 0
	local roll_2: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 40 then
		roll_2 = monster.get_monster_count() or roll_2
		if roll_2 < 18 then
			monster.set_motion("歩き", -1.0, 0)
			turn_toward_target_with_offset(7.0, 30.0, 15)
			summon_kotores()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1.0, 0)
			turn_toward_target_and_wait(3.5)
			monster.set_motion("歩き", -1.0, 0)
			walk_toward_target(vm.f32(1.8), 3.5, 80.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("歩き", -1.0, 0)
				wander_randomly(vm.f32(1.8), 3.5, 40.0, 180.0, 30.0, 80.0, 40)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				wait_until_target_in_front(150.0, 45.0, 45)
			end
		end
	end
	update_guard_and_wait_frame()
end

--- Walks in the given direction for the given distance.
local function walk_in_direction(move_speed: f32, angle_degrees: f32, distance: f32, stop_distance: f32, max_frames: s32)
	local position_y: f32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
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
		position_x_2 = out1 or position_x_2
		position_y_2 = out2 or position_y_2
		position_z_2 = out3 or position_z_2
	end
	position_x_2 = vm.f32(position_x_2 + vm.f32(vm.sin(angle_degrees) * distance))
	position_z_2 = vm.f32(position_z_2 + vm.f32(vm.cos(angle_degrees) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(position_x_2, position_y, position_z_2, move_speed, move_speed + 1.0)
	wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
end

--- Attacks, chases or walks away when the target is close.
local function act_at_close_range()
	local roll: s32 = 0
	local target_angle: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		monster.set_motion("歩き", -1.0, 0)
		turn_toward_target_and_wait(3.5)
		slash_attack()
	else
		monster.get_target_distance()
		roll = monster.get_random(100) or roll
		if roll < 45 then
			monster.set_motion("歩き", -1.0, 0)
			turn_toward_target_and_wait(3.5)
			monster.set_motion("歩き", -1.0, 0)
			chase_target(vm.f32(1.8), 3.5, 80.0, 50)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("立ち", -1, 0)
				wait_until_target_in_front(120.0, 30.0, 45)
			else
				monster.set_motion("歩き", -1.0, 0)
				turn_toward_target_and_wait(3.5)
				target_angle = monster.get_target_angle() or target_angle
				monster.set_motion("歩き", -1.0, 0)
				walk_in_direction(vm.f32(1.8), calc.radians_to_degrees(target_angle), 100.0, 360.0, 45)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Fights the target by distance until it moves away or the rage hits run out.
local function fight_target_nearby()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		update_guard_and_wait_frame()
		watch_transformed_player()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 360.0 then
			monster.set_variable(0, 0)
			update_guard_and_wait_frame()
			return
		elseif target_distance > 120.0 then
			monster.set_variable(0, 0)
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left <= 0 then
			update_guard_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			sidestep_or_wait()
			continue
		end
		if target_distance < 360.0 and target_distance >= 200.0 then
			act_at_long_range()
		elseif target_distance < 200.0 and target_distance >= 120.0 then
			act_at_medium_range()
		else
			act_at_close_range()
		end
		update_guard_and_wait_frame()
	end
end

--- Waits until the target comes close and then turns to face it.
local function wait_for_target_to_approach()
	local target_distance: f32 = 0
	local has_noticed_target: s32 = 0
	monster.set_variable(0, 0)
	while true do
		update_guard_and_wait_frame()
		target_distance = monster.get_target_distance() or target_distance
		-- retail: monster.set_variable(0, value) does nothing, since its handler stores only an integer or a float
		if target_distance < 220.0 and has_noticed_target == 0 then
			monster.set_motion("立ち", -1, 0)
			monster.set_motion("歩き", -1.0, 0)
			turn_toward_target_and_wait(vm.f32(2.45))
			monster.set_motion("立ち", -1, 0)
			update_guard_and_wait_frame()
			monster.set_variable(0, 1)
			return
		end
		has_noticed_target = monster.get_variable(0) or has_noticed_target
		if has_noticed_target == 0 then
			monster.set_motion("待機", -1, 0)
			wait_frames(10)
		end
		if reaction.is_guard_active() ~= 0 then
			break
		end
	end
end

--- Walks toward the target after noticing it and summons if it is far.
local function approach_after_notice()
	local target_distance: f32 = 0
	local roll: s32 = 0
	monster.set_monster_attributes(16, 0)
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	chase_target(vm.f32(1.8), 7.0, 80.0, 60)
	monster.set_motion("立ち", -1, 0)
	target_distance = monster.get_target_distance() or target_distance
	if target_distance > 200.0 then
		roll = monster.get_monster_count() or roll
		if roll < 18 then
			monster.set_motion("歩き", -1.0, 0)
			turn_toward_target_with_offset(7.0, 30.0, 15)
			summon_kotores()
		end
	end
end

--- Fights the target by distance while no rage hits remain.
local function fight_when_rage_hits_exhausted()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	local roll: s32 = 0
	local roll_2: s32 = 0
	local close_distance: f32 = 0
	local roll_3: s32 = 0
	local roll_4: s32 = 0
	local target_angle: f32 = 0
	while true do
		update_guard_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 360.0 then
			update_guard_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1.0, 0)
				turn_toward_target_and_wait(vm.f32(1.8))
				monster.set_motion("歩き", -1.0, 0)
				walk_in_direction(vm.f32(1.8), 180.0, 200.0, 200.0, 90)
			else
				monster.set_motion("立ち", -1, 0)
				wait_until_target_in_front(80.0, 90.0, 30)
			end
			continue
		end
		if target_distance < 360.0 and target_distance >= 200.0 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll_2 = monster.get_monster_count() or roll_2
				if roll_2 < 18 then
					monster.set_motion("歩き", -1.0, 0)
					turn_toward_target_with_offset(7.0, 30.0, 15)
					summon_kotores()
				end
			else
				monster.set_motion("歩き", -1.0, 0)
				turn_toward_target_and_wait(3.5)
				monster.set_motion("歩き", -1.0, 0)
				walk_toward_target(vm.f32(3.6), 3.5, 80.0, 30)
				monster.set_motion("立ち", -1, 0)
			end
		else
			close_distance = monster.get_target_distance() or close_distance
			if close_distance < 70.0 then
				roll = monster.get_random(100) or roll
				if roll < 60 then
					roll_3 = monster.get_monster_count() or roll_3
					if roll_3 < 18 then
						monster.set_motion("歩き", -1.0, 0)
						turn_toward_target_with_offset(7.0, 30.0, 15)
						summon_kotores()
					end
				end
			end
			roll = monster.get_random(100) or roll
			if roll < 65 then
				roll = monster.get_random(100) or roll
				if roll < 40 then
					roll_4 = monster.get_monster_count() or roll_4
					if roll_4 < 18 then
						monster.set_motion("歩き", -1.0, 0)
						turn_toward_target_with_offset(7.0, 30.0, 15)
						summon_kotores()
					end
				else
					monster.set_motion("歩き", -1.0, 0)
					turn_toward_target_and_wait(7.0)
					slash_attack()
				end
			else
				roll = monster.get_random(100) or roll
				if roll < 70 then
					monster.set_motion("歩き", -1.0, 0)
					turn_toward_target_and_wait(5.25)
					target_angle = monster.get_target_angle() or target_angle
					walk_in_direction(vm.f32(2.6999998), calc.radians_to_degrees(target_angle), 100.0, 360.0, 45)
				else
					monster.set_motion("歩き", -1.0, 0)
					turn_toward_target_and_wait(3.5)
					monster.set_motion("歩き", -1.0, 0)
					walk_toward_target(vm.f32(2.6999998), 3.5, 80.0, 30)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
		update_guard_and_wait_frame()
	end
end

--- Locks the monster in place facing the target before it is knocked down.
local function begin_knockdown()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	update_guard_and_wait_frame()
	monster.set_action_status(1)
end

--- Ends the throw state and waits briefly after landing.
local function recover_from_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	wait_frames(10)
	monster.reset_motion()
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the attack hit windows, loads the effects and starts the dungeon timer.
function script.init()
	local command_result: s32 = 0
	local free_texture_block: s32 = 0
	local smoke_effect_loaded: s32 = 0
	local explosion_effect_loaded: s32 = 0
	monster.register_damage_hit("通常攻撃", 10.0, "攻撃１", 0.3, 0.7, 1)
	monster.register_damage_hit("通常攻撃", 10.0, "攻撃１", 0.4, 0.8, 2)
	monster.call_command(171, command_result) -- retail: the handler rejects 1 arguments
	if command_result == 0 then
		monster.set_photo_opportunity("待機", 0.0, 1.0, 1019)
	end
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		smoke_effect_loaded = monster.load_effect_script("トーレの煙", free_texture_block) or smoke_effect_loaded
		explosion_effect_loaded = monster.load_effect_script("Ｍ小爆発", free_texture_block) or explosion_effect_loaded
		if (if smoke_effect_loaded ~= 0 then 1 else explosion_effect_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.reset_dungeon_timer()
	mark_time(0)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	initialize_monster_settings()
end

--- Chooses between fighting, waiting and approaching the target by its distance and the guard state.
function script.loop()
	local target_distance: f32 = 0
	local rage_hits_left: s32 = 0
	local alert_range: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(16, 0)
	while true do
		update_guard_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			watch_transformed_player()
			target_distance = monster.get_target_distance() or target_distance
			if reaction.is_guard_active() == 0 then
				print("normal mode ----------------------\n")
				if target_distance < 360.0 then
					reaction.set_guard_active(0)
					fight_target_nearby()
				else
					wait_for_target_to_approach()
				end
			else
				print("notice mode ----------------------\n")
				alert_range = state.get_secondary_float(alert_range)
				if target_distance < alert_range then
					if target_distance < 120.0 then
						reaction.set_guard_active(0)
						fight_target_nearby()
					else
						approach_after_notice()
					end
				else
					reaction.set_guard_active(0)
					monster.set_variable(0, 0)
				end
			end
		else
			fight_when_rage_hits_exhausted()
		end
	end
end

--- Holds the monster in its damage pose until its status ailment wears off.
function script.on_status_hit()
	local has_status_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status_ailment = 1
	while has_status_ailment ~= 0 do
		has_status_ailment = monster.get_status_ailments(40) or has_status_ailment
		update_guard_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers the monster back when it takes a hit.
function script.on_damage()
	monster.set_monster_attributes(16, 0)
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	wait_until_motion_finished()
	wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Knocks the monster over and gets it back up.
function script.on_knockdown()
	monster.set_monster_attributes(16, 0)
	begin_knockdown()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	wait_until_motion_finished()
	wait_frames(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Makes the monster guard against a hit.
function script.on_guard()
	monster.set_monster_attributes(16, 0)
	state.lock_and_stop_moving()
	state.unlock()
end

--- Makes the monster dodge the player's first kind of attack.
function script.on_dodge_1()
	monster.set_monster_attributes(16, 0)
	state.lock_and_reset_motion()
	state.unlock()
end

--- Makes the monster dodge the player's second kind of attack.
function script.on_dodge_2()
	monster.set_monster_attributes(16, 0)
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the monster's death animation and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Makes the monster struggle while it is held by the player.
function script.on_caught()
	monster.set_monster_attributes(16, 0)
	monster.set_motion("じたばた", -1, 4)
	while true do
		update_guard_and_wait_frame()
	end
end

--- Gets the monster back on its feet after it lands from a throw.
function script.on_land()
	monster.set_monster_attributes(16, 0)
	recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	wait_until_motion_finished()
	state.do_nothing_hook()
	return 1
end

--- Staggers the monster and keeps it stunned until it recovers.
function script.on_stun()
	monster.set_monster_attributes(16, 0)
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	wait_frames(12)
	reaction.stun_until_recovered()
end

return script
