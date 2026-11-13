--!strict
--- Drives the Sewer Rat family of rodent monsters that bite and dodge around the player.

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

--- Returns a point around the target at the given angle offset and distance.
local function get_point_around_target(offset_degrees: f32, distance: f32, point_x: f32, point_y: f32, point_z: f32)
	local offset_radians: f32 = 0
	local angle: f32 = 0
	offset_radians = vm.f32(offset_degrees * vm.f32(0.017453292))
	angle = monster.get_target_angle() or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = vm.f32(angle + offset_radians)
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_point_around_target(angle, distance)
		point_x = out1 or point_x
		point_y = out2 or point_y
		point_z = out3 or point_z
	end
	return point_x, point_y, point_z
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
	destination_x, destination_y, destination_z = get_point_around_target(angle, distance, destination_x, destination_y, destination_z)
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
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(angle), turn_speed)
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
	result = movement.wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
	return result
end

--- Walks to a point beside the target or waits for it to face the monster.
local function sidestep_or_wait()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance_offset: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_offset = monster.get_random_whole_number(30.0) or side_offset
		distance_offset = monster.get_random_whole_number(30.0) or distance_offset
		distance_offset = vm.f32(distance_offset + 145.0)
		if roll < 50 then
			side_offset = vm.f32(-side_offset - 30.0)
		else
			side_offset = vm.f32(side_offset + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = walk_to_point_near_target(vm.f32(1.8), 4.0, side_offset, distance_offset, 37.0, 30)
		movement.turn_toward_target_and_wait_guarded(4.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(37.0, 45.0, 30)
	end
end

--- Performs the first attack and waits for it to finish.
local function bite_attack()
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	timer.wait_frames_with_guard_update(8)
end

--- Performs the dodging attack and waits for it to finish.
local function dodge_attack()
	monster.set_motion("避け攻撃", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	timer.wait_frames_with_guard_update(8)
end

--- Steps to one side and circles the target until it turns to face it.
local function strafe_around_target()
	local strafe_degrees: f32 = 0
	local target_distance: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local roll: s32 = 0
	local position_y: f32 = 0
	local roll_2: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 50 then
		strafe_degrees = 20.0
		monster.set_motion("ステップ右", -1, 2)
	else
		strafe_degrees = -20.0
		monster.set_motion("ステップ左", -1, 2)
	end
	timer.wait_frames_with_guard_update(calc.pass_through(10))
	destination_x, destination_y, destination_z = get_point_around_target(strafe_degrees, target_distance, destination_x, destination_y, destination_z)
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(destination_x, position_y - 20.0, destination_z, 4.0, 5.0)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("立ち")
	roll_2 = monster.get_random(50) or roll_2
	while true do
		movement.turn_toward_target(4.0)
		if roll_2 > 50 then
			break
		else
			roll_2 = roll_2 + 1
			reaction.update_and_wait_frame()
		end
	end
end

--- Approaches, circles or runs at the target when it is at long range.
local function act_at_long_range()
	local target_distance: f32 = 0
	local life: f32 = 0
	local roll: s32 = 0
	local side_degrees: f32 = 0
	life = 1.0
	target_distance = monster.get_target_distance() or target_distance
	life = monster.get_life() or life
	if target_distance < 150.0 and life > 0.25 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("歩き", -1.0, 0)
			movement.chase_target_guarded(vm.f32(1.8), 4.0, 37.0, 45)
		else
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("走り", -1.0, 0)
			movement.chase_target_guarded(4.0, 8.0, 37.0, 30)
			roll = monster.get_random(100) or roll
			if roll < 85 then
				bite_attack()
			else
				dodge_attack()
			end
		end
		monster.set_motion("立ち", -1, 0)
		return
	end
	roll = monster.get_random(100) or roll
	if roll < 40 then
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		movement.track_target_guarded(4.0, 30)
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
	else
		roll = monster.get_random(100) or roll
		if roll < 60 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				side_degrees = -30.0
			else
				side_degrees = 30.0
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			roll = monster.get_random(100) or roll
			monster.set_motion("歩き", -1.0, 0)
			walk_to_point_near_target(vm.f32(1.8), 4.0, side_degrees, target_distance, 37.0, vm.i32(45 + roll))
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.call_command(35, roll) -- retail: the handler rejects 1 arguments
				if roll < 30 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(8.0)
					strafe_around_target()
					monster.set_motion("立ち", -1, 0)
				else
					roll = monster.get_random(15) or roll
					monster.set_motion("歩き", -1.0, 0)
					movement.wander(vm.f32(1.8), 3.0, target_distance, 360.0, 40.0, 37.0, vm.i32(45 + roll))
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				monster.set_motion("走り", -1.0, 0)
				movement.chase_target_guarded(4.0, 8.0, 37.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Performs the dodge-return motion three times in a row.
local function shuffle_back()
	monster.set_motion("避け戻り", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 4)
	reaction.update_and_wait_frame()
	monster.set_motion("避け戻り", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 4)
	reaction.update_and_wait_frame()
	monster.set_motion("避け戻り", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	timer.wait_frames_with_guard_update(8)
end

--- Hops backwards away from the target.
local function hop_back()
	local position_x: f32 = 0
	local position_z: f32 = 0
	local position_y_2: f32 = 0
	monster.set_motion("ステップ後", -1, 2)
	timer.wait_frames_with_guard_update(calc.pass_through(12))
	do
		local out1, _, out3 = monster.get_point_from_facing(3.1415927, 40.0)
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_position_3()
		position_y_2 = out2 or position_y_2
	end
	monster.move_toward_position(position_x, position_y_2 + -26.0, position_z, 4.0, 5.0)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
end

--- Attacks, shuffles or strafes when the target is close.
local function act_at_close_range()
	local target_distance: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 65 then
		roll = monster.get_random(100) or roll
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_toward_target_and_wait_guarded(8.0)
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 45.0 then
			monster.set_motion("走り", -1.0, 0)
			movement.chase_target_guarded(4.0, 4.0, 37.0, 30)
		elseif target_distance > vm.f32(51.8) then
			monster.set_motion("歩き", -1.0, 0)
			movement.chase_target_guarded(vm.f32(1.8), 4.0, 37.0, 30)
		end
		roll = monster.get_random(100) or roll
		if roll < 85 then
			bite_attack()
		else
			dodge_attack()
		end
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(9)
	else
		roll = monster.get_random(100) or roll
		if roll < 70 then
			roll = monster.get_random(100) or roll
			if roll < 30 then
				if target_distance < 45.0 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					monster.set_motion("歩き", -1.0, 0)
					movement.chase_target_guarded(vm.f32(1.8), 4.0, 37.0, 45)
				else
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					monster.set_motion("走り", -1.0, 0)
					movement.chase_target_guarded(8.0, 4.0, 37.0, 30)
				end
				movement.turn_toward_target_and_wait_guarded(8.0)
				bite_attack()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(9)
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				shuffle_back()
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(8.0)
				hop_back()
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(8.0)
				strafe_around_target()
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Fights the target by distance until it moves away.
local function fight_target_nearby()
	local target_distance: f32 = 0
	local priority: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.face_target_if_transformed_medium()
		monster.get_life()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 300.0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			sidestep_or_wait()
			continue
		end
		if target_distance < 300.0 and target_distance >= 145.0 then
			act_at_long_range()
		else
			act_at_close_range()
		end
	end
end

--- Picks a random idle action such as wandering, turning or watching when the target is far away.
local function wander_when_idle()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle: f32 = 0
	local final_turn_angle: f32 = 0
	local approach_angle: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local look_angle: f32 = 0
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
	distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 37.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 37.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.0, vm.f32(1.8), turn_angle, clear_distance, 37.0, 30)
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
				monster.set_place_position(position_x, position_y, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					orbit_angle = vm.f32(-orbit_angle - 30.0)
				else
					orbit_angle = vm.f32(orbit_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, vm.f32(1.8), 3.0, distance, orbit_angle, 37.0, 60)
				final_turn_angle = monster.get_random_whole_number(180.0) or final_turn_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_angle = vm.f32(final_turn_angle * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_angle, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 75 then
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
			movement.turn_to_angle_and_wait(turn_angle, 3.0)
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
					wait_result = walk_to_point_near_target(vm.f32(1.8), 3.0, approach_angle, approach_distance, 37.0, 60)
					look_angle = monster.get_random_whole_number(360.0) or look_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						look_angle = vm.f32(look_angle * -1.0)
					end
					movement.turn_to_angle_and_wait(look_angle, 3.0)
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
					movement.move_in_direction_guarded(vm.f32(1.8), turn_angle, 1000.0, 37.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.8), 3.0, distance, 360.0, 40.0, 37.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs after the target for a while.
local function run_at_target()
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(4.0, 4.0, 37.0, 180)
	monster.set_motion("立ち", -1, 0)
end

--- Chooses between fighting, wandering and chasing from the rage hits and guard state.
local function choose_behavior()
	local rage_hits_left: s32 = 0
	local target_distance: f32 = 0
	local alert_range: f32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 300.0 then
				fight_target_nearby()
			else
				monster.set_mask_flags(1, 1)
				monster.set_mask_flags(2, 1)
				wander_when_idle()
				monster.set_mask_flags(1, 0)
				monster.set_mask_flags(2, 0)
			end
		else
			alert_range = state.get_secondary_float(alert_range)
			if target_distance < alert_range then
				if target_distance < 145.0 then
					reaction.set_guard_active(0)
					fight_target_nearby()
				else
					run_at_target()
				end
			end
		end
	else
		fight_target_nearby()
	end
end

--- Dodges backwards and then lunges at the target with the dodging attack.
local function dodge_back_and_lunge()
	local position_x: f32 = 0
	local position_z: f32 = 0
	local position_y_2: f32 = 0
	monster.set_motion("避け", -1, 2)
	monster.set_monster_attributes(32, 1)
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	monster.set_monster_attributes(32, 0)
	do
		local out1, _, out3 = monster.get_point_from_facing(3.1415927, 30.0)
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_position_3()
		position_y_2 = out2 or position_y_2
	end
	monster.move_toward_position(position_x, position_y_2 + -26.0, position_z, 5.0, 5.0)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("避け攻撃", -1, 6)
	timer.wait_frames_with_guard_update(4)
	monster.set_monster_attributes(32, 1)
	do
		local out1, _, out3 = monster.get_point_from_facing(0.0, 40.0)
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_position_3()
		position_y_2 = out2 or position_y_2
	end
	monster.move_toward_position(position_x, position_y_2 + -26.0, position_z, 5.0, 5.0)
	motion.wait_until_finished_guarded()
	monster.set_monster_attributes(32, 0)
	timer.wait_frames_with_guard_update(8)
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the monster's attack hit windows and prepares its state.
function script.init()
	monster.register_entry_object(0, "bcol00")
	monster.register_entry_object(1, "dcol00")
	monster.register_entry_object(2, "dcol01")
	monster.register_damage_hit("通常攻撃", 5.0, "攻撃１", 0.3, 0.6, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 4.5, "避け攻撃", 0.3, 0.45, 1)
	monster.get_position_3()
	initialize_monster_settings()
end

--- Runs the monster's behaviour each frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		choose_behavior()
	end
end

--- Holds the monster in its damage pose until its status ailment wears off.
function script.on_status_hit()
	local has_status_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ後", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status_ailment = 1
	while has_status_ailment ~= 0 do
		has_status_ailment = monster.get_status_ailments(40) or has_status_ailment
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers the monster back when it takes a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ後", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Knocks the monster over, waits, and gets it back up.
function script.on_knockdown()
	local is_motion_finished: s32 = 0
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(5.0, 0.05, 10)
	while true do
		is_motion_finished = 0
		is_motion_finished = monster.is_motion_finished() or is_motion_finished
		if is_motion_finished ~= 0 then
			monster.set_action_status(1)
			timer.wait_frames_with_guard_update(45)
			monster.set_action_status(0)
			monster.set_motion("起き上がり", -1, 6)
			while true do
				reaction.update_and_wait_frame()
				is_motion_finished = monster.is_motion_finished() or is_motion_finished
				if is_motion_finished ~= 0 then
					return 1
				end
			end
		end
		reaction.update_and_wait_frame()
	end
	state.unlock_and_clear_action()
end

--- Makes the monster guard against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 4)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	state.unlock()
end

--- Dodges backwards or lunges depending on the rage hits left.
function script.on_dodge_1()
	local rage_hits_left: s32 = 0
	local lunge_chance: s32 = 0
	local roll: s32 = 0
	local position_x: f32 = 0
	local position_z: f32 = 0
	local position_y_2: f32 = 0
	state.lock_and_reset_motion()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	reaction.update_and_wait_frame()
	movement.face_target_instantly()
	reaction.update_and_wait_frame()
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left == 0 then
		lunge_chance = 80
	else
		lunge_chance = 40
	end
	roll = monster.get_random(100) or roll
	if roll < lunge_chance then
		dodge_back_and_lunge()
	else
		monster.set_motion("避け", -1, 6)
		monster.set_monster_attributes(32, 1)
		timer.wait_frames_with_guard_update(calc.pass_through(6))
		monster.set_monster_attributes(32, 0)
		do
			local out1, _, out3 = monster.get_point_from_facing(3.1415927, 30.0)
			position_x = out1 or position_x
			position_z = out3 or position_z
		end
		do
			local _, out2, _ = monster.get_position_3()
			position_y_2 = out2 or position_y_2
		end
		monster.move_toward_position(position_x, position_y_2 + -26.0, position_z, 5.0, 5.0)
		motion.wait_until_finished_guarded()
		monster.stop_moving()
		monster.set_motion("避け戻り", -1, 6)
		do
			local out1, _, out3 = monster.get_point_from_facing(3.1415927, 20.0)
			position_x = out1 or position_x
			position_z = out3 or position_z
		end
		do
			local _, out2, _ = monster.get_position_3()
			position_y_2 = out2 or position_y_2
		end
		monster.move_toward_position(position_x, position_y_2 + -26.0, position_z, 5.0, 5.0)
		motion.wait_until_finished_guarded()
		monster.stop_moving()
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Steps to the side to dodge.
function script.on_dodge_2()
	local position_x: f32 = 0
	local position_z: f32 = 0
	local roll: s32 = 0
	local position_y_2: f32 = 0
	state.lock_and_reset_motion()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	reaction.update_and_wait_frame()
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ左", -1, 2)
		do
			local out1, _, out3 = monster.get_point_from_facing(1.5707964, 20.0)
			position_x = out1 or position_x
			position_z = out3 or position_z
		end
	else
		monster.set_motion("ステップ右", -1, 2)
		do
			local out1, _, out3 = monster.get_point_from_facing(-1.5707964, 20.0)
			position_x = out1 or position_x
			position_z = out3 or position_z
		end
	end
	monster.set_monster_attributes(32, 1)
	timer.wait_frames_with_guard_update(calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	do
		local _, out2, _ = monster.get_position_3()
		position_y_2 = out2 or position_y_2
	end
	monster.move_toward_position(position_x, position_y_2 + -26.0, position_z, 4.0, 5.0)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 4)
	monster.stop_moving()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
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
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Gets the monster back on its feet after it lands from a throw.
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

--- Staggers the monster and keeps it stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
