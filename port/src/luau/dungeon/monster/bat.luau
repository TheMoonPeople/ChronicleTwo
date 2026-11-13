--!strict
--- Controls the Bat family of flying monsters: they hover, fly toward and around the player, dive at the player with a swoop attack and retreat, and change tactics once enraged.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the clip distance, using an unlimited distance for bosses.
local function apply_default_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Flies toward a position at a fixed step per frame, hovering above the ground, and returns 1 on arrival or the blocking result when the path is obstructed.
local function fly_to_position(target_x: f32, target_y: f32, target_z: f32, step_speed: f32, arrival_margin: f32, hover_height: f32, max_frames: any)
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local heading_radians: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_height: f32 = 0
	local distance_to_target: f32 = 0
	local height_above_ground: f32 = 0
	local frame: s32 = 0
	local blocked_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	ground_height = sense.get_ground_height(ground_height)
	target_y = vm.f32(ground_height + hover_height)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, current_x, current_y, current_z)
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
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_speed)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	monster.copy_vector(target_x, target_y, target_z)
	heading_radians = monster.get_angle_to_position(current_x + step_x, current_y + step_y, current_z + step_z) or heading_radians
	frame = 0
	while frame < max_frames do
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		height_above_ground = monster.get_height_above_ground_at(current_x, current_y, current_z) or height_above_ground
		if height_above_ground >= 50.0 or height_above_ground <= 0.0 then
			current_y = vm.f32(current_y - step_y)
			step_y = 0.0
		end
		distance_to_target = monster.get_distance_between(current_x, current_y, current_z, target_x, target_y, target_z) or distance_to_target
		if distance_to_target < vm.f32(step_speed + arrival_margin) then
			return 1
		end
		blocked_result = sense.check_flight_destination(current_x, current_y, current_z, step_speed, heading_radians)
		if blocked_result ~= 0 then
			return blocked_result
		end
		monster.set_position(current_x, current_y, current_z)
		monster.copy_vector(current_x, current_y, current_z)
		timer.wait_one_frame()
		frame = vm.i32(frame + 1)
	end
	return 0
end

--- Rises into the air and keeps facing the player until the player is no longer transformed.
local function hover_while_player_transformed(monster_kind: any)
	local position_x: f32 = 0
	local position_z: f32 = 0
	local player_transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	fly_to_position(position_x, 25.0, position_z, 0.875, 10.0, 5.0, 150)
	while true do
		timer.wait_one_frame()
		player_transform_id = monster.get_player_transform_id() or player_transform_id
		if player_transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(90.0) == 0 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(vm.f32(4.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Starts the hover routine when the player has transformed.
local function react_to_player_transformation()
	local player_transform_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	player_transform_id = monster.get_player_transform_id() or player_transform_id
	if player_transform_id > -1 then
		hover_while_player_transformed(monster_id)
	end
end

--- Turns toward a point offset from the player by an angle and distance and flies to it, returning the flight result.
local function fly_to_point_near_target(step_speed: f32, turn_speed: f32, offset_degrees: f32, offset_distance: f32, arrival_margin: f32, hover_height: f32, max_frames: s32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local result: s32 = 0
	approach_x, approach_y, approach_z = movement.get_approach_point(offset_degrees, offset_distance, approach_x, approach_y, approach_z)
	offset_degrees = monster.get_angle_to_position(approach_x, approach_y, approach_z) or offset_degrees
	if offset_degrees > vm.f32(3.1415927) then
		offset_degrees = vm.f32(offset_degrees - vm.f32(6.2831855))
	end
	if offset_degrees <= vm.f32(-3.1415927) then
		offset_degrees = vm.f32(offset_degrees + vm.f32(6.2831855))
	end
	movement.turn_to_angle(calc.radians_to_degrees(offset_degrees), turn_speed)
	movement.stop_turning()
	result = fly_to_position(approach_x, approach_y, approach_z, step_speed, arrival_margin, hover_height, max_frames)
	return result
end

--- Flies to a random spot near the player or waits until the player is in front.
local function reposition_near_target()
	local roll: s32 = 0
	local side_offset_degrees: f32 = 0
	local distance_offset: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_offset_degrees = monster.get_random_whole_number(30.0) or side_offset_degrees
		distance_offset = monster.get_random_whole_number(30.0) or distance_offset
		distance_offset = vm.f32(distance_offset + 100.0)
		if roll < 50 then
			side_offset_degrees = vm.f32(-side_offset_degrees - 30.0)
		else
			side_offset_degrees = vm.f32(side_offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		fly_to_point_near_target(1.75, vm.f32(4.8), side_offset_degrees, distance_offset, 50.0, 50.0, 30)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(50.0, 45.0, 30)
	end
end

--- Turns toward the player and flies straight at the player's position until close, blocked or out of frames.
local function fly_straight_at_target(step_speed: f32, turn_speed: f32, arrival_margin: f32, hover_height: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local yaw_radians: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_height: f32 = 0
	local distance_to_target: f32 = 0
	local height_above_ground: f32 = 0
	local blocked_result: s32 = 0
	distance_to_target = monster.get_target_distance() or distance_to_target
	movement.turn_toward_target_and_wait(turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_y = out3 or current_y
	end
	ground_height = sense.get_ground_height(ground_height)
	target_y = vm.f32(ground_height + hover_height)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, current_x, current_y, current_z)
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
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_speed)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw_radians = out2 or yaw_radians
	end
	for frame = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		height_above_ground = monster.get_height_above_ground_at(current_x, current_y, current_z) or height_above_ground
		if height_above_ground >= 50.0 or height_above_ground <= 0.0 then
			current_y = vm.f32(current_y - step_y)
			step_y = 0.0
		end
		distance_to_target = monster.get_distance_between(current_x, current_y, current_z, target_x, target_y, target_z) or distance_to_target
		if distance_to_target < vm.f32(step_speed + arrival_margin) then
			return
		end
		blocked_result = sense.check_flight_destination(current_x, current_y, current_z, step_speed, yaw_radians)
		if blocked_result ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(current_x, current_y, current_z)
		timer.wait_one_frame()
	end
end

--- Waits for the player, circles the player or flies straight at the player at long range.
local function act_at_long_range()
	local random_angle_degrees: f32 = 0
	local target_distance: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 30 then
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(50.0, 45.0, 45)
	else
		roll = monster.get_random(100) or roll
		if roll < 30 then
			monster.set_motion("歩き", -1, 0)
			target_distance = monster.get_target_distance() or target_distance
			monster.get_random_whole_number(360.0, random_angle_degrees)
			fly_to_point_near_target(1.75, vm.f32(4.8), random_angle_degrees, target_distance, 50.0, 50.0, 50)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			fly_straight_at_target(4.0, vm.f32(4.8), 50.0, 50.0, 30)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Flies toward the player, waits or circles the player at medium range.
local function act_at_mid_range()
	local random_angle_degrees: f32 = 0
	local target_distance: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.set_motion("歩き", -1, 0)
		movement.fly_toward_target(4.0, vm.f32(4.8), 50.0, 40.0, 0, 90)
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(50.0, 45.0, 45)
		else
			monster.set_motion("歩き", -1, 0)
			target_distance = monster.get_target_distance() or target_distance
			random_angle_degrees = monster.get_random_whole_number(360.0) or random_angle_degrees
			fly_to_point_near_target(1.75, vm.f32(4.8), random_angle_degrees, target_distance, 50.0, 50.0, 50)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Dives at the player, then flies back away from the player after the strike.
local function swoop_attack()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local heading_radians: f32 = 0
	local ground_offset: f32 = 0
	monster.set_motion("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	movement.turn_toward_target_and_wait(vm.f32(9.6))
	monster.reset_motion()
	monster.set_motion("攻撃１in", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("攻撃１", -1, 0)
	ground_offset = sense.get_ground_offset_at(target_x, target_y, target_z, ground_offset)
	fly_to_position(target_x, vm.f32(target_y + 10.0), target_z, 5.25, 5.0, 10.0, 60)
	heading_radians = monster.get_target_angle() or heading_radians
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
		position_z = out3 or position_z
	end
	monster.set_rotation(0.0, heading_radians, 0.0)
	vm.wait()
	heading_radians = vm.f32(heading_radians + vm.f32(3.1415927))
	if heading_radians > vm.f32(3.1415927) then
		heading_radians = vm.f32(heading_radians - vm.f32(6.2831855))
	end
	if heading_radians <= vm.f32(-3.1415927) then
		heading_radians = vm.f32(heading_radians + vm.f32(6.2831855))
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(heading_radians) * 150.0))
	position_z = vm.f32(position_z + vm.f32(vm.cos(heading_radians) * 150.0))
	monster.set_motion("攻撃１out", -1, 6)
	fly_to_position(position_x, position_y, position_z, vm.f32(2.1000001), vm.f32(16.666666), 50.0, 30)
end

--- Flies backward away from the direction the monster is facing.
local function fly_backward(step_speed: f32, arrival_margin: f32, hover_height: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local yaw_radians: f32 = 0
	local backward_yaw_radians: f32 = 0
	local retreat_distance: f32 = 0
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw_radians = out2 or yaw_radians
	end
	backward_yaw_radians = vm.f32(yaw_radians + vm.f32(3.1415927))
	if backward_yaw_radians > vm.f32(3.1415927) then
		backward_yaw_radians = vm.f32(backward_yaw_radians - vm.f32(6.2831855))
	end
	if backward_yaw_radians <= vm.f32(-3.1415927) then
		backward_yaw_radians = vm.f32(backward_yaw_radians + vm.f32(6.2831855))
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(backward_yaw_radians) * retreat_distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(backward_yaw_radians) * retreat_distance))
	fly_to_position(position_x, position_y, position_z, step_speed, arrival_margin, hover_height, max_frames)
end

--- Swoops at the player, circles the player or backs away at close range.
local function act_at_close_range()
	local target_distance: f32 = 0
	local roll: s32 = 0
	local random_angle_degrees: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.set_motion("歩き", -1, 0)
		fly_straight_at_target(1.75, vm.f32(4.8), 50.0, 50.0, 15)
		swoop_attack()
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_motion("歩き", -1, 0)
			target_distance = monster.get_target_distance() or target_distance
			random_angle_degrees = monster.get_random_whole_number(360.0) or random_angle_degrees
			target_distance = vm.f32(target_distance + 30.0)
			fly_to_point_near_target(1.75, vm.f32(4.8), random_angle_degrees, target_distance, 25.0, 40.0, 50)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			fly_backward(1.75, 50.0, 46.0, 60)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Picks the flying approach or attack for the player's horizontal distance.
local function choose_attack_by_distance()
	local horizontal_distance: f32 = 0
	local rage_hits_left: s32 = 0
	local priority: s32 = 0
	react_to_player_transformation()
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left <= 0 then
		return
	end
	priority = monster.get_priority() or priority
	if priority > 6 then
		reposition_near_target()
		return
	end
	horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
	if horizontal_distance < 350.0 and horizontal_distance >= 180.0 then
		act_at_long_range()
	elseif horizontal_distance < 180.0 and horizontal_distance >= 100.0 then
		act_at_mid_range()
	else
		act_at_close_range()
	end
end

--- Turns to a direction and flies the given distance that way.
local function turn_and_fly_in_direction(turn_speed: f32, step_speed: f32, direction_degrees: f32, distance: f32, arrival_margin: f32, hover_height: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	movement.turn_to_angle(direction_degrees, turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(vm.f32(direction_degrees * vm.f32(0.017453292))) * distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(vm.f32(direction_degrees * vm.f32(0.017453292))) * distance))
	local _ = fly_to_position(position_x, position_y, position_z, step_speed, arrival_margin, hover_height, max_frames)
end

--- Flies to a point on a circle around a position, turning toward it first.
local function fly_around_position(
	center_x: f32,
	center_y: f32,
	center_z: f32,
	step_speed: f32,
	turn_speed: f32,
	radius: f32,
	orbit_degrees: f32,
	arrival_margin: f32,
	hover_height: f32,
	max_frames: s32
)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local orbit_offset_radians: f32 = 0
	local orbit_angle_radians: f32 = 0
	orbit_offset_radians = vm.f32(orbit_degrees * vm.f32(0.017453292))
	orbit_angle_radians = monster.get_angle_to_position(center_x, center_y, center_z) or orbit_angle_radians
	orbit_angle_radians = vm.f32(orbit_angle_radians - vm.f32(3.1415927))
	orbit_angle_radians = vm.f32(orbit_angle_radians + orbit_offset_radians)
	if orbit_angle_radians > vm.f32(3.1415927) then
		orbit_angle_radians = vm.f32(orbit_angle_radians - vm.f32(6.2831855))
	end
	if orbit_angle_radians <= vm.f32(-3.1415927) then
		orbit_angle_radians = vm.f32(orbit_angle_radians + vm.f32(6.2831855))
	end
	destination_x = vm.f32(center_x + vm.f32(radius * vm.sin(orbit_angle_radians)))
	destination_y = 0.0
	destination_z = vm.f32(center_z + vm.f32(radius * vm.cos(orbit_angle_radians)))
	orbit_degrees = monster.get_angle_to_position(destination_x, destination_y, destination_z) or orbit_degrees
	movement.turn_to_angle(calc.radians_to_degrees(orbit_degrees), turn_speed)
	movement.stop_turning()
	local _ = fly_to_position(destination_x, destination_y, destination_z, step_speed, arrival_margin, hover_height, max_frames)
end

--- Flies the given distance in a direction relative to the world.
local function fly_in_direction(step_speed: f32, direction_degrees: f32, distance: f32, arrival_margin: f32, hover_height: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	direction_degrees = calc.degrees_to_radians(direction_degrees)
	if direction_degrees > vm.f32(3.1415927) then
		direction_degrees = vm.f32(direction_degrees - vm.f32(6.2831855))
	end
	if direction_degrees <= vm.f32(-3.1415927) then
		direction_degrees = vm.f32(direction_degrees + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(direction_degrees) * distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(direction_degrees) * distance))
	local _ = fly_to_position(position_x, position_y, position_z, step_speed, arrival_margin, hover_height, max_frames)
end

--- Turns a random angle and flies a random distance forward.
local function wander_in_air(step_speed: f32, turn_speed: f32, base_distance: f32, angle_range_degrees: f32, distance_range: f32, arrival_margin: f32, hover_height: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local yaw_radians: f32 = 0
	local travel_distance: f32 = 0
	local turn_angle_degrees: f32 = 0
	travel_distance = monster.get_random_whole_number(distance_range) or travel_distance
	turn_angle_degrees = monster.get_random_whole_number(angle_range_degrees) or turn_angle_degrees
	travel_distance = vm.f32(travel_distance + base_distance)
	movement.turn_to_angle(turn_angle_degrees, turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw_radians = out2 or yaw_radians
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(yaw_radians) * travel_distance))
	position_z = vm.f32(position_z + vm.f32(vm.cos(yaw_radians) * travel_distance))
	local _ = fly_to_position(position_x, position_y, position_z, step_speed, arrival_margin, hover_height, max_frames)
end

--- Roams the air around the home position: turns away from walls, returns toward home when too far, and otherwise waits, turns, circles or wanders.
local function roam_around_home()
	local roll: s32 = 0
	local threat_result: s32 = 0
	local unused_mode: s32 = 0
	local distance_from_home: f32 = 0
	local turn_angle_degrees: f32 = 0
	local home_x: f32 = 0
	local home_y: f32 = 0
	local home_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local yaw_radians: f32 = 0
	local clear_distance: f32 = 0
	local target_y: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local approach_angle_degrees: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local closing_turn_degrees: f32 = 0
	timer.wait_one_frame()
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
	distance_from_home = monster.get_distance_between(position_x, position_y, position_z, home_x, home_y, home_z) or distance_from_home
	do
		local _, out2, _ = monster.get_rotation()
		yaw_radians = out2 or yaw_radians
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 50.0 then
		print("1------------------------------------------------\n")
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1, 0)
		movement.turn_to_angle(turn_angle_degrees, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 50.0)
		if clear_distance > 0.0 then
			turn_and_fly_in_direction(vm.f32(4.8), 1.75, turn_angle_degrees, clear_distance, 50.0, 50.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance_from_home > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance_from_home > 800.0 then
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
				monster.set_place_position(position_x, target_y + 50.0, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				print("2------------------------------------------------\n")
				monster.set_secondary_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_angle_degrees = monster.get_random_whole_number(360.0) or orbit_angle_degrees
				distance_from_home = monster.get_random_whole_number(150.0) or distance_from_home
				if roll < 50 then
					orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
				else
					orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				fly_around_position(home_x, home_y, home_z, 1.75, vm.f32(4.8), distance_from_home, orbit_angle_degrees, 50.0, 50.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle(final_turn_degrees, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 30 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_secondary_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.set_secondary_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_to_angle(turn_angle_degrees, vm.f32(4.8))
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
					approach_angle_degrees = monster.get_random_whole_number(180.0) or approach_angle_degrees
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if roll < 50 then
						approach_angle_degrees = vm.f32(approach_angle_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						approach_angle_degrees = vm.f32(-approach_angle_degrees - 30.0)
					else
						approach_angle_degrees = vm.f32(approach_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					threat_result = fly_to_point_near_target(1.75, vm.f32(4.8), approach_angle_degrees, approach_distance, 50.0, 50.0, 60)
					closing_turn_degrees = monster.get_random_whole_number(360.0) or closing_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						closing_turn_degrees = vm.f32(closing_turn_degrees * -1.0)
					end
					movement.turn_to_angle(closing_turn_degrees, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.set_secondary_variable(0, 32)
					monster.set_motion("歩き", -1, 0)
					do
						local _, out2, _ = monster.get_rotation()
						yaw_radians = out2 or yaw_radians
					end
					turn_angle_degrees = calc.radians_to_degrees(yaw_radians)
					if turn_angle_degrees > vm.f32(3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees - vm.f32(6.2831855))
					end
					if turn_angle_degrees <= vm.f32(-3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees + vm.f32(6.2831855))
					end
					fly_in_direction(1.75, turn_angle_degrees, 1000.0, 50.0, 50.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
		elseif unused_mode == 8 then
			print("7------------------------------------------------\n")
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance_from_home = monster.get_target_distance() or distance_from_home
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1, 0)
			wander_in_air(1.75, vm.f32(4.8), distance_from_home, 360.0, 40.0, 50.0, 50.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Swoops at a nearby player or flies toward a distant one while enraged.
local function attack_while_enraged()
	local rage_hits_left: s32 = 0
	local horizontal_distance: f32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		return
	end
	horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
	if horizontal_distance < 100.0 then
		monster.set_motion("歩き", -1, 0)
		fly_straight_at_target(1.75, vm.f32(4.8), 50.0, 50.0, 30)
		swoop_attack()
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("歩き", -1, 0)
		movement.fly_toward_target(1.75, vm.f32(4.8), 50.0, 50.0, 0, 45)
		monster.set_motion("立ち", -1, 0)
	end
end

local script = {}

--- Does nothing because the monster needs no load-time setup.
function script.setup() end

--- Sets the clip distance, registers the contact hit window by grade, and starts the monster hovering.
function script.init()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local grade: s32 = 0
	monster.set_clip_distance(500.0)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.register_damage_hit("通常攻撃", 4.0, "攻撃１", 0.0, 1.0, 0)
	end
	if grade == 1 then
		monster.register_damage_hit("通常毒", 4.0, "攻撃１", 0.0, 1.0, 0)
	end
	if grade == 2 then
		monster.register_damage_hit("通常毒", 4.0, "攻撃１", 0.0, 1.0, 0)
	end
	if grade == 3 then
		monster.register_damage_hit("通常毒", 4.0, "攻撃１", 0.0, 1.0, 0)
	end
	monster.set_variable(0, 0)
	apply_default_clip_distance()
	monster.stop_moving()
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(256, 1)
	state.setup_default_ranges()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_position(position_x, position_y + 10.0, position_z)
	state.set_max_flight_height(55.0)
end

--- Clears the mask flags and repeatedly chooses between attacking, roaming and the enraged routine.
function script.loop()
	local horizontal_distance: f32 = 0
	local rage_hits_left: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
			react_to_player_transformation()
			if horizontal_distance < 350.0 then
				choose_attack_by_distance()
			else
				roam_around_home()
			end
		else
			attack_while_enraged()
		end
	end
end

--- Plays the damage motion and waits until the status ailment wears off.
function script.on_status_hit()
	local status_ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	status_ailments = 1
	while status_ailments ~= 0 do
		status_ailments = monster.get_status_ailments(40) or status_ailments
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Stops moving, plays the damage motion and stays staggered briefly.
function script.on_damage()
	movement.stop_and_reset_motion()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Begins and ends a knockdown with no extra motion.
function script.on_knockdown()
	reaction.begin_knockdown()
	reaction.end_knockdown()
end

--- Locks and unlocks the monster without guarding.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Locks and unlocks the monster without dodging.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Locks and unlocks the monster without dodging.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Starts the death fall, plays the death motion and then the death effects.
function script.on_death()
	death.start_death_and_fall()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Plays the struggling motion forever while the bat is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers from a throw, plays the get-up motion and resumes flying.
function script.on_land()
	reaction.end_throw_and_resume_flying()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	movement.raise_one_unit()
	return 1
end

--- Plays the knocked-over and get-up motions and stays stunned until the stars fade.
function script.on_stun()
	reaction.begin_stun()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_stars_fade()
end

return script
