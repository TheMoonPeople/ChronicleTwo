--!strict
--- Drives the Ram family: a horned monster that butts and charges at the target.

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

--- Sets the guard threshold, secondary parameters and clip distance shared by this monster's variants.
local function set_default_parameters()
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

--- Hovers near the target at a random offset or waits for it to face the monster while another monster holds the attack priority.
local function wait_for_turn()
	local roll: s32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		offset_angle = monster.get_random_whole_number(30.0) or offset_angle
		offset_distance = monster.get_random_whole_number(30.0) or offset_distance
		offset_distance = vm.f32(offset_distance + 90.0)
		if roll < 50 then
			offset_angle = vm.f32(-offset_angle - 30.0)
		else
			offset_angle = vm.f32(offset_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(1.45), 3.0, offset_angle, offset_distance, 49.0, 30)
		movement.turn_toward_target_and_wait_guarded(3.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(49.0, 45.0, 30)
	end
end

--- Turns to the target, winds up and charges at it before recovering.
local function perform_charge(unused_speed: any, unused_frames: any)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("攻撃２in", 6)
	timer.wait_frames(calc.pass_through(25))
	monster.set_motion("攻撃２", -1, 0)
	movement.chase_target_guarded(7.0, 7.0, 24.5, 120)
	monster.set_motion("攻撃２out", 6)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Picks a far-range action: chasing, waiting, circling the target or charging.
local function act_at_far_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(vm.f32(1.45), 3.0, 49.0, 90)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(49.0, 45.0, 75)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				side_angle = -30.0
			else
				side_angle = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.45), 3.0, side_angle, target_distance, 90.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(49.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		perform_charge(6.0, 45)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Picks a mid-range action: charging, chasing or circling the target.
local function act_at_mid_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 70 then
		perform_charge(6.0, 25)
	else
		roll = monster.get_random(100) or roll
		if roll < 70 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(vm.f32(1.45), 3.0, 49.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				side_angle = -30.0
			else
				side_angle = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.45), 3.0, side_angle, target_distance, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(49.0, 45.0, 30)
		end
	end
end

--- Turns to the target and plays the first attack while tracking it.
local function perform_attack_1()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(6.0)
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target_guarded(3.0, calc.pass_through(17))
	timer.wait_frames(calc.pass_through(31))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Steps away from the target by a randomised distance at the given speed.
local function step_backward(move_speed: f32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local retreat_distance: f32 = 0
	local random_extra: f32 = 0
	local current_y: f32 = 0
	monster.set_motion("歩き", -1, 4)
	movement.turn_toward_target_and_wait_guarded(30.0)
	monster.set_monster_attributes(32, 1)
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		point_x = out1 or point_x
		point_z = out3 or point_z
	end
	random_extra = monster.get_random_whole_number(10.0) or random_extra
	retreat_distance = vm.f32(retreat_distance + vm.f32(40.0 + random_extra))
	point_x, point_y, point_z = movement.get_approach_point(0.0, retreat_distance, point_x, point_y, point_z)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames(calc.pass_through(8))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(point_x, current_y, point_z, move_speed, move_speed + 1.0)
	timer.wait_frames(calc.pass_through(9))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	timer.wait_frames(calc.pass_through(19))
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Picks a close-range action: an attack, a charge, a backward step or a flanking walk.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		target_distance = monster.get_target_distance() or target_distance
		roll = monster.get_random(100) or roll
		if target_distance < 50.0 then
			perform_attack_1()
		else
			perform_charge(6.0, 25)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			step_backward(3.0)
		else
			roll = monster.get_random(100) or roll
			side_angle = monster.get_random_whole_number(60.0) or side_angle
			if roll < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.45), 3.0, side_angle, 98.0, 1.0, 30)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(9)
		end
	end
end

--- Fights the target by distance until it leaves range or the rage counter runs out.
local function fight_target_cautiously()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 240.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			wait_for_turn()
			continue
		end
		if target_distance < 240.0 and target_distance >= 150.0 then
			act_at_far_range()
		elseif target_distance < 150.0 and target_distance >= 90.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Roams around the placement position by circling it, wandering or waiting for the target to threaten.
local function roam()
	local roll: s32 = 0
	local result: s32 = 0
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
	local circle_angle: f32 = 0
	local turn_after_walk: f32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	local target_distance: f32 = 0
	local turn_after_approach: f32 = 0
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
	if clear_distance < 49.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 49.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.0, vm.f32(1.45), turn_angle, clear_distance, 49.0, 30)
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
				circle_angle = monster.get_random_whole_number(360.0) or circle_angle
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					circle_angle = vm.f32(-circle_angle - 30.0)
				else
					circle_angle = vm.f32(circle_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, vm.f32(1.45), 3.0, distance, circle_angle, 49.0, 60)
				turn_after_walk = monster.get_random_whole_number(180.0) or turn_after_walk
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_after_walk = vm.f32(turn_after_walk * -1.0)
				end
				movement.turn_to_angle_and_wait(turn_after_walk, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
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
					offset_angle = monster.get_random_whole_number(180.0) or offset_angle
					offset_distance = monster.get_random_whole_number(30.0) or offset_distance
					target_distance = monster.get_target_distance() or target_distance
					offset_distance = vm.f32(offset_distance + target_distance)
					if roll < 50 then
						offset_angle = vm.f32(offset_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						offset_angle = vm.f32(-offset_angle - 30.0)
					else
						offset_angle = vm.f32(offset_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					result = movement.walk_to_point_near_target(vm.f32(1.45), 3.0, offset_angle, offset_distance, 49.0, 60)
					turn_after_approach = monster.get_random_whole_number(360.0) or turn_after_approach
					roll = monster.get_random(100) or roll
					if roll < 50 then
						turn_after_approach = vm.f32(turn_after_approach * -1.0)
					end
					movement.turn_to_angle_and_wait(turn_after_approach, 3.0)
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
					movement.move_in_direction_guarded(vm.f32(1.45), turn_angle, 1000.0, 49.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.45), 3.0, distance, 360.0, 40.0, 49.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Turns to the target, winds up while tracking it and charges at it before recovering.
local function perform_tracking_charge()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("攻撃２in", 6)
	movement.track_target_guarded(3.0, 25)
	monster.set_motion("攻撃２", 0)
	movement.chase_target_guarded(vm.f32(6.8999996), 3.0, 24.5, 120)
	monster.set_motion("攻撃２out", 6)
	timer.wait_frames(calc.pass_through(28))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Fights the target aggressively once the rage counter has run out.
local function fight_target_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	local side_angle: f32 = 0
	monster.get_life_int()
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			wait_for_turn()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 90.0 then
			if target_distance < 75.0 then
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(vm.f32(1.45), 3.0, 49.0, 90)
				perform_attack_1()
			else
				perform_charge(vm.f32(4.8), 15)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 70 then
				perform_charge(vm.f32(4.8), 15)
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(vm.f32(1.7400001), 3.0, 49.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					roll = monster.get_random(100) or roll
					if roll < 50 then
						side_angle = -30.0
					else
						side_angle = 30.0
					end
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(3.0)
					monster.set_motion("歩き", -1, 0)
					movement.walk_to_point_near_target(vm.f32(1.7400001), 3.0, side_angle, target_distance, 1.0, 45)
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(3.0)
					monster.set_motion("立ち", -1, 0)
					sense.wait_until_target_in_front(49.0, 45.0, 30)
				end
			end
		end
	end
end

--- Chooses between fighting, roaming and chasing from the target distance, the guard state and the rage counter.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 240.0 then
				fight_target_cautiously()
			else
				roam()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 150.0 then
					reaction.set_guard_active(0)
					fight_target_cautiously()
				else
					perform_tracking_charge()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_target_enraged()
	end
end

--- Steps to one side of the target at the given speed, keeping it in front.
local function sidestep_around_target(move_speed: f32)
	local roll: s32 = 0
	local target_x: f32 = 0
	local point_y: f32 = 0
	local target_z: f32 = 0
	local position_y: f32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	monster.set_motion("歩き", -1, 4)
	movement.turn_toward_target_and_wait_guarded(30.0)
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		side_angle = 30.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		side_angle = -30.0
	end
	target_x, point_y, target_z = movement.get_approach_point(side_angle, target_distance, target_x, point_y, target_z)
	sense.wait_until_target_in_front(49.0, 45.0, calc.pass_through(10))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	monster.move_toward_position(target_x, position_y - 10.0, target_z, move_speed, move_speed)
	monster.set_monster_attributes(32, 1)
	sense.wait_until_target_in_front(49.0, 45.0, calc.pass_through(6))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
end

local script = {}

--- Runs once when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the monster's attack hits and applies its default parameters when it is placed.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("通常攻撃", 6.0, "攻撃１", 0.364, 0.45, 0)
	monster.register_damage_hit("吹っ飛び弱", 6.0, "攻撃２", 0.0, 0.5, 1)
	monster.register_damage_hit("吹っ飛び弱", 6.0, "攻撃２", 0.5, 1.0, 1)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("攻撃２", 0.0, 1.0, 1002)
	end
	set_default_parameters()
end

--- Runs the monster's main behaviour loop.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
end

--- Holds the monster in its damage pose until its status ailment ends.
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

--- Staggers the monster back and recovers when it takes a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Knocks the monster down, then lets it get back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Plays the guard motions when the monster blocks a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges the first kind of attack by stepping backward.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	step_backward(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the second kind of attack by sidestepping around the target.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	sidestep_around_target(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the monster's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles in place while the monster is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Gets the monster back up after it has been thrown and lands.
function script.on_land()
	reaction.recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	state.do_nothing_hook()
	return 1
end

--- Knocks the monster over and holds it until the stun ends.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
