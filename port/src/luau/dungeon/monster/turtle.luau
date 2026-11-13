--!strict
--- Drives the turtle monsters (Turtle, Fintol, Arkerath and Bolter).

local vm = require("@lib/vm")
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

--- Keeps facing the target while the player stays transformed.
local function face_transformed_player(monster_kind: any)
	local character_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		reaction.update_and_wait_frame()
		character_id = monster.get_player_transform_id() or character_id
		if character_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(1.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Starts facing the target if the player is currently transformed.
local function face_player_if_transformed()
	local character_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	character_id = monster.get_player_transform_id() or character_id
	if character_id > -1 then
		face_transformed_player(monster_kind)
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
		distance = vm.f32(distance + 80.0)
		if roll < 50 then
			side_offset = vm.f32(-side_offset - 30.0)
		else
			side_offset = vm.f32(side_offset + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(1.2), 10.0, side_offset, distance, 20.0, 30)
		movement.turn_toward_target_and_wait_guarded(10.0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(20.0, 45.0, 30)
	end
end

--- Either stands guarding until the target is in front or wanders about.
local function guard_or_wander()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 80 then
		monster.set_motion("ガード", -1, 0)
		sense.wait_until_target_in_front(240.0, 45.0, 45)
	else
		monster.set_motion("歩き", -1, 0)
		movement.wander(vm.f32(1.2), 10.0, 30.0, 180.0, 30.0, 180.0, 30)
	end
end

--- Winds up its shell for a number of beats and then charges at the target.
local function spin_up_and_charge(wind_up_count: s32, charge_timeout_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃１in", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("攻撃１", 0)
	for i = 0, wind_up_count - 1 do
		timer.wait_frames_with_guard_update(15)
	end
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 4)
	movement.turn_toward_target_and_wait_guarded(10.0)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	movement.chase_target_guarded(vm.f32(3.0 * wind_up_count), 10.0, 20.0, charge_timeout_frames)
	if wind_up_count > 2 then
		monster.set_motion("遊び", -1, 0)
		timer.wait_frames_with_guard_update(vm.i32(wind_up_count * 15))
	end
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(3)
end

--- Either winds up and charges the target or walks after it.
local function charge_or_chase()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 65 then
		roll = monster.get_random(5) or roll
		spin_up_and_charge(vm.i32(1 + roll), 60)
		monster.set_variable(0, 1)
	else
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(vm.f32(1.2), 10.0, 20.0, 30)
	end
end

--- Rolls into the target for a duration scaled by the roll count and then recovers.
local function roll_into_target(roll_count: s32)
	monster.get_target_speed()
	monster.reset_motion()
	monster.set_motion("攻撃１in", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("攻撃１", -1, 4)
	movement.chase_target_guarded(6.0, 10.0, 20.0, vm.i32(12 * roll_count))
	monster.set_motion("攻撃１out", -1, 6)
	motion.wait_until_finished_guarded()
	if roll_count > 2 then
		monster.set_motion("遊び", -1, 0)
		timer.wait_frames_with_guard_update(vm.i32(roll_count * 15))
	end
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(3)
end

--- Chooses an action when the target is close: roll, idle or sidestep.
local function act_at_close_range()
	local roll: s32 = 0
	local variable_0: f32 = 0
	local side_offset: f32 = 0
	monster.get_life_int()
	variable_0 = monster.get_variable_float(0) or variable_0
	roll = monster.get_random(100) or roll
	if roll < 40 then
		if variable_0 == 1 then
			monster.set_motion("遊び", -1, 0)
			timer.wait_frames_with_guard_update(10)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(calc.radians_to_degrees(10.0))
			roll = monster.get_random(7) or roll
			roll_into_target(vm.i32(1 + roll))
		end
	else
		monster.get_random(100, roll)
		monster.get_random_whole_number(30.0, side_offset)
		if roll < 50 then
			side_offset = vm.f32(-side_offset - 30.0)
		else
			side_offset = vm.f32(side_offset + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		movement.walk_to_point_near_target(vm.f32(1.2), 10.0, side_offset, 40.0, 20.0, 40)
		movement.turn_toward_target_and_wait_guarded(10.0)
	end
	if variable_0 == 1 then
		monster.set_variable(0, 0)
	end
end

--- Combat loop used while rage hits remain, picking actions by target distance until the target leaves.
local function fight_with_rage_hits_left()
	local target_distance: f32 = 0
	local monster_priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		face_player_if_transformed()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 240.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left <= 0 then
			reaction.update_and_wait_frame()
			return
		end
		monster_priority = monster.get_priority() or monster_priority
		if monster_priority > 1 then
			sidestep_or_stand()
			continue
		end
		if target_distance < 240.0 and target_distance >= 180.0 then
			guard_or_wander()
		elseif target_distance < 180.0 and target_distance >= 80.0 then
			charge_or_chase()
		else
			act_at_close_range()
		end
		reaction.update_and_wait_frame()
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
	if clear_distance < 20.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, 1.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 20.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(1.0, vm.f32(1.2), turn_angle, clear_distance, 20.0, 30)
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
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, vm.f32(1.2), 1.0, place_distance, orbit_start_angle, 20.0, 60)
				orbit_end_turn_angle = monster.get_random_whole_number(180.0) or orbit_end_turn_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					orbit_end_turn_angle = vm.f32(orbit_end_turn_angle * -1.0)
				end
				movement.turn_to_angle_and_wait(orbit_end_turn_angle, 1.0)
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
	if roll < 90 then
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
			movement.turn_to_angle_and_wait(turn_angle, 1.0)
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
					threat_result = movement.walk_to_point_near_target(vm.f32(1.2), 1.0, approach_angle, approach_distance, 20.0, 60)
					final_turn_angle = monster.get_random_whole_number(360.0) or final_turn_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_angle = vm.f32(final_turn_angle * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_angle, 1.0)
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
					movement.move_in_direction_guarded(vm.f32(1.2), turn_angle, 1000.0, 20.0, 60)
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
			movement.wander(vm.f32(1.2), 1.0, place_distance, 360.0, 40.0, 20.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Turns to the target and charges at it with a long rolling attack.
local function charge_target_while_guarding()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(10.0)
	monster.set_motion("攻撃１in", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("攻撃１", -1, 4)
	movement.chase_target_checking_clearance(6.0, 10.0, 20.0, 160)
	monster.set_motion("攻撃１out", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(15)
end

--- Combat loop used once no rage hits remain, charging or rolling at the target.
local function fight_without_rage_hits_left()
	local target_distance: f32 = 0
	local monster_priority: s32 = 0
	local roll: s32 = 0
	local side_offset: f32 = 0
	while true do
		reaction.update_and_wait_frame()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 240.0 then
			reaction.update_and_wait_frame()
			return
		end
		monster_priority = monster.get_priority() or monster_priority
		if monster_priority > 2 then
			sidestep_or_stand()
			continue
		end
		if target_distance < 80.0 then
			roll = monster.get_random(100) or roll
			if roll < 70 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(calc.radians_to_degrees(10.0))
				roll = monster.get_random(7) or roll
				roll_into_target(vm.i32(1 + roll))
			else
				monster.get_random(100, roll)
				monster.get_random_whole_number(30.0, side_offset)
				if roll < 50 then
					side_offset = vm.f32(-side_offset - 30.0)
				else
					side_offset = vm.f32(side_offset + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.walk_to_point_near_target(vm.f32(1.2), 10.0, side_offset, 40.0, 20.0, 40)
				movement.turn_toward_target_and_wait_guarded(10.0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 80 then
				roll = monster.get_random(5) or roll
				spin_up_and_charge(vm.i32(1 + roll), 60)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(1.0, 45.0, 45)
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
		face_player_if_transformed()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 240.0 then
				fight_with_rage_hits_left()
			else
				wander_near_spawn()
			end
		else
			guard_release_distance = state.get_secondary_float(guard_release_distance)
			if target_distance < guard_release_distance then
				if target_distance < 80.0 then
					reaction.set_guard_active(0)
					fight_with_rage_hits_left()
				else
					charge_target_while_guarding()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage_hits_left()
	end
end

local script = {}

--- Runs when the script is loaded.
function script.setup() end

--- Registers the turtle's hit reactions and sets its guard and clip distances.
function script.init()
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "攻撃１", 0.0, 0.5, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "攻撃１", 0.0, 1.0, 0)
	monster.set_variable(0, 0)
	configure_guard_and_clip_distance()
end

--- Updates the turtle's behaviour every frame.
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
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Gets knocked down and stands back up.
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

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default dodge.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default dodge.
function script.on_dodge_2() end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished_guarded()
	death.play_effects()
end

--- Struggles while held.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
	timer.wait_forever_guarded()
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
	monster.set_motion("立ち", -1, 0)
end

return script
