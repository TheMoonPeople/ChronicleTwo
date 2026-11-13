--!strict
--- Controls the Diamond monster family, a card enemy that lunges at the target.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard, clip distance and secondary-variable defaults for the monster.
local function setup_defaults()
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

--- Circles the target at a random angle or waits for it to enter the front cone.
local function strafe_or_stand()
	local random_value: s32 = 0
	local side_angle: f32 = 0
	local orbit_distance: f32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		random_value = monster.get_random(100) or random_value
		side_angle = monster.get_random_whole_number(30.0) or side_angle
		orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
		orbit_distance = vm.f32(orbit_distance + 90.0)
		if random_value < 50 then
			side_angle = vm.f32(-side_angle - 30.0)
		else
			side_angle = vm.f32(side_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(1.65), vm.f32(4.2), side_angle, orbit_distance, 44.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(44.0, 45.0, 30)
	end
end

--- Closes the distance to the target by running, walking or waiting when it is far away.
local function approach_from_far()
	local random_value: s32 = 0
	monster.get_target_distance()
	random_value = monster.get_random(100) or random_value
	if random_value < 70 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("走り", -1, 0)
		movement.chase_target_guarded(vm.f32(3.4), vm.f32(4.2), 90.0, 75)
		monster.set_motion("立ち", -1, 0)
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 25 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(vm.f32(1.65), vm.f32(4.2), 90.0, 75)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(44.0, 45.0, 75)
		end
	end
end

--- Turns to the target, tracks it briefly and lunges to where it stood at the given speed.
local function lunge_at_target(lunge_speed: f32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(8.4))
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target_guarded(vm.f32(4.2), calc.pass_through(25))
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.move_toward_position(target_x, target_y, target_z, lunge_speed, lunge_speed)
	timer.wait_frames_with_guard_update(calc.pass_through(7))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks an attack, approach or sidestep when the target is at middle range.
local function act_at_mid_range()
	local random_value: s32 = 0
	local side_angle: f32 = 0
	monster.get_target_distance()
	random_value = monster.get_random(100) or random_value
	if random_value < 70 then
		random_value = monster.get_random(100) or random_value
		if random_value < 80 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			lunge_at_target(vm.f32(4.0800004))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(vm.f32(3.4), vm.f32(4.2), 44.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 70 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(vm.f32(1.65), vm.f32(4.2), 44.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			random_value = monster.get_random(100) or random_value
			if random_value < 45 then
			else
				random_value = monster.get_random(100) or random_value
				side_angle = monster.get_random_whole_number(60.0) or side_angle
				if random_value < 50 then
					side_angle = vm.f32(-side_angle - 30.0)
				else
					side_angle = vm.f32(side_angle + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.walk_to_point_near_target(vm.f32(1.65), vm.f32(4.2), side_angle, 88.0, 1.0, 30)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(9)
			end
		end
	end
end

--- Picks an attack, sidestep or backstep when the target is close.
local function act_at_close_range()
	local random_value: s32 = 0
	local side_angle: f32 = 0
	monster.get_life()
	random_value = monster.get_random(100) or random_value
	if random_value < 78 then
		lunge_at_target(vm.f32(3.4))
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			random_value = monster.get_random(100) or random_value
			side_angle = monster.get_random_whole_number(60.0) or side_angle
			if random_value < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.65), vm.f32(4.2), side_angle, 88.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			reaction.dodge_backward_fast()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Fights the target while it stays in range and rage hits remain, choosing behaviour by distance.
local function fight_while_rage_remaining()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		reaction.watch_transformation_walking()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 230.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left <= 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			strafe_or_stand()
			continue
		end
		if target_distance < 230.0 and target_distance >= 135.0 then
			approach_from_far()
		elseif target_distance < 135.0 and target_distance >= 90.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Wanders around its home position by orbiting, turning, walking or waiting for the target.
local function wander_near_home()
	local random_value: s32 = 0
	local wait_result: s32 = 0
	local unset_mode: s32 = 0
	local home_distance: f32 = 0
	local heading: f32 = 0
	local home_position_x: f32 = 0
	local home_position_y: f32 = 0
	local home_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle: f32 = 0
	local final_turn_angle: f32 = 0
	local target_orbit_angle: f32 = 0
	local target_orbit_radius: f32 = 0
	local target_distance: f32 = 0
	local target_final_turn_angle: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		home_position_x = out1 or home_position_x
		home_position_y = out2 or home_position_y
		home_position_z = out3 or home_position_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	home_distance = monster.get_distance_between(position_x, position_y, position_z, home_position_x, home_position_y, home_position_z) or home_distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 44.0 then
		heading = monster.get_random_whole_number(360.0) or heading
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(heading, vm.f32(4.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 44.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.2), vm.f32(1.65), heading, clear_distance, 44.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if home_distance > 300.0 then
		random_value = monster.get_random(100) or random_value
		if random_value < 90 then
			if home_distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				monster.set_place_position(position_x, position_y, position_z)
			end
			random_value = monster.get_random(100) or random_value
			if random_value < 30 then
				monster.set_variable(0, 4)
				random_value = monster.get_random(100) or random_value
				orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if random_value < 50 then
					orbit_angle = vm.f32(-orbit_angle - 30.0)
				else
					orbit_angle = vm.f32(orbit_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(home_position_x, home_position_y, home_position_z, vm.f32(1.65), vm.f32(4.2), home_distance, orbit_angle, 44.0, 60)
				final_turn_angle = monster.get_random_whole_number(180.0) or final_turn_angle
				random_value = monster.get_random(100) or random_value
				if random_value < 50 then
					final_turn_angle = vm.f32(final_turn_angle * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_angle, vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, random_value)
			return
		end
	end
	random_value = monster.get_random(100) or random_value
	if random_value < 75 then
		random_value = monster.get_random(100) or random_value
		if random_value < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			heading = monster.get_random_whole_number(180.0) or heading
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				heading = vm.f32(heading * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(heading, vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				random_value = monster.get_random(100) or random_value
				if random_value < 50 then
					monster.set_variable(0, 4)
					random_value = monster.get_random(100) or random_value
					target_orbit_angle = monster.get_random_whole_number(180.0) or target_orbit_angle
					target_orbit_radius = monster.get_random_whole_number(30.0) or target_orbit_radius
					target_distance = monster.get_target_distance() or target_distance
					target_orbit_radius = vm.f32(target_orbit_radius + target_distance)
					if random_value < 50 then
						target_orbit_angle = vm.f32(target_orbit_angle * -1.0)
					end
					random_value = monster.get_random(100) or random_value
					if random_value < 50 then
						target_orbit_angle = vm.f32(-target_orbit_angle - 30.0)
					else
						target_orbit_angle = vm.f32(target_orbit_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(vm.f32(1.65), vm.f32(4.2), target_orbit_angle, target_orbit_radius, 44.0, 60)
					target_final_turn_angle = monster.get_random_whole_number(360.0) or target_final_turn_angle
					random_value = monster.get_random(100) or random_value
					if random_value < 50 then
						target_final_turn_angle = vm.f32(target_final_turn_angle * -1.0)
					end
					movement.turn_to_angle_and_wait(target_final_turn_angle, vm.f32(4.2))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					heading = calc.radians_to_degrees(rotation_y)
					if heading > vm.f32(3.1415927) then
						heading = vm.f32(heading - vm.f32(6.2831855))
					end
					if heading <= vm.f32(-3.1415927) then
						heading = vm.f32(heading + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(vm.f32(1.65), heading, 1000.0, 44.0, 60)
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
		elseif unset_mode == 8 then
			monster.set_variable(0, 1)
			random_value = monster.get_random(120) or random_value
			home_distance = monster.get_target_distance() or home_distance
			random_value = vm.i32(random_value + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.65), vm.f32(4.2), home_distance, 360.0, 40.0, 44.0, random_value)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs toward the target for up to 120 frames and then stands.
local function run_toward_target()
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(vm.f32(3.4), vm.f32(4.2), 44.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Fights the target once no rage hits remain, attacking when close and chasing otherwise.
local function fight_without_rage()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local random_value: s32 = 0
	local rage_hits_left: s32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			strafe_or_stand()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 90.0 then
			random_value = monster.get_random(100) or random_value
			if random_value < 80 then
				lunge_at_target(vm.f32(4.0800004))
			else
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(vm.f32(1.65), vm.f32(4.2), 44.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			random_value = monster.get_random(100) or random_value
			if random_value < 40 then
				lunge_at_target(vm.f32(4.76))
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(vm.f32(3.4), vm.f32(4.2), 44.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Chooses between fighting, wandering and guard-breaking behaviour from the target distance and guard state.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_range: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		reaction.watch_transformation_walking()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 230.0 then
				fight_while_rage_remaining()
			else
				wander_near_home()
			end
		else
			guard_range = state.get_secondary_float(guard_range)
			if target_distance < guard_range then
				if target_distance < 90.0 then
					reaction.set_guard_active(0)
					fight_while_rage_remaining()
				else
					run_toward_target()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage()
	end
end

--- Steps to the left or right and slides sideways while keeping the target in view.
local function sidestep_dodge()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local step_distance: f32 = 0
	local random_value: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		monster.set_motion("ステップ左", -1, 6)
		rotation_y = vm.f32(rotation_y + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 6)
		rotation_y = vm.f32(rotation_y - vm.f32(1.5707964))
	end
	step_distance = 100.0
	target_x = vm.f32(position_x + vm.f32(vm.sin(rotation_y) * step_distance))
	target_y = vm.f32(position_y - 20.0)
	target_z = vm.f32(position_z + vm.f32(vm.cos(rotation_y) * step_distance))
	sense.wait_until_target_in_front(44.0, 45.0, calc.pass_through(6))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target_x, target_y, target_z, 4.0800004, 4.0800004)
	sense.wait_until_target_in_front(44.0, 45.0, calc.pass_through(4))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the monster's attack hits and loads its resources when it is placed.
function script.init()
	monster.register_damage_hit("吹っ飛び弱", 5.0, "攻撃１", 0.486, 0.583, 0)
	monster.set_variable(0, 0)
	setup_defaults()
end

--- Runs the monster's normal behaviour each frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
end

--- Stands staggered while a status ailment lasts after being hit.
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

--- Reacts to a hit that staggers the monster.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Reacts to a hit that knocks the monster over and gets it back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	monster.set_action_status(1)
	timer.wait_frames_with_guard_update(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(21.0)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(12)
	monster.set_invulnerable_time(18)
	timer.wait_frames_with_guard_update(18)
	monster.set_invulnerable_time(0)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges the target's first kind of attack.
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
	reaction.dodge_backward_fast()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the target's second kind of attack.
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
	sidestep_dodge()
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

--- Struggles while caught by a frame that lifts it.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
	timer.wait_forever_guarded()
end

--- Gets the monster back up after it has been thrown and lands.
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

--- Knocks the monster down and keeps it stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_invulnerable_time(0)
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
