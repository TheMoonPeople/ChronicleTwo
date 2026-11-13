--!strict
--- Controls the Griffon Soldier, a winged soldier that runs at the target and slashes.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the monster's default guard and clip-distance settings, with unlimited clip distance for bosses.
local function apply_default_settings()
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

--- Strafes around the target at a fixed distance or idles in place while waiting for an opening.
local function keep_distance_while_waiting()
	local roll: s32 = 0
	local offset_degrees: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		offset_degrees = monster.get_random_whole_number(30.0) or offset_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 110.0)
		if roll < 50 then
			offset_degrees = vm.f32(-offset_degrees - 30.0)
		else
			offset_degrees = vm.f32(offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = movement.walk_to_point_near_target(1.75, vm.f32(4.2), offset_degrees, distance, 44.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(44.0, 45.0, 30)
	end
end

--- Randomly turns and watches the target or walks toward it from long range.
local function wait_or_approach_at_far_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", 0.45, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(110.0, 75.0, 75)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(110.0, 75.0, 30)
		end
	else
		monster.set_motion("歩き", 0.45, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("歩き", -1.0, 0)
		movement.chase_target_guarded(1.75, vm.f32(4.2), 44.0, 45)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Randomly turns and watches the target or walks toward it from mid range.
local function wait_or_approach_at_mid_range()
	local roll: s32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", 0.45, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(110.0, 75.0, 45)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(110.0, 75.0, 30)
		end
	else
		monster.set_motion("歩き", 0.45, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("歩き", -1.0, 0)
		movement.chase_target_guarded(1.75, vm.f32(4.2), 44.0, 75)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Turns to the target and lunges forward with the first attack motion.
local function perform_lunging_attack_1()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target_guarded(vm.f32(4.2), calc.pass_through(24))
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(yaw) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(yaw) * 100.0))
	monster.move_toward_position(pos_x, pos_y - 20.0, pos_z, 1.75, 1.75)
	timer.wait_frames_with_guard_update(calc.pass_through(7))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Turns to the target and lunges forward with the second attack motion.
local function perform_lunging_attack_2()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 6)
	movement.track_target_guarded(vm.f32(4.2), 12)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(yaw) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(yaw) * 100.0))
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.625, 2.625)
	timer.wait_frames_with_guard_update(calc.pass_through(17))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Turns to the target and plays the second attack motion while facing it.
local function perform_attack_2()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_facing_target_guarded(vm.f32(4.2))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Steps backward away from the target.
local function step_backward()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local backward_yaw: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	backward_yaw = vm.f32(yaw + vm.f32(3.1415927))
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(backward_yaw) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(backward_yaw) * 100.0))
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(12))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y - 20.0, pos_z, 4.2, 4.2)
	timer.wait_frames_with_guard_update(calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
end

--- Sidesteps right or left around the target while tracking it.
local function sidestep_around_target(move_right: s32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local offset_degrees: f32 = 0
	local target_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if move_right ~= 0 then
		monster.set_motion("歩き右", -1, 0)
		offset_degrees = -45.0
	else
		monster.set_motion("歩き左", -1, 0)
		offset_degrees = 45.0
	end
	if target_distance < 88.0 then
		target_distance = vm.f32(target_distance + 30.0)
	end
	approach_x, approach_y, approach_z = movement.get_approach_point(offset_degrees, target_distance, approach_x, approach_y, approach_z)
	monster.move_toward_position(approach_x, approach_y, approach_z, 1.75, 1.75)
	movement.track_target_guarded(vm.f32(4.2), 40)
	monster.stop_moving()
end

--- Picks a random charge-and-attack, step back or sidestep for a target at close range.
local function choose_close_range_move()
	local roll: s32 = 0
	local target_distance: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 70 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("走り", -1, 0)
			movement.pursue_target_guarded(vm.f32(4.2), vm.f32(4.2), 44.0, 75)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				perform_lunging_attack_1()
			else
				perform_lunging_attack_2()
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(1.75, vm.f32(4.2), 44.0, 90)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				perform_lunging_attack_1()
			else
				perform_attack_2()
			end
		end
	else
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 66.0 then
			step_backward()
		end
		roll = monster.get_random(100) or roll
		if roll < 50 then
			sidestep_around_target(1)
		else
			sidestep_around_target(0)
		end
	end
end

--- Loops choosing moves by target distance until the target leaves range or rage hits run out.
local function fight_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		reaction.watch_transformation()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 290.0 then
			reaction.update_and_wait_frame()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			keep_distance_while_waiting()
			continue
		end
		if target_distance < 290.0 and target_distance >= 170.0 then
			wait_or_approach_at_far_range()
		elseif target_distance < 170.0 and target_distance >= 110.0 then
			wait_or_approach_at_mid_range()
		else
			choose_close_range_move()
		end
	end
end

--- Idles, turns, circles or wanders near its spawn point while the target is out of combat range.
local function wander_idle()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unknown_mode: s32 = 0
	local home_distance: f32 = 0
	local turn_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local clear_distance: f32 = 0
	local orbit_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local offset_degrees: f32 = 0
	local walk_distance: f32 = 0
	local target_distance: f32 = 0
	local end_turn_degrees: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
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
		yaw = out2 or yaw
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 44.0 then
		turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
		monster.set_motion("歩き", 0.45, 0)
		movement.turn_to_angle_and_wait(turn_degrees, vm.f32(4.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 44.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.2), 1.75, turn_degrees, clear_distance, 44.0, 30)
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
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_degrees = monster.get_random_whole_number(360.0) or orbit_degrees
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if roll < 50 then
					orbit_degrees = vm.f32(-orbit_degrees - 30.0)
				else
					orbit_degrees = vm.f32(orbit_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.2), home_distance, orbit_degrees, 44.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, vm.f32(4.2))
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
	if roll < 40 then
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
			monster.set_motion("歩き", 0.45, 0)
			movement.turn_to_angle_and_wait(turn_degrees, vm.f32(4.2))
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
					offset_degrees = monster.get_random_whole_number(180.0) or offset_degrees
					walk_distance = monster.get_random_whole_number(30.0) or walk_distance
					target_distance = monster.get_target_distance() or target_distance
					walk_distance = vm.f32(walk_distance + target_distance)
					if roll < 50 then
						offset_degrees = vm.f32(offset_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						offset_degrees = vm.f32(-offset_degrees - 30.0)
					else
						offset_degrees = vm.f32(offset_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(1.75, vm.f32(4.2), offset_degrees, walk_distance, 44.0, 60)
					end_turn_degrees = monster.get_random_whole_number(360.0) or end_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						end_turn_degrees = vm.f32(end_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(end_turn_degrees, vm.f32(4.2))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						yaw = out2 or yaw
					end
					turn_degrees = calc.radians_to_degrees(yaw)
					if turn_degrees > vm.f32(3.1415927) then
						turn_degrees = vm.f32(turn_degrees - vm.f32(6.2831855))
					end
					if turn_degrees <= vm.f32(-3.1415927) then
						turn_degrees = vm.f32(turn_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(1.75, turn_degrees, 1000.0, 44.0, 60)
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
		elseif unknown_mode == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			home_distance = monster.get_target_distance() or home_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(1.75, vm.f32(4.2), home_distance, 360.0, 40.0, 44.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs after the target while the guard state is active.
local function run_after_target_while_guarded()
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(vm.f32(4.2), vm.f32(4.2), 44.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Runs at the target and attacks once its rage hits are used up.
local function fight_when_rage_exhausted()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local gekirin: s32 = 0
	local chase_distance: f32 = 0
	local attack_roll: s32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			keep_distance_while_waiting()
			continue
		end
		if target_distance < 110.0 then
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(vm.f32(4.2), vm.f32(4.2), 44.0, 90)
			chase_distance = monster.get_target_distance() or chase_distance
			if chase_distance < 110.0 then
				attack_roll = monster.get_random(100) or attack_roll
				if attack_roll < 50 then
					perform_lunging_attack_1()
				elseif chase_distance < 44.0 then
					perform_attack_2()
				else
					perform_lunging_attack_2()
				end
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(30)
			else
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(vm.f32(4.2), vm.f32(4.2), 44.0, 90)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Chooses between fighting, wandering and guard handling for each frame.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		reaction.watch_transformation()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 290.0 then
				fight_target()
			else
				wander_idle()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 170.0 then
					monster.set_monster_guard_rate(-1, 1.0)
					reaction.set_guard_active(0)
					fight_target()
				else
					monster.set_monster_guard_rate(-1, 10.0)
					run_after_target_while_guarded()
				end
			else
				monster.set_monster_guard_rate(-1, 1.0)
				reaction.set_guard_active(0)
			end
		end
	else
		fight_when_rage_exhausted()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the Griffon Soldier's attack hits and applies its default settings when it is placed.
function script.init()
	monster.register_damage_hit("Ｍ連撃２", 3.0, "攻撃１", 0.298, 0.409, 2, 3)
	monster.register_damage_hit("Ｍ連撃２", 3.0, "攻撃１", 0.502, 0.614, 0, 1)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２", 0.544, 0.583, 2, 3)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２", 0.544, 0.583, 0, 1)
	monster.set_variable(0, 0)
	apply_default_settings()
end

--- Runs the Griffon Soldier's normal combat behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		update_behavior()
	end
end

--- Holds the Griffon Soldier in its damage pose while a status ailment is active.
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
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the Griffon Soldier's stagger reaction to a normal hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Handles the Griffon Soldier being knocked down.
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

--- Handles the Griffon Soldier guarding against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(21.0)
	monster.reset_motion()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち", 0)
	state.unlock()
end

--- Faces the target's direction and steps backward to dodge.
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
	step_backward()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the Griffon Soldier's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Handles the Griffon Soldier being caught and lifted.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
	timer.wait_forever_guarded()
end

--- Recovers the Griffon Soldier after it lands from a throw.
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

--- Stuns the Griffon Soldier until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	timer.wait_frames_with_guard_update(12)
	reaction.stun_until_recovered()
end

return script
