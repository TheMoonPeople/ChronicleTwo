--!strict
--- Controls a test copy of the bat that evades the target until its rage counter runs out and then dives at it.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Uses a short clip distance for a normal monster and an unlimited one for a boss.
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

--- Flies toward a position at a height above the ground, stopping on arrival, a blocked path or after a frame limit.
local function fly_toward_position(target_x: f32, target_y: f32, target_z: f32, speed: f32, arrival_margin: f32, height_offset: f32, max_frames: any)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local travel_angle: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_height: f32 = 0
	local remaining_distance: f32 = 0
	local height_above_ground: f32 = 0
	local frame: s32 = 0
	local blocked_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	ground_height = sense.get_ground_height(ground_height)
	print("ground=", vm.float(ground_height), "---------------\n")
	target_y = vm.f32(ground_height + height_offset)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, pos_x, pos_y, pos_z)
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
	monster.copy_vector(target_x, target_y, target_z)
	travel_angle = monster.get_angle_to_position(pos_x + step_x, pos_y + step_y, pos_z + step_z) or travel_angle
	frame = 0
	while frame < max_frames do
		do
			local out1, out2, out3 = monster.add_vectors(pos_x, pos_y, pos_z, step_x, step_y, step_z)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		height_above_ground = monster.get_height_above_ground_at(pos_x, pos_y, pos_z) or height_above_ground
		if height_above_ground >= 50.0 or height_above_ground <= 0.0 then
			pos_y = vm.f32(pos_y - step_y)
			step_y = 0.0
		end
		remaining_distance = monster.get_distance_between(pos_x, pos_y, pos_z, target_x, target_y, target_z) or remaining_distance
		if remaining_distance < vm.f32(speed + arrival_margin) then
			print("hit1------------------\n")
			return 1
		end
		blocked_result = sense.check_flight_destination(pos_x, pos_y, pos_z, speed, travel_angle)
		if blocked_result ~= 0 then
			print("hit2------------------\n")
			return blocked_result
		end
		monster.set_position(pos_x, pos_y, pos_z)
		monster.copy_vector(pos_x, pos_y, pos_z)
		timer.wait_one_frame()
		frame = vm.i32(frame + 1)
	end
	return 0
end

--- Flies above its position and keeps facing the target while the player stays transformed.
local function hover_while_player_transformed(monster_kind: any)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	fly_toward_position(pos_x, 25.0, pos_z, 0.875, 10.0, 5.0, 150)
	while true do
		timer.wait_one_frame()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
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

--- Hovers when the player is transformed.
local function react_to_player_transformation()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		hover_while_player_transformed(monster_kind)
	end
end

--- Flies to a point at a given angle and distance around the target.
local function fly_around_target(speed: f32, turn_speed: f32, orbit_angle: f32, orbit_distance: f32, arrival_margin: f32, height_offset: f32, max_frames: s32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local flight_result: s32 = 0
	print("FLMTargetAroundMove---------------\n")
	approach_x, approach_y, approach_z = movement.get_approach_point(orbit_angle, orbit_distance, approach_x, approach_y, approach_z)
	orbit_angle = monster.get_angle_to_position(approach_x, approach_y, approach_z) or orbit_angle
	if orbit_angle > vm.f32(3.1415927) then
		orbit_angle = vm.f32(orbit_angle - vm.f32(6.2831855))
	end
	if orbit_angle <= vm.f32(-3.1415927) then
		orbit_angle = vm.f32(orbit_angle + vm.f32(6.2831855))
	end
	movement.turn_to_angle(calc.radians_to_degrees(orbit_angle), turn_speed)
	movement.stop_turning()
	flight_result = fly_toward_position(approach_x, approach_y, approach_z, speed, arrival_margin, height_offset, max_frames)
	return flight_result
end

--- Either strafes around the target or waits for it to come into an arc.
local function strafe_or_wait()
	local roll: s32 = 0
	local orbit_angle: f32 = 0
	local orbit_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		orbit_angle = monster.get_random_whole_number(30.0) or orbit_angle
		orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
		orbit_distance = vm.f32(orbit_distance + 100.0)
		if roll < 50 then
			orbit_angle = vm.f32(-orbit_angle - 30.0)
		else
			orbit_angle = vm.f32(orbit_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		fly_around_target(1.75, vm.f32(4.8), orbit_angle, orbit_distance, 50.0, 50.0, 30)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(50.0, 45.0, 30)
	end
end

--- Flies toward the target at a height above the ground until close or blocked.
local function fly_toward_target(speed: f32, turn_speed: f32, arrival_margin: f32, height_offset: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_height: f32 = 0
	local target_distance: f32 = 0
	local height_above_ground: f32 = 0
	local blocked_result: s32 = 0
	print("FLMTargetMove---------------\n")
	target_distance = monster.get_target_distance() or target_distance
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
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_y = out3 or pos_y
	end
	ground_height = sense.get_ground_height(ground_height)
	target_y = vm.f32(ground_height + height_offset)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, pos_x, pos_y, pos_z)
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
	for index = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(pos_x, pos_y, pos_z, step_x, step_y, step_z)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		height_above_ground = monster.get_height_above_ground_at(pos_x, pos_y, pos_z) or height_above_ground
		if height_above_ground >= 50.0 or height_above_ground <= 0.0 then
			pos_y = vm.f32(pos_y - step_y)
			step_y = 0.0
		end
		target_distance = monster.get_distance_between(pos_x, pos_y, pos_z, target_x, target_y, target_z) or target_distance
		if target_distance < vm.f32(speed + arrival_margin) then
			return
		end
		blocked_result = sense.check_flight_destination(pos_x, pos_y, pos_z, speed, facing_angle)
		if blocked_result ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(pos_x, pos_y, pos_z)
		timer.wait_one_frame()
	end
end

--- Waits, circles the target or flies toward it when the target is far away.
local function move_at_far_range()
	local orbit_angle: f32 = 0
	local target_distance: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(50.0, 45.0, 45)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			target_distance = monster.get_target_distance() or target_distance
			monster.get_random_whole_number(360.0, orbit_angle)
			fly_around_target(1.75, vm.f32(4.8), orbit_angle, target_distance, 50.0, 50.0, 50)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			fly_toward_target(vm.f32(7.2), vm.f32(4.8), 50.0, 50.0, 30)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Flies toward the target, waits or circles it when the target is at medium range.
local function move_at_mid_range()
	local orbit_angle: f32 = 0
	local target_distance: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 33 then
		monster.set_motion("歩き", -1, 0)
		fly_toward_target(vm.f32(7.2), vm.f32(4.8), 50.0, 50.0, 45)
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(50.0, 45.0, 45)
		else
			monster.set_motion("歩き", -1, 0)
			target_distance = monster.get_target_distance() or target_distance
			orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
			fly_around_target(1.75, vm.f32(4.8), orbit_angle, target_distance, 50.0, 50.0, 50)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Dives at the target, strikes and flies back out.
local function dive_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_angle: f32 = 0
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
	fly_toward_position(target_x, vm.f32(target_y + 10.0), target_z, 5.25, 5.0, 10.0, 60)
	target_angle = monster.get_target_angle() or target_angle
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_rotation(0.0, target_angle, 0.0)
	vm.wait()
	target_angle = vm.f32(target_angle + vm.f32(3.1415927))
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(target_angle) * 150.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(target_angle) * 150.0))
	monster.set_motion("攻撃１out", -1, 6)
	fly_toward_position(pos_x, pos_y, pos_z, vm.f32(2.1000001), vm.f32(16.666666), 50.0, 30)
end

--- Flies backward from the current facing.
local function fly_backward(speed: f32, arrival_margin: f32, height_offset: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local back_angle: f32 = 0
	local distance: f32 = 0
	print("FlyBackMove---------------\n")
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(back_angle) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(back_angle) * distance))
	fly_toward_position(pos_x, pos_y, pos_z, speed, arrival_margin, height_offset, max_frames)
end

--- Dives at the target, circles it or backs away when the target is near.
local function move_at_near_range()
	local target_distance: f32 = 0
	local roll: s32 = 0
	local orbit_angle: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.set_motion("歩き", -1, 0)
		fly_toward_target(1.75, vm.f32(4.8), 50.0, 50.0, 15)
		dive_attack()
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_motion("歩き", -1, 0)
			target_distance = monster.get_target_distance() or target_distance
			orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
			target_distance = vm.f32(target_distance + 30.0)
			fly_around_target(1.75, vm.f32(4.8), orbit_angle, target_distance, 25.0, 40.0, 50)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			fly_backward(1.75, 50.0, 46.0, 60)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Picks a movement that suits the horizontal distance to the target while its rage counter is above zero.
local function choose_movement_by_distance()
	local horizontal_distance: f32 = 0
	local rage_hits_left: s32 = 0
	local priority: s32 = 0
	react_to_player_transformation()
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left <= 0 then
		return
	end
	priority = monster.get_priority() or priority
	if priority > 4 then
		strafe_or_wait()
		return
	end
	horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
	if horizontal_distance < 300.0 and horizontal_distance >= 180.0 then
		move_at_far_range()
	elseif horizontal_distance < 180.0 and horizontal_distance >= 100.0 then
		move_at_mid_range()
	else
		move_at_near_range()
	end
end

--- Turns to a heading in degrees and flies a distance along it.
local function turn_and_fly_in_direction(turn_speed: f32, speed: f32, heading_degrees: f32, distance: f32, arrival_margin: f32, height_offset: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	print("FlyEnemyMove---------------\n")
	movement.turn_to_angle(heading_degrees, turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(vm.f32(heading_degrees * vm.f32(0.017453292))) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(vm.f32(heading_degrees * vm.f32(0.017453292))) * distance))
	local _ = fly_toward_position(pos_x, pos_y, pos_z, speed, arrival_margin, height_offset, max_frames)
end

--- Flies to a point on a circle around a position, offset by an angle.
local function fly_to_point_around_place(
	place_x: f32,
	place_y: f32,
	place_z: f32,
	speed: f32,
	turn_speed: f32,
	radius: f32,
	angle_offset_degrees: f32,
	arrival_margin: f32,
	height_offset: f32,
	max_frames: s32
)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local angle_offset: f32 = 0
	local orbit_angle: f32 = 0
	angle_offset = vm.f32(angle_offset_degrees * vm.f32(0.017453292))
	orbit_angle = monster.get_angle_to_position(place_x, place_y, place_z) or orbit_angle
	orbit_angle = vm.f32(orbit_angle - vm.f32(3.1415927))
	orbit_angle = vm.f32(orbit_angle + angle_offset)
	if orbit_angle > vm.f32(3.1415927) then
		orbit_angle = vm.f32(orbit_angle - vm.f32(6.2831855))
	end
	if orbit_angle <= vm.f32(-3.1415927) then
		orbit_angle = vm.f32(orbit_angle + vm.f32(6.2831855))
	end
	point_x = vm.f32(place_x + vm.f32(radius * vm.sin(orbit_angle)))
	point_y = 0.0
	point_z = vm.f32(place_z + vm.f32(radius * vm.cos(orbit_angle)))
	angle_offset_degrees = monster.get_angle_to_position(point_x, point_y, point_z) or angle_offset_degrees
	movement.turn_to_angle(calc.radians_to_degrees(angle_offset_degrees), turn_speed)
	movement.stop_turning()
	local _ = fly_toward_position(point_x, point_y, point_z, speed, arrival_margin, height_offset, max_frames)
end

--- Flies a distance along a heading given in degrees.
local function fly_along_heading(speed: f32, heading_degrees: f32, distance: f32, arrival_margin: f32, height_offset: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	print("FLMSkyEnemyMove---------------\n")
	heading_degrees = calc.degrees_to_radians(heading_degrees)
	if heading_degrees > vm.f32(3.1415927) then
		heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
	end
	if heading_degrees <= vm.f32(-3.1415927) then
		heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(heading_degrees) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(heading_degrees) * distance))
	local _ = fly_toward_position(pos_x, pos_y, pos_z, speed, arrival_margin, height_offset, max_frames)
end

--- Turns to a random heading and flies a random distance along it.
local function fly_in_random_direction(speed: f32, turn_speed: f32, base_distance: f32, heading_range_degrees: f32, distance_range: f32, arrival_margin: f32, height_offset: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local distance: f32 = 0
	local heading_degrees: f32 = 0
	print("FLMRandomMove---------------\n")
	distance = monster.get_random_whole_number(distance_range) or distance
	heading_degrees = monster.get_random_whole_number(heading_range_degrees) or heading_degrees
	distance = vm.f32(distance + base_distance)
	movement.turn_to_angle(heading_degrees, turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(facing_angle) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(facing_angle) * distance))
	local _ = fly_toward_position(pos_x, pos_y, pos_z, speed, arrival_margin, height_offset, max_frames)
end

--- Picks an idle flight pattern such as circling the place position, waiting or wandering while the rage counter is above zero.
local function choose_idle_flight()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local distance_from_place: f32 = 0
	local heading_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local clear_distance: f32 = 0
	local target_height: f32 = 0
	local orbit_angle: f32 = 0
	local turn_degrees: f32 = 0
	local side_angle: f32 = 0
	local side_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
	print("FlyMoveAction---------------\n")
	timer.wait_one_frame()
	roll = monster.get_random(100) or roll
	if roll < 10 then
	else
	end
	monster.set_secondary_variable(0, 0)
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
	distance_from_place = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or distance_from_place
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 50.0 then
		print("1------------------------------------------------\n")
		heading_degrees = monster.get_random_whole_number(360.0) or heading_degrees
		monster.set_motion("歩き", -1, 0)
		movement.turn_to_angle(heading_degrees, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 50.0)
		if clear_distance > 0.0 then
			turn_and_fly_in_direction(vm.f32(4.8), 1.75, heading_degrees, clear_distance, 50.0, 50.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance_from_place > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance_from_place > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				do
					local _, out2, _ = monster.get_target_position()
					target_height = out2 or target_height
				end
				monster.set_place_position(pos_x, target_height + 50.0, pos_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				print("2------------------------------------------------\n")
				monster.set_secondary_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
				distance_from_place = monster.get_random_whole_number(150.0) or distance_from_place
				if roll < 50 then
					orbit_angle = vm.f32(-orbit_angle - 30.0)
				else
					orbit_angle = vm.f32(orbit_angle + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				fly_to_point_around_place(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), distance_from_place, orbit_angle, 50.0, 50.0, 60)
				turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_degrees = vm.f32(turn_degrees * -1.0)
				end
				movement.turn_to_angle(turn_degrees, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
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
			heading_degrees = monster.get_random_whole_number(180.0) or heading_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				heading_degrees = vm.f32(heading_degrees * -1.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_to_angle(heading_degrees, vm.f32(4.8))
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
					side_angle = monster.get_random_whole_number(180.0) or side_angle
					side_distance = monster.get_random_whole_number(30.0) or side_distance
					target_distance = monster.get_target_distance() or target_distance
					side_distance = vm.f32(side_distance + target_distance)
					if roll < 50 then
						side_angle = vm.f32(side_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						side_angle = vm.f32(-side_angle - 30.0)
					else
						side_angle = vm.f32(side_angle + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					wait_result = fly_around_target(1.75, vm.f32(4.8), side_angle, side_distance, 50.0, 50.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_angle(final_turn_degrees, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.set_secondary_variable(0, 32)
					monster.set_motion("歩き", -1, 0)
					do
						local _, out2, _ = monster.get_rotation()
						facing_angle = out2 or facing_angle
					end
					heading_degrees = calc.radians_to_degrees(facing_angle)
					if heading_degrees > vm.f32(3.1415927) then
						heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
					end
					if heading_degrees <= vm.f32(-3.1415927) then
						heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
					end
					fly_along_heading(1.75, heading_degrees, 1000.0, 50.0, 50.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			print("7------------------------------------------------\n")
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance_from_place = monster.get_target_distance() or distance_from_place
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1, 0)
			fly_in_random_direction(1.75, vm.f32(4.8), distance_from_place, 360.0, 40.0, 50.0, 50.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Dives at a close target or flies toward a far one once the rage counter reaches zero.
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
		fly_toward_target(1.75, vm.f32(4.8), 50.0, 50.0, 30)
		dive_attack()
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("歩き", -1, 0)
		movement.fly_toward_target(1.75, vm.f32(4.8), 50.0, 50.0, 0, 45)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Stops the monster and lets it fall until it touches the ground.
local function fall_to_ground_dying()
	local height_above_ground: f32 = 0
	monster.stop_moving()
	movement.stop_turning()
	monster.start_death()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(256, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_motion("ダメージ", -1, 0)
	while true do
		timer.wait_one_frame()
		monster.get_position_3()
		height_above_ground = monster.get_height_above_ground() or height_above_ground
		if height_above_ground <= 0.0 then
			break
		end
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the dive hit and puts the bat in the air.
function script.init()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.set_clip_distance(500.0)
	monster.register_damage_hit("通常攻撃", 4.0, "攻撃１", 0.0, 1.0, 0)
	monster.set_variable(0, 0)
	configure_clip_distance()
	monster.stop_moving()
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(256, 1)
	state.setup_default_ranges()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, pos_y + 10.0, pos_z)
	state.set_max_flight_height(55.0)
end

--- Evades the target while its rage counter is above zero and attacks once the counter reaches zero.
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
			if horizontal_distance < 300.0 then
				choose_movement_by_distance()
			else
				choose_idle_flight()
			end
		else
			attack_while_enraged()
		end
	end
end

--- Staggers and holds still until the status ailment ends, then stands again.
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

--- Reacts to a staggering hit.
function script.on_damage()
	movement.stop_and_reset_motion()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Reacts to a knockdown hit.
function script.on_knockdown()
	reaction.begin_knockdown()
	reaction.end_knockdown()
end

--- Reacts to guarding against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Reacts to dodging the first kind of attack.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Reacts to dodging the second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Falls to the ground, plays the death motion and spawns the death effects.
function script.on_death()
	local height_above_ground: f32 = 0
	fall_to_ground_dying()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(256, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_motion("落下", -1, 0)
	while true do
		vm.wait()
		monster.get_position_3()
		height_above_ground = monster.get_height_above_ground() or height_above_ground
		if height_above_ground <= 0.0 then
			break
		end
	end
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	death.play_death_effects_forever()
end

--- Struggles while it is carried.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers from a throw, stands up and resumes flying.
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

--- Is knocked back by the stun, gets up and waits for the stars to fade.
function script.on_stun()
	reaction.begin_stun()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_stars_fade()
end

return script
