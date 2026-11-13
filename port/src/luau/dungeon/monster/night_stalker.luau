--!strict
--- Controls the Night Stalker, a flying ghost family that swoops, spins its sword and shoots fireballs.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets how far away the monster stays visible, unlimited for bosses.
local function set_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Flies toward a point at the given hover height until it arrives, hits something or runs out of frames.
local function fly_toward_point(target_x: f32, target_y: f32, target_z: f32, scale: f32, stop_margin: f32, hover_height: f32, max_frames: any)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local heading: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local ground_height: f32 = 0
	local distance_to_target: f32 = 0
	local height_above_ground: f32 = 0
	local frame: s32 = 0
	local collision_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	ground_height = sense.get_ground_height(ground_height)
	target_y = vm.f32(ground_height + hover_height)
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
		local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, scale)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	monster.copy_vector(target_x, target_y, target_z)
	heading = monster.get_angle_to_position(position_x + direction_x, position_y + direction_y, position_z + direction_z) or heading
	frame = 0
	while frame < max_frames do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, direction_x, direction_y, direction_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		height_above_ground = monster.get_height_above_ground_at(position_x, position_y, position_z) or height_above_ground
		if height_above_ground >= 40.0 or height_above_ground <= 0.0 then
			position_y = vm.f32(position_y - direction_y)
			direction_y = 0.0
		end
		distance_to_target = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance_to_target
		if distance_to_target < vm.f32(scale + stop_margin) then
			return 1
		end
		collision_result = sense.check_flight_destination(position_x, position_y, position_z, scale, heading)
		if collision_result ~= 0 then
			return collision_result
		end
		monster.set_position(position_x, position_y, position_z)
		monster.copy_vector(position_x, position_y, position_z)
		timer.wait_one_frame()
		frame = vm.i32(frame + 1)
	end
	return 0
end

--- Hovers and faces the target for as long as the player stays transformed.
local function hover_while_player_transformed(monster_kind: any)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	fly_toward_point(pos_x, 25.0, pos_z, 0.875, 10.0, 5.0, 150)
	while true do
		timer.wait_one_frame()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
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

--- Hovers in place when the player is currently transformed.
local function wait_out_player_transformation()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		hover_while_player_transformed(monster_id)
	end
end

--- Turns toward a point at an angle and distance from the target and flies to it.
local function fly_to_approach_point(speed: f32, turn_speed: f32, approach_angle: f32, approach_distance: f32, stop_margin: f32, hover_height: f32, max_frames: s32)
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local arrival_result: s32 = 0
	target, target_2, target_3 = movement.get_approach_point(approach_angle, approach_distance, target, target_2, target_3)
	approach_angle = monster.get_angle_to_position(target, target_2, target_3) or approach_angle
	if approach_angle > vm.f32(3.1415927) then
		approach_angle = vm.f32(approach_angle - vm.f32(6.2831855))
	end
	if approach_angle <= vm.f32(-3.1415927) then
		approach_angle = vm.f32(approach_angle + vm.f32(6.2831855))
	end
	movement.turn_to_angle(calc.radians_to_degrees(approach_angle), turn_speed)
	movement.stop_turning()
	arrival_result = fly_toward_point(target, target_2, target_3, speed, stop_margin, hover_height, max_frames)
	return arrival_result
end

--- Strafes to a spot beside the target or waits for the target to line up.
local function reposition_near_target()
	local roll: s32 = 0
	local side_angle: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_angle = monster.get_random_whole_number(30.0) or side_angle
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 140.0)
		if roll < 50 then
			side_angle = vm.f32(-side_angle - 30.0)
		else
			side_angle = vm.f32(side_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		fly_to_approach_point(1.75, 10.0, side_angle, distance, 42.0, 40.0, 60)
		movement.turn_toward_target_and_wait(10.0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(42.0, 45.0, 30)
	end
end

--- Flies straight at the target for a number of frames, stopping when close or blocked.
local function chase_target(scale: f32, turn_speed: any, stop_margin: f32, hover_height: f32, tilt_enabled: s32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local distance_to_target: f32 = 0
	local ground_height: f32 = 0
	local height_above_ground: f32 = 0
	local collision_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	for frame = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		ground_height = sense.get_ground_height(ground_height)
		target_y = vm.f32(ground_height + hover_height)
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
			local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, scale)
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
			local out1, out2, out3 = monster.get_rotation_toward_6(position_x, position_y, position_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		height_above_ground = monster.get_height_above_ground_at(position_x, position_y, position_z) or height_above_ground
		if height_above_ground >= 40.0 or height_above_ground <= 0.0 then
			position_y = vm.f32(position_y - direction_y)
			direction_y = 0.0
		end
		distance_to_target = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance_to_target
		if distance_to_target < vm.f32(scale + stop_margin) then
			return 1
		end
		collision_result = sense.check_flight_destination(position_x, position_y, position_z, scale, rotation_y)
		if collision_result ~= 0 then
			print("hit------------------\n")
			return collision_result
		end
		monster.set_position(position_x, position_y, position_z)
		if tilt_enabled ~= 0 then
			monster.set_rotation(rotation_x, rotation_y, rotation_z)
		else
			monster.set_rotation(0.0, rotation_y, 0.0)
		end
		timer.wait_one_frame()
	end
	return 0
end

--- Optionally backs off, then fires a fireball at the target with the swing attack.
local function shoot_fireball(range: any)
	local roll: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local chara_type: s32 = 0
	local id: s32 = 0
	local value_5: s32 = 0
	local attack: s32 = 0
	local value_6: s32 = 0
	local value_7: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("立ち", -1, 0)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		fly_toward_point(pos_x, pos_y, pos_z, 1.5, 0.0, 40.0, 30)
	end
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_progress_facing_target(10.0, vm.f32(0.688), vm.f32(0.02))
	chara_type = monster.get_character_number() or chara_type
	id = 0
	do
		local out1, out2, out3 = monster.get_frame_position("dcol_00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.get_rotation()
	attack = monster.get_attack_power_1() or attack
	value_3 = 12.0
	value_2 = vm.f32(0.28)
	value = 0.0
	value_5 = 0
	value_4 = 0.0
	value_6 = 90
	value_7 = 15
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.create_effect_1("火弾Ｌ２")
	monster.set_effect_owner(-1, chara_type)
	monster.set_effect_target(-1, id)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, target_x, target_y, target_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value_3)
	monster.set_effect_value_float(-1, 2, value_2)
	monster.set_effect_value_float(-1, 3, value)
	monster.set_effect_value(-1, 4, value_5)
	monster.set_effect_value_float(-1, 5, value_4)
	monster.set_effect_value(-1, 6, value_6)
	monster.set_effect_value(-1, 7, value_7)
	motion.wait_until_finished()
end

--- Turns to a random angle and flies a random distance in that direction.
local function fly_random_distance(speed: f32, turn_speed: f32, base_distance: f32, range: f32, range_2: f32, stop_margin: f32, hover_height: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local distance: f32 = 0
	local angle_degrees: f32 = 0
	distance = monster.get_random_whole_number(range_2) or distance
	angle_degrees = monster.get_random_whole_number(range) or angle_degrees
	distance = vm.f32(distance + base_distance)
	movement.turn_to_angle(angle_degrees, turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(heading) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(heading) * distance))
	local _ = fly_toward_point(pos_x, pos_y, pos_z, speed, stop_margin, hover_height, max_frames)
end

--- Picks an attack or repositioning move for when the target is far away.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 5 then
		monster.set_motion("歩き", -1, 0)
		chase_target(1.5, 10.0, 14.0, 20.0, 0, 60)
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 75 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			shoot_fireball(33.0)
		else
			target_distance = sense.get_horizontal_target_distance(target_distance)
			roll = monster.get_random(100) or roll
			if roll < 70 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					side_angle = -30.0
				else
					side_angle = 30.0
				end
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(10.0)
				monster.set_motion("歩き", -1, 0)
				fly_to_approach_point(1.75, 10.0, side_angle, target_distance, 140.0, 40.0, 45)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(10.0)
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(42.0, 45.0, 30)
			else
				monster.set_motion("歩き", -1, 0)
				fly_random_distance(1.75, 10.0, 60.0, 180.0, 30.0, 42.0, 40.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Spins forward at the target with the sword swing, then may follow with a fireball.
local function spin_attack(duration_scale: s32)
	local charge_result: s32 = 0
	local roll: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.set_motion("攻撃２in", -1, 2)
	motion.wait_until_finished()
	monster.set_motion("攻撃２loop", -1, 4)
	charge_result = chase_target(4.0, 10.0, 1.5, 5.0, 0, vm.i32(20 * duration_scale))
	monster.set_motion("攻撃２out", -1, 6)
	motion.wait_until_finished()
	if charge_result == -1 or charge_result == 1 then
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		fly_toward_point(pos_x, pos_y, pos_z, 1.5, 0.0, 40.0, 30)
		roll = monster.get_random(100) or roll
		if roll < 50 then
			shoot_fireball(5.0)
		end
	end
	monster.set_motion("立ち", -1, 0)
end

--- Picks an attack or repositioning move for when the target is at medium distance.
local function act_at_medium_range()
	local target_distance: f32 = 0
	local roll: s32 = 0
	local side_angle: f32 = 0
	local wait_result: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 90 then
		roll = monster.get_random(100) or roll
		if roll < 70 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			shoot_fireball(17.0)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				side_angle = -45.0
			else
				side_angle = 45.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			monster.set_motion("走り", -1, 0)
			fly_to_approach_point(1.75, 10.0, side_angle, target_distance, 42.0, 40.0, 60)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			monster.set_motion("立ち", -1, 0)
			wait_result = sense.wait_until_target_in_arc(42.0, 45.0, 30)
			if wait_result == 1 then
				spin_attack(3)
			end
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(10.0)
		monster.set_motion("走り", -1, 0)
		chase_target(2.0, 10.0, 14.0, 15.0, 0, 90)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Steps backward away from the target.
local function step_backward(speed: f32, stop_margin: f32, hover_height: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local backward_heading: f32 = 0
	local distance: f32 = 0
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	backward_heading = vm.f32(heading + vm.f32(3.1415927))
	if backward_heading > vm.f32(3.1415927) then
		backward_heading = vm.f32(backward_heading - vm.f32(6.2831855))
	end
	if backward_heading <= vm.f32(-3.1415927) then
		backward_heading = vm.f32(backward_heading + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(backward_heading) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(backward_heading) * distance))
	fly_toward_point(pos_x, pos_y, pos_z, speed, stop_margin, hover_height, max_frames)
end

--- Turns to an angle and flies a distance in that direction.
local function fly_at_angle(turn_speed: f32, speed: f32, angle_degrees: f32, distance: f32, stop_margin: f32, hover_height: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	movement.turn_to_angle(angle_degrees, turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(vm.f32(angle_degrees * vm.f32(0.017453292))) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(vm.f32(angle_degrees * vm.f32(0.017453292))) * distance))
	local _ = fly_toward_point(pos_x, pos_y, pos_z, speed, stop_margin, hover_height, max_frames)
end

--- Picks an attack or retreat for when the target is close.
local function act_at_short_range()
	local roll: s32 = 0
	local retreat_angle: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(10.0)
		roll = monster.get_random(2) or roll
		spin_attack(vm.i32(1 + roll))
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames(3)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			monster.set_motion("ステップ後", -1, 0)
			step_backward(2.25, 10.0, 40.0, 60)
			monster.set_motion("立ち", -1)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			shoot_fireball(5.0)
		else
			retreat_angle = monster.get_target_angle() or retreat_angle
			monster.set_motion("歩き", -1, 0)
			fly_at_angle(10.0, 1.5, calc.radians_to_degrees(vm.f32(retreat_angle + vm.f32(3.1415927))), 100.0, 10.0, 40.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Chooses attacks by target distance for as long as the monster has rage hits left.
local function fight_with_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin <= 0 then
			return
		end
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance > 330.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			reposition_near_target()
			continue
		end
		if target_distance < 330.0 and target_distance >= 220.0 then
			act_at_long_range()
		elseif target_distance < 220.0 and target_distance >= 140.0 then
			act_at_medium_range()
		else
			act_at_short_range()
		end
	end
end

--- Flies to a spot on a ring around a point.
local function circle_point(
	target: f32,
	target_2: f32,
	target_3: f32,
	speed: f32,
	turn_speed: f32,
	radius: f32,
	angle_offset_degrees: f32,
	stop_margin: f32,
	hover_height: f32,
	max_frames: s32
)
	local target_4: f32 = 0
	local target_2_2: f32 = 0
	local target_3_2: f32 = 0
	local offset_radians: f32 = 0
	local ring_angle: f32 = 0
	offset_radians = vm.f32(angle_offset_degrees * vm.f32(0.017453292))
	ring_angle = monster.get_angle_to_position(target, target_2, target_3) or ring_angle
	ring_angle = vm.f32(ring_angle - vm.f32(3.1415927))
	ring_angle = vm.f32(ring_angle + offset_radians)
	if ring_angle > vm.f32(3.1415927) then
		ring_angle = vm.f32(ring_angle - vm.f32(6.2831855))
	end
	if ring_angle <= vm.f32(-3.1415927) then
		ring_angle = vm.f32(ring_angle + vm.f32(6.2831855))
	end
	target_4 = vm.f32(target + vm.f32(radius * vm.sin(ring_angle)))
	target_2_2 = 0.0
	target_3_2 = vm.f32(target_3 + vm.f32(radius * vm.cos(ring_angle)))
	angle_offset_degrees = monster.get_angle_to_position(target_4, target_2_2, target_3_2) or angle_offset_degrees
	movement.turn_to_angle(calc.radians_to_degrees(angle_offset_degrees), turn_speed)
	movement.stop_turning()
	local _ = fly_toward_point(target_4, target_2_2, target_3_2, speed, stop_margin, hover_height, max_frames)
end

--- Flies a distance along a heading given in degrees.
local function fly_along_heading(speed: f32, heading_degrees: f32, distance: f32, stop_margin: f32, hover_height: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
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
	local _ = fly_toward_point(pos_x, pos_y, pos_z, speed, stop_margin, hover_height, max_frames)
end

--- Wanders, waits or returns toward its home position while the target is out of range.
local function wander_near_home()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local home_distance: f32 = 0
	local random_angle: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local clear_distance: f32 = 0
	local target_height: f32 = 0
	local orbit_angle: f32 = 0
	local facing_angle: f32 = 0
	local strafe_angle: f32 = 0
	local strafe_distance: f32 = 0
	local target_distance: f32 = 0
	local final_angle: f32 = 0
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
	home_distance = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or home_distance
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 42.0 then
		print("1------------------------------------------------\n")
		random_angle = monster.get_random_whole_number(360.0) or random_angle
		monster.set_motion("歩き", -1, 0)
		movement.turn_to_angle(random_angle, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 42.0)
		if clear_distance > 0.0 then
			fly_at_angle(vm.f32(4.8), 1.75, random_angle, clear_distance, 42.0, 40.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if home_distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if home_distance > 800.0 then
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
				monster.set_place_position(pos_x, target_height + 40.0, pos_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				print("2------------------------------------------------\n")
				monster.set_secondary_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if roll < 50 then
					orbit_angle = vm.f32(-orbit_angle - 30.0)
				else
					orbit_angle = vm.f32(orbit_angle + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				circle_point(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), home_distance, orbit_angle, 42.0, 40.0, 60)
				facing_angle = monster.get_random_whole_number(180.0) or facing_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					facing_angle = vm.f32(facing_angle * -1.0)
				end
				movement.turn_to_angle(facing_angle, vm.f32(4.8))
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
	if roll < 35 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_secondary_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.set_secondary_variable(0, 16)
			random_angle = monster.get_random_whole_number(180.0) or random_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				random_angle = vm.f32(random_angle * -1.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_to_angle(random_angle, vm.f32(4.8))
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
					strafe_angle = monster.get_random_whole_number(180.0) or strafe_angle
					strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
					target_distance = monster.get_target_distance() or target_distance
					strafe_distance = vm.f32(strafe_distance + target_distance)
					if roll < 50 then
						strafe_angle = vm.f32(strafe_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_angle = vm.f32(-strafe_angle - 30.0)
					else
						strafe_angle = vm.f32(strafe_angle + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					wait_result = fly_to_approach_point(1.75, vm.f32(4.8), strafe_angle, strafe_distance, 42.0, 40.0, 60)
					final_angle = monster.get_random_whole_number(360.0) or final_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_angle = vm.f32(final_angle * -1.0)
					end
					movement.turn_to_angle(final_angle, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.set_secondary_variable(0, 32)
					monster.set_motion("歩き", -1, 0)
					do
						local _, out2, _ = monster.get_rotation()
						heading = out2 or heading
					end
					random_angle = calc.radians_to_degrees(heading)
					if random_angle > vm.f32(3.1415927) then
						random_angle = vm.f32(random_angle - vm.f32(6.2831855))
					end
					if random_angle <= vm.f32(-3.1415927) then
						random_angle = vm.f32(random_angle + vm.f32(6.2831855))
					end
					fly_along_heading(1.75, random_angle, 1000.0, 42.0, 40.0, 60)
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
			home_distance = monster.get_target_distance() or home_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1, 0)
			fly_random_distance(1.75, vm.f32(4.8), home_distance, 360.0, 40.0, 42.0, 40.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Chooses attacks by target distance once the monster has no rage hits left.
local function fight_without_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	while true do
		vm.wait()
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance > 330.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 5 then
			reposition_near_target()
			continue
		end
		if target_distance < 140.0 then
			roll = monster.get_random(100) or roll
			if roll < 85 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(10.0)
				roll = monster.get_random(2) or roll
				spin_attack(vm.i32(3 + roll))
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(10.0)
				monster.set_motion("ステップ後", -1, 0)
				step_backward(2.25, 10.0, 40.0, 60)
				monster.set_motion("立ち", -1)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(10.0)
				shoot_fireball(5.0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(10.0)
				if target_distance < 220.0 and target_distance >= 140.0 then
					shoot_fireball(17.0)
				else
					shoot_fireball(33.0)
				end
			else
				monster.set_motion("走り", -1, 0)
				chase_target(2.0, 10.0, 42.0, 15.0, 0, 90)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers hit reactions, effects and sword trails and sets up flight.
function script.init()
	local get_not_used_texb: s32 = 0
	local texture_reserve_flag_1: s32 = 0
	local texture_reserve_flag_2: s32 = 0
	local texture_reserve_flag_3: s32 = 0
	local grade: s32 = 0
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２loop", 0.0, 1.0, 1)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２loop", 0.0, 1.0, 2)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２loop", 0.0, 1.0, 3)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２loop", 0.0, 1.0, 4)
	monster.register_damage_hit("吹っ飛び攻撃", 3.0, "攻撃２out", 0.0, 0.2, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 3.0, "攻撃２out", 0.0, 0.2, 2)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２out", 0.0, 0.2, 3)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２out", 0.0, 0.2, 4)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		monster.load_effect_script("火弾Ｆ")
		monster.load_effect_script("火弾Ｌ２")
		monster.load_effect_script("火弾Ｈ")
		if (if (if texture_reserve_flag_1 ~= 0 then 1 else texture_reserve_flag_2) ~= 0 then 1 else texture_reserve_flag_3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.add_sword_trail(0, "攻撃２in", 0.7, 0.82, "kiseki0", "kiseki1", 100, 5, 50)
	monster.add_sword_trail(1, "攻撃２in", 0.7, 0.82, "kiseki2", "kiseki3", 100, 5, 50)
	monster.add_sword_trail(0, "攻撃２loop", 0.0, 0.12, "kiseki0", "kiseki1", 100, 5, 50)
	monster.add_sword_trail(1, "攻撃２loop", 0.0, 0.12, "kiseki2", "kiseki3", 100, 5, 50)
	state.set_flying_defaults()
	state.set_max_flight_height(60.0)
	set_clip_distance()
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("攻撃２loop", 0.0, 1.0, 1006)
	end
end

--- Fights the target, using the rage phase attacks while rage hits remain.
function script.loop()
	local target_distance: f32 = 0
	local gekirin: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			wait_out_player_transformation()
			target_distance = sense.get_horizontal_target_distance(target_distance)
			if target_distance < 330.0 then
				fight_with_rage_hits()
			else
				wander_near_home()
			end
		else
			fight_without_rage_hits()
		end
	end
end

--- Staggers in place while a status ailment lasts.
function script.on_status_hit()
	local ailment_flags: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailment_flags = 1
	while ailment_flags ~= 0 do
		ailment_flags = monster.get_status_ailments(40) or ailment_flags
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers back after a hit.
function script.on_damage()
	movement.stop_and_reset_motion()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Is knocked down and gets back up.
function script.on_knockdown()
	reaction.begin_knockdown()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	reaction.end_knockdown()
end

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.reset_motion()
	monster.set_motion("ガード", -1, 4)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("立ち")
	state.unlock()
end

--- Steps backward to dodge.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(10.0)
	monster.set_motion("ステップ後", -1, 2)
	step_backward(2.25, 10.0, 40.0, 60)
	monster.set_motion("立ち", -1)
	state.unlock()
end

--- Dodges by guarding.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.reset_motion()
	monster.set_motion("ガード", -1, 4)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays the death sequence.
function script.on_death()
	death.start_death_and_fall()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while caught.
function script.on_caught()
	state.stop_flying_and_reset_motion()
	monster.set_motion("じたばた", -1, 4)
	timer.wait_forever_unguarded()
	timer.wait_forever_unguarded()
end

--- Recovers after landing from a throw.
function script.on_land()
	local ground_height: f32 = 0
	reaction.end_throw_and_resume_flying()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_counted(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_complete()
	movement.raise_one_unit()
	ground_height = sense.get_ground_height(ground_height)
	monster.set_motion("歩き", -1, 0)
	timer.wait_one_frame()
end

--- Is stunned and recovers.
function script.on_stun()
	reaction.begin_stun()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_stars_fade()
	monster.set_motion("歩き", -1, 0)
end

return script
