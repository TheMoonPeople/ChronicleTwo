--!strict
--- Distance, angle and view checks for monster scripts.

local vm = require("@lib/vm")
local behavior = vm.module("@lib/monster/behavior")
local calc = vm.module("@lib/monster/calc")
local reaction = vm.module("@lib/monster/reaction")
local state = vm.module("@lib/monster/state")
local timer = vm.module("@lib/monster/timer")

local sense = {}

--- Returns 0 when a flying move of a distance along an angle from a position is clear, -1 when blocked and -2 when the height above the ground is out of range.
function sense.check_flight_destination(x: f32, y: f32, z: f32, distance: f32, angle: f32)
	local height_above_ground: f32 = 0
	local clear_distance: f32 = 0
	local clearance: f32 = 0
	local max_height: f32 = 0
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	height_above_ground = monster.get_height_above_ground_at(x, y, z) or height_above_ground
	y = vm.f32(y - vm.f32(y - height_above_ground))
	if height_above_ground < 0.0 then
		print("high=", vm.float(height_above_ground), "-------------------\n")
		return -2
	end
	max_height = state.get_max_flight_height(max_height)
	if height_above_ground > max_height then
		return -2
	end
	clearance = state.get_flight_clearance(clearance)
	clear_distance = monster.get_flying_clear_distance(distance + clearance, angle) or clear_distance
	if clear_distance < vm.f32(distance + clearance) then
		return -1
	end
	return 0
end

--- Returns the flat distance between two points on the ground plane.
function sense.get_distance_2d(from_x: f32, from_z: f32, to_x: f32, to_z: f32)
	local distance: f32 = 0
	monster.call_command(
		20,
		vm.f32(vm.f32(to_x - from_x) * vm.f32(to_x - from_x)) + vm.f32(vm.f32(to_z - from_z) * vm.f32(to_z - from_z)),
		distance
	) -- retail: command 20 is not registered
	return distance
end

--- Returns the cosine of the angle between the monster's facing, offset by the rotation of monster 0, and the direction from the target to the monster.
function sense.get_facing_alignment()
	local angle: f32 = 0
	local facing_angle: f32 = 0
	local delta_x: f32 = 0
	local delta_y: f32 = 0
	local delta_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local alignment: f32 = 0
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	do
		local _, out2, _ = monster.get_rotation(0)
		angle = out2 or angle
	end
	facing_angle = vm.f32(facing_angle + angle)
	if facing_angle > vm.f32(3.1415927) then
		facing_angle = vm.f32(facing_angle - vm.f32(6.2831855))
	end
	if facing_angle < vm.f32(-3.1415927) then
		facing_angle = vm.f32(facing_angle + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		delta_x = out1 or delta_x
		delta_y = out2 or delta_y
		delta_z = out3 or delta_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(delta_x, delta_y, delta_z, target_x, target_y, target_z)
		delta_x = out1 or delta_x
		delta_y = out2 or delta_y
		delta_z = out3 or delta_z
	end
	angle = monster.get_arc_tangent(delta_x, delta_z) or angle
	alignment = monster.get_angle_difference_cosine_3(facing_angle, angle) or alignment
	return alignment
end

--- Returns the signed angle between a facing direction and the direction from one point to another, wrapped to one turn.
function sense.get_facing_offset_to_point(from_x: f32, from_z: f32, facing_angle: f32, to_x: f32, to_z: f32)
	local angle_offset: f32 = 0
	angle_offset = monster.play_sound(to_x - from_x, to_z - from_z) or angle_offset
	angle_offset = vm.f32(angle_offset - facing_angle)
	if angle_offset > vm.f32(3.1415927) then
		angle_offset = vm.f32(angle_offset - vm.f32(6.2831855))
	end
	if angle_offset <= vm.f32(-3.1415927) then
		angle_offset = vm.f32(angle_offset + vm.f32(6.2831855))
	end
	return angle_offset
end

--- Returns the height of the ground under the monster.
function sense.get_ground_height(result: f32)
	local position_y: f32 = 0
	local height_above_ground: f32 = 0
	height_above_ground = monster.get_height_above_ground() or height_above_ground
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	result = vm.f32(position_y - height_above_ground)
	return result
end

--- Returns how much higher the ground at a position is than the ground under the monster.
function sense.get_ground_offset_at(x: f32, y: f32, z: f32, height_difference: f32)
	local own_ground_y: f32 = 0
	local position_ground_y: f32 = 0
	own_ground_y = sense.get_ground_height(own_ground_y)
	position_ground_y = sense.get_ground_y_at(x, y, z, position_ground_y)
	height_difference = vm.f32(position_ground_y - own_ground_y)
	return height_difference
end

--- Returns the ground height under a position by subtracting the height above ground from its y coordinate.
function sense.get_ground_y_at(x: f32, y: f32, z: f32, ground_y: f32)
	local height: f32 = 0
	height = monster.get_height_above_ground_at(x, y, z) or height
	ground_y = vm.f32(y - height)
	return ground_y
end

--- Returns the distance to the target ignoring height.
function sense.get_horizontal_target_distance(distance: f32)
	local position_x: f32 = 0
	local position_z: f32 = 0
	local target_x: f32 = 0
	local target_z: f32 = 0
	local horizontal_distance: f32 = 0
	do
		local out1, _, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	do
		local out1, _, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	horizontal_distance = monster.get_distance_between(target_x, 0.0, target_z, position_x, 0.0, position_z) or horizontal_distance
	distance = horizontal_distance
	return distance
end

--- Returns the signed angle between a facing direction and the direction from one point to another.
function sense.get_relative_angle_to_point(from_x: f32, from_z: f32, facing_angle: f32, to_x: f32, to_z: f32)
	local angle_offset: f32 = 0
	angle_offset = monster.get_arc_tangent(to_x - from_x, to_z - from_z) or angle_offset
	angle_offset = vm.f32(angle_offset - facing_angle)
	if angle_offset > vm.f32(3.1415927) then
		angle_offset = vm.f32(angle_offset - vm.f32(6.2831855))
	end
	if angle_offset <= vm.f32(-3.1415927) then
		angle_offset = vm.f32(angle_offset + vm.f32(6.2831855))
	end
	return angle_offset
end

--- Returns 1 when the monster faces the target, shifted by an angle offset, within an arc.
function sense.is_facing_target(angle_offset: f32, arc_width: f32)
	local rotation_y: f32 = 0
	local target_angle: f32 = 0
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	target_angle = monster.get_target_angle() or target_angle
	if calc.compare_angles(vm.f32(target_angle + angle_offset), rotation_y, vm.f32(arc_width / 2.0)) == 0 then
		return 1
	end
	return 0
end

--- Returns 1 when the monster faces the target within an arc given in degrees.
function sense.is_facing_target_degrees(angle_offset_degrees: s32, arc_degrees: any)
	return sense.is_facing_target(vm.f32(angle_offset_degrees * vm.f32(0.017453292)), arc_degrees * vm.f32(0.017453292))
end

--- Returns 1 when the monster faces within an arc, in degrees, centered on the target direction shifted by an offset in degrees.
function sense.is_facing_target_with_offset(offset_degrees: s32, arc_degrees: f32)
	return sense.is_facing_target(vm.f32(offset_degrees * vm.f32(0.017453292)), vm.f32(arc_degrees * vm.f32(0.017453292)))
end

--- Returns 1 when the monster faces within an arc, in whole degrees, centered on the target direction shifted by an offset in whole degrees.
function sense.is_facing_target_with_whole_offset(offset_degrees: s32, arc_degrees: s32)
	return sense.is_facing_target(vm.f32(offset_degrees * vm.f32(0.017453292)), vm.f32(arc_degrees * vm.f32(0.017453292)))
end

--- Returns 1 when the monster's rotation is within a half-angle in degrees of the direction to the target.
function sense.is_facing_target_within_angle(half_angle_degrees: f32)
	local rotation_y: f32 = 0
	local target_angle: f32 = 0
	target_angle = monster.get_target_angle() or target_angle
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	if rotation_y < vm.f32(target_angle + calc.degrees_to_radians(half_angle_degrees)) and rotation_y > vm.f32(target_angle + calc.degrees_to_radians(-half_angle_degrees)) then
		return 1
	end
	return 0
end

--- Returns 1 when a point lies inside a viewer's view cone and range, otherwise 0.
function sense.is_point_in_view(viewer_x: f32, viewer_z: f32, facing_angle: f32, view_half_angle: f32, view_range: f32, point_x: f32, point_z: f32)
	local angle_offset: f32 = 0
	local distance: f32 = 0
	angle_offset = sense.get_facing_offset_to_point(viewer_x, viewer_z, facing_angle, point_x, point_z)
	if angle_offset < -view_half_angle then
		return 0
	end
	if view_half_angle < angle_offset then
		return 0
	end
	distance = sense.get_distance_2d(viewer_x, viewer_z, point_x, point_z)
	if view_range < distance then
		return 0
	end
	return 1
end

--- Returns 1 when the target is within a range and inside an arc in front of the monster.
function sense.is_target_in_front(range: f32, arc_degrees: f32)
	local target_distance: f32 = 0
	local rotation_y: f32 = 0
	local target_angle: f32 = 0
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	target_distance = monster.get_target_distance() or target_distance
	target_angle = monster.get_target_angle() or target_angle
	if target_distance < range and rotation_y < vm.f32(target_angle + calc.degrees_to_radians(arc_degrees)) and rotation_y > vm.f32(target_angle + calc.degrees_to_radians(-arc_degrees)) then
		return 1
	end
	return 0
end

--- Returns 1 when the target is in range and in front of the monster, or close and moving fast.
function sense.is_target_threatening(attack_range: f32, half_angle_degrees: f32, close_range: f32, min_target_speed: f32)
	local rotation_y: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local target_speed: f32 = 0
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	target_distance = monster.get_target_distance() or target_distance
	target_angle = monster.get_target_angle() or target_angle
	target_speed = monster.get_target_speed() or target_speed
	half_angle_degrees = calc.degrees_to_radians(half_angle_degrees)
	if
		target_distance < attack_range and rotation_y < vm.f32(target_angle + half_angle_degrees) and rotation_y > vm.f32(target_angle - half_angle_degrees)
		or target_distance < close_range and target_speed > min_target_speed
	then
		return 1
	end
	return 0
end

--- Rotates a flying monster toward the player while the player is in its view cone and back toward a fixed point otherwise, announcing each case.
function sense.search_for_player()
	local searching: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local unused_input: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local unused_reference: f32 = 0
	local facing_angle: f32 = 0
	local turn_step: f32 = 0
	local sees_player: s32 = 0
	local angle_offset: f32 = 0
	local home_angle_offset: f32 = 0
	local new_x: f32 = 0
	local new_y: f32 = 0
	local new_z: f32 = 0
	local step_x: f32 = 0
	local step_z: f32 = 0
	local new_angle: f32 = 0
	local rotation_x: f32 = 0
	local rotation_z: f32 = 0
	monster.call_command(100, "飛行") -- retail: the handler rejects 1 arguments
	monster.stop_sound(1, 0, "飛行")
	searching = 1
	while searching ~= 0 do
		do
			local out1, _, out3 = monster.get_status_ailments()
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		monster.get_event_info_3(unused_input) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		monster.call_command(50, position_x, position_y, position_z) -- retail: the handler rejects 3 arguments
		do
			local out1, _ = monster.get_pause_flags(unused_reference) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
			facing_angle = vm.bits_float(out1) or facing_angle
		end
		sees_player = sense.is_point_in_view(position_x, position_z, facing_angle, 0.5, 800.0, player_x, player_z)
		if sees_player ~= 0 then
			monster.stop_sound(1, 1, "ハッケーン！")
			angle_offset = sense.get_facing_offset_to_point(position_x, position_z, facing_angle, player_x, player_z)
			if angle_offset < vm.f32(-0.005) or vm.f32(0.005) < angle_offset then
				if 0 < angle_offset then
					turn_step = angle_offset
					if vm.f32(0.025) < turn_step then
						turn_step = vm.f32(0.025)
					end
				else
					turn_step = angle_offset
					if turn_step < vm.f32(-0.025) then
						turn_step = vm.f32(-0.025)
					end
				end
			else
				turn_step = 0.0
				searching = 0
			end
		else
			monster.stop_sound(1, 1, "いないよぅ～")
			home_angle_offset = sense.get_facing_offset_to_point(position_x, position_z, facing_angle, vm.f32(268.8), vm.f32(-322.4))
			if true then
				if 0 < home_angle_offset then
					turn_step = home_angle_offset
					if vm.f32(0.025) < turn_step then
						turn_step = vm.f32(0.025)
					end
				else
					turn_step = home_angle_offset
					if turn_step < vm.f32(-0.025) then
						turn_step = vm.f32(-0.025)
					end
				end
			else
				turn_step = 0.0
			end
		end
		new_y = 800.0
		step_x = vm.f32(vm.sin(vm.f32(facing_angle + turn_step)) * 1.0)
		step_z = vm.f32(vm.cos(vm.f32(facing_angle + turn_step)) * 1.0)
		new_x = vm.f32(position_x + step_x)
		new_z = vm.f32(position_z + step_z)
		new_angle = vm.f32(facing_angle + turn_step)
		if new_angle > vm.f32(3.1415927) then
			new_angle = vm.f32(new_angle - vm.f32(6.2831855))
		end
		if new_angle <= vm.f32(-3.1415927) then
			new_angle = vm.f32(new_angle + vm.f32(6.2831855))
		end
		monster.set_pause_flags(new_x, new_y, new_z)
		do
			local _, out2 = monster.get_pause_flags(rotation_x) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
			rotation_z = out2 or rotation_z
		end
		monster.is_save_flag_set(rotation_x, new_angle, rotation_z)
		vm.wait()
	end
end

--- Stores a bit mask describing the target's distance band and facing in monster variable 0.
function sense.store_target_range_flags()
	local flags: s32 = 0
	local target_distance: f32 = 0
	flags = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance <= 0.0 then
		flags = vm.i32(bit32.bor(flags, 1))
	elseif target_distance <= 80.0 then
		flags = vm.i32(bit32.bor(flags, 2))
	elseif target_distance <= 800.0 then
		flags = vm.i32(bit32.bor(flags, 4))
	else
		flags = vm.i32(bit32.bor(flags, 8))
	end
	if target_distance <= 80.0 then
		flags = vm.i32(bit32.bor(flags, 16))
	end
	if sense.is_facing_target_degrees(0, 360.0) ~= 0 then
		flags = vm.i32(bit32.bor(flags, 32))
	end
	if target_distance <= 60.0 then
		flags = vm.i32(bit32.bor(flags, 64))
	end
	if sense.is_facing_target_degrees(0, 360.0) ~= 0 then
		flags = vm.i32(bit32.bor(flags, 128))
	end
	monster.set_variable(0, flags)
end

--- Waits up to the given frames and returns 1 as soon as the monster faces the target from within range or the target closes in quickly, otherwise 0.
function sense.wait_for_target_engagement(distance: f32, half_angle_degrees: f32, close_distance: f32, min_target_speed: f32, frames: s32)
	for i = 0, frames - 1 do
		timer.wait_frame()
		if sense.is_target_threatening(distance, half_angle_degrees, close_distance, min_target_speed) == 1 then
			return 1
		end
	end
	return 0
end

--- Waits up to a number of frames until the target is within a distance and in front of the monster, returning 1 when it is.
function sense.wait_for_target_in_cone(distance: f32, angle_degrees: f32, max_frames: s32)
	for i = 0, max_frames - 1 do
		monster.get_rotation()
		monster.get_target_distance()
		monster.get_target_angle()
		timer.wait_frame_with_reaction()
		if sense.is_target_in_front(distance, angle_degrees) == 1 then
			return 1
		end
	end
	return 0
end

--- Waits up to a number of frames until the target is in front or fast and near, returning 1 when it is.
function sense.wait_for_target_in_cone_or_approaching(distance: f32, angle_degrees: f32, near_distance: f32, approach_speed: f32, max_frames: s32)
	for i = 0, max_frames - 1 do
		timer.wait_frame_with_reaction()
		if sense.is_target_threatening(distance, angle_degrees, near_distance, approach_speed) == 1 then
			return 1
		end
	end
	return 0
end

--- Waits up to a frame limit until the target is within a distance and inside a half-angle in front of the monster, returning 1 when it is and 0 otherwise.
function sense.wait_until_target_in_arc(max_distance: f32, half_angle_degrees: f32, max_frames: s32)
	for i = 0, max_frames - 1 do
		monster.get_rotation()
		monster.get_target_distance()
		monster.get_target_angle()
		timer.wait_one_frame()
		if sense.is_target_in_front(max_distance, half_angle_degrees) == 1 then
			return 1
		end
	end
	return 0
end

--- Waits up to a frame limit until the target is within a distance and inside a half-angle in front of the monster, updating model lighting.
function sense.wait_until_target_in_arc_with_lighting(max_distance: f32, half_angle_degrees: f32, max_frames: s32)
	for i = 0, max_frames - 1 do
		monster.get_rotation()
		monster.get_target_distance()
		monster.get_target_angle()
		timer.wait_frame_with_lighting()
		if sense.is_target_in_front(max_distance, half_angle_degrees) == 1 then
			return 1
		end
	end
	return 0
end

--- Waits up to a number of frames for the target to be in front, returning 1 when it is.
function sense.wait_until_target_in_front(range: f32, arc_degrees: f32, frames: s32)
	for i = 0, frames - 1 do
		monster.get_rotation()
		monster.get_target_distance()
		monster.get_target_angle()
		reaction.update_and_wait_frame()
		if sense.is_target_in_front(range, arc_degrees) == 1 then
			return 1
		end
	end
	return 0
end

--- Waits up to the given frames and returns 1 as soon as the target is within range and in front of the monster. It updates the lighting each frame.
function sense.wait_until_target_in_front_updating_lighting(distance: f32, half_angle_degrees: f32, frames: s32)
	for i = 0, frames - 1 do
		monster.get_rotation()
		monster.get_target_distance()
		monster.get_target_angle()
		timer.wait_frame()
		if sense.is_target_in_front(distance, half_angle_degrees) == 1 then
			return 1
		end
	end
	return 0
end

--- Stands idle until the target comes within 280 units.
function sense.wait_until_target_near()
	local target_distance: f32 = 0
	while true do
		monster.set_motion("立ち", -1, 0)
		vm.wait()
		behavior.try_face_transformed_player_plain_speed_4()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 280.0 then
			vm.wait()
			return
		end
	end
end

--- Waits up to a frame limit until the target is threatening, returning 1 when it is.
function sense.wait_until_target_threatening(attack_range: f32, half_angle_degrees: f32, close_range: f32, min_target_speed: f32, max_frames: s32)
	for i = 0, max_frames - 1 do
		timer.wait_one_frame()
		if sense.is_target_threatening(attack_range, half_angle_degrees, close_range, min_target_speed) == 1 then
			return 1
		end
	end
	return 0
end

--- Waits up to a frame limit until the target is threatening, updating the guard state each frame and returning 1 when it is.
function sense.wait_until_target_threatening_guarded(attack_range: f32, half_angle_degrees: f32, close_range: f32, min_target_speed: f32, max_frames: s32)
	for i = 0, max_frames - 1 do
		reaction.update_and_wait_frame()
		if sense.is_target_threatening(attack_range, half_angle_degrees, close_range, min_target_speed) == 1 then
			return 1
		end
	end
	return 0
end

--- Waits up to a frame limit until the target is threatening, updating model lighting and returning 1 when it is.
function sense.wait_until_target_threatening_with_lighting(attack_range: f32, half_angle_degrees: f32, close_range: f32, min_target_speed: f32, max_frames: s32)
	for i = 0, max_frames - 1 do
		timer.wait_frame_with_lighting()
		if sense.is_target_threatening(attack_range, half_angle_degrees, close_range, min_target_speed) == 1 then
			return 1
		end
	end
	return 0
end

return sense
