--!strict
--- Drives the griffin monsters (Tigriff, Chimera, Leogriff and Sphinx), which fire feather volleys.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard thresholds and the draw clip distance, unlimited for bosses.
local function configure_guard_and_clip_distance()
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

--- Either walks to a point beside the target or stands waiting for the target to come in front.
local function sidestep_or_stand()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_offset = monster.get_random_whole_number(30.0) or side_offset
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 150.0)
		if roll < 50 then
			side_offset = vm.f32(-side_offset - 30.0)
		else
			side_offset = vm.f32(side_offset + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(1.75, vm.f32(4.8), side_offset, distance, 79.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(79.0, 45.0, 30)
	end
end

--- Turns toward a goal angle, giving up with -1 if the target comes into view, and returns the frames spent.
local function turn_until_facing_goal(goal_angle_degrees: f32, tolerance_degrees: f32, view_distance: f32, view_angle_degrees: f32, max_frames: f32)
	local rotation_y: f32 = 0
	local elapsed_frames: f32 = 0
	local frame_limit: f32 = 0
	goal_angle_degrees = calc.degrees_to_radians(goal_angle_degrees)
	if goal_angle_degrees > vm.f32(3.1415927) then
		goal_angle_degrees = vm.f32(goal_angle_degrees - vm.f32(6.2831855))
	end
	if goal_angle_degrees <= vm.f32(-3.1415927) then
		goal_angle_degrees = vm.f32(goal_angle_degrees + vm.f32(6.2831855))
	end
	tolerance_degrees = calc.degrees_to_radians(tolerance_degrees)
	frame_limit = max_frames
	elapsed_frames = 0.0
	while elapsed_frames < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		if sense.is_target_in_front(view_distance, view_angle_degrees) ~= 0 then
			return -1
		end
		if rotation_y > vm.f32(goal_angle_degrees - tolerance_degrees) and rotation_y < vm.f32(goal_angle_degrees + tolerance_degrees) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(goal_angle_degrees, rotation_y, tolerance_degrees) == 0 then
			movement.stop_turning()
			break
		elseif elapsed_frames >= max_frames then
			movement.stop_turning()
			break
		else
			reaction.update_and_wait_frame()
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
	end
	movement.stop_turning()
	return vm.ftoi(elapsed_frames)
end

--- Turns to a random heading and chases the target if it comes into view, otherwise waits for it.
local function turn_randomly_and_look_for_target()
	local turn_result: s32 = 0
	local random_angle: f32 = 0
	local rotation_speed: f32 = 0
	random_angle = monster.get_random_whole_number(360.0) or random_angle
	monster.set_motion("歩き", -1, 0)
	random_angle = calc.degrees_to_radians(random_angle)
	if random_angle > vm.f32(3.1415927) then
		random_angle = vm.f32(random_angle - vm.f32(6.2831855))
	end
	if random_angle <= vm.f32(-3.1415927) then
		random_angle = vm.f32(random_angle + vm.f32(6.2831855))
	end
	rotation_speed = calc.degrees_to_radians(vm.f32(4.8))
	if rotation_speed > vm.f32(3.1415927) then
		rotation_speed = vm.f32(rotation_speed - vm.f32(6.2831855))
	end
	if rotation_speed <= vm.f32(-3.1415927) then
		rotation_speed = vm.f32(rotation_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(random_angle, rotation_speed)
	turn_result = turn_until_facing_goal(
		calc.radians_to_degrees(random_angle),
		calc.radians_to_degrees(rotation_speed),
		350.0,
		60.0,
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(rotation_speed)))
	)
	movement.stop_turning()
	if turn_result == -1 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
		monster.set_motion("走り", -1, 0)
		movement.chase_target_guarded(4.0, vm.f32(4.8), 79.0, 160)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(350.0, 60.0, 45)
	end
end

--- Winds up and launches six feather projectiles toward the target.
local function fire_feather_volley()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local to_target_x: f32 = 0
	local to_target_y: f32 = 0
	local to_target_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local feather_value: f32 = 0
	local attack_power: s32 = 0
	monster.set_variable(0, 1)
	feather_value = 8.0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(7.2000003))
	monster.set_motion("攻撃１in", -1, 2)
	motion.wait_until_finished_facing_target_guarded(vm.f32(4.8))
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_progress(vm.f32(0.15), -1.0)
	attack_power = monster.get_attack_power_1() or attack_power
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	do
		local out1, out2, out3 = monster.get_frame_position("eff288")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(to_target_x, to_target_y, to_target_z, position_x, position_y, position_z)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y + vm.f32(0.18), rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	monster.set_effect_value_float(-1, 1, feather_value)
	do
		local out1, out2, out3 = monster.get_frame_position("eff289")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(to_target_x, to_target_y, to_target_z, position_x, position_y, position_z)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y + vm.f32(0.18), rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	monster.set_effect_value_float(-1, 1, feather_value - 1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("eff290")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(to_target_x, to_target_y, to_target_z, position_x, position_y, position_z)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y + vm.f32(0.18), rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	monster.set_effect_value_float(-1, 1, feather_value - 2.0)
	do
		local out1, out2, out3 = monster.get_frame_position("eff276")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(to_target_x, to_target_y, to_target_z, position_x, position_y, position_z)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y - vm.f32(0.18), rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	monster.set_effect_value_float(-1, 1, feather_value)
	do
		local out1, out2, out3 = monster.get_frame_position("eff277")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(to_target_x, to_target_y, to_target_z, position_x, position_y, position_z)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y - vm.f32(0.18), rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	monster.set_effect_value_float(-1, 1, feather_value - 1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("eff278")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(to_target_x, to_target_y, to_target_z, position_x, position_y, position_z)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	monster.create_effect_1("ティグ羽根Ｌ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y - vm.f32(0.18), rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	monster.set_effect_value_float(-1, 1, feather_value - 2.0)
	motion.wait_until_finished_guarded()
	monster.set_motion("攻撃１out", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(6)
end

--- Chooses an action when the target is far away: turn, feather volley, chase or wait.
local function act_at_long_range()
	local roll: s32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			turn_randomly_and_look_for_target()
		else
			fire_feather_volley()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 90 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(1.75, vm.f32(4.8), 150.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(79.0, 45.0, 75)
		end
	end
end

--- Turns to the target and lunges forward with a claw slash.
local function lunge_slash()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_angle: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(7.2000003))
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	target_angle = monster.get_target_angle() or target_angle
	position_x = vm.f32(position_x + vm.f32(vm.sin(target_angle) * 100.0))
	position_y = vm.f32(position_y - 20.0)
	position_z = vm.f32(position_z + vm.f32(vm.cos(target_angle) * 100.0))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_progress(vm.f32(0.323), -1.0)
	monster.move_toward_position(position_x, position_y, position_z, 8.0, 8.0)
	motion.wait_until_progress(vm.f32(0.404), -1.0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(6)
end

--- Chooses an action when the target is close: feather volley, chase and slash, or sidestep.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 30 then
		fire_feather_volley()
	end
	roll = monster.get_random(100) or roll
	if roll < 75 then
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(1.75, vm.f32(4.8), 79.0, 60)
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 94.0 then
			lunge_slash()
		else
			fire_feather_volley()
		end
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 15 then
			roll = monster.get_random(100) or roll
			side_angle = monster.get_random_whole_number(60.0) or side_angle
			if roll < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(1.75, vm.f32(4.8), side_angle, 158.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(6)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Combat loop used while rage hits remain, picking actions by target distance until the target leaves.
local function fight_with_rage_hits_left()
	local target_distance: f32 = 0
	local monster_priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 350.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			reaction.update_and_wait_frame()
			return
		end
		monster_priority = monster.get_priority() or monster_priority
		if monster_priority > 3 then
			sidestep_or_stand()
			continue
		end
		if target_distance < 350.0 and target_distance >= 150.0 then
			act_at_long_range()
		else
			act_at_close_range()
		end
	end
end

--- Idles by wandering, orbiting the spawn point or watching for the target when it is not engaged.
local function wander_near_spawn()
	local roll: s32 = 0
	local threat_result: s32 = 0
	local unused_selector: s32 = 0
	local place_distance: f32 = 0
	local turn_angle: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_start_angle: f32 = 0
	local orbit_end_turn_angle: f32 = 0
	local approach_angle: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_angle: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_position_x = out1 or place_position_x
		place_position_y = out2 or place_position_y
		place_position_z = out3 or place_position_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	place_distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or place_distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 79.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 79.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.8), 1.75, turn_angle, clear_distance, 79.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if place_distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if place_distance > 800.0 then
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
				orbit_start_angle = monster.get_random_whole_number(360.0) or orbit_start_angle
				place_distance = monster.get_random_whole_number(150.0) or place_distance
				if roll < 50 then
					orbit_start_angle = vm.f32(-orbit_start_angle - 30.0)
				else
					orbit_start_angle = vm.f32(orbit_start_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, 1.75, vm.f32(4.8), place_distance, orbit_start_angle, 79.0, 60)
				orbit_end_turn_angle = monster.get_random_whole_number(180.0) or orbit_end_turn_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					orbit_end_turn_angle = vm.f32(orbit_end_turn_angle * -1.0)
				end
				movement.turn_to_angle_and_wait(orbit_end_turn_angle, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 20 then
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
			movement.turn_to_angle_and_wait(turn_angle, vm.f32(4.8))
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
					approach_angle = monster.get_random_whole_number(180.0) or approach_angle
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if roll < 50 then
						approach_angle = vm.f32(approach_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						approach_angle = vm.f32(-approach_angle - 30.0)
					else
						approach_angle = vm.f32(approach_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					threat_result = movement.walk_to_point_near_target(1.75, vm.f32(4.8), approach_angle, approach_distance, 79.0, 60)
					final_turn_angle = monster.get_random_whole_number(360.0) or final_turn_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_angle = vm.f32(final_turn_angle * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_angle, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					turn_angle = calc.radians_to_degrees(rotation_y)
					if turn_angle > vm.f32(3.1415927) then
						turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
					end
					if turn_angle <= vm.f32(-3.1415927) then
						turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(1.75, turn_angle, 1000.0, 79.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
		elseif unused_selector == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			place_distance = monster.get_target_distance() or place_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(1.75, vm.f32(4.8), place_distance, 360.0, 40.0, 79.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs after the target for a short while and then stands.
local function chase_target_at_run_speed()
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(4.0, vm.f32(4.8), 79.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Combat loop used once no rage hits remain, alternating chases, slashes and feather volleys.
local function fight_without_rage_hits_left()
	local target_distance: f32 = 0
	local monster_priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		behavior.face_target_if_transformed_fast()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		monster_priority = monster.get_priority() or monster_priority
		if monster_priority > 4 then
			sidestep_or_stand()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 150.0 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(4.0, vm.f32(4.8), 79.0, 60)
				lunge_slash()
			else
				fire_feather_volley()
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				lunge_slash()
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(7.2000003))
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(4.0, vm.f32(4.8), 79.0, 75)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Chooses between fighting, wandering and releasing the guard each frame.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_release_distance: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 350.0 then
				fight_with_rage_hits_left()
			else
				wander_near_spawn()
			end
		else
			guard_release_distance = state.get_secondary_float(guard_release_distance)
			if target_distance < guard_release_distance then
				if target_distance < 150.0 then
					reaction.set_guard_active(0)
					fight_with_rage_hits_left()
				else
					chase_target_at_run_speed()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage_hits_left()
	end
end

--- Hops backward away from the target while briefly invulnerable.
local function step_back_dodge()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local away_angle: f32 = 0
	local target_angle: f32 = 0
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		away_angle = out2 or away_angle
	end
	away_angle = vm.f32(away_angle + vm.f32(3.1415927))
	position_x = vm.f32(position_x + vm.f32(100.0 * vm.sin(away_angle)))
	position_z = vm.f32(position_z + vm.f32(100.0 * vm.cos(away_angle)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	monster.move_toward_position(position_x, position_y, position_z, 4.0, 4.0)
	timer.wait_frames_with_guard_update(calc.pass_through(17))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

local script = {}

--- Runs when the script is loaded.
function script.setup() end

--- Registers the monster's hit reactions, loads its feather effect scripts and sets its guard and clip distances.
function script.init()
	local texture_block: s32 = 0
	local light_feather_loaded: s32 = 0
	local heavy_feather_loaded: s32 = 0
	monster.register_damage_hit("通常攻撃", 5.0, "攻撃２", 0.404, 0.417, 0)
	monster.register_damage_hit("通常攻撃", 7.2, "攻撃２", 0.35, 0.417, 1)
	monster.register_damage_hit("通常攻撃", 7.2, "攻撃２", 0.35, 0.417, 2)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		light_feather_loaded = monster.load_effect_script("ティグ羽根Ｌ", texture_block) or light_feather_loaded
		heavy_feather_loaded = monster.load_effect_script("ティグ羽根Ｈ", texture_block) or heavy_feather_loaded
		if (if light_feather_loaded ~= 0 then 1 else heavy_feather_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(0, 0)
	configure_guard_and_clip_distance()
end

--- Updates the monster's behaviour every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		update_behavior()
	end
end

--- Plays the damage motion until the status ailments wear off.
function script.on_status_hit()
	local ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailments = 1
	while ailments ~= 0 do
		ailments = monster.get_status_ailments(40) or ailments
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers back from a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち", 0)
	state.do_nothing()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default knockdown.
function script.on_knockdown() end

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	state.unlock()
end

--- Turns to the target and steps back out of the way.
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
	reaction.update_and_wait_frame()
	step_back_dodge()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Turns to the target and faces it again.
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
	reaction.update_and_wait_frame()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Stands up after being thrown.
function script.on_land()
	reaction.recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_guard_update(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	state.do_nothing_hook()
	return 1
end

--- Is knocked down and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
