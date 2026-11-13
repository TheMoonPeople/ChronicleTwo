--!strict
--- Drives the fox and wolf gunner monsters (Hunter Fox, Red Fox, Rifle Wolf, Smiling Wolf).

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets how far from the camera the monster stays drawn, unlimited for bosses.
local function apply_clip_distance()
	local is_boss: s32 = 0
	is_boss = monster.is_boss() or is_boss
	if is_boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Walks toward a point offset around the target, stopping short of obstacles, and returns whether it arrived.
local function walk_to_point_around_target(move_speed: f32, turn_speed: f32, angle_offset: f32, distance: f32, arrival_distance: f32, timeout_frames: s32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local clear_distance: f32 = 0
	local arrival_result: s32 = 0
	point_x, point_y, point_z = movement.get_point_around_target(angle_offset, distance, point_x, point_y, point_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	angle_offset = monster.get_angle_to_position(point_x, point_y, point_z) or angle_offset
	if angle_offset > vm.f32(3.1415927) then
		angle_offset = vm.f32(angle_offset - vm.f32(6.2831855))
	end
	if angle_offset <= vm.f32(-3.1415927) then
		angle_offset = vm.f32(angle_offset + vm.f32(6.2831855))
	end
	movement.turn_to_angle(calc.radians_to_degrees(angle_offset), turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.copy_vector(point_x, point_y, point_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
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
	clear_distance = monster.get_clear_distance(move_speed + arrival_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(move_speed + arrival_distance) then
		point_x = vm.f32(position_x + vm.f32(vm.sin(angle_offset) * clear_distance))
		point_y = position_y
		point_z = vm.f32(position_z + vm.f32(vm.cos(angle_offset) * clear_distance))
		clear_distance = vm.f32(clear_distance - arrival_distance)
		if clear_distance < arrival_distance then
			return -1
		end
	end
	monster.move_toward_position(point_x, position_y - 20.0, point_z, move_speed, move_speed)
	arrival_result = movement.wait_until_arrived_unguarded(arrival_distance, timeout_frames)
	monster.stop_moving()
	return arrival_result
end

--- Either walks to a point beside the target or stands waiting for the target to come into view.
local function sidestep_or_stand()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_offset = monster.get_random_whole_number(30.0) or side_offset
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 80.0)
		if roll < 50 then
			side_offset = vm.f32(-side_offset - 30.0)
		else
			side_offset = vm.f32(side_offset + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = walk_to_point_around_target(2.0, 5.0, side_offset, distance, 30.0, 30)
		movement.turn_toward_target_and_wait(5.0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(30.0, 45.0, 30)
	end
end

--- Tracks the target for a number of frames and then fires a rifle shot with a muzzle flash.
local function aim_and_fire_rifle(base_aim_frames: s32)
	local roll: s32 = 0
	local aim_frames: s32 = 0
	local attack_power: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	roll = monster.get_random(5) or roll
	aim_frames = vm.i32(base_aim_frames + roll)
	monster.set_motion("攻撃１ループ", -1, 0)
	movement.track_target(5.0, aim_frames)
	monster.set_motion("攻撃１", -1, 6)
	attack_power = monster.get_attack_power_1() or attack_power
	do
		local out1, out2, out3 = monster.get_frame_position("dcol00")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.create_effect_1("fox_銃弾")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_value(-1, 0, attack_power)
	monster.create_effect_1("マズルフラッシュ")
	motion.wait_until_finished()
end

--- Moves sideways around the target at a fixed range, stopping short of obstacles.
local function strafe_around_target(move_speed: f32, angle_offset: f32, arrival_distance: f32, timeout_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local distance: f32 = 0
	distance = monster.get_target_distance() or distance
	point_x, point_y, point_z = movement.get_point_around_target(angle_offset, distance, point_x, point_y, point_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(point_x, point_y, point_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
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
	distance = monster.get_clear_distance(100.0, 0.0) or distance
	if distance < 100.0 then
		point_x = vm.f32(position_x + vm.f32(direction_x * distance))
		point_y = position_y
		point_z = vm.f32(position_z + vm.f32(direction_z * distance))
		distance = vm.f32(distance - arrival_distance)
		if distance < arrival_distance then
			return
		end
	end
	monster.move_toward_position(point_x, position_y, point_z, move_speed, move_speed)
	local _ = movement.wait_until_arrived_unguarded(arrival_distance, timeout_frames)
	monster.stop_moving()
end

--- Chooses an action when the target is far away: shoot, wander, wait or strafe.
local function act_at_long_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 60 then
		roll = monster.get_random(100) or roll
		if roll < 60 then
			aim_and_fire_rifle(60)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.wander_unguarded(2.0, 5.0, 15.0, 180.0, 20.0, 30.0, 20)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(200.0, 45.0, 30)
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait(5.0)
			monster.set_motion("歩き右", -1, 4)
			strafe_around_target(2.0, 30.0, 200.0, 30)
		else
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait(5.0)
			monster.set_motion("歩き左", -1, 4)
			strafe_around_target(2.0, -30.0, 200.0, 30)
		end
	end
end

--- Hops backward away from the target while briefly invulnerable.
local function retreat_from_target(move_speed: f32)
	local position_x: f32 = 0
	local point_y: f32 = 0
	local position_z: f32 = 0
	local position_y: f32 = 0
	local retreat_distance: f32 = 0
	local random_extra_distance: f32 = 0
	monster.set_monster_attributes(32, 1)
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	random_extra_distance = monster.get_random_whole_number(15.0) or random_extra_distance
	retreat_distance = vm.f32(retreat_distance + vm.f32(100.0 + random_extra_distance))
	position_x, point_y, position_z = movement.get_point_around_target(0.0, retreat_distance, position_x, point_y, position_z)
	monster.set_motion("歩き後", -1, 2)
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(position_x, position_y - 10.0, position_z, move_speed, move_speed + 1.0)
	timer.wait_frames(calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Chooses an action when the target is at medium distance: shoot, circle, retreat or strafe.
local function act_at_medium_range()
	local roll: s32 = 0
	local extra_distance: f32 = 0
	local angle_offset: f32 = 0
	local retreat_angle_degrees: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			aim_and_fire_rifle(35)
		else
			monster.get_random(100, roll)
			monster.get_random_whole_number(45.0, angle_offset)
			monster.get_random_whole_number(30.0, extra_distance)
			if roll < 50 then
				angle_offset = vm.f32(-angle_offset - 45.0)
			else
				angle_offset = vm.f32(angle_offset + 45.0)
			end
			extra_distance = vm.f32(extra_distance + 40.0)
			monster.set_motion("歩き", -1.0, 0)
			local _ = walk_to_point_around_target(2.0, 5.0, angle_offset, vm.f32(200.0 + extra_distance), 30.0, 30)
			movement.turn_toward_target_and_wait(5.0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 15 then
			retreat_from_target(vm.f32(3.2))
			aim_and_fire_rifle(20)
		elseif roll < 35 then
			retreat_angle_degrees = monster.get_target_angle() or retreat_angle_degrees
			retreat_angle_degrees = calc.radians_to_degrees(vm.f32(retreat_angle_degrees + vm.f32(3.1415927)))
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_and_move_in_direction(2.0, 5.0, retreat_angle_degrees, 60.0, 300.0, 60)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait(5.0)
				monster.set_motion("歩き右", -1, 4)
				strafe_around_target(2.0, 30.0, 200.0, 30)
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait(5.0)
				monster.set_motion("歩き左", -1, 4)
				strafe_around_target(2.0, -30.0, 200.0, 30)
			end
		end
	end
end

--- Plays the counter attack motion to completion.
local function perform_counter_attack()
	monster.set_motion("避け攻撃", -1, 6)
	motion.wait_until_finished()
end

--- Chooses an action when the target is close: counter attack, shoot, dash around or retreat.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local variable_0: s32 = 0
	local variable_1: s32 = 0
	local second_roll: s32 = 0
	local side_angle_degrees: f32 = 0
	local point_angle: f32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local walk_result: s32 = 0
	local side_angle_offset: f32 = 0
	monster.get_life()
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 30 then
		roll = monster.get_random(100) or roll
		if roll < 85 then
			if target_distance < 80.0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait(7.5)
				perform_counter_attack()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(3)
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait(5.0)
				aim_and_fire_rifle(15)
			end
		else
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait(5.0)
			aim_and_fire_rifle(30)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			variable_0 = monster.get_variable(0) or variable_0
			variable_1 = monster.get_variable(1) or variable_1
			if variable_0 == 1 or variable_1 > 5 then
				monster.get_target_distance()
				second_roll = monster.get_random(100) or second_roll
				if second_roll < 50 then
					side_angle_degrees = 120.0
				else
					side_angle_degrees = -120.0
				end
				point_x, point_y, point_z = movement.get_point_around_target(side_angle_degrees, 200.0, point_x, point_y, point_z)
				point_angle = monster.get_angle_to_position(point_x, point_y, point_z) or point_angle
				monster.set_rotation(0.0, point_angle, 0.0)
				monster.set_motion("走り")
				monster.move_toward_position(point_x, point_y - 20.0, point_z, 6.4, 6.4)
				movement.wait_until_move_finished_without_stopping(60)
				monster.set_variable(0, 0)
				monster.set_variable(1, 0)
			else
				roll = monster.get_random(100) or roll
				if roll < 25 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait(5.0)
					retreat_from_target(vm.f32(3.8400002))
					aim_and_fire_rifle(20)
				else
					monster.get_random(100, roll)
					monster.get_random_whole_number(30.0, side_angle_offset)
					if roll < 50 then
						side_angle_offset = vm.f32(-side_angle_offset - 30.0)
					else
						side_angle_offset = vm.f32(side_angle_offset + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					walk_result = walk_to_point_around_target(2.0, 5.0, side_angle_offset, 60.0, 30.0, 40)
					movement.turn_toward_target_and_wait(5.0)
					if walk_result == 1 then
						monster.set_motion("歩き", -1.0, 0)
						movement.turn_toward_target_and_wait(5.0)
						perform_counter_attack()
						monster.set_motion("立ち", -1, 0)
						timer.wait_frames(3)
					end
				end
			end
		end
	end
end

--- Combat loop used while rage hits remain, picking actions by target distance until the target leaves.
local function fight_with_rage_hits_left()
	local target_distance: f32 = 0
	local monster_priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		behavior.try_face_transformed_player_plain_speed_3()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 300.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		monster_priority = monster.get_priority() or monster_priority
		if monster_priority > 4 then
			sidestep_or_stand()
			continue
		end
		if target_distance < 300.0 and target_distance >= 200.0 then
			act_at_long_range()
		elseif target_distance < 200.0 and target_distance >= 80.0 then
			act_at_medium_range()
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
	timer.wait_one_frame()
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
	if clear_distance < 30.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle(turn_angle, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 30.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction(3.0, vm.f32(1.8), turn_angle, clear_distance, 30.0, 30)
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
				movement.walk_around_position_unguarded(place_position_x, place_position_y, place_position_z, vm.f32(1.8), 3.0, place_distance, orbit_start_angle, 30.0, 60)
				orbit_end_turn_angle = monster.get_random_whole_number(180.0) or orbit_end_turn_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					orbit_end_turn_angle = vm.f32(orbit_end_turn_angle * -1.0)
				end
				movement.turn_to_angle(orbit_end_turn_angle, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening(200.0, 50.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(200.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle = monster.get_random_whole_number(180.0) or turn_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle = vm.f32(turn_angle * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle(turn_angle, 3.0)
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
					threat_result = walk_to_point_around_target(vm.f32(1.8), 3.0, approach_angle, approach_distance, 30.0, 60)
					final_turn_angle = monster.get_random_whole_number(360.0) or final_turn_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_angle = vm.f32(final_turn_angle * -1.0)
					end
					movement.turn_to_angle(final_turn_angle, 3.0)
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
					movement.move_in_direction(vm.f32(1.8), turn_angle, 1000.0, 30.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening(200.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			movement.wander_unguarded(vm.f32(1.8), 3.0, place_distance, 360.0, 40.0, 30.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Stops moving and stands still for a number of frames.
local function stand_for_frames(frames: s32)
	monster.stop_moving()
	monster.reset_motion()
	monster.set_motion("立ち", -1, 4)
	timer.wait_for_frames(frames)
end

--- Combat loop used once no rage hits remain, favouring melee counters and dashes.
local function fight_without_rage_hits_left()
	local target_distance: f32 = 0
	local monster_priority: s32 = 0
	local rage_hits_left: s32 = 0
	local roll: s32 = 0
	local second_roll: s32 = 0
	local side_angle: f32 = 0
	local point_angle: f32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 300.0 then
			vm.wait()
			return
		end
		monster_priority = monster.get_priority() or monster_priority
		if monster_priority > 1 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait(2.0)
				movement.move_in_direction(2.0, 2.52e-43, 200.0, 30.0, 90) -- retail: the integer 180 is passed where the callee reads a float, so it reads its bits
			else
				stand_for_frames(30)
			end
			continue
		end
		if target_distance < 300.0 and target_distance >= 80.0 then
			roll = monster.get_random(100) or roll
			if roll < 75 then
				aim_and_fire_rifle(25)
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait(5.0)
					monster.set_motion("歩き右", -1, 0)
					strafe_around_target(vm.f32(2.4), 5.0, 200.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait(5.0)
					monster.set_motion("歩き左", -1, 0)
					strafe_around_target(vm.f32(2.4), 5.0, 200.0, 30)
					monster.set_motion("立ち", -1, 0)
				end
			end
		else
			if target_distance < 75.0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait(5.0)
				perform_counter_attack()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(3)
			end
			roll = monster.get_random(100) or roll
			if roll < 20 then
				monster.get_target_distance()
				second_roll = monster.get_random(100) or second_roll
				if second_roll < 50 then
					side_angle = 120.0
				else
					side_angle = -120.0
				end
				point_x, point_y, point_z = movement.get_point_around_target(side_angle, 200.0, point_x, point_y, point_z)
				point_angle = monster.get_angle_to_position(point_x, point_y, point_z) or point_angle
				monster.set_rotation(0.0, point_angle, 0.0)
				monster.set_motion("走り")
				monster.move_toward_position(point_x, point_y - 20.0, point_z, 6.4, 6.4)
				movement.wait_until_move_finished_without_stopping(60)
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait(6.0)
				retreat_from_target(vm.f32(3.8400002))
				monster.set_motion("立ち", -1, 0)
				aim_and_fire_rifle(15)
			end
		end
		vm.wait()
	end
end

local script = {}

--- Runs when the script is loaded.
function script.setup() end

--- Registers the monster's hit reactions, loads its effect scripts and sets up variables.
function script.init()
	local texture_block: s32 = 0
	local bullet_effect_loaded: s32 = 0
	local muzzle_flash_loaded: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 5.0, "避け攻撃", 0.4, 0.7, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 7.0, "避け攻撃", 0.4, 0.7, 1)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		bullet_effect_loaded = monster.load_effect_script("fox_銃弾", texture_block) or bullet_effect_loaded
		muzzle_flash_loaded = monster.load_effect_script("マズルフラッシュ", texture_block) or muzzle_flash_loaded
		if (if bullet_effect_loaded ~= 0 then 1 else muzzle_flash_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	apply_clip_distance()
end

--- Chooses between engaged combat and idle wandering depending on rage hits and target distance.
function script.loop()
	local target_distance: f32 = 0
	local rage_hits_left: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			behavior.try_face_transformed_player_plain_speed_3()
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 300.0 then
				fight_with_rage_hits_left()
			else
				wander_near_spawn()
			end
		else
			fight_without_rage_hits_left()
		end
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
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers back, usually counting a hit, otherwise retreating and firing.
function script.on_damage()
	local roll: s32 = 0
	local hit_count: s32 = 0
	state.stop_and_clear_action()
	roll = monster.get_random(100) or roll
	if roll < 95 then
		monster.set_motion("ダメージ", -1, 6)
		monster.start_knockback(4.0, 0.0, 3)
		motion.wait_until_finished()
		timer.wait_frames(16)
		hit_count = monster.get_variable(1) or hit_count
		hit_count = vm.i32(hit_count + 1)
		monster.set_variable(1, hit_count)
	else
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_toward_target_and_wait(5.0)
		retreat_from_target(vm.f32(3.8400002))
		aim_and_fire_rifle(5)
	end
	monster.set_motion("立ち", -1, 0)
	state.do_nothing()
end

--- Gets knocked down and stands back up.
function script.on_knockdown()
	state.lock_and_face_target()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(15)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	monster.set_variable(0, 1)
	state.unlock_and_clear_action()
end

--- Guards against a hit, sometimes dodging and counter attacking first.
function script.on_guard()
	local target_distance: f32 = 0
	local roll: s32 = 0
	state.lock_and_stop_moving()
	target_distance = monster.get_target_distance() or target_distance
	if target_distance > 80.0 then
		roll = monster.get_random(100) or roll
		if roll < 5 then
			monster.set_monster_attributes(32, 1)
			monster.set_mask_flags(2, 1)
			monster.set_motion("避けin", -1, 2)
			timer.wait_frames(calc.pass_through(10))
			monster.set_monster_attributes(32, 0)
			monster.set_mask_flags(2, 0)
			movement.face_target_instantly()
			vm.wait()
			motion.wait_until_finished()
			monster.set_motion("避け攻撃", -1, 6)
			motion.wait_until_finished()
		end
	end
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	motion.wait_until_finished()
	timer.wait_frames(8)
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges and counter attacks or recovers.
function script.on_dodge_1()
	local roll: s32 = 0
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_monster_attributes(32, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("避けin", -1, 2)
	timer.wait_frames(calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	movement.face_target_instantly()
	vm.wait()
	motion.wait_until_finished()
	roll = monster.get_random(100) or roll
	if roll > 5 then
		monster.set_motion("避け攻撃", -1, 6)
		motion.wait_until_finished()
	else
		monster.set_motion("避け戻り", -1, 6)
		motion.wait_until_finished()
	end
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Dodges and recovers without attacking.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_monster_attributes(32, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("避けin", -1, 2)
	timer.wait_frames(calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	movement.face_target_instantly()
	vm.wait()
	motion.wait_until_finished()
	monster.set_motion("避け戻り", -1, 6)
	motion.wait_until_finished()
	monster.set_mask_flags(2, 0)
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
		vm.wait()
	end
end

--- Stands up after being thrown.
function script.on_land()
	combat.finish_throw_delayed()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	state.do_nothing_hook()
	return 1
end

--- Is knocked down and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
