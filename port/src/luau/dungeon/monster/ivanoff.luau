--!strict
--- Controls the Ivanoff family of rock monsters, which swing, roll-charge and circle the player and fight more aggressively once their rage hits are spent.

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

--- Turns toward the target, then chases it while swinging an arm and recovers.
local function walk_up_and_swing()
	local frames_remaining: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(4.5)
	monster.set_motion("攻撃２", -1, 6)
	frames_remaining = movement.chase_target_guarded(vm.f32(6.2), 3.0, 0.0, calc.pass_through(20))
	timer.wait_frames_with_guard_update(calc.pass_through(vm.i32(20 - frames_remaining)))
	timer.wait_frames_with_guard_update(calc.pass_through(20))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Plays an idle taunt until the target stands in front, then swings at it.
local function play_then_swing_if_target_in_front()
	local target_in_front: s32 = 0
	monster.set_motion("遊び", -1, 6)
	target_in_front = sense.wait_until_target_in_front(45.0, 45.0, calc.pass_through(125))
	if target_in_front == 1 then
		walk_up_and_swing()
	end
	monster.set_motion("立ち", -1, 4)
end

--- Randomly strafes around the target, stands still or plays the idle taunt while waiting for an opening.
local function idle_or_strafe()
	local roll: s32 = 0
	local strafe_degrees: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_degrees = -30.0
				monster.set_motion("歩き左", -1, 0)
			else
				strafe_degrees = 30.0
				monster.set_motion("歩き右", -1, 0)
			end
			movement.move_to_point_around_target_keeping_facing(vm.f32(2.2), strafe_degrees, 3.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(45.0, 45.0, 30)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(45.0, 45.0, 30)
		end
	else
		play_then_swing_if_target_in_front()
	end
end

--- Walks forward, backward, left or right relative to the current facing for a limited distance and time.
local function walk_relative_to_facing(speed: f32, max_distance: f32, stop_distance: f32, timeout_frames: s32, direction: s32)
	local facing_radians: f32 = 0
	local move_radians: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	if direction == 0 then
		monster.set_motion("歩き", -1, 0)
		move_radians = facing_radians
	end
	if direction == 1 then
		monster.set_motion("歩き後", -1, 0)
		move_radians = vm.f32(facing_radians + vm.f32(3.1415927))
	end
	if direction == 2 then
		monster.set_motion("歩き左", -1, 0)
		move_radians = vm.f32(facing_radians - vm.f32(1.5707964))
	end
	if direction == 3 then
		monster.set_motion("歩き右", -1, 0)
		move_radians = vm.f32(facing_radians + vm.f32(1.5707964))
	end
	if move_radians > vm.f32(3.1415927) then
		move_radians = vm.f32(move_radians - vm.f32(6.2831855))
	end
	if move_radians <= vm.f32(-3.1415927) then
		move_radians = vm.f32(move_radians + vm.f32(6.2831855))
	end
	movement.move_in_direction_guarded(speed, calc.radians_to_degrees(move_radians), max_distance, stop_distance, timeout_frames)
	monster.set_motion("立ち", -1, 0)
end

--- Winds up, then rolls forward at the target at the given speed for a distance scaled by the multiplier and recovers.
local function roll_charge(speed: f32, distance_scale: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local facing_radians: f32 = 0
	local heading_radians: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(6.0)
	monster.set_motion("攻撃１in", -1, 2)
	motion.wait_until_finished_guarded()
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	heading_radians = facing_radians
	if heading_radians > vm.f32(3.1415927) then
		heading_radians = vm.f32(heading_radians - vm.f32(6.2831855))
	end
	if heading_radians <= vm.f32(-3.1415927) then
		heading_radians = vm.f32(heading_radians + vm.f32(6.2831855))
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.f32(distance_scale * 150.0) * vm.sin(heading_radians)))
	destination_y = vm.f32(destination_y - 20.0)
	destination_z = vm.f32(destination_z + vm.f32(vm.f32(distance_scale * 150.0) * vm.cos(heading_radians)))
	monster.move_toward_position(destination_x, destination_y, destination_z, speed, speed)
	monster.set_motion("攻撃１", -1, 4)
	timer.wait_frames_with_guard_update(vm.i32(vm.i32(16 * distance_scale) * 2))
	monster.stop_moving()
	monster.set_motion("攻撃１out", -1, 6)
	monster.move_toward_position(destination_x, destination_y, destination_z, speed * vm.f32(0.8), speed * vm.f32(0.8))
	timer.wait_frames_with_guard_update(calc.pass_through(7))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Chooses a long-range action: sidestep, wait, taunt, circle the target or roll-charge.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local circle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			roll = monster.get_random(100) or roll
			if roll < 70 then
				walk_relative_to_facing(vm.f32(2.2), 200.0, 45.0, 45, 0)
			else
				roll = monster.get_random(100) or roll
				if roll < 70 then
					monster.set_motion("立ち", -1, 0)
					sense.wait_until_target_in_front(45.0, 45.0, 75)
				else
					play_then_swing_if_target_in_front()
				end
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				circle_degrees = -30.0
			else
				circle_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(2.2), 3.0, circle_degrees, target_distance, 100.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(45.0, 45.0, 30)
		end
	else
		roll_charge(vm.f32(8.059999), 3)
	end
end

--- Chooses a medium-range action: roll-charge, wait, taunt, sidestep or circle the target.
local function act_at_medium_range()
	local roll: s32 = 0
	local circle_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 60 then
		roll_charge(vm.f32(9.299999), 3)
	else
		roll = monster.get_random(100) or roll
		if roll < 25 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(45.0, 45.0, 30)
			else
				play_then_swing_if_target_in_front()
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 70 then
				walk_relative_to_facing(vm.f32(2.2), 200.0, 100.0, 45, 0)
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(3.0)
				roll = monster.get_random(100) or roll
				if roll < 50 then
					circle_degrees = -30.0
					monster.set_motion("歩き左", -1, 0)
				else
					circle_degrees = 30.0
					monster.set_motion("歩き右", -1, 0)
				end
				movement.move_to_point_around_target_keeping_facing(vm.f32(2.2), circle_degrees, 3.0, 45)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(3.0)
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(45.0, 45.0, 30)
			end
		end
	end
end

--- Chooses a close-range action: swing, roll-charge, sidestep or circle the target.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local circle_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 60 then
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 60.0 then
			walk_up_and_swing()
		else
			roll_charge(vm.f32(6.2), 3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			roll = monster.get_random(2) or roll
			walk_relative_to_facing(vm.f32(2.2), 100.0, 45.0, 60, vm.i32(roll + 1))
		else
			roll = monster.get_random(100) or roll
			circle_degrees = monster.get_random_whole_number(60.0) or circle_degrees
			if roll < 50 then
				circle_degrees = vm.f32(-circle_degrees - 30.0)
				monster.set_motion("歩き左", -1, 0)
			else
				circle_degrees = vm.f32(circle_degrees + 30.0)
				monster.set_motion("歩き右", -1, 0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.move_to_point_around_target_keeping_facing(vm.f32(2.2), circle_degrees, 3.0, 30)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Repeatedly picks an attack by target distance while rage hits remain and the target is near.
local function engage_target_with_rage()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 290.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			idle_or_strafe()
			continue
		end
		if target_distance < 290.0 and target_distance >= 180.0 then
			act_at_long_range()
		elseif target_distance < 180.0 and target_distance >= 100.0 then
			act_at_medium_range()
		else
			act_at_close_range()
		end
	end
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
	local orbit_degrees: f32 = 0
	local after_orbit_turn_degrees: f32 = 0
	local approach_degrees: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
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
	if clear_distance < 45.0 then
		turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_degrees, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 45.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.0, vm.f32(1.65), turn_degrees, clear_distance, 45.0, 30)
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
				orbit_degrees = monster.get_random_whole_number(360.0) or orbit_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					orbit_degrees = vm.f32(-orbit_degrees - 30.0)
				else
					orbit_degrees = vm.f32(orbit_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(home_x, home_y, home_z, vm.f32(1.65), 3.0, distance, orbit_degrees, 45.0, 60)
				after_orbit_turn_degrees = monster.get_random_whole_number(180.0) or after_orbit_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					after_orbit_turn_degrees = vm.f32(after_orbit_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(after_orbit_turn_degrees, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				target_threatening = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if target_threatening == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 85 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_degrees = vm.f32(turn_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_degrees, 3.0)
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
					monster.set_motion("歩き", -1.0, 0)
					target_threatening = movement.walk_to_point_near_target(vm.f32(1.65), 3.0, approach_degrees, approach_distance, 45.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_degrees, 3.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
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
					movement.move_in_direction_guarded(vm.f32(1.65), turn_degrees, 1000.0, 45.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				target_threatening = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if target_threatening == 1 then
					return
				end
			end
		elseif unused_mode == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.65), 3.0, distance, 360.0, 40.0, 45.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Loops the aggressive behaviour used once the rage counter is spent, charging and chasing the target.
local function fight_without_rage()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	monster.get_life_int()
	while true do
		reaction.update_and_wait_frame()
		priority = monster.get_priority() or priority
		if priority > 4 then
			idle_or_strafe()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 100.0 then
			roll = monster.get_random(100) or roll
			if roll < 90 then
				if target_distance > 60.0 then
					roll_charge(vm.f32(11.159999), 3)
				else
					walk_up_and_swing()
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(vm.f32(2.64), 3.0, 45.0, 90)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 30 then
				roll_charge(vm.f32(12.4), 4)
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(vm.f32(2.64), 3.0, 45.0, 90)
					monster.set_motion("立ち", -1, 0)
				else
					roll = monster.get_random(3) or roll
					walk_relative_to_facing(vm.f32(2.2), 100.0, 45.0, 60, vm.i32(roll + 1))
				end
			end
		end
	end
end

--- Picks between engaging, roaming and guarding depending on rage, guard state and target distance.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	local roll: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 290.0 then
				engage_target_with_rage()
			else
				roam_when_idle()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 180.0 then
					reaction.set_guard_active(0)
					engage_target_with_rage()
				else
					roll = monster.get_random(100) or roll
					if roll < 50 then
						monster.set_motion("歩き", -1, 0)
						movement.turn_toward_target_and_wait_guarded(4.5)
						roll_charge(vm.f32(9.299999), 3)
						monster.set_motion("立ち", -1, 0)
					else
						monster.set_motion("歩き", -1, 0)
						movement.chase_target_guarded(vm.f32(2.2), 3.0, 45.0, 90)
						monster.set_motion("立ち", -1, 0)
					end
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack hit windows and applies the default behaviour settings.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 9.0, "攻撃１", 0.0, 0.5, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 9.0, "攻撃１", 0.5, 1.0, 0)
	monster.register_damage_hit("通常攻撃", 5.0, "攻撃２", 0.3, 0.85, 1)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("攻撃１", 0.0, 1.0, 1001)
	end
	initialize_behavior_settings()
end

--- Runs the monster's main behaviour each frame.
function script.loop()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
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
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the flinch reaction.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockback, lies down and gets back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	monster.set_action_status(1)
	timer.wait_frames_with_guard_update(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Stops moving while guarding.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Dodges by resetting the motion.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Dodges by resetting the motion.
function script.on_dodge_2()
	state.lock_and_reset_motion()
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

--- Recovers and stands up after being thrown.
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

--- Falls down and gets back up while stunned.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
