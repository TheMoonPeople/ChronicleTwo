--!strict
--- Controls the Pixie family of flying fairy monsters that cast elemental bolts at the player.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard, clip distance and secondary variable defaults shared by this monster's behaviour.
local function initialize_behavior_defaults()
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

--- Flies toward a point at a hover height above the ground until it arrives, is blocked or runs out of frames.
local function fly_to_point(target_x: f32, target_y: f32, target_z: f32, speed: f32, arrival_distance: f32, hover_height: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_angle: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local ground_height: f32 = 0
	local distance_to_target: f32 = 0
	local height_above_ground: f32 = 0
	local obstacle_result: s32 = 0
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
		local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, speed)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	monster.copy_vector(target_x, target_y, target_z)
	target_angle = monster.get_angle_to_position(position_x + direction_x, position_y + direction_y, position_z + direction_z) or target_angle
	for frame = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, direction_x, direction_y, direction_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		height_above_ground = monster.get_height_above_ground_at(position_x, position_y, position_z) or height_above_ground
		if height_above_ground >= 45.0 or height_above_ground <= 0.0 then
			position_y = vm.f32(position_y - direction_y)
			direction_y = 0.0
		end
		distance_to_target = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance_to_target
		if distance_to_target < vm.f32(speed + arrival_distance) then
			return 1
		end
		obstacle_result = sense.check_flight_destination(position_x, position_y, position_z, speed, target_angle)
		if obstacle_result ~= 0 then
			return obstacle_result
		end
		monster.set_position(position_x, position_y, position_z)
		monster.copy_vector(position_x, position_y, position_z)
		reaction.update_and_wait_frame()
	end
	return 0
end

--- Descends to the ground and keeps facing the player until the player is no longer transformed.
local function wait_while_player_transformed(monster_kind: any)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local chara_id: s32 = 0
	monster.set_motion("前立ち", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	fly_to_point(pos_x, 25.0, pos_z, 0.875, 10.0, 5.0, 150)
	while true do
		reaction.update_and_wait_frame()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(90.0) == 0 then
				monster.set_motion("前歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			end
			monster.set_motion("前立ち", -1, 0)
		end
	end
end

--- Waits on the ground for the player to change back when the player is currently transformed.
local function wait_if_player_transformed()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		wait_while_player_transformed(monster_id)
	end
end

--- Flies toward the target's position at a hover height, optionally tilting to face it.
local function chase_target(speed: f32, turn_speed: any, arrival_distance: f32, hover_height: f32, tilt_toward_target: s32, max_frames: s32)
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
	local obstacle_result: s32 = 0
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
			local out1, out2, out3 = monster.get_rotation_toward_6(position_x, position_y, position_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		height_above_ground = monster.get_height_above_ground_at(position_x, position_y, position_z) or height_above_ground
		if height_above_ground >= 45.0 or height_above_ground <= 0.0 then
			position_y = vm.f32(position_y - direction_y)
			direction_y = 0.0
		end
		distance_to_target = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance_to_target
		if distance_to_target < vm.f32(speed + arrival_distance) then
			return
		end
		obstacle_result = sense.check_flight_destination(position_x, position_y, position_z, speed, rotation_y)
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
		reaction.update_and_wait_frame()
	end
end

--- Turns toward a point at an angle and distance from the target and flies to it.
local function fly_near_target(speed: f32, turn_speed: f32, angle_degrees: f32, distance: f32, arrival_distance: f32, hover_height: f32, max_frames: s32)
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local obstacle_result: s32 = 0
	target, target_2, target_3 = movement.get_approach_point(angle_degrees, distance, target, target_2, target_3)
	angle_degrees = monster.get_angle_to_position(target, target_2, target_3) or angle_degrees
	if angle_degrees > vm.f32(3.1415927) then
		angle_degrees = vm.f32(angle_degrees - vm.f32(6.2831855))
	end
	if angle_degrees <= vm.f32(-3.1415927) then
		angle_degrees = vm.f32(angle_degrees + vm.f32(6.2831855))
	end
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(angle_degrees), turn_speed)
	movement.stop_turning()
	obstacle_result = fly_to_point(target, target_2, target_3, speed, arrival_distance, hover_height, max_frames)
	return obstacle_result
end

--- Either strafes around the target or waits for it to come in front, chosen at random.
local function strafe_or_wait()
	local random_roll: s32 = 0
	local angle_degrees: f32 = 0
	local distance: f32 = 0
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 50 then
		random_roll = monster.get_random(100) or random_roll
		angle_degrees = monster.get_random_whole_number(30.0) or angle_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 100.0)
		if random_roll < 50 then
			angle_degrees = vm.f32(-angle_degrees - 30.0)
		else
			angle_degrees = vm.f32(angle_degrees + 30.0)
		end
		monster.set_motion("前歩き", -1, 0)
		fly_near_target(2.0, 3.0, angle_degrees, distance, 30.0, 45.0, 50)
		movement.turn_toward_target_and_wait_guarded(3.0)
		monster.set_motion("前立ち", -1, 0)
	else
		monster.set_motion("前立ち", -1, 0)
		sense.wait_until_target_in_front(30.0, 45.0, 30)
	end
end

--- Runs at the target, strikes, then backs away.
local function charge_attack_and_retreat()
	local retreat_x: f32 = 0
	local retreat_y: f32 = 0
	local retreat_z: f32 = 0
	local retreat_angle: f32 = 0
	local target_distance: f32 = 0
	local height: f32 = 0
	monster.set_motion("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.get_target_position()
		retreat_x = out1 or retreat_x
		retreat_y = out2 or retreat_y
		retreat_z = out3 or retreat_z
	end
	movement.turn_toward_target_and_wait_guarded(6.0)
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 45.0 then
	else
	end
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("走り", -1, 0)
	chase_target(vm.f32(7.4), 6.0, 25.0, 5.0, 0, 75)
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_finished_guarded()
	retreat_angle = monster.get_target_angle() or retreat_angle
	monster.get_target_position()
	monster.set_rotation(0.0, retreat_angle, 0.0)
	reaction.update_and_wait_frame()
	retreat_angle = vm.f32(retreat_angle + vm.f32(3.1415927))
	if retreat_angle > vm.f32(3.1415927) then
		retreat_angle = vm.f32(retreat_angle - vm.f32(6.2831855))
	end
	if retreat_angle <= vm.f32(-3.1415927) then
		retreat_angle = vm.f32(retreat_angle + vm.f32(6.2831855))
	end
	height = monster.get_height_above_ground() or height
	retreat_x = vm.f32(retreat_x + vm.f32(vm.sin(retreat_angle) * 150.0))
	retreat_y = vm.f32(height + 45.0)
	retreat_z = vm.f32(retreat_z + vm.f32(vm.cos(retreat_angle) * 150.0))
	monster.set_motion("歩き", -1, 0)
	fly_to_point(retreat_x, retreat_y, retreat_z, 4.0, 6.0, 45.0, 30)
	monster.set_motion("立ち", -1, 0)
end

--- Fires an elemental bolt at the target, with the element depending on the monster's grade.
local function cast_elemental_bolt()
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value: f32 = 0
	local attack: s32 = 0
	local grade: s32 = 0
	monster.set_variable(0, 2)
	value = 10.0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(6.0)
	monster.set_motion("攻撃２", -1, 6)
	movement.turn_until_motion_progress(3.0, vm.f32(0.428), vm.f32(0.02))
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_frame_position("col_magic")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	direction_y = vm.f32(direction_y + 20.0)
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, pos_x, pos_y, pos_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.create_effect_1("火弾Ｌ３")
	end
	if grade == 1 then
		monster.create_effect_1("風弾Ｌ２")
	end
	if grade == 2 then
		monster.create_effect_1("氷弾Ｌ２")
	end
	if grade == 3 then
		monster.create_effect_1("雷弾Ｌ２")
	end
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, value)
	reaction.update_and_wait_frame()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Closes in or repositions when the target is far away, then may attack.
local function act_at_far_range()
	local angle_degrees: f32 = 0
	local target_distance: f32 = 0
	local random_roll: s32 = 0
	local final_distance: f32 = 0
	print("far----------------\n")
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 90 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		monster.set_motion("走り", -1, 0)
		chase_target(vm.f32(7.4), 6.0, 30.0, 5.0, 0, 120)
		monster.set_motion("立ち", -1, 0)
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			monster.set_motion("歩き", -1, 0)
			target_distance = monster.get_target_distance() or target_distance
			monster.get_random_whole_number(360.0, angle_degrees)
			fly_near_target(2.0, 3.0, angle_degrees, target_distance, 30.0, 45.0, 50)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			chase_target(2.0, 3.0, 30.0, 45.0, 0, 30)
			monster.set_motion("立ち", -1, 0)
		end
	end
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 50 then
		final_distance = monster.get_target_distance() or final_distance
		if final_distance < 50.0 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				charge_attack_and_retreat()
			else
				cast_elemental_bolt()
			end
		else
			cast_elemental_bolt()
		end
	end
end

--- Casts a bolt, then repositions or advances on the target.
local function act_at_mid_range()
	local angle_degrees: f32 = 0
	local target_distance: f32 = 0
	local random_roll: s32 = 0
	print("mid----------------\n")
	cast_elemental_bolt()
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 90 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			monster.set_motion("歩き", -1, 0)
			chase_target(2.0, 3.0, 30.0, 45.0, 0, 30)
			cast_elemental_bolt()
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("走り", -1, 0)
			chase_target(vm.f32(7.4), 6.0, 30.0, 5.0, 0, 90)
		end
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(30.0, 45.0, 45)
		else
			monster.set_motion("歩き", -1, 0)
			target_distance = monster.get_target_distance() or target_distance
			angle_degrees = monster.get_random_whole_number(360.0) or angle_degrees
			fly_near_target(2.0, 3.0, angle_degrees, target_distance, 30.0, 45.0, 50)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Flies to a point 300 units to one side of its facing, the side chosen by a flag.
local function fly_sideways(speed: f32, arrival_distance: f32, hover_height: f32, side_flag: s32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local side_angle: f32 = 0
	local distance: f32 = 0
	distance = 300.0
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
	if side_flag ~= 0 then
		side_angle = vm.f32(facing_angle - vm.f32(1.5707964))
	else
		side_angle = vm.f32(facing_angle + vm.f32(1.5707964))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(side_angle) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(side_angle) * distance))
	fly_to_point(pos_x, pos_y, pos_z, speed, arrival_distance, hover_height, max_frames)
end

--- Flies to a point behind it along its facing.
local function fly_backward(speed: f32, arrival_distance: f32, hover_height: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local back_angle: f32 = 0
	local backward_distance: f32 = 0
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(back_angle) * backward_distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(back_angle) * backward_distance))
	fly_to_point(pos_x, pos_y, pos_z, speed, arrival_distance, hover_height, max_frames)
end

--- Casts a bolt and then attacks, backs off or circles when the target is close.
local function act_at_near_range()
	local horizontal_distance: f32 = 0
	local random_roll: s32 = 0
	local side_flag: s32 = 0
	print("near----------------\n")
	cast_elemental_bolt()
	horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
	if horizontal_distance < 70.0 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 90 then
			charge_attack_and_retreat()
			monster.set_motion("立ち", -1, 0)
		end
	end
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 80 then
		charge_attack_and_retreat()
		monster.set_motion("立ち", -1, 0)
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				side_flag = 1
			else
				side_flag = 0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			fly_sideways(1.0, 30.0, 45.0, side_flag, 45)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			fly_backward(1.0, 30.0, 45.0, 45)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Picks the behaviour for the target's current distance.
local function choose_combat_action()
	local horizontal_distance: f32 = 0
	local priority: s32 = 0
	wait_if_player_transformed()
	priority = monster.get_priority() or priority
	if priority > 5 then
		strafe_or_wait()
		return
	end
	horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
	if horizontal_distance < 290.0 and horizontal_distance >= 160.0 then
		act_at_far_range()
	elseif horizontal_distance < 160.0 and horizontal_distance >= 100.0 then
		act_at_mid_range()
	else
		act_at_near_range()
	end
end

--- Turns to an angle and flies a set distance along it.
local function fly_in_direction(turn_speed: f32, speed: f32, angle_degrees: f32, distance: f32, arrival_distance: f32, hover_height: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	movement.turn_to_angle_and_wait(angle_degrees, turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(vm.f32(angle_degrees * vm.f32(0.017453292))) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(vm.f32(angle_degrees * vm.f32(0.017453292))) * distance))
	local _ = fly_to_point(pos_x, pos_y, pos_z, speed, arrival_distance, hover_height, max_frames)
end

--- Flies to a point on a circle around the given point.
local function fly_around_point(
	target: f32,
	target_2: f32,
	target_3: f32,
	speed: f32,
	turn_speed: f32,
	radius: f32,
	angle_offset_degrees: f32,
	arrival_distance: f32,
	hover_height: f32,
	max_frames: s32
)
	local target_4: f32 = 0
	local target_2_2: f32 = 0
	local target_3_2: f32 = 0
	local offset_radians: f32 = 0
	local orbit_angle: f32 = 0
	offset_radians = vm.f32(angle_offset_degrees * vm.f32(0.017453292))
	orbit_angle = monster.get_angle_to_position(target, target_2, target_3) or orbit_angle
	orbit_angle = vm.f32(orbit_angle - vm.f32(3.1415927))
	orbit_angle = vm.f32(orbit_angle + offset_radians)
	if orbit_angle > vm.f32(3.1415927) then
		orbit_angle = vm.f32(orbit_angle - vm.f32(6.2831855))
	end
	if orbit_angle <= vm.f32(-3.1415927) then
		orbit_angle = vm.f32(orbit_angle + vm.f32(6.2831855))
	end
	target_4 = vm.f32(target + vm.f32(radius * vm.sin(orbit_angle)))
	target_2_2 = 0.0
	target_3_2 = vm.f32(target_3 + vm.f32(radius * vm.cos(orbit_angle)))
	angle_offset_degrees = monster.get_angle_to_position(target_4, target_2_2, target_3_2) or angle_offset_degrees
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(angle_offset_degrees), turn_speed)
	movement.stop_turning()
	local _ = fly_to_point(target_4, target_2_2, target_3_2, speed, arrival_distance, hover_height, max_frames)
end

--- Flies a set distance along a heading.
local function fly_along_heading(speed: f32, angle_degrees: f32, distance: f32, arrival_distance: f32, hover_height: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	angle_degrees = calc.degrees_to_radians(angle_degrees)
	if angle_degrees > vm.f32(3.1415927) then
		angle_degrees = vm.f32(angle_degrees - vm.f32(6.2831855))
	end
	if angle_degrees <= vm.f32(-3.1415927) then
		angle_degrees = vm.f32(angle_degrees + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(angle_degrees) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(angle_degrees) * distance))
	local _ = fly_to_point(pos_x, pos_y, pos_z, speed, arrival_distance, hover_height, max_frames)
end

--- Turns a random amount and flies a random distance ahead.
local function fly_random_direction(speed: f32, turn_speed: f32, min_distance: f32, angle_range: f32, distance_range: f32, arrival_distance: f32, hover_height: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local distance: f32 = 0
	local turn_angle_degrees: f32 = 0
	distance = monster.get_random_whole_number(distance_range) or distance
	turn_angle_degrees = monster.get_random_whole_number(angle_range) or turn_angle_degrees
	distance = vm.f32(distance + min_distance)
	movement.turn_to_angle_and_wait(turn_angle_degrees, turn_speed)
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
	local _ = fly_to_point(pos_x, pos_y, pos_z, speed, arrival_distance, hover_height, max_frames)
end

--- Wanders around or waits for the target while it is far away.
local function wander_when_far()
	local random_roll: s32 = 0
	local action_result: s32 = 0
	local wander_state: s32 = 0
	local distance: f32 = 0
	local turn_angle_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local clear_distance: f32 = 0
	local target_height: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local approach_angle_degrees: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local end_turn_degrees: f32 = 0
	reaction.update_and_wait_frame()
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 10 then
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
	distance = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 30.0 then
		print("1------------------------------------------------\n")
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("前歩き", -1, 0)
		movement.turn_to_angle_and_wait(turn_angle_degrees, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 30.0)
		if clear_distance > 0.0 then
			fly_in_direction(vm.f32(4.8), 1.75, turn_angle_degrees, clear_distance, 30.0, 45.0, 30)
		end
		monster.set_motion("前立ち", -1, 0)
	end
	if distance > 300.0 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 90 then
			if distance > 800.0 then
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
				monster.set_place_position(pos_x, target_height + 45.0, pos_z)
			end
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 30 then
				print("2------------------------------------------------\n")
				monster.set_secondary_variable(0, 4)
				random_roll = monster.get_random(100) or random_roll
				orbit_angle_degrees = monster.get_random_whole_number(360.0) or orbit_angle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if random_roll < 50 then
					orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
				else
					orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
				end
				monster.set_motion("前歩き", -1, 0)
				fly_around_point(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), distance, orbit_angle_degrees, 30.0, 45.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, vm.f32(4.8))
				monster.set_motion("前立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.set_secondary_variable(0, 8)
				monster.set_motion("前立ち", -1, 0)
				action_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if action_result == 1 then
					return
				end
			end
			monster.get_random(100, random_roll)
			return
		end
	end
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 40 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 80 then
			monster.set_secondary_variable(0, 8)
			monster.set_motion("前立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.set_secondary_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("前歩き", -1, 0)
			movement.turn_to_angle_and_wait(turn_angle_degrees, vm.f32(4.8))
			monster.set_motion("前立ち", -1, 0)
		end
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 50 then
					print("5------------------------------------------------\n")
					monster.set_secondary_variable(0, 4)
					random_roll = monster.get_random(100) or random_roll
					approach_angle_degrees = monster.get_random_whole_number(180.0) or approach_angle_degrees
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if random_roll < 50 then
						approach_angle_degrees = vm.f32(approach_angle_degrees * -1.0)
					end
					random_roll = monster.get_random(100) or random_roll
					if random_roll < 50 then
						approach_angle_degrees = vm.f32(-approach_angle_degrees - 30.0)
					else
						approach_angle_degrees = vm.f32(approach_angle_degrees + 30.0)
					end
					monster.set_motion("前歩き", -1, 0)
					action_result = fly_near_target(1.75, vm.f32(4.8), approach_angle_degrees, approach_distance, 30.0, 45.0, 60)
					end_turn_degrees = monster.get_random_whole_number(360.0) or end_turn_degrees
					random_roll = monster.get_random(100) or random_roll
					if random_roll < 50 then
						end_turn_degrees = vm.f32(end_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(end_turn_degrees, vm.f32(4.8))
					monster.set_motion("前立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.set_secondary_variable(0, 32)
					monster.set_motion("前歩き", -1, 0)
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
					fly_along_heading(1.75, turn_angle_degrees, 1000.0, 30.0, 45.0, 60)
					monster.set_motion("前立ち", -1, 0)
				end
			else
				monster.set_secondary_variable(0, 8)
				monster.set_motion("前立ち", -1, 0)
				action_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if action_result == 1 then
					return
				end
			end
		elseif wander_state == 8 then
			print("7------------------------------------------------\n")
			monster.set_variable(0, 1)
			random_roll = monster.get_random(120) or random_roll
			distance = monster.get_target_distance() or distance
			random_roll = vm.i32(random_roll + 15)
			monster.set_motion("前歩き", -1, 0)
			fly_random_direction(1.75, vm.f32(4.8), distance, 360.0, 40.0, 30.0, 45.0, random_roll)
			monster.set_motion("前立ち", -1, 0)
		end
	end
end

--- Turns to the target and rushes at it.
local function charge_at_target()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("走り", -1, 0)
	chase_target(vm.f32(7.4), 6.0, 50.0, 5.0, 0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Attacks or closes in on the target once the rage hits are used up.
local function act_when_no_rage_hits_left()
	local gekirin: s32 = 0
	local random_roll: s32 = 0
	local horizontal_distance: f32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		return
	end
	horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
	if horizontal_distance < 100.0 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			charge_attack_and_retreat()
		else
			cast_elemental_bolt()
		end
	else
		horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
		if horizontal_distance < 160.0 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 40 then
				cast_elemental_bolt()
			else
				monster.set_motion("走り", -1, 0)
				chase_target(vm.f32(7.4), 3.0, 30.0, 10.0, 0, 90)
				monster.set_motion("立ち", -1, 0)
			end
		else
			monster.set_motion("走り", -1, 0)
			chase_target(vm.f32(7.4), 3.0, 30.0, 10.0, 0, 90)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Stops the monster, ends the throw and restores flight after it lands.
local function reset_after_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_guard_update(10)
	state.set_flying_attributes(1)
	monster.reset_motion()
end

local script = {}

--- Runs once when the script is loaded, before any program.
function script.setup() end

--- Registers the damage hit, loads the elemental bolt effects for the monster's grade and lifts it to flight height.
function script.init()
	local get_not_used_texb: s32 = 0
	local bolt_effect_loaded: s32 = 0
	local hit_effect_loaded: s32 = 0
	local grade: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃１", 0.28, 0.4, 0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		grade = monster.get_monster_grade_2(-1) or grade
		if grade == 0 then
			bolt_effect_loaded = monster.load_effect_script("火弾Ｌ３", get_not_used_texb) or bolt_effect_loaded
			hit_effect_loaded = monster.load_effect_script("火弾Ｈ", get_not_used_texb) or hit_effect_loaded
		end
		if grade == 1 then
			bolt_effect_loaded = monster.load_effect_script("風弾Ｌ２", get_not_used_texb) or bolt_effect_loaded
			hit_effect_loaded = monster.load_effect_script("風弾Ｈ", get_not_used_texb) or hit_effect_loaded
		end
		if grade == 2 then
			bolt_effect_loaded = monster.load_effect_script("氷弾Ｌ２", get_not_used_texb) or bolt_effect_loaded
			hit_effect_loaded = monster.load_effect_script("氷弾Ｈ", get_not_used_texb) or hit_effect_loaded
		end
		if grade == 3 then
			bolt_effect_loaded = monster.load_effect_script("雷弾Ｌ２", get_not_used_texb) or bolt_effect_loaded
			hit_effect_loaded = monster.load_effect_script("雷弾Ｈ", get_not_used_texb) or hit_effect_loaded
		end
		if (if bolt_effect_loaded ~= 0 then 1 else hit_effect_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(0, 0)
	monster.set_variable(7, 2)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	monster.set_position(pos_x, pos_y + 45.0, pos_z)
	monster.set_place_position(place_pos_x, place_pos_y + 45.0, place_pos_z)
	movement.stop_at_current_position()
	state.initialize_flying_defaults()
	state.set_max_flight_height(55.0)
	initialize_behavior_defaults()
end

--- Each frame chooses between combat, transforming, wandering and the simple attack mode, depending on rage hits left, guard state and target distance.
function script.loop()
	local gekirin: s32 = 0
	local value: s32 = 0
	local horizontal_distance: f32 = 0
	local secondary_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			if reaction.is_guard_active() == 0 then
				wait_if_player_transformed()
				horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
				if horizontal_distance < 290.0 then
					value = monster.get_variable(7) or value
					if value == 2 then
						monster.set_variable(7, 1)
						monster.set_motion("前歩き", -1, 0)
						movement.turn_toward_target_and_wait_guarded(3.0)
						chase_target(2.0, 3.0, 30.0, 45.0, 0, 75)
						monster.set_motion("変身", -1, 2)
						motion.wait_until_finished_guarded()
					end
					choose_combat_action()
				else
					if value ~= 2 then
						value = monster.get_variable(7) or value
						monster.set_variable(7, 2)
						monster.set_motion("前立ち", -1, 6)
						motion.wait_until_finished_guarded()
					end
					wander_when_far()
					monster.set_variable(7, 1)
				end
			else
				secondary_distance = state.get_secondary_float(secondary_distance)
				if horizontal_distance < secondary_distance then
					if horizontal_distance < 160.0 then
						reaction.set_guard_active(0)
						choose_combat_action()
					else
						charge_at_target()
					end
				else
					reaction.set_guard_active(0)
				end
			end
		else
			act_when_no_rage_hits_left()
		end
	end
end

--- Stops the monster in a hurt pose until its status ailments clear.
function script.on_status_hit()
	local ailment_flags: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailment_flags = 1
	while ailment_flags ~= 0 do
		ailment_flags = monster.get_status_ailments(40) or ailment_flags
		reaction.update_and_wait_frame()
	end
	monster.set_motion("前立ち")
	state.do_nothing()
end

--- Plays the flinch reaction when the monster is hit.
function script.on_damage()
	movement.stop_and_reset_motion()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち", -1, 0)
	state.do_nothing()
end

--- Plays the knockdown reaction when the monster is knocked over.
function script.on_knockdown()
	reaction.begin_knockdown_with_reaction()
	movement.stop_at_current_position()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち", -1, 0)
	reaction.end_knockdown()
end

--- Plays the guard reaction when the monster blocks a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	movement.stop_at_current_position()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(15.0)
	movement.stop_turning()
	monster.set_motion("ガード", -1, 0)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays the first dodge reaction.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	movement.stop_at_current_position()
	state.unlock()
end

--- Plays the second dodge reaction.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	movement.stop_at_current_position()
	state.unlock()
end

--- Plays the monster's death sequence.
function script.on_death()
	death.start_death_and_fall()
	movement.stop_at_current_position()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Plays the struggling pose while the monster is held.
function script.on_caught()
	state.stop_flying_and_reset_motion()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
	timer.wait_forever_guarded()
end

--- Recovers the monster after a throw lands and returns it to the ground.
function script.on_land()
	reset_after_throw()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	movement.raise_one_unit()
	monster.set_motion("歩き", -1, 0)
	reaction.update_and_wait_frame()
	return 1
end

--- Plays the stun reaction until the monster recovers.
function script.on_stun()
	reaction.begin_stun()
	movement.stop_at_current_position()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_stars_fade()
	monster.set_motion("歩き", -1, 0)
end

return script
