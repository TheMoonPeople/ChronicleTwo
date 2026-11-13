--!strict
--- Controls the flying elemental monsters (fire, ice, thunder, water and wind elements, spirits, ghosts and servants), which hover, dash at the player and fire elemental orbs.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Returns 1 when the monster is one of the fire-element kinds.
local function is_fire_element()
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	if monster_id >= 76 and monster_id <= 79 then
		return 1
	end
	return 0
end

--- Returns 1 when the monster is one of the ice-element kinds.
local function is_ice_element()
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	if monster_id >= 80 and monster_id <= 83 then
		return 1
	end
	return 0
end

--- Returns 1 when the monster is one of the thunder-element kinds.
local function is_thunder_element()
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	if monster_id >= 84 and monster_id <= 87 then
		return 1
	end
	return 0
end

--- Returns 1 when the monster is one of the water-element kinds.
local function is_water_element()
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	if monster_id >= 88 and monster_id <= 91 then
		return 1
	end
	return 0
end

--- Returns 1 when the monster is one of the wind-element kinds.
local function is_wind_element()
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	if monster_id >= 92 and monster_id <= 95 then
		return 1
	end
	return 0
end

--- Sets the guard thresholds, secondary parameters and clip distance used by this monster.
local function initialize_behavior_settings()
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

--- Flies step by step toward a point at a hover height above the ground and returns 1 on arrival or a blocked result.
local function fly_toward_position(target_x: f32, target_y: f32, target_z: f32, step_length: f32, arrival_tolerance: f32, hover_height: f32, max_steps: s32)
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local heading_radians: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_height: f32 = 0
	local remaining_distance: f32 = 0
	local height_above_ground: f32 = 0
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
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_length)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	monster.copy_vector(target_x, target_y, target_z)
	heading_radians = monster.get_angle_to_position(current_x + step_x, current_y + step_y, current_z + step_z) or heading_radians
	for step_index = 0, max_steps - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		height_above_ground = monster.get_height_above_ground_at(current_x, current_y, current_z) or height_above_ground
		if height_above_ground >= 30.0 or height_above_ground <= 0.0 then
			current_y = vm.f32(current_y - step_y)
			step_y = 0.0
		end
		remaining_distance = monster.get_distance_between(current_x, current_y, current_z, target_x, target_y, target_z) or remaining_distance
		if remaining_distance < vm.f32(step_length + arrival_tolerance) then
			return 1
		end
		blocked_result = sense.check_flight_destination(current_x, current_y, current_z, step_length, heading_radians)
		if blocked_result ~= 0 then
			return blocked_result
		end
		monster.set_position(current_x, current_y, current_z)
		monster.copy_vector(current_x, current_y, current_z)
		timer.wait_frame_with_lighting()
	end
	return 0
end

--- Hovers in place and keeps facing the player for as long as the player stays transformed.
local function hover_facing_transformed_player(monster_id: any)
	local position_x: f32 = 0
	local position_z: f32 = 0
	local transform_character_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	fly_toward_position(position_x, 25.0, position_z, 0.875, 10.0, 5.0, 150)
	while true do
		timer.wait_frame_with_lighting()
		transform_character_id = monster.get_player_transform_id() or transform_character_id
		if transform_character_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(90.0) == 0 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_with_lighting(vm.f32(4.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Hovers and faces the player when the player is currently transformed.
local function hover_if_player_transformed()
	local transform_character_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	transform_character_id = monster.get_player_transform_id() or transform_character_id
	if transform_character_id > -1 then
		hover_facing_transformed_player(monster_id)
	end
end

--- Turns toward a point at the given angle and distance from the target and flies to it.
local function fly_to_approach_point(step_length: f32, turn_speed: f32, approach_degrees: f32, approach_distance: f32, arrival_tolerance: f32, hover_height: f32, max_steps: s32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local fly_result: s32 = 0
	approach_x, approach_y, approach_z = movement.get_approach_point(approach_degrees, approach_distance, approach_x, approach_y, approach_z)
	approach_degrees = monster.get_angle_to_position(approach_x, approach_y, approach_z) or approach_degrees
	if approach_degrees > vm.f32(3.1415927) then
		approach_degrees = vm.f32(approach_degrees - vm.f32(6.2831855))
	end
	if approach_degrees <= vm.f32(-3.1415927) then
		approach_degrees = vm.f32(approach_degrees + vm.f32(6.2831855))
	end
	movement.turn_to_angle_with_lighting(calc.radians_to_degrees(approach_degrees), turn_speed)
	movement.stop_turning()
	fly_result = fly_toward_position(approach_x, approach_y, approach_z, step_length, arrival_tolerance, hover_height, max_steps)
	return fly_result
end

--- Strafes around the target at random or waits until the target is in front.
local function strafe_or_wait()
	local roll: s32 = 0
	local strafe_degrees: f32 = 0
	local unused_distance_offset: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		strafe_degrees = monster.get_random_whole_number(30.0) or strafe_degrees
		unused_distance_offset = monster.get_random_whole_number(30.0) or unused_distance_offset
		unused_distance_offset = vm.f32(unused_distance_offset + 120.0)
		if roll < 50 then
			strafe_degrees = vm.f32(-strafe_degrees - 30.0)
		else
			strafe_degrees = vm.f32(strafe_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = fly_to_approach_point(2.0, vm.f32(4.8), strafe_degrees, 60.0, 1.0, 30.0, 50)
		movement.turn_toward_target_and_wait_with_lighting(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc_with_lighting(30.0, 45.0, 30)
	end
end

--- Flies toward the target step by step, tilting to face it, and returns 1 on arrival or a blocked result.
local function chase_target_flying(step_length: f32, unused_turn_speed: any, arrival_tolerance: f32, hover_height: f32, tilt_toward_target: s32, max_steps: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local remaining_distance: f32 = 0
	local ground_height: f32 = 0
	local height_above_ground: f32 = 0
	local blocked_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	for step_index = 0, max_steps - 1 do
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
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_length)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		do
			local out1, out2, out3 = monster.get_rotation_toward_6(current_x, current_y, current_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		height_above_ground = monster.get_height_above_ground_at(current_x, current_y, current_z) or height_above_ground
		if height_above_ground >= 30.0 or height_above_ground <= 0.0 then
			current_y = vm.f32(current_y - step_y)
			step_y = 0.0
		end
		remaining_distance = monster.get_distance_between(current_x, current_y, current_z, target_x, target_y, target_z) or remaining_distance
		if remaining_distance < vm.f32(step_length + arrival_tolerance) then
			return 1
		end
		blocked_result = sense.check_flight_destination(current_x, current_y, current_z, step_length, rotation_y)
		if blocked_result ~= 0 then
			print("hit------------------\n")
			return blocked_result
		end
		monster.set_position(current_x, current_y, current_z)
		if tilt_toward_target ~= 0 then
			monster.set_rotation(rotation_x, rotation_y, rotation_z)
		else
			monster.set_rotation(0.0, rotation_y, 0.0)
		end
		timer.wait_frame_with_lighting()
	end
	return 0
end

--- Turns to a random heading, waits for the target to line up and then dashes at it.
local function turn_randomly_then_dash_at_target()
	local target_in_arc: s32 = 0
	local turn_degrees: f32 = 0
	turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
	monster.set_motion("歩き", -1, 0)
	movement.turn_to_angle_with_lighting(turn_degrees, vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_lighting(9)
	target_in_arc = sense.wait_until_target_in_arc_with_lighting(290.0, 45.0, 45)
	if target_in_arc == 1 then
		monster.set_motion("走り", -1, 0)
		chase_target_flying(vm.f32(7.4), vm.f32(4.8), 30.0, 5.0, 0, 150)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Keeps turning toward the target until the current motion reaches the given progress.
local function turn_toward_target_until_motion_progress(turn_speed_degrees: f32, progress: f32, progress_tolerance: f32)
	local target_angle: f32 = 0
	local motion_progress: f32 = 0
	local turn_speed_radians: f32 = 0
	if progress_tolerance == -1.0 then
		progress_tolerance = vm.f32(0.05)
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
		if motion_progress < vm.f32(progress + progress_tolerance) and motion_progress > vm.f32(progress - progress_tolerance) then
			break
		else
			timer.wait_frame_with_lighting()
		end
	end
	movement.stop_turning()
end

--- Waits until the current motion reaches the given progress or finishes.
local function wait_until_motion_progress(progress: f32, progress_tolerance: f32)
	local motion_progress: f32 = 0
	local frame_count: s32 = 0
	local motion_finished: s32 = 0
	if progress_tolerance == -1.0 then
		progress_tolerance = vm.f32(0.03)
	end
	frame_count = 0
	while true do
		timer.wait_frame_with_lighting()
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress < vm.f32(progress + progress_tolerance) and motion_progress > vm.f32(progress - progress_tolerance) then
			break
		else
			motion_finished = monster.is_motion_finished() or motion_finished
			if motion_finished ~= 0 then
				break
			else
				frame_count = vm.i32(frame_count + 1)
			end
		end
	end
end

--- Faces the target and fires an orb of the monster element from its face toward the target.
local function fire_elemental_orb()
	local face_x: f32 = 0
	local face_y: f32 = 0
	local face_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_with_lighting(vm.f32(7.2000003))
	monster.set_motion("攻撃２", -1, 6)
	turn_toward_target_until_motion_progress(vm.f32(4.8), vm.f32(0.592), vm.f32(0.02))
	do
		local out1, out2, out3 = monster.get_target_position()
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	direction_y = vm.f32(direction_y + 15.0)
	do
		local out1, out2, out3 = monster.get_frame_position("face")
		face_x = out1 or face_x
		face_y = out2 or face_y
		face_z = out3 or face_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, face_x, face_y, face_z)
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
	if is_fire_element() ~= 0 then
		monster.create_effect_1("火弾Ｆ")
	end
	if is_ice_element() ~= 0 then
		monster.create_effect_1("氷弾Ｆ")
	end
	if is_thunder_element() ~= 0 then
		monster.create_effect_1("雷弾Ｆ")
	end
	if is_water_element() ~= 0 then
		monster.create_effect_1("水弾Ｆ")
	end
	if is_wind_element() ~= 0 then
		monster.create_effect_1("風弾Ｆ")
	end
	monster.set_effect_first_vector(-1, face_x, face_y, face_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	wait_until_motion_progress(vm.f32(0.608), vm.f32(0.02))
	if is_fire_element() ~= 0 then
		monster.create_effect_1("火弾Ｌ３")
	end
	if is_ice_element() ~= 0 then
		monster.create_effect_1("氷弾Ｌ２")
	end
	if is_thunder_element() ~= 0 then
		monster.create_effect_1("雷弾Ｌ２")
	end
	if is_water_element() ~= 0 then
		monster.create_effect_1("水弾Ｌ２")
	end
	if is_wind_element() ~= 0 then
		monster.create_effect_1("風弾Ｌ２")
	end
	monster.set_effect_first_vector(-1, face_x, face_y, face_z)
	monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, 12.0)
	motion.wait_until_finished_with_lighting()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_lighting(9)
end

--- Flies straight up or down step by step until it reaches the requested height.
local function rise_toward_height(target_height: f32, step_length: f32, arrival_tolerance: f32, max_steps: s32)
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local facing_radians: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local remaining_distance: f32 = 0
	local height_above_ground: f32 = 0
	local blocked_result: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(0.0, target_height, 0.0)
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
	for step_index = 0, max_steps - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		height_above_ground = monster.get_height_above_ground_at(current_x, current_y, current_z) or height_above_ground
		if height_above_ground >= 30.0 or height_above_ground <= 0.0 then
			current_y = vm.f32(current_y - step_y)
			step_y = 0.0
		end
		remaining_distance = monster.get_distance_between(current_x, current_y, current_z, current_x, target_height, current_z) or remaining_distance
		if remaining_distance < vm.f32(step_length + arrival_tolerance) then
			return
		end
		do
			local _, out2, _ = monster.get_rotation()
			facing_radians = out2 or facing_radians
		end
		blocked_result = sense.check_flight_destination(current_x, current_y, current_z, step_length, facing_radians)
		if blocked_result ~= 0 then
			return
		end
		monster.set_position(current_x, current_y, current_z)
		monster.copy_vector(current_x, current_y, current_z)
		timer.wait_frame_with_lighting()
	end
end

--- Plays the walk motion and rises back to the usual hover height.
local function climb_to_hover_height()
	monster.get_position_3()
	monster.set_motion("歩き", -1, 0)
	rise_toward_height(30.0, 2.0, 30.0, 60)
end

--- Chooses a long-range action: dash, fire an orb, rush, wait or chase the target.
local function act_at_long_range()
	local roll: s32 = 0
	local chase_result: s32 = 0
	local target_distance: f32 = 0
	target_distance = sense.get_horizontal_target_distance(target_distance)
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			roll = monster.get_random(100) or roll
			if roll < 20 then
				turn_randomly_then_dash_at_target()
			else
				fire_elemental_orb()
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 25 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_with_lighting(2.0, vm.f32(4.8), 120.0, 60)
				chase_target_flying(2.0, vm.f32(4.8), 30.0, 30.0, 0, 90)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc_with_lighting(30.0, 45.0, 75)
			end
		end
	else
		monster.set_motion("走り", -1, 0)
		chase_result = chase_target_flying(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 90)
		if chase_result < 85 and chase_result ~= 1 then
			climb_to_hover_height()
		end
		monster.set_motion("立ち", -1, 0)
	end
end

--- Flies to the left or right of its current heading for a fixed distance.
local function fly_sideways(step_length: f32, arrival_tolerance: f32, hover_height: f32, step_right: s32, max_steps: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local facing_radians: f32 = 0
	local side_radians: f32 = 0
	local side_distance: f32 = 0
	side_distance = 300.0
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	if step_right ~= 0 then
		side_radians = vm.f32(facing_radians - vm.f32(1.5707964))
	else
		side_radians = vm.f32(facing_radians + vm.f32(1.5707964))
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(side_radians) * side_distance))
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(side_radians) * side_distance))
	fly_toward_position(destination_x, destination_y, destination_z, step_length, arrival_tolerance, hover_height, max_steps)
end

--- Chooses a medium-range action: fire an orb, dash, strafe, side-step or chase the target.
local function act_at_medium_range()
	local roll: s32 = 0
	local chase_result: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	local step_right: s32 = 0
	target_distance = sense.get_horizontal_target_distance(target_distance)
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 70 then
			fire_elemental_orb()
		else
			roll = monster.get_random(100) or roll
			if roll < 30 then
				turn_randomly_then_dash_at_target()
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					roll = monster.get_random(100) or roll
					strafe_degrees = monster.get_random_whole_number(60.0) or strafe_degrees
					if roll < 50 then
						strafe_degrees = vm.f32(-strafe_degrees - 30.0)
					else
						strafe_degrees = vm.f32(strafe_degrees + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					fly_to_approach_point(2.0, vm.f32(4.8), strafe_degrees, 60.0, 1.0, 30.0, 75)
					movement.turn_toward_target_and_wait_with_lighting(vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_lighting(9)
				else
					roll = monster.get_random(100) or roll
					if roll < 50 then
						step_right = 1
						monster.set_motion("ステップ右", -1, 0)
					else
						step_right = 0
						monster.set_motion("ステップ左", -1, 0)
					end
					fly_sideways(2.0, 30.0, 30.0, step_right, 60)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
	else
		monster.set_motion("走り", -1, 0)
		chase_result = chase_target_flying(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 60)
		if chase_result < 55 and chase_result ~= 1 then
			climb_to_hover_height()
		end
		monster.set_motion("立ち", -1, 0)
	end
end

--- Turns toward the target and flies at it step by step, stopping when close or blocked.
local function swoop_toward_target(step_length: f32, turn_speed: f32, arrival_tolerance: f32, hover_height: f32, max_steps: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local facing_radians: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_height: f32 = 0
	local remaining_distance: f32 = 0
	local height_above_ground: f32 = 0
	local blocked_result: s32 = 0
	remaining_distance = monster.get_target_distance() or remaining_distance
	movement.turn_toward_target_and_wait_with_lighting(turn_speed)
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
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_length)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	for step_index = 0, max_steps - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		height_above_ground = monster.get_height_above_ground_at(current_x, current_y, current_z) or height_above_ground
		if height_above_ground >= 30.0 or height_above_ground <= 0.0 then
			current_y = vm.f32(current_y - step_y)
			step_y = 0.0
		end
		remaining_distance = monster.get_distance_between(current_x, current_y, current_z, target_x, target_y, target_z) or remaining_distance
		if remaining_distance < vm.f32(step_length + arrival_tolerance) then
			return
		end
		blocked_result = sense.check_flight_destination(current_x, current_y, current_z, step_length, facing_radians)
		if blocked_result ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(current_x, current_y, current_z)
		timer.wait_frame_with_lighting()
	end
end

--- Turns toward the target and flies at it while playing the melee attack motion.
local function lunge_at_target()
	local probe_x: f32 = 0
	local probe_y: f32 = 0
	local probe_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local ground_offset: f32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_with_lighting(vm.f32(7.2000003))
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	monster.get_target_position(probe_x, probe_y, probe_z)
	ground_offset = sense.get_ground_offset_at(probe_x, probe_y, probe_z, ground_offset)
	fly_toward_position(target_x, target_y, target_z, 10.5, 10.0, 2.0, 27)
	motion.wait_until_finished_with_lighting()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_lighting(9)
end

--- Flies directly away from its current facing.
local function fly_backward(step_length: f32, arrival_tolerance: f32, hover_height: f32, max_steps: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local facing_radians: f32 = 0
	local backward_radians: f32 = 0
	local backward_distance: f32 = 0
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	backward_radians = vm.f32(facing_radians + vm.f32(3.1415927))
	if backward_radians > vm.f32(3.1415927) then
		backward_radians = vm.f32(backward_radians - vm.f32(6.2831855))
	end
	if backward_radians <= vm.f32(-3.1415927) then
		backward_radians = vm.f32(backward_radians + vm.f32(6.2831855))
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(backward_radians) * backward_distance))
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(backward_radians) * backward_distance))
	fly_toward_position(destination_x, destination_y, destination_z, step_length, arrival_tolerance, hover_height, max_steps)
end

--- Chooses a close-range action: strafe away when very close, lunge, strafe, side-step or fly backward.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	local second_strafe_degrees: f32 = 0
	local step_right: s32 = 0
	monster.get_life()
	target_distance = sense.get_horizontal_target_distance(target_distance)
	if target_distance < 30.0 then
		roll = monster.get_random(100) or roll
		strafe_degrees = monster.get_random_whole_number(60.0) or strafe_degrees
		if roll < 50 then
			strafe_degrees = vm.f32(-strafe_degrees - 30.0)
		else
			strafe_degrees = vm.f32(strafe_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		fly_to_approach_point(2.0, vm.f32(4.8), strafe_degrees, 60.0, 1.0, 30.0, 50)
		movement.turn_toward_target_and_wait_with_lighting(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_lighting(9)
	end
	roll = monster.get_random(100) or roll
	if roll < 65 then
		monster.set_motion("歩き", -1, 0)
		swoop_toward_target(2.0, vm.f32(4.8), 30.0, 30.0, 60)
		lunge_at_target()
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 15 then
			roll = monster.get_random(100) or roll
			second_strafe_degrees = monster.get_random_whole_number(60.0) or second_strafe_degrees
			if roll < 50 then
				second_strafe_degrees = vm.f32(-second_strafe_degrees - 30.0)
			else
				second_strafe_degrees = vm.f32(second_strafe_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			fly_to_approach_point(2.0, vm.f32(4.8), second_strafe_degrees, 60.0, 1.0, 30.0, 50)
			movement.turn_toward_target_and_wait_with_lighting(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_lighting(9)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_with_lighting(vm.f32(4.8))
			roll = monster.get_random(100) or roll
			if roll < 67 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					step_right = 1
					monster.set_motion("ステップ右", -1, 0)
				else
					step_right = 0
					monster.set_motion("ステップ左", -1, 0)
				end
				fly_sideways(2.0, 30.0, 30.0, step_right, 60)
				monster.set_motion("立ち", -1, 0)
			else
				fly_backward(2.0, 30.0, 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Loops choosing an attack by target distance until the target moves out of range.
local function engage_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	while true do
		timer.wait_frame_with_lighting()
		monster.get_life()
		hover_if_player_transformed()
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance > 290.0 then
			timer.wait_frame_with_lighting()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			strafe_or_wait()
			continue
		end
		if target_distance < 290.0 and target_distance >= 180.0 then
			act_at_long_range()
		elseif target_distance < 180.0 and target_distance >= 120.0 then
			act_at_medium_range()
		else
			act_at_close_range()
		end
	end
end

--- Turns to a heading and flies a fixed distance along it.
local function turn_and_fly_in_direction(turn_speed: f32, step_length: f32, heading_degrees: f32, distance: f32, arrival_tolerance: f32, hover_height: f32, max_steps: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	movement.turn_to_angle_with_lighting(heading_degrees, turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(vm.f32(heading_degrees * vm.f32(0.017453292))) * distance))
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(vm.f32(heading_degrees * vm.f32(0.017453292))) * distance))
	local _ = fly_toward_position(destination_x, destination_y, destination_z, step_length, arrival_tolerance, hover_height, max_steps)
end

--- Flies to a point on a circle around a position at the given angle and radius.
local function fly_around_position(
	center_x: f32,
	center_y: f32,
	center_z: f32,
	step_length: f32,
	turn_speed: f32,
	orbit_radius: f32,
	orbit_degrees: f32,
	arrival_tolerance: f32,
	hover_height: f32,
	max_steps: s32
)
	local orbit_x: f32 = 0
	local orbit_y: f32 = 0
	local orbit_z: f32 = 0
	local orbit_radians: f32 = 0
	local orbit_angle: f32 = 0
	orbit_radians = vm.f32(orbit_degrees * vm.f32(0.017453292))
	orbit_angle = monster.get_angle_to_position(center_x, center_y, center_z) or orbit_angle
	orbit_angle = vm.f32(orbit_angle - vm.f32(3.1415927))
	orbit_angle = vm.f32(orbit_angle + orbit_radians)
	if orbit_angle > vm.f32(3.1415927) then
		orbit_angle = vm.f32(orbit_angle - vm.f32(6.2831855))
	end
	if orbit_angle <= vm.f32(-3.1415927) then
		orbit_angle = vm.f32(orbit_angle + vm.f32(6.2831855))
	end
	orbit_x = vm.f32(center_x + vm.f32(orbit_radius * vm.sin(orbit_angle)))
	orbit_y = 0.0
	orbit_z = vm.f32(center_z + vm.f32(orbit_radius * vm.cos(orbit_angle)))
	orbit_degrees = monster.get_angle_to_position(orbit_x, orbit_y, orbit_z) or orbit_degrees
	movement.turn_to_angle_with_lighting(calc.radians_to_degrees(orbit_degrees), turn_speed)
	movement.stop_turning()
	local _ = fly_toward_position(orbit_x, orbit_y, orbit_z, step_length, arrival_tolerance, hover_height, max_steps)
end

--- Flies a fixed distance along the given heading.
local function fly_in_direction(step_length: f32, heading_degrees: f32, distance: f32, arrival_tolerance: f32, hover_height: f32, max_steps: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	heading_degrees = calc.degrees_to_radians(heading_degrees)
	if heading_degrees > vm.f32(3.1415927) then
		heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
	end
	if heading_degrees <= vm.f32(-3.1415927) then
		heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(heading_degrees) * distance))
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(heading_degrees) * distance))
	local _ = fly_toward_position(destination_x, destination_y, destination_z, step_length, arrival_tolerance, hover_height, max_steps)
end

--- Turns by a random angle and flies a random distance ahead.
local function wander_randomly(step_length: f32, turn_speed: f32, base_distance: f32, turn_range_degrees: f32, distance_range: f32, arrival_tolerance: f32, hover_height: f32, max_steps: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local facing_radians: f32 = 0
	local wander_distance: f32 = 0
	local turn_degrees: f32 = 0
	wander_distance = monster.get_random_whole_number(distance_range) or wander_distance
	turn_degrees = monster.get_random_whole_number(turn_range_degrees) or turn_degrees
	wander_distance = vm.f32(wander_distance + base_distance)
	movement.turn_to_angle_with_lighting(turn_degrees, turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(facing_radians) * wander_distance))
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(facing_radians) * wander_distance))
	local _ = fly_toward_position(destination_x, destination_y, destination_z, step_length, arrival_tolerance, hover_height, max_steps)
end

--- Wanders, turns, circles the target or waits in place when the target is far away or out of reach.
local function roam_when_idle()
	local roll: s32 = 0
	local target_threatening: s32 = 0
	local unused_mode: s32 = 0
	local distance: f32 = 0
	local turn_degrees: f32 = 0
	local home_x: f32 = 0
	local home_y: f32 = 0
	local home_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_radians: f32 = 0
	local clear_distance: f32 = 0
	local target_height: f32 = 0
	local orbit_degrees: f32 = 0
	local after_orbit_turn_degrees: f32 = 0
	local approach_degrees: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
	timer.wait_frame_with_lighting()
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
		facing_radians = out2 or facing_radians
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 30.0 then
		print("1------------------------------------------------\n")
		turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
		monster.set_motion("歩き", -1, 0)
		movement.turn_to_angle_with_lighting(turn_degrees, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 30.0)
		if clear_distance > 0.0 then
			turn_and_fly_in_direction(vm.f32(4.8), 1.75, turn_degrees, clear_distance, 30.0, 30.0, 30)
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
					target_height = out2 or target_height
				end
				monster.set_place_position(position_x, target_height + 30.0, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				print("2------------------------------------------------\n")
				monster.set_secondary_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_degrees = monster.get_random_whole_number(360.0) or orbit_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					orbit_degrees = vm.f32(-orbit_degrees - 30.0)
				else
					orbit_degrees = vm.f32(orbit_degrees + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				fly_around_position(home_x, home_y, home_z, 1.75, vm.f32(4.8), distance, orbit_degrees, 30.0, 30.0, 60)
				after_orbit_turn_degrees = monster.get_random_whole_number(180.0) or after_orbit_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					after_orbit_turn_degrees = vm.f32(after_orbit_turn_degrees * -1.0)
				end
				movement.turn_to_angle_with_lighting(after_orbit_turn_degrees, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				target_threatening = sense.wait_until_target_threatening_with_lighting(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if target_threatening == 1 then
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
			sense.wait_until_target_threatening_with_lighting(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.set_secondary_variable(0, 16)
			turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_degrees = vm.f32(turn_degrees * -1.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_to_angle_with_lighting(turn_degrees, vm.f32(4.8))
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
					approach_degrees = monster.get_random_whole_number(180.0) or approach_degrees
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if roll < 50 then
						approach_degrees = vm.f32(approach_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						approach_degrees = vm.f32(-approach_degrees - 30.0)
					else
						approach_degrees = vm.f32(approach_degrees + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					target_threatening = fly_to_approach_point(1.75, vm.f32(4.8), approach_degrees, approach_distance, 30.0, 30.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_angle_with_lighting(final_turn_degrees, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.set_secondary_variable(0, 32)
					monster.set_motion("歩き", -1, 0)
					do
						local _, out2, _ = monster.get_rotation()
						facing_radians = out2 or facing_radians
					end
					turn_degrees = calc.radians_to_degrees(facing_radians)
					if turn_degrees > vm.f32(3.1415927) then
						turn_degrees = vm.f32(turn_degrees - vm.f32(6.2831855))
					end
					if turn_degrees <= vm.f32(-3.1415927) then
						turn_degrees = vm.f32(turn_degrees + vm.f32(6.2831855))
					end
					fly_in_direction(1.75, turn_degrees, 1000.0, 30.0, 30.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				target_threatening = sense.wait_until_target_threatening_with_lighting(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if target_threatening == 1 then
					return
				end
			end
		elseif unused_mode == 8 then
			print("7------------------------------------------------\n")
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1, 0)
			wander_randomly(1.75, vm.f32(4.8), distance, 360.0, 40.0, 30.0, 30.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Dashes at the target and sometimes fires an orb afterwards.
local function dash_then_maybe_fire()
	local chase_result: s32 = 0
	local roll: s32 = 0
	monster.set_motion("走り", -1, 0)
	chase_result = chase_target_flying(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 60)
	if chase_result < 55 and chase_result ~= 1 then
		climb_to_hover_height()
	end
	monster.set_motion("立ち", -1, 0)
	roll = monster.get_random(100) or roll
	if roll < 70 then
		fire_elemental_orb()
	end
end

--- Loops the aggressive behaviour used while the rage hits are spent, dashing, lunging and firing orbs.
local function fight_without_rage()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local chase_result: s32 = 0
	local rage_hits_left: s32 = 0
	monster.get_life()
	while true do
		timer.wait_frame_with_lighting()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 5 then
			strafe_or_wait()
			continue
		end
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance < 120.0 then
			roll = monster.get_random(100) or roll
			if roll < 90 then
				monster.set_motion("走り", -1, 0)
				chase_result = chase_target_flying(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 60)
				if chase_result < 55 and chase_result ~= 1 then
					climb_to_hover_height()
				end
				monster.set_motion("立ち", -1, 0)
				lunge_at_target()
			else
				fire_elemental_orb()
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 80 then
				fire_elemental_orb()
			else
				monster.set_motion("走り", -1, 0)
				chase_result = chase_target_flying(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 90)
				if chase_result < 85 and chase_result ~= 1 then
					climb_to_hover_height()
				end
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Picks between engaging, roaming and guarding depending on rage, guard state and target distance.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		hover_if_player_transformed()
		if reaction.is_guard_active() == 0 then
			target_distance = sense.get_horizontal_target_distance(target_distance)
			if target_distance < 290.0 then
				reaction.set_guard_active(0)
				engage_target()
			else
				roam_when_idle()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 180.0 then
					reaction.set_guard_active(0)
					engage_target()
				else
					dash_then_maybe_fire()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage()
	end
end

--- Disables flight and clears motion at the start of a knockdown.
local function begin_knockdown()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	movement.stop_turning()
	timer.wait_frame_with_lighting()
	state.set_flying_attributes(0)
	monster.set_action_status(1)
end

--- Waits every frame without ever returning.
local function wait_forever()
	while true do
		timer.wait_frame_with_lighting()
	end
end

--- Ends the throw, waits briefly and resumes flying.
local function recover_from_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_lighting(10)
	state.set_flying_attributes(1)
	monster.reset_motion()
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the melee hit windows, loads the effect scripts for the monster element and enables flying.
function script.init()
	local texture_block: s32 = 0
	local charge_effect_loaded: s32 = 0
	local launch_effect_loaded: s32 = 0
	local hit_effect_loaded: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.288, 0.408, 0)
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.288, 0.408, 1)
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.432, 0.696, 0)
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.432, 0.696, 1)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		if is_fire_element() ~= 0 then
			charge_effect_loaded = monster.load_effect_script("火弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("火弾Ｌ３", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("火弾Ｈ", texture_block) or hit_effect_loaded
		end
		if is_ice_element() ~= 0 then
			charge_effect_loaded = monster.load_effect_script("氷弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("氷弾Ｌ２", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("氷弾Ｈ", texture_block) or hit_effect_loaded
		end
		if is_thunder_element() ~= 0 then
			charge_effect_loaded = monster.load_effect_script("雷弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("雷弾Ｌ２", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("雷弾Ｈ", texture_block) or hit_effect_loaded
		end
		if is_water_element() ~= 0 then
			charge_effect_loaded = monster.load_effect_script("水弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("水弾Ｌ２", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("水弾Ｈ", texture_block) or hit_effect_loaded
		end
		if is_wind_element() ~= 0 then
			charge_effect_loaded = monster.load_effect_script("風弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("風弾Ｌ２", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("風弾Ｈ", texture_block) or hit_effect_loaded
		end
		if (if (if charge_effect_loaded ~= 0 then 1 else launch_effect_loaded) ~= 0 then 1 else hit_effect_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_position(position_x, position_y + 20.0, position_z)
	state.initialize_flying_defaults()
	state.set_max_flight_height(45.0)
	initialize_behavior_settings()
	monster.set_variable(0, 0)
end

--- Runs the monster main behaviour each frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		timer.wait_frame_with_lighting()
		choose_behavior()
	end
end

--- Staggers in place until the status ailment wears off.
function script.on_status_hit()
	local ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailments = 1
	while ailments ~= 0 do
		ailments = monster.get_status_ailments(40) or ailments
		timer.wait_frame_with_lighting()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the flinch reaction.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_with_lighting()
	timer.wait_frames_with_lighting(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockback, lies down and gets back up.
function script.on_knockdown()
	begin_knockdown()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_with_lighting()
	monster.set_action_status(1)
	timer.wait_frames_with_lighting(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_with_lighting()
	monster.set_motion("立ち")
	reaction.end_knockdown()
end

--- Plays the guard motion and recoils.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_lighting(8)
	state.unlock()
end

--- Faces the target and dodges its attack.
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
	timer.wait_frame_with_lighting()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Faces the target, turns toward it and dodges its attack.
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
	timer.wait_frame_with_lighting()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_with_lighting(vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.start_death_and_fall()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while held.
function script.on_caught()
	state.stop_flying_and_reset_motion()
	monster.set_motion("じたばた", -1, 4)
	while true do
		timer.wait_frame_with_lighting()
	end
	wait_forever()
end

--- Recovers after being thrown and settles back to the hover height.
function script.on_land()
	local position_x: f32 = 0
	local position_z: f32 = 0
	local ground_height: f32 = 0
	recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_lighting(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_with_lighting()
	movement.raise_one_unit()
	ground_height = sense.get_ground_height(ground_height)
	timer.wait_frame_with_lighting()
	do
		local out1, _, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	monster.set_position(position_x, ground_height + 10.0, position_z)
	timer.wait_frame_with_lighting()
	return 1
end

--- Falls, gets up and stays stunned until it recovers.
function script.on_stun()
	local position_x: f32 = 0
	local position_z: f32 = 0
	local height: f32 = 0
	local motion_finished: s32 = 0
	local ground_height: f32 = 0
	state.clear_attribute_and_lock()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_motion("吹っ飛び", -1, 6)
	while true do
		height = monster.get_height_above_ground() or height
		if height < 10.0 then
			break
		else
			timer.wait_frame_with_lighting()
			motion_finished = monster.is_motion_finished() or motion_finished
			if motion_finished ~= 0 then
				break
			end
		end
	end
	monster.set_motion("起き上がり", -1, 6)
	while true do
		height = monster.get_height_above_ground() or height
		if height < 10.0 then
			break
		else
			timer.wait_frame_with_lighting()
			motion_finished = monster.is_motion_finished() or motion_finished
			if motion_finished ~= 0 then
				break
			end
		end
	end
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	ground_height = sense.get_ground_height(ground_height)
	timer.wait_frame_with_lighting()
	do
		local out1, _, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	monster.set_position(position_x, ground_height + 10.0, position_z)
	timer.wait_frame_with_lighting()
	reaction.stun_until_recovered()
end

return script
