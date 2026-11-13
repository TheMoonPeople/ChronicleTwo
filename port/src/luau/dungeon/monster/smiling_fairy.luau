--!strict
--- Drives the Smiling Fairy family of flying monsters that attack by dashing at the player.

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
		distance_offset = vm.f32(distance_offset + 80.0)
		if roll < 50 then
			side_offset = vm.f32(-side_offset - 30.0)
		else
			side_offset = vm.f32(side_offset + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(1.75, 3.0, side_offset, distance_offset, 19.0, 30)
		movement.turn_toward_target_and_wait_guarded(3.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(19.0, 45.0, 30)
	end
end

--- Dashes at the target with the second attack.
local function dash_attack(unused_distance: any)
	local chase_result: s32 = 0
	monster.set_variable(0, 2)
	monster.set_motion("攻撃２", -1, 0)
	chase_result = movement.chase_target_checking_clearance(6.0, 12.0, 19.0, 120)
	if chase_result == -1 then
		monster.play_sound(6)
	end
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Approaches, waits or dash-attacks when the target is at long range.
local function act_at_long_range()
	local roll: s32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 85 then
		roll = monster.get_random(100) or roll
		if roll < 25 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(1.75, 3.0, 80.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(19.0, 45.0, 75)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		dash_attack(90)
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(9)
	end
end

--- Dash-attacks, approaches or sidesteps when the target is at medium range.
local function act_at_medium_range()
	local roll: s32 = 0
	local side_offset: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 75 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		dash_attack(60)
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(9)
	else
		roll = monster.get_random(100) or roll
		if roll < 60 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(1.75, 3.0, 19.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 45 then
			else
				roll = monster.get_random(100) or roll
				side_offset = monster.get_random_whole_number(60.0) or side_offset
				if roll < 50 then
					side_offset = vm.f32(-side_offset - 30.0)
				else
					side_offset = vm.f32(side_offset + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.walk_to_point_near_target(1.75, 3.0, side_offset, 38.0, 1.0, 25)
				movement.turn_toward_target_and_wait_guarded(3.0)
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(9)
			end
		end
	end
end

--- Walks up to the target and performs the first attack.
local function melee_attack()
	local frames_elapsed: s32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(1.75, 3.0, 19.0, 30)
	monster.set_motion("攻撃１", -1, 2)
	frames_elapsed = movement.track_target_guarded(6.0, calc.pass_through(10))
	if frames_elapsed < calc.pass_through(17) then
		timer.wait_frames_with_guard_update(calc.pass_through(vm.i32(17 - frames_elapsed)))
	end
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Steps backwards away from the target.
local function step_back()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local back_rotation: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		back_rotation = out2 or back_rotation
	end
	back_rotation = vm.f32(back_rotation + vm.f32(3.1415927))
	position_x = vm.f32(position_x + vm.f32(100.0 * vm.sin(back_rotation)))
	position_z = vm.f32(position_z + vm.f32(100.0 * vm.cos(back_rotation)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(9))
	monster.move_toward_position(position_x, position_y, position_z, 2.6999998, 2.6999998)
	timer.wait_frames_with_guard_update(calc.pass_through(9))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Attacks, sidesteps or steps back when the target is close.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_offset: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 55.0 then
			melee_attack()
		else
			dash_attack(45)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			side_offset = monster.get_random_whole_number(60.0) or side_offset
			if roll < 50 then
				side_offset = vm.f32(-side_offset - 30.0)
			else
				side_offset = vm.f32(side_offset + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(1.75, 3.0, side_offset, 38.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			step_back()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Fights the target by distance until it moves away or the rage hits run out.
local function fight_target_nearby()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 250.0 then
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
			sidestep_or_wait()
			continue
		end
		if target_distance < 250.0 and target_distance >= 140.0 then
			act_at_long_range()
		elseif target_distance < 140.0 and target_distance >= 80.0 then
			act_at_medium_range()
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
	if clear_distance < 19.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 19.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.0, 1.75, turn_angle, clear_distance, 19.0, 30)
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
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, 1.75, 3.0, distance, orbit_angle, 19.0, 60)
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
					wait_result = movement.walk_to_point_near_target(1.75, 3.0, approach_angle, approach_distance, 19.0, 60)
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
					movement.move_in_direction_guarded(1.75, turn_angle, 1000.0, 19.0, 60)
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
			movement.wander(1.75, 3.0, distance, 360.0, 40.0, 19.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Dashes at the target and then walks after it when the monster has noticed it.
local function rush_target_when_alerted()
	local chase_result: s32 = 0
	monster.set_motion("攻撃２", -1, 0)
	chase_result = movement.chase_target_checking_clearance(6.0, 12.0, 19.0, 120)
	if chase_result == -2 then
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(1.75, 6.0, 19.0, 30)
		monster.set_motion("立ち", -1, 0)
	end
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Fights the target aggressively while no rage hits remain.
local function fight_when_rage_hits_exhausted()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
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
			sidestep_or_wait()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 80.0 then
			if target_distance < 40.0 then
				melee_attack()
			else
				dash_attack(90)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 80 then
				dash_attack(120)
			else
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(1.75, 6.0, 19.0, 30)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Chooses between fighting, wandering and alert behaviour from the rage hits and guard state.
local function choose_behavior()
	local target_distance: f32 = 0
	local alert_range: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 250.0 then
				fight_target_nearby()
			else
				wander_when_idle()
			end
		else
			alert_range = state.get_secondary_float(alert_range)
			if target_distance < alert_range then
				if target_distance < 80.0 then
					reaction.set_guard_active(0)
					fight_target_nearby()
				else
					rush_target_when_alerted()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_when_rage_hits_exhausted()
	end
end

--- Steps quickly to the left or right.
local function sidestep()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local sidestep_rotation: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local sidestep_distance: f32 = 0
	local roll: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		sidestep_rotation = out2 or sidestep_rotation
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ右", -1, 6)
		sidestep_rotation = vm.f32(sidestep_rotation + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ左", -1, 6)
		sidestep_rotation = vm.f32(sidestep_rotation - vm.f32(1.5707964))
	end
	sidestep_distance = 100.0
	destination_x = vm.f32(position_x + vm.f32(vm.sin(sidestep_rotation) * sidestep_distance))
	destination_y = vm.f32(position_y - 20.0)
	destination_z = vm.f32(position_z + vm.f32(vm.cos(sidestep_rotation) * sidestep_distance))
	sense.wait_until_target_in_front(19.0, 45.0, calc.pass_through(8))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(destination_x, destination_y, destination_z, 3.6000001, 3.6000001)
	sense.wait_until_target_in_front(19.0, 45.0, calc.pass_through(6))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the monster's attack hit windows and prepares its state.
function script.init()
	monster.register_damage_hit("通常攻撃", 2.0, "攻撃１", 0.33, 0.418, 0, 2)
	monster.register_damage_hit("通常攻撃", 2.0, "攻撃１", 0.528, 0.616, 0, 2)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２", 0.0, 0.3, 1)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２", 0.0, 0.6, 1)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２", 0.0, 1.0, 1)
	monster.set_variable(0, 0)
	initialize_monster_settings()
end

--- Runs the monster's behaviour each frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
end

--- Holds the monster in its damage pose until its status ailment wears off.
function script.on_status_hit()
	local has_status_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
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
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Knocks the monster over and gets it back up.
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

--- Makes the monster guard against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(15.0)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 4)
	monster.start_knockback(1.0, 0.0, 2)
	timer.wait_frames_with_guard_update(60)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Turns to face the target and steps backwards to dodge.
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
	step_back()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Turns to face the target and sidesteps to dodge.
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
	sidestep()
	monster.set_motion("立ち", -1, 0)
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
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
	timer.wait_forever_guarded()
end

--- Gets the monster back on its feet after it lands from a throw.
function script.on_land()
	reaction.recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_guard_update(45)
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
