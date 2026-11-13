--!strict
--- Metal Flotsam boss that flies with jets, drills at the player, drops bombs and takes passages when the player is out of reach.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")

--- Stores the behaviour mode.
local function set_mode(mode: s32)
	monster.set_variable(0, mode)
end

--- Stores the secondary behaviour mode.
local function set_secondary_mode(secondary_mode: s32)
	monster.set_variable(16, secondary_mode)
end

--- Sets the flight ceiling, clearance, clip distance and flying attributes.
local function configure_flight()
	state.set_max_flight_height(vm.f32(999.9))
	state.set_flight_clearance(45.0)
	monster.set_clip_distance(600.0)
	state.set_flying_attributes(1)
end

--- Uses a short clip distance for ordinary monsters and an unlimited one for bosses.
local function configure_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Returns the stored behaviour mode.
local function get_mode(mode: s32)
	local value: s32 = 0
	value = monster.get_variable(0) or value
	mode = value
	return mode
end

--- Creates the two jet effects when enabled and shuts them down and stops their sound when disabled.
local function set_jets_enabled(enabled: s32)
	local jet_effect: s32 = 0
	local chara_type: s32 = 0
	if enabled ~= 0 then
		jet_effect = 0
		chara_type = monster.get_character_number() or chara_type
		jet_effect = monster.create_effect_2("ポルＪＥＴ") or jet_effect
		monster.set_effect_owner(jet_effect, chara_type)
		monster.set_effect_value(jet_effect, 0, 0)
		monster.set_effect_value(jet_effect, 1, 0)
		monster.set_variable(4, jet_effect)
		jet_effect = 0
		jet_effect = monster.create_effect_2("ポルＪＥＴ") or jet_effect
		monster.set_effect_owner(jet_effect, chara_type)
		monster.set_effect_value(jet_effect, 0, 0)
		monster.set_effect_value(jet_effect, 1, 1)
		monster.set_variable(3, jet_effect)
	else
		jet_effect = 0
		jet_effect = monster.get_variable(4) or jet_effect
		if jet_effect ~= -99999 then
			monster.set_effect_value(jet_effect, 0, 1)
		end
		jet_effect = monster.get_variable(3) or jet_effect
		if jet_effect ~= -99999 then
			monster.set_effect_value(jet_effect, 0, 1)
		end
		monster.stop_sound(5)
	end
end

--- Does nothing for this frame and waits one frame.
local function wait_frame()
	state.do_nothing()
	vm.wait()
end

--- Runs along the waypoints of the passage nearest the target until the target is close or the path ends.
local function run_through_nearest_passage()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local distance: f32 = 0
	local nearest_distance: f32 = 0
	local entrance_x: f32 = 0
	local entrance_y: f32 = 0
	local entrance_z: f32 = 0
	local waypoint_1_x: f32 = 0
	local waypoint_1_y: f32 = 0
	local waypoint_1_z: f32 = 0
	local waypoint_2_x: f32 = 0
	local waypoint_2_y: f32 = 0
	local waypoint_2_z: f32 = 0
	local waypoint_3_x: f32 = 0
	local waypoint_3_y: f32 = 0
	local waypoint_3_z: f32 = 0
	local goal_x: f32 = 0
	local goal_z: f32 = 0
	local passage_index: s32 = 0
	local index: s32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local speed: f32 = 0
	local heading_angle: f32 = 0
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	nearest_distance = 10000000.0
	index = 0
	while index < 4 do
		if index == 0 then
			position_x = -101.5
			position_y = 0.0
			position_z = vm.f32(964.72)
		end
		if index == 1 then
			position_x = vm.f32(-86.02)
			position_y = 0.0
			position_z = vm.f32(3.4)
		end
		if index == 2 then
			position_x = vm.f32(85.15)
			position_y = 0.0
			position_z = vm.f32(958.98)
		end
		if index == 3 then
			position_x = vm.f32(128.03)
			position_y = 0.0
			position_z = vm.f32(2.48)
		end
		distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
		if distance < nearest_distance then
			nearest_distance = distance
			passage_index = index
		end
		index = index + 1
	end
	print("pas_no=", passage_index, "--------------\n")
	if passage_index == 0 then
		entrance_x = -101.5
		entrance_y = 0.0
		entrance_z = vm.f32(964.72)
		waypoint_1_x = vm.f32(-484.28)
		waypoint_1_y = 40.0
		waypoint_1_z = vm.f32(978.59)
		waypoint_2_x = vm.f32(-632.77)
		waypoint_2_y = 40.0
		waypoint_2_z = vm.f32(857.39)
		waypoint_3_x = vm.f32(-635.56)
		waypoint_3_y = 40.0
		waypoint_3_z = vm.f32(532.18)
	end
	if passage_index == 1 then
		entrance_x = vm.f32(-86.02)
		entrance_y = 0.0
		entrance_z = vm.f32(3.4)
		waypoint_1_x = vm.f32(-444.91)
		waypoint_1_y = 40.0
		waypoint_1_z = vm.f32(-13.92)
		waypoint_2_x = vm.f32(-640.01)
		waypoint_2_y = 40.0
		waypoint_2_z = vm.f32(71.46)
		waypoint_3_x = vm.f32(-630.83)
		waypoint_3_y = 40.0
		waypoint_3_z = vm.f32(532.54)
	end
	if passage_index == 2 then
		entrance_x = vm.f32(85.15)
		entrance_y = 0.0
		entrance_z = vm.f32(958.98)
		waypoint_1_x = vm.f32(481.66)
		waypoint_1_y = 40.0
		waypoint_1_z = vm.f32(965.4)
		waypoint_2_x = vm.f32(635.23)
		waypoint_2_y = 40.0
		waypoint_2_z = vm.f32(875.85)
		waypoint_3_x = vm.f32(634.95)
		waypoint_3_y = 40.0
		waypoint_3_z = vm.f32(413.07)
	end
	if passage_index == 3 then
		entrance_x = vm.f32(128.03)
		entrance_y = 0.0
		entrance_z = vm.f32(2.48)
		waypoint_1_x = vm.f32(453.76)
		waypoint_1_y = 40.0
		waypoint_1_z = vm.f32(-22.55)
		waypoint_2_x = vm.f32(619.7)
		waypoint_2_y = 40.0
		waypoint_2_z = vm.f32(-79.51)
		waypoint_3_x = vm.f32(637.02)
		waypoint_3_y = 40.0
		waypoint_3_z = vm.f32(426.33)
	end
	monster.set_motion("走り", -1, 0)
	speed = 8.0
	index = 0
	passage_index = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, _, out3 = monster.copy_vector(entrance_x, entrance_y, entrance_z)
		goal_x = out1 or goal_x
		goal_z = out3 or goal_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(entrance_x, entrance_y, entrance_z)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(entrance_x, entrance_y, entrance_z)
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
		local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, speed)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	index = 0
	while true do
		if index > 300 then
			break
		else
			do
				local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, direction_x, direction_y, direction_z)
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			heading_angle = monster.get_angle_to_position(position_x, position_y, position_z) or heading_angle
			do
				local out1, out2, out3 = monster.get_target_position()
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			distance = monster.get_target_distance() or distance
			if distance < 120.0 then
				break
			else
				distance = monster.get_distance_between(goal_x, 0.0, goal_z, position_x, 0.0, position_z) or distance
				print("dist=", vm.float(distance), "-----------------------------\n")
				if distance < vm.f32(speed + 10.0) then
					index = 0
					passage_index = passage_index + 1
					if passage_index > 3 then
						break
					end
					if passage_index == 1 then
						do
							local out1, out2, out3 = monster.copy_vector(waypoint_1_x, waypoint_1_y, waypoint_1_z)
							target_x = out1 or target_x
							target_y = out2 or target_y
							target_z = out3 or target_z
						end
						do
							local out1, out2, out3 = monster.copy_vector(waypoint_1_x, waypoint_1_y, waypoint_1_z)
							direction_x = out1 or direction_x
							direction_y = out2 or direction_y
							direction_z = out3 or direction_z
						end
						do
							local out1, _, out3 = monster.copy_vector(waypoint_1_x, waypoint_1_y, waypoint_1_z)
							goal_x = out1 or goal_x
							goal_z = out3 or goal_z
						end
					end
					if passage_index == 2 then
						do
							local out1, out2, out3 = monster.copy_vector(waypoint_2_x, waypoint_2_y, waypoint_2_z)
							target_x = out1 or target_x
							target_y = out2 or target_y
							target_z = out3 or target_z
						end
						do
							local out1, out2, out3 = monster.copy_vector(waypoint_2_x, waypoint_2_y, waypoint_2_z)
							direction_x = out1 or direction_x
							direction_y = out2 or direction_y
							direction_z = out3 or direction_z
						end
						do
							local out1, _, out3 = monster.copy_vector(waypoint_2_x, waypoint_2_y, waypoint_2_z)
							goal_x = out1 or goal_x
							goal_z = out3 or goal_z
						end
					end
					if passage_index == 3 then
						do
							local out1, out2, out3 = monster.copy_vector(waypoint_3_x, waypoint_3_y, waypoint_3_z)
							target_x = out1 or target_x
							target_y = out2 or target_y
							target_z = out3 or target_z
						end
						do
							local out1, out2, out3 = monster.copy_vector(waypoint_3_x, waypoint_3_y, waypoint_3_z)
							direction_x = out1 or direction_x
							direction_y = out2 or direction_y
							direction_z = out3 or direction_z
						end
						do
							local out1, _, out3 = monster.copy_vector(waypoint_3_x, waypoint_3_y, waypoint_3_z)
							goal_x = out1 or goal_x
							goal_z = out3 or goal_z
						end
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
						local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, speed)
						direction_x = out1 or direction_x
						direction_y = out2 or direction_y
						direction_z = out3 or direction_z
					end
				end
				monster.move_toward_position(position_x, position_y - 20.0, position_z, speed, speed + 10.0)
				monster.turn_toward_angle(heading_angle, calc.degrees_to_radians(4.0))
				wait_frame()
				index = index + 1
			end
		end
	end
	monster.stop_moving()
	movement.stop_turning()
end

--- Waits until the monster faces an angle within a tolerance or a frame limit passes, and returns the frames waited.
local function wait_until_facing(target_degrees: f32, tolerance_degrees: f32, max_frames: f32)
	local rotation_y: f32 = 0
	local elapsed_frames: f32 = 0
	local frame_limit: f32 = 0
	local tolerance_radians: f32 = 0
	target_degrees = calc.degrees_to_radians(target_degrees)
	if target_degrees > vm.f32(3.1415927) then
		target_degrees = vm.f32(target_degrees - vm.f32(6.2831855))
	end
	if target_degrees <= vm.f32(-3.1415927) then
		target_degrees = vm.f32(target_degrees + vm.f32(6.2831855))
	end
	tolerance_degrees = calc.degrees_to_radians(tolerance_degrees)
	frame_limit = max_frames
	if tolerance_degrees < 3.0 then
		tolerance_radians = calc.degrees_to_radians(3.0)
	else
		tolerance_radians = tolerance_degrees
	end
	elapsed_frames = 0.0
	while elapsed_frames < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		if rotation_y > vm.f32(target_degrees - tolerance_radians) and rotation_y < vm.f32(target_degrees + tolerance_radians) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_degrees, rotation_y, tolerance_degrees) == 0 then
			movement.stop_turning()
			break
		elseif elapsed_frames >= max_frames then
			movement.stop_turning()
			break
		else
			wait_frame()
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
	end
	movement.stop_turning()
	return elapsed_frames
end

--- Turns toward the target at the given speed and waits until facing it.
local function face_target(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Runs at the target until within a stop distance or out of frames; returns -1 when it got close and the frames used otherwise.
local function chase_target(speed: f32, rot_speed: f32, stop_distance: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local frame: s32 = 0
	face_target(rot_speed)
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
			return -1
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
			approach_x = out1 or approach_x
			approach_y = out2 or approach_y
			approach_z = out3 or approach_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(approach_x, approach_y, approach_z, pos_x, pos_y, pos_z)
			approach_x = out1 or approach_x
			approach_y = out2 or approach_y
			approach_z = out3 or approach_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(approach_x, approach_y, approach_z)
			approach_x = out1 or approach_x
			approach_y = out2 or approach_y
			approach_z = out3 or approach_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(approach_x, approach_y, approach_z, speed + stop_distance)
			approach_x = out1 or approach_x
			approach_y = out2 or approach_y
			approach_z = out3 or approach_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(approach_x, approach_y, approach_z, pos_x, pos_y, pos_z)
			approach_x = out1 or approach_x
			approach_y = out2 or approach_y
			approach_z = out3 or approach_z
		end
		monster.move_toward_position(approach_x, pos_y - 20.0, approach_z, speed, speed)
		wait_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
	return frame
end

--- Waits the given number of frames.
local function wait_frames(frames: any)
	local frame: s32 = 0
	frame = 0
	while frame < frames do
		wait_frame()
		frame = vm.i32(frame + 1)
	end
end

--- Takes a passage if the target is up high, runs at the target, and catches its breath when the chase was long.
local function rush_target_long_range()
	local target_height: f32 = 0
	local frames_chased: s32 = 0
	do
		local _, out2, _ = monster.get_target_position()
		target_height = out2 or target_height
	end
	if target_height > 1.0 then
		run_through_nearest_passage()
	end
	monster.set_motion("走り", -1, 0)
	frames_chased = chase_target(8.0, 4.0, 45.0, 90)
	monster.set_motion("立ち", -1, 0)
	if frames_chased > 60 then
		monster.set_motion("息切れ", -1, 0)
		wait_frames(90)
	end
end

--- Returns 1 when the flight path to a position is clear and the ground at the position is valid.
local function can_move_to(x: f32, y: f32, z: f32)
	local distance: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local angle: f32 = 0
	local ground_height: f32 = 0
	local clear_distance: f32 = 0
	local destination_distance: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	distance = monster.get_distance_between(pos_x, pos_y, pos_z, x, y, z) or distance
	angle = monster.get_angle_to_position(x, y, z) or angle
	ground_height = monster.get_height_above_ground() or ground_height
	if ground_height > 20.0 then
		if sense.check_flight_destination(x, vm.f32(y + 1.0), z, distance, angle) ~= 0 then
			return 0
		end
	end
	destination_distance = monster.get_distance_between(pos_x, pos_y, pos_z, x, y, z) or destination_distance
	clear_distance = monster.get_clear_distance_between(pos_x, pos_y + 1.0, pos_z, x, y + 1.0, z) or clear_distance
	if clear_distance < vm.f32(destination_distance - 1.0) then
		return 0
	end
	if y < 3.0 then
		return 0
	end
	ground_height = monster.get_height_above_ground_at(x, y, z) or ground_height
	if ground_height < 0.0 or ground_height <= -100000000.0 then
		return 0
	end
	return 1
end

--- Moves toward a position with constant acceleration until it arrives, is blocked or runs out of frames.
local function glide_to_position(target_x: f32, target_y: f32, target_z: f32, start_speed: f32, distance_padding: f32, duration_scale: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local acceleration: f32 = 0
	local distance: f32 = 0
	local speed: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
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
	distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
	acceleration = movement.get_acceleration(distance, start_speed, vm.f32(vm.f32(vm.fdiv(vm.f32(distance + distance_padding), start_speed)) * duration_scale), acceleration)
	speed = start_speed
	frame = 0
	while frame < max_frames do
		speed = vm.f32(speed + acceleration)
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = monster.copy_vector(direction_x, direction_y, direction_z)
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
		if can_move_to(position_x, position_y, position_z) == 0 then
			return
		end
		if speed <= 0.0 then
			break
		else
			distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
			if distance < speed then
				break
			elseif position_y < 0.0 then
				monster.set_position(position_x, 0.0, position_z)
				break
			else
				monster.set_position(position_x, position_y, position_z)
				wait_frame()
				frame = frame + 1
			end
		end
	end
	movement.stop_turning()
end

--- Flies toward a position along a curve that bends gradually from a side heading toward the destination.
local function fly_curved_toward(
	target_x: f32,
	target_y: f32,
	target_z: f32,
	start_speed: f32,
	arrival_distance: f32,
	heading_angle: f32,
	homing_strength: f32,
	tracks_target: s32,
	max_frames: s32
)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local heading_x: f32 = 0
	local heading_y: f32 = 0
	local heading_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local distance: f32 = 0
	local speed: f32 = 0
	local frame: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
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
	heading_x = vm.f32(vm.f32(direction_x * vm.cos(heading_angle)) + vm.f32(direction_z * vm.sin(heading_angle)))
	heading_y = direction_y
	heading_z = vm.f32(vm.f32(direction_x * -vm.sin(heading_angle)) + vm.f32(direction_z * vm.cos(heading_angle)))
	do
		local out1, out2, out3 = monster.normalize_vector(heading_x, heading_y, heading_z)
		heading_x = out1 or heading_x
		heading_y = out2 or heading_y
		heading_z = out3 or heading_z
	end
	speed = start_speed
	frame = 0
	while frame < max_frames do
		if tracks_target ~= 0 then
			do
				local out1, out2, out3 = monster.get_target_position()
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
		end
		direction_x = vm.f32(target_x - position_x)
		direction_y = vm.f32(target_y - position_y)
		direction_z = vm.f32(target_z - position_z)
		do
			local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, homing_strength)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(heading_x, heading_y, heading_z, 1.0 - homing_strength)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(heading_x, heading_y, heading_z, direction_x, direction_y, direction_z)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(heading_x, heading_y, heading_z)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = monster.copy_vector(heading_x, heading_y, heading_z)
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
		if speed <= 0.0 then
			break
		else
			if can_move_to(position_x, position_y, position_z) == 0 then
				return
			end
			distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
			if distance < arrival_distance or distance < speed then
				break
			elseif position_y <= 0.0 then
				break
			else
				monster.stop_moving()
				monster.set_position(position_x, position_y, position_z)
				monster.set_rotation(rotation_x, rotation_y, rotation_z)
				wait_frame()
				frame = frame + 1
			end
		end
	end
	monster.set_rotation(0.0, rotation_y, 0.0)
	movement.stop_turning()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Moves in a straight line toward a position in fixed steps, optionally turning to face the way it moves.
local function move_linearly_to(target_x: f32, target_y: f32, target_z: f32, step_length: f32, arrival_distance: f32, faces_movement: s32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local distance: f32 = 0
	monster.stop_moving()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
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
	for frame = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		distance = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance
		if distance < arrival_distance then
			return
		end
		do
			local out1, out2, out3 = monster.get_rotation_toward_6(position_x, position_y, position_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		monster.set_position(position_x, position_y, position_z)
		if faces_movement ~= 0 then
			monster.set_rotation(rotation_x, rotation_y, rotation_z)
		end
		wait_frame()
	end
end

--- Rises, flies at the target while spinning like a drill, then returns to the ground.
local function perform_drill_attack()
	local distance: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local height: f32 = 0
	local rotation_y: f32 = 0
	distance = sense.get_horizontal_target_distance(distance)
	if distance < 110.0 then
		return
	end
	monster.set_variable(15, 1)
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(16, 1)
	set_jets_enabled(1)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ドリル攻撃（入り）", -1, 6)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	height = monster.get_height_above_ground() or height
	height = vm.f32(pos_y - height)
	glide_to_position(pos_x, vm.f32(height + 60.0), pos_z, vm.f32(7.7), 0.0, vm.f32(2.3), 25)
	monster.set_monster_attributes(32, 0)
	monster.set_motion("ドリル攻撃（ループ）", -1, 0)
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	fly_curved_toward(target_x, target_y, target_z, vm.f32(9.9), 15.0, vm.f32(0.7853982), vm.f32(0.2), 1, 90)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	height = monster.get_height_above_ground() or height
	height = vm.f32(pos_y - height)
	monster.set_motion("ドリル攻撃（戻り）", -1, 6)
	set_jets_enabled(0)
	move_linearly_to(pos_x, height, pos_z, vm.f32(0.6), 0.0, 0, 25)
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	monster.set_rotation(0.0, rotation_y, 0.0)
	monster.set_motion("立ち", -1, 0)
	wait_frame()
	monster.set_monster_attributes(16, 0)
	monster.set_monster_attributes(4, 0)
	monster.set_variable(15, 0)
end

--- Takes a passage if the target is up high or drills at it, then runs at the target and catches its breath when the chase was long.
local function approach_medium_range()
	local target_height: f32 = 0
	local frames_chased: s32 = 0
	do
		local _, out2, _ = monster.get_target_position()
		target_height = out2 or target_height
	end
	if target_height > 1.0 then
		run_through_nearest_passage()
	else
		perform_drill_attack()
	end
	monster.set_motion("走り", -1, 0)
	frames_chased = chase_target(8.0, 4.0, 45.0, 150)
	monster.set_motion("立ち", -1, 0)
	if frames_chased > 60 then
		monster.set_motion("息切れ", -1, 0)
		wait_frames(90)
	end
end

--- Turns toward the target until the current motion finishes.
local function track_target_until_motion_finished(rot_speed: f32)
	local target_angle: f32 = 0
	local is_finished: s32 = 0
	rot_speed = calc.degrees_to_radians(rot_speed)
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			movement.stop_turning()
			break
		end
	end
end

--- Plays the attack motion while turning toward the target, then stands.
local function perform_melee_attack()
	monster.set_motion("攻撃", -1, 2)
	track_target_until_motion_finished(4.0)
	monster.set_motion("立ち", -1, 0)
	wait_frame()
end

--- Takes off to the flying height and returns 0, or returns -2 when too close to the exit point.
local function take_off()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local ground_height: f32 = 0
	local takeoff_height: f32 = 0
	local exit_distance: f32 = 0
	local exit_x: f32 = 0
	local exit_z: f32 = 0
	local target_height: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	exit_x = vm.f32(-467.95)
	exit_z = vm.f32(842.14)
	exit_distance = monster.get_distance_between(pos_x, 0.0, pos_z, exit_x, 0.0, exit_z) or exit_distance
	if exit_distance < 100.0 then
		return -2
	end
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_monster_attributes(32, 1)
	set_jets_enabled(1)
	monster.set_motion("離陸", -1, 6)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	ground_height = monster.get_height_above_ground() or ground_height
	ground_height = vm.f32(pos_y - ground_height)
	do
		local _, out2, _ = monster.get_target_position()
		target_height = out2 or target_height
	end
	takeoff_height = 60.0
	if target_height > 2.0 then
		takeoff_height = 80.0
	end
	glide_to_position(pos_x, takeoff_height, pos_z, vm.f32(7.7), 0.0, vm.f32(2.3), calc.pass_through(37))
	monster.set_monster_attributes(8, 0)
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	return 0
end

--- Turns toward an angle at the given speed and waits until facing it.
local function turn_toward_angle_and_wait(next_rot: f32, rot_speed: f32)
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
	local _ = wait_until_facing(
		calc.radians_to_degrees(next_rot),
		calc.radians_to_degrees(rot_speed),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(rot_speed)))
	)
	movement.stop_turning()
end

--- Flies in a circle above the arena center and drops bombs at intervals for a number of frames.
local function circle_and_drop_bombs(frames: s32)
	local height: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local start_angle: f32 = 0
	local radius: f32 = 0
	local orbit_angle: f32 = 0
	local center_x: f32 = 0
	local center_height: f32 = 0
	local center_z: f32 = 0
	local bomb_timer: f32 = 0
	local travelled_frames: f32 = 0
	local frame: s32 = 0
	local monster_count: s32 = 0
	local bomb_x: f32 = 0
	local bomb_y: f32 = 0
	local bomb_z: f32 = 0
	height = monster.get_height_above_ground() or height
	if height < 30.0 then
		return
	end
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
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
	start_angle = monster.get_random_whole_number(6.2831855) or start_angle
	radius = monster.get_random_whole_number(50.0) or radius
	radius = vm.f32(radius + 350.0)
	center_x = 0.0
	center_height = 0.0
	center_z = 450.0
	pos_x = vm.f32(center_x + vm.f32(vm.sin(start_angle) * radius))
	pos_y = vm.f32(center_height + pos_y)
	pos_z = vm.f32(center_z + vm.f32(vm.cos(start_angle) * radius))
	monster.set_motion("飛びループ", -1, 0)
	monster.get_angle_to_position(pos_x, pos_y, pos_z)
	turn_toward_angle_and_wait(calc.radians_to_degrees(start_angle), 4.0)
	move_linearly_to(pos_x, pos_y, pos_z, 5.5, 5.5, 0, 300)
	if travelled_frames >= 299 then
		return
	end
	orbit_angle = start_angle
	frame = 0
	bomb_timer = 1.4e-42 -- retail: integer bits read as a float
	monster.stop_moving()
	while frame < frames do
		pos_x = vm.f32(center_x + vm.f32(vm.sin(orbit_angle) * radius))
		pos_y = vm.f32(center_height + pos_y)
		pos_z = vm.f32(center_z + vm.f32(vm.cos(orbit_angle) * radius))
		rotation_y = monster.get_angle_to_position(pos_x, pos_y, pos_z) or rotation_y
		monster.set_position(pos_x, pos_y, pos_z)
		monster.set_rotation(0.0, rotation_y, 0.0)
		monster_count = monster.get_monster_count() or monster_count
		if monster_count < 20 then
			if vm.imod(frame, 60) == 0 then
				monster.set_motion("爆弾攻撃", -1, 6)
				bomb_timer = 0
			end
			if bomb_timer == 35 then
				do
					local out1, out2, out3 = monster.get_frame_position("dco2")
					bomb_x = out1 or bomb_x
					bomb_y = out2 or bomb_y
					bomb_z = out3 or bomb_z
				end
				monster.create_monster(1006, bomb_x, bomb_y, bomb_z, 0.0)
			end
			if bomb_timer == 50 then
				monster.set_motion("飛びループ", -1, 0)
			end
		end
		orbit_angle = vm.f32(orbit_angle + vm.f32(0.032724924))
		wait_frame()
		frame = frame + 1
		bomb_timer = vm.f32(bomb_timer + 1)
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Flies toward the target at a fixed height, slowing down once close.
local function hover_toward_target(speed: f32, turn_speed_degrees: f32, hover_height: f32, frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local pos_y: f32 = 0
	local ground_height: f32 = 0
	local heading_angle: f32 = 0
	local distance: f32 = 0
	local acceleration: f32 = 0
	local frame: s32 = 0
	acceleration = 0.0
	monster.stop_moving()
	monster.set_monster_attributes(16, 1)
	frame = 0
	while frame < frames do
		speed = vm.f32(speed + acceleration)
		monster.get_target_angle()
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		do
			local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
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
			local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, speed)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, direction_x, direction_y, direction_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local _, out2, _ = monster.get_rotation_toward_6(position_x, position_y, position_z)
			heading_angle = out2 or heading_angle
		end
		if can_move_to(position_x, position_y, position_z) == 0 then
			return
		end
		distance = monster.get_distance_between(position_x, 0.0, position_z, target_x, 0.0, target_z) or distance
		if distance < 135.0 then
			acceleration = vm.f32(-0.4)
		end
		if speed <= 0.0 then
			break
		else
			do
				local _, out2, _ = monster.get_position_3()
				pos_y = out2 or pos_y
			end
			ground_height = monster.get_height_above_ground() or ground_height
			ground_height = vm.f32(pos_y - ground_height)
			monster.set_position(position_x, hover_height, position_z)
			monster.turn_toward_angle(heading_angle, calc.degrees_to_radians(turn_speed_degrees))
			wait_frame()
			frame = frame + 1
		end
	end
	monster.set_monster_attributes(16, 0)
end

--- Turns toward the target for a number of frames.
local function track_target_for_frames(rot_speed: f32, frames: s32)
	local target_angle: f32 = 0
	local _ = calc.degrees_to_radians(rot_speed)
	for frame = 0, frames - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		wait_frame()
	end
	movement.stop_turning()
end

--- Waits frame by frame until the current motion finishes.
local function wait_until_motion_finished()
	local is_finished: s32 = 0
	while true do
		wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			return
		end
	end
end

--- Drops a bomb monster from the bomb frame while airborne and fewer than twenty monsters exist.
local function drop_bomb()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local height: f32 = 0
	local monster_count: s32 = 0
	monster_count = monster.get_monster_count() or monster_count
	height = monster.get_height_above_ground() or height
	if height > 5.0 and monster_count < 20 then
		monster.set_motion("爆弾攻撃", -1, 6)
		track_target_for_frames(4.0, calc.pass_through(35))
		do
			local out1, out2, out3 = monster.get_frame_position("dco2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		monster.create_monster(1006, pos_x, pos_y, pos_z, rotation_y)
		wait_until_motion_finished()
	end
end

--- Flies around the target at a fixed distance and drops bombs periodically; returns -2 when aborted and 0 when finished.
local function circle_target_dropping_bombs(speed: f32, unused_option: any, frames: s32)
	local height: f32 = 0
	local frame: s32 = 0
	local bomb_timer: s32 = 0
	local monster_count: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local move_x: f32 = 0
	local move_y: f32 = 0
	local move_z: f32 = 0
	local orbit_angle: f32 = 0
	local target_distance: f32 = 0
	local target_height: f32 = 0
	local bomb_x: f32 = 0
	local bomb_y: f32 = 0
	local bomb_z: f32 = 0
	height = monster.get_height_above_ground() or height
	if height < 20.0 then
		return -2
	end
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("飛びループ", -1, 0)
	monster.stop_moving()
	orbit_angle = 0.0
	frame = 0
	bomb_timer = 999
	while frame < frames do
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance > 120.0 or frame < 10 then
			move_x, move_y, move_z = movement.get_point_around_target(orbit_angle, 120.0, move_x, move_y, move_z)
			do
				local out1, out2, out3 = monster.subtract_vectors(move_x, move_y, move_z, position_x, position_y, position_z)
				move_x = out1 or move_x
				move_y = out2 or move_y
				move_z = out3 or move_z
			end
			do
				local out1, out2, out3 = monster.normalize_vector(move_x, move_y, move_z)
				move_x = out1 or move_x
				move_y = out2 or move_y
				move_z = out3 or move_z
			end
			move_y = 0.0
			do
				local out1, out2, out3 = monster.scale_vector(move_x, move_y, move_z, speed)
				move_x = out1 or move_x
				move_y = out2 or move_y
				move_z = out3 or move_z
			end
		end
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, move_x, move_y, move_z)
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
		if can_move_to(position_x, position_y, position_z) == 0 then
			return -2
		end
		if position_z < 0.0 then
			return -2
		end
		if position_y <= 0.0 then
			break
		else
			do
				local _, out2, _ = monster.get_target_position()
				target_height = out2 or target_height
			end
			if target_height > 3.0 then
				return -2
			end
			target_distance = sense.get_horizontal_target_distance(target_distance)
			if target_distance > 120.0 then
				orbit_angle = vm.f32(orbit_angle + 3.0)
			end
			monster.stop_moving()
			monster.set_position(position_x, position_y, position_z)
			monster.set_rotation(rotation_x, rotation_y, rotation_z)
			monster_count = monster.get_monster_count() or monster_count
			if monster_count < 20 then
				if vm.imod(frame, 60) == 0 then
					monster.reset_motion()
					monster.set_motion("爆弾攻撃", -1, 6)
					bomb_timer = 0
				end
				if bomb_timer == 35 then
					rotation_y = monster.get_target_angle() or rotation_y
					do
						local out1, out2, out3 = monster.get_frame_position("dco2")
						bomb_x = out1 or bomb_x
						bomb_y = out2 or bomb_y
						bomb_z = out3 or bomb_z
					end
					monster.create_monster(1006, bomb_x, bomb_y, bomb_z, rotation_y)
				end
				if bomb_timer == 50 then
					monster.set_motion("飛びループ", -1, 0)
				end
			end
			wait_frame()
			frame = frame + 1
			bomb_timer = vm.i32(bomb_timer + 1)
		end
	end
	monster.stop_moving()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	return 0
end

--- Shuts off the jets and descends to the ground with the drill landing motion.
local function land()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	set_jets_enabled(0)
	monster.stop_sound(5)
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ドリル攻撃（入り）", -1, 6)
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.get_height_above_ground()
	glide_to_position(pos_x, 0.0, pos_z, vm.f32(7.7), 0.0, vm.f32(2.3), 37)
	monster.set_monster_attributes(32, 0)
end

--- Strikes, optionally drills, takes off, circles the target dropping bombs, then lands and chases the target.
local function perform_close_range_attack()
	local life: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local target_height: f32 = 0
	local roll: s32 = 0
	local result: s32 = 0
	life = 0.0
	do
		local _, out2, out3 = monster.get_target_position()
		target_height = out2 or target_height
		current_z = out3 or current_z
	end
	if target_height > 2.0 then
		run_through_nearest_passage()
	end
	perform_melee_attack()
	do
		local _, out2, out3 = monster.get_target_position()
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	if current_y < 1.0 then
		roll = monster.get_random(100) or roll
		if roll < 85 then
			perform_drill_attack()
		end
	end
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(16, 1)
	monster.play_sound(5)
	result = take_off()
	life = 0.0
	life = monster.get_life() or life
	if life < vm.f32(0.2) then
		do
			local _, out2, out3 = monster.get_position_3()
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		do
			local _, out2, _ = monster.get_target_position()
			target_height = out2 or target_height
		end
		if target_height < 3.0 and current_z >= 0.0 then
			circle_and_drop_bombs(300)
		end
	end
	monster.set_motion("飛びループ", -1, 0)
	do
		local _, out2, out3 = monster.get_position_3()
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	hover_toward_target(5.5, 4.0, current_y, 90)
	drop_bomb()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		result = circle_target_dropping_bombs(5.5, 60, 300)
	else
		result = -2
	end
	land()
	monster.stop_sound(5)
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(16, 0)
	if result ~= -2 then
		monster.set_motion("息切れ", -1, 0)
		wait_frames(90)
	end
	monster.set_motion("走り", -1, 0)
	result = chase_target(8.0, 4.0, 45.0, 90)
	monster.set_motion("立ち", -1, 0)
	if result > 30 then
		monster.set_motion("息切れ", -1, 0)
		wait_frames(90)
	end
end

--- Picks an attack by the distance to the target.
local function choose_attack()
	local distance: f32 = 0
	distance = monster.get_target_distance() or distance
	if distance > 450.0 then
		rush_target_long_range()
	elseif distance > 250.0 then
		approach_medium_range()
	else
		perform_close_range_attack()
	end
end

--- Stops all movement and turning, faces the target and marks the action as being recovered.
local function prepare_knockdown_recovery()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	wait_frame()
	monster.set_action_status(1)
end

local script = {}

--- Does nothing for this monster.
function script.setup() end

--- Registers the damage hits, loads the bomb explosion and jet effects, and sets the flight and starting state.
function script.init()
	local get_not_used_texb: s32 = 0
	local explosion_loaded: s32 = 0
	local jet_loaded: s32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	monster.set_clip_distance(999999.9)
	monster.register_damage_hit("中攻撃", 5.0, "攻撃", 0.587, 0.667, 1)
	monster.register_damage_hit("通常攻撃", 5.0, "ドリル攻撃（入り）", 0.84, 1.0, 0)
	monster.register_damage_hit("弱攻撃", 5.0, "ドリル攻撃（ループ）", 0.0, 0.5, 0)
	monster.register_damage_hit("弱攻撃", 5.0, "ドリル攻撃（ループ）", 0.5, 1.0, 0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		explosion_loaded = monster.load_effect_script("海賊爆弾爆発", get_not_used_texb) or explosion_loaded
		jet_loaded = monster.load_effect_script("ポルＪＥＴ", get_not_used_texb) or jet_loaded
		if (if explosion_loaded ~= 0 then 1 else jet_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_camera_mode(0)
	set_mode(2)
	state.set_float_state(0.0)
	set_secondary_mode(2)
	configure_flight()
	monster.set_monster_attributes(256, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_variable(15, 0)
	monster.set_variable(3, -99999)
	monster.set_variable(4, -99999)
	configure_clip_distance()
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, 0.0, pos_z)
	state.set_max_flight_height(80.0)
	monster.set_photo_opportunity(1024)
end

--- Sets up the state for the current mode, then attacks by distance while in the aggressive mode.
function script.loop()
	local rotation_y: f32 = 0
	local mode: s32 = 0
	monster.set_variable(15, 0)
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	monster.set_rotation(0.0, rotation_y, 0.0)
	mode = get_mode(mode)
	if mode == 2 then
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
		monster.set_action_status(0)
		monster.set_monster_attributes(4, 0)
		monster.set_monster_attributes(16, 0)
		monster.set_monster_attributes(32, 0)
		set_jets_enabled(0)
	end
	if mode == 1 then
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
		monster.set_action_status(0)
		monster.set_monster_attributes(4, 1)
		monster.set_monster_attributes(16, 0)
		monster.set_monster_attributes(32, 0)
		set_jets_enabled(0)
	end
	while true do
		wait_frame()
		mode = get_mode(mode)
		if mode == 2 then
			choose_attack()
		else
			state.do_nothing()
		end
	end
end

--- Plays the directional damage motion while drilling, knocks the monster back and recovers to the ground.
function script.on_damage()
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local target_angle: f32 = 0
	value = monster.get_variable(15) or value
	if value == 1 then
		state.stop_and_clear_action()
		target_angle = monster.get_target_angle() or target_angle
		if target_angle > vm.f32(3.1415927) then
			target_angle = vm.f32(target_angle - vm.f32(6.2831855))
		end
		if target_angle <= vm.f32(-3.1415927) then
			target_angle = vm.f32(target_angle + vm.f32(6.2831855))
		end
		monster.set_motion("ダメージ", -1, 6)
		if target_angle < vm.f32(0.7853982) and target_angle >= vm.f32(-0.7853982) then
			monster.set_motion("ダメージ", -1, 6)
		end
		if target_angle < vm.f32(2.3561945) and target_angle >= vm.f32(0.7853982) then
			monster.set_motion("ダメージ右", -1, 6)
		end
		if target_angle >= vm.f32(-2.3561945) and target_angle < vm.f32(0.7853982) then
			monster.set_motion("ダメージ左", -1, 6)
		end
		if target_angle >= vm.f32(2.3561945) and target_angle < vm.f32(-2.3561945) then
			monster.set_motion("ダメージ後", -1, 6)
		end
		monster.start_knockback(4.0, 0.0, 3)
		wait_until_motion_finished()
		wait_frames(12)
		monster.set_motion("立ち")
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
		if pos_y > 2.0 then
			perform_melee_attack()
			monster.set_rotation(0.0, rotation_y, 0.0)
		end
		if pos_y < 0.0 then
			monster.set_position(pos_x, 0.0, pos_z)
			monster.set_rotation(0.0, rotation_y, 0.0)
		end
		state.do_nothing()
	end
end

--- Recovers in place after a knockdown and releases the action.
function script.on_knockdown()
	prepare_knockdown_recovery()
	state.unlock_and_clear_action()
end

--- Stops moving while guarding.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when dodging.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when dodging.
function script.on_dodge_2() end

--- Shuts off the jets, plays the death motion, requests the defeat event and waits.
function script.on_death()
	death.begin()
	set_jets_enabled(0)
	monster.stop_sound(5)
	monster.set_monster_attributes(2, 1)
	monster.set_monster_attributes(64, 1)
	monster.set_monster_attributes(4, 0)
	monster.set_motion("死に", 6)
	motion.wait_until_finished()
	monster.set_motion("死に（ループ）", 0)
	monster.request_event_script(500)
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when caught.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when landing.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when stunned.
function script.on_stun() end

return script
